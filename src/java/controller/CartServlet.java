package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.ProductDAO;
import dal.CartDAO;
import dal.VoucherDAO;
import model.CartItem;
import model.Users;

/*
 * Name: CartServlet
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Servlet quản lý và xử lý các thao tác với giỏ hàng (Cart) của người dùng
 */
@WebServlet(name = "CartServlet", urlPatterns = { "/CartServlet" })
public class CartServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            session.setAttribute("cart", cartDAO.getCart(user.getUserId()));
        }
        List<CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart)
            total = total.add(it.getSubtotal());

        // Recalculate discount based on current cart state
        String activeCoupon = (String) session.getAttribute("couponCode");
        if (activeCoupon != null) {
            recalculateDiscount(session, cart, activeCoupon);
        }

        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null)
            discountAmount = BigDecimal.ZERO;
        BigDecimal finalTotal = total.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0)
            finalTotal = BigDecimal.ZERO;

        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("couponCode", activeCoupon);
        request.setAttribute("couponMessage", session.getAttribute("couponMessage"));
        request.setAttribute("couponSuccess", session.getAttribute("couponSuccess"));

        // Clear temporary messages to avoid display on refresh
        session.removeAttribute("couponMessage");
        session.removeAttribute("couponSuccess");

        request.getRequestDispatcher("customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "add";
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        Users user = (Users) session.getAttribute("user");

        switch (action) {
            case "add" -> addToCart(request, cart, user);
            case "update" -> updateQty(request, cart, user);
            case "remove" -> removeItem(request, cart, user);
            case "coupon" -> applyCoupon(request);
        }

        // Recalculate discount automatically on cart changes
        String activeCoupon = (String) session.getAttribute("couponCode");
        if (activeCoupon != null) {
            recalculateDiscount(session, cart, activeCoupon);
        }

        if ("true".equals(request.getParameter("ajax"))) {
            response.setContentType("application/json;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();

            BigDecimal total = BigDecimal.ZERO;
            for (CartItem it : cart)
                total = total.add(it.getSubtotal());

            BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
            if (discount == null)
                discount = BigDecimal.ZERO;
            BigDecimal finalTotal = total.subtract(discount);
            if (finalTotal.compareTo(BigDecimal.ZERO) < 0)
                finalTotal = BigDecimal.ZERO;

            int totalItems = 0;
            for (CartItem it : cart)
                totalItems += it.getQuantity();

            // Find details for current item
            BigDecimal itemSubtotal = BigDecimal.ZERO;
            int currentQty = 0;
            int availableQty = 0;
            int variantId = parseInt(request.getParameter("variantId"), 0);
            for (CartItem it : cart) {
                if (it.getVariantId() == variantId) {
                    itemSubtotal = it.getSubtotal();
                    currentQty = it.getQuantity();
                    availableQty = it.getAvailableQuantity();
                    break;
                }
            }

            String couponMessage = (String) session.getAttribute("couponMessage");
            if (couponMessage == null)
                couponMessage = "";
            Boolean couponSuccess = (Boolean) session.getAttribute("couponSuccess");
            if (couponSuccess == null)
                couponSuccess = false;

            out.print("{"
                    + "\"success\": true,"
                    + "\"cartSize\": " + cart.size() + ","
                    + "\"totalItems\": " + totalItems + ","
                    + "\"itemSubtotal\": \"" + String.format("%,.0f", itemSubtotal) + "\","
                    + "\"currentQty\": " + currentQty + ","
                    + "\"availableQty\": " + availableQty + ","
                    + "\"total\": \"" + String.format("%,.0f", total) + "\","
                    + "\"discount\": \"" + String.format("%,.0f", discount) + "\","
                    + "\"finalTotal\": \"" + String.format("%,.0f", finalTotal) + "\","
                    + "\"couponSuccess\": " + couponSuccess + ","
                    + "\"couponMessage\": \"" + couponMessage + "\","
                    + "\"message\": \"" + couponMessage + "\","
                    + "\"successCoupon\": " + couponSuccess
                    + "}");
            return;
        }

        response.sendRedirect("CartServlet"); // redirect to prevent resubmission on refresh
    }

    private void addToCart(HttpServletRequest request, List<CartItem> cart, Users user) {
        int variantId = parseInt(request.getParameter("variantId"), 0);
        int qty = parseInt(request.getParameter("quantity"), 1);
        if (variantId == 0)
            return;
        if (qty < 1)
            qty = 1;

        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.addToCart(user.getUserId(), variantId, qty);
            cart.clear();
            cart.addAll(cartDAO.getCart(user.getUserId()));
        } else {
            for (CartItem it : cart) { // if exists, add quantity and cap at stock
                if (it.getVariantId() == variantId) {
                    it.setQuantity(Math.min(it.getQuantity() + qty, it.getAvailableQuantity()));
                    return;
                }
            }
            CartItem item = new ProductDAO().getCartItemByVariantId(variantId);
            if (item != null) {
                item.setQuantity(Math.min(qty, item.getAvailableQuantity()));
                cart.add(item);
            }
        }
    }

    private void updateQty(HttpServletRequest request, List<CartItem> cart, Users user) {
        int variantId = parseInt(request.getParameter("variantId"), 0);
        int qty = parseInt(request.getParameter("quantity"), 1);

        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.updateQuantity(user.getUserId(), variantId, qty);
            cart.clear();
            cart.addAll(cartDAO.getCart(user.getUserId()));
        } else {
            for (CartItem it : cart) {
                if (it.getVariantId() == variantId) {
                    if (qty < 1)
                        qty = 1;
                    if (qty > it.getAvailableQuantity())
                        qty = it.getAvailableQuantity();
                    it.setQuantity(qty);
                    return;
                }
            }
        }
    }

    private void removeItem(HttpServletRequest request, List<CartItem> cart, Users user) {
        int variantId = parseInt(request.getParameter("variantId"), 0);
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.removeItem(user.getUserId(), variantId);
            cart.clear();
            cart.addAll(cartDAO.getCart(user.getUserId()));
        } else {
            cart.removeIf(it -> it.getVariantId() == variantId);
        }
    }

    private void applyCoupon(HttpServletRequest request) {
        String code = request.getParameter("couponCode");
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart)
            total = total.add(it.getSubtotal());

        BigDecimal discount = BigDecimal.ZERO;
        String message = "";
        boolean success = false;
        Integer couponId = null;
        Boolean isCampaign = false;

        if (code != null && !code.trim().isEmpty()) {
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherDAO.VoucherInfo info = voucherDAO.getVoucher(code, total);
            message = info.message;
            success = info.isValid;
            if (success) {
                if ("percentage".equalsIgnoreCase(info.type)) {
                    discount = total.multiply(info.discountValue).divide(new BigDecimal("100"));
                } else {
                    discount = info.discountValue;
                }
                couponId = info.id;
                isCampaign = info.isCampaign;
            }
        } else {
            message = "Vui lòng nhập mã giảm giá.";
        }

        if (success) {
            session.setAttribute("couponCode", code.trim().toUpperCase());
            session.setAttribute("discountAmount", discount);
            session.setAttribute("couponId", couponId);
            session.setAttribute("isCampaign", isCampaign);
        } else {
            session.removeAttribute("couponCode");
            session.removeAttribute("discountAmount");
            session.removeAttribute("couponId");
            session.removeAttribute("isCampaign");
        }

        session.setAttribute("couponMessage", message);
        session.setAttribute("couponSuccess", success);
    }

    private void recalculateDiscount(HttpSession session, List<CartItem> cart, String code) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart)
            total = total.add(it.getSubtotal());
        BigDecimal discount = BigDecimal.ZERO;
        if (code != null && !code.trim().isEmpty()) {
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherDAO.VoucherInfo info = voucherDAO.getVoucher(code, total);
            if (info.isValid) {
                if ("percentage".equalsIgnoreCase(info.type)) {
                    discount = total.multiply(info.discountValue).divide(new BigDecimal("100"));
                } else {
                    discount = info.discountValue;
                }
                session.setAttribute("discountAmount", discount);
                session.setAttribute("couponId", info.id);
                session.setAttribute("isCampaign", info.isCampaign);
            } else {
                session.removeAttribute("couponCode");
                session.removeAttribute("discountAmount");
                session.removeAttribute("couponId");
                session.removeAttribute("isCampaign");
            }
        }
    }
}
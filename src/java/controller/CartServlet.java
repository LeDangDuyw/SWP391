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
import model.UserVoucherDTO;

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

        // Lấy danh sách voucher cá nhân hóa (hoặc voucher dùng chung nếu chưa đăng nhập)
        List<UserVoucherDTO> userVouchers = new ArrayList<>();
        int userId = (user != null) ? user.getUserId() : 0;
        VoucherDAO voucherDAO = new VoucherDAO();
        List<UserVoucherDTO> rawVouchers = voucherDAO.getUserVouchers(userId);
        
        System.out.println("=== DEBUG CART SERVLET ===");
        System.out.println("User ID: " + userId + ", Cart Total: " + total + ", Cart Size: " + cart.size());
        System.out.println("Raw Vouchers retrieved count: " + (rawVouchers != null ? rawVouchers.size() : "null"));
        if (rawVouchers != null) {
            for (UserVoucherDTO v : rawVouchers) {
                System.out.println("Voucher: Code = " + v.getVoucherCode() + ", Discount = " + v.getDiscountValue() + ", MinOrder = " + v.getMinOrderValue() + ", Used = " + v.isUsed());
            }
        }
        System.out.println("==========================");
        
        // Tính toán động trạng thái khả dụng cho từng voucher
        for (UserVoucherDTO v : rawVouchers) {
            BigDecimal minVal = v.getMinOrderValue();
            if (minVal == null) minVal = BigDecimal.ZERO;
            
            if (v.isUsed()) {
                v.setAvailable(false);
                v.setDiscountAmountActual(BigDecimal.ZERO);
                v.setMissingAmount(BigDecimal.ZERO);
                v.setStatusMessage("Bạn đã sử dụng mã giảm giá này");
            } else if (total.compareTo(minVal) >= 0) {
                v.setAvailable(true);
                BigDecimal actualDiscount = voucherDAO.calculateActualDiscount(
                    v.getVoucherId(),
                    (v.getDiscountValue().compareTo(new BigDecimal("100")) <= 0 ? "percentage" : "fixed"),
                    v.getDiscountValue(),
                    cart
                );
                v.setDiscountAmountActual(actualDiscount);
                v.setMissingAmount(BigDecimal.ZERO);
                v.setStatusMessage("Đủ điều kiện áp dụng");
            } else {
                v.setAvailable(false);
                v.setDiscountAmountActual(BigDecimal.ZERO);
                BigDecimal missing = minVal.subtract(total);
                v.setMissingAmount(missing);
                v.setStatusMessage("Chưa đủ điều kiện nhận khuyến mãi (Cần mua thêm " + String.format("%,.0f", missing) + "₫)");
            }
            userVouchers.add(v);
        }
        
        // TỰ ĐỘNG ÁP DỤNG VOUCHER TỐT NHẤT nếu chưa có voucher nào đang hoạt động
        if (session.getAttribute("couponCode") == null) {
            UserVoucherDTO bestVoucher = voucherDAO.getBestVoucherForOrder(userId, total, cart);
            if (bestVoucher != null) {
                session.setAttribute("couponCode", bestVoucher.getVoucherCode());
                session.setAttribute("discountAmount", bestVoucher.getDiscountAmountActual());
                session.setAttribute("couponId", bestVoucher.getVoucherId());
                session.setAttribute("isCampaign", true);
                session.setAttribute("couponSuccess", true);
                session.setAttribute("couponMessage", "Hệ thống đã tự động chọn mã giảm giá tốt nhất cho bạn!");
            }
        }
        request.setAttribute("userVouchers", userVouchers);

        // Recalculate discount based on current cart state (nếu có mã được gán trong session)
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
        request.setAttribute("userVouchers", userVouchers);

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

        // Tải lại thông tin giỏ hàng và tính tổng tiền mới
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart) total = total.add(it.getSubtotal());

        // Tính toán lại danh sách voucher cá nhân hoá dựa trên tổng tiền mới
        List<UserVoucherDTO> userVouchers = new ArrayList<>();
        if (user != null) {
            VoucherDAO voucherDAO = new VoucherDAO();
            List<UserVoucherDTO> rawVouchers = voucherDAO.getUserVouchers(user.getUserId());
            for (UserVoucherDTO v : rawVouchers) {
                BigDecimal minVal = v.getMinOrderValue();
                if (minVal == null) minVal = BigDecimal.ZERO;
                
                if (v.isUsed()) {
                    v.setAvailable(false);
                    v.setDiscountAmountActual(BigDecimal.ZERO);
                    v.setMissingAmount(BigDecimal.ZERO);
                    v.setStatusMessage("Bạn đã sử dụng mã giảm giá này");
                } else if (total.compareTo(minVal) >= 0) {
                    v.setAvailable(true);
                    BigDecimal discVal = v.getDiscountValue();
                    if (discVal == null) discVal = BigDecimal.ZERO;
                    BigDecimal actualDiscount = BigDecimal.ZERO;
                    if (discVal.compareTo(new BigDecimal("100")) <= 0) {
                        actualDiscount = total.multiply(discVal).divide(new BigDecimal("100"));
                    } else {
                        actualDiscount = discVal;
                    }
                    if (actualDiscount.compareTo(total) > 0) actualDiscount = total;
                    v.setDiscountAmountActual(actualDiscount);
                    v.setMissingAmount(BigDecimal.ZERO);
                    v.setStatusMessage("Đủ điều kiện áp dụng");
                } else {
                    v.setAvailable(false);
                    v.setDiscountAmountActual(BigDecimal.ZERO);
                    BigDecimal missing = minVal.subtract(total);
                    v.setMissingAmount(missing);
                    v.setStatusMessage("Chưa đủ điều kiện nhận khuyến mãi (Cần mua thêm " + String.format("%,.0f", missing) + "₫)");
                }
                userVouchers.add(v);
            }

            // Nếu chưa áp dụng mã nào hoặc mã hiện tại bị mất hiệu lực do giảm số lượng sản phẩm, tự chọn mã tốt nhất
            String activeCoupon = (String) session.getAttribute("couponCode");
            boolean currentCouponValid = false;
            int currentUserId = (user != null) ? user.getUserId() : 0;
            voucherDAO = new VoucherDAO();
            if (activeCoupon != null) {
                VoucherDAO.VoucherInfo info = (user != null) 
                    ? voucherDAO.getVoucher(activeCoupon, total, user.getUserId())
                    : voucherDAO.getVoucher(activeCoupon, total);
                currentCouponValid = info.isValid;
            }

            if (!currentCouponValid) {
                // Mã cũ không còn hiệu lực hoặc chưa chọn mã nào, tự động chọn mã tốt nhất
                UserVoucherDTO bestVoucher = voucherDAO.getBestVoucherForOrder(currentUserId, total, cart);
                if (bestVoucher != null) {
                    session.setAttribute("couponCode", bestVoucher.getVoucherCode());
                    session.setAttribute("discountAmount", bestVoucher.getDiscountAmountActual());
                    session.setAttribute("couponId", bestVoucher.getVoucherId());
                    session.setAttribute("isCampaign", true);
                    session.setAttribute("couponSuccess", true);
                    session.setAttribute("couponMessage", "Đã tự động đổi sang mã giảm giá tốt nhất phù hợp!");
                } else {
                    session.removeAttribute("couponCode");
                    session.removeAttribute("discountAmount");
                    session.removeAttribute("couponId");
                    session.removeAttribute("isCampaign");
                }
            } else {
                // Tính lại mức giảm của mã hiện tại (vì số lượng sản phẩm thay đổi làm tổng tiền thay đổi)
                recalculateDiscount(session, cart, activeCoupon);
            }
        } else {
            // Trường hợp khách vãng lai (chưa đăng nhập) - Đồng bộ tính năng tự chọn voucher tốt nhất
            String activeCoupon = (String) session.getAttribute("couponCode");
            boolean currentCouponValid = false;
            VoucherDAO voucherDAO = new VoucherDAO();
            if (activeCoupon != null) {
                VoucherDAO.VoucherInfo info = voucherDAO.getVoucher(activeCoupon, total);
                currentCouponValid = info.isValid;
            }

            if (!currentCouponValid) {
                UserVoucherDTO bestVoucher = voucherDAO.getBestVoucherForOrder(0, total, cart);
                if (bestVoucher != null) {
                    session.setAttribute("couponCode", bestVoucher.getVoucherCode());
                    session.setAttribute("discountAmount", bestVoucher.getDiscountAmountActual());
                    session.setAttribute("couponId", bestVoucher.getVoucherId());
                    session.setAttribute("isCampaign", true);
                    session.setAttribute("couponSuccess", true);
                    session.setAttribute("couponMessage", "Đã tự động đổi sang mã giảm giá tốt nhất phù hợp!");
                } else {
                    session.removeAttribute("couponCode");
                    session.removeAttribute("discountAmount");
                    session.removeAttribute("couponId");
                    session.removeAttribute("isCampaign");
                }
            } else {
                recalculateDiscount(session, cart, activeCoupon);
            }
        }

        if ("true".equals(request.getParameter("ajax"))) {
            response.setContentType("application/json;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();

            BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
            if (discount == null)
                discount = BigDecimal.ZERO;
            BigDecimal finalTotal = total.subtract(discount);
            if (finalTotal.compareTo(BigDecimal.ZERO) < 0)
                finalTotal = BigDecimal.ZERO;

            int totalItems = 0;
            for (CartItem it : cart)
                totalItems += it.getQuantity();

            // Lấy thông tin của sản phẩm vừa cập nhật
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

            // Xây dựng JSON danh sách voucher cá nhân
            StringBuilder vouchersJson = new StringBuilder("[");
            for (int i = 0; i < userVouchers.size(); i++) {
                UserVoucherDTO v = userVouchers.get(i);
                vouchersJson.append("{")
                    .append("\"voucherId\":").append(v.getVoucherId()).append(",")
                    .append("\"voucherCode\":\"").append(v.getVoucherCode()).append("\",")
                    .append("\"discountValue\":").append(v.getDiscountValue()).append(",")
                    .append("\"minOrderValue\":").append(v.getMinOrderValue()).append(",")
                    .append("\"isAvailable\":").append(v.isAvailable()).append(",")
                    .append("\"isUsed\":").append(v.isUsed()).append(",")
                    .append("\"discountAmountActual\":\"").append(String.format("%,.0f", v.getDiscountAmountActual())).append("\",")
                    .append("\"missingAmount\":\"").append(String.format("%,.0f", v.getMissingAmount())).append("\",")
                    .append("\"statusMessage\":\"").append(v.getStatusMessage()).append("\"")
                    .append("}");
                if (i < userVouchers.size() - 1) {
                    vouchersJson.append(",");
                }
            }
            vouchersJson.append("]");

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
                + "\"couponCode\": \"" + (session.getAttribute("couponCode") != null ? session.getAttribute("couponCode") : "") + "\","
                + "\"userVouchers\": " + vouchersJson.toString()
                + "}");
            return;
        }

        response.sendRedirect("CartServlet");
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
        Users user = (Users) session.getAttribute("user");
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
            VoucherDAO.VoucherInfo info;
            if (user != null) {
                info = voucherDAO.getVoucher(code, total, user.getUserId());
            } else {
                info = voucherDAO.getVoucher(code, total);
            }
            message = info.message;
            success = info.isValid;
            if (success) {
                discount = voucherDAO.calculateActualDiscount(info.id, info.type, info.discountValue, cart);
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
        Users user = (Users) session.getAttribute("user");
        if (code != null && !code.trim().isEmpty()) {
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherDAO.VoucherInfo info;
            if (user != null) {
                info = voucherDAO.getVoucher(code, total, user.getUserId());
            } else {
                info = voucherDAO.getVoucher(code, total);
            }
            if (info.isValid) {
                discount = voucherDAO.calculateActualDiscount(info.id, info.type, info.discountValue, cart);
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
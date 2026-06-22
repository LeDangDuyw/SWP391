package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.CategoryDAO;
import model.CartItem;

public class CheckoutServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        return (List<CartItem>) session.getAttribute("cart");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());

        if ("success".equals(action)) {
            String orderId = request.getParameter("orderCode");
            if (orderId == null) {
                orderId = request.getParameter("orderId");
            }
            String paymentMethod = request.getParameter("paymentMethod");
            String totalStr = request.getParameter("total");
            request.setAttribute("orderId", orderId);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("total", totalStr);
            request.getRequestDispatcher("customer/order_success.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<CartItem> cart = getCart(session);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }

        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null) {
            discountAmount = BigDecimal.ZERO;
        }

        BigDecimal finalTotal = total.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", finalTotal);

        request.getRequestDispatcher("customer/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<CartItem> cart = getCart(session);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        // Retrieve shipping details
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");

        // Calculate totals
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }
        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null) discountAmount = BigDecimal.ZERO;
        BigDecimal finalTotal = total.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) finalTotal = BigDecimal.ZERO;

        // Try extracting user_id dynamically from session "user" using reflection to avoid compile dependency issues
        Integer userId = null;
        if (userObj != null) {
            try {
                java.lang.reflect.Method getUserIdMethod = userObj.getClass().getMethod("getUserId");
                userId = (Integer) getUserIdMethod.invoke(userObj);
            } catch (Exception e1) {
                try {
                    java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
                    userId = (Integer) getIdMethod.invoke(userObj);
                } catch (Exception e2) {
                    try {
                        java.lang.reflect.Field field = userObj.getClass().getDeclaredField("userId");
                        field.setAccessible(true);
                        userId = (Integer) field.get(userObj);
                    } catch (Exception e3) {
                        // ignore
                    }
                }
            }
        }

        // Insert Order and OrderDetails into Database
        dal.OrderDAO orderDAO = new dal.OrderDAO();
        model.Order dbOrder = orderDAO.insertOrder(finalTotal, fullName, phone, address, userId);
        String orderCode = (dbOrder != null) ? dbOrder.getOrderCode() : ("UNILAP-" + (100000 + new java.util.Random().nextInt(900000)));

        if (dbOrder != null) {
            for (CartItem item : cart) {
                orderDAO.insertOrderDetail(dbOrder.getOrderId(), item.getVariantId(), item.getQuantity(), item.getUnitPrice());
            }
        }

        // Simulation logs
        System.out.println("=== ORDER CREATION ===");
        System.out.println("Order Code: " + orderCode);
        System.out.println("Customer: " + fullName + " (" + phone + ")");
        System.out.println("Payment Method: " + paymentMethod);
        System.out.println("Final Total: " + finalTotal + "₫");
        System.out.println("======================");

        // Clear Cart and Discount Info from Session
        session.removeAttribute("cart");
        session.removeAttribute("couponCode");
        session.removeAttribute("discountAmount");
        session.removeAttribute("couponMessage");
        session.removeAttribute("couponSuccess");

        // Redirect to success page
        response.sendRedirect(request.getContextPath() + "/CheckoutServlet?action=success&orderCode=" + orderCode + "&paymentMethod=" + paymentMethod + "&total=" + finalTotal);
    }
}

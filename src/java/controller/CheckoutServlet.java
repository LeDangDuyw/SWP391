package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.CategoryDAO;
import model.CartItem;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/CheckoutServlet"})
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
            
            try {
                dal.OrderDAO orderDAO = new dal.OrderDAO();
                model.Order orderObj = orderDAO.getOrderByCode(orderId);
                if (orderObj != null) {
                    request.setAttribute("shippingFee", orderObj.getShippingFee());
                } else {
                    request.setAttribute("shippingFee", BigDecimal.ZERO);
                }
            } catch (Exception ex) {
                request.setAttribute("shippingFee", BigDecimal.ZERO);
            }
            
            request.getRequestDispatcher("customer/order_success.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            // Lưu lại URL để sau khi đăng nhập redirect về checkout
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/CheckoutServlet");
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

        // Calculate shipping fee on first load:
        // Default shippingMethod is HOME_DELIVERY. We set it to 30,000 VND as a starting default.
        BigDecimal shippingFee = new BigDecimal("30000");

        BigDecimal finalTotal = total.subtract(discountAmount).add(shippingFee);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("finalTotal", finalTotal);

        request.getRequestDispatcher("customer/checkout.jsp").forward(request, response);
    }

    private BigDecimal getViettelPostShippingFee(String provinceId, String districtId, BigDecimal totalAmount) {
        if (provinceId == null || districtId == null || provinceId.trim().isEmpty() || districtId.trim().isEmpty()) {
            return new BigDecimal("30000");
        }
        try {
            java.net.URL url = new java.net.URL("https://partner.viettelpost.vn/v2/order/getPriceAll");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            long total = totalAmount.longValue();

            String jsonInputString = "{" +
                    "\"PRODUCT_WEIGHT\": 2000," +
                    "\"PRODUCT_PRICE\": " + total + "," +
                    "\"MONEY_COLLECTION\": 0," +
                    "\"SENDER_PROVINCE\": 1," +
                    "\"SENDER_DISTRICT\": 25," +
                    "\"RECEIVER_PROVINCE\": " + provinceId.trim() + "," +
                    "\"RECEIVER_DISTRICT\": " + districtId.trim() + "," +
                    "\"PRODUCT_TYPE\": \"HH\"," +
                    "\"TYPE_LOOP\": 1" +
                    "}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    StringBuilder response = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    String resp = response.toString();
                    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\"GIA_CUOC\"\\s*:\\s*(\\d+)");
                    java.util.regex.Matcher matcher = pattern.matcher(resp);
                    if (matcher.find()) {
                        return new BigDecimal(matcher.group(1));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error calling Viettel Post getPriceAll API: " + e.getMessage());
        }
        return new BigDecimal("30000"); // default fallback fee
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
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");
        String shippingMethod = request.getParameter("shippingMethod");

        String address = "";
        BigDecimal shippingFee = BigDecimal.ZERO;

        // Calculate totals
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }
        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null) discountAmount = BigDecimal.ZERO;

        if ("STORE_PICKUP".equals(shippingMethod)) {
            address = "Nhận tại cửa hàng UniLap - Mỹ Đình, Hà Nội";
            shippingFee = BigDecimal.ZERO;
        } else {
            // Home delivery
            String provinceId = request.getParameter("provinceId");
            String districtId = request.getParameter("districtId");
            String wardId = request.getParameter("wardId");
            String provinceName = request.getParameter("provinceName");
            String districtName = request.getParameter("districtName");
            String wardName = request.getParameter("wardName");
            String detailedAddress = request.getParameter("detailedAddress");

            address = detailedAddress + ", " + wardName + ", " + districtName + ", " + provinceName;

            // Fetch dynamic shipping fee from Viettel Post API
            shippingFee = getViettelPostShippingFee(provinceId, districtId, total);
        }

        BigDecimal finalTotal = total.subtract(discountAmount).add(shippingFee);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) finalTotal = BigDecimal.ZERO;

        // Validate phone number (10 digits starting with 0)
        if (phone == null || !phone.matches("^0[0-9]{9}$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ. Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0!");
            request.setAttribute("cart", cart);
            request.setAttribute("total", total);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("finalTotal", finalTotal);
            request.getRequestDispatcher("customer/checkout.jsp").forward(request, response);
            return;
        }

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

        // Retrieve coupon info from session
        Integer couponId = (Integer) session.getAttribute("couponId");
        Boolean isCampaignObj = (Boolean) session.getAttribute("isCampaign");
        boolean isCampaign = (isCampaignObj != null) ? isCampaignObj : false;

        // Insert Order and OrderDetails into Database
        dal.OrderDAO orderDAO = new dal.OrderDAO();
        model.Order dbOrder = orderDAO.insertOrder(finalTotal, shippingFee, fullName, phone, address, userId, couponId);

        if (dbOrder == null) {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi tạo đơn hàng (có thể do tổng tiền vượt quá giới hạn hoặc lỗi kết nối). Vui lòng thử lại hoặc giảm bớt số lượng!");
            request.setAttribute("cart", cart);
            request.setAttribute("total", total);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("finalTotal", finalTotal);
            request.getRequestDispatcher("customer/checkout.jsp").forward(request, response);
            return;
        }

        String orderCode = dbOrder.getOrderCode();
        for (CartItem item : cart) {
            orderDAO.insertOrderDetail(dbOrder.getOrderId(), item.getVariantId(), item.getQuantity(), item.getUnitPrice());
        }
        
        // Increment campaign used count or update personalized user voucher status
        if (couponId != null) {
            if (isCampaign) {
                new dal.VoucherDAO().incrementUsedCount(couponId, true);
            } else if (userId != null) {
                new dal.VoucherDAO().useUserVoucher(userId, couponId);
            }
        }
        
        // Clear cart in Database if logged in
        if (userId != null) {
            new dal.CartDAO().clearCart(userId);
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
        session.removeAttribute("couponId");
        session.removeAttribute("isCampaign");

        // Redirect to success page
        response.sendRedirect(request.getContextPath() + "/CheckoutServlet?action=success&orderCode=" + orderCode + "&paymentMethod=" + paymentMethod + "&total=" + finalTotal);
    }
}

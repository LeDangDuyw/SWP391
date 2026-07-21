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
        // Lấy giỏ hàng từ Session, nếu chưa tồn tại thì khởi tạo giỏ hàng mới
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private int parseInt(String s, int def) {
        // Chuyển đổi chuỗi sang số nguyên an toàn, trả về giá trị mặc định def nếu có lỗi
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
        
        // Nếu người dùng đã đăng nhập, đồng bộ giỏ hàng từ database vào Session
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            session.setAttribute("cart", cartDAO.getCart(user.getUserId()));
        }
        
        List<CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        // Tính tổng giá trị giỏ hàng (chưa giảm giá)
        for (CartItem it : cart) {
            total = total.add(it.getSubtotal());
        }

        // Tải danh sách các voucher cá nhân hóa dựa trên trạng thái đăng nhập
        List<UserVoucherDTO> userVouchers = new ArrayList<>();
        int userId = (user != null) ? user.getUserId() : 0;
        VoucherDAO voucherDAO = new VoucherDAO();
        List<UserVoucherDTO> rawVouchers = voucherDAO.getUserVouchers(userId);
        
        // Duyệt qua và tính toán xem voucher nào đủ điều kiện áp dụng cho tổng tiền hiện tại
        if (rawVouchers != null) {
            for (UserVoucherDTO v : rawVouchers) {
                BigDecimal minVal = v.getMinOrderValue();
                if (minVal == null) minVal = BigDecimal.ZERO;
                
                if (v.isUsed()) {
                    v.setAvailable(false);
                    v.setDiscountAmountActual(BigDecimal.ZERO);
                    v.setMissingAmount(BigDecimal.ZERO);
                    v.setStatusMessage("Bạn đã sử dụng mã giảm giá này");
                } else if (total.compareTo(minVal) >= 0) {
                    BigDecimal actualDiscount = voucherDAO.calculateActualDiscount(
                        v.getVoucherId(),
                        (v.getDiscountValue().compareTo(new BigDecimal("100")) <= 0 ? "percentage" : "fixed"),
                        v.getDiscountValue(),
                        cart
                    );
                    if (actualDiscount.compareTo(BigDecimal.ZERO) > 0) {
                        v.setAvailable(true);
                        v.setDiscountAmountActual(actualDiscount);
                        v.setMissingAmount(BigDecimal.ZERO);
                        v.setStatusMessage("Đủ điều kiện áp dụng");
                    } else {
                        v.setAvailable(false);
                        v.setDiscountAmountActual(BigDecimal.ZERO);
                        v.setMissingAmount(BigDecimal.ZERO);
                        v.setStatusMessage("Không đủ điều kiện áp dụng");
                    }
                } else {
                    v.setAvailable(false);
                    v.setDiscountAmountActual(BigDecimal.ZERO);
                    BigDecimal missing = minVal.subtract(total);
                    v.setMissingAmount(missing);
                    v.setStatusMessage("Chưa đủ điều kiện nhận khuyến mãi (Cần mua thêm " + String.format("%,.0f", missing) + "₫)");
                }
                userVouchers.add(v);
            }
        }
        
        // Tái áp dụng voucher mà người dùng đã chọn chủ động
        Boolean isUserSelected = (Boolean) session.getAttribute("isUserSelected");
        String activeCoupon = (String) session.getAttribute("couponCode");
        
        if (isUserSelected != null && isUserSelected && activeCoupon != null) {
            recalculateDiscount(session, cart, activeCoupon);
            BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
            if (discount == null || discount.compareTo(BigDecimal.ZERO) <= 0) {
                session.removeAttribute("couponCode");
                session.removeAttribute("discountAmount");
                session.removeAttribute("couponId");
                session.removeAttribute("isCampaign");
                session.removeAttribute("isUserSelected");
                activeCoupon = null;
            }
        }

        // Tự động tìm và áp dụng voucher tối ưu nhất nếu người dùng chưa chọn mã nào cụ thể
        if (session.getAttribute("isUserSelected") == null || !((Boolean)session.getAttribute("isUserSelected"))) {
            UserVoucherDTO bestVoucher = voucherDAO.getBestVoucherForOrder(userId, total, cart);
            if (bestVoucher != null) {
                session.setAttribute("couponCode", bestVoucher.getVoucherCode());
                session.setAttribute("discountAmount", bestVoucher.getDiscountAmountActual());
                session.setAttribute("couponId", bestVoucher.getVoucherId());
                session.setAttribute("isCampaign", true);
                session.setAttribute("couponSuccess", true);
                if (activeCoupon == null || !activeCoupon.equalsIgnoreCase(bestVoucher.getVoucherCode())) {
                    session.setAttribute("couponMessage", "Hệ thống đã tự động chọn mã giảm giá tốt nhất cho bạn!");
                }
            } else {
                session.removeAttribute("couponCode");
                session.removeAttribute("discountAmount");
                session.removeAttribute("couponId");
                session.removeAttribute("isCampaign");
            }
        }

        // Sắp xếp danh sách voucher cá nhân: Ưu tiên mã khả dụng lên trước
        userVouchers.sort((v1, v2) -> {
            boolean active1 = v1.isAvailable() && !v1.isUsed();
            boolean active2 = v2.isAvailable() && !v2.isUsed();
            if (active1 && !active2) return -1;
            if (!active1 && active2) return 1;
            BigDecimal d1 = v1.getDiscountValue() != null ? v1.getDiscountValue() : BigDecimal.ZERO;
            BigDecimal d2 = v2.getDiscountValue() != null ? v2.getDiscountValue() : BigDecimal.ZERO;
            return d2.compareTo(d1);
        });
        request.setAttribute("userVouchers", userVouchers);

        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null) {
            discountAmount = BigDecimal.ZERO;
        }
        BigDecimal finalTotal = total.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO;
        }

        // Đưa các thông tin giỏ hàng, tổng tiền, chiết khấu lên request
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("couponCode", activeCoupon);
        request.setAttribute("couponMessage", session.getAttribute("couponMessage"));
        request.setAttribute("couponSuccess", session.getAttribute("couponSuccess"));
        request.setAttribute("userVouchers", userVouchers);

        // Xóa thông điệp tạm thời để tránh lặp lại khi tải lại trang
        session.removeAttribute("couponMessage");
        session.removeAttribute("couponSuccess");

        request.getRequestDispatcher("customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        Users user = (Users) session.getAttribute("user");

        // Gọi hàm xử lý tương ứng với các tác vụ giỏ hàng (thêm, sửa số lượng, xóa sản phẩm, áp mã)
        switch (action) {
            case "add" -> addToCart(request, cart, user);
            case "update" -> updateQty(request, cart, user);
            case "remove" -> removeItem(request, cart, user);
            case "coupon" -> applyCoupon(request);
        }

        // Tính toán lại tổng tiền giỏ hàng sau khi cập nhật dữ liệu
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart) {
            total = total.add(it.getSubtotal());
        }

        // Tính toán và định dạng lại danh sách các mã giảm giá cho người dùng đăng nhập
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
                    BigDecimal discVal = v.getDiscountValue();
                    if (discVal == null) discVal = BigDecimal.ZERO;
                    String vType = (discVal.compareTo(new BigDecimal("100")) <= 0) ? "percentage" : "fixed";
                    BigDecimal actualDiscount = voucherDAO.calculateActualDiscount(v.getVoucherId(), vType, discVal, cart);
                    if (actualDiscount.compareTo(BigDecimal.ZERO) > 0) {
                        v.setAvailable(true);
                        v.setDiscountAmountActual(actualDiscount);
                        v.setMissingAmount(BigDecimal.ZERO);
                        v.setStatusMessage("Đủ điều kiện áp dụng");
                    } else {
                        v.setAvailable(false);
                        v.setDiscountAmountActual(BigDecimal.ZERO);
                        v.setMissingAmount(BigDecimal.ZERO);
                        v.setStatusMessage("Không đủ điều kiện áp dụng");
                    }
                } else {
                    v.setAvailable(false);
                    v.setDiscountAmountActual(BigDecimal.ZERO);
                    BigDecimal missing = minVal.subtract(total);
                    v.setMissingAmount(missing);
                    v.setStatusMessage("Chưa đủ điều kiện nhận khuyến mãi (Cần mua thêm " + String.format("%,.0f", missing) + "₫)");
                }
                userVouchers.add(v);
            }
            
            // Sắp xếp lại voucher
            userVouchers.sort((v1, v2) -> {
                boolean active1 = v1.isAvailable() && !v1.isUsed();
                boolean active2 = v2.isAvailable() && !v2.isUsed();
                if (active1 && !active2) return -1;
                if (!active1 && active2) return 1;
                BigDecimal d1 = v1.getDiscountValue() != null ? v1.getDiscountValue() : BigDecimal.ZERO;
                BigDecimal d2 = v2.getDiscountValue() != null ? v2.getDiscountValue() : BigDecimal.ZERO;
                return d2.compareTo(d1);
            });
        }

        // Tự động kiểm tra tính hợp lệ và đổi mã giảm giá tối ưu nếu giỏ hàng thay đổi
        String activeCoupon = (String) session.getAttribute("couponCode");
        boolean currentCouponValid = false;
        int currentUserId = (user != null) ? user.getUserId() : 0;
        VoucherDAO voucherDAO = new VoucherDAO();
        if (activeCoupon != null) {
            VoucherDAO.VoucherInfo info = (user != null) 
                ? voucherDAO.getVoucher(activeCoupon, total, user.getUserId())
                : voucherDAO.getVoucher(activeCoupon, total);
            currentCouponValid = info.isValid;
        }

        if (session.getAttribute("isUserSelected") == null || !((Boolean)session.getAttribute("isUserSelected"))) {
            UserVoucherDTO bestVoucher = voucherDAO.getBestVoucherForOrder(currentUserId, total, cart);
            if (bestVoucher != null) {
                session.setAttribute("couponCode", bestVoucher.getVoucherCode());
                session.setAttribute("discountAmount", bestVoucher.getDiscountAmountActual());
                session.setAttribute("couponId", bestVoucher.getVoucherId());
                session.setAttribute("isCampaign", true);
                session.setAttribute("couponSuccess", true);
                if (activeCoupon == null || !activeCoupon.equalsIgnoreCase(bestVoucher.getVoucherCode())) {
                    session.setAttribute("couponMessage", "Đã tự động đổi sang mã giảm giá tốt nhất phù hợp!");
                }
            } else {
                session.removeAttribute("couponCode");
                session.removeAttribute("discountAmount");
                session.removeAttribute("couponId");
                session.removeAttribute("isCampaign");
            }
        }

        // Xử lý phản hồi dạng JSON cho các yêu cầu gọi qua AJAX (cập nhật động giỏ hàng)
        if ("true".equals(request.getParameter("ajax"))) {
            response.setContentType("application/json;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();

            BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
            if (discount == null) {
                discount = BigDecimal.ZERO;
            }
            BigDecimal finalTotal = total.subtract(discount);
            if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                finalTotal = BigDecimal.ZERO;
            }

            int totalItems = 0;
            for (CartItem it : cart) {
                totalItems += it.getQuantity();
            }

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
            if (couponMessage == null) {
                couponMessage = "";
            }
            Boolean couponSuccess = (Boolean) session.getAttribute("couponSuccess");
            if (couponSuccess == null) {
                couponSuccess = false;
            }

            // Tạo chuỗi JSON danh sách voucher để gửi ngược về Client
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
                    .append("\"statusMessage\":\"").append(v.getStatusMessage()).append("\",")
                    .append("\"description\":\"").append(v.getDescription() != null ? v.getDescription().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "").append("\"")
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
        // Đọc thông tin mã biến thể và số lượng thêm vào giỏ hàng
        int variantId = parseInt(request.getParameter("variantId"), 0);
        int qty = parseInt(request.getParameter("quantity"), 1);
        if (variantId == 0) {
            return;
        }
        if (qty < 1) {
            qty = 1;
        }

        // Lưu giỏ hàng vào Database nếu đã đăng nhập, ngược lại chỉ cập nhật trong Session
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.addToCart(user.getUserId(), variantId, qty);
            cart.clear();
            cart.addAll(cartDAO.getCart(user.getUserId()));
        } else {
            for (CartItem it : cart) { 
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
        // Đọc thông số biến thể và số lượng mới từ yêu cầu thay đổi
        int variantId = parseInt(request.getParameter("variantId"), 0);
        int qty = parseInt(request.getParameter("quantity"), 1);

        // Thực hiện cập nhật số lượng mới, kiểm tra giới hạn tồn kho
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.updateQuantity(user.getUserId(), variantId, qty);
            cart.clear();
            cart.addAll(cartDAO.getCart(user.getUserId()));
        } else {
            for (CartItem it : cart) {
                if (it.getVariantId() == variantId) {
                    if (qty < 1) {
                        qty = 1;
                    }
                    if (qty > it.getAvailableQuantity()) {
                        qty = it.getAvailableQuantity();
                    }
                    it.setQuantity(qty);
                    return;
                }
            }
        }
    }

    private void removeItem(HttpServletRequest request, List<CartItem> cart, Users user) {
        // Đọc mã biến thể cần xóa khỏi giỏ hàng
        int variantId = parseInt(request.getParameter("variantId"), 0);
        
        // Thực hiện xóa bản ghi giỏ hàng ở Database (nếu đã đăng nhập) hoặc Session
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
        // Đọc mã giảm giá do người dùng nhập từ giao diện
        String code = request.getParameter("couponCode");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        List<CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart) {
            total = total.add(it.getSubtotal());
        }

        BigDecimal discount = BigDecimal.ZERO;
        String message = "";
        boolean success = false;
        Integer couponId = null;
        Boolean isCampaign = false;

        // Tiến hành kiểm tra và tính toán giá trị chiết khấu thực tế của voucher
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
            success = true;
            message = "Đã hủy áp dụng mã giảm giá.";
        }

        // Lưu thông tin voucher đã áp dụng thành công lên Session
        if (success) {
            if (code != null && !code.trim().isEmpty()) {
                session.setAttribute("couponCode", code.trim().toUpperCase());
                session.setAttribute("discountAmount", discount);
                session.setAttribute("couponId", couponId);
                session.setAttribute("isCampaign", isCampaign);
                session.setAttribute("isUserSelected", true);
            } else {
                session.removeAttribute("couponCode");
                session.removeAttribute("discountAmount");
                session.removeAttribute("couponId");
                session.removeAttribute("isCampaign");
                session.removeAttribute("isUserSelected");
            }
        } else {
            session.removeAttribute("couponCode");
            session.removeAttribute("discountAmount");
            session.removeAttribute("couponId");
            session.removeAttribute("isCampaign");
            session.removeAttribute("isUserSelected");
        }

        session.setAttribute("couponMessage", message);
        session.setAttribute("couponSuccess", success);
    }

    private void recalculateDiscount(HttpSession session, List<CartItem> cart, String code) {
        // Tính lại giá trị giảm giá thực tế của voucher khi giỏ hàng thay đổi cấu trúc/số lượng
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cart) {
            total = total.add(it.getSubtotal());
        }
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
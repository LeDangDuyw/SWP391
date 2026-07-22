/*
 * Name: OutboundUpdateStatusController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller cập nhật trạng thái quy trình xuất kho và đơn hàng (SHIPPED, DELIVERED, CANCELLED).
 */
package controller;

import dal.OutboundDAO;
import model.Order;
import model.OrderDetail;
import service.EmailService;
import service.PdfInvoiceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OutboundUpdateStatusController", urlPatterns = {"/staff/outbound/update-status"})
public class OutboundUpdateStatusController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP POST: Cập nhật trạng thái của đơn hàng (Order) trong quá trình xuất kho/giao hàng.
     * Nhân viên có thể chuyển trạng thái từ Shipped -> Delivered, hoặc Cancelled.
     * Quá trình xử lý:
     * 1. Nhận orderId và trạng thái mới (status).
     * 2. Gọi OutboundDAO để cập nhật vào cơ sở dữ liệu và ghi log (Audit Log).
     * 3. (Tùy chọn) Gửi Email thông báo hóa đơn tự động bằng PdfInvoiceService nếu cấu hình bật.
     * 4. Điều hướng về trang danh sách phù hợp (danh sách chờ hoặc lịch sử xuất).
     * 
     * @param request  đối tượng HttpServletRequest chứa tham số orderId, status, redirect
     * @param response đối tượng HttpServletResponse điều hướng về trang tương ứng
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();
        Users staff = (Users) session.getAttribute("user");
        String actionBy = (staff != null) ? staff.getUserName() : "Staff Member";

        if (orderIdStr != null && status != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                OutboundDAO dao = new OutboundDAO();
                Order order = dao.getOrderById(orderId);
                
                if (order != null) {
                    String oldStatus = order.getOrderStatus();
                    boolean ok = dao.updateOrderStatus(orderId, status);
                    if (ok) {
                        String msg = "Cập nhật trạng thái đơn hàng từ " + oldStatus + " thành " + status + ".";
                        dao.addOrderLog(orderId, oldStatus, status, actionBy, msg);
                        
                        if ("delivered".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
                            String realPath = getServletContext().getRealPath("/invoices");
                            if (realPath == null) {
                                realPath = new File(getServletContext().getRealPath("/"), "invoices").getAbsolutePath();
                            }
                            
                            Order updatedOrder = dao.getOrderById(orderId);
                            List<OrderDetail> details = dao.getOrderDetails(orderId);
                            updatedOrder.setDetails(details);

                            // Award reward points (10,000 VND = 1 point)
                            if (updatedOrder != null && updatedOrder.getUserId() > 0 && updatedOrder.getTotalAmount() != null) {
                                int earnedPoints = updatedOrder.getTotalAmount().divide(new java.math.BigDecimal("10000"), 0, java.math.RoundingMode.DOWN).intValue();
                                if (earnedPoints > 0) {
                                    dal.UserDAO userDAO = new dal.UserDAO();
                                    userDAO.addRewardPoints(updatedOrder.getUserId(), earnedPoints);
                                    dao.addOrderLog(orderId, status, status, "System (Reward Service)",
                                            "Tích lũy +" + earnedPoints + " điểm thưởng cho tài khoản ID: " + updatedOrder.getUserId());
                                }
                            }
                            
                            String fileName = PdfInvoiceService.generateInvoice(updatedOrder, realPath);
                            String dbInvoicePath = "invoices/" + fileName;
                            
                            dao.updateInvoiceDetails(orderId, dbInvoicePath, 0);
                        }
                    } else {
                        session.setAttribute("error", "Không thể cập nhật trạng thái đơn hàng. Vui lòng kiểm tra lại trạng thái hiện tại.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/staff/order/detail?orderId=" + orderIdStr);
        } else if ("order-list".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/staff/order/list");
        } else if ("history".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/history");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
        }
    }
}

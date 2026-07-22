/*
 * Name: ReviewTicketController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc duyệt hoặc từ chối phiếu yêu cầu nhập kho của nhân viên bởi Admin.
 */
package controller;

import dal.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Ticket;

import java.io.IOException;

@WebServlet(name = "ReviewTicketController", urlPatterns = {"/admin/ticket/review"})
public class ReviewTicketController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP POST: Quản trị viên (Admin) duyệt hoặc từ chối phiếu yêu cầu nhập kho.
     * Quá trình xử lý:
     * 1. Lấy thông tin ticketId, hành động (approve/reject) và lý do (nếu có).
     * 2. Kiểm tra xem Ticket có tồn tại không bằng TicketDAO.
     * 3. Kiểm tra tính hợp lệ của trạng thái (State Machine): Chỉ những phiếu đang ở trạng thái 
     *    WAITING_FOR_ADMIN_REVIEW mới được phép duyệt hoặc từ chối.
     * 4. Nếu duyệt, chuyển trạng thái thành APPROVED_EXECUTION. Nếu từ chối, chuyển thành REJECTED.
     * 5. Cập nhật vào cơ sở dữ liệu kèm theo lý do từ chối (nếu có) và điều hướng lại trang danh sách.
     * 
     * @param request  đối tượng HttpServletRequest chứa thông tin hành động
     * @param response đối tượng HttpServletResponse để điều hướng sau khi xử lý
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdStr = request.getParameter("ticketId");
        String action = request.getParameter("action"); // "approve" or "reject"
        String reason = request.getParameter("reason");

        if (ticketIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=InvalidRequest");
            return;
        }

        int ticketId = Integer.parseInt(ticketIdStr);
        if (reason == null) reason = "";

        TicketDAO ticketDao = new TicketDAO();
        
        // Kiểm tra trạng thái hiện tại của Ticket (State Machine)
        Ticket ticket = ticketDao.getTicketById(ticketId);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=TicketNotFound");
            return;
        }
        
        // Chỉ cho phép duyệt/từ chối nếu trạng thái hiện tại là WAITING_FOR_ADMIN_REVIEW
        if (!"WAITING_FOR_ADMIN_REVIEW".equals(ticket.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=InvalidStatusTransition");
            return;
        }
        
        String status = action.equalsIgnoreCase("approve") ? "APPROVED_EXECUTION" : "REJECTED";
        boolean success = ticketDao.updateTicketStatus(ticketId, status, reason);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?success=TicketReviewed");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=ReviewFailed");
        }
    }
}

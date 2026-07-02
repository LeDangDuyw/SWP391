/*
 * Name: ReviewTicketController
 * @Author: HuyDQ
 * Date: [05/06/2026]
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

import java.io.IOException;

@WebServlet(name = "ReviewTicketController", urlPatterns = {"/admin/ticket/review"})
public class ReviewTicketController extends HttpServlet {

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
        String status = action.equalsIgnoreCase("approve") ? "APPROVED_EXECUTION" : "REJECTED";
        if (reason == null) reason = "";

        TicketDAO ticketDao = new TicketDAO();
        boolean success = ticketDao.updateTicketStatus(ticketId, status, reason);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?success=TicketReviewed");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=ReviewFailed");
        }
    }
}

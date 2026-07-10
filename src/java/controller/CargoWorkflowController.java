/*
 * Name: CargoWorkflowController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 2.0
 * Description: Controller quản lý quy trình trạng thái (hủy, nhận hàng, yêu cầu chỉnh sửa) của phiếu nhập kho.
 *              Thực thi State Machine nghiêm ngặt để đảm bảo tính toàn vẹn nghiệp vụ.
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

@WebServlet(name = "CargoWorkflowController", urlPatterns = {"/staff/ticket/workflow"})
public class CargoWorkflowController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdStr = request.getParameter("id");
        if (ticketIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list");
            return;
        }

        int ticketId = Integer.parseInt(ticketIdStr);
        TicketDAO ticketDao = new TicketDAO();
        Ticket ticket = ticketDao.getTicketById(ticketId);

        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=NotFound");
            return;
        }

        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("/staff/ticket/TicketDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdStr = request.getParameter("ticketId");
        String action = request.getParameter("action"); 
        // actions: "cancel", "receive", "request_edit"

        if (ticketIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=InvalidRequest");
            return;
        }

        int ticketId = Integer.parseInt(ticketIdStr);
        TicketDAO ticketDao = new TicketDAO();
        
        // Lấy trạng thái hiện tại của Ticket để kiểm tra State Machine
        Ticket ticket = ticketDao.getTicketById(ticketId);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=NotFound");
            return;
        }
        
        String currentStatus = ticket.getStatus();
        String newStatus = "";

        switch (action.toLowerCase()) {
            case "cancel":
                // Chỉ cho phép hủy nếu trạng thái hiện tại là WAITING_FOR_ADMIN_REVIEW hoặc APPROVED_EXECUTION
                if (!"WAITING_FOR_ADMIN_REVIEW".equals(currentStatus) && !"APPROVED_EXECUTION".equals(currentStatus)) {
                    response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId + "&error=CannotCancelInCurrentStatus");
                    return;
                }
                newStatus = "CANCELLED";
                break;
            case "receive":
                // Chỉ cho phép nhận hàng nếu trạng thái hiện tại là APPROVED_EXECUTION
                if (!"APPROVED_EXECUTION".equals(currentStatus)) {
                    response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId + "&error=CannotReceiveInCurrentStatus");
                    return;
                }
                newStatus = "CARGO_RECEIVED";
                break;
            case "request_edit":
                // Chỉ cho phép yêu cầu chỉnh sửa nếu trạng thái hiện tại là REJECTED
                if (!"REJECTED".equals(currentStatus)) {
                    response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId + "&error=CannotRequestEditInCurrentStatus");
                    return;
                }
                newStatus = "WAITING_FOR_ADMIN_REVIEW";
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=InvalidAction");
                return;
        }

        boolean success = ticketDao.updateTicketStatus(ticketId, newStatus, "");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=UpdateFailed");
        }
    }
}

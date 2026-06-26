/*
 * Name: CargoWorkflowController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Controller quản lý quy trình trạng thái (hủy, nhận hàng, yêu cầu chỉnh sửa) của phiếu nhập kho.
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
        String status = "";

        switch (action.toLowerCase()) {
            case "cancel":
                status = "CANCELLED";
                break;
            case "receive":
                status = "CARGO_RECEIVED";
                break;
            case "request_edit":
                status = "WAITING_FOR_ADMIN_REVIEW";
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=InvalidAction");
                return;
        }

        boolean success = ticketDao.updateTicketStatus(ticketId, status, "");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/list?error=UpdateFailed");
        }
    }
}

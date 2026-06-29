/*
 * Name: AdminTicketDetailController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Controller hiển thị thông tin chi tiết của một phiếu nhập kho để Admin phê duyệt hoặc từ chối.
 */
package controller.ticket;

import dal.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Ticket;

import java.io.IOException;

@WebServlet(name = "AdminTicketDetailController", urlPatterns = {"/admin/ticket/detail"})
public class AdminTicketDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=InvalidTicketId");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            TicketDAO dao = new TicketDAO();
            Ticket ticket = dao.getTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=TicketNotFound");
                return;
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/admin/ticket/AdminTicketDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/ticket/list?error=InvalidTicketId");
        }
    }
}

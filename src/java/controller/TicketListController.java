/*
 * Name: TicketListController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Controller hiển thị danh sách phiếu yêu cầu nhập kho dành cho nhân viên.
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
import java.util.List;

@WebServlet(name = "TicketListController", urlPatterns = {"/staff/ticket/list"})
public class TicketListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TicketDAO ticketDao = new TicketDAO();
        List<Ticket> tickets = ticketDao.getAllTickets();
        
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/staff/ticket/TicketList.jsp").forward(request, response);
    }
}

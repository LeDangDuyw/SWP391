/*
 * Name: TicketListController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị danh sách phiếu yêu cầu nhập kho (Import Ticket) dành cho nhân viên.
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

    /**
     * Xử lý yêu cầu HTTP GET: Lấy và hiển thị toàn bộ danh sách phiếu yêu cầu nhập kho (Ticket)
     * dành cho nhân viên kho.
     * Nhân viên có thể xem các phiếu đang chờ duyệt, phiếu đã được duyệt (để tiến hành nhập kho thực tế - Nhập IMEI),
     * hoặc các phiếu đã hoàn thành/từ chối.
     * 
     * @param request  đối tượng HttpServletRequest chứa thông tin request
     * @param response đối tượng HttpServletResponse để điều hướng về TicketList.jsp
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TicketDAO ticketDao = new TicketDAO();
        List<Ticket> tickets = ticketDao.getAllTickets();
        
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/staff/ticket/TicketList.jsp").forward(request, response);
    }
}

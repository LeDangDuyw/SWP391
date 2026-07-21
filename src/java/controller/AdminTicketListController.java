/*
 * Name: AdminTicketListController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị danh sách phiếu nhập kho chờ duyệt dành cho quản trị viên (Admin).
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

@WebServlet(name = "AdminTicketListController", urlPatterns = {"/admin/ticket/list"})
public class AdminTicketListController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Lấy và hiển thị toàn bộ danh sách phiếu yêu cầu nhập kho (Ticket)
     * dành cho trang quản trị (Admin).
     * Dữ liệu này giúp Admin nắm bắt được các phiếu đang chờ duyệt (WAITING_FOR_ADMIN_REVIEW),
     * đã duyệt (APPROVED_EXECUTION), hoặc đã hoàn thành.
     * 
     * @param request  đối tượng HttpServletRequest chứa thông tin request
     * @param response đối tượng HttpServletResponse để điều hướng về AdminTicketList.jsp
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TicketDAO ticketDao = new TicketDAO();
        List<Ticket> tickets = ticketDao.getAllTickets();
        
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/admin/ticket/AdminTicketList.jsp").forward(request, response);
    }
}

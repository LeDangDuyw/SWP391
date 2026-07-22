/*
 * Name: OutboundListController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị danh sách các đơn hàng chờ xuất kho cho nhân viên.
 */
package controller;

import dal.OutboundDAO;
import model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OutboundListController", urlPatterns = {"/staff/outbound/list"})
public class OutboundListController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Lấy và hiển thị danh sách các đơn hàng (Orders) đang chờ xử lý xuất kho.
     * Nhân viên kho sẽ xem danh sách này để biết đơn hàng nào cần soạn hàng và xuất kho.
     * Hỗ trợ phân trang (pagination) để tối ưu hiệu suất khi có nhiều đơn hàng.
     * 
     * @param request  đối tượng HttpServletRequest chứa tham số page (trang hiện tại)
     * @param response đối tượng HttpServletResponse để điều hướng về OrderList.jsp
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * pageSize;

        OutboundDAO dao = new OutboundDAO();
        int totalRecords = dao.getTotalPendingOrders();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        List<Order> orders = dao.getPendingOrders(offset, pageSize);
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/staff/outbound/OrderList.jsp").forward(request, response);
    }
}

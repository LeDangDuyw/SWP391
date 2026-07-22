/*
 * Name: OutboundHistoryController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị lịch sử các đơn hàng đã thực hiện xuất kho thành công.
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

@WebServlet(name = "OutboundHistoryController", urlPatterns = {"/staff/outbound/history"})
public class OutboundHistoryController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Lấy và hiển thị lịch sử các đơn hàng đã được xuất kho thành công.
     * Cung cấp cho nhân viên kho cái nhìn tổng quan về các đơn hàng đã xử lý xong.
     * Dữ liệu được truy xuất qua OutboundDAO và có hỗ trợ phân trang để dễ dàng tra cứu.
     * 
     * @param request  đối tượng HttpServletRequest chứa tham số page (trang hiện tại)
     * @param response đối tượng HttpServletResponse để điều hướng về OrderHistory.jsp
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
        int totalRecords = dao.getTotalOutboundHistory();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        List<Order> orders = dao.getOutboundHistory(offset, pageSize);
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/staff/outbound/OrderHistory.jsp").forward(request, response);
    }
}

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

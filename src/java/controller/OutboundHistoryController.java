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
        
        OutboundDAO dao = new OutboundDAO();
        List<Order> orders = dao.getOutboundHistory();
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/staff/outbound/OrderHistory.jsp").forward(request, response);
    }
}

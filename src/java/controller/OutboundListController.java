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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        OutboundDAO dao = new OutboundDAO();
        List<Order> orders = dao.getPendingOrders();
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/staff/outbound/OrderList.jsp").forward(request, response);
    }
}

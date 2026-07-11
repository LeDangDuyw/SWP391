package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Users;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users sessionUser = (Users) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || (order.getUserId() != null && !order.getUserId().equals(sessionUser.getUserId()))) {
                response.sendRedirect(request.getContextPath() + "/profile#orders");
                return;
            }

            order.setDetails(orderDAO.getOrderDetails(orderId));
            request.setAttribute("order", order);
            request.getRequestDispatcher("/customer/order_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
        }
    }
}

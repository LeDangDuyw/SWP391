package controller;

import dal.OrderDAO;
import dal.ProductReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.ProductReview;
import model.Users;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

            List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
            order.setDetails(details);
            request.setAttribute("order", order);

            String status = order.getOrderStatus();
            boolean isDelivered = status != null && (status.equalsIgnoreCase("delivered") || status.equalsIgnoreCase("completed"));
            request.setAttribute("isDelivered", isDelivered);

            if (isDelivered && details != null) {
                ProductReviewDAO reviewDAO = new ProductReviewDAO();
                Map<Integer, ProductReview> productReviewsMap = new HashMap<>();
                for (OrderDetail d : details) {
                    ProductReview rev = reviewDAO.getReviewByUserAndProduct(sessionUser.getUserId(), d.getProductId());
                    if (rev != null) {
                        productReviewsMap.put(d.getProductId(), rev);
                    }
                }
                request.setAttribute("productReviewsMap", productReviewsMap);
            }

            request.getRequestDispatcher("/customer/order_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users sessionUser = (Users) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (orderIdStr == null || productIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;
            if (comment == null) comment = "";

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order != null && order.getUserId() != null && order.getUserId().equals(sessionUser.getUserId())) {
                String status = order.getOrderStatus();
                boolean isDelivered = status != null && (status.equalsIgnoreCase("delivered") || status.equalsIgnoreCase("completed"));
                if (isDelivered) {
                    ProductReviewDAO reviewDAO = new ProductReviewDAO();
                    reviewDAO.saveOrUpdateReview(productId, sessionUser.getUserId(), rating, comment.trim());
                    response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId + "&reviewSuccess=true#review-" + productId);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
        }
    }
}

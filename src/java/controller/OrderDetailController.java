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

/*
 * Name: OrderDetailController
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Servlet xử lý hiển thị chi tiết thông tin đơn hàng dành cho khách hàng
 */
@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users sessionUser = (Users) session.getAttribute("user");

        // Kiểm tra xem khách hàng đã đăng nhập chưa
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        // Lấy tham số id đơn hàng từ request
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            // Đảm bảo đơn hàng tồn tại và thuộc về đúng tài khoản đang đăng nhập
            if (order == null || (order.getUserId() != null && !order.getUserId().equals(sessionUser.getUserId()))) {
                response.sendRedirect(request.getContextPath() + "/profile#orders");
                return;
            }

            // Đồng bộ thông tin người dùng mới nhất phục vụ thanh Header/TopBar
            dal.UserDAO userDAO = new dal.UserDAO();
            Users freshUser = userDAO.getUserById(sessionUser.getUserId());
            if (freshUser == null) {
                freshUser = sessionUser;
            }
            request.setAttribute("profileUser", freshUser);

            // Lấy danh sách chi tiết các sản phẩm trong đơn hàng
            java.util.List<model.OrderDetail> details = orderDAO.getOrderDetails(orderId);
            dal.ProductReviewDAO reviewDAO = new dal.ProductReviewDAO();
            
            // Kiểm tra xem sản phẩm nào trong đơn hàng đã được người dùng đánh giá
            for (model.OrderDetail od : details) {
                od.setReviewed(reviewDAO.hasUserReviewedProduct(sessionUser.getUserId(), od.getProductId()));
            }
            order.setDetails(details);
            request.setAttribute("order", order);
            
            // Chuyển tiếp yêu cầu sang giao diện chi tiết đơn hàng của khách hàng
            request.getRequestDispatcher("/customer/order_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile#orders");
        }
    }
}

package controller;

import dal.ProductReviewDAO;
import model.ProductReview;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/reviews", "/staff/reviews"})
public class ManageReviewServlet extends HttpServlet {

    private ProductReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ProductReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Đọc các bộ lọc đầu vào
        String ratingFilter = request.getParameter("ratingFilter"); // all, good, bad, 1, 2, 3, 4, 5
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String status = request.getParameter("status"); // all, approved, hidden

        // Phân trang
        int page = 1;
        int pageSize = 10;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Đặt giá trị mặc định cho bộ lọc
        if (ratingFilter == null) ratingFilter = "all";
        if (status == null) status = "all";

        // Lấy danh sách đánh giá thỏa mãn điều kiện lọc
        List<ProductReview> reviews = reviewDAO.getReviewsWithFilters(ratingFilter, fromDate, toDate, status, page, pageSize);
        int totalReviews = reviewDAO.countReviewsWithFilters(ratingFilter, fromDate, toDate, status);
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        // Đưa dữ liệu sang JSP
        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReviews", totalReviews);
        
        // Lưu lại trạng thái bộ lọc trên Form giao diện
        request.setAttribute("ratingFilter", ratingFilter);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("status", status);

        // Chuyển tiếp tới trang quản lý dùng chung
        request.getRequestDispatcher("/admin/ReviewsManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        int currentUserId = currentUser.getUserId();

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean success = false;

        if ("approve".equalsIgnoreCase(action) || "show".equalsIgnoreCase(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            success = reviewDAO.updateReviewStatus(reviewId, "approved", currentUserId);
        } 
        else if ("hide".equalsIgnoreCase(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            success = reviewDAO.updateReviewStatus(reviewId, "hidden", currentUserId);
        } 
        else if ("reply".equalsIgnoreCase(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String replyContent = request.getParameter("replyContent");
            if (replyContent != null && !replyContent.trim().isEmpty()) {
                success = reviewDAO.replyToReview(reviewId, replyContent.trim(), currentUserId);
            }
        }

        // Trở lại đúng URL hiện tại để hiển thị danh sách
        String requestURI = request.getRequestURI();
        response.sendRedirect(requestURI + "?success=" + success);
    }
}

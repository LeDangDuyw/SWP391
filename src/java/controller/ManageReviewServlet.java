//@Author: MINHBQ
// * Date: [25/7/2026]
// * Version: 1.6
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
import java.util.Map;
import java.util.LinkedHashMap;

/**
 * Servlet Quản Lý Đánh Giá (/admin/reviews, /staff/reviews)
 * 
 * CHỨC NĂNG:
 * - Điều hướng và xử lý toàn bộ nghiệp vụ Quản lý đánh giá sản phẩm (Danh sách, Ẩn/Hiện, Trả lời khách hàng).
 * - Cung cấp các API AJAX trả về dữ liệu JSON cho biểu đồ Line Chart thống kê số sao theo thời gian (getChartData).
 * - Cung cấp API AJAX tìm kiếm đánh giá trung bình theo sản phẩm (searchProduct).
 * - Cung cấp API AJAX tải lại danh sách đánh giá mới nhất theo bộ lọc live sync (syncLatestReviews).
 * 
 * LIÊN KẾT:
 * - DAO Layer: dal.ProductReviewDAO (Các hàm getRatingStatsWithInterval, searchProductAverageRating, getReviewsWithFilters, updateReviewStatus, replyToReview).
 * - View JSP: web/admin/ReviewsManagement.jsp (Render giao diện quản lý Admin/Staff).
 * - Data Models: model.ProductReview, model.Users.
 */
@WebServlet(urlPatterns = {"/admin/reviews", "/staff/reviews"})
public class ManageReviewServlet extends HttpServlet {

    private ProductReviewDAO reviewDAO;

    /**
     * CHỨC NĂNG: Khởi tạo đối tượng ProductReviewDAO khi Servlet được nạp vào Container.
     * LIÊN KẾT: dal.ProductReviewDAO
     */
    @Override
    public void init() {
        reviewDAO = new ProductReviewDAO();
    }

    /**
     * Phương thức doGet: Xử lý các yêu cầu lấy danh sách đánh giá và các API AJAX lấy dữ liệu JSON.
     * 
     * CHỨC NĂNG:
     * 1. action="getChartData": Đọc từ ngày, đến ngày, productId -> Gọi ProductReviewDAO.getRatingStatsWithInterval() -> Trả về JSON vẽ biểu đồ Line Chart.
     * 2. action="searchProduct": Đọc từ khóa query -> Gọi ProductReviewDAO.searchProductAverageRating() -> Trả về JSON danh sách sản phẩm kèm số sao trung bình.
     * 3. action="syncLatestReviews": Đọc bộ lọc rating, từ ngày, đến ngày, trạng thái, trang -> Gọi ProductReviewDAO.getReviewsWithFilters() -> Trả về JSON danh sách đánh giá live sync.
     * 4. Mặc định: Lấy danh sách đánh giá phân trang -> Đưa dữ liệu vào Attribute -> Forward tới /admin/ReviewsManagement.jsp.
     * 
     * LIÊN KẾT:
     * - Web URL: GET /admin/reviews hoặc GET /staff/reviews
     * - JSP View: /admin/ReviewsManagement.jsp
     * - DAO Methods: ProductReviewDAO.getRatingStatsWithInterval(), searchProductAverageRating(), getReviewsWithFilters(), countReviewsWithFilters()
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("getChartData".equalsIgnoreCase(action)) {
            response.setContentType("application/json;charset=UTF-8");
            String fDate = request.getParameter("fromDate");
            String tDate = request.getParameter("toDate");
            String prodIdStr = request.getParameter("productId");
            Integer productId = null;
            if (prodIdStr != null && !prodIdStr.trim().isEmpty()) {
                try {
                    productId = Integer.parseInt(prodIdStr.trim());
                } catch (NumberFormatException e) {}
            }
            
            Map<String, Object> stats = reviewDAO.getRatingStatsWithInterval(fDate, tDate, productId);
            
            List<String> labels = (List<String>) stats.get("labels");
            List<Integer> star1 = (List<Integer>) stats.get("star1");
            List<Integer> star2 = (List<Integer>) stats.get("star2");
            List<Integer> star3 = (List<Integer>) stats.get("star3");
            List<Integer> star4 = (List<Integer>) stats.get("star4");
            List<Integer> star5 = (List<Integer>) stats.get("star5");
            String fromDate = (String) stats.get("fromDate");
            String toDate = (String) stats.get("toDate");
            String productName = (String) stats.get("productName");
            
            StringBuilder json = new StringBuilder("{");
            json.append("\"fromDate\":\"").append(fromDate).append("\",");
            json.append("\"toDate\":\"").append(toDate).append("\",");
            if (productName != null) {
                json.append("\"productId\":").append(productId).append(",");
                json.append("\"productName\":\"").append(productName.replace("\"", "\\\"")).append("\",");
            }
            
            json.append("\"labels\":[");
            for (int i = 0; i < labels.size(); i++) {
                if (i > 0) json.append(",");
                json.append("\"").append(labels.get(i)).append("\"");
            }
            json.append("],");
            
            json.append("\"star1\":").append(star1.toString()).append(",");
            json.append("\"star2\":").append(star2.toString()).append(",");
            json.append("\"star3\":").append(star3.toString()).append(",");
            json.append("\"star4\":").append(star4.toString()).append(",");
            json.append("\"star5\":").append(star5.toString());
            
            json.append("}");
            response.getWriter().print(json.toString());
            return;
        } else if ("searchProduct".equalsIgnoreCase(action)) {
            response.setContentType("application/json;charset=UTF-8");
            String query = request.getParameter("query");
            if (query == null) query = "";
            List<Map<String, Object>> products = reviewDAO.searchProductAverageRating(query);
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                if (i > 0) json.append(",");
                Map<String, Object> p = products.get(i);
                String pName = ((String) p.get("productName")).replace("\"", "\\\"");
                json.append("{")
                    .append("\"productId\":").append(p.get("productId")).append(",")
                    .append("\"productName\":\"").append(pName).append("\",")
                    .append("\"avgRating\":").append(p.get("avgRating")).append(",")
                    .append("\"totalReviews\":").append(p.get("totalReviews")).append(",")
                    .append("\"star5\":").append(p.get("star5")).append(",")
                    .append("\"star4\":").append(p.get("star4")).append(",")
                    .append("\"star3\":").append(p.get("star3")).append(",")
                    .append("\"star2\":").append(p.get("star2")).append(",")
                    .append("\"star1\":").append(p.get("star1"))
                    .append("}");
            }
            json.append("]");
            response.getWriter().print(json.toString());
            return;
        } else if ("syncLatestReviews".equalsIgnoreCase(action)) {
            response.setContentType("application/json;charset=UTF-8");
            String ratingFilter = request.getParameter("ratingFilter");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String status = request.getParameter("status");
            
            if (ratingFilter == null) ratingFilter = "all";
            if (status == null) status = "all";
            
            int page = 1;
            int pageSize = 10;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            List<ProductReview> reviews = reviewDAO.getReviewsWithFilters(ratingFilter, fromDate, toDate, status, page, pageSize);
            int totalReviews = reviewDAO.countReviewsWithFilters(ratingFilter, fromDate, toDate, status);
            int totalPages = (int) Math.ceil((double) totalReviews / pageSize);
            
            StringBuilder json = new StringBuilder("{\"reviews\":[");
            for (int i = 0; i < reviews.size(); i++) {
                if (i > 0) json.append(",");
                ProductReview r = reviews.get(i);
                String uName = r.getUserName() == null ? "" : r.getUserName().replace("\"", "\\\"");
                String pName = r.getProductName() == null ? "" : r.getProductName().replace("\"", "\\\"");
                String comment = r.getComment() == null ? "" : r.getComment().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String replyContent = r.getReplyContent() == null ? "" : r.getReplyContent().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String replierName = r.getReplierName() == null ? "" : r.getReplierName().replace("\"", "\\\"");
                
                json.append("{")
                    .append("\"reviewId\":").append(r.getReviewId()).append(",")
                    .append("\"userName\":\"").append(uName).append("\",")
                    .append("\"productName\":\"").append(pName).append("\",")
                    .append("\"rating\":").append(r.getRating()).append(",")
                    .append("\"comment\":\"").append(comment).append("\",")
                    .append("\"createdAt\":\"").append(r.getCreatedAt() != null ? r.getCreatedAt().toString() : "").append("\",")
                    .append("\"status\":\"").append(r.getStatus()).append("\",")
                    .append("\"replyContent\":\"").append(replyContent).append("\",")
                    .append("\"replierName\":\"").append(replierName).append("\",")
                    .append("\"repliedAt\":\"").append(r.getRepliedAt() != null ? r.getRepliedAt().toString() : "").append("\"")
                    .append("}");
            }
            json.append("],")
                .append("\"currentPage\":").append(page).append(",")
                .append("\"totalPages\":").append(totalPages).append(",")
                .append("\"totalReviews\":").append(totalReviews)
                .append("}");
            response.getWriter().print(json.toString());
            return;
        }

        String ratingFilter = request.getParameter("ratingFilter");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String status = request.getParameter("status");

        int page = 1;
        int pageSize = 10;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (ratingFilter == null) ratingFilter = "all";
        if (status == null) status = "all";

        List<ProductReview> reviews = reviewDAO.getReviewsWithFilters(ratingFilter, fromDate, toDate, status, page, pageSize);
        int totalReviews = reviewDAO.countReviewsWithFilters(ratingFilter, fromDate, toDate, status);
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReviews", totalReviews);
        
        request.setAttribute("ratingFilter", ratingFilter);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/admin/ReviewsManagement.jsp").forward(request, response);
    }

    /**
     * Phương thức doPost: Xử lý các thao tác tương tác cập nhật đánh giá (Duyệt/Hiện, Ẩn đánh giá, Trả lời khách hàng).
     * 
     * CHỨC NĂNG:
     * 1. action="approve" hoặc "show": Gọi ProductReviewDAO.updateReviewStatus(reviewId, "approved", currentUserId) để duyệt/hiển thị đánh giá.
     * 2. action="hide": Gọi ProductReviewDAO.updateReviewStatus(reviewId, "hidden", currentUserId) để ẩn đánh giá vi phạm.
     * 3. action="reply": Gọi ProductReviewDAO.replyToReview(reviewId, replyContent, currentUserId) để lưu câu trả lời của Admin/Staff.
     * 
     * LIÊN KẾT:
     * - Web URL: POST /admin/reviews hoặc POST /staff/reviews
     * - DAO Methods: ProductReviewDAO.updateReviewStatus(), replyToReview()
     * - Form Modal: web/admin/ReviewsManagement.jsp (#replyForm)
     */
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

        String requestURI = request.getRequestURI();
        response.sendRedirect(requestURI + "?success=" + success);
    }
}

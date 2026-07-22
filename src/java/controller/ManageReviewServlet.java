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

        String action = request.getParameter("action");
        if ("getChartData".equalsIgnoreCase(action)) {
            response.setContentType("application/json;charset=UTF-8");
            String chartMode = request.getParameter("chartMode"); // "day" or "product"
            String fDate = request.getParameter("fromDate");
            String tDate = request.getParameter("toDate");
            
            StringBuilder json = new StringBuilder("{");
            if ("product".equalsIgnoreCase(chartMode)) {
                Map<String, int[]> stats = reviewDAO.getProductRatingStats(fDate, tDate);
                json.append("\"labels\":[");
                StringBuilder d1 = new StringBuilder("[");
                StringBuilder d2 = new StringBuilder("[");
                StringBuilder d3 = new StringBuilder("[");
                StringBuilder d4 = new StringBuilder("[");
                StringBuilder d5 = new StringBuilder("[");
                int index = 0;
                for (Map.Entry<String, int[]> entry : stats.entrySet()) {
                    if (index > 0) {
                        json.append(",");
                        d1.append(",");
                        d2.append(",");
                        d3.append(",");
                        d4.append(",");
                        d5.append(",");
                    }
                    String name = entry.getKey().replace("\"", "\\\"");
                    json.append("\"").append(name).append("\"");
                    d1.append(entry.getValue()[0]);
                    d2.append(entry.getValue()[1]);
                    d3.append(entry.getValue()[2]);
                    d4.append(entry.getValue()[3]);
                    d5.append(entry.getValue()[4]);
                    index++;
                }
                json.append("],\"star1\":").append(d1).append("]")
                    .append(",\"star2\":").append(d2).append("]")
                    .append(",\"star3\":").append(d3).append("]")
                    .append(",\"star4\":").append(d4).append("]")
                    .append(",\"star5\":").append(d5).append("]");
            } else {
                Map<String, int[]> stats = reviewDAO.getDailyRatingStats(fDate, tDate);
                json.append("\"labels\":[");
                StringBuilder d1 = new StringBuilder("[");
                StringBuilder d2 = new StringBuilder("[");
                StringBuilder d3 = new StringBuilder("[");
                StringBuilder d4 = new StringBuilder("[");
                StringBuilder d5 = new StringBuilder("[");
                int index = 0;
                for (Map.Entry<String, int[]> entry : stats.entrySet()) {
                    if (index > 0) {
                        json.append(",");
                        d1.append(",");
                        d2.append(",");
                        d3.append(",");
                        d4.append(",");
                        d5.append(",");
                    }
                    json.append("\"").append(entry.getKey()).append("\"");
                    d1.append(entry.getValue()[0]);
                    d2.append(entry.getValue()[1]);
                    d3.append(entry.getValue()[2]);
                    d4.append(entry.getValue()[3]);
                    d5.append(entry.getValue()[4]);
                    index++;
                }
                json.append("],\"star1\":").append(d1).append("]")
                    .append(",\"star2\":").append(d2).append("]")
                    .append(",\"star3\":").append(d3).append("]")
                    .append(",\"star4\":").append(d4).append("]")
                    .append(",\"star5\":").append(d5).append("]");
            }
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

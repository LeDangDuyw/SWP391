/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.ProductReview;
import java.sql.*;
import java.util.*;

/**
 *
 * @author NC
 */
public class ProductReviewDAO extends DBContext {
    
     private Connection con ; 
    private PreparedStatement ps ;   
    private ResultSet rs;
    
      public ProductReviewDAO() {
        this.con = super.connection;
    }
      
      // them review tu customers
    public boolean addReview(ProductReview review) {
        String sql = "INSERT INTO ProductReview (product_id, user_id, rating, comment, status) VALUES (?, ?, ?, ?, 'approved')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
     // admin , staff comment
    public boolean replyToReview(int reviewId, String replyContent, int replierId) {
        String sql = "UPDATE ProductReview SET reply_content = ?, replied_by = ?, replied_at = GETDATE() WHERE review_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, replyContent);
            ps.setInt(2, replierId);
            ps.setInt(3, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // duyet an binh luan 
        public boolean updateReviewStatus(int reviewId, String status, int moderatorId) {
        String sql = "UPDATE ProductReview SET status = ?, moderated_by = ?, moderated_at = GETDATE() WHERE review_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, moderatorId);
            ps.setInt(3, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
     // Helper map ResultSet sang Object
    private ProductReview mapRow(ResultSet rs) throws SQLException {
        return new ProductReview(
            rs.getInt("review_id"),
            rs.getInt("product_id"),
            rs.getString("product_name"),
            rs.getInt("user_id"),
            rs.getString("reviewer_name"),
            rs.getInt("rating"),
            rs.getString("comment"),
            rs.getTimestamp("created_at"),
            rs.getString("status"),
            rs.getObject("moderated_by") != null ? rs.getInt("moderated_by") : null,
            rs.getString("moderator_name"),
            rs.getTimestamp("moderated_at"),
            rs.getString("reply_content"),
            rs.getObject("replied_by") != null ? rs.getInt("replied_by") : null,
            rs.getString("replier_name"),
            rs.getTimestamp("replied_at")
        );
    }
    // Lấy đánh giá có bộ lọc đầy đủ phục vụ trang quản lý đánh giá
    public List<ProductReview> getReviewsWithFilters(String ratingFilter, String fromDate, String toDate, String status, int page, int pageSize) {
        List<ProductReview> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT pr.*, u.full_name AS reviewer_name, p.product_name, mu.full_name AS moderator_name, ru.full_name AS replier_name " +
            "FROM ProductReview pr " +
            "JOIN [User] u ON pr.user_id = u.user_id " +
            "JOIN Product p ON pr.product_id = p.product_id " +
            "LEFT JOIN [User] mu ON pr.moderated_by = mu.user_id " +
            "LEFT JOIN [User] ru ON pr.replied_by = ru.user_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        // Lọc sao: tốt (>=4), xấu (<=3), hoặc số sao cụ thể
        if (ratingFilter != null && !ratingFilter.isEmpty() && !"all".equalsIgnoreCase(ratingFilter)) {
            if ("good".equalsIgnoreCase(ratingFilter)) {
                sql.append("AND pr.rating >= 4 ");
            } else if ("bad".equalsIgnoreCase(ratingFilter)) {
                sql.append("AND pr.rating <= 3 ");
            } else {
                sql.append("AND pr.rating = ? ");
                params.add(Integer.parseInt(ratingFilter));
            }
        }
        // Lọc theo khoảng ngày gửi
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND pr.created_at >= ? ");
            params.add(Timestamp.valueOf(fromDate + " 00:00:00"));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND pr.created_at <= ? ");
            params.add(Timestamp.valueOf(toDate + " 23:59:59"));
        }
        // Lọc theo trạng thái duyệt
        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND pr.status = ? ");
            params.add(status);
        }
        sql.append("ORDER BY pr.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        int offset = (page - 1) * pageSize;
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // Đếm tổng số đánh giá theo bộ lọc phục vụ phân trang
    public int countReviewsWithFilters(String ratingFilter, String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM ProductReview pr " +
            "JOIN [User] u ON pr.user_id = u.user_id " +
            "JOIN Product p ON pr.product_id = p.product_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (ratingFilter != null && !ratingFilter.isEmpty() && !"all".equalsIgnoreCase(ratingFilter)) {
            if ("good".equalsIgnoreCase(ratingFilter)) {
                sql.append("AND pr.rating >= 4 ");
            } else if ("bad".equalsIgnoreCase(ratingFilter)) {
                sql.append("AND pr.rating <= 3 ");
            } else {
                sql.append("AND pr.rating = ? ");
                params.add(Integer.parseInt(ratingFilter));
            }
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND pr.created_at >= ? ");
            params.add(Timestamp.valueOf(fromDate + " 00:00:00"));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND pr.created_at <= ? ");
            params.add(Timestamp.valueOf(toDate + " 23:59:59"));
        }
        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND pr.status = ? ");
            params.add(status);
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Lấy các đánh giá trong ngày hoặc gần nhất cho Dashboard
    public List<ProductReview> getDashboardReviews(String fromDate, String toDate, int limit) {
        List<ProductReview> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT TOP (" + limit + ") pr.*, u.full_name AS reviewer_name, p.product_name, mu.full_name AS moderator_name, ru.full_name AS replier_name " +
            "FROM ProductReview pr " +
            "JOIN [User] u ON pr.user_id = u.user_id " +
            "JOIN Product p ON pr.product_id = p.product_id " +
            "LEFT JOIN [User] mu ON pr.moderated_by = mu.user_id " +
            "LEFT JOIN [User] ru ON pr.replied_by = ru.user_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND pr.created_at >= ? ");
            params.add(Timestamp.valueOf(fromDate + " 00:00:00"));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND pr.created_at <= ? ");
            params.add(Timestamp.valueOf(toDate + " 23:59:59"));
        }
        sql.append("ORDER BY pr.created_at DESC");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
}

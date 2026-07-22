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
        String sql = "INSERT INTO ProductReview (product_id, user_id, rating, comment, status, created_at) VALUES (?, ?, ?, ?, 'approved', GETDATE())";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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

    public ProductReview getReviewByUserAndProduct(int userId, int productId) {
        String sql = "SELECT pr.*, u.full_name AS reviewer_name, p.product_name, mu.full_name AS moderator_name, ru.full_name AS replier_name " +
                     "FROM ProductReview pr " +
                     "JOIN [User] u ON pr.user_id = u.user_id " +
                     "JOIN Product p ON pr.product_id = p.product_id " +
                     "LEFT JOIN [User] mu ON pr.moderated_by = mu.user_id " +
                     "LEFT JOIN [User] ru ON pr.replied_by = ru.user_id " +
                     "WHERE pr.user_id = ? AND pr.product_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveOrUpdateReview(int productId, int userId, int rating, String comment) {
        ProductReview existing = getReviewByUserAndProduct(userId, productId);
        if (existing != null) {
            String sql = "UPDATE ProductReview SET rating = ?, comment = ?, created_at = GETDATE(), status = 'approved' WHERE review_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
                ps.setInt(1, rating);
                ps.setString(2, comment);
                ps.setInt(3, existing.getReviewId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO ProductReview (product_id, user_id, rating, comment, status, created_at) VALUES (?, ?, ?, ?, 'approved', GETDATE())";
            try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
                ps.setInt(1, productId);
                ps.setInt(2, userId);
                ps.setInt(3, rating);
                ps.setString(4, comment);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
     // admin , staff comment
    public boolean replyToReview(int reviewId, String replyContent, int replierId) {
        String sql = "UPDATE ProductReview SET reply_content = ?, replied_by = ?, replied_at = GETDATE() WHERE review_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
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

    public List<ProductReview> getApprovedReviewsByProductId(int productId) {
        List<ProductReview> list = new ArrayList<>();
        String sql = "SELECT pr.*, u.full_name AS reviewer_name, p.product_name, mu.full_name AS moderator_name, ru.full_name AS replier_name " +
                     "FROM ProductReview pr " +
                     "JOIN [User] u ON pr.user_id = u.user_id " +
                     "JOIN Product p ON pr.product_id = p.product_id " +
                     "LEFT JOIN [User] mu ON pr.moderated_by = mu.user_id " +
                     "LEFT JOIN [User] ru ON pr.replied_by = ru.user_id " +
                     "WHERE pr.product_id = ? AND pr.status = 'approved' " +
                     "ORDER BY pr.created_at DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
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

    public boolean insertReview(int productId, int userId, int rating, String comment, String status) {
        String sql = "INSERT INTO ProductReview (product_id, user_id, rating, comment, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setString(5, status);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, int[]> getDailyRatingStats(String fromDate, String toDate) {
        Map<String, int[]> stats = new LinkedHashMap<>();
        
        if (fromDate == null || fromDate.isEmpty()) {
            fromDate = java.time.LocalDate.now().minusDays(30).toString();
        }
        if (toDate == null || toDate.isEmpty()) {
            toDate = java.time.LocalDate.now().toString();
        }
        
        String sql = "SELECT CONVERT(VARCHAR(10), created_at, 120) AS review_date, rating, COUNT(*) AS cnt " +
                     "FROM ProductReview " +
                     "WHERE created_at >= ? AND created_at <= ? " +
                     "GROUP BY CONVERT(VARCHAR(10), created_at, 120), rating " +
                     "ORDER BY review_date ASC";
                     
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(fromDate + " 00:00:00"));
            ps.setTimestamp(2, Timestamp.valueOf(toDate + " 23:59:59"));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String date = rs.getString("review_date");
                    int rating = rs.getInt("rating");
                    int count = rs.getInt("cnt");
                    
                    if (!stats.containsKey(date)) {
                        stats.put(date, new int[5]); // [1*, 2*, 3*, 4*, 5*]
                    }
                    if (rating >= 1 && rating <= 5) {
                        stats.get(date)[rating - 1] = count;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, int[]> getProductRatingStats(String fromDate, String toDate) {
        Map<String, int[]> stats = new LinkedHashMap<>();
        
        if (fromDate == null || fromDate.isEmpty()) {
            fromDate = java.time.LocalDate.now().minusDays(30).toString();
        }
        if (toDate == null || toDate.isEmpty()) {
            toDate = java.time.LocalDate.now().toString();
        }
        
        String sql = "SELECT p.product_name, pr.rating, COUNT(*) AS cnt " +
                     "FROM ProductReview pr " +
                     "JOIN Product p ON pr.product_id = p.product_id " +
                     "WHERE pr.created_at >= ? AND pr.created_at <= ? " +
                     "GROUP BY p.product_name, pr.rating " +
                     "ORDER BY p.product_name ASC";
                     
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(fromDate + " 00:00:00"));
            ps.setTimestamp(2, Timestamp.valueOf(toDate + " 23:59:59"));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("product_name");
                    int rating = rs.getInt("rating");
                    int count = rs.getInt("cnt");
                    
                    if (!stats.containsKey(name)) {
                        stats.put(name, new int[5]); // [1*, 2*, 3*, 4*, 5*]
                    }
                    if (rating >= 1 && rating <= 5) {
                        stats.get(name)[rating - 1] = count;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Map<String, Object>> searchProductAverageRating(String query) {
        List<Map<String, Object>> resultList = new ArrayList<>();
        String sql = "SELECT " +
                     "  p.product_id, " +
                     "  p.product_name, " +
                     "  AVG(CAST(pr.rating AS DECIMAL(3,2))) AS avg_rating, " +
                     "  COUNT(pr.review_id) AS total_reviews, " +
                     "  SUM(CASE WHEN pr.rating = 5 THEN 1 ELSE 0 END) AS star5, " +
                     "  SUM(CASE WHEN pr.rating = 4 THEN 1 ELSE 0 END) AS star4, " +
                     "  SUM(CASE WHEN pr.rating = 3 THEN 1 ELSE 0 END) AS star3, " +
                     "  SUM(CASE WHEN pr.rating = 2 THEN 1 ELSE 0 END) AS star2, " +
                     "  SUM(CASE WHEN pr.rating = 1 THEN 1 ELSE 0 END) AS star1 " +
                     "FROM Product p " +
                     "LEFT JOIN ProductReview pr ON p.product_id = pr.product_id " +
                     "WHERE p.product_name LIKE ? " +
                     "GROUP BY p.product_id, p.product_name " +
                     "ORDER BY total_reviews DESC, p.product_name ASC";
                     
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, "%" + query + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("productId", rs.getInt("product_id"));
                    map.put("productName", rs.getString("product_name"));
                    map.put("avgRating", rs.getObject("avg_rating") != null ? rs.getDouble("avg_rating") : 0.0);
                    map.put("totalReviews", rs.getInt("total_reviews"));
                    map.put("star5", rs.getInt("star5"));
                    map.put("star4", rs.getInt("star4"));
                    map.put("star3", rs.getInt("star3"));
                    map.put("star2", rs.getInt("star2"));
                    map.put("star1", rs.getInt("star1"));
                    resultList.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultList;
    }
}

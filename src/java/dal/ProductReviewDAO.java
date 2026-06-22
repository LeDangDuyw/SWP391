package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductReview;

public class ProductReviewDAO extends DBContext {
    private Connection cnn;
    private PreparedStatement ps;
    private ResultSet rs;

    public ProductReviewDAO() {
        cnn = super.connection;
    }

    public List<ProductReview> getApprovedReviewsByProductId(int productId) {
        List<ProductReview> list = new ArrayList<>();
        try {
            // Retrieve reviews joined with the User table to display full name
            String sql = "SELECT r.*, u.full_name FROM ProductReview r " +
                         "JOIN [User] u ON r.user_id = u.user_id " +
                         "WHERE r.product_id = ? AND r.status = 'approved' " +
                         "ORDER BY r.created_at DESC";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, productId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ProductReview review = new ProductReview();
                review.setReviewId(rs.getInt("review_id"));
                review.setProductId(rs.getInt("product_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setStatus(rs.getString("status"));
                
                int modBy = rs.getInt("moderated_by");
                review.setModeratedBy(rs.wasNull() ? null : modBy);
                review.setModeratedAt(rs.getTimestamp("moderated_at"));
                
                review.setUserFullName(rs.getString("full_name"));
                
                list.add(review);
            }
        } catch (Exception e) {
            System.out.println("getApprovedReviewsByProductId error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertReview(int productId, int userId, int rating, String comment, String status) {
        try {
            String sql = "INSERT INTO ProductReview (product_id, user_id, rating, comment, status, created_at) " +
                         "VALUES (?, ?, ?, ?, ?, GETDATE())";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setString(5, status);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("insertReview error: " + e.getMessage());
        }
        return false;
    }
}

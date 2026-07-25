package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Wishlist;

/*
 * Name: WishlistDAO.java
 * @Author: LUCTV
 * Date: [24/07/2026]
 * Version: 1.0
 * Description: Data Access Object xử lý các truy vấn liên quan đến danh sách yêu thích của khách hàng.
 */
public class WishlistDAO extends DBContext {
    private Connection cnn;

    public WishlistDAO() {
        this.cnn = super.connection;
    }

    private void checkConnection() throws SQLException {
        if (cnn == null || cnn.isClosed()) {
            this.cnn = getConnection();
        }
    }

    /*
     * Name: addToWishlist
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Thêm một sản phẩm vào danh sách yêu thích của người dùng.
     */
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT INTO Wishlist (user_id, product_id) VALUES (?, ?)";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            // Might fail if already exists due to UNIQUE constraint
            System.err.println("WishlistDAO.addToWishlist Error: " + e.getMessage());
            return false;
        }
    }

    /*
     * Name: removeFromWishlist
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Xóa một sản phẩm khỏi danh sách yêu thích của người dùng.
     */
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM Wishlist WHERE user_id = ? AND product_id = ?";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("WishlistDAO.removeFromWishlist Error: " + e.getMessage());
            return false;
        }
    }

    /*
     * Name: isWishlisted
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Kiểm tra xem sản phẩm đã nằm trong danh sách yêu thích của người dùng hay chưa.
     */
    public boolean isWishlisted(int userId, int productId) {
        String sql = "SELECT 1 FROM Wishlist WHERE user_id = ? AND product_id = ?";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }
        } catch (SQLException e) {
            System.err.println("WishlistDAO.isWishlisted Error: " + e.getMessage());
            return false;
        }
    }

    /*
     * Name: getWishlistCount
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Đếm số lượng sản phẩm trong danh sách yêu thích của người dùng.
     */
    public int getWishlistCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Wishlist WHERE user_id = ?";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("WishlistDAO.getWishlistCount Error: " + e.getMessage());
        }
        return 0;
    }

    /*
     * Name: getWishlistByUserId
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Lấy danh sách sản phẩm yêu thích kèm thông tin chi tiết (thương hiệu, danh mục, giá thấp nhất, tổng tồn kho).
     */
    public List<Wishlist> getWishlistByUserId(int userId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.user_id, w.product_id, w.created_at, "
                   + "       p.product_name, p.thumbnail, b.brand_name, c.category_name, "
                   + "       MIN(pv.selling_price) AS min_price, "
                   + "       ISNULL(SUM(inv.available_quantity), 0) AS total_stock "
                   + "FROM Wishlist w "
                   + "JOIN Product p ON w.product_id = p.product_id "
                   + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                   + "LEFT JOIN Category c ON p.category_id = c.category_id "
                   + "LEFT JOIN ProductVariant pv ON p.product_id = pv.product_id AND pv.status = 'active' "
                   + "LEFT JOIN Inventory inv ON pv.variant_id = inv.variant_id "
                   + "WHERE w.user_id = ? "
                   + "GROUP BY w.wishlist_id, w.user_id, w.product_id, w.created_at, p.product_name, p.thumbnail, b.brand_name, c.category_name "
                   + "ORDER BY w.created_at DESC";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Wishlist item = new Wishlist();
                        item.setWishlistId(rs.getInt("wishlist_id"));
                        item.setUserId(rs.getInt("user_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setCreatedAt(rs.getTimestamp("created_at"));
                        item.setProductName(rs.getString("product_name"));
                        item.setThumbnail(rs.getString("thumbnail"));
                        item.setBrandName(rs.getString("brand_name"));
                        item.setCategoryName(rs.getString("category_name"));
                        item.setPrice(rs.getDouble("min_price"));
                        item.setStockQuantity(rs.getInt("total_stock"));
                        list.add(item);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("WishlistDAO.getWishlistByUserId Error: " + e.getMessage());
        }
        return list;
    }
}

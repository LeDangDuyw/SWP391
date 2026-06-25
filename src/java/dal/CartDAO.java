package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

public class CartDAO extends DBContext {
    private Connection cnn;

    public CartDAO() {
        this.cnn = super.connection;
    }

    private void checkConnection() throws SQLException {
        if (cnn == null || cnn.isClosed()) {
            this.cnn = getConnection();
        }
    }

    public int getCartIdByUserId(int userId) throws SQLException {
        checkConnection();
        String selectSql = "SELECT cart_id FROM [Cart] WHERE user_id = ?";
        try (PreparedStatement ps = cnn.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cart_id");
                }
            }
        }

        String insertSql = "INSERT INTO [Cart] (user_id) VALUES (?)";
        try (PreparedStatement ps = cnn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create cart for user ID: " + userId);
    }

    public List<CartItem> getCart(int userId) {
        List<CartItem> list = new ArrayList<>();
        try {
            checkConnection();
            String sql = "SELECT pv.variant_id, pv.product_id, p.product_name, pv.variant_name, p.thumbnail, pv.selling_price, p.warranty_period, isnull(inv.available_quantity, 0) AS available_quantity, ci.quantity " +
                         "FROM [CartItem] ci " +
                         "JOIN [Cart] c ON ci.cart_id = c.cart_id " +
                         "JOIN [ProductVariant] pv ON ci.variant_id = pv.variant_id " +
                         "JOIN [Product] p ON pv.product_id = p.product_id " +
                         "LEFT JOIN [Inventory] inv ON pv.variant_id = inv.variant_id " +
                         "WHERE c.user_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int variantId = rs.getInt("variant_id");
                        int productId = rs.getInt("product_id");
                        String productName = rs.getString("product_name");
                        String variantName = rs.getString("variant_name");
                        String thumbnail = rs.getString("thumbnail");
                        BigDecimal unitPrice = rs.getBigDecimal("selling_price");
                        int availableQuantity = rs.getInt("available_quantity");
                        int quantity = rs.getInt("quantity");
                        int warrantyPeriod = rs.getInt("warranty_period");
 
                        CartItem item = new CartItem(
                                variantId,
                                productId,
                                productName,
                                variantName,
                                thumbnail,
                                unitPrice,
                                quantity,
                                availableQuantity
                        );
                        item.setWarrantyPeriod(warrantyPeriod);
                        list.add(item);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("CartDAO getCart Error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public void addToCart(int userId, int variantId, int quantity) {
        try {
            checkConnection();
            int cartId = getCartIdByUserId(userId);
            
            // Check available quantity in inventory
            int availableQty = 0;
            String invSql = "SELECT isnull(available_quantity, 0) FROM [Inventory] WHERE variant_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(invSql)) {
                ps.setInt(1, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        availableQty = rs.getInt(1);
                    }
                }
            }

            // Check if item already in cart
            String checkSql = "SELECT cart_item_id, quantity FROM [CartItem] WHERE cart_id = ? AND variant_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(checkSql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int cartItemId = rs.getInt("cart_item_id");
                        int currentQty = rs.getInt("quantity");
                        int newQty = Math.min(currentQty + quantity, availableQty);
                        
                        String updateSql = "UPDATE [CartItem] SET quantity = ? WHERE cart_item_id = ?";
                        try (PreparedStatement ups = cnn.prepareStatement(updateSql)) {
                            ups.setInt(1, newQty);
                            ups.setInt(2, cartItemId);
                            ups.executeUpdate();
                        }
                        return;
                    }
                }
            }

            // Insert new item
            int finalQty = Math.min(quantity, availableQty);
            if (finalQty > 0) {
                String insertSql = "INSERT INTO [CartItem] (cart_id, variant_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement ps = cnn.prepareStatement(insertSql)) {
                    ps.setInt(1, cartId);
                    ps.setInt(2, variantId);
                    ps.setInt(3, finalQty);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            System.out.println("CartDAO addToCart Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateQuantity(int userId, int variantId, int quantity) {
        try {
            checkConnection();
            int cartId = getCartIdByUserId(userId);

            // Check available quantity
            int availableQty = 0;
            String invSql = "SELECT isnull(available_quantity, 0) FROM [Inventory] WHERE variant_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(invSql)) {
                ps.setInt(1, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        availableQty = rs.getInt(1);
                    }
                }
            }

            int finalQty = Math.max(1, Math.min(quantity, availableQty));

            String updateSql = "UPDATE [CartItem] SET quantity = ? WHERE cart_id = ? AND variant_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(updateSql)) {
                ps.setInt(1, finalQty);
                ps.setInt(2, cartId);
                ps.setInt(3, variantId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("CartDAO updateQuantity Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void removeItem(int userId, int variantId) {
        try {
            checkConnection();
            int cartId = getCartIdByUserId(userId);

            String deleteSql = "DELETE FROM [CartItem] WHERE cart_id = ? AND variant_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(deleteSql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, variantId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("CartDAO removeItem Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void clearCart(int userId) {
        try {
            checkConnection();
            int cartId = getCartIdByUserId(userId);

            String deleteSql = "DELETE FROM [CartItem] WHERE cart_id = ?";
            try (PreparedStatement ps = cnn.prepareStatement(deleteSql)) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("CartDAO clearCart Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

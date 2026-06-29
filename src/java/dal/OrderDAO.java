package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;
import model.Order;

public class OrderDAO extends DBContext {
    private Connection cnn;
    private PreparedStatement ps;
    private ResultSet rs;

    public OrderDAO() {
        cnn = super.connection;
    }

    public Order insertOrder(BigDecimal totalAmount, BigDecimal shippingFee, String receiver, String phone, String address, Integer userId, Integer voucherId) {
        try {
            String sql = "INSERT INTO [Order] (total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, user_id, voucher_id) VALUES (?, ?, 'Pending', ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setBigDecimal(1, totalAmount);
            ps.setBigDecimal(2, shippingFee);
            ps.setString(3, receiver);
            ps.setString(4, phone);
            ps.setString(5, address);
            if (userId != null) {
                ps.setInt(6, userId);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            if (voucherId != null) {
                ps.setInt(7, voucherId);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    String orderCode = "UNILAP_" + orderId;
                    
                    // Update order_code
                    String updateSql = "UPDATE [Order] SET order_code = ? WHERE order_id = ?";
                    try (PreparedStatement ups = cnn.prepareStatement(updateSql)) {
                        ups.setString(1, orderCode);
                        ups.setInt(2, orderId);
                        ups.executeUpdate();
                    }
                    
                    Order order = new Order();
                    order.setOrderId(orderId);
                    order.setTotalAmount(totalAmount);
                    order.setShippingFee(shippingFee);
                    order.setOrderStatus("Pending");
                    order.setShippingReceiver(receiver);
                    order.setShippingPhone(phone);
                    order.setShippingAddress(address);
                    order.setOrderCode(orderCode);
                    order.setUserId(userId);
                    order.setVoucherId(voucherId);
                    return order;
                }
            }
        } catch (Exception e) {
            System.out.println("insertOrder error: " + e.getMessage());
        }
        return null;
    }

    public Order insertOrder(BigDecimal totalAmount, String receiver, String phone, String address, Integer userId) {
        return insertOrder(totalAmount, BigDecimal.ZERO, receiver, phone, address, userId, null);
    }

    public Order getOrderByCode(String orderCode) {
        try {
            String sql = "SELECT order_id, total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, order_code, user_id, voucher_id FROM [Order] WHERE order_code = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, orderCode);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setShippingReceiver(rs.getString("shipping_receiver"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setOrderCode(rs.getString("order_code"));
                int uId = rs.getInt("user_id");
                order.setUserId(rs.wasNull() ? null : uId);
                int vId = rs.getInt("voucher_id");
                order.setVoucherId(rs.wasNull() ? null : vId);
                return order;
            }
        } catch (Exception e) {
            System.out.println("getOrderByCode error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateOrderStatus(String orderCode, String status) {
        try {
            String sql = "UPDATE [Order] SET order_status = ? WHERE order_code = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, orderCode);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("updateOrderStatus error: " + e.getMessage());
        }
        return false;
    }

    public boolean insertOrderDetail(int orderId, int variantId, int quantity, BigDecimal unitPrice) {
        try {
            String sql = "INSERT INTO OrderDetail (order_id, variant_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement detailPs = cnn.prepareStatement(sql)) {
                detailPs.setInt(1, orderId);
                detailPs.setInt(2, variantId);
                detailPs.setInt(3, quantity);
                detailPs.setBigDecimal(4, unitPrice);
                detailPs.executeUpdate();
            }
            
            // Decrement stock in Inventory
            String updateInventorySql = "UPDATE [Inventory] SET available_quantity = available_quantity - ? WHERE variant_id = ?";
            try (PreparedStatement invPs = cnn.prepareStatement(updateInventorySql)) {
                invPs.setInt(1, quantity);
                invPs.setInt(2, variantId);
                invPs.executeUpdate();
            }
            
            return true;
        } catch (Exception e) {
            System.out.println("insertOrderDetail error: " + e.getMessage());
            return false;
        }
    }

    public boolean cancelOrder(String orderCode) {
        try {
            // Get order details first
            String selectOrderSql = "SELECT order_id FROM [Order] WHERE order_code = ?";
            int orderId = -1;
            try (PreparedStatement selectPs = cnn.prepareStatement(selectOrderSql)) {
                selectPs.setString(1, orderCode);
                try (ResultSet selectRs = selectPs.executeQuery()) {
                    if (selectRs.next()) {
                        orderId = selectRs.getInt("order_id");
                    }
                }
            }
            if (orderId == -1) return false;

            // Revert stock for each detail item
            String selectDetailsSql = "SELECT variant_id, quantity FROM OrderDetail WHERE order_id = ?";
            try (PreparedStatement detailsPs = cnn.prepareStatement(selectDetailsSql)) {
                detailsPs.setInt(1, orderId);
                try (ResultSet detailsRs = detailsPs.executeQuery()) {
                    while (detailsRs.next()) {
                        int variantId = detailsRs.getInt("variant_id");
                        int quantity = detailsRs.getInt("quantity");
                        
                        // Increment stock in Inventory
                        String updateInventorySql = "UPDATE [Inventory] SET available_quantity = available_quantity + ? WHERE variant_id = ?";
                        try (PreparedStatement invPs = cnn.prepareStatement(updateInventorySql)) {
                            invPs.setInt(1, quantity);
                            invPs.setInt(2, variantId);
                            invPs.executeUpdate();
                        }
                    }
                }
            }

            // Update order status to 'Cancelled'
            String updateOrderSql = "UPDATE [Order] SET order_status = 'Cancelled' WHERE order_id = ?";
            try (PreparedStatement updatePs = cnn.prepareStatement(updateOrderSql)) {
                updatePs.setInt(1, orderId);
                updatePs.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            System.out.println("cancelOrder error: " + e.getMessage());
            return false;
        }
    }

    public List<CartItem> getOrderDetailsForCart(int orderId) {
        List<CartItem> list = new ArrayList<>();
        try {
            String sql = "SELECT od.variant_id, pv.product_id, p.product_name, pv.variant_name, p.thumbnail, od.unit_price, od.quantity, isnull(inv.available_quantity, 0) AS available_quantity, p.warranty_period " +
                         "FROM OrderDetail od " +
                         "JOIN [ProductVariant] pv ON od.variant_id = pv.variant_id " +
                         "JOIN [Product] p ON pv.product_id = p.product_id " +
                         "LEFT JOIN [Inventory] inv ON pv.variant_id = inv.variant_id " +
                         "WHERE od.order_id = ?";
            try (PreparedStatement detailsPs = cnn.prepareStatement(sql)) {
                detailsPs.setInt(1, orderId);
                try (ResultSet detailsRs = detailsPs.executeQuery()) {
                    while (detailsRs.next()) {
                        int variantId = detailsRs.getInt("variant_id");
                        int productId = detailsRs.getInt("product_id");
                        String productName = detailsRs.getString("product_name");
                        String variantName = detailsRs.getString("variant_name");
                        String thumbnail = detailsRs.getString("thumbnail");
                        BigDecimal unitPrice = detailsRs.getBigDecimal("unit_price");
                        int availableQuantity = detailsRs.getInt("available_quantity");
                        int quantity = detailsRs.getInt("quantity");
                        int warrantyPeriod = detailsRs.getInt("warranty_period");

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
            System.out.println("getOrderDetailsForCart error: " + e.getMessage());
        }
        return list;
    }
}

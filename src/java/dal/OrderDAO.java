package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.Order;

public class OrderDAO extends DBContext {
    private Connection cnn;
    private PreparedStatement ps;
    private ResultSet rs;

    public OrderDAO() {
        cnn = super.connection;
    }

    public Order insertOrder(BigDecimal totalAmount, String receiver, String phone, String address, Integer userId) {
        try {
            String sql = "INSERT INTO [Order] (total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, user_id) VALUES (?, 0, 'Pending', ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setBigDecimal(1, totalAmount);
            ps.setString(2, receiver);
            ps.setString(3, phone);
            ps.setString(4, address);
            if (userId != null) {
                ps.setInt(5, userId);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
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
                    order.setShippingFee(BigDecimal.ZERO);
                    order.setOrderStatus("Pending");
                    order.setShippingReceiver(receiver);
                    order.setShippingPhone(phone);
                    order.setShippingAddress(address);
                    order.setOrderCode(orderCode);
                    order.setUserId(userId);
                    return order;
                }
            }
        } catch (Exception e) {
            System.out.println("insertOrder error: " + e.getMessage());
        }
        return null;
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
            return true;
        } catch (Exception e) {
            System.out.println("insertOrderDetail error: " + e.getMessage());
            return false;
        }
    }
}

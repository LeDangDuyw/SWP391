package dal;

import java.math.BigDecimal;
import java.util.List;
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

    public Order insertOrder(BigDecimal totalAmount, BigDecimal shippingFee, String receiver, String phone, String address, Integer userId, Integer voucherId) {
        return insertOrder(totalAmount, shippingFee, receiver, phone, address, userId, voucherId, "HOME_DELIVERY");
    }

    public Order insertOrder(BigDecimal totalAmount, BigDecimal shippingFee, String receiver, String phone, String address, Integer userId, Integer voucherId, String shippingMethod) {
        try {
            if (shippingMethod == null || shippingMethod.trim().isEmpty()) {
                shippingMethod = "HOME_DELIVERY";
            }
            String sql = "INSERT INTO [Order] (total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, user_id, voucher_id, shipping_method, completed_at) VALUES (?, ?, 'Pending', ?, ?, ?, ?, ?, ?, GETDATE())";
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
            ps.setString(8, shippingMethod);
            
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

                    if (voucherId != null) {
                        String updateCampaignSql = "UPDATE [Campaign] SET used_count = ISNULL(used_count, 0) + 1 WHERE campaign_id = ? OR voucher_id = ?";
                        try (PreparedStatement cps = cnn.prepareStatement(updateCampaignSql)) {
                            cps.setInt(1, voucherId);
                            cps.setInt(2, voucherId);
                            cps.executeUpdate();
                        } catch (Exception e) {
                            System.out.println("Failed to update campaign used_count: " + e.getMessage());
                        }
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

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new java.util.ArrayList<>();
        try {
            String sql = "SELECT * FROM [Order] WHERE user_id = ? ORDER BY order_id DESC";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
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
                if (rs.getTimestamp("completed_at") != null) {
                    order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                }
                list.add(order);
            }
        } catch (Exception e) {
            System.out.println("getOrdersByUserId error: " + e.getMessage());
        }
        return list;
    }

    public List<model.OrderDetail> getOrderDetails(int orderId) {
        List<model.OrderDetail> list = new java.util.ArrayList<>();
        try {
            String sql = "SELECT od.*, p.product_name, pv.variant_name, pv.sku, p.thumbnail, pv.product_id " +
                         "FROM OrderDetail od " +
                         "JOIN ProductVariant pv ON od.variant_id = pv.variant_id " +
                         "JOIN Product p ON pv.product_id = p.product_id " +
                         "WHERE od.order_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                model.OrderDetail detail = new model.OrderDetail();
                detail.setOrderDetailId(rs.getInt("order_detail_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnitPrice(rs.getBigDecimal("unit_price"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setVariantId(rs.getInt("variant_id"));
                
                detail.setProductName(rs.getString("product_name"));
                detail.setVariantName(rs.getString("variant_name"));
                detail.setSku(rs.getString("sku"));
                detail.setThumbnail(rs.getString("thumbnail"));
                detail.setProductId(rs.getInt("product_id"));
                
                list.add(detail);
            }
        } catch (Exception e) {
            System.out.println("getOrderDetails error: " + e.getMessage());
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        try {
            String sql = "SELECT * FROM [Order] WHERE order_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, orderId);
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
                if (rs.getTimestamp("completed_at") != null) {
                    order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                }
                return order;
            }
        } catch (Exception e) {
            System.out.println("getOrderById error: " + e.getMessage());
        }
        return null;
    }
}

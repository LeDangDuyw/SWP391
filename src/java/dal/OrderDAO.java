/*
 * Name: OrderDAO
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý dữ liệu đơn hàng và giao dịch đặt hàng
 */
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
        try {
            String sql1 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'shipping_method') " +
                          "ALTER TABLE [Order] ADD shipping_method NVARCHAR(50) DEFAULT 'HOME_DELIVERY';";
            String sql2 = "UPDATE [Order] SET shipping_method = 'STORE_PICKUP' WHERE shipping_address LIKE N'%Nhận tại cửa hàng%' AND (shipping_method IS NULL OR shipping_method = 'HOME_DELIVERY');";
            String sql3 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'created_at') " +
                          "ALTER TABLE [Order] ADD created_at DATETIME NOT NULL DEFAULT GETDATE();";
            try (PreparedStatement ps1 = cnn.prepareStatement(sql1);
                 PreparedStatement ps2 = cnn.prepareStatement(sql2);
                 PreparedStatement ps3 = cnn.prepareStatement(sql3)) {
                ps1.executeUpdate();
                ps2.executeUpdate();
                ps3.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("OrderDAO Schema Update warning: " + e.getMessage());
        }
    }

    public Order insertOrder(BigDecimal totalAmount, BigDecimal shippingFee, String receiver, String phone, String address, Integer userId, Integer voucherId, String shippingMethod) {
        try {
            // Thực hiện câu lệnh SQL INSERT để lưu thông tin đơn hàng mới với trạng thái ban đầu là 'Pending'
            String sql = "INSERT INTO [Order] (total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, user_id, voucher_id, shipping_method) VALUES (?, ?, 'Pending', ?, ?, ?, ?, ?, ?)";
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
                    // Sinh mã code đơn hàng duy nhất theo định dạng UNILAP_ + ID tự tăng
                    String orderCode = "UNILAP_" + orderId;
                    
                    // Cập nhật lại cột order_code trong bảng Order
                    String updateSql = "UPDATE [Order] SET order_code = ? WHERE order_id = ?";
                    try (PreparedStatement ups = cnn.prepareStatement(updateSql)) {
                        ups.setString(1, orderCode);
                        ups.setInt(2, orderId);
                        ups.executeUpdate();
                    }
                    
                    // Trả về đối tượng Order mới vừa khởi tạo thành công
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
                    order.setShippingMethod(shippingMethod);
                    return order;
                }
            }
        } catch (Exception e) {
            System.out.println("insertOrder error: " + e.getMessage());
        }
        return null;
    }

    public Order insertOrder(BigDecimal totalAmount, BigDecimal shippingFee, String receiver, String phone, String address, Integer userId, Integer voucherId) {
        return insertOrder(totalAmount, shippingFee, receiver, phone, address, userId, voucherId, "HOME_DELIVERY");
    }

    public Order insertOrder(BigDecimal totalAmount, String receiver, String phone, String address, Integer userId) {
        return insertOrder(totalAmount, BigDecimal.ZERO, receiver, phone, address, userId, null);
    }

    public Order getOrderByCode(String orderCode) {
        try {
            String sql = "SELECT order_id, total_amount, shipping_fee, order_status, shipping_receiver, shipping_phone, shipping_address, order_code, user_id, voucher_id, shipping_method, created_at FROM [Order] WHERE order_code = ?";
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
                order.setShippingMethod(rs.getString("shipping_method"));
                if (rs.getTimestamp("created_at") != null) {
                    order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                return order;
            }
        } catch (Exception e) {
            System.out.println("getOrderByCode error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateOrderStatus(String orderCode, String status) {
        try {
            cnn.setAutoCommit(false);
            
            if ("cancelled".equalsIgnoreCase(status)) {
                // Get current status and orderId
                String getStatusSql = "SELECT order_id, order_status FROM [Order] WHERE order_code = ?";
                String currentStatus = "";
                int orderId = 0;
                try (PreparedStatement psGet = cnn.prepareStatement(getStatusSql)) {
                    psGet.setString(1, orderCode);
                    try (ResultSet rsGet = psGet.executeQuery()) {
                        if (rsGet.next()) {
                            orderId = rsGet.getInt("order_id");
                            currentStatus = rsGet.getString("order_status");
                        }
                    }
                }
                
                // Only refund if the order wasn't already cancelled
                if (orderId > 0 && !"cancelled".equalsIgnoreCase(currentStatus)) {
                    // Refund to [Inventory]
                    String refundInventorySql = "UPDATE i SET i.available_quantity = i.available_quantity + od.quantity " +
                                                 "FROM [Inventory] i " +
                                                 "JOIN OrderDetail od ON i.variant_id = od.variant_id " +
                                                 "WHERE od.order_id = ?";
                    try (PreparedStatement psRefund = cnn.prepareStatement(refundInventorySql)) {
                        psRefund.setInt(1, orderId);
                        psRefund.executeUpdate();
                    }
                }
            }
            
            String sql = "UPDATE [Order] SET order_status = ? WHERE order_code = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, orderCode);
            int rows = ps.executeUpdate();
            
            cnn.commit();
            return rows > 0;
        } catch (Exception e) {
            try {
                cnn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("updateOrderStatus error: " + e.getMessage());
        } finally {
            try {
                cnn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
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
            // Lấy danh sách toàn bộ các đơn hàng của một người dùng cụ thể, sắp xếp theo thứ tự mới nhất trước
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
                order.setShippingMethod(rs.getString("shipping_method"));
                if (rs.getTimestamp("created_at") != null) {
                    order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
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
            String sql = "SELECT od.*, p.product_id, p.product_name, pv.variant_name, pv.sku, p.thumbnail, p.warranty_period " +
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
                
                detail.setProductId(rs.getInt("product_id"));
                detail.setProductName(rs.getString("product_name"));
                detail.setVariantName(rs.getString("variant_name"));
                detail.setSku(rs.getString("sku"));
                detail.setThumbnail(rs.getString("thumbnail"));
                detail.setWarrantyPeriod(rs.getInt("warranty_period"));
                
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
                order.setShippingMethod(rs.getString("shipping_method"));
                if (rs.getTimestamp("created_at") != null) {
                    order.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                return order;
            }
        } catch (Exception e) {
            System.out.println("getOrderById error: " + e.getMessage());
        }
        return null;
    }
}

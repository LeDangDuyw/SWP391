package dal;

import model.InventoryItem;
import model.Order;
import model.OrderDetail;
import model.OrderItemSerial;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OutboundDAO extends DBContext {

    public OutboundDAO() {
        super();
        try {
            String sql1 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'shipping_partner') " +
                          "ALTER TABLE [Order] ADD shipping_partner NVARCHAR(100) NULL;";
            String sql2 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'tracking_number') " +
                          "ALTER TABLE [Order] ADD tracking_number NVARCHAR(100) NULL;";
            String sql3 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'invoice_path') " +
                          "ALTER TABLE [Order] ADD invoice_path NVARCHAR(255) NULL;";
            String sql4 = "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[Order]') AND name = 'invoice_email_sent') " +
                          "ALTER TABLE [Order] ADD invoice_email_sent INT DEFAULT 0;";
            String sql5 = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderLog') " +
                          "CREATE TABLE OrderLog (" +
                          "  log_id INT IDENTITY PRIMARY KEY," +
                          "  order_id INT NOT NULL," +
                          "  old_status VARCHAR(50) NULL," +
                          "  new_status VARCHAR(50) NOT NULL," +
                          "  action_by VARCHAR(100) NOT NULL," +
                          "  log_message NVARCHAR(500) NULL," +
                          "  created_at DATETIME DEFAULT GETDATE()" +
                          ");";
            try (PreparedStatement ps1 = connection.prepareStatement(sql1);
                 PreparedStatement ps2 = connection.prepareStatement(sql2);
                 PreparedStatement ps3 = connection.prepareStatement(sql3);
                 PreparedStatement ps4 = connection.prepareStatement(sql4);
                 PreparedStatement ps5 = connection.prepareStatement(sql5)) {
                ps1.executeUpdate();
                ps2.executeUpdate();
                ps3.executeUpdate();
                ps4.executeUpdate();
                ps5.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("OutboundDAO Schema Update warning: " + e.getMessage());
        }
    }

    public List<Order> getPendingOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE order_status IN ('Pending', 'processing') ORDER BY order_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
                
                if (rs.getTimestamp("completed_at") != null) {
                    order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                }
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalPendingOrders() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [Order] WHERE order_status IN ('Pending', 'processing')";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    public List<Order> getPendingOrders(int offset, int fetchSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE order_status IN ('Pending', 'processing') ORDER BY order_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, fetchSize);
            try (ResultSet rs = ps.executeQuery()) {
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
                    
                    if (rs.getTimestamp("completed_at") != null) {
                        order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                    }
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalOutboundHistory() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'Completed', 'cancelled', 'Cancelled')";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    public List<Order> getOutboundHistory() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'Completed', 'cancelled', 'Cancelled') ORDER BY completed_at DESC, order_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
                order.setShippingPartner(rs.getString("shipping_partner"));
                order.setTrackingNumber(rs.getString("tracking_number"));
                order.setInvoicePath(rs.getString("invoice_path"));
                order.setInvoiceEmailSent(rs.getInt("invoice_email_sent"));
                int uId = rs.getInt("user_id");
                order.setUserId(rs.wasNull() ? null : uId);
                if (rs.getTimestamp("completed_at") != null) {
                    order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                }
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOutboundHistory(int offset, int fetchSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'Completed', 'cancelled', 'Cancelled') ORDER BY completed_at DESC, order_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, fetchSize);
            try (ResultSet rs = ps.executeQuery()) {
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
                    order.setShippingPartner(rs.getString("shipping_partner"));
                    order.setTrackingNumber(rs.getString("tracking_number"));
                    order.setInvoicePath(rs.getString("invoice_path"));
                    order.setInvoiceEmailSent(rs.getInt("invoice_email_sent"));
                    int uId = rs.getInt("user_id");
                    order.setUserId(rs.wasNull() ? null : uId);
                    if (rs.getTimestamp("completed_at") != null) {
                        order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                    }
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM [Order] WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
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
                    order.setShippingPartner(rs.getString("shipping_partner"));
                    order.setTrackingNumber(rs.getString("tracking_number"));
                    order.setInvoicePath(rs.getString("invoice_path"));
                    order.setInvoiceEmailSent(rs.getInt("invoice_email_sent"));
                    int uId = rs.getInt("user_id");
                    order.setUserId(rs.wasNull() ? null : uId);
                    if (rs.getTimestamp("completed_at") != null) {
                        order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                    }
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateShippingDetails(int orderId, String partner, String trackingNumber) {
        String sql = "UPDATE [Order] SET shipping_partner = ?, tracking_number = ? WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, partner);
            ps.setString(2, trackingNumber);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.product_name, pv.variant_name, pv.sku, pv.thumbnail " +
                     "FROM OrderDetail od " +
                     "JOIN ProductVariant pv ON od.variant_id = pv.variant_id " +
                     "JOIN Product p ON pv.product_id = p.product_id " +
                     "WHERE od.order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setOrderDetailId(rs.getInt("order_detail_id"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setUnitPrice(rs.getBigDecimal("unit_price"));
                    detail.setOrderId(rs.getInt("order_id"));
                    detail.setVariantId(rs.getInt("variant_id"));
                    
                    detail.setProductName(rs.getString("product_name"));
                    detail.setVariantName(rs.getString("variant_name"));
                    detail.setSku(rs.getString("sku"));
                    detail.setThumbnail(rs.getString("thumbnail"));
                    
                    list.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<InventoryItem> getAvailableSerialsForVariant(int variantId) {
        List<InventoryItem> list = new ArrayList<>();
        String sql = "SELECT item_id, serial_number " +
                     "FROM InventoryItem " +
                     "WHERE variant_id = ? AND status = 'in_stock' " +
                     "ORDER BY item_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = new InventoryItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setSerialNumber(rs.getString("serial_number"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<InventoryItem> getAssignedSerialsForOrderDetail(int orderDetailId) {
        List<InventoryItem> list = new ArrayList<>();
        String sql = "SELECT i.* FROM InventoryItem i " +
                     "JOIN OrderItemSerial ois ON i.item_id = ois.item_id " +
                     "WHERE ois.order_detail_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderDetailId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = new InventoryItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setSerialNumber(rs.getString("serial_number"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // executeOutboundTransaction
    // Map<OrderDetailId, List<ItemId>> variantToItemIds
    public boolean executeOutboundTransaction(int orderId, Map<Integer, List<Integer>> orderDetailToItemIds) throws Exception {
        boolean success = false;
        try {
            connection.setAutoCommit(false);

            String updateInventorySql = "UPDATE InventoryItem SET status = 'sold', sold_date = GETDATE(), " +
                                        "warranty_expired_date = DATEADD(month, (SELECT p.warranty_period FROM Product p " +
                                        "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                                        "WHERE pv.variant_id = InventoryItem.variant_id), GETDATE()) " +
                                        "WHERE item_id = ? AND status = 'in_stock' " +
                                        "AND variant_id = (SELECT variant_id FROM OrderDetail WHERE order_detail_id = ?)";
            
            String insertSerialSql = "INSERT INTO OrderItemSerial (order_detail_id, item_id, assigned_at) VALUES (?, ?, GETDATE())";
            
            try (PreparedStatement psInv = connection.prepareStatement(updateInventorySql);
                 PreparedStatement psSerial = connection.prepareStatement(insertSerialSql)) {
                
                for (Map.Entry<Integer, List<Integer>> entry : orderDetailToItemIds.entrySet()) {
                    int orderDetailId = entry.getKey();
                    List<Integer> itemIds = entry.getValue();
                    
                    for (Integer itemId : itemIds) {
                        // 1. Update InventoryItem (Race condition check & variant validation check)
                        psInv.setInt(1, itemId);
                        psInv.setInt(2, orderDetailId);
                        int affected = psInv.executeUpdate();
                        if (affected == 0) {
                            throw new Exception("Lỗi: Serial có ID " + itemId + " không tồn tại, sai loại sản phẩm, hoặc đã bị xuất kho bởi người khác!");
                        }
                        
                        // 2. Insert OrderItemSerial
                        psSerial.setInt(1, orderDetailId);
                        psSerial.setInt(2, itemId);
                        psSerial.executeUpdate();
                    }
                }
            }

            // 4. Update Order status to 'shipped'
            String updateOrderSql = "UPDATE [Order] SET order_status = 'shipped', completed_at = GETDATE() WHERE order_id = ?";
            try (PreparedStatement psOrder = connection.prepareStatement(updateOrderSql)) {
                psOrder.setInt(1, orderId);
                psOrder.executeUpdate();
            }

            connection.commit();
            success = true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e; // Rethrow to show message in UI
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return success;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        try {
            connection.setAutoCommit(false);
            
            // Check state machine bypass: cannot set to delivered or Completed if order is not fulfilled (no serials assigned)
            if ("delivered".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
                String checkSerialSql = "SELECT COUNT(*) FROM OrderItemSerial ois " +
                                        "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id " +
                                        "WHERE od.order_id = ?";
                try (PreparedStatement psCheck = connection.prepareStatement(checkSerialSql)) {
                    psCheck.setInt(1, orderId);
                    try (ResultSet rsCheck = psCheck.executeQuery()) {
                        if (rsCheck.next() && rsCheck.getInt(1) == 0) {
                            connection.rollback();
                            return false; // Cannot complete/deliver without serial assignment!
                        }
                    }
                }
            }
            
            if ("cancelled".equalsIgnoreCase(status)) {
                // Get current status
                String getStatusSql = "SELECT order_status FROM [Order] WHERE order_id = ?";
                String currentStatus = "";
                try (PreparedStatement ps = connection.prepareStatement(getStatusSql)) {
                    ps.setInt(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentStatus = rs.getString("order_status");
                        }
                    }
                }
                
                // Do not allow cancellation if order is already delivered or completed
                if ("delivered".equalsIgnoreCase(currentStatus) || "Completed".equalsIgnoreCase(currentStatus)) {
                    connection.rollback();
                    return false;
                }
                
                // If not already cancelled, proceed with reversion
                if (!"cancelled".equalsIgnoreCase(currentStatus)) {
                    if ("shipped".equalsIgnoreCase(currentStatus)) {
                        // Revert inventory items to in_stock
                        String revertInvSql = "UPDATE InventoryItem SET status = 'in_stock', sold_date = NULL, warranty_expired_date = NULL " +
                                              "WHERE item_id IN (SELECT item_id FROM OrderItemSerial ois " +
                                              "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id " +
                                              "WHERE od.order_id = ?)";
                        try (PreparedStatement psRevert = connection.prepareStatement(revertInvSql)) {
                            psRevert.setInt(1, orderId);
                            psRevert.executeUpdate();
                        }
                        
                        // Delete order item serial entries
                        String deleteSerialSql = "DELETE FROM OrderItemSerial WHERE order_detail_id IN (SELECT order_detail_id FROM OrderDetail WHERE order_id = ?)";
                        try (PreparedStatement psDelete = connection.prepareStatement(deleteSerialSql)) {
                            psDelete.setInt(1, orderId);
                            psDelete.executeUpdate();
                        }
                    }
                    
                    // Revert stock count in Inventory table for the variants in this order
                    String incrementInventorySql = "UPDATE [Inventory] " +
                                                   "SET available_quantity = [Inventory].available_quantity + od.quantity " +
                                                   "FROM [Inventory] " +
                                                   "JOIN OrderDetail od ON [Inventory].variant_id = od.variant_id " +
                                                   "WHERE od.order_id = ?";
                    try (PreparedStatement psInc = connection.prepareStatement(incrementInventorySql)) {
                        psInc.setInt(1, orderId);
                        psInc.executeUpdate();
                    }
                }
            }
            
            // Update order status
            String updateSql = "UPDATE [Order] SET order_status = ? WHERE order_id = ?";
            if ("delivered".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
                updateSql = "UPDATE [Order] SET order_status = ?, completed_at = GETDATE() WHERE order_id = ?";
            }
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setString(1, status);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }
            
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY order_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
                order.setShippingPartner(rs.getString("shipping_partner"));
                order.setTrackingNumber(rs.getString("tracking_number"));
                order.setInvoicePath(rs.getString("invoice_path"));
                order.setInvoiceEmailSent(rs.getInt("invoice_email_sent"));
                int uId = rs.getInt("user_id");
                order.setUserId(rs.wasNull() ? null : uId);
                if (rs.getTimestamp("completed_at") != null) {
                    order.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime());
                }
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateInvoiceDetails(int orderId, String invoicePath, int emailSentStatus) {
        String sql = "UPDATE [Order] SET invoice_path = ?, invoice_email_sent = ? WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, invoicePath);
            ps.setInt(2, emailSentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void addOrderLog(int orderId, String oldStatus, String newStatus, String actionBy, String message) {
        String sql = "INSERT INTO OrderLog (order_id, old_status, new_status, action_by, log_message) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, oldStatus);
            ps.setString(3, newStatus);
            ps.setString(4, actionBy);
            ps.setString(5, message);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<model.OrderLog> getOrderLogs(int orderId) {
        List<model.OrderLog> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderLog WHERE order_id = ? ORDER BY log_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.OrderLog log = new model.OrderLog();
                    log.setLogId(rs.getInt("log_id"));
                    log.setOrderId(rs.getInt("order_id"));
                    log.setOldStatus(rs.getString("old_status"));
                    log.setNewStatus(rs.getString("new_status"));
                    log.setActionBy(rs.getString("action_by"));
                    log.setLogMessage(rs.getString("log_message"));
                    if (rs.getTimestamp("created_at") != null) {
                        log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getCustomerEmailByUserId(int userId) {
        String sql = "SELECT email FROM [User] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("email");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

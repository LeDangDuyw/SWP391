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

    public List<Order> getOutboundHistory() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'Completed') ORDER BY completed_at DESC, order_id DESC";
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

    public List<InventoryItem> getAvailableImeisForVariant(int variantId) {
        List<InventoryItem> list = new ArrayList<>();
        String sql = "SELECT item_id, serial_number, imei, barcode " +
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
                    item.setImei(rs.getString("imei"));
                    item.setBarcode(rs.getString("barcode"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<InventoryItem> getAssignedImeisForOrderDetail(int orderDetailId) {
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
                    item.setImei(rs.getString("imei"));
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
                                        "WHERE item_id = ? AND status = 'in_stock'";
            
            String insertSerialSql = "INSERT INTO OrderItemSerial (order_detail_id, item_id, assigned_at) VALUES (?, ?, GETDATE())";
            
            try (PreparedStatement psInv = connection.prepareStatement(updateInventorySql);
                 PreparedStatement psSerial = connection.prepareStatement(insertSerialSql)) {
                
                for (Map.Entry<Integer, List<Integer>> entry : orderDetailToItemIds.entrySet()) {
                    int orderDetailId = entry.getKey();
                    List<Integer> itemIds = entry.getValue();
                    
                    for (Integer itemId : itemIds) {
                        // 1. Update InventoryItem (Race condition check)
                        psInv.setInt(1, itemId);
                        int affected = psInv.executeUpdate();
                        if (affected == 0) {
                            throw new Exception("Lỗi: IMEI/Serial có ID " + itemId + " không tồn tại hoặc đã bị xuất kho bởi người khác!");
                        }
                        
                        // 2. Insert OrderItemSerial
                        psSerial.setInt(1, orderDetailId);
                        psSerial.setInt(2, itemId);
                        psSerial.executeUpdate();
                    }
                }
            }

            // 3. Update Order status to 'shipped'
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
}

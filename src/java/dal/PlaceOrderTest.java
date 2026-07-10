package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Order;

public class PlaceOrderTest extends DBContext {
    private static int getStock(Connection conn, int variantId) throws Exception {
        String sql = "SELECT available_quantity FROM [Inventory] WHERE variant_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("available_quantity");
                }
            }
        }
        return -1;
    }

    public static void main(String[] args) {
        try {
            PlaceOrderTest test = new PlaceOrderTest();
            Connection conn = test.connection;
            if (conn == null) {
                System.out.println("Connection is null!");
                return;
            }

            int variantId = 27; // ASUS TUF Gaming F15
            int stockBefore = getStock(conn, variantId);
            System.out.println("Stock of Variant 27 BEFORE test order with Qty 2: " + stockBefore);

            OrderDAO orderDAO = new OrderDAO();
            // Insert order
            Order order = orderDAO.insertOrder(new BigDecimal("40000000.00"), "Test Qty 2 Receiver", "0912345678", "Test Address", null);
            if (order != null) {
                System.out.println("Created test order: " + order.getOrderCode() + " (ID: " + order.getOrderId() + ")");
                // Insert order detail with quantity = 2
                boolean success = orderDAO.insertOrderDetail(order.getOrderId(), variantId, 2, new BigDecimal("20000000.00"));
                System.out.println("Insert order detail success: " + success);

                int stockAfter = getStock(conn, variantId);
                System.out.println("Stock of Variant 27 AFTER test order with Qty 2: " + stockAfter);

                if (stockAfter == stockBefore - 2) {
                    System.out.println("SUCCESS: Stock successfully decremented by 2!");
                } else {
                    System.out.println("FAILURE: Stock was NOT decremented correctly.");
                }
            } else {
                System.out.println("Failed to create test order.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

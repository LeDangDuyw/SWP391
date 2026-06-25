package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DumpOrders extends DBContext {
    public static void main(String[] args) {
        try {
            DumpOrders d = new DumpOrders();
            Connection conn = d.connection;
            if (conn == null) {
                System.out.println("Connection is null!");
                return;
            }
            System.out.println("=== ALL ORDERS >= 20 ===");
            String sql = "SELECT order_id, order_code, total_amount, order_status FROM [Order] WHERE order_id >= 20 ORDER BY order_id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    System.out.println("OrderID: " + rs.getInt("order_id") + 
                                       " | Code: " + rs.getString("order_code") + 
                                       " | Total: " + rs.getBigDecimal("total_amount") + 
                                       " | Status: " + rs.getString("order_status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

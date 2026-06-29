package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.DashboardSummary;
import java.sql.Timestamp;
import model.Product;

/**
 * AdminDashboardDAO retrieves aggregated KPI summary data for the admin and
 * staff dashboards.
 *
 * Version 2.0
 *
 * Date: 18/06/2026
 *
 * Author DuyLD
 */
public class AdminDashboardDAO extends DBContext {

    /**
     * Total number of registered users.
     */
    public int getTotalUsers() {
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM [User]"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalUsers: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Total number of products.
     */
    public int getTotalProducts() {
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Product"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalProducts: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Total number of categories.
     */
    public int getTotalCategories() {
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Category"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalCategories: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Total number of warranty policies.
     */
    public int getTotalWarrantyClaims() {
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM WarrantyPolicies"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalWarrantyClaims: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Products grouped by category with count. Returns a map of category name
     * -> product count.
     */
    public Map<String, Integer> getProductsByCategory() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT c.category_name, COUNT(p.product_id) AS cnt "
                + "FROM Category c LEFT JOIN Product p ON c.category_id = p.category_id "
                + "GROUP BY c.category_name ORDER BY cnt DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getProductsByCategory: " + e.getMessage());
        }
        return map;
    }

    /**
     * Products with stock quantity <= 10. Returns list of Products with
     * productName, categoryName, and minPrice (used as quantity).
     */
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 10 p.product_name, c.category_name, "
                + "SUM(ISNULL(i.available_quantity, 0)) AS total_qty "
                + "FROM Product p "
                + "LEFT JOIN Category c ON p.category_id = c.category_id "
                + "LEFT JOIN ProductVariant pv ON p.product_id = pv.product_id "
                + "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id "
                + "WHERE pv.status = 'active' "
                + "GROUP BY p.product_id, p.product_name, c.category_name "
                + "HAVING SUM(ISNULL(i.available_quantity, 0)) <= 10 "
                + "ORDER BY total_qty ASC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductName(rs.getString(1));
                p.setCategoryName(rs.getString(2));
                p.setMinPrice(rs.getLong(3)); // reuse minPrice field for quantity
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getLowStockProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * Recently added products (top 5).
     */
    public List<Product> getRecentProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 5 p.product_name, c.category_name "
                + "FROM Product p "
                + "LEFT JOIN Category c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductName(rs.getString(1));
                p.setCategoryName(rs.getString(2));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getRecentProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * Total revenue from all non-cancelled orders.
     */
    public long getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled')";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalRevenue: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Total number of orders.
     */
    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM [Order]";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalOrderCount: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Number of new customers registered today (role_id = 3).
     */
    public int getNewCustomersToday() {
        String sql = "SELECT COUNT(*) FROM [User] WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE) AND role_id = 3";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getNewCustomersToday: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Count of pending alerts: low stock products + pending warranty claims.
     */
    public int getPendingAlerts() {
        int count = 0;
        String sqlLowStock = "SELECT COUNT(*) FROM (SELECT p.product_id FROM Product p "
                + "LEFT JOIN ProductVariant pv ON p.product_id = pv.product_id "
                + "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id "
                + "WHERE pv.status = 'active' "
                + "GROUP BY p.product_id "
                + "HAVING SUM(ISNULL(i.available_quantity, 0)) <= 10) AS low";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlLowStock); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingAlerts(lowStock): " + e.getMessage());
        }
        String sqlPending = "SELECT COUNT(*) FROM WarrantyClaims WHERE status = 'PENDING'";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlPending); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingAlerts(warranty): " + e.getMessage());
        }
        return count;
    }

    /**
     * Monthly revenue for the current year, keyed by month name.
     */
    public Map<String, Long> getMonthlyRevenue() {
        Map<String, Long> map = new LinkedHashMap<>();
        String sql = "SELECT MONTH(completed_at) AS m, CAST(SUM(total_amount) AS BIGINT) "
                + "FROM [Order] WHERE completed_at IS NOT NULL "
                + "AND YEAR(completed_at) = YEAR(GETDATE()) "
                + "AND order_status NOT IN ('cancelled', 'Cancelled') "
                + "GROUP BY MONTH(completed_at) ORDER BY m";
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(months[rs.getInt(1) - 1], rs.getLong(2));
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getMonthlyRevenue: " + e.getMessage());
        }
        return map;
    }

    /**
     * Orders grouped by status with count.
     */
    public Map<String, Integer> getOrdersByStatus() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT order_status, COUNT(*) FROM [Order] GROUP BY order_status ORDER BY COUNT(*) DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getOrdersByStatus: " + e.getMessage());
        }
        return map;
    }

    /**
     * Top 5 products by total units sold.
     */
    public Map<String, Integer> getTopProducts() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT TOP 5 p.product_name, SUM(od.quantity) AS total_sold "
                + "FROM OrderDetail od "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "GROUP BY p.product_name ORDER BY total_sold DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTopProducts: " + e.getMessage());
        }
        return map;
    }

    /**
     * Top 5 customers by total spending (excluding cancelled orders).
     */
    public Map<String, Long> getTopCustomers() {
        Map<String, Long> map = new LinkedHashMap<>();
        String sql = "SELECT TOP 5 u.full_name, CAST(SUM(o.total_amount) AS BIGINT) AS total_spent "
                + "FROM [Order] o JOIN [User] u ON o.user_id = u.user_id "
                + "WHERE o.order_status NOT IN ('cancelled', 'Cancelled') "
                + "GROUP BY u.full_name ORDER BY total_spent DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(1), rs.getLong(2));
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getTopCustomers: " + e.getMessage());
        }
        return map;
    }

    /**
     * Recent activities combining orders, warranty claims, and new user
     * registrations. Returns a list of String arrays: {icon, text, timeAgo}.
     */
    public List<String[]> getRecentActivities() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM ("
                + "SELECT N'🛒' AS icon, "
                + "CONCAT('Order <b>', order_code, '</b> — ', order_status) AS txt, "
                + "completed_at AS event_date "
                + "FROM [Order] WHERE completed_at IS NOT NULL "
                + "UNION ALL "
                + "SELECT N'🔧' AS icon, "
                + "CONCAT('Warranty claim <b>#', claim_id, '</b> — ', status) AS txt, "
                + "created_at AS event_date "
                + "FROM WarrantyClaims "
                + "UNION ALL "
                + "SELECT N'👤' AS icon, "
                + "CONCAT('New customer <b>', full_name, '</b> registered') AS txt, "
                + "created_at AS event_date "
                + "FROM [User] WHERE role_id = 3"
                + ") AS combined ORDER BY event_date DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String icon = rs.getString("icon");
                String text = rs.getString("txt");
                Timestamp eventDate = rs.getTimestamp("event_date");
                list.add(new String[]{icon, text, timeAgo(eventDate)});
            }
        } catch (Exception e) {
            System.out.println("DashboardService.getRecentActivities: " + e.getMessage());
        }
        return list;
    }

    /**
     * Helper method to convert a Timestamp to a human-readable "time ago" string.
     */
    private String timeAgo(Timestamp ts) {
        if (ts == null) return "";
        long diffMs = System.currentTimeMillis() - ts.getTime();
        long mins = diffMs / 60000;
        if (mins < 1) return "just now";
        if (mins < 60) return mins + " min ago";
        long hours = mins / 60;
        if (hours < 24) return hours + " hr ago";
        long days = hours / 24;
        return days + " day ago";
    }

}

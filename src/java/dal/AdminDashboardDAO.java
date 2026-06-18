package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.DashboardSummary;
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
                + "SUM(pv.quantity) AS total_qty "
                + "FROM Product p "
                + "LEFT JOIN Category c ON p.category_id = c.category_id "
                + "LEFT JOIN ProductVariant pv ON p.product_id = pv.product_id "
                + "WHERE pv.status = 'active' "
                + "GROUP BY p.product_id, p.product_name, c.category_name "
                + "HAVING SUM(pv.quantity) <= 10 "
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
     * Retrieves a staff-level KPI summary including total orders, products, and
     * system status.
     */
    public DashboardSummary getStaffDashboard() throws Exception {

        DashboardSummary summary = new DashboardSummary();

        try (Connection con = getConnection()) {

            PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM [Order]");
            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM Product");

            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                summary.setTotalOrders(rs1.getInt(1));
            }

            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                summary.setTotalProducts(rs2.getInt(1));
            }

            summary.setSystemStatus("ONLINE");
        }

        return summary;
    }
}

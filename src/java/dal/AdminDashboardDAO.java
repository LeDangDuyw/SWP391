package dal;
/**
 * Class: AdminDashboardDAO
 * Description: Data Access Object truy xuất số liệu thống kê tổng quan cho Dashboard.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-07-11 23:00:12 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: AdminDashboardDAO
 * Description: Data Access Object truy xuất số liệu thống kê tổng quan cho Dashboard.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-07-11 23:00:12 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

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


public class AdminDashboardDAO extends DBContext {

    /**
     * Tổng số lượng tài khoản người dùng đã đăng ký.
     */
    public int getTotalUsers() {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM [User]"); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalUsers: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng số lượng biến thể sản phẩm.
     */
    public int getTotalProducts() {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Product"); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalProducts: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng số lượng danh mục sản phẩm.
     */
    public int getTotalCategories() {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Category"); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalCategories: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng số lượng chính sách bảo hành.
     */
    public int getTotalWarrantyClaims() {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM WarrantyPolicies"); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
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
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
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
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductName(rs.getString(1));
                p.setCategoryName(rs.getString(2));
                p.setMinPrice(rs.getLong(3)); // reuse minPrice field for quantity
                list.add(p);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getLowStockProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * Danh sách 5 sản phẩm được thêm vào hệ thống gần đây nhất.
     */
    public List<Product> getRecentProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 5 p.product_name, c.category_name "
                + "FROM Product p "
                + "LEFT JOIN Category c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductName(rs.getString(1));
                p.setCategoryName(rs.getString(2));
                list.add(p);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getRecentProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * Tổng doanh thu ròng từ các đơn hàng hợp lệ (không bị hủy).
     */
    public long getTotalRevenue(String from, String to) {
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled')";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += " AND CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ?";
        }
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalRevenue: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Phuong thuc getTotalRevenue
     */
    public long getTotalRevenue() {
        return getTotalRevenue(null, null);
    }

    /**
     * Tổng số lượng đơn đặt hàng.
     */
    public int getTotalOrderCount(String from, String to) {
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT COUNT(*) FROM [Order]";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += " WHERE CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ?";
        }
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTotalOrderCount: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Phuong thuc getTotalOrderCount
     */
    public int getTotalOrderCount() {
        return getTotalOrderCount(null, null);
    }

    /**
     * Số lượng khách hàng mới đăng ký tài khoản (vai trò khách hàng role_id = 3).
     */
    public int getNewCustomers(String from, String to) {
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT COUNT(*) FROM [User] WHERE role_id = 3";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += " AND CAST(created_at AS DATE) >= ? AND CAST(created_at AS DATE) <= ?";
        } else {
            sql += " AND CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        }
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getNewCustomers: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Phuong thuc getNewCustomers
     */
    public int getNewCustomers() {
        return getNewCustomers(null, null);
    }

    /**
     * Đếm tổng số cảnh báo đang chờ xử lý (tồn kho thấp, bảo hành, ticket).
     */
    public int getPendingAlerts() {
        int count = 0;
        String sqlLowStock = "SELECT COUNT(*) FROM (SELECT p.product_id FROM Product p "
                + "LEFT JOIN ProductVariant pv ON p.product_id = pv.product_id "
                + "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id "
                + "WHERE pv.status = 'active' "
                + "GROUP BY p.product_id "
                + "HAVING SUM(ISNULL(i.available_quantity, 0)) <= 10) AS low";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlLowStock); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                count += rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingAlerts(lowStock): " + e.getMessage());
        }
        String sqlPending = "SELECT COUNT(*) FROM WarrantyClaims WHERE status = 'PENDING'";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlPending); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                count += rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingAlerts(warranty): " + e.getMessage());
        }
        String sqlTickets = "SELECT COUNT(*) FROM Ticket WHERE status = 'WAITING_FOR_ADMIN_REVIEW'";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlTickets); ResultSet rs = ps.executeQuery()) {
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                count += rs.getInt(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingAlerts(tickets): " + e.getMessage());
        }
        return count;
    }

    /**
     * Phuong thuc getPendingClaimsList
     */
    public List<String[]> getPendingClaimsList() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT c.claim_id, u.full_name, c.created_at "
                + "FROM WarrantyClaims c JOIN [User] u ON c.customer_id = u.user_id "
                + "WHERE c.status = 'PENDING' ORDER BY c.created_at DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt(1)),
                    rs.getString(2),
                    rs.getTimestamp(3).toString()
                });
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingClaimsList: " + e.getMessage());
        }
        return list;
    }

    /**
     * Phuong thuc getPendingTicketsList
     */
    public List<String[]> getPendingTicketsList() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT t.ticket_id, t.title, u.full_name "
                + "FROM Ticket t JOIN [User] u ON t.created_by = u.user_id "
                + "WHERE t.status = 'WAITING_FOR_ADMIN_REVIEW' ORDER BY t.created_at DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt(1)),
                    rs.getString(2),
                    rs.getString(3)
                });
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getPendingTicketsList: " + e.getMessage());
        }
        return list;
    }

    /**
     * Monthly revenue for the current year, keyed by month name.
     */
    public Map<String, Long> getRevenueChart(String from, String to, Integer year, String groupBy) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (groupBy == null || groupBy.trim().isEmpty()) {
            groupBy = "month";
        }

        String groupExpr;
        switch (groupBy) {
            case "day":
                groupExpr = "CONVERT(varchar(10), completed_at, 23)";
                break;
            case "quarter":
                groupExpr = "CONCAT(YEAR(completed_at), '-Q', DATEPART(quarter, completed_at))";
                break;
            case "year":
                groupExpr = "CAST(YEAR(completed_at) AS VARCHAR(4))";
                break;
            case "month":
            default:
                groupExpr = "FORMAT(completed_at, 'yyyy-MM')";
                break;
        }

        String sql = "SELECT " + groupExpr + " AS label, CAST(SUM(total_amount) AS BIGINT) AS revenue "
                + "FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') ";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += "AND CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ? ";
        } else {
            sql += "AND YEAR(completed_at) = ? ";
        }
        sql += "GROUP BY " + groupExpr + " ORDER BY MIN(completed_at)";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            } else {
                ps.setInt(1, year != null ? year : 2026);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("label"), rs.getLong("revenue"));
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getRevenueChart: " + e.getMessage());
        }

        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (!hasFilter && "month".equals(groupBy)) {
            Map<String, Long> full = new LinkedHashMap<>();
            for (int m = 1; m <= 12; m++) {
                String key = year + "-" + (m < 10 ? "0" + m : "" + m);
                full.put(key, map.getOrDefault(key, 0L));
            }
            return full;
        }
        return map;
    }

    protected String normalizeStatus(String status) {
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (status == null) return "Unknown";
        status = status.trim().toUpperCase();
        switch (status) {
            case "PENDING":
                return "Pending";
            case "COMPLETED":
                return "Completed";
            case "SHIPPED":
                return "Shipped";
            case "CANCELLED":
                return "Cancelled";
            default:
                // Kiểm tra điều kiện
                // Kiểm tra điều kiện
                // Kiểm tra điều kiện
                if (status.isEmpty()) return "";
                return status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
        }
    }

    /**
     * Orders grouped by status with count.
     */
    public Map<String, Integer> getOrdersByStatus(String from, String to) {
        Map<String, Integer> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT order_status, COUNT(*) FROM [Order] ";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += "WHERE CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY order_status";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String rawStatus = rs.getString(1);
                    String normStatus = normalizeStatus(rawStatus);
                    int count = rs.getInt(2);
                    map.put(normStatus, map.getOrDefault(normStatus, 0) + count);
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getOrdersByStatus: " + e.getMessage());
        }
        
        List<Map.Entry<String, Integer>> list = new ArrayList<>(map.entrySet());
        list.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        
        Map<String, Integer> sortedMap = new LinkedHashMap<>();
        for (Map.Entry<String, Integer> entry : list) {
            sortedMap.put(entry.getKey(), entry.getValue());
        }
        return sortedMap;
    }

    /**
     * Phuong thuc getOrdersByStatus
     */
    public Map<String, Integer> getOrdersByStatus() {
        return getOrdersByStatus(null, null);
    }

    /**
     * Top 10 products by total units sold or revenue.
     */
    public Map<String, Long> getTopProducts(String from, String to, String criteria) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sumExpr = "SUM(od.quantity)";
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if ("revenue".equalsIgnoreCase(criteria)) {
            sumExpr = "CAST(SUM(od.quantity * od.unit_price) AS BIGINT)";
        }
        String sql = "SELECT TOP 10 p.product_name, " + sumExpr + " AS metric "
                + "FROM OrderDetail od "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "WHERE o.order_status NOT IN ('cancelled', 'Cancelled') ";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += "AND CAST(o.completed_at AS DATE) >= ? AND CAST(o.completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY p.product_name ORDER BY metric DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString(1);
                    // Kiểm tra điều kiện
                    // Kiểm tra điều kiện
                    // Kiểm tra điều kiện
                    if (name != null) {
                        name = name.replace("'", "\\'").replace("\"", "\\\"");
                    }
                    map.put(name, rs.getLong(2));
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTopProducts: " + e.getMessage());
        }
        return map;
    }

    /**
     * Phuong thuc getTopProducts
     */
    public Map<String, Long> getTopProducts() {
        return getTopProducts(null, null, "units");
    }

    /**
     * Top 10 customers by total spending (excluding cancelled orders).
     */
    public Map<String, Long> getTopCustomers(String from, String to) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT TOP 10 u.full_name, CAST(SUM(o.total_amount) AS BIGINT) AS total_spent "
                + "FROM [Order] o JOIN [User] u ON o.user_id = u.user_id "
                + "WHERE o.order_status NOT IN ('cancelled', 'Cancelled') ";
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        // Nếu có áp dụng bộ lọc tham số tìm kiếm
        if (hasFilter) {
            sql += "AND CAST(o.completed_at AS DATE) >= ? AND CAST(o.completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY u.full_name ORDER BY total_spent DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            // Nếu có áp dụng bộ lọc tham số tìm kiếm
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString(1);
                    // Kiểm tra điều kiện
                    // Kiểm tra điều kiện
                    // Kiểm tra điều kiện
                    if (name != null) {
                        name = name.replace("'", "\\'").replace("\"", "\\\"");
                    }
                    map.put(name, rs.getLong(2));
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getTopCustomers: " + e.getMessage());
        }
        return map;
    }

    /**
     * Phuong thuc getTopCustomers
     */
    public Map<String, Long> getTopCustomers() {
        return getTopCustomers(null, null);
    }

    /**
     * Phuong thuc getAllOrdersForDashboard
     */
    public List<String[]> getAllOrdersForDashboard() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT order_id, order_code, shipping_receiver, order_status, CAST(total_amount AS VARCHAR), CONVERT(VARCHAR(19), completed_at, 120) FROM [Order] ORDER BY completed_at DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String receiver = rs.getString(3);
                // Kiểm tra điều kiện
                // Kiểm tra điều kiện
                // Kiểm tra điều kiện
                if (receiver != null) {
                    receiver = receiver.replace("'", "\\'").replace("\"", "\\\"");
                } else {
                    receiver = "";
                }
                list.add(new String[]{
                    rs.getString(1),
                    rs.getString(2),
                    receiver,
                    rs.getString(4),
                    rs.getString(5),
                    rs.getString(6)
                });
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getAllOrdersForDashboard: " + e.getMessage());
        }
        return list;
    }

    /**
     * Recent activities combining orders, warranty claims, and new user
     * registrations. Returns a list of String arrays: {icon, text, timeAgo}.
     */
    public List<String[]> getRecentActivities() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM ("
                + "SELECT N'🛒' AS icon, "
                + "CONCAT('Order <b>', o.order_code, '</b> by Customer <b>', u.full_name, '</b> — ', o.order_status) AS txt, "
                + "o.completed_at AS event_date "
                + "FROM [Order] o "
                + "JOIN [User] u ON o.user_id = u.user_id "
                + "WHERE o.completed_at IS NOT NULL "
                + "UNION ALL "
                + "SELECT N'🔧' AS icon, "
                + "CASE "
                + "    WHEN c.status = 'PENDING' THEN CONCAT('Warranty claim <b>#', c.claim_id, '</b> submitted by Customer <b>', cust.full_name, '</b>') "
                + "    ELSE CONCAT('Warranty claim <b>#', c.claim_id, '</b> updated to ', c.status, ' by Staff <b>', COALESCE(st.full_name, 'System'), '</b>') "
                + "END AS txt, "
                + "c.created_at AS event_date "
                + "FROM WarrantyClaims c "
                + "JOIN [User] cust ON c.customer_id = cust.user_id "
                + "LEFT JOIN [User] st ON c.staff_id = st.user_id "
                + "UNION ALL "
                + "SELECT N'👤' AS icon, "
                + "CONCAT('New customer <b>', full_name, '</b> registered') AS txt, "
                + "created_at AS event_date "
                + "FROM [User] "
                + "WHERE role_id = 3 "
                + ") AS combined ORDER BY event_date DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String icon = rs.getString("icon");
                String text = rs.getString("txt");
                Timestamp eventDate = rs.getTimestamp("event_date");
                list.add(new String[]{icon, text, timeAgo(eventDate)});
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("DashboardService.getRecentActivities: " + e.getMessage());
        }
        return list;
    }

    /**
     * Helper method to convert a Timestamp to a human-readable "time ago" string.
     */
    private String timeAgo(Timestamp ts) {
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (ts == null) return "";
        long diffMs = System.currentTimeMillis() - ts.getTime();
        long mins = diffMs / 60000;
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (mins < 1) return "just now";
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (mins < 60) return mins + " min ago";
        long hours = mins / 60;
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (hours < 24) return hours + " hr ago";
        long days = hours / 24;
        return days + " day ago";
    }

    /**
     * Get revenue stats for month, quarter, and year with growth comparisons.
     */
    public java.util.Map<String, Object> getRevenueStats() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        
        long curMonth = 0;
        long prevMonth = 0;
        long curQuarter = 0;
        long prevQuarter = 0;
        long curYear = 0;
        long prevYear = 0;

        String sqlMonthCur = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(GETDATE()) AND MONTH(completed_at) = MONTH(GETDATE())";
        String sqlMonthPrev = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(DATEADD(month, -1, GETDATE())) AND MONTH(completed_at) = MONTH(DATEADD(month, -1, GETDATE()))";
        
        String sqlQuarterCur = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(GETDATE()) AND DATEPART(quarter, completed_at) = DATEPART(quarter, GETDATE())";
        String sqlQuarterPrev = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(DATEADD(quarter, -1, GETDATE())) AND DATEPART(quarter, completed_at) = DATEPART(quarter, DATEADD(quarter, -1, GETDATE()))";
        
        String sqlYearCur = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(GETDATE())";
        String sqlYearPrev = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled') AND YEAR(completed_at) = YEAR(DATEADD(year, -1, GETDATE()))";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection()) {
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlMonthCur); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) curMonth = rs.getLong(1);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlMonthPrev); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) prevMonth = rs.getLong(1);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlQuarterCur); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) curQuarter = rs.getLong(1);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlQuarterPrev); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) prevQuarter = rs.getLong(1);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlYearCur); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) curYear = rs.getLong(1);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (PreparedStatement ps = con.prepareStatement(sqlYearPrev); ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) prevYear = rs.getLong(1);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getRevenueStats: " + e.getMessage());
        }

        stats.put("monthRevenue", curMonth);
        stats.put("monthGrowth", prevMonth == 0 ? (curMonth == 0 ? 0.0 : 100.0) : (double)(curMonth - prevMonth) * 100.0 / prevMonth);
        
        stats.put("quarterRevenue", curQuarter);
        stats.put("quarterGrowth", prevQuarter == 0 ? (curQuarter == 0 ? 0.0 : 100.0) : (double)(curQuarter - prevQuarter) * 100.0 / prevQuarter);
        
        stats.put("yearRevenue", curYear);
        stats.put("yearGrowth", prevYear == 0 ? (curYear == 0 ? 0.0 : 100.0) : (double)(curYear - prevYear) * 100.0 / prevYear);

        return stats;
    }
}

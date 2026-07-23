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
import model.Product;

/**
 * Class: AdminDashboardDAO
 * Description: Data Access Object (DAO) chuyên trách truy xuất dữ liệu thống kê tổng quan cho Admin & Staff Dashboard.
 * Bao gồm thống kê doanh thu, số lượng đơn hàng, sản phẩm sắp hết hàng, hoạt động gần đây và xếp hạng bán chạy.
 * 
 * Created: 2026-05-20
 * Updated: 2026-07-23
 * Version: v2.3
 *
 * @author DuyLD
 */
public class AdminDashboardDAO extends DBContext {


    /**
     * Lấy danh sách tối đa 10 sản phẩm/biến thể có tổng tồn kho thấp (soLuong <= 10).
     * 
     * @return Danh sách đối tượng Product chứa tên sản phẩm/biến thể, tên danh mục và số lượng tồn kho (minPrice).
     */
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 10 ISNULL(pv.variant_name, p.product_name) AS prod_name, c.category_name, "
                + "SUM(ISNULL(i.available_quantity, 0)) AS total_qty "
                + "FROM Product p "
                + "LEFT JOIN Category c ON p.category_id = c.category_id "
                + "JOIN ProductVariant pv ON p.product_id = pv.product_id "
                + "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id "
                + "WHERE pv.status = 'active' "
                + "GROUP BY pv.variant_id, pv.variant_name, p.product_name, c.category_name "
                + "HAVING SUM(ISNULL(i.available_quantity, 0)) <= 10 "
                + "ORDER BY total_qty ASC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductName(rs.getString(1));
                p.setCategoryName(rs.getString(2));
                p.setMinPrice(rs.getLong(3)); // Sử dụng tạm thuộc tính minPrice để lưu số lượng tồn kho
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getLowStockProducts: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy tổng doanh thu ròng từ các đơn hàng không bị hủy trong khoảng thời gian chỉ định (hoặc toàn bộ).
     * 
     * @param from Ngày bắt đầu (yyyy-MM-dd), có thể null
     * @param to   Ngày kết thúc (yyyy-MM-dd), có thể null
     * @return Tổng số tiền doanh thu (VNĐ)
     */
    public long getTotalRevenue(String from, String to) {
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM [Order] WHERE order_status NOT IN ('cancelled', 'Cancelled')";
        if (hasFilter) {
            sql += " AND CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ?";
        }
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getTotalRevenue: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy tổng số lượng đơn đặt hàng đã tạo trên hệ thống.
     * 
     * @return Số lượng đơn hàng
     */
    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM [Order]";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getTotalOrderCount: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Thống kê số lượng khách hàng mới đăng ký tài khoản trong ngày hôm nay (role_id = 3).
     * 
     * @return Số lượng khách hàng mới
     */
    public int getNewCustomers() {
        String sql = "SELECT COUNT(*) FROM [User] WHERE role_id = 3 AND CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getNewCustomers: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tổng hợp số lượng cảnh báo cần xử lý gấp (bảo hành PENDING + ticket nhập kho WAITING_FOR_ADMIN_REVIEW).
     * 
     * @return Tổng số cảnh báo đang chờ
     */
    public int getPendingAlerts() {
        int count = 0;
        String sqlPending = "SELECT COUNT(*) FROM WarrantyClaims WHERE status = 'PENDING'";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlPending); 
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getPendingAlerts(warranty): " + e.getMessage());
        }
        String sqlTickets = "SELECT COUNT(*) FROM Ticket WHERE status = 'WAITING_FOR_ADMIN_REVIEW'";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sqlTickets); 
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getPendingAlerts(tickets): " + e.getMessage());
        }
        return count;
    }

    /**
     * Lấy danh sách các yêu cầu bảo hành đang ở trạng thái PENDING.
     * 
     * @return Danh sách mảng String {claimId, customerName, createdAt}
     */
    public List<String[]> getPendingClaimsList() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT c.claim_id, u.full_name, c.created_at "
                + "FROM WarrantyClaims c JOIN [User] u ON c.customer_id = u.user_id "
                + "WHERE c.status = 'PENDING' ORDER BY c.created_at DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt(1)),
                    rs.getString(2),
                    rs.getTimestamp(3).toString()
                });
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getPendingClaimsList: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách các Ticket nhập kho đang chờ Admin duyệt (WAITING_FOR_ADMIN_REVIEW).
     * 
     * @return Danh sách mảng String {ticketId, title, createdByName}
     */
    public List<String[]> getPendingTicketsList() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT t.ticket_id, t.title, u.full_name "
                + "FROM Ticket t JOIN [User] u ON t.created_by = u.user_id "
                + "WHERE t.status = 'WAITING_FOR_ADMIN_REVIEW' ORDER BY t.created_at DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt(1)),
                    rs.getString(2),
                    rs.getString(3)
                });
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getPendingTicketsList: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy dữ liệu doanh thu nhóm theo mốc thời gian (ngày, tháng, quý, năm) phục vụ vẽ biểu đồ.
     * 
     * @param from    Ngày bắt đầu lọc
     * @param to      Ngày kết thúc lọc
     * @param year    Năm chọn mặc định nếu không truyền từ/đến
     * @param groupBy Nhóm theo (day, month, quarter, year)
     * @return Map lưu trữ cặp nhãn nhãn thời gian và tổng doanh thu tương ứng
     */
    public Map<String, Long> getRevenueChart(String from, String to, Integer year, String groupBy) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
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
        if (hasFilter) {
            sql += "AND CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ? ";
        } else {
            sql += "AND YEAR(completed_at) = ? ";
        }
        sql += "GROUP BY " + groupExpr + " ORDER BY MIN(completed_at)";

        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            } else {
                ps.setInt(1, year != null ? year : 2026);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("label"), rs.getLong("revenue"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getRevenueChart: " + e.getMessage());
        }

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

    /**
     * Chuẩn hóa chuỗi trạng thái đơn hàng về dạng định dạng hiển thị đẹp.
     */
    protected String normalizeStatus(String status) {
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
                if (status.isEmpty()) return "";
                return status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
        }
    }

    /**
     * Thống kê số lượng đơn hàng phân theo từng trạng thái (Pending, Completed, Shipped, Cancelled...).
     * 
     * @param from Ngày bắt đầu
     * @param to   Ngày kết thúc
     * @return Map lưu trạng thái và số lượng đơn hàng tương ứng
     */
    public Map<String, Integer> getOrdersByStatus(String from, String to) {
        Map<String, Integer> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT order_status, COUNT(*) FROM [Order] ";
        if (hasFilter) {
            sql += "WHERE CAST(completed_at AS DATE) >= ? AND CAST(completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY order_status";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String rawStatus = rs.getString(1);
                    String normStatus = normalizeStatus(rawStatus);
                    int count = rs.getInt(2);
                    map.put(normStatus, map.getOrDefault(normStatus, 0) + count);
                }
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getOrdersByStatus: " + e.getMessage());
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
     * Thống kê số lượng đơn hàng phân theo từng trạng thái (không lọc thời gian).
     */
    public Map<String, Integer> getOrdersByStatus() {
        return getOrdersByStatus(null, null);
    }

    /**
     * Lấy danh sách Top 10 sản phẩm bán chạy nhất theo tiêu chí (số lượng sản phẩm hoặc doanh thu mang lại).
     * 
     * @param from     Ngày bắt đầu
     * @param to       Ngày kết thúc
     * @param criteria Tiêu chí lọc: 'quantity' (số lượng) hoặc 'revenue' (doanh thu)
     * @return Map lưu tên sản phẩm và giá trị chỉ số tương ứng
     */
    public Map<String, Long> getTopProducts(String from, String to, String criteria) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sumExpr = "SUM(od.quantity)";
        if ("revenue".equalsIgnoreCase(criteria)) {
            sumExpr = "CAST(SUM(od.quantity * od.unit_price) AS BIGINT)";
        }
        String sql = "SELECT TOP 10 p.product_name, " + sumExpr + " AS metric "
                + "FROM OrderDetail od "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "WHERE o.order_status NOT IN ('cancelled', 'Cancelled') ";
        if (hasFilter) {
            sql += "AND CAST(o.completed_at AS DATE) >= ? AND CAST(o.completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY p.product_name ORDER BY metric DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString(1);
                    if (name != null) {
                        name = name.replace("'", "\\'").replace("\"", "\\\"");
                    }
                    map.put(name, rs.getLong(2));
                }
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getTopProducts: " + e.getMessage());
        }
        return map;
    }

    /**
     * Lấy danh sách Top 10 khách hàng chi tiêu nhiều nhất (không tính các đơn hàng đã bị hủy).
     * 
     * @param from Ngày bắt đầu
     * @param to   Ngày kết thúc
     * @return Map lưu tên khách hàng và tổng số tiền đã chi tiêu
     */
    public Map<String, Long> getTopCustomers(String from, String to) {
        Map<String, Long> map = new LinkedHashMap<>();
        boolean hasFilter = (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty());
        String sql = "SELECT TOP 10 u.full_name, CAST(SUM(o.total_amount) AS BIGINT) AS total_spent "
                + "FROM [Order] o JOIN [User] u ON o.user_id = u.user_id "
                + "WHERE o.order_status NOT IN ('cancelled', 'Cancelled') ";
        if (hasFilter) {
            sql += "AND CAST(o.completed_at AS DATE) >= ? AND CAST(o.completed_at AS DATE) <= ? ";
        }
        sql += "GROUP BY u.full_name ORDER BY total_spent DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) {
                ps.setDate(1, java.sql.Date.valueOf(from.trim()));
                ps.setDate(2, java.sql.Date.valueOf(to.trim()));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString(1);
                    if (name != null) {
                        name = name.replace("'", "\\'").replace("\"", "\\\"");
                    }
                    map.put(name, rs.getLong(2));
                }
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getTopCustomers: " + e.getMessage());
        }
        return map;
    }

    /**
     * Lấy danh sách tất cả đơn hàng kèm thông tin tóm tắt để phục vụ việc tính toán thống kê linh hoạt trên phía Javascript Client.
     * 
     * @return Danh sách mảng String đại diện thông tin đơn hàng
     */
    public List<String[]> getAllOrdersForDashboard() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT order_id, order_code, shipping_receiver, order_status, CAST(total_amount AS VARCHAR), CONVERT(VARCHAR(19), completed_at, 120) FROM [Order] ORDER BY completed_at DESC";
        try (Connection con = getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String receiver = rs.getString(3);
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
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getAllOrdersForDashboard: " + e.getMessage());
        }
        return list;
    }

    /**
     * Tổng hợp dòng hoạt động gần nhất trên hệ thống (đơn hàng mới, yêu cầu bảo hành, tài khoản khách hàng mới đăng ký).
     * 
     * @return Danh sách mảng String {icon, noiDungHTML, timeAgo}
     */
    public List<String[]> getRecentActivities() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM ("
                + "SELECT N'🛒' AS icon, "
                + "CONCAT(N'Đơn hàng <b>', o.order_code, N'</b> từ Khách hàng <b>', u.full_name, N'</b> — ', o.order_status) AS txt, "
                + "o.completed_at AS event_date "
                + "FROM [Order] o "
                + "JOIN [User] u ON o.user_id = u.user_id "
                + "WHERE o.completed_at IS NOT NULL "
                + "UNION ALL "
                + "SELECT N'🔧' AS icon, "
                + "CASE "
                + "    WHEN c.status = 'PENDING' THEN CONCAT(N'Yêu cầu bảo hành <b>#', c.claim_id, N'</b> được gửi bởi Khách hàng <b>', cust.full_name, N'</b>') "
                + "    ELSE CONCAT(N'Yêu cầu bảo hành <b>#', c.claim_id, N'</b> được cập nhật thành ', c.status, N' bởi Nhân viên <b>', COALESCE(st.full_name, N'Hệ thống'), N'</b>') "
                + "END AS txt, "
                + "c.created_at AS event_date "
                + "FROM WarrantyClaims c "
                + "JOIN [User] cust ON c.customer_id = cust.user_id "
                + "LEFT JOIN [User] st ON c.staff_id = st.user_id "
                + "UNION ALL "
                + "SELECT N'👤' AS icon, "
                + "CONCAT(N'Khách hàng mới <b>', full_name, N'</b> đã đăng ký tài khoản') AS txt, "
                + "created_at AS event_date "
                + "FROM [User] "
                + "WHERE role_id = 3 "
                + ") AS combined ORDER BY event_date DESC";
        try (Connection con = getConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String icon = rs.getString("icon");
                String text = rs.getString("txt");
                Timestamp eventDate = rs.getTimestamp("event_date");
                list.add(new String[]{icon, text, timeAgo(eventDate)});
            }
        } catch (Exception e) {
            System.out.println("AdminDashboardDAO.getRecentActivities: " + e.getMessage());
        }
        return list;
    }

    /**
     * Chuyển đổi thời điểm Timestamp sang định dạng khoảng thời gian tương đối dễ đọc ("vừa xong", "X phút trước", "X giờ trước"...).
     */
    private String timeAgo(Timestamp ts) {
        if (ts == null) return "";
        long diffMs = System.currentTimeMillis() - ts.getTime();
        long mins = diffMs / 60000;
        if (mins < 1) return "vừa xong";
        if (mins < 60) return mins + " phút trước";
        long hours = mins / 60;
        if (hours < 24) return hours + " giờ trước";
        long days = hours / 24;
        return days + " ngày trước";
    }

    /**
     * Tính toán tổng doanh thu và tỷ lệ tăng trưởng (%) theo Tháng, Quý, Năm so với kỳ trước tương ứng.
     * 
     * @return Map chứa thông tin doanh thu và % tăng trưởng cho từng kỳ
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

        try (Connection con = getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(sqlMonthCur); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) curMonth = rs.getLong(1);
            }
            try (PreparedStatement ps = con.prepareStatement(sqlMonthPrev); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) prevMonth = rs.getLong(1);
            }
            try (PreparedStatement ps = con.prepareStatement(sqlQuarterCur); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) curQuarter = rs.getLong(1);
            }
            try (PreparedStatement ps = con.prepareStatement(sqlQuarterPrev); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) prevQuarter = rs.getLong(1);
            }
            try (PreparedStatement ps = con.prepareStatement(sqlYearCur); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) curYear = rs.getLong(1);
            }
            try (PreparedStatement ps = con.prepareStatement(sqlYearPrev); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) prevYear = rs.getLong(1);
            }
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


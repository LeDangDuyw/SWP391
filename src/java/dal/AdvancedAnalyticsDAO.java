package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.AnalyticsFilter;

/**
 * AdvancedAnalyticsDAO retrieves granular charting and tabular data for reports.
 * It reuses normalized status logic from AdminDashboardDAO.
 * 
 * Version 1.0
 * Date: 09/07/2026
 * Author: Antigravity
 */
public class AdvancedAnalyticsDAO extends AdminDashboardDAO {

    /**
     * Retrieves all raw statuses from the Order table, filters them using 
     * normalizeStatus(), and returns those that map to Delivered, Completed, or Shipped.
     * This avoids code drift by reusing the status normalization source of truth.
     */
    public List<String> getValidRawStatuses() {
        List<String> rawStatuses = new ArrayList<>();
        String sql = "SELECT DISTINCT order_status FROM [Order] WHERE order_status IS NOT NULL";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rawStatuses.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getValidRawStatuses Error: " + e.getMessage());
        }

        List<String> valid = new ArrayList<>();
        for (String raw : rawStatuses) {
            String norm = normalizeStatus(raw);
            if ("Delivered".equals(norm) || "Completed".equals(norm) || "Shipped".equals(norm)) {
                valid.add(raw);
            }
        }
        
        // Fallback defaults if database contains no records or connection fails
        if (valid.isEmpty()) {
            valid.add("delivered");
            valid.add("COMPLETED");
            valid.add("shipped");
            valid.add("Completed");
            valid.add("Shipped");
            valid.add("Delivered");
        }
        return valid;
    }

    /**
     * Helper to append IN clause for valid statuses.
     */
    private void appendStatusCondition(StringBuilder sql, List<String> validStatuses) {
        sql.append(" AND o.order_status IN (");
        for (int i = 0; i < validStatuses.size(); i++) {
            sql.append("?");
            if (i < validStatuses.size() - 1) {
                sql.append(", ");
            }
        }
        sql.append(") ");
    }

    /**
     * Helper to bind valid statuses to a PreparedStatement.
     */
    private int bindStatusParams(PreparedStatement ps, List<String> validStatuses, int startIndex) throws SQLException {
        for (String status : validStatuses) {
            ps.setString(startIndex++, status);
        }
        return startIndex;
    }

    /**
     * Helper to append customer cohort (New vs Returning) filter.
     * Customer identity uses 'user_id' because 'customer_id' is mostly null in the database.
     */
    private void appendCustomerTypeCondition(StringBuilder sql, String customerType, List<String> validStatuses) {
        if (customerType == null || customerType.trim().isEmpty()) {
            return;
        }
        String op = "new".equalsIgnoreCase(customerType.trim()) ? "= 0" : "> 0";
        sql.append(" AND (SELECT COUNT(*) FROM [Order] o_prev WHERE o_prev.user_id = o.user_id AND o_prev.completed_at < o.completed_at AND o_prev.completed_at IS NOT NULL AND o_prev.order_status IN (");
        for (int i = 0; i < validStatuses.size(); i++) {
            sql.append("?");
            if (i < validStatuses.size() - 1) {
                sql.append(", ");
            }
        }
        sql.append(")) ").append(op).append(" ");
    }

    /**
     * Helper to bind customer type parameters.
     */
    private int bindCustomerTypeParams(PreparedStatement ps, String customerType, List<String> validStatuses, int startIndex) throws SQLException {
        if (customerType == null || customerType.trim().isEmpty()) {
            return startIndex;
        }
        return bindStatusParams(ps, validStatuses, startIndex);
    }

    /**
     * Helper to append standard order level dynamic filters:
     * - Date Range
     * - Product Category (via exists)
     * - Product Brand (via exists)
     * - Payment Method (via exists)
     */
    private void appendOrderFilters(StringBuilder sql, AnalyticsFilter filter, List<Object> paramValues) {
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            paramValues.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            paramValues.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            paramValues.add(filter.getPaymentMethod().trim());
        }
        
        // Exists conditions for Category and Brand at the order level
        boolean hasCategory = filter.getCategoryId() != null && filter.getCategoryId() > 0;
        boolean hasBrand = filter.getBrandId() != null && filter.getBrandId() > 0;
        if (hasCategory || hasBrand) {
            sql.append(" AND EXISTS (SELECT 1 FROM OrderDetail od_f ")
               .append(" JOIN ProductVariant pv_f ON od_f.variant_id = pv_f.variant_id ")
               .append(" JOIN Product p_f ON pv_f.product_id = p_f.product_id ")
               .append(" WHERE od_f.order_id = o.order_id ");
            if (hasCategory) {
                sql.append(" AND p_f.category_id = ? ");
                paramValues.add(filter.getCategoryId());
            }
            if (hasBrand) {
                sql.append(" AND p_f.brand_id = ? ");
                paramValues.add(filter.getBrandId());
            }
            sql.append(") ");
        }
    }

    /**
     * Helper to return time grouping expressions based on standard granularity.
     */
    private String getGroupExpression(String groupBy) {
        if (groupBy == null || groupBy.trim().isEmpty()) {
            groupBy = "month";
        }
        switch (groupBy.trim().toLowerCase()) {
            case "day":
                return "CONVERT(varchar(10), o.completed_at, 23)";
            case "quarter":
                return "CONCAT(YEAR(o.completed_at), '-Q', DATEPART(quarter, o.completed_at))";
            case "year":
                return "CAST(YEAR(o.completed_at) AS VARCHAR(4))";
            case "month":
            default:
                return "FORMAT(o.completed_at, 'yyyy-MM')";
        }
    }

    // ── REVENUE ANALYSIS ──

    /**
     * 1. Revenue trend over time (sums net product line-item sales)
     */
    public Map<String, Long> getRevenueTrend(AnalyticsFilter filter, String groupBy) {
        Map<String, Long> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        String groupExpr = getGroupExpression(groupBy);
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ").append(groupExpr).append(" AS label, ")
           .append(" CAST(SUM(od.quantity * od.unit_price) AS BIGINT) AS revenue ")
           .append("FROM [Order] o ")
           .append("JOIN OrderDetail od ON o.order_id = od.order_id ")
           .append("JOIN ProductVariant pv ON od.variant_id = pv.variant_id ")
           .append("JOIN Product p ON pv.product_id = p.product_id ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        // Apply date range, customer type, payment method filters
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            dynamicParams.add(filter.getPaymentMethod().trim());
        }
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ? ");
            dynamicParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            sql.append(" AND p.brand_id = ? ");
            dynamicParams.add(filter.getBrandId());
        }
        
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        
        sql.append("GROUP BY ").append(groupExpr).append(" ORDER BY MIN(o.completed_at) ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("label"), rs.getLong("revenue"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getRevenueTrend Error: " + e.getMessage());
        }
        return map;
    }

    /**
     * 2. Revenue breakdown by Category
     */
    public Map<String, Long> getRevenueByCategory(AnalyticsFilter filter) {
        Map<String, Long> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.category_name, CAST(SUM(od.quantity * od.unit_price) AS BIGINT) AS revenue ")
           .append("FROM [Order] o ")
           .append("JOIN OrderDetail od ON o.order_id = od.order_id ")
           .append("JOIN ProductVariant pv ON od.variant_id = pv.variant_id ")
           .append("JOIN Product p ON pv.product_id = p.product_id ")
           .append("JOIN Category c ON p.category_id = c.category_id ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            dynamicParams.add(filter.getPaymentMethod().trim());
        }
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ? ");
            dynamicParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            sql.append(" AND p.brand_id = ? ");
            dynamicParams.add(filter.getBrandId());
        }
        
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        sql.append("GROUP BY c.category_name ORDER BY revenue DESC ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("category_name"), rs.getLong("revenue"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getRevenueByCategory Error: " + e.getMessage());
        }
        return map;
    }

    /**
     * 3. Revenue breakdown by Brand
     */
    public Map<String, Long> getRevenueByBrand(AnalyticsFilter filter) {
        Map<String, Long> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.brand_name, CAST(SUM(od.quantity * od.unit_price) AS BIGINT) AS revenue ")
           .append("FROM [Order] o ")
           .append("JOIN OrderDetail od ON o.order_id = od.order_id ")
           .append("JOIN ProductVariant pv ON od.variant_id = pv.variant_id ")
           .append("JOIN Product p ON pv.product_id = p.product_id ")
           .append("JOIN Brand b ON p.brand_id = b.brand_id ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            dynamicParams.add(filter.getPaymentMethod().trim());
        }
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ? ");
            dynamicParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            sql.append(" AND p.brand_id = ? ");
            dynamicParams.add(filter.getBrandId());
        }
        
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        sql.append("GROUP BY b.brand_name ORDER BY revenue DESC ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("brand_name"), rs.getLong("revenue"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getRevenueByBrand Error: " + e.getMessage());
        }
        return map;
    }

    // ── SALES ANALYSIS ──

    /**
     * 4. Orders count trend over time
     */
    public Map<String, Integer> getOrdersTrend(AnalyticsFilter filter, String groupBy) {
        Map<String, Integer> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        String groupExpr = getGroupExpression(groupBy);
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ").append(groupExpr).append(" AS label, ")
           .append(" COUNT(DISTINCT o.order_id) AS order_count ")
           .append("FROM [Order] o ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        appendOrderFilters(sql, filter, dynamicParams);
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        
        sql.append("GROUP BY ").append(groupExpr).append(" ORDER BY MIN(o.completed_at) ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("label"), rs.getInt("order_count"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getOrdersTrend Error: " + e.getMessage());
        }
        return map;
    }

    /**
     * 5. Average Order Value (AOV) for valid orders
     */
    public double getAverageOrderValue(AnalyticsFilter filter) {
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ISNULL(AVG(o.total_amount), 0.0) AS aov ")
           .append("FROM [Order] o ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        appendOrderFilters(sql, filter, dynamicParams);
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("aov");
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getAverageOrderValue Error: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * 6. Order share by Payment Method
     */
    public Map<String, Integer> getSalesByPaymentMethod(AnalyticsFilter filter) {
        Map<String, Integer> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT pay.payment_method, COUNT(DISTINCT o.order_id) AS order_count ")
           .append("FROM [Order] o ")
           .append("JOIN Payment pay ON o.order_id = pay.order_id ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        appendOrderFilters(sql, filter, dynamicParams);
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        sql.append("GROUP BY pay.payment_method ORDER BY order_count DESC ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String method = rs.getString("payment_method");
                    if (method == null || method.trim().isEmpty()) {
                        method = "COD"; // fallback default
                    }
                    map.put(method, rs.getInt("order_count"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getSalesByPaymentMethod Error: " + e.getMessage());
        }
        return map;
    }

    // ── CUSTOMER ANALYTICS ──

    /**
     * 7. New vs Returning customer metrics.
     * Customer identity matches 'user_id' because 'customer_id' is mostly null in the database.
     */
    public Map<String, Long[]> getNewVsReturningCustomers(AnalyticsFilter filter) {
        Map<String, Long[]> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("WITH OrderClassification AS ( ")
           .append("  SELECT o.order_id, o.user_id, o.total_amount, ")
           .append("  (SELECT COUNT(*) FROM [Order] o2 WHERE o2.user_id = o.user_id AND o2.completed_at < o.completed_at AND o2.completed_at IS NOT NULL AND o2.order_status IN (");
        for (int i = 0; i < validStatuses.size(); i++) {
            sql.append("?");
            if (i < validStatuses.size() - 1) sql.append(", ");
        }
        sql.append(")) AS prior_orders ")
           .append("  FROM [Order] o ")
           .append("  WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        // Bind parameters for the prior orders count subquery in CTE (for each order)
        // Wait, standard CTE binds first, so validStatuses parameters come first!
        
        appendOrderFilters(sql, filter, dynamicParams);
        appendStatusCondition(sql, validStatuses);
        sql.append(") ")
           .append("SELECT ")
           .append("  CASE WHEN prior_orders = 0 THEN 'New' ELSE 'Returning' END AS customer_type, ")
           .append("  COUNT(DISTINCT user_id) AS customer_count, ")
           .append("  COUNT(DISTINCT order_id) AS order_count, ")
           .append("  CAST(SUM(total_amount) AS BIGINT) AS revenue ")
           .append("FROM OrderClassification ")
           .append("GROUP BY CASE WHEN prior_orders = 0 THEN 'New' ELSE 'Returning' END ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            // First bind subquery parameters inside the WITH clause (one bind per status check)
            // Wait, does it execute inside CTE? Yes, so we bind validStatuses values first
            idx = bindStatusParams(ps, validStatuses, idx);
            
            // Then bind dynamic filters
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            // Lastly bind outer order status filter
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("customer_type");
                    long customers = rs.getLong("customer_count");
                    long orders = rs.getLong("order_count");
                    long revenue = rs.getLong("revenue");
                    map.put(type, new Long[]{customers, orders, revenue});
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getNewVsReturningCustomers Error: " + e.getMessage());
        }
        
        // Ensure both categories exist in returned map
        if (!map.containsKey("New")) {
            map.put("New", new Long[]{0L, 0L, 0L});
        }
        if (!map.containsKey("Returning")) {
            map.put("Returning", new Long[]{0L, 0L, 0L});
        }
        return map;
    }

    /**
     * 8. Cohort Customer Growth: Count of new customers (first order date grouped by period).
     * Customer identity matches 'user_id' because 'customer_id' is mostly null in the database.
     */
    public Map<String, Integer> getCustomerGrowth(AnalyticsFilter filter, String groupBy) {
        Map<String, Integer> map = new LinkedHashMap<>();
        List<String> validStatuses = getValidRawStatuses();
        String groupExpr = getGroupExpression(groupBy);
        
        StringBuilder sql = new StringBuilder();
        sql.append("WITH FirstOrders AS ( ")
           .append("  SELECT user_id, MIN(completed_at) AS completed_at ")
           .append("  FROM [Order] o2 ")
           .append("  WHERE o2.completed_at IS NOT NULL AND o2.order_status IN (");
        for (int i = 0; i < validStatuses.size(); i++) {
            sql.append("?");
            if (i < validStatuses.size() - 1) sql.append(", ");
        }
        sql.append(") GROUP BY user_id ")
           .append(") ")
           .append("SELECT ").append(groupExpr).append(" AS label, COUNT(user_id) AS new_cust_count ")
           .append("FROM FirstOrders o ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        
        sql.append("GROUP BY ").append(groupExpr).append(" ORDER BY MIN(o.completed_at) ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            idx = bindStatusParams(ps, validStatuses, idx);
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("label"), rs.getInt("new_cust_count"));
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getCustomerGrowth Error: " + e.getMessage());
        }
        return map;
    }

    /**
     * 9. Top spending customers list.
     * Customer identity matches 'user_id' because 'customer_id' is mostly null in the database.
     */
    public List<String[]> getTopSpendingCustomers(AnalyticsFilter filter, int topN) {
        List<String[]> list = new ArrayList<>();
        List<String> validStatuses = getValidRawStatuses();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP (").append(topN).append(") u.full_name, u.email, ")
           .append(" CAST(SUM(o.total_amount) AS BIGINT) AS total_spent, ")
           .append(" COUNT(DISTINCT o.order_id) AS order_count ")
           .append("FROM [Order] o ")
           .append("JOIN [User] u ON o.user_id = u.user_id ") // user_id connects customers (customer_id is null)
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        appendOrderFilters(sql, filter, dynamicParams);
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        
        sql.append("GROUP BY u.user_id, u.full_name, u.email ")
           .append("ORDER BY total_spent DESC ");
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("full_name"),
                        rs.getString("email") != null ? rs.getString("email") : "-",
                        String.valueOf(rs.getLong("total_spent")),
                        String.valueOf(rs.getInt("order_count"))
                    });
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getTopSpendingCustomers Error: " + e.getMessage());
        }
        return list;
    }

    // ── PRODUCT ANALYTICS & INVENTORY TURNOVER ──

    /**
     * 10 & 11. Best and Worst Selling Products.
     * Orders are sorted descending (best) or ascending (worst).
     */
    public List<String[]> getProductSalesRanking(AnalyticsFilter filter, int topN, String sortBy, boolean descending) {
        List<String[]> list = new ArrayList<>();
        List<String> validStatuses = getValidRawStatuses();
        
        String metric = "quantity".equalsIgnoreCase(sortBy) ? "SUM(od.quantity)" : "CAST(SUM(od.quantity * od.unit_price) AS BIGINT)";
        String direction = descending ? "DESC" : "ASC";
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP (").append(topN).append(") p.product_name, pv.variant_name, ")
           .append(" SUM(od.quantity) AS qty_sold, ")
           .append(" CAST(SUM(od.quantity * od.unit_price) AS BIGINT) AS revenue ")
           .append("FROM OrderDetail od ")
           .append("JOIN [Order] o ON od.order_id = o.order_id ")
           .append("JOIN ProductVariant pv ON od.variant_id = pv.variant_id ")
           .append("JOIN Product p ON pv.product_id = p.product_id ")
           .append("WHERE o.completed_at IS NOT NULL ");
        
        List<Object> dynamicParams = new ArrayList<>();
        if (filter.getFromDate() != null && !filter.getFromDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) >= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getFromDate().trim()));
        }
        if (filter.getToDate() != null && !filter.getToDate().trim().isEmpty()) {
            sql.append(" AND CAST(o.completed_at AS DATE) <= ? ");
            dynamicParams.add(java.sql.Date.valueOf(filter.getToDate().trim()));
        }
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            dynamicParams.add(filter.getPaymentMethod().trim());
        }
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ? ");
            dynamicParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            sql.append(" AND p.brand_id = ? ");
            dynamicParams.add(filter.getBrandId());
        }
        
        appendCustomerTypeCondition(sql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(sql, validStatuses);
        
        sql.append("GROUP BY p.product_name, pv.variant_name ")
           .append("ORDER BY ").append(metric).append(" ").append(direction);
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        rs.getString("product_name"),
                        rs.getString("variant_name") != null ? rs.getString("variant_name") : "",
                        String.valueOf(rs.getInt("qty_sold")),
                        String.valueOf(rs.getLong("revenue"))
                    });
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getProductSalesRanking Error: " + e.getMessage());
        }
        return list;
    }

    /**
     * 12. Inventory Turnover Calculation (Option A - Historical Accounting Style).
     * Assumes catalog is 100% serialized (verified as of 09/07/2026: 53/53 variants in unilap_db1.sql have is_serialized = 1).
     * WARNING: If non-serialized accessories are added, they must be tracked in a separate table, and this query must be updated to avoid undercounting inventory valuation.
     */
    public double[] getInventoryTurnover(AnalyticsFilter filter) {
        List<String> validStatuses = getValidRawStatuses();
        
        String from = filter.getFromDate();
        String to = filter.getToDate();
        
        // Parse dates or default to full project history range
        java.sql.Date startSql = (from != null && !from.trim().isEmpty()) 
                                 ? java.sql.Date.valueOf(from.trim()) 
                                 : java.sql.Date.valueOf("2025-01-01");
        java.sql.Date endSql = (to != null && !to.trim().isEmpty()) 
                               ? java.sql.Date.valueOf(to.trim()) 
                               : new java.sql.Date(System.currentTimeMillis());
        
        double cogs = 0.0;
        double begInventoryVal = 0.0;
        double endInventoryVal = 0.0;
        
        // 1. Calculate Cost of Goods Sold (COGS)
        StringBuilder cogsSql = new StringBuilder();
        cogsSql.append("SELECT ISNULL(SUM(od.quantity * pv.import_price), 0.0) AS cogs ")
               .append("FROM OrderDetail od ")
               .append("JOIN [Order] o ON od.order_id = o.order_id ")
               .append("JOIN ProductVariant pv ON od.variant_id = pv.variant_id ")
               .append("JOIN Product p ON pv.product_id = p.product_id ")
               .append("WHERE o.completed_at IS NOT NULL ")
               .append("  AND CAST(o.completed_at AS DATE) >= ? ")
               .append("  AND CAST(o.completed_at AS DATE) <= ? ");
        
        List<Object> dynamicParams = new ArrayList<>();
        if (filter.getPaymentMethod() != null && !filter.getPaymentMethod().trim().isEmpty()) {
            cogsSql.append(" AND EXISTS (SELECT 1 FROM Payment pay WHERE pay.order_id = o.order_id AND pay.payment_method = ?) ");
            dynamicParams.add(filter.getPaymentMethod().trim());
        }
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            cogsSql.append(" AND p.category_id = ? ");
            dynamicParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            cogsSql.append(" AND p.brand_id = ? ");
            dynamicParams.add(filter.getBrandId());
        }
        
        appendCustomerTypeCondition(cogsSql, filter.getCustomerType(), validStatuses);
        appendStatusCondition(cogsSql, validStatuses);
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(cogsSql.toString())) {
            
            ps.setDate(1, startSql);
            ps.setDate(2, endSql);
            int idx = 3;
            for (Object param : dynamicParams) {
                ps.setObject(idx++, param);
            }
            idx = bindCustomerTypeParams(ps, filter.getCustomerType(), validStatuses, idx);
            bindStatusParams(ps, validStatuses, idx);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cogs = rs.getDouble("cogs");
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getInventoryTurnover (COGS) Error: " + e.getMessage());
        }
        
        // 2. Calculate Beginning Inventory Valuation
        StringBuilder begInvSql = new StringBuilder();
        begInvSql.append("SELECT ISNULL(SUM(pv.import_price), 0.0) AS beg_val ")
              .append("FROM InventoryItem ii ")
              .append("JOIN ProductVariant pv ON ii.variant_id = pv.variant_id ")
              .append("JOIN Product p ON pv.product_id = p.product_id ")
              .append("WHERE CAST(ii.import_date AS DATE) <= ? ")
              .append("  AND (ii.sold_date IS NULL OR CAST(ii.sold_date AS DATE) > ?) ");
        
        List<Object> begParams = new ArrayList<>();
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            begInvSql.append(" AND p.category_id = ? ");
            begParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            begInvSql.append(" AND p.brand_id = ? ");
            begParams.add(filter.getBrandId());
        }
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(begInvSql.toString())) {
            
            ps.setDate(1, startSql);
            ps.setDate(2, startSql);
            int idx = 3;
            for (Object param : begParams) {
                ps.setObject(idx++, param);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    begInventoryVal = rs.getDouble("beg_val");
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getInventoryTurnover (BegInventory) Error: " + e.getMessage());
        }
        
        // 3. Calculate Ending Inventory Valuation
        StringBuilder endInvSql = new StringBuilder();
        endInvSql.append("SELECT ISNULL(SUM(pv.import_price), 0.0) AS end_val ")
              .append("FROM InventoryItem ii ")
              .append("JOIN ProductVariant pv ON ii.variant_id = pv.variant_id ")
              .append("JOIN Product p ON pv.product_id = p.product_id ")
              .append("WHERE CAST(ii.import_date AS DATE) <= ? ")
              .append("  AND (ii.sold_date IS NULL OR CAST(ii.sold_date AS DATE) > ?) ");
        
        List<Object> endParams = new ArrayList<>();
        if (filter.getCategoryId() != null && filter.getCategoryId() > 0) {
            endInvSql.append(" AND p.category_id = ? ");
            endParams.add(filter.getCategoryId());
        }
        if (filter.getBrandId() != null && filter.getBrandId() > 0) {
            endInvSql.append(" AND p.brand_id = ? ");
            endParams.add(filter.getBrandId());
        }
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(endInvSql.toString())) {
            
            ps.setDate(1, endSql);
            ps.setDate(2, endSql);
            int idx = 3;
            for (Object param : endParams) {
                ps.setObject(idx++, param);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    endInventoryVal = rs.getDouble("end_val");
                }
            }
        } catch (Exception e) {
            System.out.println("AdvancedAnalyticsDAO.getInventoryTurnover (EndInventory) Error: " + e.getMessage());
        }
        
        // Average beginning and ending valuations
        double avgInventoryVal = (begInventoryVal + endInventoryVal) / 2.0;
        double ratio = (avgInventoryVal > 0.0) ? (cogs / avgInventoryVal) : 0.0;
        
        return new double[]{cogs, avgInventoryVal, ratio};
    }
}

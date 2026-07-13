package dal;

/**
 * Class: WarrantyDAO
 * Description: Data Access Object truy xuất và cập nhật trạng thái yêu cầu bảo hành.
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-12
 * Version: v1.7
 *
 * @author DuyLD
 */

import model.WarrantyClaim;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WarrantyDAO extends DBContext {

    // ── INSERT ───────────────────────────────────────────────────────────────
    /**
     * Inserts a new warranty claim and returns the generated claim ID.
     *
     * @param claim the WarrantyClaim to persist
     * @return generated claimId, or -1 on failure
     * @throws Exception on SQL error
     */
    public int insertClaim(WarrantyClaim claim) throws Exception {
        String sql = "INSERT INTO WarrantyClaims "
                + "(order_id, order_detail_id, customer_id, serial_number, "
                + " title, description, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', GETDATE(), GETDATE())";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, claim.getOrderId());
            ps.setInt(2, claim.getOrderDetailId());
            ps.setInt(3, claim.getCustomerId());
            ps.setString(4, claim.getSerialNumber());
            ps.setString(5, claim.getTitle());
            ps.setString(6, claim.getDescription());
            ps.executeUpdate();

            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet keys = ps.getGeneratedKeys()) {
                // Kiểm tra điều kiện
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    // ── UPDATE STATUS ─────────────────────────────────────────────────────────
    /**
     * Updates the status (and optionally completed_at) of an existing claim.
     *
     * @param claimId ID of the claim to update
     * @param newStatus the target status string
     * @throws Exception on SQL error
     */
    public void updateStatus(int claimId, String newStatus) throws Exception {
        boolean isCompleted = "COMPLETED".equals(newStatus);

        String sql = isCompleted
                ? "UPDATE WarrantyClaims SET status = ?, updated_at = GETDATE(), completed_at = GETDATE() WHERE claim_id = ?"
                : "UPDATE WarrantyClaims SET status = ?, updated_at = GETDATE() WHERE claim_id = ?";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, claimId);
            ps.executeUpdate();
        }
    }

    /**
     * Atomically assigns staff and transitions status PENDING → PROCESSING.
     * Uses optimistic locking (WHERE status = 'PENDING') to prevent race
     * condition when multiple staff click "Accept" on the same claim.
     *
     * @return number of rows affected (0 = claim was already taken by someone
     * else)
     */
    public int assignStaffAndProcess(int claimId, int staffId) throws Exception {
        String sql = "UPDATE WarrantyClaims "
                + "SET staff_id = ?, status = 'PROCESSING', updated_at = GETDATE() "
                + "WHERE claim_id = ? AND status = 'PENDING'";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, claimId);
            return ps.executeUpdate();
        }
    }

    // ── FIND BY ID ────────────────────────────────────────────────────────────
    /**
     * Retrieves a single WarrantyClaim by its ID, joining customer and product
     * names.
     *
     * @param claimId the claim's primary key
     * @return WarrantyClaim or null if not found
     * @throws Exception on SQL error
     */
    public WarrantyClaim findById(int claimId) throws Exception {
        String sql
                = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE wc.claim_id = ?";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return mapClaimWithJoin(rs);
                }
            }
        }
        return null;
    }

    // ── FIND BY CUSTOMER ─────────────────────────────────────────────────────
    /**
     * Returns all warranty claims for a specific customer, newest first.
     *
     * @param customerId ID of the customer
     * @return list of WarrantyClaim (may be empty)
     * @throws Exception on SQL error
     */
    public List<WarrantyClaim> findByCustomer(int customerId) throws Exception {
        String sql = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE wc.customer_id = ? "
                + "ORDER BY wc.created_at DESC";

        List<WarrantyClaim> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    // ── FIND ALL (paged) ─────────────────────────────────────────────────────
    /**
     * Returns a page of all warranty claims, newest first.
     *
     * @param offset zero-based row offset
     * @param limit max rows to return
     * @return list of WarrantyClaim
     * @throws Exception on SQL error
     */
    public List<WarrantyClaim> findAll(int offset, int limit) throws Exception {
        String sql = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "ORDER BY wc.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<WarrantyClaim> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    // ── COUNT ─────────────────────────────────────────────────────────────────
    /**
     * Returns the total number of warranty claims, optionally filtered by
     * status.
     *
     * @param status status filter, or null/empty for all
     * @return row count
     * @throws Exception on SQL error
     */
    public int count(String status) throws Exception {
        boolean hasStatus = (status != null && !status.trim().isEmpty());
        String sql = hasStatus
                ? "SELECT COUNT(*) FROM WarrantyClaims WHERE status = ?"
                : "SELECT COUNT(*) FROM WarrantyClaims";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            // Kiểm tra điều kiện
            if (hasStatus) {
                ps.setString(1, status);
            }
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // ── SEARCH ────────────────────────────────────────────────────────────────
    /**
     * Searches warranty claims by keyword (matches title, description, serial
     * number).
     *
     * @param keyword search keyword
     * @param offset zero-based row offset
     * @param limit max rows to return
     * @return matching claims
     * @throws Exception on SQL error
     */
    public List<WarrantyClaim> search(String keyword, int offset, int limit) throws Exception {
        String pattern = "%" + keyword.trim() + "%";
        String sql = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE wc.title LIKE ? "
                + "OR wc.description LIKE ? "
                + "OR wc.serial_number LIKE ? "
                + "ORDER BY wc.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<WarrantyClaim> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Returns the count of claims matching the search keyword.
     *
     * @param keyword search keyword
     * @return matching row count
     * @throws Exception on SQL error
     */
    public int countSearch(String keyword) throws Exception {
        String pattern = "%" + keyword.trim() + "%";
        String sql = "SELECT COUNT(*) FROM WarrantyClaims wc "
                + "WHERE wc.title LIKE ? OR wc.description LIKE ? OR wc.serial_number LIKE ?";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // ── FILTER ────────────────────────────────────────────────────────────────
    /**
     * Returns warranty claims filtered by status (paged).
     *
     * @param status status to filter by
     * @param offset zero-based row offset
     * @param limit max rows to return
     * @return matching claims
     * @throws Exception on SQL error
     */
    public List<WarrantyClaim> filter(String status, int offset, int limit) throws Exception {
        String sql = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE wc.status = ? "
                + "ORDER BY wc.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<WarrantyClaim> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    // ── VALIDATION HELPERS ────────────────────────────────────────────────────
    /**
     * Checks whether a serial number exists in the ProductSerials table.
     *
     * @param serialNumber the serial number to check
     * @return true if the serial exists
     * @throws Exception on SQL error
     */
    public boolean serialExists(String serialNumber) throws Exception {
        String sql = "SELECT 1 FROM InventoryItem WHERE serial_number = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Checks whether a serial number belongs to the given customer via a
     * completed order.
     *
     * @param serialNumber the serial number
     * @param customerId the customer to verify ownership
     * @return true if the customer owns the product
     * @throws Exception on SQL error
     */
    public boolean productBelongsToCustomer(String serialNumber, int customerId) throws Exception {
        String sql = "SELECT 1 "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "WHERE ii.serial_number = ? AND (o.user_id = ? OR o.customer_id = ?) AND o.order_status IN ('COMPLETED', 'Completed', 'completed', 'delivered', 'Delivered')";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setInt(2, customerId);
            ps.setInt(3, customerId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Checks whether the product identified by serial number is still under
     * warranty. Warranty expiry is computed as: order completion date +
     * the product's own warranty_period (months), NOT the WarrantyPolicies
     * template — warranty_period is the per-product value shown on the
     * product detail page (e.g. "Bảo hành 24 tháng") and is what customers
     * actually see when they buy.
     *
     * @param serialNumber the serial number to check
     * @return true if warranty is still active
     * @throws Exception on SQL error
     */
    public boolean isUnderWarranty(String serialNumber) throws Exception {
        String sql = "SELECT 1 "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE ii.serial_number = ? "
                + "AND ( "
                + "    (ii.warranty_expired_date IS NOT NULL AND ii.warranty_expired_date >= GETDATE()) "
                + "    OR "
                + "    (ii.warranty_expired_date IS NULL AND DATEADD(MONTH, p.warranty_period, o.completed_at) >= GETDATE()) "
                + ")";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Checks whether an open (unfinished) claim already exists for the serial
     * number. Unfinished statuses: PENDING, PROCESSING, APPROVED.
     *
     * @param serialNumber the serial number to check
     * @return true if an active claim exists
     * @throws Exception on SQL error
     */
    public boolean hasActiveClaim(String serialNumber) throws Exception {
        String sql = "SELECT 1 FROM WarrantyClaims "
                + "WHERE serial_number = ? AND status IN ('PENDING','PROCESSING','APPROVED')";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Retrieves all purchased units (one row per serial number) for a
     * customer, across all their completed orders. Used to render Step 1
     * ("Select Product") of the Submit Claim wizard — replaces manual serial
     * number entry. Each row includes purchase date, computed warranty
     * expiry, and whether an active claim already exists, so the JSP can
     * show eligibility state without an extra query per row.
     *
     * @param customerId the customer whose purchases to list
     * @return list of purchased products, most recently purchased first
     * @throws Exception on SQL error
     */
    public List<model.WarrantyPurchasedProduct> findPurchasedProductsByCustomer(int customerId) throws Exception {
        String sql = "SELECT ii.serial_number AS serialNumber, "
                + "p.product_name AS productName, "
                + "o.completed_at AS purchaseDate, "
                + "ISNULL(ii.warranty_expired_date, DATEADD(MONTH, p.warranty_period, o.completed_at)) AS warrantyExpiry, "
                + "COALESCE(wp.PolicyName, N'Bảo hành tiêu chuẩn') AS coverageName, "
                + "CASE WHEN ISNULL(ii.warranty_expired_date, DATEADD(MONTH, p.warranty_period, o.completed_at)) >= GETDATE() "
                + "     THEN 1 ELSE 0 END AS underWarranty, "
                + "CASE WHEN EXISTS (SELECT 1 FROM WarrantyClaims wc "
                + "                  WHERE wc.serial_number = ii.serial_number "
                + "                  AND wc.status IN ('PENDING','PROCESSING','APPROVED')) "
                + "     THEN 1 ELSE 0 END AS hasActiveClaim "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "LEFT JOIN WarrantyPolicies wp ON p.warranty_policy_id = wp.PolicyID "
                + "WHERE (o.user_id = ? OR o.customer_id = ?) AND o.order_status IN ('COMPLETED', 'Completed', 'completed', 'delivered', 'Delivered') "
                + "ORDER BY o.completed_at DESC, ii.serial_number ASC";

        List<model.WarrantyPurchasedProduct> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.WarrantyPurchasedProduct item = new model.WarrantyPurchasedProduct();
                    item.setSerialNumber(rs.getString("serialNumber"));
                    item.setProductName(rs.getString("productName"));
                    item.setPurchaseDate(rs.getTimestamp("purchaseDate"));
                    item.setWarrantyExpiry(rs.getDate("warrantyExpiry"));
                    item.setCoverageName(rs.getString("coverageName"));
                    item.setUnderWarranty(rs.getInt("underWarranty") == 1);
                    item.setHasActiveClaim(rs.getInt("hasActiveClaim") == 1);
                    list.add(item);
                }
            }
        }
        return list;
    }

    /**
     * Retrieves product name, warranty expiry date, and coverage (policy)
     * name for a serial number. Used to populate Step 2 ("Warranty
     * Information") of the Submit Claim wizard on warranty_center.jsp after
     * a successful Check Eligibility call. Assumes the serial has already
     * passed serialExists / productBelongsToCustomer / isUnderWarranty.
     *
     * @param serialNumber the serial number to look up
     * @return a populated WarrantyEligibilityInfo, or null if not found
     * @throws Exception on SQL error
     */
    public model.WarrantyEligibilityInfo getEligibilityInfo(String serialNumber) throws Exception {
        String sql = "SELECT p.product_name AS productName, "
                + "ISNULL(ii.warranty_expired_date, DATEADD(MONTH, p.warranty_period, o.completed_at)) AS warrantyExpiry, "
                + "COALESCE(wp.PolicyName, N'Bảo hành tiêu chuẩn') AS coverageName "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "LEFT JOIN WarrantyPolicies wp ON p.warranty_policy_id = wp.PolicyID "
                + "WHERE ii.serial_number = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return new model.WarrantyEligibilityInfo(
                            serialNumber,
                            rs.getString("productName"),
                            rs.getDate("warrantyExpiry"),
                            rs.getString("coverageName"));
                }
            }
        }
        return null;
    }

    /**
     * Retrieves the order_detail_id for a given serial number.
     *
     * @param serialNumber the serial number
     * @return order_detail_id, or -1 if not found
     * @throws Exception on SQL error
     */
    public int getOrderDetailIdBySerial(String serialNumber) throws Exception {
        String sql = "SELECT od.order_detail_id, od.order_id "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "WHERE ii.serial_number = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt("order_detail_id");
                }
            }
        }
        return -1;
    }

    /**
     * Retrieves the order_id for a given serial number.
     *
     * @param serialNumber the serial number
     * @return order_id, or -1 if not found
     * @throws Exception on SQL error
     */
    public int getOrderIdBySerial(String serialNumber) throws Exception {
        String sql = "SELECT od.order_id "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "WHERE ii.serial_number = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt("order_id");
                }
            }
        }
        return -1;
    }

    // ── PRIVATE MAPPING ───────────────────────────────────────────────────────
    /**
     * Maps base fields from a ResultSet row to a WarrantyClaim object. Dùng làm
     * helper nội bộ cho mapClaimWithJoin(). Tất cả query hiện tại đều có JOIN
     * nên không gọi method này trực tiếp.
     */
    private WarrantyClaim mapClaim(ResultSet rs) throws SQLException {
        WarrantyClaim c = new WarrantyClaim();
        c.setClaimId(rs.getInt("claim_id"));
        c.setOrderId(rs.getInt("order_id"));
        c.setOrderDetailId(rs.getInt("order_detail_id"));
        c.setCustomerId(rs.getInt("customer_id"));

        int sid = rs.getInt("staff_id");
        c.setStaffId(rs.wasNull() ? null : sid);

        c.setSerialNumber(rs.getString("serial_number"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setCompletedAt(rs.getTimestamp("completed_at"));
        return c;
    }

    /**
     * Map base fields + joined fields — dùng cho query có JOIN với Users và
     * Products. Nếu column name bị typo, lỗi sẽ nổi lên ngay thay vì bị nuốt.
     */
    private WarrantyClaim mapClaimWithJoin(ResultSet rs) throws SQLException {
        WarrantyClaim c = mapClaim(rs);
        c.setCustomerName(rs.getString("customer_name"));
        c.setProductName(rs.getString("product_name"));
        return c;
    }
}
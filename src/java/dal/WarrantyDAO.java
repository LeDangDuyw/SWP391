package dal;

import model.WarrantyClaim;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Class: WarrantyDAO
 * Description: Data Access Object (DAO) chuyên trách truy xuất, tạo mới và cập nhật trạng thái yêu cầu bảo hành (Warranty Claims).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-23
 * Version: v2.4
 *
 * @author DuyLD
 */
public class WarrantyDAO extends DBContext {


    /**
     * Tạo mới một yêu cầu bảo hành trong cơ sở dữ liệu và trả về mã ID (claim_id) vừa được tạo ra.
     *
     * @param claim Đối tượng WarrantyClaim chứa thông tin đơn bảo hành
     * @return claimId vừa được tạo, hoặc -1 nếu tạo thất bại
     * @throws Exception Ngoại lệ SQL
     */
    public int insertClaim(WarrantyClaim claim) throws Exception {
        String sql = "INSERT INTO WarrantyClaims "
                + "(order_id, order_detail_id, customer_id, serial_number, "
                + " title, description, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', GETDATE(), GETDATE())";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, claim.getOrderId());
            ps.setInt(2, claim.getOrderDetailId());
            ps.setInt(3, claim.getCustomerId());
            ps.setString(4, claim.getSerialNumber());
            ps.setString(5, claim.getTitle());
            ps.setString(6, claim.getDescription());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Cập nhật trạng thái (và thời điểm hoàn tất completed_at nếu COMPLETED) cho một đơn bảo hành.
     *
     * @param claimId   ID của đơn bảo hành
     * @param newStatus Trạng thái mới (PENDING, PROCESSING, APPROVED, REJECTED, COMPLETED...)
     * @throws Exception Ngoại lệ SQL
     */
    public void updateStatus(int claimId, String newStatus) throws Exception {
        boolean isCompleted = "COMPLETED".equals(newStatus);

        String sql = isCompleted
                ? "UPDATE WarrantyClaims SET status = ?, updated_at = GETDATE(), completed_at = GETDATE() WHERE claim_id = ?"
                : "UPDATE WarrantyClaims SET status = ?, updated_at = GETDATE() WHERE claim_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, claimId);
            ps.executeUpdate();
        }
    }

    /**
     * Phân công Nhân viên xử lý và chuyển trạng thái từ PENDING sang PROCESSING.
     * Sử dụng khóa lạc quan (Optimistic Locking status = 'PENDING') để tránh xung đột race condition.
     *
     * @param claimId ID đơn bảo hành
     * @param staffId ID của nhân viên tiếp nhận
     * @return Số dòng bị thay đổi (0 nghĩa là đơn đã bị nhân viên khác nhận trước)
     * @throws Exception Ngoại lệ SQL
     */
    public int assignStaffAndProcess(int claimId, int staffId) throws Exception {
        String sql = "UPDATE WarrantyClaims "
                + "SET staff_id = ?, status = 'PROCESSING', updated_at = GETDATE() "
                + "WHERE claim_id = ? AND status = 'PENDING'";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, claimId);
            return ps.executeUpdate();
        }
    }

    /**
     * Tìm kiếm một đơn bảo hành theo ID, kết hợp với bảng User và Product để lấy thông tin khách hàng và tên sản phẩm.
     *
     * @param claimId Mã ID của đơn bảo hành
     * @return Đối tượng WarrantyClaim hoặc null nếu không tìm thấy
     * @throws Exception Ngoại lệ SQL
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

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClaimWithJoin(rs);
                }
            }
        }
        return null;
    }

    /**
     * Lấy toàn bộ danh sách đơn bảo hành của một khách hàng cụ thể (sắp xếp mới nhất lên đầu).
     *
     * @param customerId Mã ID khách hàng
     * @return Danh sách các đơn WarrantyClaim
     * @throws Exception Ngoại lệ SQL
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Lấy danh sách đơn bảo hành của khách hàng kèm phân trang (Offset / Fetch Limit).
     */
    public List<WarrantyClaim> findByCustomer(int customerId, int offset, int limit) throws Exception {
        String sql = "SELECT wc.*, "
                + "u.full_name AS customer_name, "
                + "p.product_name "
                + "FROM WarrantyClaims wc "
                + "JOIN [User] u ON wc.customer_id = u.user_id "
                + "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id "
                + "JOIN ProductVariant pv ON od.variant_id = pv.variant_id "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE wc.customer_id = ? "
                + "ORDER BY wc.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<WarrantyClaim> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm tổng số đơn bảo hành của một khách hàng.
     */
    public int countByCustomer(int customerId) throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyClaims WHERE customer_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Tìm kiếm và lọc danh sách đơn bảo hành của khách hàng theo từ khóa và trạng thái.
     */
    public List<WarrantyClaim> searchCustomerClaims(int customerId, String keyword, String statusFilter, int offset, int limit) throws Exception {
        StringBuilder sql = new StringBuilder(
            "SELECT wc.*, u.full_name AS customer_name, p.product_name " +
            "FROM WarrantyClaims wc " +
            "JOIN [User] u ON wc.customer_id = u.user_id " +
            "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id " +
            "JOIN ProductVariant pv ON od.variant_id = pv.variant_id " +
            "JOIN Product p ON pv.product_id = p.product_id " +
            "WHERE wc.customer_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (CAST(wc.claim_id AS VARCHAR) LIKE ? OR p.product_name LIKE ? OR wc.title LIKE ? OR wc.description LIKE ? OR wc.serial_number LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter.trim())) {
            sql.append("AND wc.status = ? ");
            params.add(statusFilter.trim().toUpperCase());
        }

        sql.append("ORDER BY wc.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        List<WarrantyClaim> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm số lượng đơn bảo hành thỏa mãn điều kiện lọc của khách hàng.
     */
    public int countCustomerClaims(int customerId, String keyword, String statusFilter) throws Exception {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM WarrantyClaims wc " +
            "JOIN OrderDetail od ON wc.order_detail_id = od.order_detail_id " +
            "JOIN ProductVariant pv ON od.variant_id = pv.variant_id " +
            "JOIN Product p ON pv.product_id = p.product_id " +
            "WHERE wc.customer_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (CAST(wc.claim_id AS VARCHAR) LIKE ? OR p.product_name LIKE ? OR wc.title LIKE ? OR wc.description LIKE ? OR wc.serial_number LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter.trim())) {
            sql.append("AND wc.status = ? ");
            params.add(statusFilter.trim().toUpperCase());
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Lấy toàn bộ danh sách đơn bảo hành trong hệ thống phân trang (dành cho Admin/Staff console).
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm tổng số đơn bảo hành trong hệ thống, có thể lọc theo trạng thái.
     */
    public int count(String status) throws Exception {
        boolean hasStatus = (status != null && !status.trim().isEmpty());
        String sql = hasStatus
                ? "SELECT COUNT(*) FROM WarrantyClaims WHERE status = ?"
                : "SELECT COUNT(*) FROM WarrantyClaims";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasStatus) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Tìm kiếm đơn bảo hành theo từ khóa (tiêu đề, mô tả, số Serial/IMEI).
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm số lượng đơn bảo hành tìm thấy theo từ khóa.
     */
    public int countSearch(String keyword) throws Exception {
        String pattern = "%" + keyword.trim() + "%";
        String sql = "SELECT COUNT(*) FROM WarrantyClaims wc "
                + "WHERE wc.title LIKE ? OR wc.description LIKE ? OR wc.serial_number LIKE ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Lọc danh sách đơn bảo hành theo trạng thái chỉ định.
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaimWithJoin(rs));
                }
            }
        }
        return list;
    }

    /**
     * Kiểm tra số Serial/IMEI sản phẩm có tồn tại trong bảng kho InventoryItem hay không.
     */
    public boolean serialExists(String serialNumber) throws Exception {
        String sql = "SELECT 1 FROM InventoryItem WHERE serial_number = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra xem sản phẩm theo số Serial/IMEI có thuộc sở hữu của khách hàng qua đơn hàng thành công không.
     */
    public boolean productBelongsToCustomer(String serialNumber, int customerId) throws Exception {
        String sql = "SELECT 1 "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "JOIN [Order] o ON od.order_id = o.order_id "
                + "WHERE ii.serial_number = ? AND (o.user_id = ? OR o.customer_id = ?) AND o.order_status IN ('COMPLETED', 'Completed', 'completed', 'delivered', 'Delivered')";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setInt(2, customerId);
            ps.setInt(3, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra xem sản phẩm còn trong thời hạn bảo hành hay không (dựa trên hạn bảo hành của sản phẩm/kho).
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra xem sản phẩm có đơn bảo hành đang dở dang chưa hoàn thành hay không (PENDING, PROCESSING, APPROVED).
     */
    public boolean hasActiveClaim(String serialNumber) throws Exception {
        String sql = "SELECT 1 FROM WarrantyClaims "
                + "WHERE serial_number = ? AND status IN ('PENDING','PROCESSING','APPROVED')";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Lấy danh sách các sản phẩm đã mua của khách hàng phục vụ bước chọn sản phẩm bảo hành trên giao diện Trung tâm bảo hành.
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
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
     * Lấy thông tin tính đủ điều kiện bảo hành (Tên SP, Hạn BH, Tên chính sách BH) dựa vào số Serial/IMEI.
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
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
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
     * Lấy order_detail_id theo số Serial/IMEI.
     */
    public int getOrderDetailIdBySerial(String serialNumber) throws Exception {
        String sql = "SELECT od.order_detail_id, od.order_id "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "WHERE ii.serial_number = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("order_detail_id");
                }
            }
        }
        return -1;
    }

    /**
     * Lấy order_id theo số Serial/IMEI.
     */
    public int getOrderIdBySerial(String serialNumber) throws Exception {
        String sql = "SELECT od.order_id "
                + "FROM InventoryItem ii "
                + "JOIN OrderItemSerial ois ON ii.item_id = ois.item_id "
                + "JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id "
                + "WHERE ii.serial_number = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("order_id");
                }
            }
        }
        return -1;
    }

    /**
     * Map thông tin cơ bản từ ResultSet vào đối tượng WarrantyClaim.
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
     * Map các thuộc tính của WarrantyClaim kèm theo thông tin JOIN (customer_name, product_name).
     */
    private WarrantyClaim mapClaimWithJoin(ResultSet rs) throws SQLException {
        WarrantyClaim c = mapClaim(rs);
        c.setCustomerName(rs.getString("customer_name"));
        c.setProductName(rs.getString("product_name"));
        return c;
    }

    /**
     * Đổi nhân viên chịu trách nhiệm xử lý đơn bảo hành (Admin Reassign).
     */
    public int reassignStaff(int claimId, int newStaffId) throws Exception {
        String sql = "UPDATE WarrantyClaims "
                + "SET staff_id = ?, updated_at = GETDATE() "
                + "WHERE claim_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newStaffId);
            ps.setInt(2, claimId);
            return ps.executeUpdate();
        }
    }

    /**
     * Lấy danh sách nhân viên active (role_id = 2) phục vụ việc gán công việc bảo hành trong trang Admin.
     */
    public List<model.Users> findStaffList() throws Exception {
        String sql = "SELECT user_id, full_name, email, phone, password, status, role_id "
                + "FROM [User] WHERE role_id = 2 AND status = 'active' ORDER BY full_name";
        List<model.Users> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new model.Users(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("password"),
                            rs.getString("status"),
                            rs.getInt("role_id")
                    ));
                }
            }
        }
        return list;
    }
}
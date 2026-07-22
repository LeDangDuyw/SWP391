package dal;

/**
 * Class: WarrantyDAO
 * Description: Data Access Object xử lý lưu trữ, truy vấn, tìm kiếm, phân trang và cập nhật trạng thái yêu cầu bảo hành (WarrantyClaims).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-22
 * Version: v2.8
 *
 * @author DuyLD
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Users;
import model.WarrantyClaim;
import model.WarrantyEligibilityInfo;
import model.WarrantyPurchasedProduct;

public class WarrantyDAO extends DBContext {

    /**
     * Thêm mới một phiếu bảo hành vào CSDL và trả về claim_id vừa tạo.
     *
     * @param claim đối tượng WarrantyClaim chứa thông tin tạo mới
     * @return claim_id được sinh tự động, hoặc -1 nếu thất bại
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Cập nhật trạng thái phiếu bảo hành (và mốc completed_at nếu chuyển sang COMPLETED).
     *
     * @param claimId   ID phiếu bảo hành
     * @param newStatus trạng thái mới ("PROCESSING", "APPROVED", "REJECTED", "COMPLETED", "CANCELLED")
     * @throws Exception nếu xảy ra lỗi SQL
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
     * BR-23: Phân công nhân viên xử lý và chuyển trạng thái PENDING -> PROCESSING trong 1 câu lệnh nguyên tử (Atomic Query).
     * Sử dụng Optimistic Locking (WHERE status = 'PENDING') để tránh xung đột race condition khi 2 Staff cùng bấm tiếp nhận.
     *
     * @param claimId ID phiếu bảo hành
     * @param staffId ID nhân viên tiếp nhận
     * @return số dòng bị ảnh hưởng (0 = yêu cầu đã bị người khác nhận trước)
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Truy vấn thông tin chi tiết một phiếu bảo hành theo claim_id (kèm tên khách hàng và tên sản phẩm).
     *
     * @param claimId ID phiếu bảo hành
     * @return đối tượng WarrantyClaim hoặc null nếu không tìm thấy
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public WarrantyClaim findById(int claimId) throws Exception {
        String sql = "SELECT wc.*, "
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
     * Lấy toàn bộ danh sách phiếu bảo hành của một khách hàng cụ thể (mới nhất trước).
     *
     * @param customerId ID khách hàng
     * @return danh sách các WarrantyClaim
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Lấy danh sách phiếu bảo hành có phân trang (dùng cho giao diện Quản trị).
     *
     * @param offset số dòng bỏ qua
     * @param limit  số lượng bản ghi tối đa
     * @return danh sách WarrantyClaim
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Đếm tổng số lượng phiếu bảo hành (có hỗ trợ lọc theo trạng thái).
     *
     * @param status trạng thái lọc (hoặc null nếu đếm tất cả)
     * @return tổng số bản ghi
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Tìm kiếm phiếu bảo hành theo từ khóa (khớp tiêu đề, mô tả lỗi hoặc số serial) có phân trang.
     *
     * @param keyword từ khóa tìm kiếm
     * @param offset  số dòng bỏ qua
     * @param limit   số lượng bản ghi tối đa
     * @return danh sách các WarrantyClaim thỏa điều kiện
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Đếm số lượng phiếu bảo hành thỏa mãn từ khóa tìm kiếm.
     *
     * @param keyword từ khóa tìm kiếm
     * @return số lượng bản ghi
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Lọc phiếu bảo hành theo trạng thái cụ thể có phân trang.
     *
     * @param status trạng thái cần lọc
     * @param offset số dòng bỏ qua
     * @param limit  số lượng bản ghi tối đa
     * @return danh sách các WarrantyClaim
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Kiểm tra số serial có tồn tại trong bảng InventoryItem hay không.
     *
     * @param serialNumber số serial cần kiểm tra
     * @return true nếu tồn tại, false nếu không
     * @throws Exception nếu xảy ra lỗi SQL
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
     * BR-15: Kiểm tra số serial có thuộc đơn hàng hoàn thành (COMPLETED/DELIVERED) của chính khách hàng đó không.
     *
     * @param serialNumber số serial
     * @param customerId   ID khách hàng
     * @return true nếu chính chủ sản phẩm, false nếu không
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Kiểm tra sản phẩm mang số serial còn trong hạn bảo hành hay không (dựa vào mốc ngày mua + tháng bảo hành).
     *
     * @param serialNumber số serial cần kiểm tra
     * @return true nếu còn hạn bảo hành, false nếu hết hạn
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Kiểm tra xem số serial đã có phiếu bảo hành nào đang trong quá trình xử lý (PENDING, PROCESSING, APPROVED) hay chưa.
     *
     * @param serialNumber số serial
     * @return true nếu đã có yêu cầu active, false nếu chưa
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Truy vấn danh sách các sản phẩm đã mua của khách hàng (dùng cho Bước 1 Chọn sản phẩm của wizard tạo yêu cầu bảo hành).
     *
     * @param customerId ID khách hàng
     * @return danh sách các WarrantyPurchasedProduct
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public List<WarrantyPurchasedProduct> findPurchasedProductsByCustomer(int customerId) throws Exception {
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

        List<WarrantyPurchasedProduct> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WarrantyPurchasedProduct item = new WarrantyPurchasedProduct();
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
     * Lấy thông tin tính hợp lệ bảo hành (tên sản phẩm, thời hạn, tên chính sách) theo số serial.
     *
     * @param serialNumber số serial
     * @return đối tượng WarrantyEligibilityInfo
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public WarrantyEligibilityInfo getEligibilityInfo(String serialNumber) throws Exception {
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
                    return new WarrantyEligibilityInfo(
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
     * Lấy order_detail_id dựa trên số serial.
     *
     * @param serialNumber số serial
     * @return order_detail_id hoặc -1 nếu không tìm thấy
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public int getOrderDetailIdBySerial(String serialNumber) throws Exception {
        String sql = "SELECT od.order_detail_id "
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
     * Lấy order_id dựa trên số serial.
     *
     * @param serialNumber số serial
     * @return order_id hoặc -1 nếu không tìm thấy
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Helper ánh xạ dữ liệu ResultSet sang WarrantyClaim.
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
     * Helper ánh xạ dữ liệu ResultSet (kèm JOIN User và Product) sang WarrantyClaim.
     */
    private WarrantyClaim mapClaimWithJoin(ResultSet rs) throws SQLException {
        WarrantyClaim c = mapClaim(rs);
        c.setCustomerName(rs.getString("customer_name"));
        c.setProductName(rs.getString("product_name"));
        return c;
    }

    /**
     * Phân công lại (Reassign) phiếu bảo hành cho nhân viên khác (dành cho Admin/Staff Take Over).
     *
     * @param claimId    ID phiếu bảo hành
     * @param newStaffId ID nhân viên mới
     * @return số dòng bị ảnh hưởng
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Lấy danh sách toàn bộ nhân viên (role_id = 2) đang active để đổ vào dropdown phân công lại.
     *
     * @return danh sách các Users nhân viên
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public List<Users> findStaffList() throws Exception {
        String sql = "SELECT user_id, full_name, email, phone, password, status, role_id "
                + "FROM [User] WHERE role_id = 2 AND status = 'active' ORDER BY full_name";
        List<Users> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Users(
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
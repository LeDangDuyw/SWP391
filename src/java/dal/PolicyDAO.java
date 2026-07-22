package dal;

/**
 * Class: PolicyDAO
 * Description: Data Access Object xử lý các thao tác CRUD, tìm kiếm, phân trang
 *              và quản lý lịch sử phiên bản cho Chính sách bảo hành (WarrantyPolicies).
 *
 * Created: 2026-05-31
 * Updated: 2026-07-22
 * Version: v2.6
 *
 * @author DuyLD
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.PolicyHistory;
import model.WarrantyPolicy;

public class PolicyDAO extends DBContext {

    /**
     * Lấy thông tin một chính sách bảo hành theo ID.
     *
     * @param id ID của chính sách
     * @return đối tượng WarrantyPolicy hoặc null nếu không tìm thấy
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public WarrantyPolicy getPolicyById(int id) throws Exception {
        String sql = "SELECT * FROM WarrantyPolicies WHERE PolicyID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPolicy(rs);
                }
            }
        }
        return null;
    }

    /**
     * Thêm mới một bản ghi chính sách bảo hành vào cơ sở dữ liệu.
     *
     * @param p đối tượng WarrantyPolicy cần thêm mới
     * @return PolicyID vừa tạo (tự tăng), hoặc -1 nếu thất bại
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public int insertPolicy(WarrantyPolicy p) throws Exception {
        String sql = "INSERT INTO WarrantyPolicies "
                + "(PolicyName, Description, PolicyContent, ApplicableRegions, "
                + " WarrantyMonths, Status, Version, EffectiveDate, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getPolicyName());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getPolicyContent());
            ps.setString(4, p.getApplicableRegions());
            ps.setInt(5, p.getWarrantyMonths());
            ps.setString(6, p.getStatus());
            ps.setString(7, p.getVersion());
            ps.setDate(8, p.getEffectiveDate());
            ps.setTimestamp(9, p.getCreatedAt());
            ps.setTimestamp(10, p.getUpdatedAt());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Kiểm tra xem tên chính sách bảo hành đã tồn tại trong hệ thống hay chưa (dùng khi tạo mới).
     *
     * @param policyName tên chính sách cần kiểm tra
     * @return true nếu tên đã tồn tại, false nếu chưa
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public boolean existsPolicyName(String policyName) throws Exception {
        if (policyName == null) {
            return false;
        }
        String sql = "SELECT 1 FROM WarrantyPolicies WHERE LOWER(PolicyName) = LOWER(?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, policyName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Kiểm tra xem tên chính sách đã tồn tại ở bản ghi khác hay chưa (dùng khi cập nhật).
     *
     * @param policyName tên chính sách mới
     * @param policyId   ID của chính sách đang chỉnh sửa
     * @return true nếu trùng tên với bản ghi khác, false nếu không trùng
     */
    public boolean existsPolicyNameForUpdate(String policyName, int policyId) {
        if (policyName == null) {
            return false;
        }
        String sql = "SELECT 1 FROM WarrantyPolicies WHERE LOWER(PolicyName) = LOWER(?) AND PolicyID <> ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, policyName.trim());
            ps.setInt(2, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("PolicyDAO.existsPolicyNameForUpdate Error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cập nhật thông tin một chính sách bảo hành hiện có.
     *
     * @param p đối tượng WarrantyPolicy đã chỉnh sửa
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void updatePolicy(WarrantyPolicy p) throws Exception {
        String sql = "UPDATE WarrantyPolicies "
                + "SET PolicyName = ?, Description = ?, PolicyContent = ?, "
                + "    ApplicableRegions = ?, WarrantyMonths = ?, Status = ?, "
                + "    Version = ?, EffectiveDate = ?, UpdatedAt = ? "
                + "WHERE PolicyID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getPolicyName());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getPolicyContent());
            ps.setString(4, p.getApplicableRegions());
            ps.setInt(5, p.getWarrantyMonths());
            ps.setString(6, p.getStatus());
            ps.setString(7, p.getVersion());
            ps.setDate(8, p.getEffectiveDate());
            ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            ps.setInt(10, p.getPolicyId());
            ps.executeUpdate();
        }
    }

    /**
     * Xóa một chính sách bảo hành cùng toàn bộ lịch sử phiên bản liên quan (dùng giao tác Transaction).
     *
     * @param id ID chính sách cần xóa
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void deletePolicy(int id) throws Exception {
        String deleteHistorySql = "DELETE FROM WarrantyPolicyHistory WHERE PolicyID = ?";
        String deletePolicySql = "DELETE FROM WarrantyPolicies WHERE PolicyID = ?";
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement psHist = con.prepareStatement(deleteHistorySql)) {
                    psHist.setInt(1, id);
                    psHist.executeUpdate();
                }
                try (PreparedStatement psPol = con.prepareStatement(deletePolicySql)) {
                    psPol.setInt(1, id);
                    psPol.executeUpdate();
                }
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    /**
     * Phương thức helper cập nhật trạng thái của chính sách.
     */
    private void updateStatus(int id, String status) throws Exception {
        String sql = "UPDATE WarrantyPolicies SET Status = ?, UpdatedAt = ? WHERE PolicyID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    /**
     * Xuất bản chính sách (chuyển trạng thái sang LIVE).
     *
     * @param id ID của chính sách
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void publishPolicy(int id) throws Exception {
        updateStatus(id, "LIVE");
    }

    /**
     * Lưu nháp chính sách (chuyển trạng thái sang DRAFT).
     *
     * @param id ID của chính sách
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void saveDraft(int id) throws Exception {
        updateStatus(id, "DRAFT");
    }

    /**
     * BR-25: Vô hiệu hóa chính sách bảo hành (chuyển trạng thái sang DISABLED).
     * Việc vô hiệu hóa không làm mất hiệu lực các bảo hành sản phẩm đã mua trước đó.
     *
     * @param id ID của chính sách
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void disablePolicy(int id) throws Exception {
        updateStatus(id, "DISABLED");
    }

    /**
     * Helper ánh xạ dữ liệu từ ResultSet sang đối tượng WarrantyPolicy.
     */
    private WarrantyPolicy mapPolicy(ResultSet rs) throws Exception {
        WarrantyPolicy p = new WarrantyPolicy();
        p.setPolicyId(rs.getInt("PolicyID"));
        p.setPolicyName(rs.getString("PolicyName"));
        p.setDescription(rs.getString("Description"));
        p.setPolicyContent(rs.getString("PolicyContent"));
        p.setApplicableRegions(rs.getString("ApplicableRegions"));
        p.setWarrantyMonths(rs.getInt("WarrantyMonths"));
        p.setStatus(rs.getString("Status"));
        p.setVersion(rs.getString("Version"));
        p.setEffectiveDate(rs.getDate("EffectiveDate"));
        p.setCreatedAt(rs.getTimestamp("CreatedAt"));
        p.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return p;
    }

    /**
     * Ghi vết nhật ký thay đổi phiên bản chính sách vào bảng WarrantyPolicyHistory.
     *
     * @param policyId   ID chính sách
     * @param policyName tên chính sách
     * @param version    số phiên bản
     * @param description mô tả ngắn
     * @param content    nội dung chính sách
     * @param status     trạng thái
     * @param actionType loại hành động ("CREATE", "UPDATE", "PUBLISH", "DISABLE")
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void insertHistory(int policyId, String policyName, String version, String description, String content, String status, String actionType) throws Exception {
        String sql = "INSERT INTO WarrantyPolicyHistory (PolicyID, PolicyName, Version, Description, PolicyContent, Status, ActionType, ChangedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            ps.setString(2, policyName);
            ps.setString(3, version);
            ps.setString(4, description);
            ps.setString(5, content);
            ps.setString(6, status);
            ps.setString(7, actionType);
            ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
        }
    }

    /**
     * Lấy danh sách lịch sử thay đổi phiên bản của một chính sách bảo hành, mới nhất trước.
     *
     * @param policyId ID chính sách
     * @return danh sách các bản ghi PolicyHistory
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public List<PolicyHistory> getHistoryByPolicyId(int policyId) throws Exception {
        List<PolicyHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicyHistory WHERE PolicyID = ? ORDER BY ChangedAt DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PolicyHistory h = new PolicyHistory();
                    h.setHistoryId(rs.getInt("HistoryID"));
                    h.setPolicyId(rs.getInt("PolicyID"));
                    h.setPolicyName(rs.getString("PolicyName"));
                    h.setVersion(rs.getString("Version"));
                    h.setDescription(rs.getString("Description"));
                    h.setPolicyContent(rs.getString("PolicyContent"));
                    h.setStatus(rs.getString("Status"));
                    h.setActionType(rs.getString("ActionType"));
                    h.setChangedAt(rs.getTimestamp("ChangedAt"));
                    list.add(h);
                }
            }
        }
        return list;
    }

    /**
     * Đếm tổng số chính sách bảo hành thỏa mãn từ khóa tìm kiếm và trạng thái (phục vụ tính số trang).
     *
     * @param keyword  từ khóa tìm kiếm tên chính sách (hoặc null)
     * @param status   trạng thái lọc (hoặc null)
     * @return tổng số bản ghi thỏa điều kiện
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public int countPolicies(String keyword, String status) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM WarrantyPolicies WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND PolicyName LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
        }
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status.trim());
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
     * Lấy danh sách chính sách bảo hành có hỗ trợ lọc từ khóa, lọc trạng thái và phân trang.
     *
     * @param keyword  từ khóa tìm kiếm tên chính sách
     * @param status   trạng thái lọc
     * @param offset   số dòng bỏ qua
     * @param pageSize số bản ghi mỗi trang
     * @return danh sách WarrantyPolicy
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public List<WarrantyPolicy> getPoliciesPaging(String keyword, String status, int offset, int pageSize) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM WarrantyPolicies WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND PolicyName LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
        }
        sql.append(" ORDER BY PolicyID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status.trim());
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }
        return list;
    }
}

package dal;

import model.WarrantyPolicy;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Class: PolicyDAO
 * Description: Data Access Object (DAO) xử lý truy vấn và thao tác dữ liệu chính sách bảo hành (WarrantyPolicies).
 * 
 * Created: 2026-05-31
 * Updated: 2026-07-23
 * Version: v2.6
 *
 * @author DuyLD
 */
public class PolicyDAO extends DBContext {


    /**
     * Lấy toàn bộ danh sách các chính sách bảo hành, sắp xếp mới nhất lên đầu.
     */
    public List<WarrantyPolicy> getAllPolicies() throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies ORDER BY PolicyID DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPolicy(rs));
            }
        }
        return list;
    }

    /**
     * Lấy thông tin một chính sách bảo hành theo ID.
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
     * Thêm mới một chính sách bảo hành vào DB và trả về ID tự tăng vừa được tạo.
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
     * Kiểm tra tên chính sách bảo hành đã tồn tại hay chưa (không phân biệt hoa/thường).
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
     * Tìm kiếm chính sách bảo hành theo tên.
     */
    public List<WarrantyPolicy> searchPolicies(String keyword) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies "
                + "WHERE PolicyName LIKE ? "
                + "ORDER BY PolicyID DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }
        return list;
    }

    /**
     * Kiểm tra xem tên chính sách đã bị trùng với chính sách khác trong lúc cập nhật hay không.
     */
    public boolean existsPolicyNameForUpdate(String policyName, int policyId) {
        if (policyName == null) {
            return false;
        }
        String sql = """
        SELECT 1
        FROM WarrantyPolicies
        WHERE LOWER(PolicyName) = LOWER(?)
        AND PolicyID <> ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, policyName.trim());
            ps.setInt(2, policyId);

            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách chính sách bảo hành lọc theo trạng thái (LIVE, DRAFT, DISABLED...).
     */
    public List<WarrantyPolicy> getPoliciesByStatus(String status) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies WHERE Status = ? ORDER BY PolicyID DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }
        return list;
    }

    /**
     * Cập nhật thông tin một chính sách bảo hành hiện có.
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
     * Xóa hoàn toàn một chính sách bảo hành cùng toàn bộ lịch sử thay đổi phiên bản (Transaction atomic).
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
     * Cập nhật trạng thái của chính sách bảo hành.
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
     * Đếm tổng số lượng chính sách bảo hành.
     */
    public int countPolicies() throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyPolicies";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Đếm số lượng chính sách tìm kiếm theo từ khóa.
     */
    public int countSearchPolicies(String keyword) throws Exception {
        String sql = """
        SELECT COUNT(*)
        FROM WarrantyPolicies
        WHERE PolicyName LIKE ?
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Phân trang danh sách chính sách bảo hành mặc định.
     */
    public List<WarrantyPolicy> getPoliciesPaging(
            int offset,
            int pageSize) throws Exception {

        List<WarrantyPolicy> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM WarrantyPolicies
        ORDER BY PolicyID DESC
        OFFSET ? ROWS
        FETCH NEXT ? ROWS ONLY
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPolicy(rs));
            }
        }

        return list;
    }

    /**
     * Phân trang danh sách chính sách bảo hành theo từ khóa tìm kiếm.
     */
    public List<WarrantyPolicy> searchPoliciesPaging(
            String keyword,
            int offset,
            int pageSize) throws Exception {

        List<WarrantyPolicy> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM WarrantyPolicies
        WHERE PolicyName LIKE ?
        ORDER BY PolicyID DESC
        OFFSET ? ROWS
        FETCH NEXT ? ROWS ONLY
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPolicy(rs));
            }
        }

        return list;
    }

    /**
     * Phát hành chính sách bảo hành (chuyển trạng thái sang LIVE).
     */
    public void publishPolicy(int id) throws Exception {
        updateStatus(id, "LIVE");
    }

    /**
     * Lưu chính sách bảo hành dưới dạng bản nháp (chuyển trạng thái sang DRAFT).
     */
    public void saveDraft(int id) throws Exception {
        updateStatus(id, "DRAFT");
    }

    /**
     * Vô hiệu hóa chính sách bảo hành (BR-25: chuyển trạng thái sang DISABLED mà không ảnh hưởng tới sản phẩm đã mua trước đó).
     */
    public void disablePolicy(int id) throws Exception {
        updateStatus(id, "DISABLED");
    }

    /**
     * Ánh xạ dữ liệu từ ResultSet sang đối tượng WarrantyPolicy.
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
     * Lưu vết lịch sử thay đổi thông tin/phiên bản của một chính sách bảo hành vào bảng WarrantyPolicyHistory.
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
     * Truy xuất toàn bộ lịch sử thay đổi các phiên bản của một chính sách bảo hành theo PolicyID.
     */
    public List<model.PolicyHistory> getHistoryByPolicyId(int policyId) throws Exception {
        List<model.PolicyHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicyHistory WHERE PolicyID = ? ORDER BY ChangedAt DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.PolicyHistory h = new model.PolicyHistory();
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
     * Đếm tổng số lượng chính sách bảo hành hỗ trợ lọc theo từ khóa và trạng thái.
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
     * Lấy danh sách chính sách bảo hành phân trang nâng cao (hỗ trợ lọc từ khóa và trạng thái).
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


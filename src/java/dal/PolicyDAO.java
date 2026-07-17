package dal;
/**
 * Class: PolicyDAO
 * Description: Data Access Object xử lý truy vấn chính sách bảo hành trong CSDL.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-07-02 23:39:42 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: PolicyDAO
 * Description: Data Access Object xử lý truy vấn chính sách bảo hành trong CSDL.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-07-02 23:39:42 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import model.WarrantyPolicy;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class PolicyDAO extends DBContext {

    /*
     * Retrieves all warranty policies ordered by most recently created.
     */
    public List<WarrantyPolicy> getAllPolicies() throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies ORDER BY PolicyID DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPolicy(rs));
            }
        }
        return list;
    }

    /*
     * Retrieves a single warranty policy by its unique identifier.
     */
    public WarrantyPolicy getPolicyById(int id) throws Exception {
        String sql = "SELECT * FROM WarrantyPolicies WHERE PolicyID = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return mapPolicy(rs);
                }
            }
        }
        return null;
    }

    /*
     * Creates a new warranty policy record in the database.
     */
    public int insertPolicy(WarrantyPolicy p) throws Exception {
        String sql = "INSERT INTO WarrantyPolicies "
                + "(PolicyName, Description, PolicyContent, ApplicableRegions, "
                + " WarrantyMonths, Status, Version, EffectiveDate, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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
            
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.getGeneratedKeys()) {
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                // Nếu tồn tại bản ghi kết quả từ database
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /*
     * Check existed policy name in the policy list
     *
     */
    public boolean existsPolicyName(String policyName) throws Exception {
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (policyName == null) {
            return false;
        }
        String sql = "SELECT 1 FROM WarrantyPolicies WHERE LOWER(PolicyName) = LOWER(?)";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, policyName.trim());

            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /*
     * Searches for policies whose name or description matches the given
     * keyword.
     */
    public List<WarrantyPolicy> searchPolicies(String keyword) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies "
                + "WHERE PolicyName LIKE ? "
                + "ORDER BY PolicyID DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }
        return list;
    }

    /*
     * Check for existed policy bane for update
     *
     */
    public boolean existsPolicyNameForUpdate(String policyName, int policyId) {
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (policyName == null) {
            return false;
        }
        String sql = """
        SELECT 1
        FROM WarrantyPolicies
        WHERE LOWER(PolicyName) = LOWER(?)
        AND PolicyID <> ?
        """;

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, policyName.trim());
            ps.setInt(2, policyId);

            ResultSet rs = ps.executeQuery();
            return rs.next();
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /*
     * Retrieves all warranty policies matching the given status value.
     */
    public List<WarrantyPolicy> getPoliciesByStatus(String status) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies WHERE Status = ? ORDER BY PolicyID DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }
        return list;
    }

    /*
     * Updates an existing warranty policy record with the provided values.
     */
    public void updatePolicy(WarrantyPolicy p) throws Exception {
        String sql = "UPDATE WarrantyPolicies "
                + "SET PolicyName = ?, Description = ?, PolicyContent = ?, "
                + "    ApplicableRegions = ?, WarrantyMonths = ?, Status = ?, "
                + "    Version = ?, EffectiveDate = ?, UpdatedAt = ? "
                + "WHERE PolicyID = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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
     * Phuong thuc deletePolicy
     */
    public void deletePolicy(int id) throws Exception {
        String deleteHistorySql = "DELETE FROM WarrantyPolicyHistory WHERE PolicyID = ?";
        String deletePolicySql = "DELETE FROM WarrantyPolicies WHERE PolicyID = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try {
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try (PreparedStatement psHist = con.prepareStatement(deleteHistorySql)) {
                    psHist.setInt(1, id);
                    psHist.executeUpdate();
                }
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try (PreparedStatement psPol = con.prepareStatement(deletePolicySql)) {
                    psPol.setInt(1, id);
                    psPol.executeUpdate();
                }
                con.commit();
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    /*
     * Updates the status of a warranty policy to the specified value.
     */
    private void updateStatus(int id, String status) throws Exception {
        String sql = "UPDATE WarrantyPolicies SET Status = ?, UpdatedAt = ? WHERE PolicyID = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    /*
     * Count total policies.
     */
    public int countPolicies() throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyPolicies";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /*
     * Count total search by name policies
     */
    public int countSearchPolicies(String keyword) throws Exception {
        String sql = """
        SELECT COUNT(*)
        FROM WarrantyPolicies
        WHERE PolicyName LIKE ?
        """;

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            // Nếu tồn tại bản ghi kết quả từ database
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /*
     * Norma; paging
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

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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

    /*
     * Paging by search 
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

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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

    /*
     * Publishes a warranty policy by setting its status to LIVE.
     */
    public void publishPolicy(int id) throws Exception {
        updateStatus(id, "LIVE");
    }

    /*
     * Saves a warranty policy as a draft by setting its status to DRAFT.
     */
    public void saveDraft(int id) throws Exception {
        updateStatus(id, "DRAFT");
    }

    /*
     * Disables a warranty policy by setting its status to DISABLED.
     */
    public void disablePolicy(int id) throws Exception {
        updateStatus(id, "DISABLED");
    }

    /*
     * Maps a ResultSet row to a WarrantyPolicy model object.
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
     * Phuong thuc insertHistory
     */
    public void insertHistory(int policyId, String policyName, String version, String description, String content, String status, String actionType) throws Exception {
        String sql = "INSERT INTO WarrantyPolicyHistory (PolicyID, PolicyName, Version, Description, PolicyContent, Status, ActionType, ChangedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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
     * Phuong thuc getHistoryByPolicyId
     */
    public List<model.PolicyHistory> getHistoryByPolicyId(int policyId) throws Exception {
        List<model.PolicyHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicyHistory WHERE PolicyID = ? ORDER BY ChangedAt DESC";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
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
}

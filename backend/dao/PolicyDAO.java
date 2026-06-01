package dao;

import model.WarrantyPolicy;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PolicyDAO handles CRUD operations for the WarrantyPolicies table.
 *
 * Version 1.4
 *
 * Author DuyLD
 */
public class PolicyDAO extends DBContext {

    /**
     * Retrieves all warranty policies ordered by most recently created.
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
     * Retrieves a single warranty policy by its unique identifier.
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
     * Creates a new warranty policy record in the database.
     */
    public void insertPolicy(WarrantyPolicy p) throws Exception {

        String sql = """
            INSERT INTO WarrantyPolicies
            (PolicyName, Description, PolicyContent, ApplicableRegions,
             WarrantyMonths, Status, Version, EffectiveDate, CreatedAt, UpdatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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
        }
    }

    /**
     * Searches for policies whose name or description matches the given
     * keyword.
     */
    public List<WarrantyPolicy> searchPolicies(String keyword) throws Exception {

        List<WarrantyPolicy> list = new ArrayList<>();

        String sql = """
        SELECT * FROM WarrantyPolicies
        WHERE PolicyName LIKE ? OR Description LIKE ?
        ORDER BY PolicyID DESC
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            String k = "%" + keyword + "%";
            ps.setString(1, k);
            ps.setString(2, k);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPolicy(rs));
                }
            }
        }

        return list;
    }

    /**
     * Retrieves all warranty policies matching the given status value.
     */
    public List<WarrantyPolicy> getPoliciesByStatus(String status) throws Exception {

        List<WarrantyPolicy> list = new ArrayList<>();

        String sql = """
        SELECT * FROM WarrantyPolicies
        WHERE Status = ?
        ORDER BY PolicyID DESC
    """;

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
     * Updates an existing warranty policy record with the provided values.
     */
    public void updatePolicy(WarrantyPolicy p) throws Exception {

        String sql = """
            UPDATE WarrantyPolicies
            SET PolicyName = ?,
                Description = ?,
                PolicyContent = ?,
                ApplicableRegions = ?,
                WarrantyMonths = ?,
                Status = ?,
                Version = ?,
                EffectiveDate = ?,
                UpdatedAt = ?
            WHERE PolicyID = ?
        """;

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
     * Deletes a warranty policy record by its unique identifier.
     */
    public void deletePolicy(int id) throws Exception {

        String sql = "DELETE FROM WarrantyPolicies WHERE PolicyID = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /**
     * Updates the status of a warranty policy to the specified value.
     */
    private void updateStatus(int id, String status) throws Exception {

        String sql = """
        UPDATE WarrantyPolicies
        SET Status = ?, UpdatedAt = ?
        WHERE PolicyID = ?
    """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt(3, id);

            ps.executeUpdate();
        }
    }

    /**
     * Publishes a warranty policy by setting its status to LIVE.
     */
    public void publishPolicy(int id) throws Exception {
        updateStatus(id, "LIVE");
    }

    /**
     * Saves a warranty policy as a draft by setting its status to DRAFT.
     */
    public void saveDraft(int id) throws Exception {
        updateStatus(id, "DRAFT");
    }

    /**
     * Disables a warranty policy by setting its status to DISABLED.
     */
    public void disablePolicy(int id) throws Exception {
        updateStatus(id, "DISABLED");
    }

    /**
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
}

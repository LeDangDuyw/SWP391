package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.Region;
import model.WarrantyPolicy;

/**
 * PolicyDAO
 *
 * Purpose: Defines the PolicyDAO component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to PolicyDAO.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class PolicyDAO extends DBContext {

    // ══════════════════════════════════════════════════════════════
    // REGION OPERATIONS
    // ══════════════════════════════════════════════════════════════

    /**
     * Executes getAllActiveRegions.
     */
    public List<Region> getAllActiveRegions() throws Exception {
        List<Region> list = new ArrayList<>();
        String sql = """
            SELECT RegionID, RegionCode, RegionName, IsActive
            FROM   Regions
            WHERE  IsActive = 1
            ORDER  BY RegionName
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRegion(rs));
            }
        }
        return list;
    }

    /**
     * Executes getRegionsForPolicy.
     */
    public List<Region> getRegionsForPolicy(int policyId) throws Exception {
        List<Region> list = new ArrayList<>();
        String sql = """
            SELECT r.RegionID, r.RegionCode, r.RegionName, r.IsActive
            FROM   Regions r
            JOIN   PolicyRegions pr ON pr.RegionID = r.RegionID
            WHERE  pr.PolicyID = ?
            ORDER  BY r.RegionName
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRegion(rs));
                }
            }
        }
        return list;
    }

    // ══════════════════════════════════════════════════════════════
    // POLICY READ OPERATIONS
    // ══════════════════════════════════════════════════════════════

    /**
     * Executes getAllPolicies.
     */
    public List<WarrantyPolicy> getAllPolicies() throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = """
            SELECT PolicyID, PolicyName, Description, PolicyContent,
                   WarrantyMonths, Status, Version, EffectiveDate,
                   CreatedAt, UpdatedAt
            FROM   WarrantyPolicies
            ORDER  BY PolicyID DESC
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                WarrantyPolicy p = mapPolicy(rs);
                p.setApplicableRegions(getRegionsForPolicy(p.getPolicyId()));
                list.add(p);
            }
        }
        return list;
    }

    /**
     * Executes getPolicyById.
     */
    public WarrantyPolicy getPolicyById(int id) throws Exception {
        String sql = """
            SELECT PolicyID, PolicyName, Description, PolicyContent,
                   WarrantyMonths, Status, Version, EffectiveDate,
                   CreatedAt, UpdatedAt
            FROM   WarrantyPolicies
            WHERE  PolicyID = ?
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WarrantyPolicy p = mapPolicy(rs);
                    p.setApplicableRegions(getRegionsForPolicy(id));
                    return p;
                }
            }
        }
        return null;
    }

    // ──────────────────────────────────────────────────────────────
    // Duplicate-name validation
    // ──────────────────────────────────────────────────────────────

    /**
     * Executes isPolicyNameTakenForCreate.
     */
    public boolean isPolicyNameTakenForCreate(String name) throws Exception {
        String sql = """
            SELECT 1 FROM WarrantyPolicies
            WHERE  PolicyName = ?
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Executes isPolicyNameTakenByOther.
     */
    public boolean isPolicyNameTakenByOther(String name, int ownerId) throws Exception {
        String sql = """
            SELECT 1 FROM WarrantyPolicies
            WHERE  PolicyName = ?
              AND  PolicyID  <> ?
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ──────────────────────────────────────────────────────────────
    // Search / Filter
    // ──────────────────────────────────────────────────────────────

    /**
     * Executes searchPolicies.
     */
    public List<WarrantyPolicy> searchPolicies(String keyword, String status) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus  = status  != null && !status.trim().isEmpty();

        StringBuilder sql = new StringBuilder("""
            SELECT PolicyID, PolicyName, Description, PolicyContent,
                   WarrantyMonths, Status, Version, EffectiveDate,
                   CreatedAt, UpdatedAt
            FROM   WarrantyPolicies
            WHERE  1=1
            """);
        if (hasKeyword) sql.append(" AND PolicyName LIKE ?");
        if (hasStatus)  sql.append(" AND Status     = ?");
        sql.append(" ORDER BY PolicyID DESC");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword) ps.setString(idx++, "%" + keyword.trim() + "%");
            if (hasStatus)  ps.setString(idx,   status.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WarrantyPolicy p = mapPolicy(rs);
                    p.setApplicableRegions(getRegionsForPolicy(p.getPolicyId()));
                    list.add(p);
                }
            }
        }
        return list;
    }

    // ──────────────────────────────────────────────────────────────
    // Pagination
    // ──────────────────────────────────────────────────────────────

    public List<WarrantyPolicy> getPoliciesPaged(int page, int pageSize) throws Exception {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = """
            SELECT PolicyID, PolicyName, Description, PolicyContent,
                   WarrantyMonths, Status, Version, EffectiveDate,
                   CreatedAt, UpdatedAt
            FROM   WarrantyPolicies
            ORDER  BY PolicyID DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;
        int offset = (page - 1) * pageSize;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WarrantyPolicy p = mapPolicy(rs);
                    p.setApplicableRegions(getRegionsForPolicy(p.getPolicyId()));
                    list.add(p);
                }
            }
        }
        return list;
    }

    public int countPolicies() throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyPolicies";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ══════════════════════════════════════════════════════════════
    // POLICY WRITE OPERATIONS
    // ══════════════════════════════════════════════════════════════

    /**
     * Executes insertPolicy.
     */
    public void insertPolicy(WarrantyPolicy p, List<Integer> regionIds) throws Exception {
        String sql = """
            INSERT INTO WarrantyPolicies
                (PolicyName, Description, PolicyContent, WarrantyMonths,
                 Status, Version, EffectiveDate, CreatedAt, UpdatedAt)
            OUTPUT INSERTED.PolicyID
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                int newId;
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, p.getPolicyName().trim());
                    ps.setString(2, p.getDescription());
                    ps.setString(3, p.getPolicyContent());
                    ps.setInt   (4, p.getWarrantyMonths());
                    ps.setString(5, p.getStatus());
                    ps.setString(6, p.getVersion());
                    ps.setDate  (7, p.getEffectiveDate());
                    ps.setTimestamp(8, p.getCreatedAt());
                    ps.setTimestamp(9, p.getUpdatedAt());
                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        newId = rs.getInt(1);
                    }
                }
                linkRegions(con, newId, regionIds);
                con.commit();
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    /**
     * Executes updatePolicy.
     */
    public void updatePolicy(WarrantyPolicy p, List<Integer> regionIds) throws Exception {
        String sql = """
            UPDATE WarrantyPolicies
            SET    PolicyName    = ?,
                   Description   = ?,
                   PolicyContent = ?,
                   WarrantyMonths = ?,
                   Status        = ?,
                   Version       = ?,
                   EffectiveDate = ?,
                   UpdatedAt     = ?
            WHERE  PolicyID = ?
            """;
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, p.getPolicyName().trim());
                    ps.setString(2, p.getDescription());
                    ps.setString(3, p.getPolicyContent());
                    ps.setInt   (4, p.getWarrantyMonths());
                    ps.setString(5, p.getStatus());
                    ps.setString(6, p.getVersion());
                    ps.setDate  (7, p.getEffectiveDate());
                    ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
                    ps.setInt   (9, p.getPolicyId());
                    ps.executeUpdate();
                }
                // Full replace: delete existing links then re-insert
                deleteRegionLinks(con, p.getPolicyId());
                linkRegions(con, p.getPolicyId(), regionIds);
                con.commit();
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    /**
     * Executes deletePolicy.
     */
    public void deletePolicy(int policyId) throws Exception {
        String sql = "DELETE FROM WarrantyPolicies WHERE PolicyID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            ps.executeUpdate();
        }
    }

    // ──────────────────────────────────────────────────────────────
    // Status shortcuts
    // ──────────────────────────────────────────────────────────────

    public void publishPolicy(int policyId)  throws Exception { updateStatus(policyId, "LIVE"); }
    public void saveDraft(int policyId)      throws Exception { updateStatus(policyId, "DRAFT"); }
    public void disablePolicy(int policyId)  throws Exception { updateStatus(policyId, "DISABLED"); }

    private void updateStatus(int policyId, String newStatus) throws Exception {
        String sql = """
            UPDATE WarrantyPolicies
            SET    Status    = ?,
                   UpdatedAt = ?
            WHERE  PolicyID  = ?
            """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt   (3, policyId);
            ps.executeUpdate();
        }
    }

    // ══════════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ══════════════════════════════════════════════════════════════

    /**
     * Executes linkRegions.
     */
    private void linkRegions(Connection con, int policyId,
                             List<Integer> regionIds) throws Exception {
        if (regionIds == null || regionIds.isEmpty()) return;
        String sql = "INSERT INTO PolicyRegions (PolicyID, RegionID) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int rid : regionIds) {
                ps.setInt(1, policyId);
                ps.setInt(2, rid);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /**
     * Executes deleteRegionLinks.
     */
    private void deleteRegionLinks(Connection con, int policyId) throws Exception {
        String sql = "DELETE FROM PolicyRegions WHERE PolicyID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            ps.executeUpdate();
        }
    }

    /**
     * Executes mapPolicy.
     */
    private WarrantyPolicy mapPolicy(ResultSet rs) throws Exception {
        WarrantyPolicy p = new WarrantyPolicy();
        p.setPolicyId      (rs.getInt      ("PolicyID"));
        p.setPolicyName    (rs.getString   ("PolicyName"));
        p.setDescription   (rs.getString   ("Description"));
        p.setPolicyContent (rs.getString   ("PolicyContent"));
        p.setWarrantyMonths(rs.getInt      ("WarrantyMonths"));
        p.setStatus        (rs.getString   ("Status"));
        p.setVersion       (rs.getString   ("Version"));
        p.setEffectiveDate (rs.getDate     ("EffectiveDate"));
        p.setCreatedAt     (rs.getTimestamp("CreatedAt"));
        p.setUpdatedAt     (rs.getTimestamp("UpdatedAt"));
        return p;
    }

    /**
     * Executes mapRegion.
     */
    private Region mapRegion(ResultSet rs) throws Exception {
        return new Region(
            rs.getInt    ("RegionID"),
            rs.getString ("RegionCode"),
            rs.getString ("RegionName"),
            rs.getBoolean("IsActive")
        );
    }
}
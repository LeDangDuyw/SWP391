package dal;

import model.WarrantyHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * WarrantyHistoryDAO manages records in the existing WarrantyHistory table.
 *
 * Schema (do NOT modify):
 *   history_id, warranty_id, issue_description,
 *   repair_status, repair_date, repair_note, created_at
 *
 * Version 1.0
 * Author DuyLD
 */
public class WarrantyHistoryDAO extends DBContext {

    // ── INSERT ────────────────────────────────────────────────────────────────

    /**
     * Inserts a new WarrantyHistory record for a status change event.
     *
     * Called every time a WarrantyClaim changes status.
     *
     * @param history the history record to persist
     * @throws Exception on SQL error
     */
    public void insert(WarrantyHistory history) throws Exception {
        // repair_date và created_at đều dùng GETDATE() từ DB để tránh drift
        // giữa JVM clock và DB clock.
        String sql = "INSERT INTO WarrantyHistory "
                + "(warranty_id, issue_description, repair_status, repair_date, repair_note, created_at) "
                + "VALUES (?, ?, ?, GETDATE(), ?, GETDATE())";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, history.getWarrantyId());
            ps.setString(2, history.getIssueDescription());
            ps.setString(3, history.getRepairStatus());
            ps.setString(4, history.getRepairNote());
            ps.executeUpdate();
        }
    }

    // ── FIND BY WARRANTY ID ───────────────────────────────────────────────────

    /**
     * Retrieves all history records for a warranty claim, newest first.
     *
     * Used to render the timeline on detail.jsp.
     *
     * @param warrantyId the claim's ID
     * @return list of WarrantyHistory ordered by created_at DESC
     * @throws Exception on SQL error
     */
    public List<WarrantyHistory> findByWarrantyId(int warrantyId) throws Exception {
        String sql = "SELECT * FROM WarrantyHistory "
                + "WHERE warranty_id = ? "
                + "ORDER BY created_at DESC";

        List<WarrantyHistory> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, warrantyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapHistory(rs));
                }
            }
        }
        return list;
    }

    // ── DELETE BY WARRANTY ID ─────────────────────────────────────────────────

    /**
     * Deletes all history records for a given warranty claim.
     *
     * Useful for hard-deletion scenarios or data cleanup.
     *
     * @param warrantyId the claim's ID
     * @throws Exception on SQL error
     */
    public void deleteByWarrantyId(int warrantyId) throws Exception {
        String sql = "DELETE FROM WarrantyHistory WHERE warranty_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, warrantyId);
            ps.executeUpdate();
        }
    }

    // ── PRIVATE MAPPING ───────────────────────────────────────────────────────

    /**
     * Maps a ResultSet row to a WarrantyHistory object.
     */
    private WarrantyHistory mapHistory(ResultSet rs) throws SQLException {
        return new WarrantyHistory(
                rs.getInt("history_id"),
                rs.getInt("warranty_id"),
                rs.getString("issue_description"),
                rs.getString("repair_status"),
                rs.getTimestamp("repair_date"),
                rs.getString("repair_note"),
                rs.getTimestamp("created_at")
        );
    }
}

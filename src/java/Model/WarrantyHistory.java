package model;

import java.sql.Timestamp;

/**
 * WarrantyHistory records each status change made to a WarrantyClaim.
 *
 * Maps to the WarrantyHistory table (existing schema – do NOT modify).
 *
 * Columns: history_id, warranty_id, issue_description, repair_status,
 *          repair_date, repair_note, created_at
 *
 * Version 1.0
 * Author DuyLD
 */
public class WarrantyHistory {

    private int historyId;
    private int warrantyId;
    private String issueDescription;
    private String repairStatus;
    private Timestamp repairDate;
    private String repairNote;
    private Timestamp createdAt;

    /**
     * Default constructor.
     */
    public WarrantyHistory() {
    }

    /**
     * Full constructor for building a WarrantyHistory from a ResultSet row.
     */
    public WarrantyHistory(int historyId, int warrantyId,
            String issueDescription, String repairStatus,
            Timestamp repairDate, String repairNote,
            Timestamp createdAt) {
        this.historyId        = historyId;
        this.warrantyId       = warrantyId;
        this.issueDescription = issueDescription;
        this.repairStatus     = repairStatus;
        this.repairDate       = repairDate;
        this.repairNote       = repairNote;
        this.createdAt        = createdAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getWarrantyId() { return warrantyId; }
    public void setWarrantyId(int warrantyId) { this.warrantyId = warrantyId; }

    public String getIssueDescription() { return issueDescription; }
    public void setIssueDescription(String issueDescription) { this.issueDescription = issueDescription; }

    public String getRepairStatus() { return repairStatus; }
    public void setRepairStatus(String repairStatus) { this.repairStatus = repairStatus; }

    public Timestamp getRepairDate() { return repairDate; }
    public void setRepairDate(Timestamp repairDate) { this.repairDate = repairDate; }

    public String getRepairNote() { return repairNote; }
    public void setRepairNote(String repairNote) { this.repairNote = repairNote; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

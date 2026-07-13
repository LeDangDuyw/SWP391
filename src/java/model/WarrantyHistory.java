package model;

/**
 * Class: WarrantyHistory
 * Description: Model lịch sử xử lý và thay đổi trạng thái bảo hành.
 * 
 * Created: 2026-06-22 21:12:34 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: WarrantyHistory
 * Description: Model lịch sử xử lý và thay đổi trạng thái bảo hành.
 * 
 * Created: 2026-06-22 21:12:34 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import java.sql.Timestamp;


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
    /**
     * Phuong thuc setHistoryId
     */
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    /**
     * Phuong thuc getWarrantyId
     */
    public int getWarrantyId() { return warrantyId; }
    /**
     * Phuong thuc setWarrantyId
     */
    public void setWarrantyId(int warrantyId) { this.warrantyId = warrantyId; }

    /**
     * Phuong thuc getIssueDescription
     */
    public String getIssueDescription() { return issueDescription; }
    /**
     * Phuong thuc setIssueDescription
     */
    public void setIssueDescription(String issueDescription) { this.issueDescription = issueDescription; }

    /**
     * Phuong thuc getRepairStatus
     */
    public String getRepairStatus() { return repairStatus; }
    /**
     * Phuong thuc setRepairStatus
     */
    public void setRepairStatus(String repairStatus) { this.repairStatus = repairStatus; }

    /**
     * Phuong thuc getRepairDate
     */
    public Timestamp getRepairDate() { return repairDate; }
    /**
     * Phuong thuc setRepairDate
     */
    public void setRepairDate(Timestamp repairDate) { this.repairDate = repairDate; }

    /**
     * Phuong thuc getRepairNote
     */
    public String getRepairNote() { return repairNote; }
    /**
     * Phuong thuc setRepairNote
     */
    public void setRepairNote(String repairNote) { this.repairNote = repairNote; }

    /**
     * Phuong thuc getCreatedAt
     */
    public Timestamp getCreatedAt() { return createdAt; }
    /**
     * Phuong thuc setCreatedAt
     */
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

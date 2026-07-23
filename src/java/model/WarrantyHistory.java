package model;

import java.sql.Timestamp;

/**
 * Class: WarrantyHistory
 * Description: Model lịch sử xử lý và thay đổi trạng thái bảo hành.
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
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
     * Khởi tạo mặc định.
     */
    public WarrantyHistory() {
    }

    /**
     * Khởi tạo đầy đủ các thuộc tính của nhật ký lịch sử bảo hành.
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


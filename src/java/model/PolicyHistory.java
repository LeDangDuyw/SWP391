package model;

import java.sql.Timestamp;

/**
 * PolicyHistory represents a historical version record of a WarrantyPolicy.
 *
 * Author DuyLD
 */
public class PolicyHistory {
    private int historyId;
    private int policyId;
    private String policyName;
    private String version;
    private String description;
    private String policyContent;
    private String status;
    private String actionType; // 'CREATED' or 'UPDATED'
    private Timestamp changedAt;

    public PolicyHistory() {
    }

    public PolicyHistory(int historyId, int policyId, String policyName, String version, 
                         String description, String policyContent, String status, 
                         String actionType, Timestamp changedAt) {
        this.historyId = historyId;
        this.policyId = policyId;
        this.policyName = policyName;
        this.version = version;
        this.description = description;
        this.policyContent = policyContent;
        this.status = status;
        this.actionType = actionType;
        this.changedAt = changedAt;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getPolicyId() {
        return policyId;
    }

    public void setPolicyId(int policyId) {
        this.policyId = policyId;
    }

    public String getPolicyName() {
        return policyName;
    }

    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPolicyContent() {
        return policyContent;
    }

    public void setPolicyContent(String policyContent) {
        this.policyContent = policyContent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
}

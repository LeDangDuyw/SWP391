package model;

import java.sql.Timestamp;

public class GeneralPolicy {
    private int policyId;
    private String title;
    private String policyType;
    private String content;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public GeneralPolicy() {
    }

    public GeneralPolicy(int policyId, String title, String policyType, String content, boolean status, Timestamp createdAt, Timestamp updatedAt) {
        this.policyId = policyId;
        this.title = title;
        this.policyType = policyType;
        this.content = content;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getPolicyId() {
        return policyId;
    }

    public void setPolicyId(int policyId) {
        this.policyId = policyId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}

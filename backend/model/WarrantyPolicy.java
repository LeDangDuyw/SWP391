
package model;

import java.sql.Timestamp;
import java.sql.Date;

/**
 * WarrantyPolicy represents warranty policy information stored in the system.
 *
 * Version 1.4
 *
 * Author DuyLD
 */
public class WarrantyPolicy {

    private int policyId;
    private String policyName;
    private String description;
    private int warrantyMonths;
    private String status;
    private String version;
    private Date effectiveDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String policyContent;
    private String applicableRegions;

    public WarrantyPolicy() {
    }

    public WarrantyPolicy(int policyId, String policyName, String description, int warrantyMonths, String status, String version, Date effectiveDate, Timestamp createdAt, Timestamp updatedAt, String policyContent, String applicableRegions) {
        this.policyId = policyId;
        this.policyName = policyName;
        this.description = description;
        this.warrantyMonths = warrantyMonths;
        this.status = status;
        this.version = version;
        this.effectiveDate = effectiveDate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.policyContent = policyContent;
        this.applicableRegions = applicableRegions;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
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

    public String getPolicyContent() {
        return policyContent;
    }

    public void setPolicyContent(String policyContent) {
        this.policyContent = policyContent;
    }

    public String getApplicableRegions() {
        return applicableRegions;
    }

    public void setApplicableRegions(String applicableRegions) {
        this.applicableRegions = applicableRegions;
    }
    
    
}

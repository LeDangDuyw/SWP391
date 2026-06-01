package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * WarrantyPolicy
 *
 * Purpose: Defines the WarrantyPolicy component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to WarrantyPolicy.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class WarrantyPolicy {

    // ── Core fields (match WarrantyPolicies columns) ──────────────
    private int policyId;
    private String policyName;
    private String description;
    private String policyContent;      // NEW – HTML from CKEditor/TinyMCE
    private int warrantyMonths;
    private String status;
    private String version;
    private Date effectiveDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ── Related data (loaded via JOIN / PolicyRegions) ─────────────
    private List<Region> applicableRegions = new ArrayList<>();

    // ── Constructors ───────────────────────────────────────────────
    public WarrantyPolicy() {
    }

    /**
     * Executes WarrantyPolicy.
     */
    public WarrantyPolicy(int policyId, String policyName, String description,
            String policyContent, int warrantyMonths, String status,
            String version, Date effectiveDate,
            Timestamp createdAt, Timestamp updatedAt) {
        this.policyId = policyId;
        this.policyName = policyName;
        this.description = description;
        this.policyContent = policyContent;
        this.warrantyMonths = warrantyMonths;
        this.status = status;
        this.version = version;
        this.effectiveDate = effectiveDate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ── Getters & Setters ──────────────────────────────────────────
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

    public String getPolicyContent() {
        return policyContent;
    }

    public void setPolicyContent(String pc) {
        this.policyContent = pc;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int wm) {
        this.warrantyMonths = wm;
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

    public void setEffectiveDate(Date d) {
        this.effectiveDate = d;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp t) {
        this.createdAt = t;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp t) {
        this.updatedAt = t;
    }

    public List<Region> getApplicableRegions() {
        return applicableRegions;
    }

    public void setApplicableRegions(List<Region> r) {
        this.applicableRegions = r;
    }

    /**
     * Executes getRegionCodesJoined.
     */
    public String getRegionCodesJoined() {
        StringBuilder sb = new StringBuilder();
        for (Region r : applicableRegions) {
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(r.getRegionCode());
        }
        return sb.toString();
    }
}
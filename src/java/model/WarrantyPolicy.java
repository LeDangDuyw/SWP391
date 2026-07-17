package model;
/**
 * Class: WarrantyPolicy
 * Description: Model lưu trữ thông tin về một chính sách bảo hành (Warranty Policy).
 * 
 * Created: 2026-05-29 19:55:59 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: WarrantyPolicy
 * Description: Model lưu trữ thông tin về một chính sách bảo hành (Warranty Policy).
 * 
 * Created: 2026-05-29 19:55:59 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import java.sql.Date;
import java.sql.Timestamp;


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
    private Date expiryDate;

    /**
     * Khởi tạo đối tượng WarrantyPolicy với các giá trị mặc định.
     */
    public WarrantyPolicy() {
    }

    /**
     * Khởi tạo đối tượng WarrantyPolicy với đầy đủ các thuộc tính.
     */
    public WarrantyPolicy(int policyId, String policyName, String description,
            int warrantyMonths, String status, String version,
            Date effectiveDate, Timestamp createdAt, Timestamp updatedAt,
            String policyContent, String applicableRegions, Date expiryDate) {
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
        this.expiryDate = expiryDate;
    }

    /**
     * Phuong thuc getPolicyId
     */
    public int getPolicyId() {
        return policyId;
    }

    /**
     * Phuong thuc setPolicyId
     */
    public void setPolicyId(int policyId) {
        this.policyId = policyId;
    }

    /**
     * Phuong thuc getPolicyName
     */
    public String getPolicyName() {
        return policyName;
    }

    /**
     * Phuong thuc setPolicyName
     */
    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    /**
     * Phuong thuc getDescription
     */
    public String getDescription() {
        return description;
    }

    /**
     * Phuong thuc setDescription
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Phuong thuc getWarrantyMonths
     */
    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    /**
     * Phuong thuc setWarrantyMonths
     */
    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    /**
     * Phuong thuc getStatus
     */
    public String getStatus() {
        return status;
    }

    /**
     * Phuong thuc setStatus
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * Phuong thuc getVersion
     */
    public String getVersion() {
        return version;
    }

    /**
     * Phuong thuc setVersion
     */
    public void setVersion(String version) {
        this.version = version;
    }

    /**
     * Phuong thuc getEffectiveDate
     */
    public Date getEffectiveDate() {
        return effectiveDate;
    }

    /**
     * Phuong thuc setEffectiveDate
     */
    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    /**
     * Phuong thuc getCreatedAt
     */
    public Timestamp getCreatedAt() {
        return createdAt;
    }

    /**
     * Phuong thuc setCreatedAt
     */
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Phuong thuc getUpdatedAt
     */
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    /**
     * Phuong thuc setUpdatedAt
     */
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Phuong thuc getPolicyContent
     */
    public String getPolicyContent() {
        return policyContent;
    }

    /**
     * Phuong thuc setPolicyContent
     */
    public void setPolicyContent(String policyContent) {
        this.policyContent = policyContent;
    }

    /**
     * Phuong thuc getApplicableRegions
     */
    public String getApplicableRegions() {
        return applicableRegions;
    }

    /**
     * Phuong thuc setApplicableRegions
     */
    public void setApplicableRegions(String r) {
        this.applicableRegions = r;
    }

    /**
     * Phuong thuc getExpiryDate
     */
    public Date getExpiryDate() {
        return expiryDate;
    }

    /**
     * Phuong thuc setExpiryDate
     */
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
}

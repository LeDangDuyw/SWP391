/**
 * Class: WarrantyClaim
 * Description: Model thông tin chi tiết một phiếu yêu cầu bảo hành (Warranty Claim).
 * 
 * Created: 2026-06-22 21:12:34 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: WarrantyClaim
 * Description: Model thông tin chi tiết một phiếu yêu cầu bảo hành (Warranty Claim).
 * 
 * Created: 2026-06-22 21:12:34 +0700
 * Updated: 2026-06-22 21:12:34 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import java.sql.Timestamp;


public class WarrantyClaim {

    private int claimId;
    private int orderId;
    private int orderDetailId;
    private int customerId;
    private Integer staffId;         // nullable – assigned when staff picks up the claim
    private String serialNumber;
    private String title;
    private String description;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp completedAt;   // nullable – set when status reaches COMPLETED

    // ── transient / joined fields (not stored in WarrantyClaims) ────────────
    private String customerName;     // joined from Users
    private String productName;      // joined from Products via OrderDetails

    /**
     * Default constructor.
     */
    public WarrantyClaim() {
    }

    /**
     * Full constructor for building a WarrantyClaim from a ResultSet row.
     */
    public WarrantyClaim(int claimId, int orderId, int orderDetailId,
            int customerId, Integer staffId,
            String serialNumber, String title, String description,
            String status, Timestamp createdAt, Timestamp updatedAt,
            Timestamp completedAt) {
        this.claimId = claimId;
        this.orderId = orderId;
        this.orderDetailId = orderDetailId;
        this.customerId = customerId;
        this.staffId = staffId;
        this.serialNumber = serialNumber;
        this.title = title;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.completedAt = completedAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────
    public int getClaimId() {
        return claimId;
    }

    /**
     * Phuong thuc setClaimId
     */
    public void setClaimId(int claimId) {
        this.claimId = claimId;
    }

    /**
     * Phuong thuc getOrderId
     */
    public int getOrderId() {
        return orderId;
    }

    /**
     * Phuong thuc setOrderId
     */
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    /**
     * Phuong thuc getOrderDetailId
     */
    public int getOrderDetailId() {
        return orderDetailId;
    }

    /**
     * Phuong thuc setOrderDetailId
     */
    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    /**
     * Phuong thuc getCustomerId
     */
    public int getCustomerId() {
        return customerId;
    }

    /**
     * Phuong thuc setCustomerId
     */
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    /**
     * Phuong thuc getStaffId
     */
    public Integer getStaffId() {
        return staffId;
    }

    /**
     * Phuong thuc setStaffId
     */
    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    /**
     * Phuong thuc getSerialNumber
     */
    public String getSerialNumber() {
        return serialNumber;
    }

    /**
     * Phuong thuc setSerialNumber
     */
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    /**
     * Phuong thuc getTitle
     */
    public String getTitle() {
        return title;
    }

    /**
     * Phuong thuc setTitle
     */
    public void setTitle(String title) {
        this.title = title;
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
     * Phuong thuc getCompletedAt
     */
    public Timestamp getCompletedAt() {
        return completedAt;
    }

    /**
     * Phuong thuc setCompletedAt
     */
    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    /**
     * Phuong thuc getCustomerName
     */
    public String getCustomerName() {
        return customerName;
    }

    /**
     * Phuong thuc setCustomerName
     */
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    /**
     * Phuong thuc getProductName
     */
    public String getProductName() {
        return productName;
    }

    /**
     * Phuong thuc setProductName
     */
    public void setProductName(String productName) {
        this.productName = productName;
    }
}

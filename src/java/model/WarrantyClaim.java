package model;

import java.sql.Timestamp;

/**
 * Model biểu diễn thông tin chi tiết một phiếu yêu cầu bảo hành (Warranty Claim).
 *
 * @author DuyLD
 */
public class WarrantyClaim {

    private int claimId;
    private int orderId;
    private int orderDetailId;
    private int customerId;
    private Integer staffId;         // Nullable – nhân viên được gán xử lý phiếu
    private String serialNumber;
    private String title;
    private String description;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp completedAt;   // Nullable – thời điểm hoàn tất bảo hành

    // Các trường dữ liệu liên kết (Joined / Transient fields)
    private String customerName;     // Tên khách hàng (Join từ bảng Users)
    private String productName;      // Tên sản phẩm (Join từ bảng Products qua OrderDetails)

    /**
     * Khởi tạo mặc định.
     */
    public WarrantyClaim() {
    }

    /**
     * Khởi tạo đầy đủ thuộc tính cho phiếu bảo hành.
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

    public void setClaimId(int claimId) {
        this.claimId = claimId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
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

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
}


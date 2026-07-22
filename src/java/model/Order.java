/*
 * Name: Order
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Model đại diện cho đơn đặt hàng (Order)
 */
package model;

import java.math.BigDecimal;
import java.util.List;

public class Order {
    private int orderId;
    private BigDecimal totalAmount;
    private BigDecimal shippingFee;
    private String orderStatus;
    private String shippingReceiver;
    private String shippingPhone;
    private String shippingAddress;
    private String orderCode;
    private Integer userId;
    private Integer voucherId;
    private java.time.LocalDateTime completedAt;
    private List<OrderDetail> details;

    public Order() {
    }

    public Order(int orderId, BigDecimal totalAmount, BigDecimal shippingFee, String orderStatus,
                 String shippingReceiver, String shippingPhone, String shippingAddress, String orderCode,
                 Integer userId, Integer voucherId) {
        this.orderId = orderId;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.orderStatus = orderStatus;
        this.shippingReceiver = shippingReceiver;
        this.shippingPhone = shippingPhone;
        this.shippingAddress = shippingAddress;
        this.orderCode = orderCode;
        this.userId = userId;
        this.voucherId = voucherId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getShippingReceiver() {
        return shippingReceiver;
    }

    public void setShippingReceiver(String shippingReceiver) {
        this.shippingReceiver = shippingReceiver;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public java.time.LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(java.time.LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    private java.time.LocalDateTime createdAt;

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdAt.format(formatter);
    }

    private String shippingPartner;
    private String trackingNumber;
    private String shippingMethod;

    public String getShippingMethod() {
        if (shippingMethod == null || shippingMethod.trim().isEmpty()) {
            if (shippingAddress != null && shippingAddress.contains("Nhận tại cửa hàng")) {
                return "STORE_PICKUP";
            }
            return "HOME_DELIVERY";
        }
        return shippingMethod;
    }

    public void setShippingMethod(String shippingMethod) {
        this.shippingMethod = shippingMethod;
    }

    public List<OrderDetail> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail> details) {
        this.details = details;
    }

    public String getFormattedCompletedAt() {
        if (completedAt == null) return "N/A";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return completedAt.format(formatter);
    }

    private String invoicePath;
    private int invoiceEmailSent;

    public String getShippingPartner() {
        return shippingPartner;
    }

    public void setShippingPartner(String shippingPartner) {
        this.shippingPartner = shippingPartner;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getInvoicePath() {
        return invoicePath;
    }

    public void setInvoicePath(String invoicePath) {
        this.invoicePath = invoicePath;
    }

    public int getInvoiceEmailSent() {
        return invoiceEmailSent;
    }

    public void setInvoiceEmailSent(int invoiceEmailSent) {
        this.invoiceEmailSent = invoiceEmailSent;
    }
}

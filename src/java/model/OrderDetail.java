/*
 * Name: OrderDetail
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Model đại diện cho chi tiết đơn đặt hàng (Order Detail)
 */
package model;

import java.math.BigDecimal;
import java.util.List;

public class OrderDetail {
    private int orderDetailId;
    private int quantity;
    private BigDecimal unitPrice;
    private int orderId;
    private int variantId;

    // Helper fields for display
    private String productName;
    private String variantName;
    private String sku;
    private String thumbnail;
    
    // For outbound fulfillment tracking
    private List<InventoryItem> assignedItems;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailId, int quantity, BigDecimal unitPrice, int orderId, int variantId) {
        this.orderDetailId = orderDetailId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.orderId = orderId;
        this.variantId = variantId;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public List<InventoryItem> getAssignedItems() {
        return assignedItems;
    }

    public void setAssignedItems(List<InventoryItem> assignedItems) {
        this.assignedItems = assignedItems;
    }

    private int productId;
    private boolean reviewed;

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public boolean isReviewed() {
        return reviewed;
    }

    public void setReviewed(boolean reviewed) {
        this.reviewed = reviewed;
    }

    private int warrantyPeriod;

    public int getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(int warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public String getFormattedWarrantyExpiry(java.time.LocalDateTime startDate) {
        if (startDate == null) return "N/A";
        int period = this.warrantyPeriod > 0 ? this.warrantyPeriod : 12; // default to 12 if not set
        java.time.LocalDateTime expiry = startDate.plusMonths(period);
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return expiry.format(formatter);
    }
}

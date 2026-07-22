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
    private int productId;
    
    // For outbound fulfillment tracking
    private List<InventoryItem> assignedItems;
    
    // For review status display
    private boolean isReviewed;
    
    // For warranty period
    private int warrantyPeriod;

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

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public boolean isReviewed() {
        return isReviewed;
    }

    public void setReviewed(boolean isReviewed) {
        this.isReviewed = isReviewed;
    }

    public int getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(int warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }
}

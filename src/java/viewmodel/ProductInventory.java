/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package viewmodel;

import java.math.BigDecimal;

/**
 *
 * @author huy
 */
public class ProductInventory {
    private int productVariantId;
    private String productName;
    private String sku;
    private String variantName;
    private String brandName;
    private String categoryName;
    private BigDecimal sellingPrice;
    private int availableQuantity;
    private String status;
    private String thumbnail;

    public ProductInventory(int productVariantId, String productName, String sku, String variantName, String brandName, String categoryName, BigDecimal sellingPrice, int availableQuantity, String status, String thumbnail) {
        this.productVariantId = productVariantId;
        this.productName = productName;
        this.sku = sku;
        this.variantName = variantName;
        this.brandName = brandName;
        this.categoryName = categoryName;
        this.sellingPrice = sellingPrice;
        this.availableQuantity = availableQuantity;
        this.status = status;
        this.thumbnail = thumbnail;
    }

    public int getProductId() {
        return productVariantId;
    }

    public void setProductId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
    
}

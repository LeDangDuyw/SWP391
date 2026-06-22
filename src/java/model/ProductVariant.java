package model;

import java.math.BigDecimal;

/**
 *
 * @author huy
 */
public class ProductVariant {
    private int variantId;
    private int productId;
    private String sku;
    private String variantName;
    private BigDecimal importPrice;
    private BigDecimal sellingPrice;
    private boolean isSerialized;
    private String status;
    private boolean serialized;
    private String status;
    private int availableQuantity;

    public ProductVariant() {
    }

    public ProductVariant(int variantId, int productId, String sku, String variantName, BigDecimal importPrice, BigDecimal sellingPrice, boolean isSerialized, String status) {
    public ProductVariant(int variantId, int productId, String sku, String variantName,
            BigDecimal importPrice, BigDecimal sellingPrice, boolean serialized,
            String status, int availableQuantity) {
        this.variantId = variantId;
        this.productId = productId;
        this.sku = sku;
        this.variantName = variantName;
        this.importPrice = importPrice;
        this.sellingPrice = sellingPrice;
        this.isSerialized = isSerialized;
        this.status = status;
        this.serialized = serialized;
        this.status = status;
        this.availableQuantity = availableQuantity;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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

    public BigDecimal getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public boolean isIsSerialized() {
        return isSerialized;
    }

    public void setIsSerialized(boolean isSerialized) {
        this.isSerialized = isSerialized;
    public boolean isSerialized() {
        return serialized;
    }

    public void setSerialized(boolean serialized) {
        this.serialized = serialized;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }
}

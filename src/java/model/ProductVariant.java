package model;

import java.math.BigDecimal;

public class ProductVariant {
    private int variantId;
    private int productId;
    private String sku;
    private String variantName;
    private BigDecimal importPrice;
    private BigDecimal sellingPrice;
    private boolean isSerialized;
    private boolean serialized;
    private String status;
    private int availableQuantity;

    private String cpu;
    private String ram;
    private String ssd;
    private String gpu;
    private String screen;
    private String connectivity;
    private String switchType;
    private String dpi;

    public ProductVariant() {
    }

    public ProductVariant(int variantId, int productId, String sku, String variantName, BigDecimal importPrice, BigDecimal sellingPrice, boolean isSerialized, String status) {
        this.variantId = variantId;
        this.productId = productId;
        this.sku = sku;
        this.variantName = variantName;
        this.importPrice = importPrice;
        this.sellingPrice = sellingPrice;
        this.isSerialized = isSerialized;
        this.serialized = isSerialized;
        this.status = status;
    }

    public ProductVariant(int variantId, int productId, String sku, String variantName, BigDecimal importPrice, BigDecimal sellingPrice, boolean isSerialized, String status, int availableQuantity) {
        this.variantId = variantId;
        this.productId = productId;
        this.sku = sku;
        this.variantName = variantName;
        this.importPrice = importPrice;
        this.sellingPrice = sellingPrice;
        this.isSerialized = isSerialized;
        this.serialized = isSerialized;
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
        this.serialized = isSerialized;
    }

    public boolean isSerialized() {
        return serialized;
    }

    public void setSerialized(boolean serialized) {
        this.serialized = serialized;
        this.isSerialized = serialized;
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

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public String getRam() {
        return ram;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public String getSsd() {
        return ssd;
    }

    public void setSsd(String ssd) {
        this.ssd = ssd;
    }

    public String getGpu() {
        return gpu;
    }

    public void setGpu(String gpu) {
        this.gpu = gpu;
    }

    public String getScreen() {
        return screen;
    }

    public void setScreen(String screen) {
        this.screen = screen;
    }

    public String getConnectivity() {
        return connectivity;
    }

    public void setConnectivity(String connectivity) {
        this.connectivity = connectivity;
    }

    public String getSwitchType() {
        return switchType;
    }

    public void setSwitchType(String switchType) {
        this.switchType = switchType;
    }

    public String getDpi() {
        return dpi;
    }

    public void setDpi(String dpi) {
        this.dpi = dpi;
    }
}

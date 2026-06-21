package model;

public class ProductCompareDTO {
    private int productId;
    private String productName;
    private String thumbnail;
    private String brandName;
    private String categoryName;
    private int categoryId;
    private long originalPrice;
    private int discountPercent;
    private long minPrice;
    private int warrantyPeriod;
    private String description;
    private int totalStock;
 

    // Laptop specific
    private String cpu;
    private String ram;
    private String ssd;
    private String gpu;
    private String screen;

    // Mouse & Keyboard specific
    private String connectivity;
    private String switchType;
    private String dpi;

   
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public long getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(long originalPrice) { this.originalPrice = originalPrice; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public long getMinPrice() { return minPrice; }
    public void setMinPrice(long minPrice) { this.minPrice = minPrice; }

    public int getWarrantyPeriod() { return warrantyPeriod; }
    public void setWarrantyPeriod(int warrantyPeriod) { this.warrantyPeriod = warrantyPeriod; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getTotalStock() { return totalStock; }
    public void setTotalStock(int totalStock) { this.totalStock = totalStock; }

    public String getCpu() { return cpu; }
    public void setCpu(String cpu) { this.cpu = cpu; }

    public String getRam() { return ram; }
    public void setRam(String ram) { this.ram = ram; }

    public String getSsd() { return ssd; }
    public void setSsd(String ssd) { this.ssd = ssd; }

    public String getGpu() { return gpu; }
    public void setGpu(String gpu) { this.gpu = gpu; }

    public String getScreen() { return screen; }
    public void setScreen(String screen) { this.screen = screen; }

    public String getConnectivity() { return connectivity; }
    public void setConnectivity(String connectivity) { this.connectivity = connectivity; }

    public String getSwitchType() { return switchType; }
    public void setSwitchType(String switchType) { this.switchType = switchType; }

    public String getDpi() { return dpi; }
    public void setDpi(String dpi) { this.dpi = dpi; }
}

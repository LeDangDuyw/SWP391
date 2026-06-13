package model;

public class Product {
    private int productId;
    private String productName;
    private String thumbnail;
    private int brandId;
    private String brandName;
    private String categoryName;
    private long minPrice;
    private String purpose;
    private String description;
    private int warrantyPeriod;
    private int categoryId;
    
    private long originalPrice;
    private int discountPercent;

    public Product() {}

    public Product(int productId, String productName, String description, int warrantyPeriod, String thumbnail, int categoryId, int brandId) {
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.warrantyPeriod = warrantyPeriod;
        this.thumbnail = thumbnail;
        this.categoryId = categoryId;
        this.brandId = brandId;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public long getMinPrice() { return minPrice; }
    public void setMinPrice(long minPrice) { this.minPrice = minPrice; }

    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getWarrantyPeriod() { return warrantyPeriod; }
    public void setWarrantyPeriod(int warrantyPeriod) { this.warrantyPeriod = warrantyPeriod; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public long getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(long originalPrice) {
        this.originalPrice = originalPrice;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }
    

    // Default getters for subclass properties to avoid PropertyNotFoundException in JSP EL
    public String getCpu() { return null; }
    public String getRam() { return null; }
    public String getSsd() { return null; }
    public String getGpu() { return null; }
    public String getScreen() { return null; }
    public String getConnectivity() { return null; }
    public String getSwitchType() { return null; }
    public String getDpi() { return null; }

    // lớp con laptop 
    public static class Laptop extends Product {
        private int seriesId;
        private String seriesName;
        private String cpu;
        private String ram;
        private String ssd;
        private String gpu;
        private String screen;

        public Laptop() {}

        public int getSeriesId() { return seriesId; }
        public void setSeriesId(int seriesId) { this.seriesId = seriesId; }

        public String getSeriesName() { return seriesName; }
        public void setSeriesName(String seriesName) { this.seriesName = seriesName; }

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
    }

    // lớp con chuột 
    public static class Mouse extends Product {
        private String connectivity;
        private String dpi;

        public Mouse() {}

        public String getConnectivity() { return connectivity; }
        public void setConnectivity(String connectivity) { this.connectivity = connectivity; }

        public String getDpi() { return dpi; }
        public void setDpi(String dpi) { this.dpi = dpi; }
    }

   // lớp con bàn phím 
    public static class Keyboard extends Product {
        private String connectivity;
        private String switchType;

        public Keyboard() {}

        public String getConnectivity() { return connectivity; }
        public void setConnectivity(String connectivity) { this.connectivity = connectivity; }

        public String getSwitchType() { return switchType; }
        public void setSwitchType(String switchType) { this.switchType = switchType; }
    }
}

    
    


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Cao Tuấn Minh
 */
public class Product {
     private int productId;
    private String productName;
    private String thumbnail;
    private String brandName;
    private String categoryName;
    private long minPrice;
    private int seriesId;
    private String seriesName;
    private int brandId;
    public Product() {
    }

    public Product(int productId, String productName, String thumbnail, String brandName, String categoryName, long minPrice, int seriesId, String seriesName, int brandId) {
        this.productId = productId;
        this.productName = productName;
        this.thumbnail = thumbnail;
        this.brandName = brandName;
        this.categoryName = categoryName;
        this.minPrice = minPrice;
        this.seriesId = seriesId;
        this.seriesName = seriesName;
        this.brandId = brandId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
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

    public long getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(long minPrice) {
        this.minPrice = minPrice;
    }

    public int getSeriesId() {
        return seriesId;
    }

    public void setSeriesId(int seriesId) {
        this.seriesId = seriesId;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String seriesName) {
        this.seriesName = seriesName;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }
    
    //Thêm các thuộc tính cpu, ram, gpu để hiển thị trên UI
    private String cpu;
    private String ram;
    private String gpu;
    
    //Thêm các thuộc tính cho chuột và bàn phím
    private String connectivity;
    private String switchType;
    private String dpi;

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

    public String getGpu() {
        return gpu;
    }

    public void setGpu(String gpu) {
        this.gpu = gpu;
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

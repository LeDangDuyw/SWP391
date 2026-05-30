/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */
public class FlashSaleProduct {
   private int productId;
private String productName;
private String thumbnail;
private double originalPrice;
private double salePrice;
private int quantityLimit;
private int soldQuantity;
private int discountPercent;

    public FlashSaleProduct() {
    }

    public FlashSaleProduct(int productId, String productName, String thumbnail, double originalPrice, double salePrice, int quantityLimit, int soldQuantity, int discountPercent) {
        this.productId = productId;
        this.productName = productName;
        this.thumbnail = thumbnail;
        this.originalPrice = originalPrice;
        this.salePrice = salePrice;
        this.quantityLimit = quantityLimit;
        this.soldQuantity = soldQuantity;
        this.discountPercent = discountPercent;
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

    public double getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public int getQuantityLimit() {
        return quantityLimit;
    }

    public void setQuantityLimit(int quantityLimit) {
        this.quantityLimit = quantityLimit;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }


}

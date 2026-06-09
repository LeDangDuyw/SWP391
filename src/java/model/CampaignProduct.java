package model;
//minhbq//26/4
import java.math.BigDecimal;

/**
 * Class CampaignProduct đại diện cho một sản phẩm (biến thể biến thể variant) được áp dụng trong chiến dịch khuyến mãi.
 * Chứa các thông tin thống kê bán hàng như số lượng bán, doanh thu, tồn kho và đơn giá khuyến mãi.
 * Tác nhân liên quan: Admin xem thống kê/cấu hình, Khách hàng xem sản phẩm khuyến mãi.
 */
public class CampaignProduct {
    private int variantId;
    private String productName;
    private String sku;
    private String categoryName;
    private BigDecimal originalPrice;
    private BigDecimal salePrice;
    private int unitsSold;
    private BigDecimal revenue;
    private int stock;
    private String status;

    public int getVariantId() { return variantId; }
    public void setVariantId(int variantId) { this.variantId = variantId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public BigDecimal getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(BigDecimal originalPrice) { this.originalPrice = originalPrice; }
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    public int getUnitsSold() { return unitsSold; }
    public void setUnitsSold(int unitsSold) { this.unitsSold = unitsSold; }
    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

package model;
//minhbq//26/4
import java.math.BigDecimal;

/**
 * Class ProductSearchItem đại diện cho một sản phẩm biến thể trong kết quả tìm kiếm sản phẩm của Admin.
 * Chứa các thông tin cơ bản về sản phẩm và trạng thái liệu sản phẩm đó có đang được chọn trong chiến dịch khuyến mãi hay không.
 * Tác nhân liên quan: Admin thực hiện tìm kiếm và chọn sản phẩm áp dụng khuyến mãi.
 */
public class ProductSearchItem {
    private int variantId;
    private String productName;
    private String variantName;
    private String sku;
    private String categoryName;
    private BigDecimal price;
    private int stock;
    private boolean selected;
    private int soldQty;
    private boolean gift;

    public int getVariantId() { return variantId; }
    public void setVariantId(int variantId) { this.variantId = variantId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getVariantName() { return variantName; }
    public void setVariantName(String variantName) { this.variantName = variantName; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public boolean isSelected() { return selected; }
    public void setSelected(boolean selected) { this.selected = selected; }
    public int getSoldQty() { return soldQty; }
    public void setSoldQty(int soldQty) { this.soldQty = soldQty; }
    public boolean isGift() { return gift; }
    public void setGift(boolean gift) { this.gift = gift; }
}

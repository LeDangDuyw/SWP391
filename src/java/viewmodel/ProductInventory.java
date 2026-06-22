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

    /*
     * Name: ProductInventory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng ProductInventory với đầy đủ các thuộc tính hiển thị thông tin kho hàng.
     */
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

    /*
     * Name: getProductId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã biến thể sản phẩm (productVariantId).
     */
    public int getProductId() {
        return productVariantId;
    }

    /*
     * Name: setProductId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã biến thể sản phẩm (productVariantId).
     */
    public void setProductId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    /*
     * Name: getProductName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên sản phẩm (productName).
     */
    public String getProductName() {
        return productName;
    }

    /*
     * Name: setProductName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên sản phẩm (productName).
     */
    public void setProductName(String productName) {
        this.productName = productName;
    }

    /*
     * Name: getSku
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã SKU của sản phẩm.
     */
    public String getSku() {
        return sku;
    }

    /*
     * Name: setSku
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã SKU của sản phẩm.
     */
    public void setSku(String sku) {
        this.sku = sku;
    }

    /*
     * Name: getVariantName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên biến thể sản phẩm (variantName).
     */
    public String getVariantName() {
        return variantName;
    }

    /*
     * Name: setVariantName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên biến thể sản phẩm (variantName).
     */
    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    /*
     * Name: getBrandName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên thương hiệu sản phẩm (brandName).
     */
    public String getBrandName() {
        return brandName;
    }

    /*
     * Name: setBrandName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên thương hiệu sản phẩm (brandName).
     */
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    /*
     * Name: getCategoryName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy tên danh mục sản phẩm (categoryName).
     */
    public String getCategoryName() {
        return categoryName;
    }

    /*
     * Name: setCategoryName
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán tên danh mục sản phẩm (categoryName).
     */
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    /*
     * Name: getSellingPrice
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy giá bán sản phẩm (sellingPrice).
     */
    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    /*
     * Name: setSellingPrice
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán giá bán sản phẩm (sellingPrice).
     */
    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    /*
     * Name: getAvailableQuantity
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy số lượng hàng có sẵn trong kho (availableQuantity).
     */
    public int getAvailableQuantity() {
        return availableQuantity;
    }

    /*
     * Name: setAvailableQuantity
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán số lượng hàng có sẵn trong kho (availableQuantity).
     */
    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    /*
     * Name: getStatus
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy trạng thái tồn kho của sản phẩm (ví dụ: In Stock, Sold Out).
     */
    public String getStatus() {
        return status;
    }

    /*
     * Name: setStatus
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán trạng thái tồn kho của sản phẩm (status).
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /*
     * Name: getThumbnail
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy đường dẫn ảnh đại diện của sản phẩm (thumbnail).
     */
    public String getThumbnail() {
        return thumbnail;
    }

    /*
     * Name: setThumbnail
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán đường dẫn ảnh đại diện của sản phẩm (thumbnail).
     */
    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
    
}

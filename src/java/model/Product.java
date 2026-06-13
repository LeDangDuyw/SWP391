/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author huy
 */
public class Product {
    private int productId;
    private String productName;
    private String description;
    private int warrantyPeriod;
    private String thumbnail;
    private int categoryId;
    private int brandId;
    private String categoryName;
    private String brandName;
    /*
     * Name: Product
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Product rỗng (constructor mặc định).
     */
    public Product() {
    }

    /*
     * Name: Product
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khởi tạo đối tượng Product với đầy đủ các thuộc tính cơ bản.
     */
    public Product(int productId, String productName, String description, int warrantyPeriod, String thumbnail, int categoryId, int brandId) {
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.warrantyPeriod = warrantyPeriod;
        this.thumbnail = thumbnail;
        this.categoryId = categoryId;
        this.brandId = brandId;
    }

    /*
     * Name: getProductId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã sản phẩm (productId).
     */
    public int getProductId() {
        return productId;
    }

    /*
     * Name: setProductId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã sản phẩm (productId).
     */
    public void setProductId(int productId) {
        this.productId = productId;
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
     * Name: getDescription
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mô tả chi tiết sản phẩm (description).
     */
    public String getDescription() {
        return description;
    }

    /*
     * Name: setDescription
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mô tả chi tiết sản phẩm (description).
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /*
     * Name: getWarrantyPeriod
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy thời gian bảo hành của sản phẩm (warrantyPeriod).
     */
    public int getWarrantyPeriod() {
        return warrantyPeriod;
    }

    /*
     * Name: setWarrantyPeriod
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán thời gian bảo hành của sản phẩm (warrantyPeriod).
     */
    public void setWarrantyPeriod(int warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
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

    /*
     * Name: getCategoryId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã danh mục của sản phẩm (categoryId).
     */
    public int getCategoryId() {
        return categoryId;
    }

    /*
     * Name: setCategoryId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã danh mục của sản phẩm (categoryId).
     */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /*
     * Name: getBrandId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy mã thương hiệu của sản phẩm (brandId).
     */
    public int getBrandId() {
        return brandId;
    }

    /*
     * Name: setBrandId
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Gán mã thương hiệu của sản phẩm (brandId).
     */
    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
}

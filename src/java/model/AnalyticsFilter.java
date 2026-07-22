package model;

/**
 * Class: AnalyticsFilter
 * Description: Model Data Transfer Object (DTO) chứa các tham số lọc đa chiều
 *              (ngày bắt đầu/kết thúc, danh mục, thương hiệu, loại khách hàng, phương thức thanh toán)
 *              phục vụ báo cáo phân tích chuyên sâu (Advanced Analytics).
 * 
 * Created: 2026-07-09
 * Updated: 2026-07-22
 * Version: v1.3
 *
 * @author DuyLD
 */

public class AnalyticsFilter {
    private String fromDate;
    private String toDate;
    private Integer categoryId;
    private Integer brandId;
    private String customerType; // "new" | "returning"
    private String paymentMethod;

    /**
     * Khởi tạo đối tượng AnalyticsFilter mặc định.
     */
    public AnalyticsFilter() {
    }

    /**
     * Khởi tạo đối tượng AnalyticsFilter với đầy đủ tham số lọc.
     *
     * @param fromDate      ngày bắt đầu (YYYY-MM-DD)
     * @param toDate        ngày kết thúc (YYYY-MM-DD)
     * @param categoryId    ID danh mục sản phẩm (hoặc null)
     * @param brandId       ID thương hiệu (hoặc null)
     * @param customerType  loại khách hàng ("new", "returning", hoặc null)
     * @param paymentMethod phương thức thanh toán (hoặc null)
     */
    public AnalyticsFilter(String fromDate, String toDate, Integer categoryId, Integer brandId, String customerType, String paymentMethod) {
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.customerType = customerType;
        this.paymentMethod = paymentMethod;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}

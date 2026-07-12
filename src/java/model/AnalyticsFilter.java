/**
 * Class: AnalyticsFilter
 * Description: Model lưu trữ cấu hình bộ lọc phân tích (Analytics Filter).
 * 
 * Created: 2026-07-09 18:10:23 +0700
 * Updated: 2026-07-09 18:10:23 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: AnalyticsFilter
 * Description: Model lưu trữ cấu hình bộ lọc phân tích (Analytics Filter).
 * 
 * Created: 2026-07-09 18:10:23 +0700
 * Updated: 2026-07-09 18:10:23 +0700
 * Version: v1.0
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
     * Phuong thuc AnalyticsFilter
     */
    public AnalyticsFilter() {
    }

    /**
     * Phuong thuc AnalyticsFilter
     */
    public AnalyticsFilter(String fromDate, String toDate, Integer categoryId, Integer brandId, String customerType, String paymentMethod) {
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.customerType = customerType;
        this.paymentMethod = paymentMethod;
    }

    /**
     * Phuong thuc getFromDate
     */
    public String getFromDate() {
        return fromDate;
    }

    /**
     * Phuong thuc setFromDate
     */
    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    /**
     * Phuong thuc getToDate
     */
    public String getToDate() {
        return toDate;
    }

    /**
     * Phuong thuc setToDate
     */
    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    /**
     * Phuong thuc getCategoryId
     */
    public Integer getCategoryId() {
        return categoryId;
    }

    /**
     * Phuong thuc setCategoryId
     */
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    /**
     * Phuong thuc getBrandId
     */
    public Integer getBrandId() {
        return brandId;
    }

    /**
     * Phuong thuc setBrandId
     */
    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    /**
     * Phuong thuc getCustomerType
     */
    public String getCustomerType() {
        return customerType;
    }

    /**
     * Phuong thuc setCustomerType
     */
    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

    /**
     * Phuong thuc getPaymentMethod
     */
    public String getPaymentMethod() {
        return paymentMethod;
    }

    /**
     * Phuong thuc setPaymentMethod
     */
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    @Override
    /**
     * Phuong thuc toString
     */
    public String toString() {
        return "AnalyticsFilter{" +
                "fromDate='" + fromDate + '\'' +
                ", toDate='" + toDate + '\'' +
                ", categoryId=" + categoryId +
                ", brandId=" + brandId +
                ", customerType='" + customerType + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                '}';
    }
}

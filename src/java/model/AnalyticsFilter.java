package model;

/**
 * AnalyticsFilter represents the search/filtering criteria 
 * for the Advanced Analytics Module.
 * 
 * Version 1.0
 * Date: 09/07/2026
 * Author: Antigravity
 */
public class AnalyticsFilter {
    private String fromDate;
    private String toDate;
    private Integer categoryId;
    private Integer brandId;
    private String customerType; // "new" | "returning"
    private String paymentMethod;

    public AnalyticsFilter() {
    }

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

    @Override
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

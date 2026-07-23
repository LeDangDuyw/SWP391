package model;
//minhbq//26/4
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Class Campaign đại diện cho một chiến dịch khuyến mãi (Promotion Campaign) trong hệ thống.
 * Chứa các thông tin về cấu hình giảm giá, đối tượng áp dụng, thời gian và trạng thái chiến dịch.
 * Tác nhân liên quan: Admin quản lý cấu hình, Khách hàng áp dụng trong thanh toán.
 */
public class Campaign {
    private int campaignId;
    private String campaignName;
    private String campaignDescription;
    private String promoCode;
    private String campaignType;
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private Integer usageLimit;
    private Integer userUsageLimit;
    private int usedCount;
    private String targetGroup;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String status;
    private int productCount;
    private Integer pointsRequired = 0;

    public Integer getPointsRequired() { return pointsRequired; }
    public void setPointsRequired(Integer pointsRequired) { this.pointsRequired = pointsRequired; }

    /**
     * Khởi tạo đối tượng Campaign với các giá trị mặc định ban đầu.
     */
    public Campaign() {
        this.discountValue = BigDecimal.ZERO;
        this.minOrderValue = BigDecimal.ZERO;
        this.usedCount = 0;
        this.targetGroup = "All Customers";
        this.status = "scheduled";
        this.campaignType = "percentage";
    }

    public int getCampaignId() { return campaignId; }
    public void setCampaignId(int campaignId) { this.campaignId = campaignId; }
    public String getCampaignName() { return campaignName; }
    public void setCampaignName(String campaignName) { this.campaignName = campaignName; }
    public String getCampaignDescription() { return campaignDescription; }
    public void setCampaignDescription(String campaignDescription) { this.campaignDescription = campaignDescription; }
    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }
    public String getCampaignType() { return campaignType; }
    public void setCampaignType(String campaignType) { this.campaignType = campaignType; }
    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }
    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }
    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }
    public Integer getUserUsageLimit() { return userUsageLimit; }
    public void setUserUsageLimit(Integer userUsageLimit) { this.userUsageLimit = userUsageLimit; }
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }
    public String getTargetGroup() { return targetGroup; }
    public void setTargetGroup(String targetGroup) { this.targetGroup = targetGroup; }
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }

    public String getFormattedStartDate() {
        if (startDate == null) {
            return "";
        }
        String text = startDate.toString();
        return text.length() >= 16 ? text.substring(0, 16) : text;
    }

    public String getFormattedEndDate() {
        if (endDate == null) {
            return "";
        }
        String text = endDate.toString();
        return text.length() >= 16 ? text.substring(0, 16) : text;
    }

    public String getFormattedStatus() {
        if (status == null) {
            return "Unknown";
        }
        switch (status.toLowerCase()) {
            case "active":
                return "Active";
            case "scheduled":
                return "Scheduled";
            case "pending_approval":
                return "Pending Approval";
            case "paused":
                return "Paused";
            case "stopped":
                return "Stopped";
            case "expired":
                return "Expired";
            default:
                return status;
        }
    }

    public String getStatusClass() {
        return status == null ? "" : status.toLowerCase().replace('_', '-');
    }

    public String getFormattedStartDateDateOnly() {
        String start = getFormattedStartDate();
        return start.length() >= 10 ? start.substring(0, 10) : start;
    }

    public String getFormattedEndDateDateOnly() {
        String end = getFormattedEndDate();
        return end.length() >= 10 ? end.substring(0, 10) : end;
    }
}

package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Campaign {
    private int campaignId;
    private String campaignName;
    private String campaignDescription;
    private String promoCode;
    private String campaignType;
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private Integer usageLimit;
    private int usedCount;
    private String targetGroup;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String status;
    private int productCount;

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
}

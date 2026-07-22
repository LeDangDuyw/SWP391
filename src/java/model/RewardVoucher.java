package model;

import java.math.BigDecimal;

public class RewardVoucher {
    private int rewardVoucherId;
    private String title;
    private String voucherCodePrefix;
    private BigDecimal discountValue;
    private int pointsRequired;
    private BigDecimal minOrderValue;
    private String description;
    private String status;

    public RewardVoucher() {
    }

    public RewardVoucher(int rewardVoucherId, String title, String voucherCodePrefix, BigDecimal discountValue, int pointsRequired, BigDecimal minOrderValue, String description, String status) {
        this.rewardVoucherId = rewardVoucherId;
        this.title = title;
        this.voucherCodePrefix = voucherCodePrefix;
        this.discountValue = discountValue;
        this.pointsRequired = pointsRequired;
        this.minOrderValue = minOrderValue;
        this.description = description;
        this.status = status;
    }

    public int getRewardVoucherId() {
        return rewardVoucherId;
    }

    public void setRewardVoucherId(int rewardVoucherId) {
        this.rewardVoucherId = rewardVoucherId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getVoucherCodePrefix() {
        return voucherCodePrefix;
    }

    public void setVoucherCodePrefix(String voucherCodePrefix) {
        this.voucherCodePrefix = voucherCodePrefix;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public int getPointsRequired() {
        return pointsRequired;
    }

    public void setPointsRequired(int pointsRequired) {
        this.pointsRequired = pointsRequired;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class UserVoucherDTO {
    private int voucherId;
    private String voucherCode;
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private Timestamp expiryDate;
    private boolean isUsed;
    
    // Thuộc tính tính toán động cho giỏ hàng hiện tại (được khởi tạo giá trị mặc định để tránh NullPointerException)
    private boolean isAvailable = false;
    private BigDecimal discountAmountActual = BigDecimal.ZERO;
    private BigDecimal missingAmount = BigDecimal.ZERO;
    private String statusMessage = "";

    public UserVoucherDTO() {}

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }

    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }

    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }

    public Timestamp getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; }

    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean used) { isUsed = used; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public BigDecimal getDiscountAmountActual() { return discountAmountActual; }
    public void setDiscountAmountActual(BigDecimal discountAmountActual) { this.discountAmountActual = discountAmountActual; }

    public BigDecimal getMissingAmount() { return missingAmount; }
    public void setMissingAmount(BigDecimal missingAmount) { this.missingAmount = missingAmount; }

    public String getStatusMessage() { return statusMessage; }
    public void setStatusMessage(String statusMessage) { this.statusMessage = statusMessage; }
}

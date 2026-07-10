package model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * WarrantyPurchasedProduct represents a single purchased unit (identified by
 * serial number) shown in Step 1 ("Select Product") of the Submit Claim
 * wizard on warranty_center.jsp. One row per ProductSerials record — if a
 * customer bought 2 units of the same model in one order, each unit (each
 * serial) is listed separately, since each has its own independent
 * warranty/claim state.
 *
 * Author DuyLD
 */
public class WarrantyPurchasedProduct {

    private String serialNumber;
    private String productName;
    private Timestamp purchaseDate;
    private Date warrantyExpiry;
    private String coverageName;
    private boolean underWarranty;
    private boolean hasActiveClaim;

    public WarrantyPurchasedProduct() {
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Timestamp getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Timestamp purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public Date getWarrantyExpiry() {
        return warrantyExpiry;
    }

    public void setWarrantyExpiry(Date warrantyExpiry) {
        this.warrantyExpiry = warrantyExpiry;
    }

    public String getCoverageName() {
        return coverageName;
    }

    public void setCoverageName(String coverageName) {
        this.coverageName = coverageName;
    }

    public boolean isUnderWarranty() {
        return underWarranty;
    }

    public void setUnderWarranty(boolean underWarranty) {
        this.underWarranty = underWarranty;
    }

    public boolean isHasActiveClaim() {
        return hasActiveClaim;
    }

    public void setHasActiveClaim(boolean hasActiveClaim) {
        this.hasActiveClaim = hasActiveClaim;
    }
}

package model;

import java.sql.Date;

/**
 * WarrantyEligibilityInfo carries product and warranty details returned
 * after a successful Check Eligibility verification (Step 1 of the Submit
 * Claim wizard). Used to populate Step 2 ("Warranty Information") on
 * warranty_center.jsp without requiring AJAX/JSON — the controller sets
 * this as a request attribute before forwarding back to the JSP.
 *
 * Author DuyLD
 */
public class WarrantyEligibilityInfo {

    private String serialNumber;
    private String productName;
    private Date warrantyExpiry;
    private String coverageName;

    public WarrantyEligibilityInfo() {
    }

    public WarrantyEligibilityInfo(String serialNumber, String productName,
            Date warrantyExpiry, String coverageName) {
        this.serialNumber = serialNumber;
        this.productName = productName;
        this.warrantyExpiry = warrantyExpiry;
        this.coverageName = coverageName;
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
}

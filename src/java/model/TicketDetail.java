package model;

import java.math.BigDecimal;

public class TicketDetail {
    private int detailId;
    private int ticketId;
    private int variantId;
    private int quantity;
    private BigDecimal expectedPrice;
    
    private String variantName;
    private String sku;
    private int importedQuantity;

    public TicketDetail() {
    }

    public TicketDetail(int detailId, int ticketId, int variantId, int quantity, BigDecimal expectedPrice) {
        this.detailId = detailId;
        this.ticketId = ticketId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.expectedPrice = expectedPrice;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getExpectedPrice() {
        return expectedPrice;
    }

    public void setExpectedPrice(BigDecimal expectedPrice) {
        this.expectedPrice = expectedPrice;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public int getImportedQuantity() {
        return importedQuantity;
    }

    public void setImportedQuantity(int importedQuantity) {
        this.importedQuantity = importedQuantity;
    }
}

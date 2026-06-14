/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.time.LocalDate;
/**
 *
 * @author huy
 */
public class InventoryItem {
    private int itemId;
    private String serialNumber;
    private String imei;
    private String barcode;
    private String status;
    private String importDate;
    private LocalDate soldDate;
    private LocalDate warrantyExpiredDate;
    private String warehouseLocation;
    private String note;
    private LocalDate createdAt;
    private LocalDate updatedAt;

    public InventoryItem(int itemId, String serialNumber, String imei, String barcode, String status, String importDate, LocalDate soldDate, LocalDate warrantyExpiredDate, String warehouseLocation, String note, LocalDate createdAt, LocalDate updatedAt) {
        this.itemId = itemId;
        this.serialNumber = serialNumber;
        this.imei = imei;
        this.barcode = barcode;
        this.status = status;
        this.importDate = importDate;
        this.soldDate = soldDate;
        this.warrantyExpiredDate = warrantyExpiredDate;
        this.warehouseLocation = warehouseLocation;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getImei() {
        return imei;
    }

    public void setImei(String imei) {
        this.imei = imei;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImportDate() {
        return importDate;
    }

    public void setImportDate(String importDate) {
        this.importDate = importDate;
    }

    public LocalDate getSoldDate() {
        return soldDate;
    }

    public void setSoldDate(LocalDate soldDate) {
        this.soldDate = soldDate;
    }

    public LocalDate getWarrantyExpiredDate() {
        return warrantyExpiredDate;
    }

    public void setWarrantyExpiredDate(LocalDate warrantyExpiredDate) {
        this.warrantyExpiredDate = warrantyExpiredDate;
    }

    public String getWarehouseLocation() {
        return warehouseLocation;
    }

    public void setWarehouseLocation(String warehouseLocation) {
        this.warehouseLocation = warehouseLocation;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDate getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }

    private String productName;
    private String variantName;
    private String sku;

    public InventoryItem() {
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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
}

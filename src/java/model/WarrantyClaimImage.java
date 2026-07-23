package model;

import java.sql.Timestamp;

/**
 * Class: WarrantyClaimImage
 * Description: Model lưu trữ thông tin tệp ảnh đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
 */
public class WarrantyClaimImage {

    private int imageId;
    private int claimId;
    private String imageUrl;
    private Timestamp uploadedAt;

    /**
     * Khởi tạo mặc định.
     */
    public WarrantyClaimImage() {
    }

    /**
     * Khởi tạo dùng khi tạo mới ảnh đính kèm (chưa có ID và thời gian tạo).
     */
    public WarrantyClaimImage(int claimId, String imageUrl) {
        this.claimId = claimId;
        this.imageUrl = imageUrl;
    }

    /**
     * Khởi tạo đầy đủ thuộc tính từ bản ghi trong CSDL.
     */
    public WarrantyClaimImage(int imageId, int claimId, String imageUrl, Timestamp uploadedAt) {
        this.imageId = imageId;
        this.claimId = claimId;
        this.imageUrl = imageUrl;
        this.uploadedAt = uploadedAt;
    }

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }

    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
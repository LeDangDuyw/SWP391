package model;

import java.sql.Timestamp;

/**
 * WarrantyClaimImage represents a single image attached to a WarrantyClaim.
 *
 * Maps to the WarrantyClaimImages table.
 *
 * Quan hệ: WarrantyClaims (1) - (N) WarrantyClaimImages
 *
 * Columns: image_id, claim_id, image_url, uploaded_at
 *
 * Version 1.0
 * Author DuyLD
 */
public class WarrantyClaimImage {

    private int imageId;
    private int claimId;
    private String imageUrl;
    private Timestamp uploadedAt;

    /**
     * Default constructor.
     */
    public WarrantyClaimImage() {
    }

    /**
     * Constructor dùng khi insert (chưa có imageId, uploadedAt do DB tự gán).
     */
    public WarrantyClaimImage(int claimId, String imageUrl) {
        this.claimId = claimId;
        this.imageUrl = imageUrl;
    }

    /**
     * Full constructor cho việc map từ ResultSet.
     */
    public WarrantyClaimImage(int imageId, int claimId, String imageUrl, Timestamp uploadedAt) {
        this.imageId = imageId;
        this.claimId = claimId;
        this.imageUrl = imageUrl;
        this.uploadedAt = uploadedAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }

    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
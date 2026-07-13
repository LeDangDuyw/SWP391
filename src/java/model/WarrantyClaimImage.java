/**
 * Class: WarrantyClaimImage
 * Description: Model ảnh đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26 00:12:55 +0700
 * Updated: 2026-06-26 00:12:55 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: WarrantyClaimImage
 * Description: Model ảnh đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26 00:12:55 +0700
 * Updated: 2026-06-26 00:12:55 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import java.sql.Timestamp;


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
    /**
     * Phuong thuc setImageId
     */
    public void setImageId(int imageId) { this.imageId = imageId; }

    /**
     * Phuong thuc getClaimId
     */
    public int getClaimId() { return claimId; }
    /**
     * Phuong thuc setClaimId
     */
    public void setClaimId(int claimId) { this.claimId = claimId; }

    /**
     * Phuong thuc getImageUrl
     */
    public String getImageUrl() { return imageUrl; }
    /**
     * Phuong thuc setImageUrl
     */
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    /**
     * Phuong thuc getUploadedAt
     */
    public Timestamp getUploadedAt() { return uploadedAt; }
    /**
     * Phuong thuc setUploadedAt
     */
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
package dal;
/**
 * Class: WarrantyClaimImageDAO
 * Description: Data Access Object xử lý hình ảnh minh chứng đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26 00:12:55 +0700
 * Updated: 2026-06-26 00:12:55 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: WarrantyClaimImageDAO
 * Description: Data Access Object xử lý hình ảnh minh chứng đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26 00:12:55 +0700
 * Updated: 2026-06-26 00:12:55 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import model.WarrantyClaimImage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class WarrantyClaimImageDAO extends DBContext {

    // ── INSERT ────────────────────────────────────────────────────────────────

    /**
     * Inserts a single image record cho một claim.
     *
     * @param claimId  ID của claim sở hữu ảnh
     * @param imageUrl đường dẫn/URL ảnh đã lưu (đã được tạo sau khi ghi file vào disk)
     * @throws Exception on SQL error
     */
    public void insert(int claimId, String imageUrl) throws Exception {
        String sql = "INSERT INTO WarrantyClaimImages (claim_id, image_url, uploaded_at) "
                + "VALUES (?, ?, GETDATE())";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        }
    }

    /**
     * Insert nhiều ảnh cho một claim trong một lần gọi (dùng batch để giảm round-trip).
     *
     * @param claimId   ID của claim
     * @param imageUrls danh sách URL ảnh đã lưu trên disk
     * @throws Exception on SQL error
     */
    public void insertBatch(int claimId, List<String> imageUrls) throws Exception {
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        // Kiểm tra điều kiện
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO WarrantyClaimImages (claim_id, image_url, uploaded_at) "
                + "VALUES (?, ?, GETDATE())";

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (String url : imageUrls) {
                ps.setInt(1, claimId);
                ps.setString(2, url);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // ── FIND BY CLAIM ID ──────────────────────────────────────────────────────

    /**
     * Lấy toàn bộ ảnh của một claim, mới nhất trước (dùng cho gallery trên detail.jsp).
     *
     * @param claimId ID của claim
     * @return danh sách WarrantyClaimImage
     * @throws Exception on SQL error
     */
    public List<WarrantyClaimImage> findByClaimId(int claimId) throws Exception {
        String sql = "SELECT * FROM WarrantyClaimImages "
                + "WHERE claim_id = ? "
                + "ORDER BY uploaded_at ASC";

        List<WarrantyClaimImage> list = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapImage(rs));
                }
            }
        }
        return list;
    }

    /**
     * Đếm số ảnh hiện có của một claim — dùng để chặn việc thêm ảnh vượt quá
     * giới hạn 5 ảnh/claim nếu sau này cho phép upload bổ sung.
     *
     * @param claimId ID của claim
     * @return số ảnh hiện có
     * @throws Exception on SQL error
     */
    public int countByClaimId(int claimId) throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyClaimImages WHERE claim_id = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    /**
     * Xoá một ảnh cụ thể theo image_id.
     * Lưu ý: chỉ xoá record trong DB, việc xoá file vật lý trên disk
     * (nếu cần) phải gọi riêng ở Service layer.
     *
     * @param imageId ID của ảnh cần xoá
     * @throws Exception on SQL error
     */
    public void deleteById(int imageId) throws Exception {
        String sql = "DELETE FROM WarrantyClaimImages WHERE image_id = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
        }
    }

    /**
     * Xoá toàn bộ ảnh của một claim (dùng khi xoá hẳn claim, nếu hệ thống hỗ trợ).
     *
     * @param claimId ID của claim
     * @throws Exception on SQL error
     */
    public void deleteByClaimId(int claimId) throws Exception {
        String sql = "DELETE FROM WarrantyClaimImages WHERE claim_id = ?";
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.executeUpdate();
        }
    }

    // ── PRIVATE MAPPING ───────────────────────────────────────────────────────

    private WarrantyClaimImage mapImage(ResultSet rs) throws SQLException {
        return new WarrantyClaimImage(
                rs.getInt("image_id"),
                rs.getInt("claim_id"),
                rs.getString("image_url"),
                rs.getTimestamp("uploaded_at")
        );
    }
}
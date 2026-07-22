package dal;

/**
 * Class: WarrantyClaimImageDAO
 * Description: Data Access Object xử lý lưu trữ và truy vấn đường dẫn các hình ảnh minh chứng đính kèm phiếu bảo hành.
 * 
 * Created: 2026-06-26
 * Updated: 2026-07-22
 * Version: v1.3
 *
 * @author DuyLD
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.WarrantyClaimImage;

public class WarrantyClaimImageDAO extends DBContext {

    /**
     * Lưu thông tin một ảnh minh chứng cho phiếu bảo hành.
     *
     * @param claimId  ID phiếu bảo hành
     * @param imageUrl đường dẫn tương đối của ảnh đã ghi trên đĩa
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void insert(int claimId, String imageUrl) throws Exception {
        String sql = "INSERT INTO WarrantyClaimImages (claim_id, image_url, uploaded_at) "
                + "VALUES (?, ?, GETDATE())";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        }
    }

    /**
     * Thêm danh sách nhiều ảnh minh chứng cho phiếu bảo hành trong một giao tác batch (tối ưu hiệu năng round-trip CSDL).
     *
     * @param claimId   ID phiếu bảo hành
     * @param imageUrls danh sách các đường dẫn ảnh
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public void insertBatch(int claimId, List<String> imageUrls) throws Exception {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO WarrantyClaimImages (claim_id, image_url, uploaded_at) "
                + "VALUES (?, ?, GETDATE())";

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

    /**
     * Truy vấn toàn bộ hình ảnh minh chứng của một phiếu bảo hành (sắp xếp theo thời gian tải lên tăng dần).
     *
     * @param claimId ID phiếu bảo hành
     * @return danh sách các đối tượng WarrantyClaimImage
     * @throws Exception nếu xảy ra lỗi SQL
     */
    public List<WarrantyClaimImage> findByClaimId(int claimId) throws Exception {
        String sql = "SELECT * FROM WarrantyClaimImages "
                + "WHERE claim_id = ? "
                + "ORDER BY uploaded_at ASC";

        List<WarrantyClaimImage> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapImage(rs));
                }
            }
        }
        return list;
    }

    /**
     * Helper ánh xạ dữ liệu từ ResultSet sang đối tượng WarrantyClaimImage.
     */
    private WarrantyClaimImage mapImage(ResultSet rs) throws SQLException {
        return new WarrantyClaimImage(
                rs.getInt("image_id"),
                rs.getInt("claim_id"),
                rs.getString("image_url"),
                rs.getTimestamp("uploaded_at")
        );
    }
}
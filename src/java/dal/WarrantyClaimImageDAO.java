package dal;

import model.WarrantyClaimImage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Class: WarrantyClaimImageDAO
 * Description: Data Access Object (DAO) xử lý lưu trữ và truy vấn thông tin hình ảnh đính kèm minh chứng cho phiếu bảo hành.
 * 
 * Created: 2026-06-26
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
 */
public class WarrantyClaimImageDAO extends DBContext {


    /**
     * Thêm mới một bản ghi hình ảnh đính kèm cho phiếu bảo hành.
     *
     * @param claimId  Mã ID phiếu bảo hành
     * @param imageUrl Đường dẫn URL lưu tệp ảnh
     * @throws Exception Ngoại lệ SQL
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
     * Thêm danh sách nhiều tệp ảnh đính kèm theo lô (batch execution) cho phiếu bảo hành.
     *
     * @param claimId   Mã ID phiếu bảo hành
     * @param imageUrls Danh sách đường dẫn ảnh
     * @throws Exception Ngoại lệ SQL
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
     * Lấy toàn bộ danh sách tệp ảnh đính kèm thuộc về một phiếu bảo hành.
     *
     * @param claimId Mã ID phiếu bảo hành
     * @return Danh sách các đối tượng WarrantyClaimImage
     * @throws Exception Ngoại lệ SQL
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
     * Đếm số lượng ảnh minh chứng hiện có của một phiếu bảo hành.
     *
     * @param claimId Mã ID phiếu bảo hành
     * @return Số lượng ảnh
     * @throws Exception Ngoại lệ SQL
     */
    public int countByClaimId(int claimId) throws Exception {
        String sql = "SELECT COUNT(*) FROM WarrantyClaimImages WHERE claim_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Xóa một bản ghi tệp ảnh theo ID ảnh.
     *
     * @param imageId Mã ID ảnh cần xóa
     * @throws Exception Ngoại lệ SQL
     */
    public void deleteById(int imageId) throws Exception {
        String sql = "DELETE FROM WarrantyClaimImages WHERE image_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
        }
    }

    /**
     * Xóa toàn bộ ảnh đính kèm của một phiếu bảo hành.
     *
     * @param claimId Mã ID phiếu bảo hành
     * @throws Exception Ngoại lệ SQL
     */
    public void deleteByClaimId(int claimId) throws Exception {
        String sql = "DELETE FROM WarrantyClaimImages WHERE claim_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.executeUpdate();
        }
    }

    /**
     * Ánh xạ từ dòng dữ liệu ResultSet sang đối tượng WarrantyClaimImage.
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
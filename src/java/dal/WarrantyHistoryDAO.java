package dal;

import model.WarrantyHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Class: WarrantyHistoryDAO
 * Description: Data Access Object (DAO) ghi nhận và truy xuất nhật ký/lịch sử chuyển trạng thái xử lý bảo hành (Warranty History).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
 */
public class WarrantyHistoryDAO extends DBContext {


    /**
     * Ghi thêm một bản ghi nhật ký tiến độ xử lý bảo hành mới.
     *
     * @param history Đối tượng WarrantyHistory chứa thông tin chuyển trạng thái và ghi chú
     * @throws Exception Ngoại lệ SQL
     */
    public void insert(WarrantyHistory history) throws Exception {
        String sql = "INSERT INTO WarrantyHistory "
                + "(warranty_id, issue_description, repair_status, repair_date, repair_note, created_at) "
                + "VALUES (?, ?, ?, GETDATE(), ?, GETDATE())";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, history.getWarrantyId());
            ps.setString(2, history.getIssueDescription());
            ps.setString(3, history.getRepairStatus());
            ps.setString(4, history.getRepairNote());
            ps.executeUpdate();
        }
    }

    /**
     * Truy xuất toàn bộ lịch sử tiến độ xử lý của một đơn bảo hành (sắp xếp theo thời gian tăng dần).
     *
     * @param warrantyId Mã ID đơn bảo hành
     * @return Danh sách các bản ghi tiến độ WarrantyHistory
     * @throws Exception Ngoại lệ SQL
     */
    public List<WarrantyHistory> findByWarrantyId(int warrantyId) throws Exception {
        String sql = "SELECT * FROM WarrantyHistory "
                + "WHERE warranty_id = ? "
                + "ORDER BY created_at ASC";

        List<WarrantyHistory> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, warrantyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapHistory(rs));
                }
            }
        }
        return list;
    }

    /**
     * Xóa toàn bộ nhật ký lịch sử xử lý của một đơn bảo hành.
     *
     * @param warrantyId Mã ID đơn bảo hành
     * @throws Exception Ngoại lệ SQL
     */
    public void deleteByWarrantyId(int warrantyId) throws Exception {
        String sql = "DELETE FROM WarrantyHistory WHERE warranty_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, warrantyId);
            ps.executeUpdate();
        }
    }

    /**
     * Ánh xạ từ dòng ResultSet sang đối tượng WarrantyHistory.
     */
    private WarrantyHistory mapHistory(ResultSet rs) throws SQLException {
        return new WarrantyHistory(
                rs.getInt("history_id"),
                rs.getInt("warranty_id"),
                rs.getString("issue_description"),
                rs.getString("repair_status"),
                rs.getTimestamp("repair_date"),
                rs.getString("repair_note"),
                rs.getTimestamp("created_at")
        );
    }
}


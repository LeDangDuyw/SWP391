package dal;

/**
 * Class: WarrantyHistoryDAO
 * Description: Data Access Object xử lý ghi vết nhật ký audit log và truy vấn timeline
 *              lịch sử chuyển trạng thái yêu cầu bảo hành (BR-17).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-22
 * Version: v1.8
 *
 * @author DuyLD
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.WarrantyHistory;

public class WarrantyHistoryDAO extends DBContext {

    /**
     * Ghi nhận một mốc lịch sử thay đổi trạng thái cho phiếu bảo hành.
     * Mốc thời gian được lấy trực tiếp từ hàm GETDATE() của hệ quản trị CSDL để tránh lệch đồng hồ hệ thống.
     *
     * @param history đối tượng WarrantyHistory chứa thông tin nhật ký
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Lấy toàn bộ danh sách lịch sử xử lý của phiếu bảo hành, sắp xếp theo thời gian tạo tăng dần (phục vụ vẽ timeline trên giao diện).
     *
     * @param warrantyId ID của phiếu bảo hành
     * @return danh sách các bản ghi WarrantyHistory
     * @throws Exception nếu xảy ra lỗi SQL
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
     * Helper ánh xạ từ dòng ResultSet sang đối tượng WarrantyHistory.
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

package dal;

import model.Ticket;
import model.TicketDetail;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/*
 * Name: TicketDAO
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý các giao dịch phiếu nhập kho (Ticket & TicketDetails) thuộc luồng Inbound.
 */
public class TicketDAO extends DBContext {

    /**
     * Tạo mới một phiếu yêu cầu nhập kho (Ticket) kèm theo danh sách biến thể sản phẩm chi tiết (TicketDetails).
     * Sử dụng Transaction để đảm bảo tính toàn vẹn dữ liệu khi ghi vào CSDL.
     * 
     * @param ticket Thông tin phiếu nhập kho (tiêu đề, người tạo, trạng thái...)
     * @param details Danh sách chi tiết các biến thể sản phẩm nhập kho (số lượng, giá đề xuất...)
     * @return ID phiếu nhập kho vừa tạo nếu thành công, ngược lại trả về -1
     */
    public int createTicket(Ticket ticket, List<TicketDetail> details) {
        String insertTicketSQL = "INSERT INTO Ticket (title, status, reason, created_by, created_at, updated_at) VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";
        String insertDetailSQL = "INSERT INTO TicketDetails (ticket_id, variant_id, quantity, expected_price) VALUES (?, ?, ?, ?)";
        int generatedTicketId = -1;

        try {
            connection.setAutoCommit(false); // Start transaction

            try (PreparedStatement ps = connection.prepareStatement(insertTicketSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, ticket.getTitle());
                ps.setString(2, ticket.getStatus());
                ps.setString(3, ticket.getReason());
                ps.setInt(4, ticket.getCreatedBy());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedTicketId = rs.getInt(1);
                    }
                }
            }

            if (generatedTicketId != -1 && details != null) {
                try (PreparedStatement psDetail = connection.prepareStatement(insertDetailSQL)) {
                    for (TicketDetail detail : details) {
                        psDetail.setInt(1, generatedTicketId);
                        psDetail.setInt(2, detail.getVariantId());
                        psDetail.setInt(3, detail.getQuantity());
                        psDetail.setBigDecimal(4, detail.getExpectedPrice());
                        psDetail.addBatch();
                    }
                    psDetail.executeBatch();
                }
            }

            connection.commit(); // Commit transaction
        } catch (SQLException e) {
            try {
                connection.rollback(); // Rollback on error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return generatedTicketId;
    }

    /**
     * Cập nhật trạng thái và ghi nhận lý do (nếu bị từ chối) cho một phiếu nhập kho.
     * 
     * @param ticketId Mã ID của phiếu nhập kho cần cập nhật
     * @param status Trạng thái mới (ví dụ: APPROVED, REJECTED, COMPLETED)
     * @param reason Lý do phê duyệt hoặc từ chối
     * @return true nếu cập nhật thành công, ngược lại false
     */
    public boolean updateTicketStatus(int ticketId, String status, String reason) {
        String sql = "UPDATE Ticket SET status = ?, reason = ?, updated_at = GETDATE() WHERE ticket_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, reason);
            ps.setInt(3, ticketId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách tất cả các phiếu yêu cầu nhập kho trong hệ thống, sắp xếp theo thời gian tạo mới nhất.
     * 
     * @return Danh sách các đối tượng Ticket
     */
    public List<Ticket> getAllTickets() {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM Ticket ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Ticket t = new Ticket();
                t.setTicketId(rs.getInt("ticket_id"));
                t.setTitle(rs.getString("title"));
                t.setStatus(rs.getString("status"));
                t.setReason(rs.getString("reason"));
                t.setCreatedBy(rs.getInt("created_by"));
                if (rs.getTimestamp("created_at") != null) {
                    t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                if (rs.getTimestamp("updated_at") != null) {
                    t.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Truy vấn thông tin phiếu nhập kho theo ID, bao gồm đầy đủ danh sách các biến thể chi tiết đi kèm.
     * 
     * @param ticketId Mã ID phiếu nhập kho cần tìm
     * @return Đối tượng Ticket tìm thấy hoặc null nếu không tồn tại
     */
    public Ticket getTicketById(int ticketId) {
        String sql = "SELECT * FROM Ticket WHERE ticket_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ticket t = new Ticket();
                    t.setTicketId(rs.getInt("ticket_id"));
                    t.setTitle(rs.getString("title"));
                    t.setStatus(rs.getString("status"));
                    t.setReason(rs.getString("reason"));
                    t.setCreatedBy(rs.getInt("created_by"));
                    if (rs.getTimestamp("created_at") != null) {
                        t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        t.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    
                    t.setDetails(getTicketDetails(ticketId));
                    return t;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách chi tiết các biến thể sản phẩm thuộc một phiếu nhập kho, kèm theo số lượng đã nhập thực tế.
     * 
     * @param ticketId Mã ID phiếu nhập kho
     * @return Danh sách các đối tượng TicketDetail
     */
    public List<TicketDetail> getTicketDetails(int ticketId) {
        List<TicketDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, pv.variant_name, pv.sku, " +
                     "  (SELECT COUNT(*) FROM InventoryItem ii WHERE ii.ticket_id = td.ticket_id AND ii.variant_id = td.variant_id) as imported_quantity " +
                     "FROM TicketDetails td " +
                     "LEFT JOIN ProductVariant pv ON td.variant_id = pv.variant_id " +
                     "WHERE td.ticket_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketDetail td = new TicketDetail();
                    td.setDetailId(rs.getInt("detail_id"));
                    td.setTicketId(rs.getInt("ticket_id"));
                    td.setVariantId(rs.getInt("variant_id"));
                    td.setQuantity(rs.getInt("quantity"));
                    td.setExpectedPrice(rs.getBigDecimal("expected_price"));
                    td.setVariantName(rs.getString("variant_name"));
                    td.setSku(rs.getString("sku"));
                    td.setImportedQuantity(rs.getInt("imported_quantity"));
                    list.add(td);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * [ĐÃ VÔ HIỆU HÓA] Không còn ghi đè import_price trong ProductVariant.
     * Giá nhập theo lô hàng được giữ nguyên trong TicketDetails.expected_price,
     * liên kết với từng Serial qua InventoryItem.ticket_id.
     */
    public void updateImportPriceFromTicket(int ticketId) {
        // Đã vô hiệu hóa - giá nhập theo lô được lưu ở TicketDetails, không ghi đè lên ProductVariant
    }

    /**
     * Kiểm tra xem tất cả các mặt hàng/biến thể trong phiếu nhập kho đã được nhập kho đủ số lượng mã Serial thực tế hay chưa.
     * 
     * @param ticketId Mã ID phiếu nhập kho
     * @return true nếu đã nhập đủ toàn bộ số lượng Serial cho tất cả mặt hàng trong phiếu, ngược lại false
     */
    public boolean isTicketFullyImported(int ticketId) {
        try {
            String sql = "SELECT COUNT(*) FROM TicketDetails td " +
                         "WHERE td.ticket_id = ? " +
                         "AND td.quantity > ( " +
                         "    SELECT COUNT(*) FROM InventoryItem ii " +
                         "    WHERE ii.ticket_id = td.ticket_id " +
                         "    AND ii.variant_id = td.variant_id " +
                         ")";
            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                stm.setInt(1, ticketId);
                try (ResultSet rs = stm.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) == 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("isTicketFullyImported error: " + e.getMessage());
        }
        return false;
    }
}

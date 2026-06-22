package dal;

import model.Ticket;
import model.TicketDetail;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO extends DBContext {

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

    public List<TicketDetail> getTicketDetails(int ticketId) {
        List<TicketDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, pv.variant_name, pv.sku " +
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
                    list.add(td);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Khi Ticket hoàn tất (COMPLETED), cập nhật import_price trong ProductVariant
     * bằng giá nhập (ExpectedPrice) từ TicketDetails.
     */
    public void updateImportPriceFromTicket(int ticketId) {
        String sql = "UPDATE pv SET pv.import_price = td.expected_price " +
                     "FROM ProductVariant pv " +
                     "JOIN TicketDetails td ON pv.variant_id = td.variant_id " +
                     "WHERE td.ticket_id = ? AND td.expected_price IS NOT NULL AND td.expected_price > 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

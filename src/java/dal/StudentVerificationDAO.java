package dal;

import java.sql.*;
import java.util.ArrayList;
import model.StudentVerification;

public class StudentVerificationDAO extends DBContext {

    public StudentVerification getByUserId(int userId) {
        String sql = "SELECT * FROM StudentVerification WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new StudentVerification(
                        rs.getInt("verification_id"),
                        rs.getInt("user_id"),
                        rs.getString("student_card_image"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("staff_note")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error in getByUserId: " + e);
        }
        return null;
    }

    public boolean createRequest(int userId, String studentCardImage) {
        StudentVerification existing = getByUserId(userId);
        if (existing != null) {
            String sql = "UPDATE StudentVerification SET student_card_image = ?, status = 'pending', staff_note = NULL, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            try {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setString(1, studentCardImage);
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Error in createRequest (update): " + e);
            }
        } else {
            String sql = "INSERT INTO StudentVerification (user_id, student_card_image, status, created_at, updated_at) VALUES (?, ?, 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
            try {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, studentCardImage);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Error in createRequest (insert): " + e);
            }
        }
        return false;
    }

    public ArrayList<StudentVerification> getPendingRequests() {
        ArrayList<StudentVerification> list = new ArrayList<>();
        String sql = "SELECT sv.*, u.full_name, u.email, u.phone FROM StudentVerification sv " +
                     "JOIN [User] u ON sv.user_id = u.user_id " +
                     "WHERE sv.status = 'pending' " +
                     "ORDER BY sv.created_at ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentVerification sv = new StudentVerification(
                        rs.getInt("verification_id"),
                        rs.getInt("user_id"),
                        rs.getString("student_card_image"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("staff_note")
                );
                sv.setUserName(rs.getString("full_name"));
                sv.setUserEmail(rs.getString("email"));
                sv.setUserPhone(rs.getString("phone"));
                list.add(sv);
            }
        } catch (SQLException e) {
            System.out.println("Error in getPendingRequests: " + e);
        }
        return list;
    }

    public ArrayList<StudentVerification> getAllRequests() {
        ArrayList<StudentVerification> list = new ArrayList<>();
        String sql = "SELECT sv.*, u.full_name, u.email, u.phone FROM StudentVerification sv " +
                     "JOIN [User] u ON sv.user_id = u.user_id " +
                     "ORDER BY CASE WHEN sv.status = 'pending' THEN 0 ELSE 1 END, sv.updated_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentVerification sv = new StudentVerification(
                        rs.getInt("verification_id"),
                        rs.getInt("user_id"),
                        rs.getString("student_card_image"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("staff_note")
                );
                sv.setUserName(rs.getString("full_name"));
                sv.setUserEmail(rs.getString("email"));
                sv.setUserPhone(rs.getString("phone"));
                list.add(sv);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllRequests: " + e);
        }
        return list;
    }

    public boolean updateStatus(int verificationId, String status, String staffNote) {
        String sql = "UPDATE StudentVerification SET status = ?, staff_note = ?, updated_at = CURRENT_TIMESTAMP WHERE verification_id = ?";
        try {
            connection.setAutoCommit(false);
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, staffNote);
            ps.setInt(3, verificationId);
            int updated = ps.executeUpdate();
            
            if (updated > 0 && "approved".equalsIgnoreCase(status)) {
                // Get user_id for this verification
                String getUserIdSql = "SELECT user_id FROM StudentVerification WHERE verification_id = ?";
                int userId = -1;
                try (PreparedStatement ps2 = connection.prepareStatement(getUserIdSql)) {
                    ps2.setInt(1, verificationId);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        if (rs2.next()) {
                            userId = rs2.getInt("user_id");
                        }
                    }
                }
                
                if (userId != -1) {
                    // Update user's role to 4 (student)
                    String updateUserSql = "UPDATE [User] SET role_id = 4, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
                    try (PreparedStatement ps3 = connection.prepareStatement(updateUserSql)) {
                        ps3.setInt(1, userId);
                        ps3.executeUpdate();
                    }
                }
            }
            
            connection.commit();
            connection.setAutoCommit(true);
            return updated > 0;
        } catch (SQLException e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Error in updateStatus: " + e);
        }
        return false;
    }
}

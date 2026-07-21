package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class AccountActivationTokenDAO extends DBContext {

    public boolean createToken(int userId, String token, Timestamp expiresAt) {
        String sql = "INSERT INTO AccountActivationToken (user_id, token, is_used, expires_at) VALUES (?, ?, 0, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiresAt);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating account activation token: " + e.getMessage());
        }
        return false;
    }

    public Integer getUserIdByValidToken(String token) {
        String sql = "SELECT user_id FROM AccountActivationToken WHERE token = ? AND is_used = 0 AND expires_at > CURRENT_TIMESTAMP";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            System.err.println("Error validating account activation token: " + e.getMessage());
        }
        return null;
    }

    public boolean markTokenAsUsed(String token) {
        String sql = "UPDATE AccountActivationToken SET is_used = 1 WHERE token = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marking activation token as used: " + e.getMessage());
        }
        return false;
    }
}

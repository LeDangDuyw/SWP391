package dal;

import dal.DBContext;
import utils.hashPasswordUtil;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/*
 * Name: PasswordResetTokenDAO
 * @Author: LUCTV
 * Date: [21/06/2026]
 * Version: 1.0
 * Description: Data Access Object for handling password reset tokens and resetting user password.
 */
public class PasswordResetTokenDAO extends DBContext {

    /*
     * Name: createToken
     * Description: Inserts a new password reset token record.
     */
    public boolean createToken(int userId, String token, Timestamp expiresAt) {
        String sql = "INSERT INTO PasswordResetToken (user_id, token, is_used, expires_at) VALUES (?, ?, 0, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiresAt);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating password reset token: " + e.getMessage());
        }
        return false;
    }

    /*
     * Name: getUserIdByValidToken
     * Description: Checks if a token is valid (not used and not expired).
     * Returns the associated user_id if valid, otherwise null.
     */
    public Integer getUserIdByValidToken(String token) {
        String sql = "SELECT user_id FROM PasswordResetToken WHERE token = ? AND is_used = 0 AND expires_at > CURRENT_TIMESTAMP";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            System.err.println("Error validating password reset token: " + e.getMessage());
        }
        return null;
    }

    /*
     * Name: markTokenAsUsed
     * Description: Marks a token as used so it cannot be reused.
     */
    public boolean markTokenAsUsed(String token) {
        String sql = "UPDATE PasswordResetToken SET is_used = 1 WHERE token = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marking token as used: " + e.getMessage());
        }
        return false;
    }

    /*
     * Name: updatePassword
     * Description: Hashes the new password and updates it in the User table.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE [User] SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try {
            String hashedPassword = hashPasswordUtil.hashPassword(newPassword);
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user password: " + e.getMessage());
        }
        return false;
    }
}

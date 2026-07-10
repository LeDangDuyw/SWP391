package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ChatbotFeedbackDTO;
import model.ChatbotSecurityLogDTO;

public class ChatbotDAO extends DBContext {
    private Connection cnn;

    public ChatbotDAO() {
        this.cnn = super.connection;
    }

    // 1. Kiểm tra xem người dùng có bị chặn sử dụng chatbot hay không
    public boolean isChatbotBlocked(int userId) {
        String sql = "SELECT 1 FROM [ChatbotBlockedUsers] WHERE [user_id] = ?";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Chặn người dùng sử dụng chatbot
    public boolean blockUser(int userId, String reason) {
        // Sử dụng MERGE hoặc kiểm tra sự tồn tại để tránh insert trùng lặp
        if (isChatbotBlocked(userId)) {
            return true;
        }
        String sql = "INSERT INTO [ChatbotBlockedUsers] ([user_id], [reason]) VALUES (?, ?)";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, reason);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Mở chặn người dùng sử dụng chatbot
    public boolean unblockUser(int userId) {
        String sql = "DELETE FROM [ChatbotBlockedUsers] WHERE [user_id] = ?";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Lưu đánh giá (Feedback) chất lượng chatbot
    public boolean insertFeedback(int userId, String sessionId, int rating, String comment, String question, String answer) {
        String sql = "INSERT INTO [ChatbotFeedback] ([user_id], [session_id], [rating], [comment], [ai_question], [ai_answer]) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setString(5, question);
            ps.setString(6, answer);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Lưu nhật ký vi phạm an toàn thông tin
    public boolean insertSecurityLog(int userId, String sessionId, String violationType, String violatedMessage) {
        String sql = "INSERT INTO [ChatbotSecurityLog] ([user_id], [session_id], [violation_type], [violated_message]) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = cnn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            ps.setString(3, violationType);
            ps.setString(4, violatedMessage);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Lấy toàn bộ danh sách feedback kèm thông tin user (Dành cho Admin)
    public List<ChatbotFeedbackDTO> getAllFeedbacks() {
        List<ChatbotFeedbackDTO> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.user_id, u.full_name, u.email, f.session_id, f.rating, f.comment, f.ai_question, f.ai_answer, f.created_at " +
                     "FROM [ChatbotFeedback] f " +
                     "LEFT JOIN [User] u ON f.user_id = u.user_id " +
                     "ORDER BY f.created_at DESC";
        try (PreparedStatement ps = cnn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ChatbotFeedbackDTO dto = new ChatbotFeedbackDTO();
                dto.setFeedbackId(rs.getInt("feedback_id"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setUserName(rs.getString("full_name"));
                dto.setUserEmail(rs.getString("email"));
                dto.setSessionId(rs.getString("session_id"));
                dto.setRating(rs.getInt("rating"));
                dto.setComment(rs.getString("comment"));
                dto.setAiQuestion(rs.getString("ai_question"));
                dto.setAiAnswer(rs.getString("ai_answer"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Lấy toàn bộ danh sách nhật ký vi phạm an toàn thông tin (Dành cho Admin)
    public List<ChatbotSecurityLogDTO> getAllSecurityLogs() {
        List<ChatbotSecurityLogDTO> list = new ArrayList<>();
        String sql = "SELECT l.log_id, l.user_id, u.full_name, u.email, l.session_id, l.violation_type, l.violated_message, l.created_at, l.status, " +
                     "CASE WHEN b.user_id IS NOT NULL THEN 1 ELSE 0 END as is_blocked " +
                     "FROM [ChatbotSecurityLog] l " +
                     "LEFT JOIN [User] u ON l.user_id = u.user_id " +
                     "LEFT JOIN [ChatbotBlockedUsers] b ON l.user_id = b.user_id " +
                     "ORDER BY l.created_at DESC";
        try (PreparedStatement ps = cnn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ChatbotSecurityLogDTO dto = new ChatbotSecurityLogDTO();
                dto.setLogId(rs.getInt("log_id"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setUserName(rs.getString("full_name"));
                dto.setUserEmail(rs.getString("email"));
                dto.setSessionId(rs.getString("session_id"));
                dto.setViolationType(rs.getString("violation_type"));
                dto.setViolatedMessage(rs.getString("violated_message"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setStatus(rs.getString("status"));
                dto.setUserBlocked(rs.getInt("is_blocked") == 1);
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

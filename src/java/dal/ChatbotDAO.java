package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ChatbotFeedbackDTO;
import model.ChatbotSecurityLogDTO;

/**
 * Lớp ChatbotDAO - Truy vấn và thao tác cơ sở dữ liệu liên quan đến AI Chatbot.
 * 
 * BẢNG DỮ LIỆU LIÊN QUAN:
 * - [ChatbotBlockedUsers]: Quản lý danh sách người dùng bị khóa Chatbot.
 * - [ChatbotSecurityLog]: Nhật ký ghi nhận các hành vi vi phạm an ninh (Spam, Prompt Injection...).
 * - [ChatbotFeedback]: Lưu đánh giá phản hồi chất lượng câu trả lời của AI từ người dùng.
 * - [User]: Liên kết thông tin tài khoản người dùng.
 * 
 * LIÊN KẾT:
 * - Controller: controller.ChatServlet (/chat-ai), controller.ChatbotManagementServlet (/admin/chatbot).
 */
public class ChatbotDAO extends DBContext {
    private Connection cnn;

    public ChatbotDAO() {
        this.cnn = super.connection;
    }

    /**
     * CHỨC NĂNG: Kiểm tra xem người dùng có đang nằm trong danh sách bị khóa Chatbot hay không.
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotBlockedUsers]
     * - Controller: ChatServlet.doPost() (Dùng để chặn không cho gửi tin nhắn nếu đã bị khóa)
     * 
     * @param userId ID người dùng cần kiểm tra
     * @return true nếu bị khóa, false nếu hoạt động bình thường
     */
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

    /**
     * CHỨC NĂNG: Thêm người dùng vào danh sách bị khóa Chatbot kèm lý do.
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotBlockedUsers]
     * - Controller: ChatServlet (Tự động khóa khi phát hiện Spam > 10 tin nhắn/phút) hoặc Admin ChatbotManagementServlet.
     * 
     * @param userId ID người dùng bị khóa
     * @param reason Lý do khóa tài khoản
     * @return true nếu ghi vào DB thành công
     */
    public boolean blockUser(int userId, String reason) {
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

    /**
     * CHỨC NĂNG: Xóa người dùng khỏi danh sách bị khóa (Gỡ lệnh cấm Chatbot).
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotBlockedUsers]
     * - Controller: Admin ChatbotManagementServlet (Mở lại quyền cho người dùng)
     * 
     * @param userId ID người dùng cần bỏ khóa
     * @return true nếu gỡ thành công
     */
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

    /**
     * CHỨC NĂNG: Lưu phản hồi/đánh giá của khách hàng về câu trả lời của Chatbot AI (Số sao, bình luận).
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotFeedback]
     * - Frontend: web/js/chat.js (Gửi AJAX lưu feedback khi bấm icon Thumbs Up/Down hoặc đánh giá sao)
     * 
     * @param userId ID người đánh giá
     * @param sessionId Mã phiên làm việc chat
     * @param rating Số sao (1 đến 5)
     * @param comment Lời nhận xét
     * @param question Câu hỏi khách đã hỏi
     * @param answer Câu trả lời AI đã đáp
     * @return true nếu lưu thành công
     */
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

    /**
     * CHỨC NĂNG: Ghi nhật ký các hành vi vi phạm bảo mật an toàn thông tin (Spam, Prompt Injection, nội dung độc hại).
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotSecurityLog]
     * - Controller: ChatServlet.doPost() (Tự động lưu khi vi phạm phát sinh)
     * 
     * @param userId ID người dùng vi phạm
     * @param sessionId Mã phiên chat
     * @param violationType Loại vi phạm (SPAM, PROMPT_INJECTION...)
     * @param violatedMessage Nội dung tin nhắn vi phạm
     * @return true nếu lưu log thành công
     */
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

    /**
     * CHỨC NĂNG: Lấy danh sách toàn bộ phản hồi Feedback về Chatbot dành cho Admin kiểm tra chất lượng.
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotFeedback], [User]
     * - Controller: Admin ChatbotManagementServlet
     * - View JSP: web/admin/ChatbotManagement.jsp
     * 
     * @return Danh sách ChatbotFeedbackDTO
     */
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

    /**
     * CHỨC NĂNG: Lấy danh sách toàn bộ Nhật ký vi phạm an ninh Chatbot dành cho Admin theo dõi bảo mật.
     * LIÊN KẾT:
     * - Bảng DB: [ChatbotSecurityLog], [User], [ChatbotBlockedUsers]
     * - Controller: Admin ChatbotManagementServlet
     * - View JSP: web/admin/ChatbotManagement.jsp
     * 
     * @return Danh sách ChatbotSecurityLogDTO
     */
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

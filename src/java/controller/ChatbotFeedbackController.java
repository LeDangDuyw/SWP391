package controller;

import java.io.BufferedReader;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.ChatbotDAO;
import model.Users;

@WebServlet("/chatbot-feedback")
public class ChatbotFeedbackController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Bạn cần phải đăng nhập để gửi đánh giá!\"}");
            return;
        }

        // 2. Đọc request body JSON
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString().trim();

        if (requestBody.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Dữ liệu đánh giá trống!\"}");
            return;
        }

        // 3. Trích xuất thủ công các tham số từ JSON (tránh phụ thuộc thư viện ngoài)
        int rating = extractInt(requestBody, "rating", 5);
        String comment = extractString(requestBody, "comment");
        String aiQuestion = extractString(requestBody, "ai_question");
        String aiAnswer = extractString(requestBody, "ai_answer");
        String sessionId = extractString(requestBody, "session_id");

        if (sessionId == null || sessionId.isEmpty()) {
            sessionId = "unknown_session";
        }

        // 4. Lưu vào Database qua DAO
        ChatbotDAO dao = new ChatbotDAO();
        boolean success = dao.insertFeedback(user.getUserId(), sessionId, rating, comment, aiQuestion, aiAnswer);

        if (success) {
            response.getWriter().write("{\"status\": \"success\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Không thể lưu đánh giá vào cơ sở dữ liệu!\"}");
        }
    }

    private int extractInt(String json, String key, int defaultValue) {
        int keyIndex = json.indexOf("\"" + key + "\"");
        if (keyIndex != -1) {
            String sub = json.substring(keyIndex);
            int colonIndex = sub.indexOf(":");
            if (colonIndex != -1) {
                StringBuilder num = new StringBuilder();
                for (int i = colonIndex + 1; i < sub.length(); i++) {
                    char c = sub.charAt(i);
                    if (Character.isDigit(c)) {
                        num.append(c);
                    } else if (num.length() > 0) {
                        break;
                    }
                }
                if (num.length() > 0) {
                    try {
                        return Integer.parseInt(num.toString());
                    } catch (NumberFormatException e) {
                        return defaultValue;
                    }
                }
            }
        }
        return defaultValue;
    }

    private String extractString(String json, String key) {
        int keyIndex = json.indexOf("\"" + key + "\"");
        if (keyIndex != -1) {
            String sub = json.substring(keyIndex);
            int colonIndex = sub.indexOf(":");
            if (colonIndex != -1) {
                int startQuote = sub.indexOf("\"", colonIndex);
                if (startQuote != -1) {
                    int endQuote = sub.indexOf("\"", startQuote + 1);
                    if (endQuote != -1) {
                        String value = sub.substring(startQuote + 1, endQuote);
                        // Giải mã unicode đơn giản nếu có dạng \\uXXXX (nếu cần thiết)
                        return decodeUnicode(value);
                    }
                }
            }
        }
        return "";
    }

    private String decodeUnicode(String str) {
        // Hỗ trợ giải mã các ký tự tiếng Việt Unicode escaped dạng \\uXXXX
        StringBuilder sb = new StringBuilder();
        int i = 0;
        while (i < str.length()) {
            char c = str.charAt(i);
            if (c == '\\' && i + 1 < str.length() && str.charAt(i + 1) == 'u') {
                if (i + 5 < str.length()) {
                    String hex = str.substring(i + 2, i + 6);
                    try {
                        char u = (char) Integer.parseInt(hex, 16);
                        sb.append(u);
                        i += 6;
                        continue;
                    } catch (NumberFormatException e) {
                        // Bỏ qua nếu lỗi format
                    }
                }
            }
            sb.append(c);
            i++;
        }
        return sb.toString();
    }
}

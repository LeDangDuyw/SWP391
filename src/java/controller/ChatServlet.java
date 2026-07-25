package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.ChatbotDAO;
import model.Users;

/**
 * Controller ChatServlet (/chat-ai)
 * 
 * CHỨC NĂNG:
 * - Tiếp nhận tin nhắn trò chuyện AI từ giao diện khách hàng (web/js/chat.js).
 * - Xử lý kiểm tra quyền sử dụng, kiểm tra trạng thái bị chặn (Block) của người dùng.
 * - Kiểm tra chống Spam (Giới hạn tối đa 10 tin nhắn/phút).
 * - Chuyển tiếp (Proxy) dữ liệu tin nhắn tới máy chủ FastAPI AI (http://127.0.0.1:8000/chat).
 * - Kiểm tra phản hồi vi phạm an ninh (Prompt Injection, Harmful Content) từ FastAPI để ghi Log bảo mật.
 * 
 * LIÊN KẾT:
 * - Frontend: web/js/chat.js (Gửi AJAX request POST /chat-ai).
 * - DAO Layer: dal.ChatbotDAO (Gọi các hàm isChatbotBlocked, blockUser, insertSecurityLog).
 * - External Service: FastAPI Server Python RAG (http://127.0.0.1:8000/chat).
 * - Data Model: model.Users (Lấy thông tin userId từ Session).
 */
@WebServlet("/chat-ai")
public class ChatServlet extends HttpServlet {

    private static final String FASTAPI_URL = "http://127.0.0.1:8000/chat";

    /**
     * Phương thức doPost: Tiếp nhận tin nhắn chat từ client, xử lý bảo mật và chuyển tới FastAPI AI Server.
     * 
     * CHỨC NĂNG:
     * 1. Đọc Session lấy đối tượng Users đăng nhập.
     * 2. Gọi ChatbotDAO.isChatbotBlocked(userId) kiểm tra xem user có bị khóa Chatbot hay không.
     * 3. Đọc dữ liệu JSON từ body request (tin nhắn user, session_id).
     * 4. Kiểm tra tần suất gửi tin nhắn (Spam Control): Nếu gửi > 10 tin nhắn/phút -> Tự động gọi ChatbotDAO.blockUser() và ChatbotDAO.insertSecurityLog().
     * 5. Khởi tạo HttpURLConnection gửi dữ liệu JSON tới FastAPI Server (http://127.0.0.1:8000/chat).
     * 6. Nhận kết quả từ FastAPI, kiểm tra cờ is_violation -> Nếu có vi phạm gọi ChatbotDAO.insertSecurityLog().
     * 7. Trả kết quả JSON phản hồi về cho client (web/js/chat.js).
     * 
     * LIÊN KẾT:
     * - Web Endpoint: POST /chat-ai
     * - DAO methods: ChatbotDAO.isChatbotBlocked(), ChatbotDAO.blockUser(), ChatbotDAO.insertSecurityLog()
     * - Frontend: JS function sendChatMessage() trong web/js/chat.js
     * - Target Server: FastAPI /chat endpoint
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra xác thực người dùng đã đăng nhập chưa
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Bạn cần phải đăng nhập để trò chuyện với AI!\"}");
            return;
        }

        // 2. Kiểm tra xem người dùng có bị chặn sử dụng chatbot hay không
        ChatbotDAO chatbotDAO = new ChatbotDAO();
        if (chatbotDAO.isChatbotBlocked(user.getUserId())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Tài khoản của bạn đã bị chặn sử dụng tính năng chatbot do vi phạm điều khoản.\"}");
            return;
        }

        // 3. Read request body (JSON) from client
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString().trim();

        // If request body is empty, return bad request status
        if (requestBody == null || requestBody.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Yêu cầu không được để trống\"}");
            return;
        }

        // Trích xuất thông tin message và session_id từ requestBody của client để ghi log nếu cần
        String userMessage = "";
        int msgIndex = requestBody.indexOf("\"message\"");
        if (msgIndex != -1) {
            String sub = requestBody.substring(msgIndex);
            int colonIndex = sub.indexOf(":");
            if (colonIndex != -1) {
                int startQuote = sub.indexOf("\"", colonIndex);
                if (startQuote != -1) {
                    int endQuote = sub.indexOf("\"", startQuote + 1);
                    if (endQuote != -1) {
                        userMessage = sub.substring(startQuote + 1, endQuote);
                    }
                }
            }
        }
        
        String userSessionId = "default_session";
        int sessIndex = requestBody.indexOf("\"session_id\"");
        if (sessIndex != -1) {
            String sub = requestBody.substring(sessIndex);
            int colonIndex = sub.indexOf(":");
            if (colonIndex != -1) {
                int startQuote = sub.indexOf("\"", colonIndex);
                if (startQuote != -1) {
                    int endQuote = sub.indexOf("\"", startQuote + 1);
                    if (endQuote != -1) {
                        userSessionId = sub.substring(startQuote + 1, endQuote);
                    }
                }
            }
        }

        // Chèn thêm user_id vào JSON request chuyển tiếp sang FastAPI
        if (requestBody.endsWith("}")) {
            requestBody = requestBody.substring(0, requestBody.length() - 1) + ", \"user_id\": " + user.getUserId() + "}";
        }

        // === KIỂM TRA SPAM (GIỚI HẠN 10 TIN NHẮN / PHÚT) ===
        long now = System.currentTimeMillis();
        java.util.List<Long> msgTimes = (java.util.List<Long>) session.getAttribute("chat_message_times");
        if (msgTimes == null) {
            msgTimes = new java.util.ArrayList<>();
        }
        // Loại bỏ các mốc thời gian cũ hơn 1 phút (60,000ms)
        msgTimes.removeIf(time -> time < now - 60000);

        if (msgTimes.size() >= 10) {
            // Khóa tài khoản người dùng sử dụng chatbot trong database
            chatbotDAO.blockUser(user.getUserId(), "Hệ thống tự động khóa do spam chatbot liên tục (Quá 10 tin nhắn/phút).");
            
            // Ghi nhật ký vi phạm bảo mật loại SPAM vào database
            chatbotDAO.insertSecurityLog(user.getUserId(), userSessionId, "SPAM", userMessage);
            
            // Trả về lỗi 403 Forbidden chặn quyền truy cập
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Tài khoản của bạn đã bị chặn sử dụng tính năng chatbot do vi phạm điều khoản.\"}");
            return;
        }
        
        // Lưu mốc thời gian nhắn tin mới vào session
        msgTimes.add(now);
        session.setAttribute("chat_message_times", msgTimes);
        // ==================================================

        try {
            // 4. Connect and send request to FastAPI Server
            URL url = java.net.URI.create(FASTAPI_URL).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);  // 5 seconds connection timeout
            conn.setReadTimeout(45000);     // 45 seconds read timeout (AI generation might be slow)

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int statusCode = conn.getResponseCode();
            if (statusCode == HttpURLConnection.HTTP_OK) {
                // 5. Read response from FastAPI
                StringBuilder result = new StringBuilder();
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    while ((line = br.readLine()) != null) {
                        result.append(line.trim());
                    }
                }
                
                String responseStr = result.toString();
                
                // 6. Kiểm tra xem phản hồi từ FastAPI có đánh dấu vi phạm an ninh hay không
                boolean isViolation = responseStr.contains("\"is_violation\":true") || responseStr.contains("\"is_violation\": true");
                if (isViolation) {
                    String violationType = "UNKNOWN";
                    int typeIndex = responseStr.indexOf("\"violation_type\"");
                    if (typeIndex != -1) {
                        String sub = responseStr.substring(typeIndex);
                        int colonIndex = sub.indexOf(":");
                        if (colonIndex != -1) {
                            int startQuote = sub.indexOf("\"", colonIndex);
                            if (startQuote != -1) {
                                int endQuote = sub.indexOf("\"", startQuote + 1);
                                if (endQuote != -1) {
                                    violationType = sub.substring(startQuote + 1, endQuote);
                                }
                            }
                        }
                    }
                    // Lưu log vi phạm bảo mật vào DB
                    chatbotDAO.insertSecurityLog(user.getUserId(), userSessionId, violationType, userMessage);
                }

                // 7. Return success response to the client
                response.getWriter().write(responseStr);
            } else {
                // Return server error code and original message if FastAPI fails
                response.setStatus(statusCode);
                response.getWriter().write("{\"error\": \"Máy chủ AI trả về mã lỗi: " + statusCode + "\"}");
            }

        } catch (IOException e) {
            // FastAPI server is likely offline or network failure occurred
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Không thể kết nối tới máy chủ AI (Offline). Chi tiết: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Phương thức doGet: Từ chối các yêu cầu GET vì API Chat AI yêu cầu body dữ liệu tin nhắn dạng POST.
     * 
     * CHỨC NĂNG: Trả về mã lỗi 405 Method Not Allowed.
     * LIÊN KẾT: HTTP GET /chat-ai
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"error\": \"Chỉ hỗ trợ phương thức POST\"}");
    }
}

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Servlet Proxy chuyển tiếp tin nhắn từ client JSP tới FastAPI Chatbot (http://localhost:8000/chat)
 * giúp tránh lỗi CORS ở trình duyệt và nâng cao tính bảo mật.
 * 
 * @author Antigravity AI
 * @version 1.0
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/chat-ai"})
public class ChatServlet extends HttpServlet {

    private static final String FASTAPI_URL = "http://localhost:8000/chat";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // Lấy tin nhắn gửi đi từ request parameter
        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()  ) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("tin nhan khong duoc de trong");
        }

        // Lấy Session ID từ HTTP Session hiện tại
        String sessionId = request.getSession().getId();

        // Xây dựng JSON payload thủ công an toàn bằng cách escape các ký tự JSON đặc biệt
        String escapedMessage = message.replace("\\", "\\\\")
                                       .replace("\"", "\\\"")
                                       .replace("\n", "\\n")
                                       .replace("\r", "\\r")
                                       .replace("\t", "\\t");

        String finalPayload = "{"
                + "\"message\": \"" + escapedMessage + "\","
                + "\"session_id\": \"" + sessionId + "\","
                + "\"sessionId\": \"" + sessionId + "\""
                + "}";

        System.out.println("ChatServlet forwarding payload: " + finalPayload);

        HttpURLConnection conn = null;
        try {
            // Thiết lập kết nối tới server FastAPI AI
            URL url = new URL(FASTAPI_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000); // Timeout kết nối 5 giây
            conn.setReadTimeout(20000);    // Timeout đọc phản hồi 20 giây

            // Ghi nội dung body JSON gửi tới FastAPI
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = finalPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            
            // Lựa chọn luồng đọc dữ liệu tùy thuộc vào trạng thái phản hồi
            InputStream is;
            if (responseCode >= 200 && responseCode < 300) {
                is = conn.getInputStream();
            } else {
                is = conn.getErrorStream();
            }

            StringBuilder resBuilder = new StringBuilder();
            if (is != null) {
                try (BufferedReader reader = new BufferedReader(new java.io.InputStreamReader(is, StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        resBuilder.append(line);
                    }
                }
            }
            
            // Trả lại nguyên văn kết quả và mã trạng thái HTTP từ FastAPI về JSP client
            response.setStatus(responseCode);
            response.getWriter().write(resBuilder.toString());

        } catch (Exception e) {
            System.err.println("ChatServlet error forwarding to FastAPI: " + e.getMessage());
            // Trả về một phản hồi JSON lỗi thân thiện để giao diện không bị đơ
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": true, \"answer\": \"Xin lỗi, hệ thống không thể kết nối tới Chatbot AI. Vui lòng đảm bảo dịch vụ AI (http://localhost:8000/chat) đang hoạt động!\"}");
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}

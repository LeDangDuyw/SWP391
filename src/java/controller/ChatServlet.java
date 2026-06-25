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

@WebServlet("/chat-ai")
public class ChatServlet extends HttpServlet {

    private static final String FASTAPI_URL = "http://localhost:8000/chat";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. Read request body (JSON) from client
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString();

        // If request body is empty, return bad request status
        if (requestBody == null || requestBody.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Yêu cầu không được để trống\"}");
            return;
        }

        try {
            // 2. Connect and send request to FastAPI Server
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
                // 3. Read response from FastAPI
                StringBuilder result = new StringBuilder();
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    while ((line = br.readLine()) != null) {
                        result.append(line.trim());
                    }
                }
                // 4. Return success response to the client
                response.getWriter().write(result.toString());
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"error\": \"Chỉ hỗ trợ phương thức POST\"}");
    }
}

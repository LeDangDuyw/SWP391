package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.EmailUtils;

@WebServlet(name = "SubmitContactServlet", urlPatterns = {"/contact/submit"})
public class SubmitContactServlet extends HttpServlet {

    // Store support email target
    private static final String STORE_SUPPORT_EMAIL = "unilapsupport@gmail.com";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String messageStr = request.getParameter("message");

        PrintWriter out = response.getWriter();

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || messageStr == null || messageStr.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ Họ tên, Email và Nội dung cần hỗ trợ!\"}");
            return;
        }

        fullName = fullName.trim();
        email = email.trim();
        messageStr = messageStr.trim();

        // Build HTML Body for Email Notification to Store Admin
        StringBuilder htmlBody = new StringBuilder();
        htmlBody.append("<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px;'>");
        htmlBody.append("<h2 style='color: #2563eb; margin-top: 0;'>📬 Yêu Cầu Liên Hệ Mới Từ Footer Website UniLap</h2>");
        htmlBody.append("<p><strong>Họ và tên:</strong> ").append(escapeHtml(fullName)).append("</p>");
        htmlBody.append("<p><strong>Email khách hàng:</strong> <a href='mailto:").append(escapeHtml(email)).append("'>").append(escapeHtml(email)).append("</a></p>");
        htmlBody.append("<p><strong>Nội dung yêu cầu / góp ý:</strong></p>");
        htmlBody.append("<div style='background: #f8fafc; padding: 15px; border-left: 4px solid #2563eb; border-radius: 4px; font-size: 14px;'>");
        htmlBody.append(escapeHtml(messageStr).replace("\n", "<br>"));
        htmlBody.append("</div>");
        htmlBody.append("<hr style='margin-top: 20px; border: none; border-top: 1px solid #e2e8f0;'>");
        htmlBody.append("<p style='font-size: 12px; color: #64748b;'>Email này được gửi tự động từ hệ thống Footer Contact Form của UniLap.</p>");
        htmlBody.append("</div>");

        String subject = "[UniLap Contact] Yêu cầu hỗ trợ từ khách hàng: " + fullName;

        try {
            // Send email to Store Support / Admin using EmailUtils
            boolean sent = EmailUtils.sendEmail(STORE_SUPPORT_EMAIL, subject, htmlBody.toString());
            if (sent) {
                out.print("{\"success\": true, \"message\": \"Cảm ơn bạn! Yêu cầu hỗ trợ đã được gửi tới UniLap thành công. Chúng tôi sẽ phản hồi qua Email sớm nhất.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể gửi yêu cầu lúc này. Vui lòng thử lại sau!\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra trong quá trình gửi yêu cầu.\"}");
        }
    }

    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#039;");
    }
}

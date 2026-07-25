package controller;

import dal.UserDAO;
import dal.PasswordResetTokenDAO;
import model.Users;
import utils.EmailUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

/*
 * Name: ForgotPasswordController
 * @Author: LUCTV
 * Date: [21/06/2026]
 * Version: 1.0
 * Description: Servlet for requesting a password reset. Checks email presence, 
 * generates a secure token, registers it in database, and triggers email notification.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Basic email regex validation
        String emailRegex = "^[\\w.+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$";
        if (!email.matches(emailRegex)) {
            request.setAttribute("error", "Định dạng email không hợp lệ!");
            request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        Users user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate token and expiration time (15 minutes from now)
        String token = UUID.randomUUID().toString();
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000);

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        boolean isCreated = tokenDAO.createToken(user.getUserId(), token, expiresAt);

        if (!isCreated) {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi tạo token. Vui lòng thử lại!");
            request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Construct reset link based on request URL
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        String baseURL = scheme + "://" + serverName + ":" + serverPort + contextPath + "/";
        String resetLink = baseURL + "reset-password?token=" + token;

        // Build HTML mail body
        String subject = "Khôi phục mật khẩu - UniLap";
        String htmlBody = "<h2>Khôi phục mật khẩu tài khoản UniLap</h2>"
                + "<p>Chào " + user.getUserName() + ",</p>"
                + "<p>Chúng tôi nhận được yêu cầu khôi phục mật khẩu của bạn. Vui lòng nhấn vào đường liên kết dưới đây để thực hiện thay đổi mật khẩu (đường dẫn có hiệu lực trong vòng 15 phút):</p>"
                + "<p><a href=\"" + resetLink + "\" style=\"display:inline-block; background:#1565c0; color:#fff; padding:10px 20px; text-decoration:none; border-radius:4px;\">Đặt lại mật khẩu</a></p>"
                + "<p>Nếu link trên không hoạt động, bạn có thể copy và dán liên kết này vào trình duyệt:</p>"
                + "<p>" + resetLink + "</p>"
                + "<br/>"
                + "<p>Trân trọng,<br/>Đội ngũ hỗ trợ UniLap</p>";

        // Attempt sending email
        boolean emailSent = EmailUtils.sendEmail(email, subject, htmlBody);

        if (emailSent) {
            request.setAttribute("emailSent", true);
            request.setAttribute("success", "Yêu cầu khôi phục đã được gửi! Vui lòng kiểm tra hộp thư email.");
        } else {
            request.setAttribute("error", "Gửi email thất bại. Vui lòng kiểm tra lại kết nối mạng hoặc thử lại sau!");
        }

        request.getRequestDispatcher("auth/forgot-password.jsp").forward(request, response);
    }
}

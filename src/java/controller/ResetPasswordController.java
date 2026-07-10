package controller;

import dal.PasswordResetTokenDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/*
 * Name: ResetPasswordController
 * @Author: LUCTVHE201874
 * Date: [21/06/2026]
 * Version: 1.0
 * Description: Servlet for resetting password. Validates recovery token, 
 * renders the reset credentials form, and performs password hash modification.
 */
@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Mã xác thực khôi phục mật khẩu không được để trống!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        token = token.trim();

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        Integer userId = tokenDAO.getUserIdByValidToken(token);

        if (userId == null) {
            request.setAttribute("error", "Liên kết khôi phục mật khẩu không hợp lệ hoặc đã hết hạn!");
        } else {
            request.setAttribute("token", token);
        }

        request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Mã xác thực không hợp lệ!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        token = token.trim();

        if (password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu mới!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        password = password.trim();
        confirmPassword = confirmPassword.trim();

        if (password.length() < 6) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất 6 ký tự!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        Integer userId = tokenDAO.getUserIdByValidToken(token);

        if (userId == null) {
            request.setAttribute("error", "Liên kết khôi phục mật khẩu không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
            return;
        }

        // Update user password and mark token as used in a transaction-like sequence
        boolean passwordUpdated = tokenDAO.updatePassword(userId, password);
        if (passwordUpdated) {
            tokenDAO.markTokenAsUsed(token);
            response.sendRedirect("login?success=2");
        } else {
            request.setAttribute("token", token);
            request.setAttribute("error", "Đặt lại mật khẩu thất bại do lỗi cơ sở dữ liệu. Vui lòng thử lại!");
            request.getRequestDispatcher("auth/reset-password.jsp").forward(request, response);
        }
    }
}

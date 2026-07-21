package controller;

import dal.AccountActivationTokenDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/activate")
public class ActivateAccountController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Mã kích hoạt không hợp lệ!", "UTF-8"));
            return;
        }
        
        token = token.trim();
        
        AccountActivationTokenDAO tokenDAO = new AccountActivationTokenDAO();
        Integer userId = tokenDAO.getUserIdByValidToken(token);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Liên kết kích hoạt không hợp lệ hoặc đã hết hạn!", "UTF-8"));
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        boolean activated = userDAO.activateUser(userId);
        
        if (activated) {
            tokenDAO.markTokenAsUsed(token);
            response.sendRedirect(request.getContextPath() + "/login?success=4");
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Lỗi hệ thống khi kích hoạt tài khoản. Vui lòng thử lại!", "UTF-8"));
        }
    }
}

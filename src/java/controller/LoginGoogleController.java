package controller;

import dal.UserDAO;
import model.Users;
import utils.GoogleUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {

    /*
     * Name: doGet
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này xử lý luồng Callback từ Google Đăng nhập: lấy mã code, 
     * trao đổi token, lấy thông tin cá nhân và tiến hành đăng nhập hoặc đăng ký tài khoản mới.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Đăng nhập Google thất bại!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Exchange code for Google Access Token
            String jsonToken = GoogleUtils.getToken(code);
            String accessToken = GoogleUtils.getJsonField(jsonToken, "access_token");

            // 2. Fetch User Profile from Google
            String jsonUserInfo = GoogleUtils.getUserInfo(accessToken);
            String email = GoogleUtils.getJsonField(jsonUserInfo, "email");
            String name = GoogleUtils.getJsonField(jsonUserInfo, "name");

            UserDAO dao = new UserDAO();
            Users user = dao.getUserByEmail(email);

            // 3. User does not exist, automatically register them as Customer (role_id = 3)
            if (user == null) {
                boolean isRegistered = dao.registerGoogleUser(name, email);
                if (isRegistered) {
                    user = dao.getUserByEmail(email);
                } else {
                    request.setAttribute("error", "Tự động đăng ký qua tài khoản Google thất bại!");
                    request.getRequestDispatcher("auth/login.jsp").forward(request, response);
                    return;
                }
            }

            // 4. Validate Account Status
            if (user != null && !user.isStatus()) {
                request.setAttribute("error", "Tài khoản Google của bạn đã bị khóa!");
                request.getRequestDispatcher("auth/login.jsp").forward(request, response);
                return;
            }

            // 5. Establish session and Redirect
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            if (user.roleId == 1) {
                response.sendRedirect("admin/dashboard");
            } else if (user.roleId == 2) {
                response.sendRedirect("staff/inventory");
            } else {
                response.sendRedirect("HomeServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi trong quá trình đăng nhập Google: " + e.getMessage());
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        }
    }
}

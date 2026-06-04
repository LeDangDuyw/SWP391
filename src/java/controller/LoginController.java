package controller;

import dal.UserDAO;
import model.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth/login.jsp").forward(request, response);
    }
/*
 * Name: doPost
 * @Author: LUCTVHE201874
 * Date: [04/06/2026]
 * Version: 2.0
 * Description: Hàm này xử lý đăng nhập: xác thực tài khoản, kiểm tra trạng thái khóa, 
    và điều hướng người dùng đến trang phù hợp (admin/user/staff) dựa theo vai trò nếu thành công.
 */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // Validate null, empty, or whitespace-only inputs
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email và mật khẩu không được để trống!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        password = password.trim();

        UserDAO dao = new UserDAO();
        Users user = dao.login(email, password);

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        } else if (!user.isStatus()) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        } else {
            // Manage cookies based on Remember checkbox
            if (remember != null && "ON".equals(remember)) {
                Cookie cEmail = new Cookie("c_email", email);
                Cookie cPassword = new Cookie("c_password", password);
                Cookie cRemember = new Cookie("c_remember", "ON");
                
                cEmail.setMaxAge(7 * 24 * 60 * 60); 
                cPassword.setMaxAge(7 * 24 * 60 * 60);
                cRemember.setMaxAge(7 * 24 * 60 * 60);
                
                cEmail.setPath("/");
                cPassword.setPath("/");
                cRemember.setPath("/");
                
                response.addCookie(cEmail);
                response.addCookie(cPassword);
                response.addCookie(cRemember);
            } else {
                // Delete cookies if unchecked
                Cookie cEmail = new Cookie("c_email", "");
                Cookie cPassword = new Cookie("c_password", "");
                Cookie cRemember = new Cookie("c_remember", "");
                
                cEmail.setMaxAge(0);
                cPassword.setMaxAge(0);
                cRemember.setMaxAge(0);
                
                cEmail.setPath("/");
                cPassword.setPath("/");
                cRemember.setPath("/");
                
                response.addCookie(cEmail);
                response.addCookie(cPassword);
                response.addCookie(cRemember);
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.roleId == 1) {
                response.sendRedirect("admin/dashboard");
            } else if (user.roleId == 2) {
                response.sendRedirect("staff/inventory");
            }else{
                response.sendRedirect("HomeServlet");
            } 
        }
    }
}

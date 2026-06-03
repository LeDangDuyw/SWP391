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
 * Date: [01/06/2026]
 * Version: 1.0
 * Description: Hàm này xử lý đăng nhập: xác thực tài khoản, kiểm tra trạng thái khóa, 
    và điều hướng người dùng đến trang phù hợp (admin/user/staff) dựa theo vai trò nếu thành công.
 */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        Users user = dao.login(email, password);

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        } else if (!user.isStatus()) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa!");
            request.getRequestDispatcher("auth/login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.roleId == 1) {
                response.sendRedirect("auth/AdminDashboard.jsp");
            } else if (user.roleId == 2) {
                response.sendRedirect("auth/home.jsp");
            } 
        }
    }
}

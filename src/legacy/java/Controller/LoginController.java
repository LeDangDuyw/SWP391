package Controller;

import Dao.UserDAO;
import Model.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /*
     * Name: doPost
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Hàm này xử lý đăng nhập: xác thực tài khoản, kiểm tra trạng thái khóa ('active'),
     * và điều hướng người dùng đến trang phù hợp (admin.jsp / staff.jsp / user.jsp) dựa theo vai trò nếu thành công.
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
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if (user.getStatus() == null || !user.getStatus().equalsIgnoreCase("active")) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on exact role_id:
            // Role 1 (Admin) -> admin.jsp
            // Role 2 (Staff) -> staff.jsp
            // Role 3 (Customer) -> user.jsp
            if (user.getRoleId() == 1) {
                response.sendRedirect("admin.jsp");
            } else if (user.getRoleId() == 2) {
                response.sendRedirect("staff.jsp");
            } else if (user.getRoleId() == 3) {
                response.sendRedirect("user.jsp");
            } else {
                response.sendRedirect("user.jsp");
            }
        }
    }
}

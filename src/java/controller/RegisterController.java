package controller;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth/register.jsp").forward(request, response);
    }
    /*
 * Name: doPost
 * @Author: LUCTVHE201874
 * Date: [01/06/2026]
 * Version: 2.0
 * Description: Hàm này xử lý đăng ký tài khoản: kiểm tra tính hợp lệ của dữ liệu đầu vào (mật khẩu, định dạng email, 
    số điện thoại, trùng email) và lưu thông tin vào cơ sở dữ liệu nếu hợp lệ.
 */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Null or empty check
        if (userName == null || userName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        userName = userName.trim();
        email = email.trim();
        phone = phone.trim();
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        
        // Validate Full Name (letters and spaces only, including Vietnamese accented characters)
        if (!userName.matches("^[\\p{L} ]+$")) {
            request.setAttribute("error", "Họ và tên chỉ được chứa chữ cái và khoảng trắng!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        String emailRegex = "^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$";
        if (!email.matches(emailRegex)) {
            request.setAttribute("error", "Email không hợp lệ!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!phone.matches("^0[35789]\\d{8}$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO dao = new UserDAO();
        
        if (dao.isEmailExist(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (dao.isPhoneExist(phone)) {
            request.setAttribute("error", "Số điện thoại đã được sử dụng!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        boolean isRegistered = dao.register(userName, email, phone, password);
        if (isRegistered) {
            response.sendRedirect("login?success=1");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
        }
    }
}

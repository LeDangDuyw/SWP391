package controller;

import dal.UserDAO;
import dal.AccountActivationTokenDAO;
import model.Users;
import utils.EmailUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
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
        
        if (userName.length() > 100) {
            request.setAttribute("error", "Họ và tên không được vượt quá 100 ký tự!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
            return;
        }
        
        String emailRegex = "^[\\w.+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$";
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
        
        if (!utils.hashPasswordUtil.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
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
            Users newUser = dao.getUserByEmail(email);
            if (newUser != null) {
                // Generate token and expiration time (24 hours)
                String token = UUID.randomUUID().toString();
                Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 24 * 60 * 60 * 1000);
                
                AccountActivationTokenDAO tokenDAO = new AccountActivationTokenDAO();
                tokenDAO.createToken(newUser.getUserId(), token, expiresAt);
                
                // Construct activation link
                String scheme = request.getScheme();
                String serverName = request.getServerName();
                int serverPort = request.getServerPort();
                String contextPath = request.getContextPath();
                String baseURL = scheme + "://" + serverName + ":" + serverPort + contextPath + "/";
                String activationLink = baseURL + "activate?token=" + token;
                
                // Send email
                String subject = "Kích hoạt tài khoản - UniLap";
                String htmlBody = "<h2>Kích hoạt tài khoản UniLap của bạn</h2>"
                        + "<p>Chào " + userName + ",</p>"
                        + "<p>Cảm ơn bạn đã đăng ký tài khoản tại UniLap. Vui lòng bấm vào liên kết dưới đây để kích hoạt tài khoản của bạn (liên kết có hiệu lực trong vòng 24 giờ):</p>"
                        + "<p><a href=\"" + activationLink + "\" style=\"display:inline-block; background:#1565c0; color:#fff; padding:10px 20px; text-decoration:none; border-radius:4px;\">Kích hoạt tài khoản</a></p>"
                        + "<p>Nếu link trên không hoạt động, bạn có thể copy và dán liên kết này vào trình duyệt:</p>"
                        + "<p>" + activationLink + "</p>"
                        + "<br/>"
                        + "<p>Trân trọng,<br/>Đội ngũ hỗ trợ UniLap</p>";
                
                EmailUtils.sendEmail(email, subject, htmlBody);
            }
            response.sendRedirect("login?success=3");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("auth/register.jsp").forward(request, response);
        }
    }
}

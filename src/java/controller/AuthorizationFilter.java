package controller;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import model.Users;

/*
 * Name: AuthorizationFilter
 * @Author: Antigravity AI / LucTV
 * Date: [05/06/2026]
 * Version: 2.0
 * Description: Bộ lọc phân quyền (Authorization Filter) bảo vệ các tài nguyên 
 * trong thư mục /admin/* và /staff/*. Chỉ cho phép truy cập nếu người dùng đã đăng nhập,
 * tài khoản ở trạng thái active và có đúng vai trò tương ứng (roleId = 1 cho Admin, roleId = 2 cho Staff).
 */
@WebFilter(urlPatterns = {"/admin/*", "/staff/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo đặc biệt
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Lấy thông tin người dùng từ Session
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        if (user == null) {
            // Chưa đăng nhập -> redirect về trang login với thông báo lỗi
            httpResponse.sendRedirect(contextPath + "/login?error=" + 
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        // Kiểm tra xem tài khoản có bị khóa trong cơ sở dữ liệu hay không (Giải quyết Locked user is logged out)
        UserDAO userDAO = new UserDAO();
        Users freshUser = userDAO.getUserById(user.getUserId());
        if (freshUser == null || !"active".equalsIgnoreCase(freshUser.getStatus())) {
            if (session != null) {
                session.invalidate();
            }
            httpResponse.sendRedirect(contextPath + "/login?error=" + 
                    URLEncoder.encode("Tài khoản của bạn đã bị khóa hoặc ngừng hoạt động!", "UTF-8"));
            return;
        }

        // Kiểm tra phân quyền dựa theo roleId (1: Admin, 2: Staff, 3: Customer)
        if (path.startsWith("/admin/")) {
            if (freshUser.getRoleId() != 1) {
                // Không phải Admin -> từ chối truy cập
                httpResponse.sendRedirect(contextPath + "/login?error=" + 
                        URLEncoder.encode("Bạn không có quyền truy cập trang quản trị!", "UTF-8"));
                return;
            }
        } else if (path.startsWith("/staff/")) {
            if (freshUser.getRoleId() != 2) {
                // Không phải Staff -> từ chối truy cập
                httpResponse.sendRedirect(contextPath + "/login?error=" + 
                        URLEncoder.encode("Bạn không có quyền truy cập trang nhân viên!", "UTF-8"));
                return;
            }
        }

        // Đã thỏa mãn điều kiện phân quyền, cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}

package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;

/*
 * Name: AuthorizationFilter
 * @Author: Antigravity AI
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Bộ lọc phân quyền (Authorization Filter) bảo vệ các tài nguyên 
 * trong thư mục /admin/* và /staff/*. Chỉ cho phép truy cập nếu người dùng đã đăng nhập 
 * và có đúng vai trò tương ứng (roleId = 1 cho Admin, roleId = 2 cho Staff).
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
                    java.net.URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        // Kiểm tra phân quyền dựa theo roleId (1: Admin, 2: Staff, 3: Customer)
        if (path.startsWith("/admin/")) {
            if (user.getRoleId() != 1) {
                // Không phải Admin -> từ chối truy cập
                httpResponse.sendRedirect(contextPath + "/login?error=" + 
                        java.net.URLEncoder.encode("Bạn không có quyền truy cập trang quản trị!", "UTF-8"));
                return;
            }
        } else if (path.startsWith("/staff/")) {
            if (user.getRoleId() != 2) {
                // Không phải Staff -> từ chối truy cập
                httpResponse.sendRedirect(contextPath + "/login?error=" + 
                        java.net.URLEncoder.encode("Bạn không có quyền truy cập trang nhân viên!", "UTF-8"));
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

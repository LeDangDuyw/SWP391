package controller;

import dal.UserDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;

/*
 * Name: ManageUsersController
 * @Author: Antigravity AI
 * Date: [22/06/2026]
 * Version: 1.0
 * Description: Servlet for Admin to view, search, paginate, lock/unlock accounts, 
 * and modify roles of users. Implements security checks to prevent self-lockout 
 * and self-role downgrade according to UC07 spec.
 */
@WebServlet("/admin/users")
public class ManageUsersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        // Security check: Must be logged in as Admin (roleId = 1)
        if (sessionUser == null || sessionUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Bạn không có quyền truy cập trang quản lý tài khoản!", "UTF-8"));
            return;
        }

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }
        search = search.trim();

        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        UserDAO userDAO = new UserDAO();
        int totalUsers = userDAO.getTotalUsers(search);
        int limit = 10;
        int totalPages = (int) Math.ceil((double) totalUsers / limit);
        if (totalPages == 0) {
            totalPages = 1;
        }

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * limit;
        ArrayList<Users> usersList = userDAO.getUsers(search, offset, limit);

        // Map feedback codes
        String successCode = request.getParameter("success");
        if (successCode != null) {
            if ("1".equals(successCode)) {
                request.setAttribute("successMessage", "Tài khoản đã được khóa thành công.");
            } else if ("2".equals(successCode)) {
                request.setAttribute("successMessage", "Tài khoản đã được mở khóa thành công.");
            } else if ("3".equals(successCode)) {
                request.setAttribute("successMessage", "Phân quyền đã được cập nhật thành công.");
            }
        }

        String errorMsg = request.getParameter("error");
        if (errorMsg != null && !errorMsg.trim().isEmpty()) {
            request.setAttribute("errorMessage", errorMsg.trim());
        }

        request.setAttribute("usersList", usersList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        // Security check
        if (sessionUser == null || sessionUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Yêu cầu không hợp lệ!", "UTF-8"));
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        String roleIdStr = request.getParameter("roleId");
        String search = request.getParameter("search");
        String page = request.getParameter("page");

        // Format parameters to redirect back preserving context
        if (search == null) {
            search = "";
        }
        if (page == null || page.trim().isEmpty()) {
            page = "1";
        }
        
        StringBuilder redirectURL = new StringBuilder(request.getContextPath() + "/admin/users?page=" + page);
        if (!search.trim().isEmpty()) {
            redirectURL.append("&search=").append(URLEncoder.encode(search.trim(), "UTF-8"));
        }

        if (action == null || userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(redirectURL.toString() + "&error=" +
                    URLEncoder.encode("Thiếu thông tin yêu cầu cập nhật!", "UTF-8"));
            return;
        }

        int targetUserId;
        try {
            targetUserId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectURL.toString() + "&error=" +
                    URLEncoder.encode("ID người dùng không hợp lệ!", "UTF-8"));
            return;
        }

        // Business Rule Checks for self-modification
        if (targetUserId == sessionUser.getUserId()) {
            if ("lock".equalsIgnoreCase(action) || "unlock".equalsIgnoreCase(action)) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Bạn không thể khóa tài khoản của chính mình.", "UTF-8"));
                return;
            }
            if ("change-role".equalsIgnoreCase(action)) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Bạn không thể thay đổi quyền của chính mình.", "UTF-8"));
                return;
            }
        }

        UserDAO userDAO = new UserDAO();
        boolean isSuccess = false;

        if ("lock".equalsIgnoreCase(action)) {
            isSuccess = userDAO.updateStatus(targetUserId, "inactive");
            if (isSuccess) {
                response.sendRedirect(redirectURL.toString() + "&success=1");
            } else {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Khóa tài khoản thất bại. Vui lòng thử lại!", "UTF-8"));
            }
        } else if ("unlock".equalsIgnoreCase(action)) {
            isSuccess = userDAO.updateStatus(targetUserId, "active");
            if (isSuccess) {
                response.sendRedirect(redirectURL.toString() + "&success=2");
            } else {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Mở khóa tài khoản thất bại. Vui lòng thử lại!", "UTF-8"));
            }
        } else if ("change-role".equalsIgnoreCase(action)) {
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Thiếu thông tin vai trò mới!", "UTF-8"));
                return;
            }
            int newRoleId;
            try {
                newRoleId = Integer.parseInt(roleIdStr.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Vai trò mới không hợp lệ!", "UTF-8"));
                return;
            }

            // Ensure roleId is valid: 1 = Admin, 2 = Staff, 3 = Customer
            if (newRoleId != 1 && newRoleId != 2 && newRoleId != 3) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Phân quyền không tồn tại!", "UTF-8"));
                return;
            }

            isSuccess = userDAO.updateRole(targetUserId, newRoleId);
            if (isSuccess) {
                response.sendRedirect(redirectURL.toString() + "&success=3");
            } else {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Cập nhật phân quyền thất bại. Vui lòng thử lại!", "UTF-8"));
            }
        } else {
            response.sendRedirect(redirectURL.toString() + "&error=" +
                    URLEncoder.encode("Hành động không hợp lệ!", "UTF-8"));
        }
    }
}

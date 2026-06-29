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

    /*
     * Name: doGet
     * Description: Xử lý hiển thị danh sách tài khoản kèm bộ lọc và phân trang.
     *              Hỗ trợ cả yêu cầu AJAX để đếm số lượng đơn hàng hoạt động của người dùng trước khi khóa.
     * @Author: LUCTVHE201874
     * Created Date: 04/04/2026
     * Completed Date: 26/04/2026
     */
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

        String ajaxAction = request.getParameter("ajaxAction");
        if ("checkActiveOrders".equalsIgnoreCase(ajaxAction)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String targetUserIdStr = request.getParameter("userId");
            int targetUserId = 0;
            int activeOrdersCount = 0;
            try {
                targetUserId = Integer.parseInt(targetUserIdStr.trim());
                UserDAO userDAO = new UserDAO();
                activeOrdersCount = userDAO.getActiveOrdersCount(targetUserId);
            } catch (Exception e) {
                // Ignore
            }
            response.getWriter().write("{\"activeOrdersCount\":" + activeOrdersCount + "}");
            return;
        }

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }
        search = search.trim();

        // Retrieve and parse role filter (1 = Admin, 2 = Staff, 3 = Customer)
        String roleParam = request.getParameter("role");
        Integer roleFilter = null;
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            try {
                roleFilter = Integer.parseInt(roleParam.trim());
            } catch (NumberFormatException e) {
                roleFilter = null;
            }
        }

        // Retrieve and parse status filter (active, inactive)
        String statusParam = request.getParameter("status");
        String statusFilter = null;
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            statusFilter = statusParam.trim();
        }

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
        int totalUsers = userDAO.getTotalUsers(search, roleFilter, statusFilter);
        int limit = 10;
        int totalPages = (int) Math.ceil((double) totalUsers / limit);
        if (totalPages == 0) {
            totalPages = 1;
        }

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * limit;
        ArrayList<Users> usersList = userDAO.getUsers(search, roleFilter, statusFilter, offset, limit);

        // Map feedback codes
        String successCode = request.getParameter("success");
        if (successCode != null) {
            if ("1".equals(successCode)) {
                request.setAttribute("successMessage", "Tài khoản đã được khóa thành công.");
            } else if ("2".equals(successCode)) {
                request.setAttribute("successMessage", "Tài khoản đã được mở khóa thành công.");
            } else if ("3".equals(successCode)) {
                request.setAttribute("successMessage", "Phân quyền đã được cập nhật thành công.");
            } else if ("4".equals(successCode)) {
                request.setAttribute("successMessage", "Tài khoản mới đã được tạo thành công.");
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
        request.setAttribute("selectedRole", roleParam);
        request.setAttribute("selectedStatus", statusParam);

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
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");

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
        if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            redirectURL.append("&role=").append(URLEncoder.encode(roleFilter.trim(), "UTF-8"));
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            redirectURL.append("&status=").append(URLEncoder.encode(statusFilter.trim(), "UTF-8"));
        }

        UserDAO userDAO = new UserDAO();

        // Process creation of a new user by Admin
        if ("create".equalsIgnoreCase(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String roleIdStrInput = request.getParameter("roleId");

            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                roleIdStrInput == null || roleIdStrInput.trim().isEmpty()) {
                
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Vui lòng điền đầy đủ các thông tin bắt buộc!", "UTF-8"));
                return;
            }

            fullName = fullName.trim();
            email = email.trim();
            phone = (phone != null) ? phone.trim() : "";
            password = password.trim();

            // Validate Full Name
            if (!fullName.matches("^[\\p{L} ]+$")) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Họ và tên chỉ được chứa chữ cái và khoảng trắng!", "UTF-8"));
                return;
            }

            // Validate Email format
            String emailRegex = "^[\\w.+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$";
            if (!email.matches(emailRegex)) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Email không hợp lệ!", "UTF-8"));
                return;
            }

            // Validate Phone if present
            if (!phone.isEmpty() && !phone.matches("^0[35789]\\d{8}$")) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Số điện thoại không hợp lệ! Phải bao gồm 10 chữ số bắt đầu bằng 03, 05, 07, 08, hoặc 09.", "UTF-8"));
                return;
            }

            if (password.length() < 6) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Mật khẩu phải có ít nhất 6 ký tự!", "UTF-8"));
                return;
            }

            int newRoleId;
            try {
                newRoleId = Integer.parseInt(roleIdStrInput.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Vai trò không hợp lệ!", "UTF-8"));
                return;
            }

            if (newRoleId != 1 && newRoleId != 2 && newRoleId != 3) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Vai trò không tồn tại!", "UTF-8"));
                return;
            }

            if (userDAO.isEmailExist(email)) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Email đã được sử dụng bởi tài khoản khác!", "UTF-8"));
                return;
            }

            if (!phone.isEmpty() && userDAO.isPhoneExist(phone)) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Số điện thoại đã được sử dụng bởi tài khoản khác!", "UTF-8"));
                return;
            }

            boolean isCreated = userDAO.createUserByAdmin(fullName, email, phone, password, newRoleId);
            if (isCreated) {
                response.sendRedirect(redirectURL.toString() + "&success=4");
            } else {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Tạo tài khoản thất bại. Vui lòng thử lại!", "UTF-8"));
            }
            return;
        }

        // Remaining status/role update actions
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

        boolean isSuccess = false;

        if ("lock".equalsIgnoreCase(action)) {
            // Check active orders count before locking
            int activeOrders = userDAO.getActiveOrdersCount(targetUserId);
            if (activeOrders > 0) {
                response.sendRedirect(redirectURL.toString() + "&error=" +
                        URLEncoder.encode("Không thể khóa tài khoản này vì người dùng đang có " + activeOrders + " đơn hàng chưa hoàn tất!", "UTF-8"));
                return;
            }
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

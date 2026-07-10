package controller;

import dal.UserDAO;
import model.Users;
import utils.hashPasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.UUID;

/*
 * Name: ProfileController
 * @Author: LUCTVHE201874
 * Date: [21/06/2026]
 * Version: 2.0
 * Complete:[26/06/2026]
 * Description: Controller to display and update the user's personal profile.
 * Supports updating Full Name, Phone Number, uploading an Avatar image,
 * and changing the account password (UC05 – Change Password per SRS spec).
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        // Fetch fresh user data from database to display
        UserDAO userDAO = new UserDAO();
        Users freshUser = userDAO.getUserById(sessionUser.getUserId());
        if (freshUser == null) {
            freshUser = sessionUser;
        }

        request.setAttribute("profileUser", freshUser);
        
        // Load student verification status if customer or student
        if (freshUser.getRoleId() == 3 || freshUser.getRoleId() == 4) {
            dal.StudentVerificationDAO svDAO = new dal.StudentVerificationDAO();
            model.StudentVerification sv = svDAO.getByUserId(freshUser.getUserId());
            request.setAttribute("studentVerify", sv);

            // Load purchase history (orders & details)
            dal.OrderDAO orderDAO = new dal.OrderDAO();
            java.util.List<model.Order> userOrders = orderDAO.getOrdersByUserId(freshUser.getUserId());
            for (model.Order o : userOrders) {
                o.setDetails(orderDAO.getOrderDetails(o.getOrderId()));
            }
            request.setAttribute("userOrders", userOrders);
        }

        // Support flash message notifications
        String tempSuccess = (String) session.getAttribute("tempSuccess");
        if (tempSuccess != null) {
            request.setAttribute("success", tempSuccess);
            session.removeAttribute("tempSuccess");
        }
        String tempError = (String) session.getAttribute("tempError");
        if (tempError != null) {
            request.setAttribute("error", tempError);
            session.removeAttribute("tempError");
        }
        
        request.getRequestDispatcher("/auth/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // Route by Content-Type:
        // - Profile update form uses enctype="multipart/form-data"
        // - Change password form is a regular POST (application/x-www-form-urlencoded)
        // This avoids @MultipartConfig interfering with getParameter() on non-multipart requests.
        String contentType = request.getContentType();
        boolean isMultipart = (contentType != null && contentType.toLowerCase().startsWith("multipart/form-data"));

        if (isMultipart) {
            handleUpdateProfile(request, response, sessionUser);
        } else {
            handleChangePassword(request, response, sessionUser);
        }
    }

    // -----------------------------------------------------------------------
    // UC05 – Change Password
    // Validates current password, enforces VR-02 / VR-03, updates DB.
    // -----------------------------------------------------------------------
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
            Users sessionUser) throws ServletException, IOException {

        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Required-field check (VR-08)
        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("pwError", "Vui lòng điền đầy đủ tất cả các trường mật khẩu!");
            doGet(request, response);
            return;
        }

        currentPassword = currentPassword.trim();
        newPassword     = newPassword.trim();
        confirmPassword = confirmPassword.trim();

        // Verify current password against stored BCrypt hash
        UserDAO userDAO  = new UserDAO();
        Users freshUser  = userDAO.getUserById(sessionUser.getUserId());
        String storedHash = (freshUser != null) ? freshUser.getPassword() : sessionUser.getPassword();

        if (!hashPasswordUtil.checkPassword(currentPassword, storedHash)) {
            request.setAttribute("pwError", "Mật khẩu hiện tại không đúng!");
            doGet(request, response);
            return;
        }

        // Minimum 6 characters
        if (newPassword.length() < 6) {
            request.setAttribute("pwError", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            doGet(request, response);
            return;
        }

        // MSG15: confirmation must match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("pwError", "Xác nhận mật khẩu không khớp!");
            doGet(request, response);
            return;
        }

        // Prevent reuse of the current password
        if (hashPasswordUtil.checkPassword(newPassword, storedHash)) {
            request.setAttribute("pwError", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
            doGet(request, response);
            return;
        }

        // Commit the new password to the database
        boolean changed = userDAO.changePassword(sessionUser.getUserId(), newPassword);
        if (changed) {
            Users updatedUser = userDAO.getUserById(sessionUser.getUserId());
            if (updatedUser != null) {
                request.getSession().setAttribute("user", updatedUser);
            }
            request.setAttribute("pwSuccess", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("pwError", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
        }

        doGet(request, response);
    }

    /*
     * Name: handleUpdateProfile
     * Description: Xử lý cập nhật thông tin cá nhân bao gồm Họ tên, Số điện thoại và tải lên ảnh đại diện.
     *              Đồng bộ ảnh đại diện sang thư mục nguồn của NetBeans để lưu trữ lâu dài.
     * @Author: LUCTVHE201874
     * Created Date: 04/04/2026
     * Completed Date: 26/04/2026
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
            Users sessionUser) throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");

        if (isBlank(fullName)) {
            request.setAttribute("error", "Họ tên không được để trống!");
            doGet(request, response);
            return;
        }

        fullName = fullName.trim();
        if (phone != null) {
            phone = phone.trim();
        }

        UserDAO userDAO        = new UserDAO();
        Users freshUser        = userDAO.getUserById(sessionUser.getUserId());
        String currentAvatarUrl = (freshUser != null) ? freshUser.getAvatarUrl() : sessionUser.getAvatarUrl();
        String newAvatarUrl    = currentAvatarUrl;

        // Process avatar file upload
        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                String extension = "";
                int lastDotIdx = originalFileName.lastIndexOf('.');
                if (lastDotIdx > 0) {
                    extension = originalFileName.substring(lastDotIdx);
                }
                String contentType = filePart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {
                    String fileName  = UUID.randomUUID().toString() + extension;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir   = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    
                    // Sync to source directory for persistence in local NetBeans environment
                    try {
                        String sourcePath = uploadPath.replace("build" + File.separator + "web", "web");
                        File sourceDir = new File(sourcePath);
                        if (sourceDir.exists()) {
                            File buildFile = new File(uploadPath + File.separator + fileName);
                            File sourceFile = new File(sourcePath + File.separator + fileName);
                            if (buildFile.exists()) {
                                java.nio.file.Files.copy(buildFile.toPath(), sourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                            }
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    
                    newAvatarUrl = fileName;
                } else {
                    request.setAttribute("error", "Định dạng file không hợp lệ! Vui lòng tải lên file ảnh.");
                    doGet(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải ảnh đại diện: " + e.getMessage());
            doGet(request, response);
            return;
        }

        boolean isUpdated = userDAO.updateProfile(sessionUser.getUserId(), fullName, phone, newAvatarUrl);
        if (isUpdated) {
            Users updatedUser = userDAO.getUserById(sessionUser.getUserId());
            if (updatedUser != null) {
                request.getSession().setAttribute("user", updatedUser);
            }
            request.setAttribute("success", "Cập nhật thông tin cá nhân thành công!");
        } else {
            request.setAttribute("error", "Cập nhật thông tin thất bại. Vui lòng thử lại!");
        }

        doGet(request, response);
    }

    /** Null-safe blank check */
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

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
 * @Author: LUCTV
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

        // Kiểm tra xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        // Tải thông tin người dùng mới nhất từ database
        UserDAO userDAO = new UserDAO();
        Users freshUser = userDAO.getUserById(sessionUser.getUserId());
        if (freshUser == null) {
            freshUser = sessionUser;
        }
        session.setAttribute("user", freshUser);
        request.setAttribute("profileUser", freshUser);
        
        // Kiểm tra trạng thái phê duyệt tài khoản sinh viên (nếu thuộc vai trò Customer/Student)
        if (freshUser.getRoleId() == 3 || freshUser.getRoleId() == 4) {
            dal.StudentVerificationDAO svDAO = new dal.StudentVerificationDAO();
            model.StudentVerification sv = svDAO.getByUserId(freshUser.getUserId());
            request.setAttribute("studentVerify", sv);

            // Kiểm tra giới hạn 30 ngày để cho phép yêu cầu xác thực lại nếu bị từ chối
            if (sv != null && ("rejected".equalsIgnoreCase(sv.getStatus()) || "revoked".equalsIgnoreCase(sv.getStatus()))) {
                java.sql.Timestamp lastDate = sv.getUpdatedAt() != null ? sv.getUpdatedAt() : sv.getCreatedAt();
                if (lastDate != null) {
                    long now = System.currentTimeMillis();
                    long diffInDays = (now - lastDate.getTime()) / (1000L * 60 * 60 * 24);
                    if (diffInDays < 30) {
                        long daysRemaining = Math.max(1, 30 - diffInDays);
                        request.setAttribute("canResubmit", false);
                        request.setAttribute("daysRemaining", daysRemaining);
                    } else {
                        request.setAttribute("canResubmit", true);
                    }
                } else {
                    request.setAttribute("canResubmit", true);
                }
            }

            // Tải lịch sử các đơn hàng đã đặt của người dùng
            dal.OrderDAO orderDAO = new dal.OrderDAO();
            dal.ProductReviewDAO reviewDAO = new dal.ProductReviewDAO();
            java.util.List<model.Order> userOrders = orderDAO.getOrdersByUserId(freshUser.getUserId());
            for (model.Order o : userOrders) {
                java.util.List<model.OrderDetail> details = orderDAO.getOrderDetails(o.getOrderId());
                for (model.OrderDetail od : details) {
                    // Đánh dấu xem sản phẩm này đã được bình luận hay chưa
                    od.setReviewed(reviewDAO.hasUserReviewedProduct(freshUser.getUserId(), od.getProductId()));
                }
                o.setDetails(details);
            }
            request.setAttribute("userOrders", userOrders);
        }

        // Hỗ trợ hiển thị thông báo thành công hoặc thất bại dạng Flash Message
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

        // Xác minh trạng thái phiên đăng nhập của người dùng
        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    URLEncoder.encode("Vui lòng đăng nhập để tiếp tục!", "UTF-8"));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // Định tuyến xử lý biểu mẫu dựa trên Content-Type:
        // - Form cập nhật profile sử dụng định dạng Multipart để tải ảnh đại diện
        // - Form đổi mật khẩu sử dụng phương thức POST thông thường
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

        // Kiểm tra các trường dữ liệu bắt buộc không được bỏ trống
        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("pwError", "Vui lòng điền đầy đủ tất cả các trường mật khẩu!");
            doGet(request, response);
            return;
        }

        currentPassword = currentPassword.trim();
        newPassword     = newPassword.trim();
        confirmPassword = confirmPassword.trim();

        // Kiểm tra mật khẩu hiện tại có trùng khớp với BCrypt hash trong Database không
        UserDAO userDAO  = new UserDAO();
        Users freshUser  = userDAO.getUserById(sessionUser.getUserId());
        String storedHash = (freshUser != null) ? freshUser.getPassword() : sessionUser.getPassword();

        if (!hashPasswordUtil.checkPassword(currentPassword, storedHash)) {
            request.setAttribute("pwError", "Mật khẩu hiện tại không đúng!");
            doGet(request, response);
            return;
        }

        // Rà soát độ mạnh mật khẩu theo các quy tắc nghiệp vụ
        if (!hashPasswordUtil.isValidPassword(newPassword)) {
            request.setAttribute("pwError", "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            doGet(request, response);
            return;
        }

        // Đảm bảo mật khẩu xác nhận phải trùng với mật khẩu mới nhập
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("pwError", "Xác nhận mật khẩu không khớp!");
            doGet(request, response);
            return;
        }

        // Đảm bảo mật khẩu mới không trùng lặp với mật khẩu hiện tại
        if (hashPasswordUtil.checkPassword(newPassword, storedHash)) {
            request.setAttribute("pwError", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
            doGet(request, response);
            return;
        }

        // Tiến hành cập nhật mật khẩu mới đã mã hóa vào database
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
     * @Author: LUCTV
     * Created Date: 04/04/2026
     * Completed Date: 26/04/2026
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
            Users sessionUser) throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");

        // Rà soát không cho phép họ tên để trống
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

        // Xử lý luồng tải lên ảnh đại diện (avatar) của khách hàng
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
                    
                    // Đồng bộ ảnh từ thư mục build của máy chủ sang thư mục nguồn web của dự án
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

        // Cập nhật thông tin hồ sơ vào Database
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
        // Kiểm tra xem chuỗi đầu vào có bị null hoặc rỗng hay không
        return s == null || s.trim().isEmpty();
    }
}

package controller;

import dal.StudentVerificationDAO;
import model.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/profile/student-verify")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StudentVerificationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Only role 3 (customer) can submit verification
        if (user.getRoleId() != 3) {
            session.setAttribute("tempError", "Tài khoản của bạn đã được xác minh là sinh viên hoặc không thuộc đối tượng xác minh!");
            response.sendRedirect(request.getContextPath() + "/profile#student-verify");
            return;
        }

        StudentVerificationDAO svDAO = new StudentVerificationDAO();
        model.StudentVerification existing = svDAO.getByUserId(user.getUserId());
        if (existing != null) {
            if ("approved".equalsIgnoreCase(existing.getStatus())) {
                session.setAttribute("tempError", "Tài khoản của bạn đã được xác minh thành công!");
                response.sendRedirect(request.getContextPath() + "/profile#student-verify");
                return;
            }
            if ("pending".equalsIgnoreCase(existing.getStatus())) {
                session.setAttribute("tempError", "Yêu cầu xác minh sinh viên của bạn đang được xử lý. Vui lòng chờ nhân viên duyệt!");
                response.sendRedirect(request.getContextPath() + "/profile#student-verify");
                return;
            }
            if ("rejected".equalsIgnoreCase(existing.getStatus()) || "revoked".equalsIgnoreCase(existing.getStatus())) {
                java.sql.Timestamp lastDate = existing.getUpdatedAt() != null ? existing.getUpdatedAt() : existing.getCreatedAt();
                if (lastDate != null) {
                    long now = System.currentTimeMillis();
                    long diffInDays = (now - lastDate.getTime()) / (1000L * 60 * 60 * 24);
                    if (diffInDays < 30) {
                        long daysRemaining = Math.max(1, 30 - diffInDays);
                        session.setAttribute("tempError", "Yêu cầu của bạn từng bị từ chối/thu hồi. Mỗi tháng bạn chỉ được gửi lại yêu cầu 1 lần (Cần chờ thêm " + daysRemaining + " ngày nữa)!");
                        response.sendRedirect(request.getContextPath() + "/profile#student-verify");
                        return;
                    }
                }
            }
        }

        try {
            java.util.Collection<Part> fileParts = request.getParts();
            java.util.List<String> savedFileNames = new java.util.ArrayList<>();
            boolean hasInvalidFile = false;
            
            // Count valid image files - max 3 allowed
            int imageCount = 0;
            for (Part p : fileParts) {
                if ("studentCard".equals(p.getName()) && p.getSize() > 0) {
                    imageCount++;
                }
            }
            if (imageCount > 3) {
                session.setAttribute("tempError", "Bạn chỉ được tải lên tối đa 3 ảnh!");
                response.sendRedirect(request.getContextPath() + "/profile#student-verify");
                return;
            }
            
            for (Part filePart : fileParts) {
                if (!"studentCard".equals(filePart.getName()) || filePart.getSize() <= 0) {
                    continue;
                }
                
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    hasInvalidFile = true;
                    continue;
                }
                
                String originalFileName = filePart.getSubmittedFileName();
                String extension = "";
                int lastDotIdx = originalFileName.lastIndexOf('.');
                if (lastDotIdx > 0) {
                    extension = originalFileName.substring(lastDotIdx);
                }
                
                String fileName = UUID.randomUUID().toString() + extension;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
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
                    System.out.println("Error syncing student card photo to source folder: " + ex.getMessage());
                }
                
                savedFileNames.add(fileName);
            }
            
            if (savedFileNames.isEmpty()) {
                if (hasInvalidFile) {
                    session.setAttribute("tempError", "Định dạng file không hợp lệ! Vui lòng tải lên file ảnh.");
                } else {
                    session.setAttribute("tempError", "Vui lòng chọn ảnh thẻ sinh viên để tải lên!");
                }
            } else {
                // Join multiple file names with comma separator
                String allFileNames = String.join(",", savedFileNames);
                boolean success = svDAO.createRequest(user.getUserId(), allFileNames);
                if (success) {
                    session.setAttribute("tempSuccess", "Gửi yêu cầu xác minh sinh viên thành công! Vui lòng chờ nhân viên duyệt.");
                } else {
                    session.setAttribute("tempError", "Có lỗi xảy ra khi lưu thông tin vào cơ sở dữ liệu. Vui lòng thử lại!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("tempError", "Lỗi tải ảnh: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/profile#student-verify");
    }
}

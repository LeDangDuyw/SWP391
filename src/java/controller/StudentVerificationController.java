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
            session.setAttribute("tempError", "Tài khoản của bạn không cần xác minh sinh viên hoặc đã được xác minh!");
            response.sendRedirect(request.getContextPath() + "/profile#student-verify");
            return;
        }

        try {
            Part filePart = request.getPart("studentCard");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                String extension = "";
                int lastDotIdx = originalFileName.lastIndexOf('.');
                if (lastDotIdx > 0) {
                    extension = originalFileName.substring(lastDotIdx);
                }
                
                String contentType = filePart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {
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
                    
                    StudentVerificationDAO svDAO = new StudentVerificationDAO();
                    boolean success = svDAO.createRequest(user.getUserId(), fileName);
                    if (success) {
                        session.setAttribute("tempSuccess", "Gửi yêu cầu xác minh sinh viên thành công! Vui lòng chờ nhân viên duyệt.");
                    } else {
                        session.setAttribute("tempError", "Có lỗi xảy ra khi lưu thông tin vào cơ sở dữ liệu. Vui lòng thử lại!");
                    }
                } else {
                    session.setAttribute("tempError", "Định dạng file không hợp lệ! Vui lòng tải lên file ảnh.");
                }
            } else {
                session.setAttribute("tempError", "Vui lòng chọn ảnh thẻ sinh viên để tải lên!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("tempError", "Lỗi tải ảnh: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/profile#student-verify");
    }
}

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Class: WarrantyImageServlet
 * Description: Servlet phụ trách đọc và phân phối các tập tin hình ảnh đính kèm hồ sơ bảo hành đã được tải lên server.
 * Ánh xạ tuyến đường (URL Mapping): /warranty-images/*
 * 
 * Created: 2026-06-26
 * Updated: 2026-07-23
 * Version: v1.3
 *
 * @author DuyLD
 */
@WebServlet("/warranty-images/*")
public class WarrantyImageServlet extends HttpServlet {


    // Thư mục lưu trữ tệp hình ảnh tải lên của bảo hành (Mặc định ở thư mục người dùng user.home/uploads/warranty)
    private static final String UPLOAD_DIR = System.getProperty("warranty.upload.dir",
            System.getProperty("user.home") + File.separator + "uploads" + File.separator + "warranty");

    /**
     * Xử lý yêu cầu GET để đọc tệp ảnh từ ổ đĩa và trả về dưới dạng luồng dữ liệu HTTP với Content-Type tương ứng.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Ngăn chặn các cuộc tấn công đường dẫn Path Traversal (truy cập trái phép vào tập tin hệ thống)
        if (pathInfo.contains("..") || pathInfo.contains("WEB-INF") || pathInfo.contains("META-INF")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Path imagePath = Paths.get(UPLOAD_DIR, pathInfo);
        File file = imagePath.toFile();

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Xác định MIME Content Type dựa vào định dạng tệp ảnh (.png, .jpg, .jpeg...)
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        // Thiết lập bộ nhớ đệm Cache-Control cho trình duyệt (tối đa 1 ngày)
        response.setHeader("Cache-Control", "public, max-age=86400");

        // Sao chép luồng dữ liệu từ tệp tin sang HTTP ServletOutputStream để ghi ra Client
        Files.copy(imagePath, response.getOutputStream());
    }
}


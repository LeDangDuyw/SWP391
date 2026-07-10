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
 * WarrantyImageServlet serves the uploaded warranty claim images.
 * Maps to /warranty-images/*
 */
@WebServlet("/warranty-images/*")
public class WarrantyImageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = System.getProperty("warranty.upload.dir",
            System.getProperty("user.home") + File.separator + "uploads" + File.separator + "warranty");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Prevent path traversal attacks
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

        // Determine content type
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        // Cache header (1 day)
        response.setHeader("Cache-Control", "public, max-age=86400");

        // Stream file content to response output stream
        Files.copy(imagePath, response.getOutputStream());
    }
}

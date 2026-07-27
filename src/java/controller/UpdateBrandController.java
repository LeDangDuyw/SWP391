/*
 * Name: UpdateBrandController.java
 * @Author: HuyDQHE204239
 * Date: [27/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc cập nhật/sửa tên thương hiệu (Brand) qua AJAX.
 */
package controller;

import dal.BrandDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff/brand/update")
public class UpdateBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String brandIdStr = request.getParameter("brandId");
        String brandName = request.getParameter("brandName");
        
        if (brandIdStr == null || brandIdStr.trim().isEmpty() || brandName == null || brandName.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Thông tin mã và tên thương hiệu không được để trống!\"}");
            return;
        }
        
        int brandId;
        try {
            brandId = Integer.parseInt(brandIdStr.trim());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Mã thương hiệu không hợp lệ!\"}");
            return;
        }
        
        BrandDao brandDAO = new BrandDao();
        
        // Kiểm tra xem tên thương hiệu mới có bị trùng với thương hiệu khác không
        if (brandDAO.isBrandExist(brandName.trim())) {
            out.print("{\"success\":false,\"message\":\"Tên thương hiệu này đã tồn tại trong hệ thống!\"}");
            return;
        }
        
        boolean updated = brandDAO.updateBrand(brandId, brandName.trim());
        if (updated) {
            out.print("{\"success\":true,\"id\":" + brandId + ",\"name\":\"" + brandName.trim().replace("\"", "\\\"") + "\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể cập nhật thương hiệu!\"}");
        }
    }
}

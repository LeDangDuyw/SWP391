/*
 * Name: DeleteBrandController.java
 * @Author: HuyDQHE204239
 * Date: [27/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc xóa thương hiệu (Brand) qua AJAX có kiểm tra ràng buộc sản phẩm.
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

@WebServlet("/staff/brand/delete")
public class DeleteBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String brandIdStr = request.getParameter("brandId");
        
        if (brandIdStr == null || brandIdStr.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Vui lòng chọn thương hiệu cần xóa!\"}");
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
        
        // Kiểm tra xem thương hiệu có sản phẩm nào không
        int productCount = brandDAO.getProductCountByBrand(brandId);
        if (productCount > 0) {
            out.print("{\"success\":false,\"message\":\"Không thể xóa thương hiệu này vì đang có " + productCount + " sản phẩm liên kết!\"}");
            return;
        }
        
        boolean deleted = brandDAO.deleteBrand(brandId);
        if (deleted) {
            out.print("{\"success\":true,\"id\":" + brandId + "}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể xóa thương hiệu!\"}");
        }
    }
}

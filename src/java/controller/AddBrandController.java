/*
 * Name: AddBrandController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc thêm nhanh thương hiệu (Brand) mới qua AJAX.
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

@WebServlet("/staff/brand/add")
public class AddBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String brandName = request.getParameter("brandName");
        
        if (brandName == null || brandName.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Tên thương hiệu không được để trống!\"}");
            return;
        }
        
        BrandDao brandDAO = new BrandDao();
        if (brandDAO.isBrandExist(brandName)) {
            out.print("{\"success\":false,\"message\":\"Thương hiệu này đã tồn tại trong hệ thống!\"}");
            return;
        }
        
        int newId = brandDAO.insertBrand(brandName);
        if (newId != -1) {
            out.print("{\"success\":true,\"id\":" + newId + ",\"name\":\"" + brandName.trim().replace("\"", "\\\"") + "\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể thêm thương hiệu!\"}");
        }
    }
}

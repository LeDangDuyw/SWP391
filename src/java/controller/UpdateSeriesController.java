/*
 * Name: UpdateSeriesController.java
 * @Author: HuyDQHE204239
 * Date: [27/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc cập nhật/sửa tên dòng sản phẩm (ProductSeries) qua AJAX.
 */
package controller;

import dal.ProductSeriesDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff/series/update")
public class UpdateSeriesController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String seriesIdStr = request.getParameter("seriesId");
        String seriesName = request.getParameter("seriesName");
        String brandIdStr = request.getParameter("brandId");
        
        if (seriesIdStr == null || seriesIdStr.trim().isEmpty() || seriesName == null || seriesName.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Mã dòng sản phẩm và tên mới không được để trống!\"}");
            return;
        }
        
        int seriesId;
        int brandId = 0;
        try {
            seriesId = Integer.parseInt(seriesIdStr.trim());
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                brandId = Integer.parseInt(brandIdStr.trim());
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Dữ liệu mã số không hợp lệ!\"}");
            return;
        }
        
        ProductSeriesDAO seriesDAO = new ProductSeriesDAO();
        
        // Kiểm tra xem tên dòng sản phẩm mới có trùng trong thương hiệu hay không
        if (brandId > 0 && seriesDAO.isSeriesExist(seriesName.trim(), brandId)) {
            out.print("{\"success\":false,\"message\":\"Dòng sản phẩm tên này đã tồn tại thuộc thương hiệu này!\"}");
            return;
        }
        
        boolean updated = seriesDAO.updateSeries(seriesId, seriesName.trim());
        if (updated) {
            out.print("{\"success\":true,\"id\":" + seriesId + ",\"name\":\"" + seriesName.trim().replace("\"", "\\\"") + "\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể cập nhật dòng sản phẩm!\"}");
        }
    }
}

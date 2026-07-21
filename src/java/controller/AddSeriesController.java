/*
 * Name: AddSeriesController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc thêm nhanh dòng sản phẩm (Product Series) mới qua AJAX.
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

@WebServlet("/staff/series/add")
public class AddSeriesController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String seriesName = request.getParameter("seriesName");
        String brandIdStr = request.getParameter("brandId");
        
        if (seriesName == null || seriesName.trim().isEmpty() || brandIdStr == null || brandIdStr.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Tên dòng sản phẩm và Thương hiệu không được để trống!\"}");
            return;
        }
        
        int brandId;
        try {
            brandId = Integer.parseInt(brandIdStr.trim());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Thương hiệu không hợp lệ!\"}");
            return;
        }
        
        ProductSeriesDAO seriesDAO = new ProductSeriesDAO();
        if (seriesDAO.isSeriesExist(seriesName, brandId)) {
            out.print("{\"success\":false,\"message\":\"Dòng sản phẩm này đã tồn tại trong thương hiệu này!\"}");
            return;
        }
        
        int newId = seriesDAO.insertSeries(seriesName, brandId);
        if (newId != -1) {
            out.print("{\"success\":true,\"id\":" + newId + ",\"name\":\"" + seriesName.trim().replace("\"", "\\\"") + "\",\"brandId\":" + brandId + "}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể thêm dòng sản phẩm!\"}");
        }
    }
}

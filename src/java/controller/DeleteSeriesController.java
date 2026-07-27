/*
 * Name: DeleteSeriesController.java
 * @Author: HuyDQHE204239
 * Date: [27/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc xóa dòng sản phẩm (ProductSeries) qua AJAX có kiểm tra ràng buộc sản phẩm.
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

@WebServlet("/staff/series/delete")
public class DeleteSeriesController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String seriesIdStr = request.getParameter("seriesId");
        
        if (seriesIdStr == null || seriesIdStr.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Vui lòng chọn dòng sản phẩm cần xóa!\"}");
            return;
        }
        
        int seriesId;
        try {
            seriesId = Integer.parseInt(seriesIdStr.trim());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Mã dòng sản phẩm không hợp lệ!\"}");
            return;
        }
        
        ProductSeriesDAO seriesDAO = new ProductSeriesDAO();
        
        // Kiểm tra xem dòng sản phẩm có sản phẩm nào không
        int productCount = seriesDAO.getProductCountBySeries(seriesId);
        if (productCount > 0) {
            out.print("{\"success\":false,\"message\":\"Không thể xóa dòng sản phẩm này vì đang có " + productCount + " sản phẩm liên kết!\"}");
            return;
        }
        
        boolean deleted = seriesDAO.deleteSeries(seriesId);
        if (deleted) {
            out.print("{\"success\":true,\"id\":" + seriesId + "}");
        } else {
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống, không thể xóa dòng sản phẩm!\"}");
        }
    }
}

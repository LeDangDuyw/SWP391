/*
 * Name: SerialManagement.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller quản lý và thống kê danh sách mã Serial Number sản phẩm trong kho.
 */
package controller;

import dal.SerialDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryItem;

@WebServlet("/staff/imei")
public class SerialManagement extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Lấy và hiển thị danh sách các mã Serial (Inventory Item) trong kho.
     * Hàm này hỗ trợ tính năng tìm kiếm (theo mã Serial hoặc tên sản phẩm), lọc theo trạng thái
     * (in_stock, sold, defection, v.v.), và thực hiện phân trang (pagination).
     * Đồng thời, lấy các con số thống kê (tổng số, số lượng tồn kho, số lượng đã bán) để hiển thị Dashboard.
     * 
     * @param request  đối tượng HttpServletRequest chứa các tham số search, status, page
     * @param response đối tượng HttpServletResponse để điều hướng về trang JSP
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchInput = request.getParameter("searchInput");
        String statusFilter = request.getParameter("status");
        
        if (statusFilter == null) statusFilter = "All";
        
        int page = 1;
        int pageSize = 10;
        
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        SerialDAO dao = new SerialDAO();
        
        int offset = (page - 1) * pageSize;
        
        List<InventoryItem> items = dao.getInventoryItems(searchInput, statusFilter, offset, pageSize);
        int totalItems = dao.getTotalInventoryItemsCount(searchInput, statusFilter);
        int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / pageSize) : 1;
        
        // Get Statistics
        int totalUnits = dao.getCountByStatus(null);
        int inStockUnits = dao.getCountByStatus("in_stock");
        int soldUnits = dao.getCountByStatus("sold");
        
        request.setAttribute("items", items);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("searchInput", searchInput);
        request.setAttribute("statusFilter", statusFilter);
        
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("inStockUnits", inStockUnits);
        request.setAttribute("soldUnits", soldUnits);
        
        request.getRequestDispatcher("/staff/SerialManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

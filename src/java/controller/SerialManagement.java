/*
 * Name: SerialManagement
 * @Author: HuyDQ
 * Date: [05/06/2026]
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

@WebServlet(name = "SerialManagement", urlPatterns = { "/staff/serial", "/staff/imei" })
public class SerialManagement extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchInput = request.getParameter("searchInput");
        String statusFilter = request.getParameter("status");
        
        if(statusFilter == null) statusFilter = "All";
        
        int page = 1;
        int pageSize = 10;
        
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        SerialDAO dao = new SerialDAO();
        
        int offset = (page - 1) * pageSize;
        
        List<InventoryItem> items = dao.getInventoryItems(searchInput, statusFilter, offset, pageSize);
        int totalItems = dao.getTotalInventoryItemsCount(searchInput, statusFilter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
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
        // Handle adding new Serial or bulk import if needed
    }

}

package controller;

import dal.ImeiDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryItem;

@WebServlet("/staff/imei")
public class ImeiManagement extends HttpServlet {

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
        
        ImeiDAO dao = new ImeiDAO();
        
        int offset = (page - 1) * pageSize;
        
        List<InventoryItem> items = dao.getInventoryItems(searchInput, statusFilter, offset, pageSize);
        int totalItems = dao.getTotalInventoryItemsCount(searchInput, statusFilter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Get Statistics
        int totalUnits = dao.getCountByStatus(null);
        int availableUnits = dao.getCountByStatus("Available");
        int soldUnits = dao.getCountByStatus("Sold");
        int faultyUnits = dao.getCountByStatus("Damaged"); // Assuming "Damaged" is faulty
        
        request.setAttribute("items", items);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("searchInput", searchInput);
        request.setAttribute("statusFilter", statusFilter);
        
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("availableUnits", availableUnits);
        request.setAttribute("soldUnits", soldUnits);
        request.setAttribute("faultyUnits", faultyUnits);
        
        request.getRequestDispatcher("/staff/ImeiManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle adding new IMEI or bulk import if needed
    }

}

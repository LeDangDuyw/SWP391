package controller;

import dal.CategoryDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;

@WebServlet("/staff/category")
public class CategoryManagementController extends HttpServlet {

    /*
     * Name: doGet
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu GET để hiển thị danh sách Category có phân trang và tìm kiếm.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchInput = request.getParameter("searchInput");
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int pageSize = 10;
        CategoryDAO categoryDAO = new CategoryDAO();
        int totalCategories = categoryDAO.getTotalCategoryCount(searchInput);
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
        
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        int offset = (page - 1) * pageSize;
        
        List<Category> categories = categoryDAO.getCategoriesPaginated(searchInput, offset, pageSize);
        
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/staff/CategoryManagement.jsp").forward(request, response);
    }

    /*
     * Name: doPost
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu POST để thêm mới, cập nhật hoặc xóa danh mục (Category).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CategoryDAO categoryDAO = new CategoryDAO();
        
        try {
            if ("add".equals(action)) {
                String categoryName = request.getParameter("categoryName");
                if (categoryName != null && !categoryName.trim().isEmpty()) {
                    categoryDAO.insertCategory(categoryName.trim());
                }
            } else if ("update".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String categoryName = request.getParameter("categoryName");
                if (categoryName != null && !categoryName.trim().isEmpty()) {
                    categoryDAO.updateCategory(categoryId, categoryName.trim());
                }
            } else if ("delete".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryIdToDelete"));
                categoryDAO.deleteCategory(categoryId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Preserve search input if present
        String searchInput = request.getParameter("searchInput");
        String redirectUrl = request.getContextPath() + "/staff/category";
        if (searchInput != null && !searchInput.isEmpty()) {
            redirectUrl += "?searchInput=" + java.net.URLEncoder.encode(searchInput, "UTF-8");
        }
        
        response.sendRedirect(redirectUrl);
    }
}

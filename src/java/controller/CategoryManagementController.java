/*
 * Name: CategoryManagementController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller quản lý danh mục sản phẩm (thêm, sửa, xóa, tìm kiếm và phân trang Category).
 */
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
        String action = request.getParameter("action");
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("getSpecs".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            List<model.CategorySpecification> specs = categoryDAO.getSpecificationsByCategoryId(categoryId);
            List<model.Specification> masterSpecs = categoryDAO.getAllMasterSpecifications();
            
            StringBuilder json = new StringBuilder("{");
            json.append("\"categorySpecs\":[");
            for (int i = 0; i < specs.size(); i++) {
                model.CategorySpecification cs = specs.get(i);
                json.append(String.format("{\"specId\":%d,\"specName\":\"%s\"}", cs.getSpecificationId(), escapeJson(cs.getSpecificationName())));
                if (i < specs.size() - 1) json.append(",");
            }
            json.append("],\"masterSpecs\":[");
            for (int i = 0; i < masterSpecs.size(); i++) {
                model.Specification s = masterSpecs.get(i);
                json.append(String.format("{\"specId\":%d,\"specName\":\"%s\"}", s.getSpecificationId(), escapeJson(s.getSpecificationName())));
                if (i < masterSpecs.size() - 1) json.append(",");
            }
            json.append("]}");
            response.getWriter().write(json.toString());
            return;
        } else if ("getVariantSpecs".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                List<model.VariantSpecification> list = new dal.ProductDAO().getVariantSpecifications(variantId);
                StringBuilder json = new StringBuilder("{\"specs\":{");
                for (int i = 0; i < list.size(); i++) {
                    model.VariantSpecification vs = list.get(i);
                    json.append(String.format("\"%d\":\"%s\"", vs.getSpecificationId(), escapeJson(vs.getValue())));
                    if (i < list.size() - 1) json.append(",");
                }
                json.append("}}");
                response.getWriter().write(json.toString());
            } catch (Exception e) {
                response.getWriter().write("{\"specs\":{}}");
            }
            return;
        }

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
        int totalCategories = categoryDAO.getTotalCategoryCount(searchInput);
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
        
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        int offset = (page - 1) * pageSize;
        
        List<Category> categories = categoryDAO.getCategoriesPaginated(searchInput, offset, pageSize);
        
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchInput", searchInput);
        
        request.getRequestDispatcher("/staff/CategoryManagement.jsp").forward(request, response);
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
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
            // ĐOẠN 1: Thêm mới danh mục sản phẩm (Action "add")
            // Nhiệm vụ: Check trùng tên bằng isCategoryExist() tại [dal/CategoryDAO.java] trước khi chèn vào bảng Category
            if ("add".equals(action)) {
                String categoryName = request.getParameter("categoryName");
                if (categoryName != null && !categoryName.trim().isEmpty()) {
                    if (categoryDAO.isCategoryExist(categoryName.trim(), -1)) {
                        request.setAttribute("errorMessage", "Tên danh mục đã tồn tại.");
                        doGet(request, response);
                        return;
                    }
                    categoryDAO.insertCategory(categoryName.trim());
                }
            // ĐOẠN 2: Cập nhật tên danh mục sản phẩm (Action "update")
            // Nhiệm vụ: Check trùng tên với các danh mục khác (trừ chính nó) trước khi chạy lệnh UPDATE
            } else if ("update".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String categoryName = request.getParameter("categoryName");
                if (categoryName != null && !categoryName.trim().isEmpty()) {
                    if (categoryDAO.isCategoryExist(categoryName.trim(), categoryId)) {
                        request.setAttribute("errorMessage", "Tên danh mục đã tồn tại.");
                        doGet(request, response);
                        return;
                    }
                    categoryDAO.updateCategory(categoryId, categoryName.trim());
                }
            // ĐOẠN 3: Gán thuộc tính thông số kỹ thuật cho danh mục (Action "addCategorySpec")
            // Nhiệm vụ: Chèn bản ghi liên kết vào bảng CategorySpecification để quy định các thuộc tính cấu hình cho dòng máy này
            } else if ("addCategorySpec".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int specId = Integer.parseInt(request.getParameter("specId"));
                categoryDAO.addSpecificationToCategory(categoryId, specId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true}");
                return;
            // ĐOẠN 4: Hủy thuộc tính thông số kỹ thuật khỏi danh mục (Action "removeCategorySpec")
            // Nhiệm vụ: Xóa bản ghi trong bảng CategorySpecification
            } else if ("removeCategorySpec".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int specId = Integer.parseInt(request.getParameter("specId"));
                categoryDAO.removeSpecificationFromCategory(categoryId, specId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true}");
                return;
            // ĐOẠN 5: Tạo mới thuộc tính Master Spec và gán cho Danh mục (Action "addMasterSpec")
            // Nhiệm vụ: Thêm tên thông số vào bảng Specification và gán ngay cho Category
            } else if ("addMasterSpec".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String specName = request.getParameter("specName");
                if (specName != null && !specName.trim().isEmpty()) {
                    int newSpecId = categoryDAO.addMasterSpecification(specName.trim());
                    if (newSpecId > 0) {
                        categoryDAO.addSpecificationToCategory(categoryId, newSpecId);
                    }
                }
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true}");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
            return;
        }
        
        // 🎯 ĐOẠN 6: Điều hướng về trang danh sách Quản lý danh mục [/staff/category] rendering [web/staff/CategoryManagement.jsp]
        String searchInput = request.getParameter("searchInput");
        String redirectUrl = request.getContextPath() + "/staff/category";
        if (searchInput != null && !searchInput.isEmpty()) {
            redirectUrl += "?searchInput=" + java.net.URLEncoder.encode(searchInput, "UTF-8");
        }
        
        response.sendRedirect(redirectUrl);
    }
}

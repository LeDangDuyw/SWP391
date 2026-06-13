/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;
import viewmodel.ProductInventory;

/**
 *
 * @author huy
 */
@WebServlet("/staff/inventory")
public class InventoryListController extends HttpServlet {

    /*
     * Name: doGet
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Xử lý GET — load dữ liệu cho cả hai tab (Products và Variants),
     *              hỗ trợ tìm kiếm, sắp xếp, lọc stock status và phân trang độc lập cho từng tab.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();

        // ── Các tham số chung ────────────────────────────────────────────────
        String tab         = request.getParameter("tab");
        String searchInput = request.getParameter("searchInput");
        String sortBy      = request.getParameter("sortBy");
        String category    = request.getParameter("category");
        String stockStatus = request.getParameter("stockStatus");

        if (tab == null || tab.isEmpty()) tab = "products";

        int pageSize = 10;

        // ════════════════════════════════════════════════════════════════════
        // Tab PRODUCTS — phân trang riêng
        // ════════════════════════════════════════════════════════════════════
        int pageP = 1;
        String pageParamP = request.getParameter("page");
        // Chỉ đọc ?page khi đang ở tab products, hoặc khi param không rõ nguồn
        if (pageParamP != null && !pageParamP.isEmpty()) {
            try {
                pageP = Integer.parseInt(pageParamP);
                if (pageP < 1) pageP = 1;
            } catch (NumberFormatException e) {
                pageP = 1;
            }
        }

        int offsetP        = (pageP - 1) * pageSize;
        int totalRecordsP  = dao.getTotalProductCount(searchInput, category);
        int totalPagesP    = (int) Math.ceil((double) totalRecordsP / pageSize);
        if (totalPagesP == 0) totalPagesP = 1;

        List<Product> product = dao.GetProductsPaginated(searchInput, category, sortBy, offsetP, pageSize);

        request.setAttribute("product",             product);
        request.setAttribute("currentPageProduct",  pageP);
        request.setAttribute("totalPagesProduct",   totalPagesP);
        request.setAttribute("totalRecordsProduct", totalRecordsP);

        // ════════════════════════════════════════════════════════════════════
        // Tab VARIANTS — phân trang riêng
        // ════════════════════════════════════════════════════════════════════
        int pageV = 1;
        String pageParamV = request.getParameter("page");
        if (pageParamV != null && !pageParamV.isEmpty()) {
            try {
                pageV = Integer.parseInt(pageParamV);
                if (pageV < 1) pageV = 1;
            } catch (NumberFormatException e) {
                pageV = 1;
            }
        }

        int offsetV       = (pageV - 1) * pageSize;
        int totalRecordsV = dao.getTotalInventoryCount(searchInput, category, stockStatus);
        int totalPagesV   = (int) Math.ceil((double) totalRecordsV / pageSize);
        if (totalPagesV == 0) totalPagesV = 1;

        List<ProductInventory> products = dao.GetProductInventoryPaginated(
                searchInput, category, sortBy, stockStatus, offsetV, pageSize);

        request.setAttribute("products",      products);
        request.setAttribute("currentPage",   pageV);
        request.setAttribute("totalPages",    totalPagesV);
        request.setAttribute("totalRecords",  totalRecordsV);
        request.setAttribute("pageSize",      pageSize);

        // Chuyển sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff/InventoryManagement.jsp");
        dispatcher.forward(request, response);
    }

    /*
     * Name: doPost
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Xử lý POST — ẩn (xóa mềm) hoặc khôi phục một biến thể sản phẩm,
     *              sau đó redirect về trang danh sách giữ nguyên tab đang active.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao  = new ProductDAO();
        String action   = request.getParameter("action");
        String idParam  = request.getParameter("variantIdToDelete");
        String tab      = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "products";

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int variantId = Integer.parseInt(idParam);
                if ("delete".equals(action)) {
                    dao.hideProduct(variantId);
                } else if ("restore".equals(action)) {
                    dao.unhideProduct(variantId);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid variantId: " + idParam);
            }
        }

        // Redirect về đúng tab sau khi thao tác
        response.sendRedirect(request.getContextPath() + "/staff/inventory?tab=" + tab);
    }

    @Override
    public String getServletInfo() {
        return "Inventory List Controller v3.0";
    }
}
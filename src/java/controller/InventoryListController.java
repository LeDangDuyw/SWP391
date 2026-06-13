/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import viewmodel.ProductInventory;
/**
 *
 * @author huy
 */
@WebServlet("/staff/inventory")
public class InventoryListController extends HttpServlet {
       private final ProductDAO productDAO = new ProductDAO();
    private static final int PAGE_SIZE = 10;

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    /*
     * Name: processRequest
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý chung các yêu cầu HTTP (GET và POST), trả về mã HTML hiển thị thông tin mặc định của servlet.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InventoryListController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InventoryListController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    /*
     * Name: doGet
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu GET để hiển thị danh sách hàng tồn kho, hỗ trợ tìm kiếm, sắp xếp và phân trang.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         // 1. Đọc tab hiện tại (mặc định là "products")
        String tab = request.getParameter("tab");
        if (tab == null || (!tab.equals("products") && !tab.equals("variants"))) {
            tab = "products";
        }

        // 2. Đọc các param chung
        String search = request.getParameter("searchInput");
        if (search == null) search = "";
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null) sortBy = "all";

        // 3. Đọc số trang
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * PAGE_SIZE;

        if (tab.equals("products")) {
            // --- Tab Products ---
            List<Product> productList = productDAO.GetProductPaginated(
                    search, sortBy, offset, PAGE_SIZE);
            int total      = productDAO.getTotalProductCount(search);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;

            request.setAttribute("product",             productList);
            request.setAttribute("currentPageProduct",  page);
            request.setAttribute("totalPagesProduct",   totalPages);

        } else {
            // --- Tab Variants ---
            List<ProductInventory> variantList = productDAO.GetProductInventoryPaginated(
                    search, sortBy, offset, PAGE_SIZE);
            int total      = productDAO.getTotalInventoryCount(search);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;

            request.setAttribute("products",     variantList);
            request.setAttribute("currentPage",  page);
            request.setAttribute("totalPages",   totalPages);
        }

        // 4. Truyền tab xuống JSP để render đúng trạng thái
        request.setAttribute("activeTab", tab);

        // Chuyển tiếp request sang trang InventoryManagement.jsp để hiển thị
        RequestDispatcher dispatcher = request.getRequestDispatcher("/staff/InventoryManagement.jsp");
        dispatcher.forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    /*
     * Name: doPost
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu POST để thực hiện các thao tác ẩn (xóa mềm) hoặc khôi phục sản phẩm trong kho.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         String action          = request.getParameter("action");
        String variantIdStr    = request.getParameter("variantIdToDelete");
        String redirectTab     = request.getParameter("currentTab");
        if (redirectTab == null) redirectTab = "variants";

        if (variantIdStr != null) {
            int variantId = Integer.parseInt(variantIdStr);
            if ("delete".equals(action)) {
                productDAO.hideProduct(variantId);
            } else if ("restore".equals(action)) {
                productDAO.unhideProduct(variantId);
            }
        }        
        // Load lại trang danh sách sản phẩm sau khi thực hiện thao tác
        response.sendRedirect(request.getContextPath() + "/staff/inventory");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    /*
     * Name: getServletInfo
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Trả về thông tin ngắn gọn mô tả về servlet này.
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
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
public class InventoryListController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        
        // Lấy từ khóa tìm kiếm và tiêu chí sắp xếp từ request
        String searchInput = request.getParameter("searchInput");
        String sortBy = request.getParameter("sortBy");
        
        // Khởi tạo các biến dùng cho chức năng phân trang
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                // Ép kiểu số trang hiện tại
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Tính toán vị trí bắt đầu lấy dữ liệu (offset) và tổng số trang
        int offset = (page - 1) * pageSize;
        int totalRecords = dao.getTotalInventoryCount(searchInput);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Lấy danh sách sản phẩm đã được phân trang và lọc từ CSDL
        products = dao.GetProductInventoryPaginated(searchInput, sortBy, offset, pageSize);
        
        // Đưa các thông số phân trang và dữ liệu sản phẩm lên view (JSP)
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);
        
        // Chuyển tiếp request sang trang InventoryManagement.jsp để hiển thị
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/InventoryManagement.jsp");
        dispatcher.forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        // Kiểm tra xem hành động người dùng gửi lên là gì (xóa hay khôi phục)
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            // Xử lý ẩn (xóa mềm) sản phẩm
            String variantIdToHide = request.getParameter("variantIdToDelete");
            if (variantIdToHide != null && !variantIdToHide.isEmpty()) {
                int v = Integer.parseInt(variantIdToHide);
                dao.hideProduct(v);
            }
        }else if("restore".equals(action)) {
            // Xử lý khôi phục lại sản phẩm đã ẩn
            String variantIdToHide = request.getParameter("variantIdToDelete");
            if (variantIdToHide != null && !variantIdToHide.isEmpty()) {
                int v = Integer.parseInt(variantIdToHide);
                dao.unhideProduct(v);
            }
        }
        
        // Load lại trang danh sách sản phẩm sau khi thực hiện thao tác
        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

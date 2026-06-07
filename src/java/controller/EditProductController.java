/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.BrandDao;
import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Brand;
import model.Category;
import model.Product;
import model.ProductVariant;

/**
 *
 * @author huy
 */
@WebServlet("/staff/inventory/edit")
public class EditProductController extends HttpServlet {
   
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
            out.println("<title>Servlet EditProductController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProductController at " + request.getContextPath () + "</h1>");
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
     * Description: Xử lý yêu cầu GET để chuyển hướng người dùng sang trang giao diện sửa thông tin sản phẩm (EditProduct.jsp).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Chuyển hướng người dùng sang trang giao diện sửa sản phẩm (EditProduct.jsp)
        // Lưu ý: Cần bổ sung logic lấy thông tin sản phẩm từ CSDL trước khi forward
        ProductDAO productDAO = new ProductDAO();
        int variantId = parseInt(request.getParameter("variantId"), 1);

        Product product = productDAO.getProductByVariantId(variantId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;
        }

        List<ProductVariant> variants = productDAO.getProductVariantsByProductId(product.getProductId());
        List<Category> categories = new CategoryDAO().getAllCategories();
        List<Brand> brands = new BrandDao().getAllBrands();

        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("selectedVariantId", variantId);
        request.getRequestDispatcher("/staff/EditProduct.jsp").forward(request, response);
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
     * Description: Xử lý yêu cầu POST bằng cách gọi hàm processRequest.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateVariant".equals(action)) {
            try {
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                String sku = request.getParameter("sku");
                String variantName = request.getParameter("variantName");
                java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                
                dal.ProductDAO dao = new dal.ProductDAO();
                dao.updateProductVariant(variantId, sku, variantName, price, stock);
                response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantId);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;
        }
        processRequest(request, response);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.trim().isEmpty() ? defaultValue : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
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

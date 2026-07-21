/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.BrandDao;
import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ProductSeriesDAO;
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

/*
 * Name: EditProductController
 * @Author: HUYDQHE204239
 * Date: [04/06/2026]
 * Version: 2.0
 * Description: Controller quản lý giao diện và thực hiện cập nhật thông tin sản phẩm cùng biến thể (RAM/SSD/Giá)
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
        // Khởi tạo ProductDAO để đọc thông tin từ database
        ProductDAO productDAO = new ProductDAO();
        // Lấy mã định danh biến thể sản phẩm từ request
        int variantId = parseInt(request.getParameter("variantId"), 1);

        // Lấy chi tiết thông tin sản phẩm dựa trên mã biến thể
        Product product = productDAO.getProductByVariantId(variantId);
        if (product == null) {
            // Nếu không tìm thấy sản phẩm, chuyển hướng về trang quản lý kho
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;
        }

        // Đọc danh sách các biến thể liên quan của sản phẩm, danh mục, thương hiệu và dòng máy
        List<ProductVariant> variants = productDAO.getProductVariantsByProductId(product.getProductId());
        List<Category> categories = new CategoryDAO().getAllCategories();
        List<Brand> brands = new BrandDao().getAllBrands();
        List<model.ProductSeries> serieses = new ProductSeriesDAO().getAllSeries();

        // Đặt thuộc tính truyền sang giao diện EditProduct.jsp
        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("serieses", serieses);
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
        
        // Nhánh xử lý cập nhật thông tin một biến thể sản phẩm cụ thể (SKU, tên, giá bán)
        if ("updateVariant".equals(action)) {
            try {
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                String sku = request.getParameter("sku");
                String variantName = request.getParameter("variantName");
                java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
                
                dal.ProductDAO dao = new dal.ProductDAO();
                // Thực thi câu lệnh SQL cập nhật thông tin biến thể
                dao.updateProductVariant(variantId, sku, variantName, price);
                // Quay lại trang chỉnh sửa với tham số variantId vừa cập nhật
                response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantId);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;
        } 
        
        // Nhánh xử lý cập nhật các thông số chung của sản phẩm gốc (Tên, danh mục, hãng, mô tả, bảo hành, dòng máy)
        else if ("updateProduct".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                String productName = request.getParameter("productName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                String description = request.getParameter("description");
                String warrantyPeriodStr = request.getParameter("warrantyPeriod");
                String purpose = request.getParameter("purposeSelect");
                // Hỗ trợ điền mục đích sử dụng tùy chỉnh khác
                if ("Khác".equals(purpose)) {
                    purpose = request.getParameter("purposeCustom");
                }
                String seriesIdStr = request.getParameter("seriesId");
                
                int warrantyPeriod = 0;
                if (warrantyPeriodStr != null && !warrantyPeriodStr.trim().isEmpty()) {
                    warrantyPeriod = Integer.parseInt(warrantyPeriodStr.trim());
                }
                
                int seriesId = 0;
                if (seriesIdStr != null && !seriesIdStr.trim().isEmpty()) {
                    seriesId = Integer.parseInt(seriesIdStr.trim());
                }
                
                dal.ProductDAO dao = new dal.ProductDAO();
                // Thực thi câu lệnh SQL cập nhật các thuộc tính chung của sản phẩm
                dao.updateProduct(productId, productName, categoryId, brandId, description, warrantyPeriod, purpose, seriesId);
                // Quay về trang quản lý kho chung sau khi cập nhật thành công
                response.sendRedirect(request.getContextPath() + "/staff/inventory");
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
        // Chuyển đổi an toàn chuỗi số nguyên sang kiểu int, trả về defaultValue nếu xảy ra lỗi
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

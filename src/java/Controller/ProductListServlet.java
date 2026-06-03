/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;
import dal.BrandDao;
import dal.ProductSeriesDao;

/**
 *
 * @author Cao Tuấn Minh
 */
public class ProductListServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ProductListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductListServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO p = new ProductDAO();
        BrandDao b = new BrandDao();
        
        String search = request.getParameter("search"); 
        String category = request.getParameter("category");
        
        Integer categoryId = null;
        if (category != null && !category.isEmpty()) {
            try {
                categoryId = Integer.parseInt(category);
            } catch (NumberFormatException e) {
            }
        }
      
        if (search != null && !search.trim().isEmpty()) {
            dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
            String cleanSearch = search.trim().toLowerCase();

            Integer detectedCategoryId = categoryDAO.getCategoryIdByName(cleanSearch);

            if (detectedCategoryId == null) {
                if (cleanSearch.contains("mouse") || cleanSearch.contains("chuột")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Chuột");
                } else if (cleanSearch.contains("keyboard") || cleanSearch.contains("bàn phím") || cleanSearch.contains("phím")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Bàn phím");
                } else if (cleanSearch.contains("laptop") || cleanSearch.contains("máy tính")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Laptop");
                }
            }
            if (detectedCategoryId == null) {
                Integer prodCategoryId = p.getCategoryIdByProductSearch(search.trim());
                if (prodCategoryId != null) {
                    detectedCategoryId = prodCategoryId;
                }
            }

            if (detectedCategoryId != null) {
                categoryId = detectedCategoryId;
            }
        }
        
        if (categoryId == null) {
            response.sendRedirect("HomeServlet");
            return;
        }
        
        String brand = request.getParameter("brand");
        String series = request.getParameter("series");
        String purpose = request.getParameter("purpose");
        String cpu = request.getParameter("cpu");
        String ram = request.getParameter("ram");
        String ssd = request.getParameter("ssd");
        String gpu = request.getParameter("gpu");
        String screen = request.getParameter("screen");
        String price = request.getParameter("price");
        String sort = request.getParameter("sort");

        String connectivity = request.getParameter("connectivity");
        String switchType = request.getParameter("switch");
        String dpi = request.getParameter("dpi");

        int page = 1;
        int pageSize = 6; 
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {}
        }
        
        Integer brandId = null;
        Integer seriesId = null;
        
        //
        if (brand != null && !brand.isEmpty()) {
            brandId = Integer.parseInt(brand);
        }
        if (series != null && !series.isEmpty()) {
            seriesId = Integer.parseInt(series);
        }
        // lấy series laptop
        if (categoryId == 1) { 
            ProductSeriesDao s = new ProductSeriesDao();
            if (brandId != null) {
                request.setAttribute("serieses",s.getSeriesByBrand(brandId) );
           }
        }
        // Lấy danh sách sản phẩm và lọc 
        int totalProducts = p.countFilteredLaptop(categoryId, brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, search, connectivity, switchType, dpi);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("products", p.filterLaptop(categoryId, brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, sort, page, pageSize, search, connectivity, switchType, dpi));
        // hiển thị brand
        request.setAttribute("brands", b.getBrandsByCategory(categoryId));
        // hiển thị danh mục 
        request.setAttribute("categoryId", categoryId);
        dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("customer/product_list.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

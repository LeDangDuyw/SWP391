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
import dal.CategoryDAO;
import dal.ProductListFilterDAO;
import dal.ProductSeriesDAO;

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
        ProductListFilterDAO ProductListFilterDAO = new ProductListFilterDAO();
        ProductDAO productDAO = new ProductDAO();
        BrandDao brandDao = new BrandDao();
        CategoryDAO categoryDAO = new CategoryDAO();

        // xác định danh mục tìm kiếm 
        String search = request.getParameter("search");
        String category = request.getParameter("category");

        Integer categoryId = null;
        if (category != null && !category.isEmpty()) {
            try {
                categoryId = Integer.parseInt(category);
            } catch (NumberFormatException ignored) {
            }
        }

        // Detect category từ keyword search
        if (search != null && !search.trim().isEmpty()) {
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
                Integer prodCategoryId = productDAO.getCategoryIdByProductSearch(search.trim());
                if (prodCategoryId != null) {
                    detectedCategoryId = prodCategoryId;
                }
            }
            if (detectedCategoryId != null) {
                categoryId = detectedCategoryId;
            }
        }

        // ── Global search — không xác định được category ────────────────────
        if (categoryId == null && search != null && !search.trim().isEmpty()) {
            int page = 1, pageSize = 12;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
            } catch (Exception ignored) {
            }

            int totalProducts = productDAO.countSearchAllProducts(search.trim());
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            request.setAttribute("products", productDAO.searchAllProducts(search.trim(), page, pageSize));
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("globalSearch", true);
            request.setAttribute("searchKeyword", search.trim());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("customer/product_list.jsp").forward(request, response);
            return;
        }

        // ── Không có category → về Home ─────────────────────────────────────
        if (categoryId == null) {
            response.sendRedirect("HomeServlet");
            return;
        }

        // ── Đọc params chung ─────────────────────────────────────────────────
        String brand = request.getParameter("brand");
        String price = request.getParameter("price");
        String sort = request.getParameter("sort");
        String purpose = request.getParameter("purpose");
        String connectivity = request.getParameter("connectivity");

        int page = 1, pageSize = 9;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception ignored) {
        }

        Integer brandId = null;
        if (brand != null && !brand.isEmpty()) {
            try {
                brandId = Integer.parseInt(brand);
            } catch (NumberFormatException ignored) {
            }
        }

        // ── Filter theo category ─────────────────────────────────────────────
        int totalProducts;

        switch (categoryId) {
            case 1 -> {
                // Laptop
                String series = request.getParameter("series");
                String cpu = request.getParameter("cpu");
                String ram = request.getParameter("ram");
                String ssd = request.getParameter("ssd");
                String gpu = request.getParameter("gpu");
                String screen = request.getParameter("screen");

                Integer seriesId = null;
                if (series != null && !series.isEmpty()) {
                    try {
                        seriesId = Integer.parseInt(series);
                    } catch (NumberFormatException ignored) {
                    }
                }

                // Lấy series theo brand để hiển thị sidebar
                if (brandId != null) {
                    request.setAttribute("serieses", new ProductSeriesDAO().getSeriesByBrand(brandId));
                }

                // Sử dụng thông số kỹ thuật tĩnh cho bộ lọc tổng quát
                totalProducts = productDAO.countFilteredLaptop(categoryId, brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, search, null, null, null);
                request.setAttribute("products", ProductListFilterDAO.filterLaptop(brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, sort, page, pageSize, search));
            }
            case 3 -> {
                // Keyboard
                String switchType = request.getParameter("switch");

                // Sử dụng thông số kỹ thuật tĩnh cho bộ lọc tổng quát
                totalProducts = ProductListFilterDAO.countFilteredKeyboard(brandId, purpose, connectivity, switchType, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterKeyboard(brandId, purpose, connectivity, switchType, price, sort, page, pageSize, search));
            }
            case 4 -> {
                // Mouse
                String dpi = request.getParameter("dpi");

                // Sử dụng thông số kỹ thuật tĩnh cho bộ lọc tổng quát
                totalProducts = ProductListFilterDAO.countFilteredMouse(brandId, purpose, connectivity, dpi, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterMouse(brandId, purpose, connectivity, dpi, price, sort, page, pageSize, search));
            }
            default -> {
                totalProducts = ProductListFilterDAO.countFilteredGeneral(categoryId, brandId, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterGeneral(categoryId, brandId, price, sort, page, pageSize, search));
            }
        }

        // ── Phân trang & attributes chung ────────────────────────────────────
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("brands", brandDao.getBrandsByCategory(categoryId));
        request.setAttribute("categoryId", categoryId);
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

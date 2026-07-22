/*
 * Name: ProductListServlet.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Servlet xử lý hiển thị danh sách sản phẩm và bộ lọc sản phẩm cho khách hàng.
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
        // Khởi tạo các đối tượng truy cập dữ liệu (DAO) cần thiết cho việc lọc và hiển thị sản phẩm
        ProductListFilterDAO ProductListFilterDAO = new ProductListFilterDAO();
        ProductDAO productDAO = new ProductDAO();
        BrandDao brandDao = new BrandDao();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Đọc các tham số tìm kiếm và danh mục từ yêu cầu của khách hàng
        String search = request.getParameter("search");
        String category = request.getParameter("category");

        // Chuyển đổi tham số category sang kiểu số nguyên (nếu có)
        Integer categoryId = null;
        if (category != null && !category.isEmpty()) {
            try {
                categoryId = Integer.parseInt(category);
            } catch (NumberFormatException ignored) {
            }
        }

        // Tự động nhận diện danh mục dựa trên từ khóa tìm kiếm (search keyword)
        if (search != null && !search.trim().isEmpty()) {
            String cleanSearch = search.trim().toLowerCase();
            Integer detectedCategoryId = categoryDAO.getCategoryIdByName(cleanSearch);

            // Kiểm tra các từ khóa tiếng Anh/Việt thông dụng để ánh xạ danh mục phù hợp
            if (detectedCategoryId == null) {
                if (cleanSearch.contains("mouse") || cleanSearch.contains("chuột")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Chuột");
                } else if (cleanSearch.contains("keyboard") || cleanSearch.contains("bàn phím") || cleanSearch.contains("phím")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Bàn phím");
                } else if (cleanSearch.contains("laptop") || cleanSearch.contains("máy tính")) {
                    detectedCategoryId = categoryDAO.getCategoryIdByName("Laptop");
                }
            }
            // Nếu vẫn chưa tìm thấy danh mục, thử tra cứu danh mục dựa trên tên sản phẩm tìm kiếm
            if (detectedCategoryId == null) {
                Integer prodCategoryId = productDAO.getCategoryIdByProductSearch(search.trim());
                if (prodCategoryId != null) {
                    detectedCategoryId = prodCategoryId;
                }
            }
            // Nếu phát hiện được danh mục phù hợp, cập nhật lại categoryId
            if (detectedCategoryId != null) {
                categoryId = detectedCategoryId;
            }
        }

        // Trường hợp tìm kiếm toàn cục (Global Search) khi không xác định cụ thể danh mục
        if (categoryId == null && search != null && !search.trim().isEmpty()) {
            int page = 1, pageSize = 12;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
            } catch (Exception ignored) {
            }

            // Đếm tổng số sản phẩm khớp với từ khóa tìm kiếm để thực hiện phân trang
            int totalProducts = productDAO.countSearchAllProducts(search.trim());
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            // Đặt các thuộc tính cần thiết vào request để hiển thị ngoài giao diện
            request.setAttribute("products", productDAO.searchAllProducts(search.trim(), page, pageSize));
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("globalSearch", true);
            request.setAttribute("searchKeyword", search.trim());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            // Forward yêu cầu đến trang hiển thị danh sách sản phẩm
            request.getRequestDispatcher("customer/product_list.jsp").forward(request, response);
            return;
        }

        // Nếu không chỉ định danh mục và cũng không tìm kiếm gì, chuyển hướng về trang chủ
        if (categoryId == null) {
            response.sendRedirect("HomeServlet");
            return;
        }

        // Đọc các bộ lọc chung từ request (thương hiệu, khoảng giá, sắp xếp, mục đích sử dụng...)
        String brand = request.getParameter("brand");
        String price = request.getParameter("price");
        String sort = request.getParameter("sort");
        String purpose = request.getParameter("purpose");
        String connectivity = request.getParameter("connectivity");

        // Xử lý trang hiện tại phục vụ phân trang (mặc định là trang 1, mỗi trang có 9 sản phẩm)
        int page = 1, pageSize = 9;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception ignored) {
        }

        // Chuyển đổi tham số thương hiệu sang kiểu số nguyên
        Integer brandId = null;
        if (brand != null && !brand.isEmpty()) {
            try {
                brandId = Integer.parseInt(brand);
            } catch (NumberFormatException ignored) {
            }
        }

        // Thực hiện lọc và lấy danh sách sản phẩm theo từng danh mục cụ thể
        int totalProducts;

        switch (categoryId) {
            case 1 -> {
                // Đối với danh mục Laptop: Lọc theo các thông số cấu hình như CPU, RAM, SSD, GPU, màn hình, dòng máy
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

                // Lấy danh sách các dòng máy (series) tương ứng với thương hiệu đã chọn để hiển thị ở thanh bên (sidebar)
                if (brandId != null) {
                    request.setAttribute("serieses", new ProductSeriesDAO().getSeriesByBrand(brandId));
                }

                // Thực hiện đếm và lọc danh sách sản phẩm laptop tương ứng
                totalProducts = productDAO.countFilteredLaptop(categoryId, brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, search, null, null, null);
                request.setAttribute("products", ProductListFilterDAO.filterLaptop(brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, sort, page, pageSize, search));
            }
            case 3 -> {
                // Đối với danh mục Bàn phím: Lọc theo mục đích sử dụng, kiểu kết nối và loại Switch
                String switchType = request.getParameter("switch");

                // Thực hiện đếm và lọc danh sách sản phẩm bàn phím
                totalProducts = ProductListFilterDAO.countFilteredKeyboard(brandId, purpose, connectivity, switchType, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterKeyboard(brandId, purpose, connectivity, switchType, price, sort, page, pageSize, search));
            }
            case 4 -> {
                // Đối với danh mục Chuột: Lọc theo mục đích sử dụng, kiểu kết nối và chỉ số DPI
                String dpi = request.getParameter("dpi");

                // Thực hiện đếm và lọc danh sách sản phẩm chuột tương ứng
                totalProducts = ProductListFilterDAO.countFilteredMouse(brandId, purpose, connectivity, dpi, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterMouse(brandId, purpose, connectivity, dpi, price, sort, page, pageSize, search));
            }
            default -> {
                // Lọc chung cho các danh mục sản phẩm khác không thuộc ba nhóm trên
                totalProducts = ProductListFilterDAO.countFilteredGeneral(categoryId, brandId, price, search);
                request.setAttribute("products", ProductListFilterDAO.filterGeneral(categoryId, brandId, price, sort, page, pageSize, search));
            }
        }

        // Tính toán tổng số trang dựa trên tổng số sản phẩm và số lượng sản phẩm mỗi trang
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        
        // Đặt các thuộc tính phản hồi về trang JSP hiển thị danh sách sản phẩm
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("brands", brandDao.getBrandsByCategory(categoryId));
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("categories", categoryDAO.getAllCategories());

        // Forward dữ liệu đã lọc sang giao diện hiển thị danh sách sản phẩm của khách hàng
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

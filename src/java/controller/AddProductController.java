package controller;

import dal.BrandDAO;
import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Brand;
import model.Category;
import model.Product;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet("/staff/inventory/add")
public class AddProductController extends HttpServlet {

    /*
     * Name: doGet
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu GET để hiển thị trang thêm sản phẩm, bao gồm việc tải danh sách danh mục và thương hiệu
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khởi tạo các DAO để lấy dữ liệu từ database
        CategoryDAO categoryDAO = new CategoryDAO();
        BrandDAO brandDAO = new BrandDAO();

        // Lấy danh sách tất cả danh mục và thương hiệu
        List<Category> categories = categoryDAO.getAllCategories();
        List<Brand> brands = brandDAO.getAllBrands();

        // Đưa dữ liệu vào request để hiển thị trên file JSP
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);

        // Chuyển hướng người dùng đến trang AddProduct.jsp
        request.getRequestDispatcher("/staff/AddProduct.jsp").forward(request, response);
    }

    /*
     * Name: doPost
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xử lý yêu cầu POST để lưu thông tin sản phẩm mới và các biến thể của nó vào cơ sở dữ liệu, bao gồm cả upload ảnh
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập encoding UTF-8 để hỗ trợ gõ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        
        // Lấy thông tin cơ bản của sản phẩm từ form
        String productName = request.getParameter("productName");
        String categoryIdStr = request.getParameter("categoryId");
        String brandIdStr = request.getParameter("brandId");
        String description = request.getParameter("description");
        
        // Lấy danh sách các thuộc tính của variant từ mảng input
        String[] skus = request.getParameterValues("sku[]");
        String[] prices = request.getParameterValues("price[]");
        String[] stocks = request.getParameterValues("stock[]");
        String[] variantNames = request.getParameterValues("variantName[]");

        // --- Bắt lỗi không nhập input ---
        if (productName == null || productName.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
            brandIdStr == null || brandIdStr.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin bắt buộc (Tên sản phẩm, Danh mục, Thương hiệu)!");
            doGet(request, response);
            return;
        }

        if (skus == null || skus.length == 0) {
            request.setAttribute("errorMessage", "Vui lòng thêm ít nhất một biến thể sản phẩm!");
            doGet(request, response);
            return;
        }

        for (int i = 0; i < skus.length; i++) {
            if (skus[i] == null || skus[i].trim().isEmpty() ||
                prices[i] == null || prices[i].trim().isEmpty() ||
                stocks[i] == null || stocks[i].trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin cho các biến thể (SKU, Giá, Tồn kho)!");
                doGet(request, response);
                return;
            }
        }
        
        int categoryId = 0;
        int brandId = 0;
        try {
            // Ép kiểu ID của danh mục và thương hiệu từ String sang int
            categoryId = Integer.parseInt(categoryIdStr);
            brandId = Integer.parseInt(brandIdStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Xử lý upload file ảnh (thumbnail)
        Part filePart = request.getPart("thumbnail");
        String fileName = "";
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = filePart.getSubmittedFileName();
            String extension = "";
            int i = originalFileName.lastIndexOf('.');
            if (i > 0) {
                extension = originalFileName.substring(i);
            }
            // Tạo tên ngẫu nhiên cho file ảnh để tránh bị trùng lặp tên
            fileName = UUID.randomUUID().toString() + extension;
            // Đường dẫn lưu ảnh trong thư mục 'images' của server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir(); // Tạo thư mục nếu nó chưa tồn tại
            }
            // Tiến hành ghi file ảnh vào ổ cứng
            filePart.write(uploadPath + File.separator + fileName);
        }

        // Tạo đối tượng Product mới và gọi hàm insert vào CSDL
        Product p = new Product(0, productName, description, 0, fileName, categoryId, brandId);
        ProductDAO productDAO = new ProductDAO();
        int productId = productDAO.insertProduct(p);

        // Nếu lưu sản phẩm thành công, tiếp tục lưu các biến thể (variants) của sản phẩm
        if (productId != -1) {
            if (skus != null) {
                for (int j = 0; j < skus.length; j++) {
                    String sku = skus[j];
                    String priceStr = prices[j];
                    String stockStr = stocks[j];
                    String variantName = variantNames != null && variantNames.length > j ? variantNames[j] : "";
                    
                    BigDecimal price = new BigDecimal(0);
                    int stock = 0;
                    try {
                        // Ép kiểu giá tiền và số lượng tồn kho
                        price = new BigDecimal(priceStr);
                        stock = Integer.parseInt(stockStr);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                    // Thêm biến thể của sản phẩm vào database
                    productDAO.insertProductVariant(productId, sku, variantName, price, stock);
                }
            }
        }
        
        // Quay về trang quản lý kho sau khi lưu xong
        response.sendRedirect(request.getContextPath() + "/staff/inventory");
    }
}

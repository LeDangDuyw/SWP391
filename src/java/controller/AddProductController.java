package controller;

import dal.BrandDao;
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
        BrandDao brandDAO = new BrandDao();

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
        String[] importPrices = request.getParameterValues("importPrice[]");
        String[] prices = request.getParameterValues("price[]");
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
                importPrices == null || importPrices.length <= i || importPrices[i] == null || importPrices[i].trim().isEmpty() ||
                prices[i] == null || prices[i].trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin cho các biến thể (SKU, Giá Nhập, Giá Bán)!");
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
                 uploadDir.mkdirs(); // Tạo thư mục nếu nó chưa tồn tại
             }
             // Tiến hành ghi file ảnh vào ổ cứng
             filePart.write(uploadPath + File.separator + fileName);
             
             // Sync to source directory for persistence in local NetBeans environment
             try {
                 String sourcePath = uploadPath.replace("build" + File.separator + "web", "web");
                 File sourceDir = new File(sourcePath);
                 if (sourceDir.exists()) {
                     File buildFile = new File(uploadPath + File.separator + fileName);
                     File sourceFile = new File(sourcePath + File.separator + fileName);
                     if (buildFile.exists()) {
                         java.nio.file.Files.copy(buildFile.toPath(), sourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                     }
                 }
             } catch (Exception ex) {
                 ex.printStackTrace();
             }
         }

        // Tạo đối tượng Product mới và gọi hàm insert vào CSDL
        Product p = new Product(0, productName, description, 0, fileName, categoryId, brandId);
        ProductDAO productDAO = new ProductDAO();
        int productId = productDAO.insertProduct(p);

        // Nếu lưu sản phẩm thành công, tiếp tục lưu các biến thể (variants) của sản phẩm
        if (productId != -1) {
            if (skus != null) {
                // Lấy tất cả các Parts từ request để tìm file thumbnail cho từng variant
                java.util.Collection<Part> allParts = request.getParts();
                java.util.List<Part> variantThumbParts = new java.util.ArrayList<>();
                for (Part part : allParts) {
                    if ("variantThumbnail[]".equals(part.getName())) {
                        variantThumbParts.add(part);
                    }
                }

                for (int j = 0; j < skus.length; j++) {
                    String sku = skus[j];
                    String importPriceStr = importPrices[j];
                    String priceStr = prices[j];
                    String variantName = variantNames != null && variantNames.length > j ? variantNames[j] : "";
                    
                    BigDecimal importPrice = BigDecimal.ZERO;
                    BigDecimal price = BigDecimal.ZERO;
                    int stock = 0; // Stock always starts at 0, updated by Ticket Workflow
                    try {
                        importPrice = new BigDecimal(importPriceStr);
                        price = new BigDecimal(priceStr);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                    // Xử lý upload ảnh thumbnail cho biến thể
                    String variantThumbName = null;
                    if (j < variantThumbParts.size()) {
                        Part variantThumbPart = variantThumbParts.get(j);
                        if (variantThumbPart != null && variantThumbPart.getSize() > 0) {
                            String origName = variantThumbPart.getSubmittedFileName();
                            String ext = "";
                            int idx = origName.lastIndexOf('.');
                            if (idx > 0) {
                                ext = origName.substring(idx);
                            }
                            variantThumbName = UUID.randomUUID().toString() + ext;
                            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            variantThumbPart.write(uploadPath + File.separator + variantThumbName);
                            
                            // Sync to source directory
                            try {
                                String sourcePath = uploadPath.replace("build" + File.separator + "web", "web");
                                File sourceDir = new File(sourcePath);
                                if (sourceDir.exists()) {
                                    File buildFile = new File(uploadPath + File.separator + variantThumbName);
                                    File sourceFile = new File(sourcePath + File.separator + variantThumbName);
                                    if (buildFile.exists()) {
                                        java.nio.file.Files.copy(buildFile.toPath(), sourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                                    }
                                }
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }
                    }
                    
                    // Thêm biến thể của sản phẩm vào database (kèm thumbnail nếu có)
                    if (variantThumbName != null) {
                        productDAO.insertProductVariant(productId, sku, variantName, importPrice, price, stock, variantThumbName);
                    } else {
                        productDAO.insertProductVariant(productId, sku, variantName, importPrice, price, stock);
                    }
                }
            }
        }
        
        // Quay về trang quản lý kho sau khi lưu xong
        response.sendRedirect(request.getContextPath() + "/staff/inventory");
    }
}

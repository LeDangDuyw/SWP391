/*
 * Name: AddProductController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc thêm sản phẩm mới và các biến thể sản phẩm vào hệ thống.
 */
package controller;

import dal.BrandDao;
import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ProductSeriesDAO;
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
        List<model.ProductSeries> serieses = new ProductSeriesDAO().getAllSeries();

        // Đưa dữ liệu vào request để hiển thị trên file JSP
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("serieses", serieses);

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
        String warrantyPeriodStr = request.getParameter("warrantyPeriod");
        String purpose = request.getParameter("purposeSelect");
        if ("Khác".equals(purpose)) {
            purpose = request.getParameter("purposeCustom");
        }
        String seriesIdStr = request.getParameter("seriesId");
        
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

        int warrantyPeriod = 0;
        if (warrantyPeriodStr != null && !warrantyPeriodStr.trim().isEmpty()) {
            try {
                warrantyPeriod = Integer.parseInt(warrantyPeriodStr.trim());
                if (warrantyPeriod < 0) {
                    request.setAttribute("errorMessage", "Thời gian bảo hành không được là số âm!");
                    doGet(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Thời gian bảo hành phải là số nguyên hợp lệ!");
                doGet(request, response);
                return;
            }
        }

        if (skus == null || skus.length == 0) {
            request.setAttribute("errorMessage", "Vui lòng thêm ít nhất một biến thể sản phẩm!");
            doGet(request, response);
            return;
        }

        ProductDAO productDAO = new ProductDAO();

        for (int i = 0; i < skus.length; i++) {
            String vName = (variantNames != null && i < variantNames.length) ? variantNames[i] : "";
            if (skus[i] == null || skus[i].trim().isEmpty() ||
                vName == null || vName.trim().isEmpty() ||
                importPrices == null || importPrices.length <= i || importPrices[i] == null || importPrices[i].trim().isEmpty() ||
                prices[i] == null || prices[i].trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tất cả các ô thông tin biến thể (Tên biến thể, SKU, Giá Nhập, Giá Bán) không được để trống!");
                doGet(request, response);
                return;
            }
            
            try {
                java.math.BigDecimal ip = new java.math.BigDecimal(importPrices[i].trim());
                java.math.BigDecimal sp = new java.math.BigDecimal(prices[i].trim());
                
                if (ip.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                    request.setAttribute("errorMessage", "Giá nhập phải là số dương lớn hơn 0 (SKU: " + skus[i] + ")!");
                    doGet(request, response);
                    return;
                }
                if (sp.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                    request.setAttribute("errorMessage", "Giá bán phải là số dương lớn hơn 0 (SKU: " + skus[i] + ")!");
                    doGet(request, response);
                    return;
                }
                if (sp.compareTo(ip) < 0) {
                    request.setAttribute("errorMessage", "Giá bán không được nhỏ hơn giá nhập (SKU: " + skus[i] + ")!");
                    doGet(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Giá nhập và giá bán phải là số hợp lệ, không chứa chữ cái hoặc ký tự đặc biệt (SKU: " + skus[i] + ")!");
                doGet(request, response);
                return;
            }

            if (productDAO.isSkuExist(skus[i].trim())) {
                request.setAttribute("errorMessage", "Mã SKU '" + skus[i] + "' đã tồn tại trong hệ thống!");
                doGet(request, response);
                return;
            }
        }
        
        // Validate all file uploads (product thumbnail & variant thumbnails) for RCE security
        Part filePart = request.getPart("thumbnail");
        if (filePart != null && filePart.getSize() > 0) {
            String origName = filePart.getSubmittedFileName().toLowerCase();
            if (!origName.endsWith(".jpg") && !origName.endsWith(".jpeg") && !origName.endsWith(".png") && !origName.endsWith(".webp") && !origName.endsWith(".gif")) {
                request.setAttribute("errorMessage", "Định dạng ảnh sản phẩm không hợp lệ! (Chỉ chấp nhận .jpg, .jpeg, .png, .webp, .gif)");
                doGet(request, response);
                return;
            }
        }
        
        java.util.Collection<Part> allParts = request.getParts();
        java.util.List<Part> variantThumbParts = new java.util.ArrayList<>();
        for (Part part : allParts) {
            if ("variantThumbnail[]".equals(part.getName())) {
                variantThumbParts.add(part);
            }
        }
        
        for (Part part : variantThumbParts) {
            if (part != null && part.getSize() > 0) {
                String origName = part.getSubmittedFileName().toLowerCase();
                if (!origName.endsWith(".jpg") && !origName.endsWith(".jpeg") && !origName.endsWith(".png") && !origName.endsWith(".webp") && !origName.endsWith(".gif")) {
                    request.setAttribute("errorMessage", "Định dạng ảnh của biến thể không hợp lệ! (Chỉ chấp nhận .jpg, .jpeg, .png, .webp, .gif)");
                    doGet(request, response);
                    return;
                }
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

        int seriesId = 0;
        if (seriesIdStr != null && !seriesIdStr.trim().isEmpty()) {
            try {
                seriesId = Integer.parseInt(seriesIdStr.trim());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Tạo đối tượng Product mới và gọi hàm insert vào CSDL
        Product p = new Product(0, productName, description, warrantyPeriod, fileName, categoryId, brandId);
        p.setPurpose(purpose);
        p.setSeriesId(seriesId);
        int productId = productDAO.insertProduct(p);

        // Nếu lưu sản phẩm thành công, tiếp tục lưu các biến thể (variants) của sản phẩm
        if (productId != -1) {
            if (skus != null) {
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
                    
                    // Thêm biến thể của sản phẩm vào database (kèm thumbnail nếu có) và lưu VariantSpecification
                    int variantId = -1;
                    if (variantThumbName != null) {
                        variantId = productDAO.insertProductVariant(productId, sku, variantName, importPrice, price, stock, variantThumbName);
                    } else {
                        variantId = productDAO.insertProductVariant(productId, sku, variantName, importPrice, price, stock);
                    }

                    if (variantId != -1) {
                        java.util.Map<Integer, String> specMap = new java.util.HashMap<>();
                        java.util.Enumeration<String> paramNames = request.getParameterNames();
                        String prefix = "specVal_" + j + "_";
                        while (paramNames.hasMoreElements()) {
                            String pName = paramNames.nextElement();
                            if (pName.startsWith(prefix)) {
                                try {
                                    int specId = Integer.parseInt(pName.substring(prefix.length()));
                                    String val = request.getParameter(pName);
                                    if (val != null && !val.trim().isEmpty()) {
                                        specMap.put(specId, val.trim());
                                    }
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                }
                            }
                        }
                        if (!specMap.isEmpty()) {
                            productDAO.saveVariantSpecifications(variantId, specMap);
                        }
                    }
                }
            }
        }
        
        // Quay về trang quản lý kho sau khi lưu xong
        response.sendRedirect(request.getContextPath() + "/staff/inventory");
    }
}

package controller;

import dao.BrandDAO;
import dao.CategoryDAO;
import dao.ProductDAO;
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
public class AddProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        BrandDAO brandDAO = new BrandDAO();

        List<Category> categories = categoryDAO.getAllCategories();
        List<Brand> brands = brandDAO.getAllBrands();

        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);

        request.getRequestDispatcher("/admin/views/AddProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String productName = request.getParameter("productName");
        String categoryIdStr = request.getParameter("categoryId");
        String brandIdStr = request.getParameter("brandId");
        String description = request.getParameter("description");
        
        int categoryId = 0;
        int brandId = 0;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
            brandId = Integer.parseInt(brandIdStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Handle File Upload
        Part filePart = request.getPart("thumbnail");
        String fileName = "";
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = filePart.getSubmittedFileName();
            String extension = "";
            int i = originalFileName.lastIndexOf('.');
            if (i > 0) {
                extension = originalFileName.substring(i);
            }
            fileName = UUID.randomUUID().toString() + extension;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            filePart.write(uploadPath + File.separator + fileName);
        }

        Product p = new Product(0, productName, description, 0, fileName, categoryId, brandId);
        ProductDAO productDAO = new ProductDAO();
        int productId = productDAO.insertProduct(p);

        if (productId != -1) {
            String[] skus = request.getParameterValues("sku[]");
            String[] prices = request.getParameterValues("price[]");
            String[] stocks = request.getParameterValues("stock[]");
            String[] variantNames = request.getParameterValues("variantName[]");

            if (skus != null) {
                for (int j = 0; j < skus.length; j++) {
                    String sku = skus[j];
                    String priceStr = prices[j];
                    String stockStr = stocks[j];
                    String variantName = variantNames != null && variantNames.length > j ? variantNames[j] : "";
                    
                    BigDecimal price = new BigDecimal(0);
                    int stock = 0;
                    try {
                        price = new BigDecimal(priceStr);
                        stock = Integer.parseInt(stockStr);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    
                    productDAO.insertProductVariant(productId, sku, variantName, price, stock);
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }
}

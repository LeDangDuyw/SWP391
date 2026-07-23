package controller;

import dal.BrandDao;
import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ProductSeriesDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import model.ProductVariant;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
@WebServlet("/staff/inventory/edit")
public class EditProductController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
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
        List<model.ProductSeries> serieses = new ProductSeriesDAO().getAllSeries();

        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("serieses", serieses);
        request.setAttribute("selectedVariantId", variantId);
        request.getRequestDispatcher("/staff/EditProduct.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        if ("updateVariant".equals(action)) {
            try {
                String variantIdStr = request.getParameter("variantId");
                String productIdStr = request.getParameter("productId");
                String sku = request.getParameter("sku");
                String variantName = request.getParameter("variantName");
                String importPriceStr = request.getParameter("importPrice");
                String priceStr = request.getParameter("price");
                
                if (variantIdStr == null || sku == null || sku.trim().isEmpty() ||
                    variantName == null || variantName.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantIdStr + "&error=EmptyFields");
                    return;
                }
                
                int variantId = Integer.parseInt(variantIdStr);
                BigDecimal price = new BigDecimal(priceStr.trim());
                BigDecimal importPrice = (importPriceStr != null && !importPriceStr.trim().isEmpty()) 
                        ? new BigDecimal(importPriceStr.trim()) : null;

                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantId + "&error=InvalidPrice");
                    return;
                }

                // File upload for variant thumbnail
                String savedVariantThumbName = null;
                try {
                    Part filePart = request.getPart("variantThumbnail");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = getSubmittedFileName(filePart);
                        if (fileName != null && !fileName.trim().isEmpty()) {
                            String ext = "";
                            int lastDot = fileName.lastIndexOf('.');
                            if (lastDot > 0) {
                                ext = fileName.substring(lastDot);
                            }
                            savedVariantThumbName = UUID.randomUUID().toString() + ext;

                            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            filePart.write(uploadPath + File.separator + savedVariantThumbName);

                            try {
                                String buildPath = getServletContext().getRealPath("").replace("build" + File.separator + "web", "web") + File.separator + "images";
                                File buildDir = new File(buildPath);
                                if (!buildDir.exists()) buildDir.mkdirs();
                                filePart.write(buildPath + File.separator + savedVariantThumbName);
                            } catch (Exception ignored) {}
                        }
                    }
                } catch (Exception ignored) {}
                
                dao.updateProductVariant(variantId, sku.trim(), variantName.trim(), importPrice, price, savedVariantThumbName);

                // Process specifications
                Map<Integer, String> specValueMap = new HashMap<>();
                Enumeration<String> paramNames = request.getParameterNames();
                while (paramNames.hasMoreElements()) {
                    String paramName = paramNames.nextElement();
                    if (paramName.startsWith("spec_")) {
                        try {
                            int specId = Integer.parseInt(paramName.substring(5));
                            String val = request.getParameter(paramName);
                            if (val != null && !val.trim().isEmpty()) {
                                specValueMap.put(specId, val.trim());
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                }
                if (!specValueMap.isEmpty()) {
                    dao.saveVariantSpecifications(variantId, specValueMap);
                }

                response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantId + "&success=Updated");
                return;
            } catch (NumberFormatException e) {
                String vId = request.getParameter("variantId");
                response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + (vId != null ? vId : "") + "&error=InvalidNumberFormat");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;

        } else if ("updateProduct".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                String productName = request.getParameter("productName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                String description = request.getParameter("description");
                String warrantyPeriodStr = request.getParameter("warrantyPeriod");
                String purpose = request.getParameter("purposeSelect");
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

                // Handle main product thumbnail upload
                try {
                    Part filePart = request.getPart("thumbnail");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = getSubmittedFileName(filePart);
                        if (fileName != null && !fileName.trim().isEmpty()) {
                            String ext = "";
                            int lastDot = fileName.lastIndexOf('.');
                            if (lastDot > 0) {
                                ext = fileName.substring(lastDot);
                            }
                            String savedFileName = UUID.randomUUID().toString() + ext;

                            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            filePart.write(uploadPath + File.separator + savedFileName);

                            try {
                                String buildPath = getServletContext().getRealPath("").replace("build" + File.separator + "web", "web") + File.separator + "images";
                                File buildDir = new File(buildPath);
                                if (!buildDir.exists()) buildDir.mkdirs();
                                filePart.write(buildPath + File.separator + savedFileName);
                            } catch (Exception ignored) {}

                            dao.updateProductThumbnail(productId, savedFileName);
                        }
                    }
                } catch (Exception ignored) {}
                
                dao.updateProduct(productId, productName, categoryId, brandId, description, warrantyPeriod, purpose, seriesId);
                response.sendRedirect(request.getContextPath() + "/staff/inventory/edit?variantId=" + variantId + "&success=ProductUpdated");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/staff/inventory");
            return;
        }
        processRequest(request, response);
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
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

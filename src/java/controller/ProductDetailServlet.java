package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import dal.ProductDAO;
<<<<<<< Updated upstream
import dal.ProductReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import model.Product;
import model.ProductVariant;
import model.ProductReview;

/**
 * @author ASUS
 */
=======
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;
import model.ProductVariant;

/**
 *
 * @author ASUS
 */
@WebServlet(urlPatterns = {"/ProductDetailServlet"})
>>>>>>> Stashed changes
public class ProductDetailServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductDetailServlet at " + request.getContextPath() + "</h1>");
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
         // 1) Đọc & kiểm tra id sản phẩm
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("HomeServlet");
            return;
        }
        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("HomeServlet");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
<<<<<<< Updated upstream
        dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
=======
>>>>>>> Stashed changes

        // 2) Lấy thông tin sản phẩm
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            // EF1: sản phẩm không tồn tại / đã bị gỡ
            request.setAttribute("errorMessage", "Sản phẩm không tồn tại.");
<<<<<<< Updated upstream
            request.setAttribute("categories", categoryDAO.getAllCategories());
=======
>>>>>>> Stashed changes
            request.getRequestDispatcher("customer/product_detail.jsp").forward(request, response);
            return;
        }

        // 3) Lấy các biến thể (RAM/SSD) kèm tồn kho
        List<ProductVariant> variants = productDAO.getProductVariantsByProductId(productId);
<<<<<<< Updated upstream
        List<Product> similarProducts = productDAO.getSimilarProducts(product.getCategoryId(), product.getProductId(), 4);

        // 4) Lấy đánh giá & bình luận sản phẩm
        ProductReviewDAO reviewDAO = new ProductReviewDAO();
        List<ProductReview> reviews = reviewDAO.getApprovedReviewsByProductId(productId);
        
        double averageRating = 5.0; // Mặc định là 5 sao nếu chưa có đánh giá
        if (reviews != null && !reviews.isEmpty()) {
            double totalStars = 0;
            for (ProductReview r : reviews) {
                totalStars += r.getRating();
            }
            averageRating = totalStars / reviews.size();
        }
        int reviewsCount = (reviews != null) ? reviews.size() : 0;

        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("similarProducts", similarProducts);
        request.setAttribute("reviews", reviews);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewsCount", reviewsCount);
=======

        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
>>>>>>> Stashed changes
        request.getRequestDispatcher("customer/product_detail.jsp").forward(request, response);
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
<<<<<<< Updated upstream
        request.setCharacterEncoding("UTF-8");
        String productIdParam = request.getParameter("productId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        if (productIdParam == null || ratingParam == null || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect("HomeServlet");
            return;
        }

        int productId;
        int rating;
        try {
            productId = Integer.parseInt(productIdParam);
            rating = Integer.parseInt(ratingParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("HomeServlet");
            return;
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Trích xuất user_id động từ session "user" bằng reflection
        Integer userId = null;
        try {
            java.lang.reflect.Method getUserIdMethod = userObj.getClass().getMethod("getUserId");
            userId = (Integer) getUserIdMethod.invoke(userObj);
        } catch (Exception e1) {
            try {
                java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
                userId = (Integer) getIdMethod.invoke(userObj);
            } catch (Exception e2) {
                try {
                    java.lang.reflect.Field field = userObj.getClass().getDeclaredField("userId");
                    field.setAccessible(true);
                    userId = (Integer) field.get(userObj);
                } catch (Exception e3) {
                    // ignore
                }
            }
        }

        if (userId != null) {
            ProductReviewDAO reviewDAO = new ProductReviewDAO();
            reviewDAO.insertReview(productId, userId, rating, comment.trim(), "approved");
        }

        response.sendRedirect("ProductDetailServlet?id=" + productId + "#tab-reviews");
=======
        processRequest(request, response);
>>>>>>> Stashed changes
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

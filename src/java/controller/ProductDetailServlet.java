package controller;

/*
 * Name: ProductDetailServlet.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Servlet xử lý hiển thị trang thông tin chi tiết sản phẩm và các biến thể.
 */

import dal.ProductDAO;
import dal.ProductReviewDAO;
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
import model.ProductReview;

@WebServlet(urlPatterns = {"/ProductDetailServlet"})
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
        // Đọc tham số id sản phẩm từ URL/request
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

        // Khởi tạo các DAO để truy xuất thông tin sản phẩm và danh mục
        ProductDAO productDAO = new ProductDAO();
        dal.CategoryDAO categoryDAO = new dal.CategoryDAO();

        // Lấy chi tiết thông tin sản phẩm theo productId
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            // Trường hợp sản phẩm không tồn tại hoặc đã bị ẩn khỏi hệ thống
            request.setAttribute("errorMessage", "Sản phẩm không tồn tại.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("customer/product_detail.jsp").forward(request, response);
            return;
        }

        // Lấy các biến thể sản phẩm (dung lượng RAM/SSD) và danh sách sản phẩm tương tự gợi ý
        List<ProductVariant> variants = productDAO.getProductVariantsByProductId(productId);
        List<Product> similarProducts = productDAO.getSimilarProducts(product.getPurpose(), product.getCategoryId(), product.getProductId(), 4);

        // Lấy danh sách các đánh giá của sản phẩm đã được phê duyệt từ khách hàng
        ProductReviewDAO reviewDAO = new ProductReviewDAO();
        List<ProductReview> reviews = reviewDAO.getApprovedReviewsByProductId(productId);
        
        // Tính toán điểm số đánh giá trung bình (Rating Average)
        double averageRating = 5.0; // Mặc định là 5 sao nếu chưa có đánh giá nào
        if (reviews != null && !reviews.isEmpty()) {
            double totalStars = 0;
            for (ProductReview r : reviews) {
                totalStars += r.getRating();
            }
            averageRating = totalStars / reviews.size();
        }
        int reviewsCount = (reviews != null) ? reviews.size() : 0;

        // Xác định nhãn hiển thị cho sản phẩm (Badge) dựa trên mục đích sử dụng hoặc loại danh mục
        String productBadge = product.getPurpose();
        if (productBadge == null || productBadge.trim().isEmpty()) {
            productBadge = productDAO.getProductBadge(product.getProductId(), product.getCategoryId());
        }

        // Truyền các thuộc tính dữ liệu cần thiết sang giao diện JSP hiển thị chi tiết sản phẩm
        request.setAttribute("productBadge", productBadge);
        request.setAttribute("product", product);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("similarProducts", similarProducts);
        request.setAttribute("reviews", reviews);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewsCount", reviewsCount);
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
        // Thiết lập bảng mã UTF-8 để hỗ trợ gửi bình luận tiếng Việt có dấu
        request.setCharacterEncoding("UTF-8");
        String productIdParam = request.getParameter("productId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        // Kiểm tra các tham số đầu vào của form đánh giá
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

        // Kiểm tra phiên đăng nhập của người dùng trước khi đánh giá
        jakarta.servlet.http.HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Sử dụng Reflection để trích xuất userId của người dùng linh hoạt từ session
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
                    // Bỏ qua lỗi nếu không tìm thấy
                }
            }
        }

        // Lưu thông tin đánh giá mới của khách hàng vào CSDL ở trạng thái chờ duyệt (pending)
        boolean success = false;
        if (userId != null) {
            ProductReviewDAO reviewDAO = new ProductReviewDAO();
            success = reviewDAO.insertReview(productId, userId, rating, comment.trim(), "pending");
        }

        // Hỗ trợ xử lý phản hồi bất đồng bộ (AJAX)
        String isAjax = request.getParameter("ajax");
        if ("true".equals(isAjax)) {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            if (success) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
            return;
        }

        // Chuyển hướng trở lại tab đánh giá tại trang chi tiết sản phẩm
        response.sendRedirect("ProductDetailServlet?id=" + productId + "#tab-reviews");
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

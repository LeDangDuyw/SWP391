package controller;

import dal.CategoryDAO;
import dal.GeneralPolicyDAO;
import dal.WarrantyPolicyDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.GeneralPolicy;
import model.WarrantyPolicy;

/**
 * Class: PolicyController
 * Description: Controller chuyên trách điều hướng và hiển thị thông tin các trang Chính sách (Policy) và Tin tức / Khuyến mãi (News).
 * Các đường dẫn hỗ trợ:
 * - /policy/privacy : Chính sách bảo mật
 * - /policy/terms : Điều khoản sử dụng
 * - /policy/shopping-guide : Hướng dẫn mua hàng
 * - /policy/warranty : Chính sách bảo hành
 * - /about : Giới thiệu UNILAP
 * - /news : Danh sách bài viết Tin tức / Khuyến mãi / Sản phẩm mới
 * - /policy?id=X : Xem chi tiết bài viết chính sách chung theo ID
 * 
 * Created: 2026-05-29
 * Updated: 2026-07-23
 * Version: v2.1
 *
 * @author DuyLD
 */
@WebServlet(urlPatterns = {

    "/policy/privacy",
    "/policy/terms",
    "/policy/shopping-guide",
    "/policy/warranty",
    "/about",
    "/news",
    "/policy"
})
public class PolicyController extends HttpServlet {

    private GeneralPolicyDAO generalPolicyDAO;
    private WarrantyPolicyDAO warrantyPolicyDAO;
    private CategoryDAO categoryDAO;

    /**
     * Khởi tạo các DAO tương tác dữ liệu chính sách, bảo hành và danh mục sản phẩm.
     */
    @Override
    public void init() {
        generalPolicyDAO = new GeneralPolicyDAO();
        warrantyPolicyDAO = new WarrantyPolicyDAO();
        categoryDAO = new CategoryDAO();
    }

    /**
     * Xử lý điều hướng các trang chính sách và tin tức dựa theo đường dẫn URL (URI Pattern).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nạp danh sách các danh mục sản phẩm lên thanh điều hướng Navigation Header
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if ("/policy/privacy".equals(path)) {
            // Trang Chính sách bảo mật
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("PRIVACY");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/privacy_policy.jsp").forward(request, response);
        } else if ("/policy/terms".equals(path)) {
            // Trang Điều khoản sử dụng
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("TERMS");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/terms_of_use.jsp").forward(request, response);
        } else if ("/policy/shopping-guide".equals(path)) {
            // Trang Hướng dẫn mua hàng
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("SHOPPING_GUIDE");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/shopping_guide.jsp").forward(request, response);
        } else if ("/policy/warranty".equals(path)) {
            // Trang Chính sách bảo hành
            List<WarrantyPolicy> policies = warrantyPolicyDAO.getActivePolicies();
            request.setAttribute("policies", policies);
            request.getRequestDispatcher("/customer/warranty_policy.jsp").forward(request, response);
        } else if ("/about".equals(path)) {
            // Trang Giới thiệu cửa hàng
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("ABOUT");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/about_us.jsp").forward(request, response);
        } else if ("/news".equals(path)) {
            // Trang Tin tức & Khuyến mãi (Hỗ trợ lọc theo tab: ALL, PROMOTION, NEW_PRODUCT)
            String typeParam = request.getParameter("type");
            List<String> types = new java.util.ArrayList<>();
            if ("PROMOTION".equalsIgnoreCase(typeParam)) {
                types.add("PROMOTION");
                types.add("PROMO");
                request.setAttribute("activeTab", "PROMOTION");
            } else if ("NEW_PRODUCT".equalsIgnoreCase(typeParam)) {
                types.add("NEW_PRODUCT");
                types.add("NEWPROD");
                request.setAttribute("activeTab", "NEW_PRODUCT");
            } else {
                types.add("PROMOTION");
                types.add("PROMO");
                types.add("NEW_PRODUCT");
                types.add("NEWPROD");
                types.add("NEWS");
                request.setAttribute("activeTab", "ALL");
            }
            List<GeneralPolicy> articles = generalPolicyDAO.getPoliciesByTypes(types);
            request.setAttribute("articles", articles);
            request.getRequestDispatcher("/customer/news_list.jsp").forward(request, response);
        } else if ("/policy".equals(path)) {
            // Xem chi tiết một bài viết chính sách chung theo tham số ?id=
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    GeneralPolicy policy = generalPolicyDAO.getPolicyById(id);
                    if (policy != null) {
                        request.setAttribute("policy", policy);
                        request.getRequestDispatcher("/customer/general_policy_view.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}


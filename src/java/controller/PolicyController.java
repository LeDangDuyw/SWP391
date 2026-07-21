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

    @Override
    public void init() {
        generalPolicyDAO = new GeneralPolicyDAO();
        warrantyPolicyDAO = new WarrantyPolicyDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Populate standard categories in request scope for navigation bar dropdowns
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
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("PRIVACY");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/privacy_policy.jsp").forward(request, response);
        } else if ("/policy/terms".equals(path)) {
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("TERMS");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/terms_of_use.jsp").forward(request, response);
        } else if ("/policy/shopping-guide".equals(path)) {
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("SHOPPING_GUIDE");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/shopping_guide.jsp").forward(request, response);
        } else if ("/policy/warranty".equals(path)) {
            List<WarrantyPolicy> policies = warrantyPolicyDAO.getActivePolicies();
            request.setAttribute("policies", policies);
            request.getRequestDispatcher("/customer/warranty_policy.jsp").forward(request, response);
        } else if ("/about".equals(path)) {
            GeneralPolicy policy = generalPolicyDAO.getPolicyByType("ABOUT");
            request.setAttribute("policy", policy);
            request.getRequestDispatcher("/customer/about_us.jsp").forward(request, response);
        } else if ("/news".equals(path)) {
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

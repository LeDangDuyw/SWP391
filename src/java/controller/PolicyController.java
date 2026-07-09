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
    "/about"
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
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}

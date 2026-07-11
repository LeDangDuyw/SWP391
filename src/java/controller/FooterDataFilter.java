package controller;

import dal.GeneralPolicyDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import model.GeneralPolicy;

@WebFilter(filterName = "FooterDataFilter", urlPatterns = {"/*"})
public class FooterDataFilter implements Filter {

    private GeneralPolicyDAO generalPolicyDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        generalPolicyDAO = new GeneralPolicyDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Skip database lookup for static resources
        boolean isStatic = path.startsWith("/css") || path.startsWith("/js") || path.startsWith("/images") || path.contains(".");
        
        if (!isStatic) {
            try {
                List<GeneralPolicy> footerPolicies = generalPolicyDAO.getFooterPolicies();
                request.setAttribute("footerPolicies", footerPolicies);
                
                dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
                request.setAttribute("categories", categoryDAO.getAllCategories());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

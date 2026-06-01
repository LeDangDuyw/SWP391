package controller;

import dao.PolicyDAO;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.WarrantyPolicy;

/**
 * AdminPolicy handles policy management requests from administrators.
 *
 * Version 1.4
 *
 * Author DuyLD
 */
public class AdminPolicy extends HttpServlet {

    private PolicyDAO dao;

    /**
     * Initializes the PolicyDAO instance used by this servlet.
     */
    @Override
    public void init() {
        dao = new PolicyDAO();
    }

    /**
     * Handles GET requests by loading, filtering, or searching policies and forwarding to the policy JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String keyword = request.getParameter("keyword");
            String statusFilter = request.getParameter("statusFilter");

            List<WarrantyPolicy> policies;

            if (keyword != null && !keyword.trim().isEmpty()) {
                policies = dao.searchPolicies(keyword.trim());
                request.setAttribute("keyword", keyword.trim());
            } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                policies = dao.getPoliciesByStatus(statusFilter.trim());
                request.setAttribute("statusFilter", statusFilter.trim());
            } else {
                policies = dao.getAllPolicies();
            }

            request.setAttribute("policies", policies);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    WarrantyPolicy selected = dao.getPolicyById(id);
                    request.setAttribute("selectedPolicy", selected);
                } catch (Exception ignored) {
                }
            }

            request.getRequestDispatcher("/Admin/PolicyManagement.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error loading policies", e);
        }
    }

    /**
     * Handles POST requests by dispatching to the appropriate create, update, delete, or status action.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        try {

            switch (action == null ? "" : action) {

                case "create": {

                    WarrantyPolicy p = buildPolicyFromRequest(request);

                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    p.setStatus("DRAFT");
                    p.setCreatedAt(now);
                    p.setUpdatedAt(now);

                    dao.insertPolicy(p);

                    response.sendRedirect(contextPath + "/admin/policy");
                    break;
                }

                case "update": {

                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);

                    if (p != null) {
                        updatePolicyFromRequest(request, p);
                        dao.updatePolicy(p);
                    }

                    response.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }

                case "delete": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.deletePolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy");
                    break;
                }

                case "publish": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.publishPolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }

                case "saveDraft": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.saveDraft(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }

                case "disable": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.disablePolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }

                default:
                    response.sendRedirect(contextPath + "/admin/policy");
            }

        } catch (Exception e) {
            throw new ServletException("Error processing policy action: " + action, e);
        }
    }

    /**
     * Builds a new WarrantyPolicy object from the HTTP request parameters.
     */
    private WarrantyPolicy buildPolicyFromRequest(HttpServletRequest request) {
        WarrantyPolicy p = new WarrantyPolicy();

        p.setPolicyName(request.getParameter("policyName"));
        p.setDescription(request.getParameter("description"));
        p.setPolicyContent(request.getParameter("policyContent"));
        p.setApplicableRegions(request.getParameter("applicableRegions"));

        String wm = request.getParameter("warrantyMonths");
        p.setWarrantyMonths(wm != null && !wm.isEmpty() ? Integer.parseInt(wm) : 0);

        String version = request.getParameter("version");
        p.setVersion(version != null && !version.trim().isEmpty() ? version.trim() : "1.0");

        String effDate = request.getParameter("effectiveDate");
        if (effDate != null && !effDate.isEmpty()) {
            p.setEffectiveDate(java.sql.Date.valueOf(effDate));
        } else {
            p.setEffectiveDate(new java.sql.Date(System.currentTimeMillis()));
        }

        return p;
    }

    /**
     * Updates an existing WarrantyPolicy object with values from the HTTP request parameters.
     */
    private void updatePolicyFromRequest(HttpServletRequest request, WarrantyPolicy p) {

        p.setPolicyName(request.getParameter("policyName"));
        p.setDescription(request.getParameter("description"));

        String content = request.getParameter("policyContent");
        if (content != null) {
            p.setPolicyContent(content);
        }

        String regions = request.getParameter("applicableRegions");
        if (regions != null) {
            p.setApplicableRegions(regions);
        }

        String wm = request.getParameter("warrantyMonths");
        if (wm != null && !wm.isEmpty()) {
            p.setWarrantyMonths(Integer.parseInt(wm));
        }

        String version = request.getParameter("version");
        if (version != null) {
            p.setVersion(version.trim());
        }

        String status = request.getParameter("status");
        if (status != null && !status.trim().isEmpty()) {
            p.setStatus(status.trim());
        }

        String effDate = request.getParameter("effectiveDate");
        if (effDate != null && !effDate.isEmpty()) {
            p.setEffectiveDate(java.sql.Date.valueOf(effDate));
        }
    }

    /**
     * Returns a brief description of this servlet.
     */
    @Override
    public String getServletInfo() {
        return "AdminPolicy Servlet";
    }
}

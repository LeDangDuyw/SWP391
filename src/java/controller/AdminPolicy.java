package controller;

import dal.PolicyDAO;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.WarrantyPolicy;

/**
 * AdminPolicy handles policy management requests from administrators.
 *
 * URL: /admin/policy
 *
 * Version 2.0
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
     * Handles GET requests by loading, filtering, or searching policies and
     * forwarding to the policy JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String statusFilter = request.getParameter("statusFilter");

            int page = 1;
            int pageSize = 5;
            int totalRecords;
            List<WarrantyPolicy> policies;

            String pageParam = request.getParameter("page");

            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {

                keyword = keyword.trim();

                totalRecords = dao.countSearchPolicies(keyword);

                policies = dao.searchPoliciesPaging(keyword, (page - 1) * pageSize, pageSize);

                request.setAttribute("keyword", keyword);

            } else {

                totalRecords = dao.countPolicies();

                policies = dao.getPoliciesPaging((page - 1) * pageSize, pageSize);
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
            int totalPages
                    = (int) Math.ceil((double) totalRecords / pageSize);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("/admin/PolicyManagement.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error loading policies", e);
        }

    }

    /**
     * Handles POST requests by dispatching to the appropriate create, update,
     * delete, or status action.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String contextPath = request.getContextPath();
        String pageParam = request.getParameter("page");

        try {
            switch (action == null ? "" : action) {

                case "create": {
                    WarrantyPolicy p = buildPolicyFromRequest(request);

                    if (dao.existsPolicyName(p.getPolicyName())) {
                        request.setAttribute("error", "Policy name has already existed");
                        request.setAttribute("formData", p);

                        int page;

                        if (pageParam != null && !pageParam.trim().isEmpty()) {
                            page = Integer.parseInt(pageParam);
                        } else {
                            page = 1;
                        }
                        int pageSize = 5;
                        int offset = (page - 1) * pageSize;

                        List<WarrantyPolicy> policies = dao.getPoliciesPaging(offset, pageSize);
                        int totalPolicies = dao.countPolicies();
                        int totalPages = (int) Math.ceil((double) totalPolicies / pageSize);

                        request.setAttribute("policies", policies);
                        request.setAttribute("currentPage", page);
                        request.setAttribute("totalPages", totalPages);

                        request.setAttribute("policies", policies);
                        request.setAttribute("currentPage", page);
                        request.setAttribute("totalPages", totalPages);

                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }

                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    p.setStatus("DRAFT");
                    p.setCreatedAt(now);
                    p.setUpdatedAt(now);
                    dao.insertPolicy(p);
                    response.sendRedirect(contextPath + "/admin/policy?page=" + pageParam);
                    break;
                }

                case "update": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);

                    if (p != null) {
                        updatePolicyFromRequest(request, p);

                        if (dao.existsPolicyNameForUpdate(p.getPolicyName(), id)) {
                            request.setAttribute("error", "Policy name has existed!");
                            request.setAttribute("selectedPolicy", p);

                            List<WarrantyPolicy> policies = dao.getAllPolicies();
                            request.setAttribute("policies", policies);

                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }
                        dao.updatePolicy(p);
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + "&page=" + pageParam);
                    break;
                }

                case "delete": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.deletePolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy?page=" + pageParam);
                    break;
                }

                case "publish": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.publishPolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + "&page=" + pageParam);
                    break;
                }

                case "saveDraft": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.saveDraft(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + "&page=" + pageParam);
                    break;
                }

                case "disable": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.disablePolicy(id);
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + "&page=" + pageParam);
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
        String name = request.getParameter("policyName");
        p.setPolicyName(name);

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Policy name can't be empty!");
        }

        p.setDescription(request.getParameter("description"));
        p.setPolicyContent(request.getParameter("policyContent"));
        p.setApplicableRegions(request.getParameter("applicableRegions"));

        String wm = request.getParameter("warrantyMonths");
        if (wm != null && !wm.isEmpty()) {
            p.setWarrantyMonths(Integer.parseInt(wm));
        } else {
            p.setWarrantyMonths(0);
        }

        String version = request.getParameter("version");
        if (version != null && !version.trim().isEmpty()) {
            p.setVersion(version.trim());
        } else {
            p.setVersion("1.0");
        }

        String effDate = request.getParameter("effectiveDate");
        if (effDate != null && !effDate.isEmpty()) {
            p.setEffectiveDate(java.sql.Date.valueOf(effDate));
        } else {
            p.setEffectiveDate(new java.sql.Date(System.currentTimeMillis()));
        }
        return p;
    }

    /**
     * Updates an existing WarrantyPolicy object with values from the HTTP
     * request parameters.
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

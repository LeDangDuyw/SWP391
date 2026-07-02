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

    private void loadPolicyList(HttpServletRequest request) throws Exception {
        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 5;
        int totalRecords;
        List<WarrantyPolicy> policies;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            totalRecords = dao.countSearchPolicies(keyword);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            policies = dao.searchPoliciesPaging(
                    keyword,
                    (page - 1) * pageSize,
                    pageSize
            );
            request.setAttribute("keyword", keyword);
        } else {
            totalRecords = dao.countPolicies();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            policies = dao.getPoliciesPaging(
                    (page - 1) * pageSize,
                    pageSize
            );
        }
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        request.setAttribute("policies", policies);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
    }

    /**
     * Handles GET requests by loading, filtering, or searching policies and
     * forwarding to the policy JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            loadPolicyList(request);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    WarrantyPolicy selected = dao.getPolicyById(id);
                    if (selected != null) {
                        selected.setExpiryDate(calculateExpiryDate(selected.getEffectiveDate(),selected.getWarrantyMonths()));
                        List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                        request.setAttribute("historyList", historyList);
                    }
                    request.setAttribute("selectedPolicy", selected);
                } catch (Exception ignored) {
                }
            }
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
        String pageSuffix = (pageParam != null && !pageParam.trim().isEmpty()) ? "&page=" + pageParam.trim() : "";

        try {
            switch (action == null ? "" : action) {

                case "create": {
                    WarrantyPolicy p = buildPolicyFromRequest(request);

                    if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty()) {
                        request.setAttribute("error", "Policy name can't be empty!");
                        request.setAttribute("formData", p);
                        loadPolicyList(request);
                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }

                    if (dao.existsPolicyName(p.getPolicyName())) {
                        request.setAttribute("error", "Policy name has already existed");
                        request.setAttribute("formData", p);
                        loadPolicyList(request);
                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }

                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    p.setStatus("DRAFT");
                    p.setCreatedAt(now);
                    p.setUpdatedAt(now);
                    int newId = dao.insertPolicy(p);
                    if (newId > 0) {
                        dao.insertHistory(newId, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "CREATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy");
                    break;
                }

                case "update": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);

                    if (p != null) {
                        updatePolicyFromRequest(request, p);

                        if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty()) {
                            request.setAttribute("error", "Policy name can't be empty!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }

                        if (dao.existsPolicyNameForUpdate(p.getPolicyName(), id)) {
                            request.setAttribute("error", "Policy name has existed!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }
                        dao.updatePolicy(p);
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
                    break;
                }

                case "delete": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.deletePolicy(id);
                    String deletePageSuffix = (pageParam != null && !pageParam.trim().isEmpty()) ? "?page=" + pageParam.trim() : "";
                    response.sendRedirect(contextPath + "/admin/policy" + deletePageSuffix);
                    break;
                }

                case "publish": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.publishPolicy(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
                    break;
                }

                case "saveDraft": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.saveDraft(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
                    break;
                }

                case "disable": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    dao.disablePolicy(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
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
        p.setPolicyName(name != null ? name.trim() : null);

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Policy name can't be empty!");
        }

        String desc = request.getParameter("description");
        p.setDescription(desc != null ? desc.trim() : null);
        
        String content = request.getParameter("policyContent");
        p.setPolicyContent(content != null ? content.trim() : null);
        
        String regions = request.getParameter("applicableRegions");
        p.setApplicableRegions(regions != null ? regions.trim() : null);

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
        String name = request.getParameter("policyName");
        p.setPolicyName(name != null ? name.trim() : null);
        
        String desc = request.getParameter("description");
        p.setDescription(desc != null ? desc.trim() : null);

        String content = request.getParameter("policyContent");
        if (content != null) {
            p.setPolicyContent(content.trim());
        }

        String regions = request.getParameter("applicableRegions");
        if (regions != null) {
            p.setApplicableRegions(regions.trim());
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

    private java.sql.Date calculateExpiryDate(java.sql.Date start, int months) {
        if (start == null) {
            return null;
        }

        java.time.LocalDate ld = start.toLocalDate();
        ld = ld.plusMonths(months);

        return java.sql.Date.valueOf(ld);
    }

    /**
     * Returns a brief description of this servlet.
     */
    @Override
    public String getServletInfo() {
        return "AdminPolicy Servlet";
    }
}

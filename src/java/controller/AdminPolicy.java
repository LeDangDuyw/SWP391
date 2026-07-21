package controller;

/**
 * Class: AdminPolicy
 * Description: Controller quản lý CRUD các chính sách bảo hành (Warranty Policy).
 * 
 * Created: 2026-05-29
 * Updated: 2026-07-19
 * Version: v2.8
 *
 * @author DuyLD
 */

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

public class AdminPolicy extends HttpServlet {

    private PolicyDAO dao;

    /**
     * Initializes the PolicyDAO instance used by this servlet.
     */
    @Override
    /**
     * Phuong thuc init
     */
    public void init() {
        dao = new PolicyDAO();
    }

    private void loadPolicyList(HttpServletRequest request) throws Exception {
        // BR-44: The warranty policy list is paginated at 5 records per page, ordered by creation time descending.
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("statusFilter");
        int page = 1;
        int pageSize = 5;
        int totalRecords;
        List<WarrantyPolicy> policies;

        String pageParam = request.getParameter("page");
        // Kiểm tra điều kiện
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try {
                page = Integer.parseInt(pageParam.trim());
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            } catch (NumberFormatException ignored) {}
        }

        totalRecords = dao.countPolicies(keyword, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Kiểm tra điều kiện
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        policies = dao.getPoliciesPaging(
                keyword,
                statusFilter,
                (page - 1) * pageSize,
                pageSize
        );

        request.setAttribute("policies", policies);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
    }

    /**
     * Handles GET requests by loading, filtering, or searching policies and
     * forwarding to the policy JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            request.setAttribute("activeTab", "WARRANTY");
            loadPolicyList(request);

            String idParam = request.getParameter("id");
            // Kiểm tra điều kiện
            if (idParam != null && !idParam.trim().isEmpty()) {
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try {
                    int id = Integer.parseInt(idParam.trim());
                    WarrantyPolicy selected = dao.getPolicyById(id);
                    // Kiểm tra điều kiện
                    if (selected != null) {
                        selected.setExpiryDate(calculateExpiryDate(selected.getEffectiveDate(),selected.getWarrantyMonths()));
                        List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                        request.setAttribute("historyList", historyList);
                    }
                    request.setAttribute("selectedPolicy", selected);
                // Bắt và xử lý ngoại lệ xảy ra trong khối try
                } catch (Exception ignored) {
                }
            }
            request.getRequestDispatcher("/admin/PolicyManagement.jsp")
                    .forward(request, response);

        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ServletException("Lỗi tải danh sách chính sách bảo hành.", e);
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

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            switch (action == null ? "" : action) {

                case "create": {
                    WarrantyPolicy p = buildPolicyFromRequest(request);

                    // BR-24: A Warranty Policy must define at minimum: policy name, at least one applicable product category, warranty duration in months, and terms and conditions text.
                    if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty() || !p.getPolicyName().matches(".*\\p{L}.*")) {
                        request.setAttribute("error", "Tên chính sách phải chứa ít nhất một chữ cái và không được chỉ gồm số hoặc ký tự đặc biệt!");
                        request.setAttribute("formData", p);
                        loadPolicyList(request);
                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }

                    // Kiểm tra điều kiện
                    if (dao.existsPolicyName(p.getPolicyName())) {
                        request.setAttribute("error", "Tên chính sách đã tồn tại!");
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
                    // Kiểm tra điều kiện
                    if (newId > 0) {
                        dao.insertHistory(newId, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "CREATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy");
                    break;
                }

                case "update": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);

                    // Kiểm tra điều kiện
                    if (p != null) {
                        updatePolicyFromRequest(request, p);

                        // Kiểm tra điều kiện
                        if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty() || !p.getPolicyName().matches(".*\\p{L}.*")) {
                            request.setAttribute("error", "Tên chính sách phải chứa ít nhất một chữ cái và không được chỉ gồm số hoặc ký tự đặc biệt!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }

                        // Kiểm tra điều kiện
                        if (("LIVE".equalsIgnoreCase(p.getStatus()) || "PUBLISHED".equalsIgnoreCase(p.getStatus()))
                                && isContentEmpty(p.getPolicyContent())) {
                            request.setAttribute("error", "Nội dung chính sách không được để trống khi phát hành lên trạng thái Live!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }

                        // Kiểm tra điều kiện
                        if (dao.existsPolicyNameForUpdate(p.getPolicyName(), id)) {
                            request.setAttribute("error", "Tên chính sách đã được sử dụng bởi chính sách khác!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }
                        // Tự động tăng version khi update (ví dụ: 1.0 -> 1.1 hoặc v1.0 -> v1.1)
                        String currentVer = p.getVersion();
                        p.setVersion(incrementVersion(currentVer));

                        dao.updatePolicy(p);
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
                    break;
                }

                case "delete": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    // BR-39: Deleting a Warranty Policy permanently removes it along with its full change history; this action cannot be undone.
                    dao.deletePolicy(id);
                    String deletePageSuffix = (pageParam != null && !pageParam.trim().isEmpty()) ? "?page=" + pageParam.trim() : "";
                    response.sendRedirect(contextPath + "/admin/policy" + deletePageSuffix);
                    break;
                }

                case "publish": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);
                    // Kiểm tra điều kiện
                    if (p != null && isContentEmpty(p.getPolicyContent())) {
                        request.setAttribute("error", "Nội dung chính sách không được để trống khi phát hành lên trạng thái Live!");
                        request.setAttribute("selectedPolicy", p);
                        loadPolicyList(request);
                        List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                        request.setAttribute("historyList", historyList);
                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }
                    dao.publishPolicy(id);
                    p = dao.getPolicyById(id);
                    // Kiểm tra điều kiện
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
                    // Kiểm tra điều kiện
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
                    // Kiểm tra điều kiện
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), p.getStatus(), "UPDATED");
                    }
                    response.sendRedirect(contextPath + "/admin/policy?id=" + id + pageSuffix);
                    break;
                }

                default:
                    response.sendRedirect(contextPath + "/admin/policy");
            }

        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý thao tác chính sách: " + action, e);
        }
    }

    /**
     * Builds a new WarrantyPolicy object from the HTTP request parameters.
     */
    private WarrantyPolicy buildPolicyFromRequest(HttpServletRequest request) {
        WarrantyPolicy p = new WarrantyPolicy();
        String name = request.getParameter("policyName");
        p.setPolicyName(name != null ? name.trim() : null);

        // Kiểm tra điều kiện
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên chính sách không được để trống!");
        }

        String desc = request.getParameter("description");
        p.setDescription(desc != null ? desc.trim() : null);
        
        String content = request.getParameter("policyContent");
        p.setPolicyContent(content != null ? content.trim() : null);
        
        String regions = request.getParameter("applicableRegions");
        p.setApplicableRegions(regions != null ? regions.trim() : null);

        String wm = request.getParameter("warrantyMonths");
        // Kiểm tra điều kiện
        if (wm != null && !wm.isEmpty()) {
            p.setWarrantyMonths(Integer.parseInt(wm));
        } else {
            p.setWarrantyMonths(0);
        }

        String version = request.getParameter("version");
        // Kiểm tra điều kiện
        if (version != null && !version.trim().isEmpty()) {
            p.setVersion(version.trim());
        } else {
            p.setVersion("1.0");
        }

        String effDate = request.getParameter("effectiveDate");
        // Kiểm tra điều kiện
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
        // Kiểm tra điều kiện
        if (content != null) {
            p.setPolicyContent(content.trim());
        }

        String regions = request.getParameter("applicableRegions");
        // Kiểm tra điều kiện
        if (regions != null) {
            p.setApplicableRegions(regions.trim());
        }

        String wm = request.getParameter("warrantyMonths");
        // Kiểm tra điều kiện
        if (wm != null && !wm.isEmpty()) {
            p.setWarrantyMonths(Integer.parseInt(wm));
        }

        String status = request.getParameter("status");
        // Kiểm tra điều kiện
        if (status != null && !status.trim().isEmpty()) {
            p.setStatus(status.trim());
        }

        String effDate = request.getParameter("effectiveDate");
        // Kiểm tra điều kiện
        if (effDate != null && !effDate.isEmpty()) {
            p.setEffectiveDate(java.sql.Date.valueOf(effDate));
        }
    }

    private java.sql.Date calculateExpiryDate(java.sql.Date start, int months) {
        // Kiểm tra điều kiện
        if (start == null) {
            return null;
        }

        java.time.LocalDate ld = start.toLocalDate();
        ld = ld.plusMonths(months);

        return java.sql.Date.valueOf(ld);
    }

    private boolean isContentEmpty(String content) {
        // Kiểm tra điều kiện
        if (content == null) {
            return true;
        }
        String clean = content.replaceAll("<[^>]*>", "").trim();
        return clean.isEmpty();
    }

    private String incrementVersion(String currentVersion) {
        if (currentVersion == null || currentVersion.trim().isEmpty()) {
            return "1.1";
        }
        String verStr = currentVersion.trim();
        boolean hasV = verStr.toLowerCase().startsWith("v");
        String numStr = hasV ? verStr.substring(1) : verStr;
        try {
            if (numStr.contains(".")) {
                String[] parts = numStr.split("\\.");
                int major = Integer.parseInt(parts[0]);
                int minor = Integer.parseInt(parts[1]);
                minor++;
                return (hasV ? "v" : "") + major + "." + minor;
            } else {
                int major = Integer.parseInt(numStr);
                return (hasV ? "v" : "") + (major + 1) + ".0";
            }
        } catch (Exception e) {
            return verStr + ".1";
        }
    }

    /**
     * Returns a brief description of this servlet.
     */
    @Override
    /**
     * Phuong thuc getServletInfo
     */
    public String getServletInfo() {
        return "AdminPolicy Servlet";
    }
}

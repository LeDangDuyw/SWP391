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
 * Class: AdminPolicy
 * Description: Controller quản trị CRUD danh sách và chi tiết các chính sách bảo hành (Warranty Policy).
 * Hỗ trợ tạo mới, chỉnh sửa, phát hành (Publish), lưu nháp (Save Draft), ẩn (Disable), xóa và ghi nhận lịch sử phiên bản.
 * 
 * Created: 2026-05-29
 * Updated: 2026-07-23
 * Version: v2.9
 *
 * @author DuyLD
 */
public class AdminPolicy extends HttpServlet {


    private PolicyDAO dao;

    /**
     * Khởi tạo đối tượng PolicyDAO để truy vấn DB.
     */
    @Override
    public void init() {
        dao = new PolicyDAO();
    }

    /**
     * Tải danh sách chính sách bảo hành có hỗ trợ phân trang (5 bản ghi/trang) và tìm kiếm/lọc.
     */
    private void loadPolicyList(HttpServletRequest request) throws Exception {
        // BR-44: Danh sách chính sách bảo hành được phân trang 5 bản ghi mỗi trang, sắp xếp giảm dần theo thời gian tạo
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("statusFilter");
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

        totalRecords = dao.countPolicies(keyword, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
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
     * Xử lý yêu cầu GET: Hiển thị danh sách chính sách bảo hành và nạp chính sách đang chọn (selectedPolicy).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("activeTab", "WARRANTY");
            loadPolicyList(request);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    WarrantyPolicy selected = dao.getPolicyById(id);
                    if (selected != null) {
                        selected.setExpiryDate(calculateExpiryDate(selected.getEffectiveDate(), selected.getWarrantyMonths()));
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
            throw new ServletException("Lỗi tải danh sách chính sách bảo hành.", e);
        }

    }

    /**
     * Xử lý các thao tác POST (create, update, delete, publish, saveDraft, disable).
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

                    // BR-24: Tên chính sách phải chứa ít nhất một chữ cái
                    if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty() || !p.getPolicyName().matches(".*\\p{L}.*")) {
                        request.setAttribute("error", "Tên chính sách phải chứa ít nhất một chữ cái và không được chỉ gồm số hoặc ký tự đặc biệt!");
                        request.setAttribute("formData", p);
                        loadPolicyList(request);
                        request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                        return;
                    }

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

                        if (p.getPolicyName() == null || p.getPolicyName().trim().isEmpty() || !p.getPolicyName().matches(".*\\p{L}.*")) {
                            request.setAttribute("error", "Tên chính sách phải chứa ít nhất một chữ cái và không được chỉ gồm số hoặc ký tự đặc biệt!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }

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

                        if (dao.existsPolicyNameForUpdate(p.getPolicyName(), id)) {
                            request.setAttribute("error", "Tên chính sách đã được sử dụng bởi chính sách khác!");
                            request.setAttribute("selectedPolicy", p);
                            loadPolicyList(request);
                            List<model.PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                            request.setAttribute("historyList", historyList);
                            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
                            return;
                        }
                        // Tự động tăng version khi update (ví dụ: 1.0 -> 1.1)
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
                    // BR-39: Xóa hoàn toàn chính sách cùng lịch sử thay đổi phiên bản
                    dao.deletePolicy(id);
                    String deletePageSuffix = (pageParam != null && !pageParam.trim().isEmpty()) ? "?page=" + pageParam.trim() : "";
                    response.sendRedirect(contextPath + "/admin/policy" + deletePageSuffix);
                    break;
                }

                case "publish": {
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    WarrantyPolicy p = dao.getPolicyById(id);
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
            throw new ServletException("Lỗi xử lý thao tác chính sách: " + action, e);
        }
    }

    /**
     * Tạo đối tượng WarrantyPolicy từ dữ liệu các trường trên HTTP Form Request.
     */
    private WarrantyPolicy buildPolicyFromRequest(HttpServletRequest request) {
        WarrantyPolicy p = new WarrantyPolicy();
        String name = request.getParameter("policyName");
        p.setPolicyName(name != null ? name.trim() : null);

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
     * Cập nhật thông tin các thuộc tính của chính sách từ HTTP Form Request.
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
     * Tính toán ngày hết hạn hiệu lực dựa theo ngày bắt đầu và số tháng bảo hành.
     */
    private java.sql.Date calculateExpiryDate(java.sql.Date start, int months) {
        if (start == null) {
            return null;
        }

        java.time.LocalDate ld = start.toLocalDate();
        ld = ld.plusMonths(months);

        return java.sql.Date.valueOf(ld);
    }

    /**
     * Kiểm tra nội dung HTML chính sách có rỗng hay không.
     */
    private boolean isContentEmpty(String content) {
        if (content == null) {
            return true;
        }
        String clean = content.replaceAll("<[^>]*>", "").trim();
        return clean.isEmpty();
    }

    /**
     * Tự động tăng số phiên bản của chính sách (ví dụ: 1.0 -> 1.1 hoặc v1.0 -> v1.1).
     */
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

    @Override
    public String getServletInfo() {
        return "AdminPolicy Servlet";
    }
}


package controller;

/**
 * Class: AdminPolicy
 * Description: Controller quản lý vòng đời chính sách bảo hành (Warranty Policy).
 *              Hỗ trợ xem danh sách phân trang (5 bản ghi/trang - BR-44), tìm kiếm,
 *              lọc trạng thái, xem chi tiết, tạo mới, chỉnh sửa, lưu nháp (DRAFT),
 *              xuất bản (LIVE), vô hiệu hóa (DISABLED - BR-25), xóa và xem lịch sử phiên bản.
 * 
 * Created: 2026-05-29
 * Updated: 2026-07-22
 * Version: v2.9
 *
 * @author DuyLD
 */

import dal.PolicyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.PolicyHistory;
import model.WarrantyPolicy;

public class AdminPolicy extends HttpServlet {

    private PolicyDAO dao;

    /**
     * Khởi tạo Servlet và đối tượng PolicyDAO.
     */
    @Override
    public void init() {
        dao = new PolicyDAO();
    }

    /**
     * Phương thức helper tải danh sách chính sách bảo hành có hỗ trợ lọc từ khóa, trạng thái và phân trang.
     *
     * @param request đối tượng HttpServletRequest
     * @throws Exception nếu xảy ra lỗi SQL
     */
    private void loadPolicyList(HttpServletRequest request) throws Exception {
        // BR-44: Danh sách chính sách bảo hành được phân trang 5 bản ghi/trang, sắp xếp theo thời gian giảm dần
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
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }

        totalRecords = dao.countPolicies(keyword, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;
        policies = dao.getPoliciesPaging(keyword, statusFilter, offset, pageSize);

        request.setAttribute("policies", policies);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
    }

    /**
     * Xử lý các yêu cầu HTTP GET (hiển thị danh sách, xem chi tiết, hiển thị form tạo/chỉnh sửa, xem lịch sử).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "view": {
                    // Xem chi tiết nội dung chính sách
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        WarrantyPolicy policy = dao.getPolicyById(id);
                        request.setAttribute("policy", policy);

                        // Lấy thêm danh sách lịch sử thay đổi phiên bản
                        List<PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                        request.setAttribute("historyList", historyList);

                        request.getRequestDispatcher("/admin/ViewPolicyDetail.jsp").forward(request, response);
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy");
                    break;
                }
                case "edit": {
                    // Hiển thị giao diện chỉnh sửa chính sách
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        WarrantyPolicy policy = dao.getPolicyById(id);
                        request.setAttribute("policy", policy);
                        request.getRequestDispatcher("/admin/EditPolicy.jsp").forward(request, response);
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy");
                    break;
                }
                case "add": {
                    // Hiển thị giao diện tạo mới chính sách
                    request.getRequestDispatcher("/admin/AddPolicy.jsp").forward(request, response);
                    break;
                }
                case "history": {
                    // Xem lịch sử thay đổi phiên bản
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        WarrantyPolicy policy = dao.getPolicyById(id);
                        List<PolicyHistory> historyList = dao.getHistoryByPolicyId(id);
                        request.setAttribute("policy", policy);
                        request.setAttribute("historyList", historyList);
                        request.getRequestDispatcher("/admin/PolicyHistory.jsp").forward(request, response);
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy");
                    break;
                }
                case "list":
                default: {
                    // Hiển thị danh sách chính sách
                    loadPolicyList(request);
                    request.getRequestDispatcher("/admin/PolicyList.jsp").forward(request, response);
                    break;
                }
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý tải thông tin chính sách.", e);
        }
    }

    /**
     * Xử lý các yêu cầu HTTP POST (thêm mới, cập nhật, lưu nháp, xuất bản, vô hiệu hóa, xóa).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "add": {
                    // Thao tác tạo mới chính sách bảo hành
                    String name = request.getParameter("policyName");
                    String desc = request.getParameter("description");
                    String content = request.getParameter("policyContent");
                    String regions = request.getParameter("applicableRegions");
                    String monthsStr = request.getParameter("warrantyMonths");
                    String status = request.getParameter("status");
                    String version = request.getParameter("version");
                    String effectiveStr = request.getParameter("effectiveDate");

                    if (status == null || status.trim().isEmpty()) {
                        status = "DRAFT";
                    }

                    int months = 12;
                    if (monthsStr != null && !monthsStr.trim().isEmpty()) {
                        months = Integer.parseInt(monthsStr.trim());
                    }

                    java.sql.Date effectiveDate = null;
                    if (effectiveStr != null && !effectiveStr.trim().isEmpty()) {
                        effectiveDate = java.sql.Date.valueOf(effectiveStr.trim());
                    }

                    // Kiểm tra trùng tên chính sách
                    if (dao.existsPolicyName(name)) {
                        request.setAttribute("errorMessage", "Tên chính sách đã tồn tại trong hệ thống. Vui lòng nhập tên khác!");
                        request.setAttribute("policyName", name);
                        request.setAttribute("description", desc);
                        request.setAttribute("policyContent", content);
                        request.setAttribute("applicableRegions", regions);
                        request.setAttribute("warrantyMonths", monthsStr);
                        request.setAttribute("status", status);
                        request.setAttribute("version", version);
                        request.setAttribute("effectiveDate", effectiveStr);
                        request.getRequestDispatcher("/admin/AddPolicy.jsp").forward(request, response);
                        return;
                    }

                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    WarrantyPolicy p = new WarrantyPolicy();
                    p.setPolicyName(name);
                    p.setDescription(desc);
                    p.setPolicyContent(content);
                    p.setApplicableRegions(regions);
                    p.setWarrantyMonths(months);
                    p.setStatus(status);
                    p.setVersion(version);
                    p.setEffectiveDate(effectiveDate);
                    p.setCreatedAt(now);
                    p.setUpdatedAt(now);

                    int generatedId = dao.insertPolicy(p);
                    if (generatedId > 0) {
                        // Ghi vết lịch sử tạo mới
                        dao.insertHistory(generatedId, name, version, desc, content, status, "CREATE");
                    }

                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                case "edit": {
                    // Thao tác chỉnh sửa thông tin chính sách
                    int id = Integer.parseInt(request.getParameter("policyId"));
                    String name = request.getParameter("policyName");
                    String desc = request.getParameter("description");
                    String content = request.getParameter("policyContent");
                    String regions = request.getParameter("applicableRegions");
                    String monthsStr = request.getParameter("warrantyMonths");
                    String status = request.getParameter("status");
                    String version = request.getParameter("version");
                    String effectiveStr = request.getParameter("effectiveDate");

                    int months = Integer.parseInt(monthsStr.trim());
                    java.sql.Date effectiveDate = null;
                    if (effectiveStr != null && !effectiveStr.trim().isEmpty()) {
                        effectiveDate = java.sql.Date.valueOf(effectiveStr.trim());
                    }

                    // Kiểm tra trùng tên chính sách khi chỉnh sửa
                    if (dao.existsPolicyNameForUpdate(name, id)) {
                        WarrantyPolicy existingPolicy = dao.getPolicyById(id);
                        request.setAttribute("policy", existingPolicy);
                        request.setAttribute("errorMessage", "Tên chính sách đã tồn tại trong hệ thống. Vui lòng nhập tên khác!");
                        request.getRequestDispatcher("/admin/EditPolicy.jsp").forward(request, response);
                        return;
                    }

                    WarrantyPolicy p = new WarrantyPolicy();
                    p.setPolicyId(id);
                    p.setPolicyName(name);
                    p.setDescription(desc);
                    p.setPolicyContent(content);
                    p.setApplicableRegions(regions);
                    p.setWarrantyMonths(months);
                    p.setStatus(status);
                    p.setVersion(version);
                    p.setEffectiveDate(effectiveDate);

                    dao.updatePolicy(p);
                    // Ghi vết lịch sử cập nhật
                    dao.insertHistory(id, name, version, desc, content, status, "UPDATE");

                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                case "delete": {
                    // Thao tác xóa chính sách
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deletePolicy(id);
                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                case "publish": {
                    // Thao tác xuất bản (LIVE)
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.publishPolicy(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), "LIVE", "PUBLISH");
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                case "saveDraft": {
                    // Thao tác lưu nháp (DRAFT)
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.saveDraft(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), "DRAFT", "SAVE_DRAFT");
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                case "disable": {
                    // BR-25: Thao tác vô hiệu hóa chính sách (DISABLED)
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.disablePolicy(id);
                    WarrantyPolicy p = dao.getPolicyById(id);
                    if (p != null) {
                        dao.insertHistory(id, p.getPolicyName(), p.getVersion(), p.getDescription(), p.getPolicyContent(), "DISABLED", "DISABLE");
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/policy?action=list");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý tác vụ chính sách.", e);
        }
    }
}

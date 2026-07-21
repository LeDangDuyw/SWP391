package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.WarrantyClaim;
import service.WarrantyService;

import java.io.IOException;
import java.util.List;
import utils.ValidationException;

/**
 * StaffWarrantyController handles all warranty-related HTTP requests for Staff.
 *
 * URL pattern : /staff/warranty
 *
 * GET actions : list, detail
 * POST actions : process
 */
@WebServlet("/staff/warranty")
@MultipartConfig(
        maxFileSize = 5L * 1024 * 1024,
        maxRequestSize = 30L * 1024 * 1024,
        fileSizeThreshold = 1024 * 1024
)
public class StaffWarrantyController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private WarrantyService warrantyService;

    @Override
    public void init() {
        warrantyService = new WarrantyService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = getUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Đảm bảo chỉ nhân viên (hoặc admin) truy cập
        if (user.getRoleId() != 2 && user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login?error=Access+Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleList(request, response, user);
                    break;
                case "detail":
                    handleDetail(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/warranty?action=list");
            }
        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            forwardToList(request, response, user);
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý Staff Warranty module.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Users user = getUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleId() != 2 && user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login?error=Access+Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "process":
                    handleProcess(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/warranty?action=list");
            }
        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            String selectedIdParam = request.getParameter("selectedId") != null
                    ? request.getParameter("selectedId")
                    : request.getParameter("id");
            try {
                loadConsoleClaims(request, selectedIdParam);
                request.getRequestDispatcher("/staff/WarrantyProcess.jsp").forward(request, response);
            } catch (Exception loadEx) {
                throw new ServletException("Lỗi tải dữ liệu sau khi xử lý validation error.", loadEx);
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý Staff Warranty module.", e);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception, ServletException, IOException {
        String selectedIdParam = request.getParameter("selectedId") != null
                ? request.getParameter("selectedId")
                : request.getParameter("id");
        loadConsoleClaims(request, selectedIdParam);
        request.getRequestDispatcher("/staff/WarrantyProcess.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception, ServletException, IOException {
        int claimId = parseId(request.getParameter("id"));
        loadConsoleClaims(request, String.valueOf(claimId));
        request.getRequestDispatcher("/staff/WarrantyProcess.jsp").forward(request, response);
    }

    private void handleProcess(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ValidationException, Exception, IOException {
        int claimId = parseId(request.getParameter("id"));
        String newStatus = request.getParameter("newStatus");
        String note = request.getParameter("note");

        if (newStatus == null || newStatus.trim().isEmpty()) {
            throw new ValidationException("Trạng thái mới không được để trống.");
        }

        warrantyService.validateClaim(claimId, newStatus.trim(), user.getUserId(), note);

        response.sendRedirect(request.getContextPath()
                + "/staff/warranty?action=list&selectedId=" + claimId + "&msg=updated");
    }

    private void loadConsoleClaims(HttpServletRequest request, String selectedIdParam) throws Exception {
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("statusFilter");
        int page = parsePage(request.getParameter("page"));
        int offset = (page - 1) * PAGE_SIZE;

        List<WarrantyClaim> claims;
        int total;

        if (keyword != null && !keyword.trim().isEmpty()) {
            claims = warrantyService.searchClaims(keyword.trim(), offset, PAGE_SIZE);
            total = warrantyService.countSearch(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            claims = warrantyService.filterByStatus(statusFilter.trim(), offset, PAGE_SIZE);
            total = warrantyService.countClaims(statusFilter.trim());
            request.setAttribute("statusFilter", statusFilter.trim());
        } else {
            claims = warrantyService.getAllClaims(offset, PAGE_SIZE);
            total = warrantyService.countClaims(null);
        }

        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("claims", claims);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        if (selectedIdParam != null && !selectedIdParam.isEmpty()) {
            try {
                int selectedId = Integer.parseInt(selectedIdParam);
                WarrantyClaim selectedClaim = warrantyService.getClaimDetail(selectedId);
                request.setAttribute("selectedClaim", selectedClaim);
                request.setAttribute("selectedHistory", warrantyService.getHistory(selectedId));
                request.setAttribute("selectedImages", warrantyService.getClaimImages(selectedId));
            } catch (Exception ignored) {
            }
        }
    }

    private void forwardToList(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        try {
            loadConsoleClaims(request, null);
            request.getRequestDispatcher("/staff/WarrantyProcess.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Users getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Users) session.getAttribute("user") : null;
    }

    private int parsePage(String param) {
        try {
            int p = Integer.parseInt(param);
            return p > 0 ? p : 1;
        } catch (Exception e) {
            return 1;
        }
    }

    private int parseId(String param) throws ValidationException {
        try {
            return Integer.parseInt(param);
        } catch (Exception e) {
            throw new ValidationException("ID không hợp lệ: " + param);
        }
    }
}

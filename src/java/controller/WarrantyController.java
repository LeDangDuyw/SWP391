package controller;

/**
 * Class: WarrantyController
 * Description: Controller tiếp nhận và điều hướng các yêu cầu nghiệp vụ Bảo hành
 *              (Tra cứu điều kiện, tạo mới yêu cầu đính kèm ảnh, xem chi tiết, hủy yêu cầu,
 *              cập nhật trạng thái xử lý của Staff và Take Over của Admin).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-22
 * Version: v2.4
 *
 * @author DuyLD
 */

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Users;
import model.WarrantyClaim;
import service.WarrantyService;
import utils.ValidationException;

@WebServlet("/warranty")
@MultipartConfig(
        maxFileSize = 5L * 1024 * 1024,      // Tối đa 5MB mỗi ảnh đính kèm (BR-42)
        maxRequestSize = 30L * 1024 * 1024,   // Tối đa 30MB tổng request upload
        fileSizeThreshold = 1024 * 1024       // > 1MB thì lưu đĩa tạm
)
public class WarrantyController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private WarrantyService warrantyService;

    /**
     * Khởi tạo Servlet và đối tượng WarrantyService.
     */
    @Override
    public void init() {
        warrantyService = new WarrantyService();
    }

    /**
     * Nạp danh mục sản phẩm phục vụ hiển thị header/menu.
     */
    private void loadCategories(HttpServletRequest request) {
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            System.out.println("WarrantyController.loadCategories Error: " + e.getMessage());
        }
    }

    /**
     * Xử lý yêu cầu HTTP GET (mở wizard tạo yêu cầu, tra cứu, xem danh sách, xem chi tiết).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        loadCategories(request);
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "index";
        }

        try {
            switch (action) {
                case "index":
                    renderIndex(request, response);
                    break;
                case "checkEligibility":
                    handleCheckEligibility(request, response);
                    break;
                case "list":
                    renderCustomerList(request, response);
                    break;
                case "detail":
                    renderClaimDetail(request, response);
                    break;
                case "staffProcess":
                    renderStaffConsole(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/warranty");
                    break;
            }
        } catch (ValidationException ve) {
            request.setAttribute("errorMessage", ve.getMessage());
            request.getRequestDispatcher("/warranty_center.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý yêu cầu bảo hành.", e);
        }
    }

    /**
     * Xử lý yêu cầu HTTP POST (nộp đơn bảo hành, hủy đơn, nhân viên cập nhật trạng thái, Admin take over).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        loadCategories(request);
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "submit";
        }

        try {
            switch (action) {
                case "submit":
                    handleSubmit(request, response);
                    break;
                case "cancel":
                    handleCustomerCancel(request, response);
                    break;
                case "updateStatus":
                    handleStaffUpdateStatus(request, response);
                    break;
                case "takeOver":
                    handleTakeOver(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/warranty");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý tác vụ bảo hành.", e);
        }
    }

    /**
     * Render giao diện trung tâm bảo hành (Wizard nộp đơn).
     */
    private void renderIndex(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user != null && user.getRoleId() == 3) {
            List<model.WarrantyPurchasedProduct> purchasedProducts =
                    warrantyService.getPurchasedProducts(user.getUserId());
            request.setAttribute("purchasedProducts", purchasedProducts);
        }

        request.getRequestDispatcher("/warranty_center.jsp").forward(request, response);
    }

    /**
     * Xử lý tra cứu tính hợp lệ bảo hành theo số serial.
     */
    private void handleCheckEligibility(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        String serialNumber = request.getParameter("serialNumber");
        Users user = requireLogin(request, response);
        if (user == null) return;

        try {
            model.WarrantyEligibilityInfo info =
                    warrantyService.checkEligibility(serialNumber, user.getUserId());

            request.setAttribute("eligibilityInfo", info);
            request.setAttribute("step", 2);
            renderIndex(request, response);

        } catch (ValidationException ve) {
            request.setAttribute("eligibilityError", ve.getMessage());
            request.setAttribute("searchedSerial", serialNumber);
            request.setAttribute("step", 1);
            renderIndex(request, response);
        }
    }

    /**
     * Xử lý nộp đơn tạo yêu cầu bảo hành mới kèm đính kèm ảnh minh chứng.
     */
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireLogin(request, response);
        if (user == null) return;

        String serialNumber = request.getParameter("serialNumber");
        String title        = request.getParameter("title");
        String description  = request.getParameter("description");

        List<Part> imageParts = new ArrayList<>();
        try {
            for (Part p : request.getParts()) {
                if ("images".equals(p.getName()) && p.getSize() > 0) {
                    imageParts.add(p);
                }
            }
        } catch (Exception ignored) {
        }

        try {
            int claimId = warrantyService.submitWarranty(
                    user.getUserId(), serialNumber, title, description, imageParts);

            request.getSession().setAttribute("flashSuccess",
                    "Gửi yêu cầu bảo hành #" + claimId + " thành công!");
            response.sendRedirect(request.getContextPath() + "/warranty?action=detail&id=" + claimId);

        } catch (ValidationException ve) {
            request.setAttribute("submitError", ve.getMessage());
            request.setAttribute("serialNumber", serialNumber);
            request.setAttribute("title", title);
            request.setAttribute("description", description);
            request.setAttribute("step", 3);

            try {
                model.WarrantyEligibilityInfo info =
                        warrantyService.checkEligibility(serialNumber, user.getUserId());
                request.setAttribute("eligibilityInfo", info);
            } catch (Exception ignored) {
            }

            renderIndex(request, response);
        }
    }

    /**
     * Khách hàng tự hủy phiếu bảo hành PENDING của mình.
     */
    private void handleCustomerCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireLogin(request, response);
        if (user == null) return;

        int claimId = Integer.parseInt(request.getParameter("claimId"));

        try {
            warrantyService.cancelWarranty(claimId, user.getUserId());
            request.getSession().setAttribute("flashSuccess", "Đã huỷ yêu cầu bảo hành #" + claimId);
        } catch (ValidationException ve) {
            request.getSession().setAttribute("flashError", ve.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/warranty?action=detail&id=" + claimId);
    }

    /**
     * Hiển thị danh sách các phiếu bảo hành của khách hàng.
     */
    private void renderCustomerList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireLogin(request, response);
        if (user == null) return;

        List<WarrantyClaim> list = warrantyService.getCustomerClaims(user.getUserId());
        request.setAttribute("claims", list);
        request.getRequestDispatcher("/warranty_list.jsp").forward(request, response);
    }

    /**
     * Hiển thị thông tin chi tiết một phiếu bảo hành (kèm ảnh minh chứng & lịch sử timeline).
     */
    private void renderClaimDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/warranty?action=list");
            return;
        }

        int claimId = Integer.parseInt(idParam);

        try {
            WarrantyClaim claim = warrantyService.getClaimDetail(claimId);
            List<model.WarrantyClaimImage> images = warrantyService.getClaimImages(claimId);
            List<model.WarrantyHistory> history   = warrantyService.getHistory(claimId);

            request.setAttribute("claim", claim);
            request.setAttribute("images", images);
            request.setAttribute("historyList", history);

            request.getRequestDispatcher("/warranty_detail.jsp").forward(request, response);

        } catch (ValidationException ve) {
            request.setAttribute("errorMessage", ve.getMessage());
            request.getRequestDispatcher("/warranty_center.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị console xử lý bảo hành cho Nhân viên / Admin.
     */
    private void renderStaffConsole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireStaffOrAdmin(request, response);
        if (user == null) return;

        String statusFilter = request.getParameter("statusFilter");
        String keyword      = request.getParameter("keyword");
        String pageParam    = request.getParameter("page");

        int page = 1;
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        List<WarrantyClaim> claims;
        int totalClaims;

        if (keyword != null && !keyword.trim().isEmpty()) {
            claims = warrantyService.searchClaims(keyword, offset, PAGE_SIZE);
            totalClaims = warrantyService.countSearch(keyword);
        } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            claims = warrantyService.filterByStatus(statusFilter, offset, PAGE_SIZE);
            totalClaims = warrantyService.countClaims(statusFilter);
        } else {
            claims = warrantyService.getAllClaims(offset, PAGE_SIZE);
            totalClaims = warrantyService.countClaims(null);
        }

        int totalPages = (int) Math.ceil((double) totalClaims / PAGE_SIZE);

        if (user.getRoleId() == 1) {
            List<Users> staffList = warrantyService.getStaffList();
            request.setAttribute("staffList", staffList);
        }

        request.setAttribute("claims", claims);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/staff/warranty_process.jsp").forward(request, response);
    }

    /**
     * Xử lý cập nhật trạng thái phiếu bảo hành từ Nhân viên.
     */
    private void handleStaffUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireStaffOrAdmin(request, response);
        if (user == null) return;

        int claimId     = Integer.parseInt(request.getParameter("claimId"));
        String newStatus = request.getParameter("newStatus");
        String note      = request.getParameter("note");

        try {
            warrantyService.validateClaim(claimId, newStatus, user.getUserId(), note);
            request.getSession().setAttribute("flashSuccess",
                    "Cập nhật trạng thái phiếu #" + claimId + " sang " + newStatus + " thành công.");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("flashError", ve.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/warranty?action=staffProcess");
    }

    /**
     * Admin tự tiếp nhận (Take Over) hoặc chuyển giao phiếu bảo hành cho nhân viên khác.
     */
    private void handleTakeOver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

        Users user = requireStaffOrAdmin(request, response);
        if (user == null) return;

        if (user.getRoleId() != 1) {
            request.getSession().setAttribute("flashError", "Chỉ Admin mới có quyền Take Over / Reassign.");
            response.sendRedirect(request.getContextPath() + "/warranty?action=staffProcess");
            return;
        }

        int claimId = Integer.parseInt(request.getParameter("claimId"));
        String targetStaffStr = request.getParameter("targetStaffId");
        String note = request.getParameter("takeOverNote");

        int targetStaffId = user.getUserId();
        if (targetStaffStr != null && !targetStaffStr.trim().isEmpty()) {
            try {
                targetStaffId = Integer.parseInt(targetStaffStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        try {
            warrantyService.takeOverClaim(claimId, targetStaffId, note);
            request.getSession().setAttribute("flashSuccess",
                    "Đã chuyển giao xử lý phiếu bảo hành #" + claimId + " thành công.");
        } catch (ValidationException ve) {
            request.getSession().setAttribute("flashError", ve.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/warranty?action=staffProcess");
    }

    /**
     * Yêu cầu xác thực đăng nhập người dùng.
     */
    private Users requireLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
    }

    /**
     * Yêu cầu xác thực quyền Nhân viên (roleId=2) hoặc Admin (roleId=1).
     */
    private Users requireStaffOrAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Users user = requireLogin(request, response);
        if (user == null) return null;

        if (user.getRoleId() != 1 && user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return null;
        }
        return user;
    }
}
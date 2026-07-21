package controller;

/**
 * Class: WarrantyController
 * Description: Controller tiếp nhận các yêu cầu bảo hành từ khách hàng và nhân viên.
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-19
 * Version: v2.3
 *
 * @author DuyLD
 */

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Users;
import model.WarrantyClaim;
import service.WarrantyService;
import dal.CategoryDAO;
import model.Category;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import utils.ValidationException;

@WebServlet("/warranty")
@MultipartConfig(
        maxFileSize = 5L * 1024 * 1024, // 5MB / file — khớp MAX_IMAGE_SIZE ở Service
        maxRequestSize = 30L * 1024 * 1024, // tổng request: 5 ảnh * 5MB + buffer cho field text khác
        fileSizeThreshold = 1024 * 1024 // > 1MB thì ghi tạm ra disk thay vì giữ hết trong memory
)
public class WarrantyController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private WarrantyService warrantyService;

    @Override
    /**
     * Phuong thuc init
     */
    public void init() {
        warrantyService = new WarrantyService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = getUser(request);
        // Kiểm tra xác thực người dùng / phiên đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        // Kiểm tra điều kiện
        if (action == null) {
            action = "list";
        }

        // Kiểm tra điều kiện
        if (user.getRoleId() == 2) {
            response.sendRedirect(request.getContextPath() + "/staff/warranty?action=" + action
                    + (request.getParameter("id") != null ? "&id=" + request.getParameter("id") : "")
                    + (request.getParameter("selectedId") != null ? "&selectedId=" + request.getParameter("selectedId") : ""));
            return;
        }

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            switch (action) {
                case "list":
                    handleList(request, response, user);
                    break;
                case "detail":
                    handleDetail(request, response, user);
                    break;
                case "checkEligibility":
                    handleCheckEligibility(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/warranty?action=list");
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            forwardToList(request, response, user);
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý Warranty module.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Users user = getUser(request);
        // Kiểm tra xác thực người dùng / phiên đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        // Kiểm tra điều kiện
        if (action == null) {
            action = "";
        }

        // Kiểm tra điều kiện
        if (user.getRoleId() == 2) {
            response.sendRedirect(request.getContextPath() + "/staff/warranty?action=list");
            return;
        }

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            switch (action) {
                case "submit":
                    handleSubmit(request, response, user);
                    break;
                case "cancel":
                    handleCancel(request, response, user);
                    break;
                case "process":
                    handleProcess(request, response, user);
                    break;
                case "takeOver":
                    handleTakeOver(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/warranty?action=list");
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            // Lấy selectedId từ request để giữ nguyên detail panel sau khi lỗi
            String selectedIdParam
                    = request.getParameter("selectedId") != null
                    ? request.getParameter("selectedId")
                    : request.getParameter("id");
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try {
                // Kiểm tra điều kiện
                if (isCustomer(user)) {
                    loadCustomerClaims(request, user);
                    request.getRequestDispatcher("/customer/warranty_center.jsp").forward(request, response);
                } else {
                    loadConsoleClaims(request, selectedIdParam);
                    request.getRequestDispatcher("/admin/WarrantyProcess.jsp").forward(request, response);
                }
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            } catch (Exception loadEx) {
                // Nếu load data cũng fail thì throw ServletException thật sự,
                // không nuốt lỗi khiến trang render trắng không rõ nguyên nhân
                throw new ServletException("Lỗi tải dữ liệu sau khi xử lý validation error.", loadEx);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (IllegalStateException e) {
            // Request multipart vượt quá maxRequestSize/maxFileSize khai báo ở
            // @MultipartConfig, ném ra trước khi vào được handleXxx().
            request.setAttribute("errorMessage",
                    "Dung lượng ảnh tải lên vượt quá giới hạn cho phép (tối đa 5 ảnh, mỗi ảnh 5MB).");
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try {
                // Kiểm tra điều kiện
                if (isCustomer(user)) {
                    loadCustomerClaims(request, user);
                    request.getRequestDispatcher("/customer/warranty_center.jsp").forward(request, response);
                } else {
                    loadConsoleClaims(request, null);
                    request.getRequestDispatcher("/admin/WarrantyProcess.jsp").forward(request, response);
                }
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            } catch (Exception loadEx) {
                throw new ServletException("Lỗi tải dữ liệu sau khi xử lý lỗi upload ảnh.", loadEx);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý Warranty module.", e);
        }
    }

    /**
     * GET list: Customer → warranty-center.jsp (loads their own claims)
     * Staff/Admin → warranty-console.jsp (loads all claims, supports
     * selectedId)
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception, ServletException, IOException {

        // Kiểm tra điều kiện
        if (isCustomer(user)) {
            loadCustomerClaims(request, user);
            request.getRequestDispatcher("/customer/warranty_center.jsp").forward(request, response);
        } else {
            // selectedId: click một row trong console để xem detail panel
            String selectedIdParam
                    = request.getParameter("selectedId") != null
                    ? request.getParameter("selectedId")
                    : request.getParameter("id");
            loadConsoleClaims(request, selectedIdParam);
            request.getRequestDispatcher("/admin/WarrantyProcess.jsp").forward(request, response);
        }
    }

    /**
     * GET detail: Dùng cho customer khi click "View" trên một claim cụ thể.
     * Forward sang detail.jsp (trang riêng với timeline đầy đủ).
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception, ServletException, IOException {

        int claimId = parseId(request.getParameter("id"));
        WarrantyClaim claim = warrantyService.getClaimDetail(claimId);

        // BR-18: A customer may view the complete information and processing history of their own warranty requests only.
        if (isCustomer(user) && claim != null && claim.getCustomerId() != user.getUserId()) {
            throw new ValidationException("Bạn không có quyền xem yêu cầu này.");
        }

        request.setAttribute("selectedClaim", claim);
        request.setAttribute("selectedHistory", warrantyService.getHistory(claimId));
        request.setAttribute("selectedImages", warrantyService.getClaimImages(claimId));

        // Kiểm tra điều kiện
        if (isCustomer(user)) {
            List<Category> categories = new CategoryDAO().getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/customer/warranty_detail.jsp")
                    .forward(request, response);
        } else {
            loadConsoleClaims(request, String.valueOf(claimId));
            request.getRequestDispatcher("/admin/WarrantyProcess.jsp")
                    .forward(request, response);
        }
    }

    /**
     * GET checkEligibility: Kiểm tra serial number còn bảo hành không, trả kết
     * quả cho warranty-center.jsp.
     */
    private void handleCheckEligibility(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception, ServletException, IOException {

        String serial = request.getParameter("serialNumber");

        // Kiểm tra điều kiện
        if (serial != null) {
            // Kiểm tra điều kiện
            if (serial.trim().isEmpty()) {
                request.setAttribute("eligibilityResult", "INVALID");
                request.setAttribute("eligibilityMessage", "Vui lòng nhập số serial.");
            } else {
                serial = serial.trim();
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try {
                    model.WarrantyEligibilityInfo info = warrantyService.checkEligibility(serial, user.getUserId());
                    request.setAttribute("eligibilityResult", "VALID");
                    // Dữ liệu cho Step 2 (Warranty Information) của wizard Submit Claim
                    request.setAttribute("eligibilityInfo", info);
                // Bắt và xử lý ngoại lệ xảy ra trong khối try
                } catch (ValidationException e) {
                    // Bắt lỗi tại đây để hiển thị đúng eligibilityMessage,
                    // thay vì để nổi lên doGet() rồi forward về list không kèm kết quả.
                    request.setAttribute("eligibilityResult", "INVALID");
                    request.setAttribute("eligibilityMessage", e.getMessage());
                }
            }
        }

        // Load claims để giữ bảng Recent Activity
        loadCustomerClaims(request, user);
        request.getRequestDispatcher("/customer/warranty_center.jsp").forward(request, response);
    }

    /**
     * POST submit: tạo claim mới (customer only), kèm tối đa 5 ảnh đính kèm.
     */
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ValidationException, Exception, IOException, ServletException {

        String serialNumber = request.getParameter("serialNumber");
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        // Trả về form với giá trị đã nhập nếu validation fail
        request.setAttribute("serialNumber", serialNumber);
        request.setAttribute("title", title);
        request.setAttribute("description", description);

        // Lấy các Part tên "images" — input file có attribute multiple nên
        // browser gửi nhiều Part cùng tên trong 1 request multipart/form-data.
        List<Part> imageParts = new ArrayList<>();
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            for (Part part : request.getParts()) {
                // Kiểm tra điều kiện
                if ("images".equals(part.getName())) {
                    imageParts.add(part);
                }
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (IllegalStateException e) {
            // Container ném lỗi này khi 1 file hoặc cả request vượt giới hạn
            // khai báo ở @MultipartConfig (maxFileSize / maxRequestSize).
            throw new ValidationException(
                    "Dung lượng ảnh tải lên vượt quá giới hạn cho phép (tối đa 5 ảnh, mỗi ảnh 5MB).");
        }

        int claimId = warrantyService.submitWarranty(
                user.getUserId(), serialNumber, title, description, imageParts);

        response.sendRedirect(request.getContextPath()
                + "/warranty?action=list&msg=submitted");
    }

    /**
     * POST cancel: customer huỷ claim PENDING.
     */
    private void handleCancel(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ValidationException, Exception, IOException {

        int claimId = parseId(request.getParameter("id"));
        warrantyService.cancelWarranty(claimId, user.getUserId());

        // Redirect về đúng trang theo role
        // Kiểm tra điều kiện
        if (isCustomer(user)) {
            response.sendRedirect(request.getContextPath()
                    + "/warranty?action=list&msg=cancelled");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/warranty?action=list&msg=cancelled&selectedId=" + claimId);
        }
    }

    /**
     * POST process: staff/admin cập nhật trạng thái claim.
     */
    private void handleProcess(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ValidationException, Exception, IOException {

        // Chỉ Staff (roleId=2) và Admin (roleId=1) được phép xử lý claim
        // Kiểm tra điều kiện
        if (isCustomer(user)) {
            throw new ValidationException("Bạn không có quyền thực hiện thao tác này.");
        }

        int claimId = parseId(request.getParameter("id"));
        String newStatus = request.getParameter("newStatus");
        String note = request.getParameter("note");

        // Kiểm tra điều kiện
        if (newStatus == null || newStatus.trim().isEmpty()) {
            throw new ValidationException("Trạng thái mới không được để trống.");
        }

        warrantyService.validateClaim(claimId, newStatus.trim(), user.getUserId(), note);

        // Nếu POST từ console thì redirect về console, giữ claim đang chọn
        String redirectTo = request.getParameter("redirectTo");
        // Kiểm tra điều kiện
        if ("console".equals(redirectTo)) {
            response.sendRedirect(request.getContextPath()
                    + "/warranty?action=list&selectedId=" + claimId + "&msg=updated");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/warranty?action=detail&id=" + claimId + "&msg=updated");
        }
    }

    /**
     * POST takeOver: Admin tiếp nhận (Take Over) hoặc gán lại (Reassign) claim cho staff khác.
     * Chỉ Admin (roleId == 1) mới được gọi action này.
     */
    private void handleTakeOver(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ValidationException, Exception, IOException {

        // Chỉ Admin mới được phép take over / reassign
        if (user.getRoleId() != 1) {
            throw new ValidationException("Chỉ Admin mới có quyền thực hiện thao tác này.");
        }

        int claimId = parseId(request.getParameter("id"));
        String newStaffIdParam = request.getParameter("newStaffId");
        String note = request.getParameter("note");

        // Nếu không chọn staff cụ thể (hoặc chọn -1), tự gán cho Admin hiện tại (Take Over)
        int newStaffId;
        try {
            newStaffId = Integer.parseInt(newStaffIdParam);
            if (newStaffId <= 0) newStaffId = user.getUserId();
        } catch (Exception e) {
            newStaffId = user.getUserId();
        }

        warrantyService.takeOverClaim(claimId, newStaffId, note);

        response.sendRedirect(request.getContextPath()
                + "/warranty?action=list&selectedId=" + claimId + "&msg=takeover");
    }

    /**
     * Loads claims cho customer view (warranty-center.jsp).
     */
    private void loadCustomerClaims(HttpServletRequest request, Users user) throws Exception {
        List<WarrantyClaim> claims = warrantyService.getCustomerClaims(user.getUserId());
        request.setAttribute("claims", claims);

        // Load categories to populate standard navigation header
        List<Category> categories = new CategoryDAO().getAllCategories();
        request.setAttribute("categories", categories);

        // Step 1 wizard cần danh sách sản phẩm đã mua để khách chọn thay vì
        // gõ tay serial number — load luôn ở đây vì handleList/handleCheckEligibility/
        // error handler trong doGet/doPost đều gọi qua loadCustomerClaims().
        List<model.WarrantyPurchasedProduct> purchasedProducts = warrantyService.getPurchasedProducts(user.getUserId());
        request.setAttribute("purchasedProducts", purchasedProducts);
    }

    /**
     * Loads claims cho staff/admin console (warranty-console.jsp). Nếu
     * selectedIdParam != null thì cũng load selectedClaim + selectedHistory.
     */
    private void loadConsoleClaims(HttpServletRequest request, String selectedIdParam) throws Exception {
        // Keyword và status filter
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("statusFilter");
        int page = parsePage(request.getParameter("page"));
        int offset = (page - 1) * PAGE_SIZE;

        List<WarrantyClaim> claims;
        int total;

        // Kiểm tra điều kiện
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

        // Load staff list để Admin có dropdown Reassign
        try {
            request.setAttribute("staffList", warrantyService.getStaffList());
        } catch (Exception ignored) {
            // Nếu query thất bại thì dropdown rỗng, không ảnh hưởng luồng chính
        }

        // Load selected claim vào detail panel
        // Kiểm tra điều kiện
        if (selectedIdParam != null && !selectedIdParam.isEmpty()) {
            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try {
                int selectedId = Integer.parseInt(selectedIdParam);
                WarrantyClaim selectedClaim = warrantyService.getClaimDetail(selectedId);
                request.setAttribute("selectedClaim", selectedClaim);
                request.setAttribute("selectedHistory", warrantyService.getHistory(selectedId));
                request.setAttribute("selectedImages", warrantyService.getClaimImages(selectedId));
            // Bắt và xử lý ngoại lệ xảy ra trong khối try
            } catch (Exception ignored) {
                // Nếu ID không hợp lệ thì bỏ qua, detail panel hiện trống
            }
        }
    }

    /**
     * Forward về đúng list page theo role.
     */
    private void forwardToList(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            // Kiểm tra điều kiện
            if (isCustomer(user)) {
                loadCustomerClaims(request, user);
                request.getRequestDispatcher("/customer/warranty_center.jsp").forward(request, response);
            } else {
                loadConsoleClaims(request, null);
                request.getRequestDispatcher("/admin/WarrantyProcess.jsp").forward(request, response);
            }
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Users getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Users) session.getAttribute("user") : null;
    }

    private boolean isCustomer(Users user) {
        return user.getRoleId() == 3 || user.getRoleId() == 4;
    }

    private int parsePage(String param) {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            int p = Integer.parseInt(param);
            return p > 0 ? p : 1;
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            return 1;
        }
    }

    private int parseId(String param) throws ValidationException {
        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            return Integer.parseInt(param);
        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            throw new ValidationException("ID không hợp lệ: " + param);
        }
    }
}
package service;

/**
 * Class: WarrantyService
 * Description: Lớp xử lý logic nghiệp vụ bảo hành (Warranty Service).
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-19
 * Version: v2.3
 *
 * @author DuyLD
 */

import dal.WarrantyDAO;
import dal.WarrantyHistoryDAO;
import dal.WarrantyClaimImageDAO;
import model.WarrantyClaim;
import model.WarrantyHistory;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import utils.ValidationException;

public class WarrantyService {

    private final WarrantyDAO warrantyDAO;
    private final WarrantyHistoryDAO historyDAO;
    private final WarrantyClaimImageDAO imageDAO;

    // ── IMAGE UPLOAD CONFIG ───────────────────────────────────────────────────

    private static final int MAX_IMAGES = 5;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_CONTENT_TYPES =
            List.of("image/jpeg", "image/png", "image/jpg", "image/webp");

    // Thư mục lưu ảnh trên disk, nằm ngoài thư mục build của webapp để không bị
    // mất khi redeploy. URL trả về cho client sẽ map qua servlet/context riêng
    // (xem ghi chú ở WarrantyController khi đăng ký static resource mapping).
    private static final String UPLOAD_DIR = System.getProperty("warranty.upload.dir",
            System.getProperty("user.home") + File.separator + "uploads" + File.separator + "warranty");

    /**
     * Phuong thuc WarrantyService
     */
    public WarrantyService() {
        this.warrantyDAO = new WarrantyDAO();
        this.historyDAO  = new WarrantyHistoryDAO();
        this.imageDAO    = new WarrantyClaimImageDAO();
    }

    // ── SUBMIT ────────────────────────────────────────────────────────────────

    public int submitWarranty(int customerId, String serialNumber,
            String title, String description, List<Part> images)
            throws ValidationException, Exception {

        // Kiểm tra điều kiện
        if (serialNumber == null || serialNumber.trim().isEmpty()) {
            throw new ValidationException("Số serial không được để trống.");
        }
        // Kiểm tra điều kiện
        if (title == null || title.trim().isEmpty()) {
            throw new ValidationException("Tiêu đề không được để trống.");
        }
        // Kiểm tra điều kiện
        if (description == null || description.trim().isEmpty()) {
            throw new ValidationException("Mô tả lỗi không được để trống.");
        }

        // BR-43: Warranty request field lengths: serial number <= 100 characters, title <= 200 characters, defect description <= 2000 characters
        if (serialNumber.trim().length() > 100) {
            throw new ValidationException("Số serial không được vượt quá 100 ký tự.");
        }
        if (title.trim().length() > 200) {
            throw new ValidationException("Tiêu đề không được vượt quá 200 ký tự.");
        }
        if (description.trim().length() > 2000) {
            throw new ValidationException("Mô tả lỗi không được vượt quá 2000 ký tự.");
        }

        // Validate ảnh TRƯỚC khi đụng tới DB hoặc disk, để fail-fast và
        // không tạo claim "mồ côi" nếu ảnh không hợp lệ.
        List<Part> validImageParts = filterImageParts(images);
        validateImages(validImageParts);

        serialNumber = serialNumber.trim();

        // Kiểm tra điều kiện
        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }

        // BR-15: A customer can submit a warranty request only for a product that belongs to their completed order
        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }

        // BR-15: ... and is linked to an active Warranty Policy, and is still within its warranty period.
        if (!warrantyDAO.isUnderWarranty(serialNumber)) {
            throw new ValidationException("Sản phẩm đã hết hạn bảo hành. Không thể tạo yêu cầu.");
        }

        // Kiểm tra điều kiện
        if (warrantyDAO.hasActiveClaim(serialNumber)) {
            throw new ValidationException("Đã tồn tại một yêu cầu bảo hành đang xử lý cho sản phẩm này.");
        }

        int orderId = warrantyDAO.getOrderIdBySerial(serialNumber);
        int orderDetailId = warrantyDAO.getOrderDetailIdBySerial(serialNumber);

        WarrantyClaim claim = new WarrantyClaim();
        claim.setCustomerId(customerId);
        claim.setOrderId(orderId);
        claim.setOrderDetailId(orderDetailId);
        claim.setSerialNumber(serialNumber);
        claim.setTitle(title.trim());
        claim.setDescription(description.trim());
        // BR-16: Every newly submitted warranty request shall be created with the initial status PENDING
        claim.setStatus("PENDING");

        int claimId = warrantyDAO.insertClaim(claim);

        // BR-17: Every warranty request creation, cancellation, and status transition shall be recorded in the Warranty History log
        insertHistory(claimId, description.trim(), "PENDING",
                "Yêu cầu bảo hành đã được gửi và đang chờ xử lý.");

        // Lưu ảnh SAU khi claim đã có claimId
        if (!validImageParts.isEmpty()) {
            saveClaimImages(claimId, validImageParts);
        }

        return claimId;
    }

    // ── IMAGE UPLOAD HELPERS ──────────────────────────────────────────────────

    /**
     * Lọc ra các Part thực sự là file ảnh được chọn (bỏ qua các Part rỗng do
     * trình duyệt gửi khi người dùng không chọn đủ 5 ô input, hoặc các Part
     * không phải field file).
     */
    private List<Part> filterImageParts(List<Part> images) {
        List<Part> result = new ArrayList<>();
        // Kiểm tra điều kiện
        if (images == null) {
            return result;
        }
        for (Part p : images) {
            // Kiểm tra điều kiện
            if (p != null && p.getSize() > 0 && p.getSubmittedFileName() != null
                    && !p.getSubmittedFileName().trim().isEmpty()) {
                result.add(p);
            }
        }
        return result;
    }

    /**
     * Validate số lượng, dung lượng và định dạng ảnh.
     * Ném ValidationException với message tiếng Việt rõ ràng cho từng trường hợp.
     */
    private void validateImages(List<Part> images) throws ValidationException {
        // BR-08: All online warranty requests submitted by customers must include valid evidence (images, videos, or documents).
        if (images == null || images.isEmpty()) {
            throw new ValidationException("Yêu cầu bảo hành trực tuyến bắt buộc phải kèm theo ít nhất 1 ảnh bằng chứng.");
        }

        // BR-42: Warranty request images: up to 5 files may be attached
        if (images.size() > MAX_IMAGES) {
            throw new ValidationException(
                    "Chỉ được tải lên tối đa " + MAX_IMAGES + " ảnh.");
        }

        for (Part p : images) {
            // BR-42: maximum 5MB per file
            if (p.getSize() > MAX_IMAGE_SIZE) {
                throw new ValidationException(
                        "Ảnh \"" + p.getSubmittedFileName() + "\" vượt quá 5MB. "
                        + "Vui lòng chọn ảnh nhỏ hơn.");
            }

            // BR-42: in JPEG, PNG, JPG, or WEBP format
            String contentType = p.getContentType();
            if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
                throw new ValidationException(
                        "Ảnh \"" + p.getSubmittedFileName() + "\" không đúng định dạng. "
                        + "Chỉ chấp nhận JPG, PNG hoặc WEBP.");
            }
        }
    }

    /**
     * Ghi các Part ảnh xuống disk dưới tên file ngẫu nhiên (UUID) để tránh
     * trùng lặp/đụng tên cũng như tránh path traversal qua tên file gốc của
     * người dùng, rồi insert batch các image_url tương ứng vào DB.
     */
    private void saveClaimImages(int claimId, List<Part> images) throws Exception {
        Path uploadPath = Paths.get(UPLOAD_DIR, String.valueOf(claimId));
        Files.createDirectories(uploadPath);

        List<String> savedUrls = new ArrayList<>();

        for (Part p : images) {
            String originalName = p.getSubmittedFileName();
            String ext = "";
            int dot = originalName.lastIndexOf('.');
            // Kiểm tra điều kiện
            if (dot >= 0) {
                ext = originalName.substring(dot).toLowerCase();
            }
            // Whitelist phần mở rộng để tránh lưu file thực thi dưới tên giả mạo
            // Kiểm tra điều kiện
            if (!ext.matches("\\.(jpg|jpeg|png|webp)")) {
                ext = ".jpg";
            }

            String storedFileName = UUID.randomUUID().toString() + ext;
            Path targetFile = uploadPath.resolve(storedFileName);

            // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
            try (InputStream in = p.getInputStream()) {
                Files.copy(in, targetFile);
            }

            // URL tương đối — controller/servlet phục vụ ảnh tĩnh sẽ map từ
            // đường dẫn này, ví dụ: /warranty-images/{claimId}/{storedFileName}
            String relativeUrl = "/warranty-images/" + claimId + "/" + storedFileName;
            savedUrls.add(relativeUrl);
        }

        imageDAO.insertBatch(claimId, savedUrls);
    }

    /**
     * Lấy danh sách ảnh của một claim — dùng cho gallery trên detail.jsp.
     */
    public List<model.WarrantyClaimImage> getClaimImages(int claimId) throws Exception {
        return imageDAO.findByClaimId(claimId);
    }

    // ── CANCEL ────────────────────────────────────────────────────────────────

    public void cancelWarranty(int claimId, int customerId)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertOwner(claim, customerId);

        // BR-05 & BR-19: Customers are only allowed to cancel a warranty request only while its status is PENDING. Once cancelled, the request cannot be restored.
        if (!"PENDING".equals(claim.getStatus())) {
            throw new ValidationException(
                    "Chỉ có thể huỷ yêu cầu bảo hành khi trạng thái là PENDING.");
        }

        warrantyDAO.updateStatus(claimId, "CANCELLED");

        // BR-17: Every warranty request creation, cancellation, and status transition shall be recorded in the Warranty History log
        insertHistory(claimId, claim.getDescription(), "CANCELLED",
                "Khách hàng đã huỷ yêu cầu bảo hành.");
    }

    // ── STAFF CANCEL ──────────────────────────────────────────────────────────

    /**
     * Cho phép Staff/Admin huỷ một claim đang ở trạng thái PENDING.
     * Không kiểm tra ownership vì staff được phép thao tác trên mọi claim.
     *
     * @param claimId ID của claim cần huỷ
     * @param staffId ID của staff thực hiện hành động (dùng để ghi log)
     * @param note    Lý do huỷ (bắt buộc phải có)
     */
    public void staffCancelClaim(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);

        // Kiểm tra điều kiện
        if (!"PENDING".equals(claim.getStatus())) {
            throw new ValidationException(
                    "Chỉ có thể huỷ yêu cầu khi trạng thái là PENDING. "
                    + "Trạng thái hiện tại: " + claim.getStatus());
        }

        warrantyDAO.updateStatus(claimId, "CANCELLED");

        String historyNote = (note != null && !note.trim().isEmpty())
                ? note.trim()
                : "Staff đã huỷ yêu cầu bảo hành.";

        insertHistory(claimId, claim.getDescription(), "CANCELLED", historyNote);
    }

    // ── PROCESS ───────────────────────────────────────────────────────────────

    private void processWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PENDING", "PROCESSING");

        // BR-23: A warranty request cannot be processed simultaneously by multiple Staff members.
        // Atomic update: gán staff + đổi status trong 1 SQL, đồng thời dùng
        // optimistic lock (WHERE status = 'PENDING') để tránh race condition
        // khi 2 staff cùng nhận claim.
        int rows = warrantyDAO.assignStaffAndProcess(claimId, staffId);
        // Kiểm tra điều kiện
        if (rows == 0) {
            throw new ValidationException(
                "Yêu cầu đã được xử lý bởi người khác. Vui lòng tải lại trang.");
        }

        insertHistory(claimId, claim.getDescription(), "PROCESSING",
                (note != null && !note.trim().isEmpty()) ? note : "Đã tiếp nhận và bắt đầu xử lý.");
    }

    // ── APPROVE ───────────────────────────────────────────────────────────────

    private void approveWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "APPROVED");

        // Chỉ staff được gán (staff_id) mới được phép approve claim
        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "APPROVED");

        insertHistory(claimId, claim.getDescription(), "APPROVED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu đã được duyệt.");
    }

    // ── REJECT ────────────────────────────────────────────────────────────────

    private void rejectWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "REJECTED");

        // Chỉ staff được gán (staff_id) mới được phép reject claim
        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "REJECTED");

        insertHistory(claimId, claim.getDescription(), "REJECTED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu bị từ chối.");
    }

    // ── COMPLETE ──────────────────────────────────────────────────────────────

    private void completeWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "APPROVED", "COMPLETED");

        // Chỉ staff được gán (staff_id) mới được phép complete claim
        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "COMPLETED");

        insertHistory(claimId, claim.getDescription(), "COMPLETED",
                (note != null && !note.trim().isEmpty())
                        ? note
                        : "Bảo hành hoàn tất. Sản phẩm đã được trả lại cho khách hàng.");
    }

    // ── VALIDATE ROUTER ───────────────────────────────────────────────────────

    public void validateClaim(int claimId, String newStatus, int staffId, String note)
            throws ValidationException, Exception {

        switch (newStatus) {
            case "PROCESSING":
                processWarranty(claimId, staffId, note);
                break;
            case "APPROVED":
                // Truyền staffId để kiểm tra ownership trước khi approve
                approveWarranty(claimId, staffId, note);
                break;
            case "REJECTED":
                // Truyền staffId để kiểm tra ownership trước khi reject
                rejectWarranty(claimId, staffId, note);
                break;
            case "COMPLETED":
                // Truyền staffId để kiểm tra ownership trước khi complete
                completeWarranty(claimId, staffId, note);
                break;
            case "CANCELLED":
                // Staff cancel: không check ownership, chỉ cho phép từ PENDING
                staffCancelClaim(claimId, staffId, note);
                break;
            default:
                throw new ValidationException("Trạng thái không hợp lệ: " + newStatus);
        }
    }

    // ── QUERIES ───────────────────────────────────────────────────────────────

    public List<WarrantyClaim> getCustomerClaims(int customerId) throws Exception {
        return warrantyDAO.findByCustomer(customerId);
    }

    /**
     * Phuong thuc getClaimDetail
     */
    public WarrantyClaim getClaimDetail(int claimId) throws ValidationException, Exception {
        return getClaim(claimId);
    }

    /**
     * Phuong thuc getHistory
     */
    public List<WarrantyHistory> getHistory(int claimId) throws Exception {
        return historyDAO.findByWarrantyId(claimId);
    }

    /**
     * Phuong thuc getAllClaims
     */
    public List<WarrantyClaim> getAllClaims(int offset, int limit) throws Exception {
        return warrantyDAO.findAll(offset, limit);
    }

    /**
     * Phuong thuc countClaims
     */
    public int countClaims(String status) throws Exception {
        return warrantyDAO.count(status);
    }

    /**
     * Phuong thuc searchClaims
     */
    public List<WarrantyClaim> searchClaims(String keyword, int offset, int limit) throws Exception {
        return warrantyDAO.search(keyword, offset, limit);
    }

    /**
     * Phuong thuc countSearch
     */
    public int countSearch(String keyword) throws Exception {
        return warrantyDAO.countSearch(keyword);
    }

    /**
     * Phuong thuc filterByStatus
     */
    public List<WarrantyClaim> filterByStatus(String status, int offset, int limit) throws Exception {
        return warrantyDAO.filter(status, offset, limit);
    }

    // ── PURCHASED PRODUCTS (Step 1 product picker) ────────────────────────────

    /**
     * Lists all purchased units (one row per serial) for the customer, to
     * populate Step 1 ("Select Product") of the Submit Claim wizard. Replaces
     * manual serial number entry — the customer picks from their own
     * purchase history instead of typing a serial.
     */
    public List<model.WarrantyPurchasedProduct> getPurchasedProducts(int customerId) throws Exception {
        return warrantyDAO.findPurchasedProductsByCustomer(customerId);
    }

    // ── CHECK ELIGIBILITY (FIXED - moved inside class) ────────────────────────

    public model.WarrantyEligibilityInfo checkEligibility(String serialNumber, int customerId)
            throws ValidationException, Exception {

        // Kiểm tra điều kiện
        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }
        // Kiểm tra điều kiện
        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }
        // Kiểm tra điều kiện
        if (!warrantyDAO.isUnderWarranty(serialNumber)) {
            throw new ValidationException("Sản phẩm đã hết hạn bảo hành.");
        }
        // BR18 / UC27 E2: chỉ 1 active claim (PENDING/PROCESSING/APPROVED)
        // cho mỗi serial. Step 1 của wizard phải chặn ở đây, không để khách
        // điền hết Step 3 rồi mới bị từ chối ở submit.
        // Kiểm tra điều kiện
        if (warrantyDAO.hasActiveClaim(serialNumber)) {
            throw new ValidationException("Đã tồn tại một yêu cầu bảo hành đang xử lý cho sản phẩm này.");
        }

        return warrantyDAO.getEligibilityInfo(serialNumber);
    }

    // ── PRIVATE HELPERS ───────────────────────────────────────────────────────

    private WarrantyClaim getClaim(int claimId) throws ValidationException, Exception {
        WarrantyClaim claim = warrantyDAO.findById(claimId);
        // Kiểm tra điều kiện
        if (claim == null) {
            throw new ValidationException("Không tìm thấy yêu cầu bảo hành #" + claimId);
        }
        return claim;
    }

    private void assertOwner(WarrantyClaim claim, int customerId) throws ValidationException {
        // Kiểm tra điều kiện
        if (claim.getCustomerId() != customerId) {
            throw new ValidationException("Bạn không có quyền thao tác trên yêu cầu này.");
        }
    }

    /**
     * Kiểm tra staff đang thực hiện action có phải là staff được gán cho claim không.
     * Admin (roleId = 1) được phép bypass — nhưng phải Take Over trước (xem takeOverClaim).
     * Phương thức này chỉ kiểm tra ownership thuần túy, không phân biệt role.
     */
    private void assertStaffOwner(WarrantyClaim claim, int staffId) throws ValidationException {
        // BR-22: Only authorized Staff members are allowed to process warranty requests and update their processing status.
        if (claim.getStaffId() == null || claim.getStaffId() != staffId) {
            throw new ValidationException(
                    "Bạn không phải nhân viên đang xử lý yêu cầu bảo hành này. "
                    + "Admin vui lòng dùng 'Take Over' trước khi xử lý.");
        }
    }

    // ── TAKE OVER / REASSIGN (Admin only) ────────────────────────────────

    /**
     * Admin tự tiếp nhận claim (Take Over) hoặc gán lại cho staff khác (Reassign).
     * Chỉ áp dụng khi claim đang ở PROCESSING hoặc APPROVED.
     *
     * @param claimId     ID claim cần chuyển
     * @param newStaffId  ID nhân viên mới được gán (có thể là Admin tự gán cho mình)
     * @param note        Ghi chú lý do chuyển giao
     * @throws ValidationException nếu claim không ở trạng thái hợp lệ
     */
    public void takeOverClaim(int claimId, int newStaffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);

        // Chỉ cho phép Take Over khi đang PROCESSING hoặc APPROVED
        if (!"PROCESSING".equals(claim.getStatus()) && !"APPROVED".equals(claim.getStatus())) {
            throw new ValidationException(
                    "Chỉ có thể chuyển giao yêu cầu khi đang ở trạng thái PROCESSING hoặc APPROVED. "
                    + "Trạng thái hiện tại: " + claim.getStatus());
        }

        warrantyDAO.reassignStaff(claimId, newStaffId);

        String historyNote = (note != null && !note.trim().isEmpty())
                ? note.trim()
                : "Admin đã chuyển giao yêu cầu bảo hành cho nhân viên khác.";

        insertHistory(claimId, claim.getDescription(), claim.getStatus(), historyNote);
    }

    /**
     * Lấy danh sách toàn bộ nhân viên (role_id = 2) đang active,
     * dùng cho dropdown Reassign trong giao diện Admin.
     */
    public List<model.Users> getStaffList() throws Exception {
        return warrantyDAO.findStaffList();
    }

    private void assertTransition(String currentStatus,
                                  String expectedCurrent,
                                  String targetStatus)
            throws ValidationException {

        // BR-20: Warranty request status transitions shall strictly follow the workflow: PENDING -> PROCESSING -> APPROVED -> COMPLETED, or PENDING -> PROCESSING -> REJECTED.
        if (!expectedCurrent.equals(currentStatus)) {
            throw new ValidationException(
                    "Không thể chuyển sang " + targetStatus +
                    ": trạng thái hiện tại là " + currentStatus);
        }
    }

    private void insertHistory(int claimId, String issueDesc,
                               String repairStatus, String note) throws Exception {

        // BR-17: Every warranty request creation, cancellation, and status transition shall be recorded in the Warranty History log together with the actor identity, action performed, and timestamp.
        WarrantyHistory h = new WarrantyHistory();
        h.setWarrantyId(claimId);
        h.setIssueDescription(issueDesc);
        h.setRepairStatus(repairStatus);
        h.setRepairNote(note);
        historyDAO.insert(h);
    }
}
package service;

import dal.WarrantyDAO;
import dal.WarrantyHistoryDAO;
import dal.WarrantyClaimImageDAO;
import model.WarrantyClaim;
import model.WarrantyHistory;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileOutputStream;
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

    public WarrantyService() {
        this.warrantyDAO = new WarrantyDAO();
        this.historyDAO  = new WarrantyHistoryDAO();
        this.imageDAO    = new WarrantyClaimImageDAO();
    }

    // ── SUBMIT ────────────────────────────────────────────────────────────────

    public int submitWarranty(int customerId, String serialNumber,
            String title, String description, List<Part> images)
            throws ValidationException, Exception {

        if (serialNumber == null || serialNumber.trim().isEmpty()) {
            throw new ValidationException("Số serial không được để trống.");
        }
        if (title == null || title.trim().isEmpty()) {
            throw new ValidationException("Tiêu đề không được để trống.");
        }
        if (description == null || description.trim().isEmpty()) {
            throw new ValidationException("Mô tả lỗi không được để trống.");
        }

        // Max-length guards — khớp với maxlength attribute trong warranty_center.jsp
        // và giới hạn VARCHAR trong DB để tránh SQL exception thô
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

        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }

        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }

        if (!warrantyDAO.isUnderWarranty(serialNumber)) {
            throw new ValidationException("Sản phẩm đã hết hạn bảo hành. Không thể tạo yêu cầu.");
        }

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
        claim.setStatus("PENDING");

        int claimId = warrantyDAO.insertClaim(claim);

        insertHistory(claimId, description.trim(), "PENDING",
                "Yêu cầu bảo hành đã được gửi và đang chờ xử lý.");

        // Lưu ảnh SAU khi claim đã có claimId. Nếu việc ghi file/DB ảnh lỗi,
        // không rollback claim (claim vẫn hợp lệ, chỉ là thiếu ảnh) — nhưng
        // ta vẫn throw để staff/customer biết và có thể upload lại qua trang detail.
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
        if (images == null) {
            return result;
        }
        for (Part p : images) {
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
        if (images.size() > MAX_IMAGES) {
            throw new ValidationException(
                    "Chỉ được tải lên tối đa " + MAX_IMAGES + " ảnh.");
        }

        for (Part p : images) {
            if (p.getSize() > MAX_IMAGE_SIZE) {
                throw new ValidationException(
                        "Ảnh \"" + p.getSubmittedFileName() + "\" vượt quá 5MB. "
                        + "Vui lòng chọn ảnh nhỏ hơn.");
            }

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
            if (dot >= 0) {
                ext = originalName.substring(dot).toLowerCase();
            }
            // Whitelist phần mở rộng để tránh lưu file thực thi dưới tên giả mạo
            if (!ext.matches("\\.(jpg|jpeg|png|webp)")) {
                ext = ".jpg";
            }

            String storedFileName = UUID.randomUUID().toString() + ext;
            Path targetFile = uploadPath.resolve(storedFileName);

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

        if (!"PENDING".equals(claim.getStatus())) {
            throw new ValidationException(
                    "Chỉ có thể huỷ yêu cầu bảo hành khi trạng thái là PENDING.");
        }

        warrantyDAO.updateStatus(claimId, "CANCELLED");

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

        // Atomic update: gán staff + đổi status trong 1 SQL, đồng thời dùng
        // optimistic lock (WHERE status = 'PENDING') để tránh race condition
        // khi 2 staff cùng nhận claim.
        int rows = warrantyDAO.assignStaffAndProcess(claimId, staffId);
        if (rows == 0) {
            throw new ValidationException(
                "Yêu cầu đã được xử lý bởi người khác. Vui lòng tải lại trang.");
        }

        insertHistory(claimId, claim.getDescription(), "PROCESSING",
                (note != null && !note.trim().isEmpty()) ? note : "Đã tiếp nhận và bắt đầu xử lý.");
    }

    // ── APPROVE ───────────────────────────────────────────────────────────────

    private void approveWarranty(int claimId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "APPROVED");

        warrantyDAO.updateStatus(claimId, "APPROVED");

        insertHistory(claimId, claim.getDescription(), "APPROVED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu đã được duyệt.");
    }

    // ── REJECT ────────────────────────────────────────────────────────────────

    private void rejectWarranty(int claimId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "REJECTED");

        warrantyDAO.updateStatus(claimId, "REJECTED");

        insertHistory(claimId, claim.getDescription(), "REJECTED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu bị từ chối.");
    }

    // ── COMPLETE ──────────────────────────────────────────────────────────────

    private void completeWarranty(int claimId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "APPROVED", "COMPLETED");

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
                approveWarranty(claimId, note);
                break;
            case "REJECTED":
                rejectWarranty(claimId, note);
                break;
            case "COMPLETED":
                completeWarranty(claimId, note);
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

    public WarrantyClaim getClaimDetail(int claimId) throws ValidationException, Exception {
        return getClaim(claimId);
    }

    public List<WarrantyHistory> getHistory(int claimId) throws Exception {
        return historyDAO.findByWarrantyId(claimId);
    }

    public List<WarrantyClaim> getAllClaims(int offset, int limit) throws Exception {
        return warrantyDAO.findAll(offset, limit);
    }

    public int countClaims(String status) throws Exception {
        return warrantyDAO.count(status);
    }

    public List<WarrantyClaim> searchClaims(String keyword, int offset, int limit) throws Exception {
        return warrantyDAO.search(keyword, offset, limit);
    }

    public int countSearch(String keyword) throws Exception {
        return warrantyDAO.countSearch(keyword);
    }

    public List<WarrantyClaim> filterByStatus(String status, int offset, int limit) throws Exception {
        return warrantyDAO.filter(status, offset, limit);
    }

    // ── CHECK ELIGIBILITY (FIXED - moved inside class) ────────────────────────

    public void checkEligibility(String serialNumber, int customerId)
            throws ValidationException, Exception {

        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }
        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }
        if (!warrantyDAO.isUnderWarranty(serialNumber)) {
            throw new ValidationException("Sản phẩm đã hết hạn bảo hành.");
        }
    }

    // ── PRIVATE HELPERS ───────────────────────────────────────────────────────

    private WarrantyClaim getClaim(int claimId) throws ValidationException, Exception {
        WarrantyClaim claim = warrantyDAO.findById(claimId);
        if (claim == null) {
            throw new ValidationException("Không tìm thấy yêu cầu bảo hành #" + claimId);
        }
        return claim;
    }

    private void assertOwner(WarrantyClaim claim, int customerId) throws ValidationException {
        if (claim.getCustomerId() != customerId) {
            throw new ValidationException("Bạn không có quyền thao tác trên yêu cầu này.");
        }
    }

    private void assertTransition(String currentStatus,
                                  String expectedCurrent,
                                  String targetStatus)
            throws ValidationException {

        if (!expectedCurrent.equals(currentStatus)) {
            throw new ValidationException(
                    "Không thể chuyển sang " + targetStatus +
                    ": trạng thái hiện tại là " + currentStatus);
        }
    }

    private void insertHistory(int claimId, String issueDesc,
                               String repairStatus, String note) throws Exception {

        WarrantyHistory h = new WarrantyHistory();
        h.setWarrantyId(claimId);
        h.setIssueDescription(issueDesc);
        h.setRepairStatus(repairStatus);
        h.setRepairNote(note);
        historyDAO.insert(h);
    }
}
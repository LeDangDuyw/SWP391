package service;

import dal.WarrantyDAO;
import dal.WarrantyHistoryDAO;
import model.WarrantyClaim;
import model.WarrantyHistory;
import java.util.List;
import utils.ValidationException;

public class WarrantyService {

    private final WarrantyDAO warrantyDAO;
    private final WarrantyHistoryDAO historyDAO;

    public WarrantyService() {
        this.warrantyDAO = new WarrantyDAO();
        this.historyDAO  = new WarrantyHistoryDAO();
    }

    // ── SUBMIT ────────────────────────────────────────────────────────────────

    public int submitWarranty(int customerId, String serialNumber,
            String title, String description)
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

        return claimId;
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
package service;

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

/**
 * Class: WarrantyService
 * Description: Lớp xử lý các quy tắc nghiệp vụ bảo hành (Warranty Service).
 * Bao gồm kiểm tra điều kiện bảo hành, gửi phiếu bảo hành mới, tải lên ảnh minh chứng, chuyển đổi trạng thái và ghi log lịch sử.
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-23
 * Version: v2.4
 *
 * @author DuyLD
 */
public class WarrantyService {

    private final WarrantyDAO warrantyDAO;
    private final WarrantyHistoryDAO historyDAO;
    private final WarrantyClaimImageDAO imageDAO;

    // Cấu hình tải ảnh minh chứng
    private static final int MAX_IMAGES = 5;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024; // 5MB / file
    private static final List<String> ALLOWED_CONTENT_TYPES =
            List.of("image/jpeg", "image/png", "image/jpg", "image/webp");

    // Thư mục lưu trữ ảnh tải lên trên ổ đĩa
    private static final String UPLOAD_DIR = System.getProperty("warranty.upload.dir",
            System.getProperty("user.home") + File.separator + "uploads" + File.separator + "warranty");


    /**
     * Khởi tạo WarrantyService cùng với các lớp truy xuất dữ liệu DAO tương ứng.
     */
    public WarrantyService() {
        this.warrantyDAO = new WarrantyDAO();
        this.historyDAO  = new WarrantyHistoryDAO();
        this.imageDAO    = new WarrantyClaimImageDAO();
    }

    /**
     * Xử lý gửi yêu cầu bảo hành mới từ khách hàng.
     * Validate dữ liệu đầu vào, kiểm tra quyền sở hữu sản phẩm, hạn bảo hành, lưu tệp ảnh và ghi lịch sử.
     *
     * @param customerId   Mã ID khách hàng gửi
     * @param serialNumber Số Serial/IMEI của sản phẩm bảo hành
     * @param title        Tiêu đề yêu cầu bảo hành
     * @param description  Mô tả chi tiết sự cố
     * @param images       Danh sách các file ảnh minh chứng đính kèm
     * @return claimId Mã phiếu bảo hành vừa tạo thành công
     */
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

        // BR-43: Quy định độ dài tối đa các trường văn bản
        if (serialNumber.trim().length() > 100) {
            throw new ValidationException("Số serial không được vượt quá 100 ký tự.");
        }
        if (title.trim().length() > 200) {
            throw new ValidationException("Tiêu đề không được vượt quá 200 ký tự.");
        }
        if (description.trim().length() > 2000) {
            throw new ValidationException("Mô tả lỗi không được vượt quá 2000 ký tự.");
        }

        // Kiểm tra tệp ảnh đính kèm trước khi tác động DB
        List<Part> validImageParts = filterImageParts(images);
        validateImages(validImageParts);

        serialNumber = serialNumber.trim();

        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }

        // BR-15: Sản phẩm phải thuộc về đơn hàng đã hoàn tất của chính khách hàng này
        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }

        // BR-15: Sản phẩm còn trong thời hạn bảo hành
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
        // BR-16: Trạng thái ban đầu mặc định là PENDING
        claim.setStatus("PENDING");

        int claimId = warrantyDAO.insertClaim(claim);

        // BR-17: Ghi nhật ký khởi tạo vào bảng lịch sử bảo hành
        insertHistory(claimId, description.trim(), "PENDING",
                "Yêu cầu bảo hành đã được gửi và đang chờ xử lý.");

        // Lưu các tệp ảnh minh chứng đính kèm
        if (!validImageParts.isEmpty()) {
            saveClaimImages(claimId, validImageParts);
        }

        return claimId;
    }

    /**
     * Lọc ra các Part tệp hợp lệ (bỏ qua các input rỗng).
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
     * Kiểm tra hợp lệ về số lượng, dung lượng và định dạng tệp ảnh minh chứng.
     */
    private void validateImages(List<Part> images) throws ValidationException {
        // BR-08: Phải có ít nhất 1 ảnh minh chứng
        if (images == null || images.isEmpty()) {
            throw new ValidationException("Yêu cầu bảo hành trực tuyến bắt buộc phải kèm theo ít nhất 1 ảnh bằng chứng.");
        }

        // BR-42: Tối đa 5 ảnh
        if (images.size() > MAX_IMAGES) {
            throw new ValidationException(
                    "Chỉ được tải lên tối đa " + MAX_IMAGES + " ảnh.");
        }

        for (Part p : images) {
            // BR-42: Tối đa 5MB mỗi file
            if (p.getSize() > MAX_IMAGE_SIZE) {
                throw new ValidationException(
                        "Ảnh \"" + p.getSubmittedFileName() + "\" vượt quá 5MB. "
                        + "Vui lòng chọn ảnh nhỏ hơn.");
            }

            // BR-42: Định dạng JPEG, PNG, JPG, WEBP
            String contentType = p.getContentType();
            if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
                throw new ValidationException(
                        "Ảnh \"" + p.getSubmittedFileName() + "\" không đúng định dạng. "
                        + "Chỉ chấp nhận JPG, PNG hoặc WEBP.");
            }
        }
    }

    /**
     * Ghi các tệp ảnh minh chứng vào đĩa cứng với tên định danh UUID ngẫu nhiên và lưu URL vào DB.
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
            if (!ext.matches("\\.(jpg|jpeg|png|webp)")) {
                ext = ".jpg";
            }

            String storedFileName = UUID.randomUUID().toString() + ext;
            Path targetFile = uploadPath.resolve(storedFileName);

            try (InputStream in = p.getInputStream()) {
                Files.copy(in, targetFile);
            }

            String relativeUrl = "/warranty-images/" + claimId + "/" + storedFileName;
            savedUrls.add(relativeUrl);
        }

        imageDAO.insertBatch(claimId, savedUrls);
    }

    /**
     * Lấy danh sách ảnh minh chứng đính kèm của một phiếu bảo hành.
     */
    public List<model.WarrantyClaimImage> getClaimImages(int claimId) throws Exception {
        return imageDAO.findByClaimId(claimId);
    }

    /**
     * Khách hàng chủ động hủy phiếu bảo hành khi đang ở trạng thái PENDING.
     */
    public void cancelWarranty(int claimId, int customerId)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertOwner(claim, customerId);

        // BR-05 & BR-19: Chỉ được hủy yêu cầu bảo hành khi ở trạng thái PENDING
        if (!"PENDING".equals(claim.getStatus())) {
            throw new ValidationException(
                    "Chỉ có thể huỷ yêu cầu bảo hành khi trạng thái là PENDING.");
        }

        warrantyDAO.updateStatus(claimId, "CANCELLED");

        // BR-17: Ghi lịch sử hủy phiếu bảo hành
        insertHistory(claimId, claim.getDescription(), "CANCELLED",
                "Khách hàng đã huỷ yêu cầu bảo hành.");
    }

    /**
     * Nhân viên/Admin hủy phiếu bảo hành ở trạng thái PENDING kèm lý do ghi chú.
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

    /**
     * Nhân viên tiếp nhận đơn bảo hành (PENDING -> PROCESSING).
     */
    private void processWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PENDING", "PROCESSING");

        // BR-23: Gán nhân viên xử lý nguyên tử (Atomic optimistic locking) tránh xung đột
        int rows = warrantyDAO.assignStaffAndProcess(claimId, staffId);
        if (rows == 0) {
            throw new ValidationException(
                "Yêu cầu đã được xử lý bởi người khác. Vui lòng tải lại trang.");
        }

        insertHistory(claimId, claim.getDescription(), "PROCESSING",
                (note != null && !note.trim().isEmpty()) ? note : "Đã tiếp nhận và bắt đầu xử lý.");
    }

    /**
     * Nhân viên duyệt chấp nhận phương án bảo hành (PROCESSING -> APPROVED).
     */
    private void approveWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "APPROVED");

        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "APPROVED");

        insertHistory(claimId, claim.getDescription(), "APPROVED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu đã được duyệt.");
    }

    /**
     * Nhân viên từ chối bảo hành (PROCESSING -> REJECTED).
     */
    private void rejectWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PROCESSING", "REJECTED");

        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "REJECTED");

        insertHistory(claimId, claim.getDescription(), "REJECTED",
                (note != null && !note.trim().isEmpty()) ? note : "Yêu cầu bị từ chối.");
    }

    /**
     * Hoàn thành quy trình sửa chữa/bảo hành (APPROVED -> COMPLETED).
     */
    private void completeWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "APPROVED", "COMPLETED");

        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "COMPLETED");

        insertHistory(claimId, claim.getDescription(), "COMPLETED",
                (note != null && !note.trim().isEmpty())
                        ? note
                        : "Bảo hành hoàn tất. Sản phẩm đã được trả lại cho khách hàng.");
    }

    /**
     * Bộ điều hướng cập nhật trạng thái phiếu bảo hành tương ứng theo hành động của Nhân viên.
     */
    public void validateClaim(int claimId, String newStatus, int staffId, String note)
            throws ValidationException, Exception {

        switch (newStatus) {
            case "PROCESSING":
                processWarranty(claimId, staffId, note);
                break;
            case "APPROVED":
                approveWarranty(claimId, staffId, note);
                break;
            case "REJECTED":
                rejectWarranty(claimId, staffId, note);
                break;
            case "COMPLETED":
                completeWarranty(claimId, staffId, note);
                break;
            case "CANCELLED":
                staffCancelClaim(claimId, staffId, note);
                break;
            default:
                throw new ValidationException("Trạng thái không hợp lệ: " + newStatus);
        }
    }

    /**
     * Lấy danh sách phiếu bảo hành của khách hàng.
     */
    public List<WarrantyClaim> getCustomerClaims(int customerId) throws Exception {
        return warrantyDAO.findByCustomer(customerId);
    }

    public List<WarrantyClaim> getCustomerClaims(int customerId, int offset, int limit) throws Exception {
        return warrantyDAO.findByCustomer(customerId, offset, limit);
    }

    public int countCustomerClaims(int customerId) throws Exception {
        return warrantyDAO.countByCustomer(customerId);
    }

    public List<WarrantyClaim> searchCustomerClaims(int customerId, String keyword, String statusFilter, int offset, int limit) throws Exception {
        return warrantyDAO.searchCustomerClaims(customerId, keyword, statusFilter, offset, limit);
    }

    public int countCustomerClaims(int customerId, String keyword, String statusFilter) throws Exception {
        return warrantyDAO.countCustomerClaims(customerId, keyword, statusFilter);
    }

    /**
     * Lấy thông tin chi tiết của phiếu bảo hành theo ID.
     */
    public WarrantyClaim getClaimDetail(int claimId) throws ValidationException, Exception {
        return getClaim(claimId);
    }

    /**
     * Lấy danh sách nhật ký lịch sử tiến độ bảo hành theo ID phiếu bảo hành.
     */
    public List<WarrantyHistory> getHistory(int claimId) throws Exception {
        return historyDAO.findByWarrantyId(claimId);
    }

    /**
     * Lấy toàn bộ phiếu bảo hành phân trang cho Nhân viên/Admin.
     */
    public List<WarrantyClaim> getAllClaims(int offset, int limit) throws Exception {
        return warrantyDAO.findAll(offset, limit);
    }

    /**
     * Đếm tổng số phiếu bảo hành (có thể lọc theo trạng thái).
     */
    public int countClaims(String status) throws Exception {
        return warrantyDAO.count(status);
    }

    /**
     * Tìm kiếm phiếu bảo hành theo từ khóa.
     */
    public List<WarrantyClaim> searchClaims(String keyword, int offset, int limit) throws Exception {
        return warrantyDAO.search(keyword, offset, limit);
    }

    /**
     * Đếm số lượng phiếu bảo hành khớp từ khóa tìm kiếm.
     */
    public int countSearch(String keyword) throws Exception {
        return warrantyDAO.countSearch(keyword);
    }

    /**
     * Lọc phiếu bảo hành theo trạng thái.
     */
    public List<WarrantyClaim> filterByStatus(String status, int offset, int limit) throws Exception {
        return warrantyDAO.filter(status, offset, limit);
    }

    /**
     * Lấy danh sách các sản phẩm đã mua thành công của khách hàng để chọn sản phẩm gửi bảo hành.
     */
    public List<model.WarrantyPurchasedProduct> getPurchasedProducts(int customerId) throws Exception {
        return warrantyDAO.findPurchasedProductsByCustomer(customerId);
    }

    /**
     * Kiểm tra tính đủ điều kiện gửi bảo hành cho một số Serial/IMEI.
     */
    public model.WarrantyEligibilityInfo checkEligibility(String serialNumber, int customerId)
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
        if (warrantyDAO.hasActiveClaim(serialNumber)) {
            throw new ValidationException("Đã tồn tại một yêu cầu bảo hành đang xử lý cho sản phẩm này.");
        }

        return warrantyDAO.getEligibilityInfo(serialNumber);
    }

    /**
     * Lấy đối tượng WarrantyClaim theo ID và ném ngoại lệ nếu không tìm thấy.
     */
    private WarrantyClaim getClaim(int claimId) throws ValidationException, Exception {
        WarrantyClaim claim = warrantyDAO.findById(claimId);
        if (claim == null) {
            throw new ValidationException("Không tìm thấy yêu cầu bảo hành #" + claimId);
        }
        return claim;
    }

    /**
     * Kiểm tra xem tài khoản có phải là chủ sở hữu của đơn bảo hành hay không.
     */
    private void assertOwner(WarrantyClaim claim, int customerId) throws ValidationException {
        if (claim.getCustomerId() != customerId) {
            throw new ValidationException("Bạn không có quyền thao tác trên yêu cầu này.");
        }
    }

    /**
     * Kiểm tra nhân viên đang thao tác có phải nhân viên được gán xử lý phiếu bảo hành này hay không.
     */
    private void assertStaffOwner(WarrantyClaim claim, int staffId) throws ValidationException {
        if (claim.getStaffId() == null || claim.getStaffId() != staffId) {
            throw new ValidationException(
                    "Bạn không phải nhân viên đang xử lý yêu cầu bảo hành này. "
                    + "Admin vui lòng dùng 'Take Over' trước khi xử lý.");
        }
    }

    /**
     * Chuyển giao đơn bảo hành cho nhân viên khác hoặc Admin tự tiếp nhận (Take Over).
     */
    public void takeOverClaim(int claimId, int newStaffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);

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
     * Lấy danh sách nhân viên active để Admin thực hiện chọn chuyển giao đơn bảo hành.
     */
    public List<model.Users> getStaffList() throws Exception {
        return warrantyDAO.findStaffList();
    }

    /**
     * Kiểm tra quy tắc chuyển đổi trạng thái hợp lệ (Workflow: PENDING -> PROCESSING -> APPROVED -> COMPLETED hoặc REJECTED).
     */
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

    /**
     * Thêm một bản ghi nhật ký mới vào bảng lịch sử bảo hành.
     */
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
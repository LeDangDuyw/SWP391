package service;

/**
 * Class: WarrantyService
 * Description: Lớp xử lý nghiệp vụ bảo hành (Warranty Business Logic Layer).
 *              Đảm nhận kiểm tra quy tắc nghiệp vụ (BR-05, BR-08, BR-15, BR-16, BR-17, BR-19, BR-20, BR-22, BR-23, BR-42, BR-43),
 *              validate danh sách ảnh upload, lưu trữ ảnh xuống ổ đĩa, ghi log nhật ký lịch sử chuyển trạng thái
 *              và quản lý phân công/chuyển giao nhiệm vụ xử lý cho Nhân viên/Admin.
 * 
 * Created: 2026-06-22
 * Updated: 2026-07-22
 * Version: v2.4
 *
 * @author DuyLD
 */

import dal.WarrantyClaimImageDAO;
import dal.WarrantyDAO;
import dal.WarrantyHistoryDAO;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.Users;
import model.WarrantyClaim;
import model.WarrantyClaimImage;
import model.WarrantyEligibilityInfo;
import model.WarrantyHistory;
import model.WarrantyPurchasedProduct;
import utils.ValidationException;

public class WarrantyService {

    private final WarrantyDAO warrantyDAO;
    private final WarrantyHistoryDAO historyDAO;
    private final WarrantyClaimImageDAO imageDAO;

    // Cấu hình giới hạn upload ảnh (BR-42)
    private static final int MAX_IMAGES = 5;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024; // 5MB per image
    private static final List<String> ALLOWED_CONTENT_TYPES =
            List.of("image/jpeg", "image/png", "image/jpg", "image/webp");

    // Thư mục lưu đĩa ảnh upload vật lý
    private static final String UPLOAD_DIR = System.getProperty("warranty.upload.dir",
            System.getProperty("user.home") + File.separator + "uploads" + File.separator + "warranty");

    /**
     * Khởi tạo WarrantyService và các DAO phụ trợ.
     */
    public WarrantyService() {
        this.warrantyDAO = new WarrantyDAO();
        this.historyDAO  = new WarrantyHistoryDAO();
        this.imageDAO    = new WarrantyClaimImageDAO();
    }

    /**
     * Nộp yêu cầu bảo hành mới từ Khách hàng.
     * Validate độ dài trường thông tin (BR-43), kiểm tra chính chủ & hạn bảo hành (BR-15),
     * kiểm tra không trùng lặp active claim (BR-18), validate ảnh (BR-42, BR-08),
     * khởi tạo trạng thái PENDING (BR-16), ghi log lịch sử (BR-17) và lưu trữ tập tin ảnh.
     *
     * @param customerId   ID khách hàng nộp đơn
     * @param serialNumber số serial sản phẩm
     * @param title        tiêu đề yêu cầu
     * @param description  mô tả chi tiết lỗi
     * @param images       danh sách Part ảnh upload từ HTTP form
     * @return claim_id vừa tạo thành công
     * @throws ValidationException nếu vi phạm quy tắc nghiệp vụ
     * @throws Exception           nếu xảy ra lỗi hệ thống/CSDL
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

        // BR-43: Giới hạn độ dài trường thông tin
        if (serialNumber.trim().length() > 100) {
            throw new ValidationException("Số serial không được vượt quá 100 ký tự.");
        }
        if (title.trim().length() > 200) {
            throw new ValidationException("Tiêu đề không được vượt quá 200 ký tự.");
        }
        if (description.trim().length() > 2000) {
            throw new ValidationException("Mô tả lỗi không được vượt quá 2000 ký tự.");
        }

        // Validate danh sách ảnh trước khi ghi vào CSDL (Fail-fast pattern)
        List<Part> validImageParts = filterImageParts(images);
        validateImages(validImageParts);

        serialNumber = serialNumber.trim();

        if (!warrantyDAO.serialExists(serialNumber)) {
            throw new ValidationException("Số serial không tồn tại trong hệ thống.");
        }

        // BR-15: Sản phẩm phải thuộc đơn hàng hoàn thành của chính khách hàng
        if (!warrantyDAO.productBelongsToCustomer(serialNumber, customerId)) {
            throw new ValidationException("Sản phẩm này không thuộc đơn hàng đã hoàn thành của bạn.");
        }

        // BR-15: Sản phẩm phải còn trong thời hạn bảo hành
        if (!warrantyDAO.isUnderWarranty(serialNumber)) {
            throw new ValidationException("Sản phẩm đã hết hạn bảo hành. Không thể tạo yêu cầu.");
        }

        // BR-18: Chỉ 1 yêu cầu bảo hành đang xử lý cho mỗi số serial
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
        // BR-16: Trạng thái khởi tạo ban đầu là PENDING
        claim.setStatus("PENDING");

        int claimId = warrantyDAO.insertClaim(claim);

        // BR-17: Ghi log nhật ký tạo mới
        insertHistory(claimId, description.trim(), "PENDING",
                "Yêu cầu bảo hành đã được gửi và đang chờ xử lý.");

        // Lưu trữ tập tin ảnh minh chứng lên ổ đĩa & lưu URL vào CSDL
        if (!validImageParts.isEmpty()) {
            saveClaimImages(claimId, validImageParts);
        }

        return claimId;
    }

    /**
     * Lọc danh sách Part thực sự là tập tin ảnh hợp lệ.
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
     * BR-42 & BR-08: Validate bắt buộc có ảnh minh chứng, tối đa 5 ảnh, dung lượng <= 5MB/ảnh và định dạng JPG, PNG, WEBP.
     */
    private void validateImages(List<Part> images) throws ValidationException {
        // BR-08: Bắt buộc đính kèm ảnh minh chứng
        if (images == null || images.isEmpty()) {
            throw new ValidationException("Yêu cầu bảo hành trực tuyến bắt buộc phải kèm theo ít nhất 1 ảnh bằng chứng.");
        }

        // BR-42: Tối đa 5 ảnh
        if (images.size() > MAX_IMAGES) {
            throw new ValidationException("Chỉ được tải lên tối đa " + MAX_IMAGES + " ảnh.");
        }

        for (Part p : images) {
            // BR-42: Tối đa 5MB mỗi ảnh
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
     * Lưu ảnh xuống đĩa cứng sử dụng tên ngẫu nhiên UUID và chèn thông tin URL vào CSDL.
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
     * Lấy danh sách ảnh minh chứng đính kèm phiếu bảo hành.
     *
     * @param claimId ID phiếu bảo hành
     * @return danh sách WarrantyClaimImage
     * @throws Exception nếu xảy ra lỗi CSDL
     */
    public List<WarrantyClaimImage> getClaimImages(int claimId) throws Exception {
        return imageDAO.findByClaimId(claimId);
    }

    /**
     * Khách hàng tự hủy yêu cầu bảo hành của mình (BR-05 & BR-19: Chỉ cho phép hủy khi ở trạng thái PENDING).
     *
     * @param claimId    ID phiếu bảo hành
     * @param customerId ID khách hàng thực hiện hủy
     * @throws ValidationException nếu trạng thái khác PENDING hoặc không đúng chủ sở hữu
     * @throws Exception           nếu xảy ra lỗi CSDL
     */
    public void cancelWarranty(int claimId, int customerId)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertOwner(claim, customerId);

        if (!"PENDING".equals(claim.getStatus())) {
            throw new ValidationException("Chỉ có thể huỷ yêu cầu bảo hành khi trạng thái là PENDING.");
        }

        warrantyDAO.updateStatus(claimId, "CANCELLED");
        insertHistory(claimId, claim.getDescription(), "CANCELLED", "Khách hàng đã huỷ yêu cầu bảo hành.");
    }

    /**
     * Nhân viên / Admin hủy yêu cầu bảo hành ở trạng thái PENDING (kèm ghi chú lý do).
     *
     * @param claimId ID phiếu bảo hành
     * @param staffId ID nhân viên thao tác
     * @param note    lý do hủy
     * @throws ValidationException nếu trạng thái không phải PENDING
     * @throws Exception           nếu xảy ra lỗi CSDL
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
        String historyNote = (note != null && !note.trim().isEmpty()) ? note.trim() : "Staff đã huỷ yêu cầu bảo hành.";
        insertHistory(claimId, claim.getDescription(), "CANCELLED", historyNote);
    }

    /**
     * Tiếp nhận và bắt đầu xử lý phiếu bảo hành (chuyển PENDING -> PROCESSING - BR-23).
     */
    private void processWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "PENDING", "PROCESSING");

        // BR-23: Phân công nhân viên nguyên tử tránh 2 staff cùng nhận
        int rows = warrantyDAO.assignStaffAndProcess(claimId, staffId);
        if (rows == 0) {
            throw new ValidationException("Yêu cầu đã được xử lý bởi người khác. Vui lòng tải lại trang.");
        }

        insertHistory(claimId, claim.getDescription(), "PROCESSING",
                (note != null && !note.trim().isEmpty()) ? note : "Đã tiếp nhận và bắt đầu xử lý.");
    }

    /**
     * Phê duyệt yêu cầu bảo hành (chuyển PROCESSING -> APPROVED).
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
     * Từ chối yêu cầu bảo hành (chuyển PROCESSING -> REJECTED).
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
     * Hoàn tất quá trình sửa chữa/bảo hành (chuyển APPROVED -> COMPLETED).
     */
    private void completeWarranty(int claimId, int staffId, String note)
            throws ValidationException, Exception {

        WarrantyClaim claim = getClaim(claimId);
        assertTransition(claim.getStatus(), "APPROVED", "COMPLETED");
        assertStaffOwner(claim, staffId);

        warrantyDAO.updateStatus(claimId, "COMPLETED");
        insertHistory(claimId, claim.getDescription(), "COMPLETED",
                (note != null && !note.trim().isEmpty()) ? note : "Bảo hành hoàn tất. Sản phẩm đã được trả lại cho khách hàng.");
    }

    /**
     * Điều hướng tác vụ cập nhật trạng thái phiếu bảo hành theo đúng workflow (BR-20).
     *
     * @param claimId   ID phiếu bảo hành
     * @param newStatus trạng thái đích
     * @param staffId   ID nhân viên thao tác
     * @param note      ghi chú nội dung xử lý
     * @throws ValidationException nếu chuyển trạng thái không hợp lệ
     * @throws Exception           nếu xảy ra lỗi CSDL
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

    /**
     * Lấy thông tin chi tiết phiếu bảo hành.
     */
    public WarrantyClaim getClaimDetail(int claimId) throws ValidationException, Exception {
        return getClaim(claimId);
    }

    /**
     * Lấy nhật ký lịch sử timeline xử lý bảo hành (BR-17).
     */
    public List<WarrantyHistory> getHistory(int claimId) throws Exception {
        return historyDAO.findByWarrantyId(claimId);
    }

    /**
     * Lấy toàn bộ phiếu bảo hành có phân trang.
     */
    public List<WarrantyClaim> getAllClaims(int offset, int limit) throws Exception {
        return warrantyDAO.findAll(offset, limit);
    }

    /**
     * Đếm tổng số lượng phiếu bảo hành theo trạng thái.
     */
    public int countClaims(String status) throws Exception {
        return warrantyDAO.count(status);
    }

    /**
     * Tìm kiếm phiếu bảo hành theo từ khóa có phân trang.
     */
    public List<WarrantyClaim> searchClaims(String keyword, int offset, int limit) throws Exception {
        return warrantyDAO.search(keyword, offset, limit);
    }

    /**
     * Đếm số kết quả tìm kiếm phiếu bảo hành.
     */
    public int countSearch(String keyword) throws Exception {
        return warrantyDAO.countSearch(keyword);
    }

    /**
     * Lọc danh sách phiếu bảo hành theo trạng thái có phân trang.
     */
    public List<WarrantyClaim> filterByStatus(String status, int offset, int limit) throws Exception {
        return warrantyDAO.filter(status, offset, limit);
    }

    /**
     * Lấy danh sách sản phẩm đã mua của khách hàng (phục vụ chọn sản phẩm tại Bước 1 của Wizard).
     */
    public List<WarrantyPurchasedProduct> getPurchasedProducts(int customerId) throws Exception {
        return warrantyDAO.findPurchasedProductsByCustomer(customerId);
    }

    /**
     * Kiểm tra tính hợp lệ bảo hành của sản phẩm trước khi cho phép mở wizard điền thông tin lỗi.
     */
    public WarrantyEligibilityInfo checkEligibility(String serialNumber, int customerId)
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

    /**
     * BR-22: Kiểm tra nhân viên thao tác có đúng là người được phân công phụ trách phiếu bảo hành hay không.
     */
    private void assertStaffOwner(WarrantyClaim claim, int staffId) throws ValidationException {
        if (claim.getStaffId() == null || claim.getStaffId() != staffId) {
            throw new ValidationException(
                    "Bạn không phải nhân viên đang xử lý yêu cầu bảo hành này. "
                    + "Admin vui lòng dùng 'Take Over' trước khi xử lý.");
        }
    }

    /**
     * Admin thực hiện tự tiếp nhận (Take Over) hoặc chuyển giao phiếu bảo hành cho nhân viên khác.
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
        String historyNote = (note != null && !note.trim().isEmpty()) ? note.trim() : "Admin đã chuyển giao yêu cầu bảo hành cho nhân viên khác.";
        insertHistory(claimId, claim.getDescription(), claim.getStatus(), historyNote);
    }

    /**
     * Lấy danh sách nhân viên active để hiển thị trên dropdown chuyển giao (Reassign).
     */
    public List<Users> getStaffList() throws Exception {
        return warrantyDAO.findStaffList();
    }

    /**
     * BR-20: Kiểm tra chuyển đổi trạng thái có tuân thủ đúng workflow chuẩn hay không:
     * PENDING -> PROCESSING -> APPROVED -> COMPLETED hoặc PENDING -> PROCESSING -> REJECTED.
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
     * Ghi nhận một mốc nhật ký lịch sử chuyển trạng thái (BR-17).
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
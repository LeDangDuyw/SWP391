/*
 * Name: AddProductSerialController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc đăng ký số Serial Number / IMEI cho sản phẩm khi nhập kho.
 */
package controller;

import dal.SerialDAO;
import dal.ProductDAO;
import dal.TicketDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryItem;
import model.Product;
import model.ProductVariant;
import model.TicketDetail;

@WebServlet(name = "AddProductSerialController", urlPatterns = { "/staff/imei/add", "/staff/serial/add" })
public class AddProductSerialController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Hiển thị giao diện đăng ký mã Serial/IMEI.
     * Nếu có truyền vào ticketId và variantId từ phiếu nhập kho (Inbound), hệ thống sẽ
     * tự động lấy thông tin số lượng yêu cầu (expectedQuantity) và sản phẩm tương ứng để điền sẵn vào form.
     * 
     * @param request  đối tượng HttpServletRequest chứa thông tin request
     * @param response đối tượng HttpServletResponse để gửi phản hồi
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdStr = request.getParameter("ticketId");
        String variantIdStr = request.getParameter("variantId");

        ProductDAO productDao = new ProductDAO();
        TicketDAO ticketDao = new TicketDAO();

        if (ticketIdStr != null && !ticketIdStr.trim().isEmpty() &&
                variantIdStr != null && !variantIdStr.trim().isEmpty()) {

            try {
                int ticketId = Integer.parseInt(ticketIdStr.trim());
                int variantId = Integer.parseInt(variantIdStr.trim());

                List<model.TicketDetail> details = ticketDao.getTicketDetails(ticketId);
                int expectedQuantity = -1;
                for (model.TicketDetail td : details) {
                    if (td.getVariantId() == variantId) {
                        expectedQuantity = td.getQuantity();
                        break;
                    }
                }

                model.ProductVariant selectedVariant = productDao.getVariantById(variantId);
                model.Product selectedProduct = null;
                if (selectedVariant != null) {
                    selectedProduct = productDao.getProductByVariantId(variantId);
                }

                model.Ticket ticket = ticketDao.getTicketById(ticketId);

                request.setAttribute("ticketId", ticketId);
                request.setAttribute("expectedQuantity", expectedQuantity);
                request.setAttribute("selectedVariant", selectedVariant);
                request.setAttribute("selectedProduct", selectedProduct);
                request.setAttribute("ticket", ticket);

            } catch (NumberFormatException e) {
                // Ignore parse errors, fall back to normal
            }
        }

        List<Product> products = productDao.GetAllProducts();
        List<ProductVariant> variants = productDao.getAllVariants();

        request.setAttribute("products", products);
        request.setAttribute("variants", variants);

        request.getRequestDispatcher("/staff/AddProductSerial.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu HTTP POST: Nhận danh sách mã Serial/IMEI do nhân viên nhập và lưu vào cơ sở dữ liệu.
     * Các bước xử lý:
     * 1. Validate dữ liệu đầu vào (mã biến thể, danh sách serial, ngày nhập).
     * 2. Kiểm tra ngày nhập không được vượt quá ngày hiện tại (không ở tương lai).
     * 3. Lọc bỏ các serial trống và khởi tạo danh sách InventoryItem trạng thái "in_stock".
     * 4. Gọi SerialDAO để lưu hàng loạt serial mới vào kho và cập nhật số lượng khả dụng (available_quantity).
     * 5. (Nghiệp vụ Inbound) Nếu nhập qua phiếu nhập kho, gọi kiểm tra tự động xem toàn bộ các sản phẩm
     *    trong phiếu đã nhập đủ chưa để cập nhật trạng thái phiếu thành COMPLETED.
     * 
     * @param request  đối tượng HttpServletRequest chứa form data
     * @param response đối tượng HttpServletResponse để điều hướng sau khi xử lý
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ĐOẠN 1: Đọc thông tin từ Form Đăng ký Serial [web/staff/AddProductSerial.jsp]
        // Nhiệm vụ: Nhận variantId, mảng mã serialNumbers, ngày nhập receivedDate và ticketId (nếu có)
        String variantIdStr = request.getParameter("variantId");
        String[] serialNumbers = request.getParameterValues("serialNumbers");
        String receivedDate = request.getParameter("receivedDate");
        String ticketIdStr = request.getParameter("ticketId");

        if (variantIdStr == null || variantIdStr.trim().isEmpty() ||
                serialNumbers == null) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" +
                    (ticketIdStr != null ? "&ticketId=" + ticketIdStr : "") +
                    (variantIdStr != null ? "&variantId=" + variantIdStr : ""));
            return;
        }

        int variantId = Integer.parseInt(variantIdStr.trim());
        Integer ticketId = null;
        if (ticketIdStr != null && !ticketIdStr.trim().isEmpty()) {
            try {
                ticketId = Integer.parseInt(ticketIdStr.trim());
            } catch (NumberFormatException e) {
                // Bỏ qua nếu không đúng định dạng số
            }
        }

        // ĐOẠN 2: Lọc danh sách Serial hợp lệ & Validate độ dài (>= 5 ký tự)
        List<String> validSerials = new ArrayList<>();

        for (int i = 0; i < serialNumbers.length; i++) {
            String sn = (serialNumbers[i] != null) ? serialNumbers[i].trim() : "";

            if (sn.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" +
                        (ticketIdStr != null ? "&ticketId=" + ticketIdStr : "") +
                        (variantIdStr != null ? "&variantId=" + variantIdStr : ""));
                return;
            }

            if (!sn.matches("^[^@#\\$%\\^&\\*\\(\\)\\+=\\{\\}\\[\\]\\|\\\\:;\"'<>,?/]{5,30}$")) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=InvalidSerialFormat" +
                        (ticketIdStr != null ? "&ticketId=" + ticketIdStr : "") +
                        (variantIdStr != null ? "&variantId=" + variantIdStr : ""));
                return;
            }

            validSerials.add(sn);
        }

        if (validSerials.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" +
                    (ticketId != null ? "&ticketId=" + ticketId : "") +
                    "&variantId=" + variantId);
            return;
        }

        // ĐOẠN 3: Đọc expectedQuantity từ TicketDetails [dal/TicketDAO.java: getTicketDetails()]
        // Nhiệm vụ: Lấy số lượng sản phẩm được Admin duyệt nhập cho biến thể này để đối chiếu với số Serial nhập vào
        TicketDAO ticketDao = new TicketDAO();
        int expectedQuantity = -1;
        if (ticketId != null) {
            List<model.TicketDetail> details = ticketDao.getTicketDetails(ticketId);
            for (model.TicketDetail td : details) {
                if (td.getVariantId() == variantId) {
                    expectedQuantity = td.getQuantity();
                    break;
                }
            }
        }

        // Bắt lỗi nếu số lượng Serial thủ kho quét không khớp với số lượng được Admin duyệt
        if (expectedQuantity != -1 && validSerials.size() != expectedQuantity) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId="
                    + variantId + "&error=MismatchImeisQuantity&expected=" + expectedQuantity + "&actual="
                    + validSerials.size());
            return;
        }

        // ĐOẠN 4: Validate Ngày nhập kho (không ở tương lai, không trước ngày tạo phiếu) & Tính hạn bảo hành tạm thời (2 tuần)
        LocalDate warrantyExpiredDate = null;
        if (receivedDate != null && !receivedDate.isEmpty()) {
            try {
                LocalDate importDate = LocalDate.parse(receivedDate);
                LocalDate today = LocalDate.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
                if (importDate.isAfter(today)) {
                    response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=InvalidImportDate" +
                            (ticketId != null ? "&ticketId=" + ticketId : "") +
                            "&variantId=" + variantId);
                    return;
                }
                if (ticketId != null) {
                    model.Ticket ticket = ticketDao.getTicketById(ticketId);
                    if (ticket != null && ticket.getCreatedAt() != null) {
                        LocalDate createdAt = ticket.getCreatedAt().toLocalDate();
                        if (importDate.isBefore(createdAt)) {
                            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=InvalidImportDateBeforeCreation" +
                                    "&ticketId=" + ticketId + "&variantId=" + variantId);
                            return;
                        }
                    }
                }
                warrantyExpiredDate = importDate.plusWeeks(2); // Hạn bảo hành tạm khi máy nằm trong kho
            } catch (java.time.format.DateTimeParseException e) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" +
                        (ticketId != null ? "&ticketId=" + ticketId : "") +
                        "&variantId=" + variantId);
                return;
            }
        }

        // ĐOẠN 5: Đóng gói đối tượng InventoryItem trạng thái 'in_stock'
        List<InventoryItem> items = new ArrayList<>();
        for (int i = 0; i < validSerials.size(); i++) {
            InventoryItem item = new InventoryItem();
            item.setVariantId(variantId);
            item.setSerialNumber(validSerials.get(i));
            item.setStatus("in_stock"); // Trạng thái sẵn sàng bán
            item.setImportDate(receivedDate);
            item.setWarrantyExpiredDate(warrantyExpiredDate);
            item.setTicketId(ticketId != null ? ticketId : 0);
            items.add(item);
        }

        // ĐOẠN 6: Thực thi Database Transaction lưu Serial & Cộng tồn kho khả dụng
        // Tham chiếu: Gọi insertInventoryItems() tại [dal/SerialDAO.java] để chèn InventoryItem và UPDATE available_quantity
        SerialDAO imeiDao = new SerialDAO();
        try {
            imeiDao.insertInventoryItems(items);
        } catch (Exception e) {
            String msg = e.getMessage();
            String sn = "";
            if (msg != null && msg.contains("Duplicate Serial Number found:")) {
                sn = msg.substring(msg.indexOf(":") + 1).trim();
            }
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=DuplicateSerial&sn=" + java.net.URLEncoder.encode(sn, "UTF-8") +
                    (ticketId != null ? "&ticketId=" + ticketId : "") +
                    "&variantId=" + variantId);
            return;
        }

        // ĐOẠN 7: Kiểm tra hoàn tất phiếu nhập kho & Điều hướng State Machine
        // Tham chiếu: Gọi isTicketFullyImported() tại [dal/TicketDAO.java]. Nếu 100% các dòng đã nhập đủ Serial -> Đổi status thành 'COMPLETED'
        if (ticketId != null) {
            if (ticketDao.isTicketFullyImported(ticketId)) {
                ticketDao.updateTicketStatus(ticketId, "COMPLETED", "Đã nhập đủ kho và mã Serial");
                response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId
                        + "&success=InboundCompleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId
                        + "&success=VariantImported");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/imei?success=Added");
        }
    }
}

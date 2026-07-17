# TỔNG KẾT ITERATION 3: CHỨC NĂNG QUẢN LÝ XUẤT KHO (OUTBOUND)
**Dự án:** UNILAP - Hệ thống quản lý kho hàng thiết bị điện tử
**Phân hệ:** Quản lý Kho (Staff)
**Người phụ trách:** HuyDQ

---

## I. MÔ TẢ NGHIỆP VỤ (BUSINESS LOGIC)

Chức năng Xuất Kho (Outbound) được xây dựng để giải quyết bài toán Fulfillment: biến một đơn hàng từ trạng thái khách hàng vừa đặt (Pending) thành trạng thái đã giao cho đơn vị vận chuyển (Shipped), kèm theo việc quản lý chặt chẽ số Serial/IMEI của từng sản phẩm rời khỏi kho.

### 1. Vòng Đời Dữ Liệu
*   **Order (Đơn hàng):** `Pending` / `Processing` -> `Shipped`
*   **Inventory Item (Sản phẩm vật lý):** `in_stock` -> `sold`

### 2. Quy Trình Vận Hành (Outbound Flow)
*   **Bước 1 - Pick List (Xem danh sách):** Thủ kho xem các đơn hàng đã thanh toán hoặc đang chờ xử lý (`Pending`, `Processing`).
*   **Bước 2 - Fulfillment (Chuẩn bị hàng):** Hệ thống phân tách đơn hàng thành các dòng sản phẩm (Variants) và số lượng cần lấy. Thủ kho chọn/quét các mã IMEI cụ thể đang có trong kho (`in_stock`) để gán cho đơn hàng.
*   **Bước 3 - Transaction & Locking (Xác nhận xuất kho):** 
    *   Hệ thống kiểm tra xem các mã IMEI vừa chọn có hợp lệ không (chống trùng lặp, chống chọn hàng đã bán).
    *   Thực hiện Database Transaction (All-or-Nothing) để chuyển trạng thái IMEI thành `sold` và sinh record vào bảng `OrderItemSerial`. Cập nhật trạng thái đơn hàng.
*   **Bước 4 - Print Delivery Slip (In phiếu):** Sinh ra phiếu giao hàng (Delivery Slip) chứa thông tin người nhận, danh sách IMEI vừa gán để dán lên thùng hàng.
*   **Bước 5 - History (Lịch sử):** Xem lại các đơn đã xuất thành công.

### 3. Ràng Buộc & Validation Chặt Chẽ
*   **Chống Race Condition:** Khóa (Lock) dữ liệu ở mức Database bằng Transaction để tránh việc 2 nhân viên kho cùng chọn 1 mã IMEI ở 2 máy tính khác nhau.
*   **Validation FE & BE:** JS ngăn không cho nhân viên chọn 1 mã IMEI cho 2 mục khác nhau trên cùng 1 đơn. Backend kiểm tra lại một lần nữa trước khi UPDATE.
*   **Bảo hành (Warranty):** Khi chuyển sang trạng thái `sold`, hệ thống kích hoạt tính toán ngày hết hạn bảo hành (`warranty_expired_date` = `sold_date` + thời gian bảo hành).

---

## II. DANH SÁCH MÃ NGUỒN VÀ KIẾN TRÚC ĐÃ TRIỂN KHAI

Hệ thống được thiết kế theo mô hình MVC nguyên bản sử dụng Java Servlet, JSP và SQL thuần (JDBC).

### 1. Database Model (Tầng Data)
*   `Order.java`: Class chứa thông tin đơn hàng tổng (Mã đơn, tổng tiền, người nhận...). Bổ sung thêm biến `completedAt` phục vụ lịch sử.
*   `OrderDetail.java`: Chứa các mặt hàng trong đơn. Bổ sung các biến UI (`productName`, `variantName`, `thumbnail`, `sku`) để tiện hiển thị.
*   `OrderItemSerial.java`: Class mapping với bảng trung gian `OrderItemSerial`, làm nhiệm vụ lưu lại vết (traceability) rằng một OrderDetail đã được giao bằng những IMEI cụ thể nào.

### 2. Data Access Object - DAO (Tầng Tương Tác DB)
Trái tim của nghiệp vụ nằm tại `OutboundDAO.java`. Chứa các câu query SQL phức tạp:
*   `getPendingOrders()`: SELECT các đơn hàng có trạng thái Pending/Processing.
*   `getOutboundHistory()`: SELECT các đơn hàng đã Shipped/Delivered.
*   `getAvailableImeisForVariant(variantId)`: Query danh sách các IMEI còn `in_stock` để đổ vào Dropdown cho thủ kho chọn.
*   `executeOutboundTransaction(orderId, imeiList)`: **[QUAN TRỌNG]** Hàm sử dụng `connection.setAutoCommit(false)` thực hiện 3 lệnh UPDATE/INSERT liên tiếp. Nếu một lệnh thất bại (VD: IMEI đã bị ai đó bán mất), toàn bộ quá trình bị `rollback()` để bảo toàn tính toàn vẹn dữ liệu.

### 3. Controllers (Tầng Xử Lý Logic)
4 Servlet tương ứng với 4 màn hình:
*   `OutboundListController.java`: Load danh sách chờ xuất kho.
*   `OutboundFulfillController.java`: 
    *   (GET): Load chi tiết đơn và gọi DAO lấy các IMEI còn khả dụng.
    *   (POST): Tiếp nhận Array các IMEI do nhân viên submit, thực hiện hàm Transaction ở DAO.
*   `OutboundHistoryController.java`: Load màn hình lịch sử.
*   `OutboundPrintController.java`: Nạp dữ liệu (bao gồm thông tin khách hàng và chi tiết các IMEI đã gán) để đẩy ra giao diện Phiếu in.

### 4. Views - JSP (Tầng Giao Diện)
Cấu trúc giao diện tận dụng bộ CSS nội bộ của dự án (`promotion.css`) kết hợp TailwindCSS.
*   `OrderList.jsp`: Giao diện Bảng danh sách đơn hàng.
*   `OrderFulfillment.jsp`: Giao diện chọn IMEI. Xử lý UI/UX khéo léo để nhân viên biết kho có đang thiếu hàng hay không. Nếu thiếu hàng, nút Submit bị disable.
*   `OrderHistory.jsp`: Giao diện xem lại các đơn.
*   `DeliverySlip.jsp`: File đặc biệt dùng kỹ thuật CSS `@media print` ẩn đi các nút bấm, thiết lập chuẩn khổ A4, thân thiện với hộp thoại In (Ctrl+P) của trình duyệt.
*   Đã cập nhật hệ thống Sidebar toàn cục (của 7 file JSP khác của Staff) để chèn thêm menu **"📦 Outbound"**.

---

## III. HƯỚNG DẪN KIỂM THỬ (TESTING)

1. Mở NetBeans, chọn **Clean and Build**.
2. Run project (Deploy lên Tomcat).
3. Sử dụng tài khoản nhân viên (Staff) đăng nhập.
4. Ở Menu bên trái, chọn tab **Outbound** (Biểu tượng 📦).
5. Luồng thao tác:
   * Chọn 1 đơn Pending -> Bấm **Chuẩn bị hàng**.
   * Ở màn hình chọn IMEI, hãy cố tình chọn trùng 1 mã IMEI ở 2 ô dropdown khác nhau -> Trình duyệt sẽ hiện cảnh báo lỗi.
   * Chọn IMEI đúng đắn -> Bấm **Xác nhận Xuất Kho**.
   * Hệ thống báo thành công và trả về trang Lịch sử.
   * Tại trang lịch sử, bấm **Xem phiếu (Print)**. Nhấn "In / Tải PDF" để xem bản xem trước khi in chuẩn A4.

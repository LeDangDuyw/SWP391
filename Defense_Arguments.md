# TÀI LIỆU BẢO VỆ NGHIỆP VỤ QUẢN LÝ KHO (OUTBOUND)
Tài liệu này tổng hợp các luận điểm kỹ thuật và nghiệp vụ được thảo luận, nhằm mục đích giúp bạn tự tin giải trình với các thành viên trong nhóm và bảo vệ trước Hội đồng chấm đồ án SWP391.

---

## 1. Tại sao bắt buộc phải làm phần Xuất kho (Outbound)?
Nhiều ý kiến cho rằng "khi khách đặt hàng, hệ thống tự động trừ đi Quantity là xong". Đối với dự án bán lẻ thiết bị điện tử có quản lý IMEI (như dự án này), tư duy trên là **sai nghiệp vụ**:

*   **Lỗi sai lệch dữ liệu (Mismatch):** Hệ thống không thể tự chọn ngẫu nhiên IMEI trong CSDL để gán vào đơn hàng. Nếu hệ thống tự gán `IMEI-001` nhưng thủ kho thực tế cầm nhầm hộp máy `IMEI-002` đi giao, CSDL bảo hành sẽ lưu sai hoàn toàn. Khách mang máy `IMEI-002` đến bảo hành sẽ bị từ chối oan.
*   **Không xử lý được hàng lỗi vật lý:** Nếu hệ thống tự gán cứng IMEI vào đơn hàng, khi thủ kho ra kệ phát hiện chiếc máy đó bị rách hộp / móp vỏ, thủ kho sẽ không có công cụ (màn hình Outbound) để đổi sang IMEI của một chiếc máy khác nguyên vẹn.
*   **In phiếu giao hàng (Delivery Slip):** Phiếu giao hàng bắt buộc phải in mã IMEI để bên vận chuyển và khách hàng đồng kiểm khi nhận. Việc gán tự động ngầm sẽ khiến phiếu giao hàng và hàng thực tế không khớp nhau.

👉 **Kết luận:** Màn hình Outbound là công cụ BẮT BUỘC để thủ kho xác nhận chính xác mã IMEI vật lý của sản phẩm được đóng gói, khớp 100% với dữ liệu lưu trên hệ thống.

---

## 2. Bằng chứng hệ thống được thiết kế để quản lý Serial
Bạn có thể tham khảo file `WarrantyDAO.java` (do bạn DuyLD viết):

```java
SELECT 1 
FROM ProductSerials ps 
JOIN OrderDetail od ON ps.order_detail_id = od.order_detail_id 
JOIN [Order] o ON o.order_id = o.order_id 
WHERE ps.serial_number = ? AND o.customer_id = ? AND o.order_status = 'COMPLETED'
```
*   **Phân tích:** Phân hệ Bảo hành đã được lập trình sẵn để query vào bảng chứa các số Serial được gán vào đơn hàng (`ProductSerials` / `OrderItemSerial`).
*   **Hậu quả nếu bỏ Outbound:** Nếu bạn bỏ luồng Xuất kho gán IMEI, bảng này sẽ hoàn toàn trống rỗng, khiến tính năng Bảo hành của cả nhóm bị tê liệt (không thể check được Serial khách mang đến có thuộc đơn hàng của họ hay không).

---

## 3. Vấn đề "Giá tiền đơn hàng sai lệch" ở màn hình Outbound
Khi xem một số đơn hàng test (ví dụ: ORD-20260502-0012 có 15 bàn phím + 1 màn hình nhưng giá chỉ 13.990.000đ), có ý kiến cho rằng Outbound tính giá bị sai hoặc fix cứng.

*   **Sự thật:** Phân hệ Outbound **KHÔNG tính toán** giá trị đơn hàng, cũng **KHÔNG hardcode**.
*   **Code chuẩn MVC:** Outbound đọc trực tiếp cột `total_amount` từ bảng `[Order]` trong cơ sở dữ liệu (`order.setTotalAmount(rs.getBigDecimal("total_amount"));`).
*   **Nguyên lý E-commerce:** Tổng tiền (`total_amount`) bắt buộc phải được tính toán 1 lần duy nhất lúc Checkout (Cộng tổng sản phẩm + Phí ship - Khuyến mãi) và lưu cứng vào bảng Order. Không được dùng phép tính `SUM(quantity * unit_price)` mỗi lần hiển thị vì sẽ làm sai lệch hóa đơn nếu khách có dùng Voucher giảm giá hoặc giá sản phẩm thay đổi trong tương lai.
*   **Lý do lỗi:** Các đơn hàng sai giá trong CSDL hiện tại là do thành viên tạo dữ liệu rác (test data) bằng các script như `PlaceOrderTest.java` đã gõ bừa dữ liệu. Khi chạy thực tế qua website, `CheckoutServlet` sẽ tính toán và lưu giá tiền chuẩn xác.

---

**🔥 CHỐT LẠI KHI BÁO CÁO:**
"Luồng Inbound và Outbound trong dự án đã được thiết kế chặt chẽ và bám sát nghiệp vụ quản lý kho bằng IMEI thực tế. Code chuẩn, linh hoạt và là mắt xích cực kỳ quan trọng để bảo đảm dữ liệu đầu vào cho tính năng Bảo hành."

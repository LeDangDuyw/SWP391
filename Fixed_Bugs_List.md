# Danh Sách Các Lỗi Nghiệp Vụ Đã Sửa (Fixed Bugs List)

Dưới đây là danh sách chi tiết các bug nghiệp vụ (Business Logic Bugs) đã được khắc phục hoàn toàn trong mã nguồn của dự án (trừ các bug liên quan đến Warranty được bỏ qua theo yêu cầu).

---

## I. MODULE: CATEGORY MANAGEMENT

### 1. [BUG-01] Xóa danh mục đang chứa sản phẩm
* **Lỗi gốc:** Cho phép xóa danh mục trực tiếp khỏi DB bất kể danh mục đó đang có sản phẩm liên kết hay không, gây vi phạm ràng buộc dữ liệu.
* **Cách sửa:** Cập nhật `CategoryDAO.java` thêm hàm `countProductsByCategory(int categoryId)`. Ở `CategoryManagementController.java`, chặn thao tác xóa và báo lỗi hiển thị lên giao diện nếu số lượng sản phẩm lớn hơn 0.

### 2. [BUG-02] Trùng tên danh mục khi thêm/sửa
* **Lỗi gốc:** Không kiểm tra trùng tên danh mục dẫn đến việc tạo nhiều danh mục cùng tên trong DB (ví dụ: "Laptop" và "laptop").
* **Cách sửa:** Thêm hàm `isCategoryExist(String name, int excludeId)` kiểm tra không phân biệt hoa thường (Case-insensitive) ở `CategoryDAO`. Chặn lưu và hiển thị thông báo lỗi trên UI tại Controller nếu tên mới bị trùng lặp.

### 3. [BUG-03] Nuốt ngoại lệ (Exception) trong DAO
* **Lỗi gốc:** Các hàm thêm/sửa/xóa chỉ in lỗi ra console (`System.out.println`) và trả về `void` khiến Controller tưởng lầm thao tác thành công.
* **Cách sửa:** Thay đổi các phương thức trong `CategoryDAO.java` để ném lỗi ra ngoài (`throws Exception`), giúp Controller có thể bắt được và thông báo lại cho người dùng trên giao diện.

---

## II. MODULE: PRODUCT CATALOG MANAGEMENT

### 4. [BUG-04] Giá bán nhỏ hơn giá nhập
* **Lỗi gốc:** Không kiểm duyệt tính hợp lý của giá tiền khi tạo sản phẩm, dẫn đến nguy cơ bán lỗ.
* **Cách sửa:** Thêm kiểm tra validation ở `AddProductController.java`: Giá bán lẻ (selling price) của từng biến thể phải lớn hơn hoặc bằng giá nhập khẩu (import price) (`price.compareTo(importPrice) >= 0`), nếu không sẽ hiển thị cảnh báo lỗi.

### 5. [BUG-05] Trùng lặp SKU sản phẩm
* **Lỗi gốc:** Không kiểm tra SKU trùng lặp trước khi tạo biến thể, gây lỗi âm thầm khi insert vào database hoặc tạo ra sản phẩm rác (Product mồ côi không có Variant).
* **Cách sửa:** Thêm hàm kiểm tra `isSkuExist(String sku)` trong `ProductDAO.java`. Ở `AddProductController.java`, validate danh sách SKU người dùng nhập lên, chặn tạo mới nếu phát hiện SKU đã tồn tại trong DB.

### 6. [BUG-06] Biến thể sản phẩm bị ẩn trên giao diện kho hàng
* **Lỗi gốc:** Sử dụng `INNER JOIN Inventory` trong hàm lấy danh sách kho. Nếu một sản phẩm mới tạo mà chưa được khởi tạo dòng trong bảng `Inventory`, nó sẽ bị biến mất khỏi UI.
* **Cách sửa:** Đổi câu lệnh SQL trong `ProductDAO.java` thành `LEFT JOIN Inventory` cho các hàm lấy danh sách tồn kho, đảm bảo hiển thị sản phẩm đầy đủ với số lượng mặc định bằng 0.

### 7. [BUG-07] Tự ý chỉnh sửa trực tiếp số lượng tồn kho (Stock)
* **Lỗi gốc:** Cho phép nhân viên thay đổi trực tiếp cột `available_quantity` ở trang chỉnh sửa sản phẩm, bỏ qua toàn bộ quy trình nhập kho (Inbound), gây lệch dữ liệu với mã IMEI thực tế.
* **Cách sửa:** Loại bỏ hoàn toàn tham số `stock` trong hàm `updateProductVariant` ở `ProductDAO.java` và xóa logic lấy/cập nhật `stock` trong `EditProductController.java`, buộc nhân viên phải tạo Inbound Ticket để tăng số lượng tồn kho.

### 8. [BUG-19] Lỗ hổng tải lên tệp tin độc hại (Unrestricted File Upload)
* **Lỗi gốc:** Lớp `AddProductController.java` chỉ kiểm tra kích thước file ảnh đại diện (`thumbnail`) mà không kiểm tra định dạng đuôi mở rộng, dẫn đến rủi ro hacker tải lên tệp `.jsp` để thực thi mã độc từ xa (RCE).
* **Cách sửa:** Bổ sung bước kiểm tra định dạng đuôi file (`.jpg`, `.jpeg`, `.png`, `.webp`) và kiểm tra Content-Type của tệp tin trước khi cho phép ghi lên ổ cứng.

---


## III. MODULE: INBOUND MANAGEMENT (Nhập kho)

### 8. [BUG-09] Nhập IMEI thiếu so với số lượng yêu cầu
* **Lỗi gốc:** Chỉ chặn khi nhập dư IMEI chứ không chặn khi nhập thiếu IMEI, khiến số tồn kho tăng ảo mà không có IMEI tương ứng để bán.
* **Cách sửa:** Sửa toán tử so sánh từ `>` thành `!=` ở `AddProductImeiController.java` (`validImeis.size() != expectedQuantity`), bắt buộc nhân viên phải nhập chính xác số lượng IMEI đã khai báo trong Ticket.

### 9. [BUG-11] Trùng lặp biến thể trong một phiếu nhập (Ticket)
* **Lỗi gốc:** Cho phép tạo phiếu nhập chứa 2 hoặc nhiều dòng cho cùng một sản phẩm/biến thể.
* **Cách sửa:** Sử dụng cấu trúc `Set<Integer> processedVariantIds` trong `CreateTicketController.java` để phát hiện dòng trùng lặp và chặn submit, yêu cầu nhân viên gộp số lượng.

### 10. [BUG-12] Nhập kho sản phẩm đã ngừng kinh doanh (Inactive)
* **Lỗi gốc:** Hàm lấy danh sách biến thể trả về cả các sản phẩm đã bị ẩn/ngừng bán, cho phép tạo phiếu nhập kho cho chúng.
* **Cách sửa:** Bổ sung điều kiện `WHERE status = 'active'` vào truy vấn `getAllVariants` trong `ProductDAO.java` để lọc bỏ các sản phẩm không còn hoạt động.

### 11. [BUG-18] Không kiểm tra trùng IMEI/Serial Number khi nhập kho
* **Lỗi gốc:** Cho phép lưu trùng mã IMEI/Serial vốn dĩ là duy nhất đối với thiết bị phần cứng.
* **Cách sửa:** Thêm bước kiểm tra trùng lặp IMEI/Serial trong bảng `InventoryItem` ở hàm `insertInventoryItems` thuộc `ImeiDAO.java` trước khi thực hiện giao dịch ghi DB.

### 12. [BUG-20] Trùng lặp mã Serial trong cùng một lô nhập (Batch Duplicate)
* **Lỗi gốc:** Chỉ kiểm tra trùng lặp serial dưới database. Nếu nhân viên nhập trùng 2 mã Serial giống nhau trên cùng một form, bước kiểm tra đơn lẻ sẽ bỏ qua, gây ra lỗi vi phạm ràng buộc duy nhất (`Unique Constraint`) khi ghi DB hàng loạt.
* **Cách sửa:** Sử dụng cấu trúc `Set<String>` ở Controller để kiểm tra và loại bỏ trùng lặp mã Serial ngay trong danh sách gửi lên trước khi chuyển xuống lớp DAO.

### 13. [BUG-21] Đề xuất nhập kho với đơn giá âm
* **Lỗi gốc:** Không giới hạn giá trị tối thiểu của đơn giá đề xuất (`expectedPrice`), cho phép tạo phiếu nhập kho với giá âm.
* **Cách sửa:** Bổ sung điều kiện validate `expectedPrice.compareTo(BigDecimal.ZERO) <= 0` để chặn và báo lỗi nếu giá nhập <= 0.

---


## IV. MODULE: OUTBOUND MANAGEMENT (Xuất kho)

### 12. [BUG-13] Phân biệt hoa thường khi kiểm tra trạng thái Order
* **Lỗi gốc:** Sử dụng `equals` phân biệt hoa thường ("Pending" và "processing"), khiến đơn hàng có trạng thái "Processing" bị từ chối Fulfill.
* **Cách sửa:** Đổi sang dùng phương thức `equalsIgnoreCase` ở `OutboundFulfillController.java` để đảm bảo hoạt động đồng nhất.

### 13. [BUG-14] Nuốt lỗi khi hủy đơn hàng thất bại
* **Lỗi gốc:** Controller không kiểm tra kết quả trả về của hàm cập nhật trạng thái đơn, dẫn đến việc không hiển thị thông báo lỗi khi thao tác hủy đơn không được chấp nhận.
* **Cách sửa:** Cập nhật `OutboundUpdateStatusController.java` để bắt kết quả trả về (`boolean ok`). Nếu cập nhật thất bại, hệ thống sẽ lưu thông báo lỗi vào Session và phản hồi lại cho người dùng.

### 14. [BUG-15] Không trừ số lượng sẵn có (available_quantity) khi xuất kho
* **Lỗi gốc:** Khi xuất kho thành công, hệ thống chuyển trạng thái IMEI sang `sold` nhưng quên không trừ số lượng tồn kho tổng thể trong bảng `Inventory`, dẫn đến dữ liệu ảo cho phép bán quá số lượng thực tế.
* **Cách sửa:** Thêm câu lệnh cập nhật giảm tồn kho `UPDATE [Inventory] SET available_quantity = available_quantity - quantity` vào trong cùng một Transaction tại hàm `executeOutboundTransaction` ở `OutboundDAO.java`.

### 15. [BUG-16 & BUG-17] Thiếu phân trang danh sách đơn hàng Outbound
* **Lỗi gốc:** Tải toàn bộ danh sách đơn hàng chờ xử lý và lịch sử đơn hàng vào RAM cùng lúc, gây chậm hệ thống (Memory Leak/Performance issues).
* **Cách sửa:** Thêm phân trang bằng cách sử dụng mệnh đề `OFFSET ? ROWS FETCH NEXT ? ROWS ONLY` trong SQL ở `OutboundDAO.java` và tích hợp tham số phân trang `page` tại `OutboundListController.java` cùng `OutboundHistoryController.java`.

### 16. [BUG-22] Lỗ hổng gán sai mã máy khi xuất kho (Mismatched Product Variant & Serial Assignment)
* **Lỗi gốc:** Giao dịch xuất kho chỉ tìm và cập nhật Serial theo `itemId` mà không kiểm tra tính đồng nhất về mặt hàng, cho phép xuất sai loại Serial của sản phẩm này cho sản phẩm khác.
* **Cách sửa:** Bổ sung kiểm tra chéo `variant_id` trong câu lệnh SQL UPDATE trạng thái bán của Serial để đảm bảo Serial được chọn thuộc đúng biến thể của đơn hàng.

### 17. [BUG-23] Bỏ qua trạng thái xuất kho (State Machine Bypass)
* **Lỗi gốc:** Cho phép chuyển trạng thái đơn hàng sang `delivered` hoặc `Completed` trực tiếp từ trạng thái `Pending` mà không cần qua bước gán Serial (`shipped`), làm mất dấu vết xuất kho và không trừ số lượng tồn kho thực tế.
* **Cách sửa:** Chặn chuyển đổi trạng thái giao hàng thành công nếu đơn hàng chưa có bản ghi xuất kho liên kết trong bảng `OrderItemSerial`.


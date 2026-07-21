# Hướng Dẫn Chi Tiết Trình Tự Thực Thi Code (Control Flow & Data Flow)
Tài liệu này mô tả chi tiết các bước chạy của hệ thống, chỉ rõ dòng code, phương thức, lớp, câu lệnh SQL và luồng dữ liệu tương ứng cho ba quy trình cốt lõi: **Inbound (Nhập kho)**, **Outbound (Xuất kho)**, và **Product Catalog (Danh mục & Sản phẩm)**.

---

## 1. Luồng Nhập kho (Inbound Flow)

Quy trình này được thực hiện qua 4 giai đoạn chính:

### Giai đoạn 1.1: Đề xuất phiếu nhập (Create Import Ticket)
*   **Bước 1: Hiển thị form**
    *   **Client Request:** Trình duyệt gửi yêu cầu `GET` tới URL `/staff/ticket/create`.
    *   **Controller:** Lớp [CreateTicketController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/CreateTicketController.java) đón nhận trong phương thức `doGet` (dòng 32-55).
    *   **Xử lý dữ liệu:** Controller gọi `ProductDAO.GetAllProducts()` và `ProductDAO.getAllVariants()` để chuẩn bị dữ liệu sản phẩm/biến thể đưa vào request attribute.
    *   **Giao diện:** Forward sang [CreateTicket.jsp](file:///c:/Users/huy/Downloads/lll/SWP391/web/staff/ticket/CreateTicket.jsp) (dòng 54) để hiển thị form nhập liệu.
*   **Bước 2: Submit form tạo phiếu**
    *   **Client Action:** Người dùng nhập tiêu đề (`title`), chọn các biến thể, nhập số lượng (`quantity`), giá đề xuất (`expectedPrice`) và nhấn gửi (yêu cầu `POST` tới `/staff/ticket/create`).
    *   **Controller:** Lớp [CreateTicketController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/CreateTicketController.java) tiếp nhận ở `doPost` (dòng 58-128).
    *   **Validate:** Kiểm tra các trường bắt buộc, duyệt qua danh sách biến thể, lọc bỏ các dòng có số lượng $\le 0$, kiểm tra tránh chọn trùng lặp biến thể trong cùng một phiếu (dòng 78-110).
    *   **DAO & Database:** 
        *   Controller khởi tạo đối tượng `Ticket` với trạng thái mặc định `"WAITING_FOR_ADMIN_REVIEW"` (dòng 117-120).
        *   Gọi phương thức `createTicket(ticket, details)` của [TicketDAO](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/dal/TicketDAO.java) (dòng 15-66).
        *   **Giao dịch database (Transaction):**
            1.  Thiết lập `connection.setAutoCommit(false)` (dòng 21).
            2.  Thực hiện PreparedStatement chèn thông tin phiếu:
                ```sql
                INSERT INTO Ticket (title, status, reason, created_by, created_at, updated_at) 
                VALUES (?, ?, ?, ?, GETDATE(), GETDATE())
                ```
            3.  Lấy ID tự tăng của Ticket vừa tạo (`generatedTicketId`) bằng `Statement.RETURN_GENERATED_KEYS`.
            4.  Chạy Batch chèn các bản ghi chi tiết phiếu vào bảng `TicketDetails`:
                ```sql
                INSERT INTO TicketDetails (ticket_id, variant_id, quantity, expected_price) 
                VALUES (?, ?, ?, ?)
                ```
            5.  Gọi `connection.commit()` (dòng 50) để hoàn tất hoặc `rollback()` nếu có lỗi SQL.
    *   **Response:** Redirect về trang danh sách phiếu `/staff/ticket/list?success=TicketCreated` (dòng 126).

---

### Giai đoạn 1.2: Duyệt phiếu nhập (Admin Review)
*   **Client Action:** Admin xem chi tiết phiếu và click nút "Approve" (Duyệt) hoặc "Reject" (Từ chối) kèm theo lý do (`reason`), gửi yêu cầu `POST` đến `/admin/ticket/review`.
*   **Controller:** Lớp [ReviewTicketController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/ReviewTicketController.java) tiếp nhận ở `doPost` (dòng 25-62).
*   **State Machine Validation:**
    *   Gọi `TicketDAO.getTicketById(ticketId)` lấy trạng thái hiện tại.
    *   Chỉ cho phép tiếp tục nếu trạng thái cũ là `"WAITING_FOR_ADMIN_REVIEW"` (dòng 49-52). Nếu khác, trả lỗi `"InvalidStatusTransition"`.
*   **DAO & Database:**
    *   Xác định trạng thái mới dựa trên nút bấm của Admin (Approved $\rightarrow$ `"APPROVED_EXECUTION"`, Reject $\rightarrow$ `"REJECTED"`).
    *   Gọi `TicketDAO.updateTicketStatus(ticketId, status, reason)` (dòng 55) để thực thi câu lệnh SQL:
        ```sql
        UPDATE Ticket SET status = ?, reason = ?, updated_at = GETDATE() WHERE ticket_id = ?
        ```
*   **Response:** Redirect về trang danh sách của admin `/admin/ticket/list?success=TicketReviewed` (dòng 58).

---

### Giai đoạn 1.3: Nhận hàng vật lý (Cargo Received Workflow)
*   **Client Action:** Nhân viên thực hiện nhận hàng thực tế tại kho, chọn "Receive Cargo" trên giao diện chi tiết phiếu, gửi yêu cầu `POST` đến `/staff/ticket/workflow` với tham số `action=receive` và `ticketId`.
*   **Controller:** Lớp [CargoWorkflowController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/CargoWorkflowController.java) xử lý trong `doPost` (dòng 47-108).
*   **State Machine Validation:** 
    *   Tải thông tin ticket và kiểm tra trạng thái hiện tại.
    *   Chỉ cho phép nhận hàng nếu trạng thái hiện tại là `"APPROVED_EXECUTION"` (dòng 82-85).
*   **DAO & Database:**
    *   Thiết lập `newStatus = "CARGO_RECEIVED"`.
    *   Gọi `TicketDAO.updateTicketStatus(ticketId, "CARGO_RECEIVED", "")` (dòng 101) để thực thi cập nhật trạng thái phiếu trong bảng `Ticket`.
*   **Response:** Redirect về lại trang workflow để bắt đầu quy trình nhập serial: `/staff/ticket/workflow?id=ticketId` (dòng 103).

---

### Giai đoạn 1.4: Khai báo Serial & Hoàn thành (Add Serials & Complete)
*   **Bước 1: Hiển thị giao diện nhập serial**
    *   **Client Request:** Click nút "Nhập Serial" ứng với từng variant $\rightarrow$ `GET` tới `/staff/serial/add?ticketId=...&variantId=...`.
    *   **Controller:** [AddProductSerialController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/AddProductSerialController.java) tiếp nhận trong `doGet` (dòng 30-78).
    *   **Xử lý dữ liệu:** Gọi `TicketDAO.getTicketDetails(ticketId)` để tìm số lượng cần nhập (`expectedQuantity`), lấy thông tin biến thể (`variantId`) từ `ProductDAO`.
    *   **Giao diện:** Forward sang [AddProductSerial.jsp](file:///c:/Users/huy/Downloads/lll/SWP391/web/staff/AddProductSerial.jsp) (dòng 77) hiển thị form gồm `N` ô nhập serial (với `N` = `expectedQuantity`).
*   **Bước 2: Ghi nhận Serial và Tăng tồn kho**
    *   **Client Action:** Quét/Nhập danh sách mã Serial và nhấn "Hoàn thành" $\rightarrow$ `POST` tới `/staff/serial/add`.
    *   **Controller:** [AddProductSerialController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/AddProductSerialController.java) tiếp nhận ở `doPost` (dòng 80-188).
    *   **Validate:** Kiểm tra tính hợp lệ của ngày nhận (không được sau ngày hôm nay), so khớp số lượng serial gửi lên có đúng bằng `expectedQuantity` hay không (dòng 138-141).
    *   **DAO & Database:**
        *   Khởi tạo danh sách `List<InventoryItem>` tương ứng.
        *   Gọi `SerialDAO.insertInventoryItems(items)` (dòng 176). Trong [SerialDAO](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/dal/SerialDAO.java):
            1.  Kiểm tra trùng lặp serial trong hệ thống (dòng 142-150) bằng SQL:
                ```sql
                SELECT COUNT(*) FROM InventoryItem WHERE serial_number = ?
                ```
            2.  Nếu không trùng, tắt AutoCommit: `connection.setAutoCommit(false)` (dòng 152).
            3.  Thêm từng Serial Number vào bảng `InventoryItem` (Batch Insert):
                ```sql
                INSERT INTO InventoryItem (variant_id, serial_number, status, import_date, warranty_expired_date, note, ticket_id) 
                VALUES (?, ?, ?, ?, ?, ?, ?)
                ```
            4.  Tính toán tăng tồn kho khả dụng và chạy câu lệnh cập nhật bảng `Inventory` (Batch Update):
                ```sql
                UPDATE [Inventory] SET available_quantity = available_quantity + ? WHERE variant_id = ?
                ```
            5.  Gọi `connection.commit()` (dòng 202) để chốt giao dịch.
    *   **Kiểm tra hoàn thành phiếu:** 
        *   Quay lại [AddProductSerialController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/AddProductSerialController.java), controller gọi `TicketDAO.isTicketFullyImported(ticketId)` (dòng 179) để kiểm tra xem tất cả các biến thể trong phiếu nhập đã được khai báo đủ serial chưa qua câu lệnh SQL:
            ```sql
            SELECT COUNT(*) FROM TicketDetails td 
            WHERE td.ticket_id = ? AND td.quantity > (
                SELECT COUNT(*) FROM InventoryItem ii WHERE ii.ticket_id = td.ticket_id AND ii.variant_id = td.variant_id
            )
            ```
        *   Nếu trả về `true` (không còn dòng nào thiếu hàng): Gọi `TicketDAO.updateTicketStatus(ticketId, "COMPLETED", ...)` cập nhật trạng thái phiếu thành `"COMPLETED"`.
*   **Response:** Redirect về trang chi tiết workflow `/staff/ticket/workflow?id=ticketId&success=InboundCompleted` (dòng 181).

---

## 2. Luồng Xuất kho (Outbound Flow)

Quy trình này quản lý việc chuẩn bị hàng và giao hàng cho các đơn hàng của hệ thống:

### Giai đoạn 2.1: Hiển thị đơn hàng chờ xuất (Outbound List)
*   **Client Action:** Nhân viên truy cập phân hệ xuất kho $\rightarrow$ URL `/staff/outbound/list`.
*   **Controller:** Lớp [OutboundListController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/OutboundListController.java) nhận trong `doGet` (dòng 17-42).
*   **DAO & Database:** Gọi `OutboundDAO.getPendingOrders(offset, pageSize)` (dòng 36) để truy vấn danh sách đơn hàng có trạng thái `Pending` hoặc `processing`:
    ```sql
    SELECT * FROM [Order] WHERE order_status IN ('Pending', 'processing') 
    ORDER BY order_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    ```
*   **Giao diện:** Forward dữ liệu sang [OrderList.jsp](file:///c:/Users/huy/Downloads/lll/SWP391/web/staff/outbound/OrderList.jsp) (dòng 41).

---

### Giai đoạn 2.2: Chọn Serial & Bàn giao xuất kho (Outbound Fulfillment)
*   **Bước 1: Chọn Serial**
    *   **Client Action:** Bấm nút "Fulfill" ứng với đơn hàng $\rightarrow$ `GET` tới `/staff/outbound/fulfill?orderId=...`.
    *   **Controller:** [OutboundFulfillController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/OutboundFulfillController.java) xử lý ở `doGet` (dòng 23-60).
    *   **Xử lý dữ liệu:**
        *   Tải đơn hàng: `OutboundDAO.getOrderById(orderId)`.
        *   Lấy chi tiết sản phẩm khách mua: `OutboundDAO.getOrderDetails(orderId)`.
        *   Với mỗi mặt hàng, truy vấn các serial đang sẵn có trong kho (`status = 'in_stock'`) thông qua hàm `OutboundDAO.getAvailableSerialsForVariant(variantId)` (dòng 47):
            ```sql
            SELECT item_id, serial_number FROM InventoryItem 
            WHERE variant_id = ? AND status = 'in_stock' ORDER BY item_id ASC
            ```
    *   **Giao diện:** Forward sang [OrderFulfillment.jsp](file:///c:/Users/huy/Downloads/lll/SWP391/web/staff/outbound/OrderFulfillment.jsp) (dòng 55).
*   **Bước 2: Thực thi giao dịch xuất kho**
    *   **Client Action:** Nhân viên chọn tích chọn đủ các Serial Number tương ứng với số lượng hàng khách đặt mua $\rightarrow$ Nhấn nút Xác nhận xuất kho (`POST` tới `/staff/outbound/fulfill`).
    *   **Controller:** [OutboundFulfillController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/OutboundFulfillController.java) xử lý trong `doPost` (dòng 63-112).
    *   **Validate:** Kiểm tra xem số lượng serial được chọn cho mỗi mặt hàng có khớp chính xác với số lượng yêu cầu đặt mua (`detail.getQuantity()`) hay không (dòng 80-85).
    *   **DAO & Database:**
        *   Tạo Map liên kết dữ liệu giữa `orderDetailId` và danh sách các `itemId` (Serial ID) được chọn.
        *   Gọi phương thức giao dịch `OutboundDAO.executeOutboundTransaction(orderId, orderDetailToItemIds)` (dòng 96). Trong [OutboundDAO](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/dal/OutboundDAO.java):
            1.  Thiết lập `connection.setAutoCommit(false)` (dòng 324).
            2.  Cập nhật trạng thái từng máy (Serial) thành đã bán, đồng thời ghi nhận ngày bán và hạn bảo hành dựa trên số tháng bảo hành khai báo của sản phẩm gốc (dòng 326-348):
                ```sql
                UPDATE InventoryItem SET status = 'sold', sold_date = GETDATE(), 
                       warranty_expired_date = DATEADD(month, (SELECT p.warranty_period FROM Product p 
                       JOIN ProductVariant pv ON p.product_id = pv.product_id 
                       WHERE pv.variant_id = InventoryItem.variant_id), GETDATE()) 
                WHERE item_id = ? AND status = 'in_stock'
                ```
            3.  Ghi nhận máy nào được bàn giao cho đơn hàng chi tiết vào bảng `OrderItemSerial` (dòng 349-354):
                ```sql
                INSERT INTO OrderItemSerial (order_detail_id, item_id, assigned_at) VALUES (?, ?, GETDATE())
                ```
            4.  Cập nhật trừ tồn kho khả dụng trong bảng `Inventory` (dòng 358-364):
                ```sql
                UPDATE [Inventory] SET available_quantity = available_quantity - od.quantity 
                FROM [Inventory] JOIN OrderDetail od ON [Inventory].variant_id = od.variant_id 
                WHERE od.order_id = ?
                ```
            5.  Cập nhật trạng thái đơn hàng thành `"shipped"` và lưu thời gian xuất kho hoàn thành (dòng 367-371):
                ```sql
                UPDATE [Order] SET order_status = 'shipped', completed_at = GETDATE() WHERE order_id = ?
                ```
            6.  Gọi `connection.commit()` (dòng 373).
*   **Response:** Chuyển hướng sang trang in phiếu biên nhận xuất kho `/staff/outbound/print?orderId=orderId` (dòng 99).

---

### Giai đoạn 2.3: Cập nhật giao hàng & Tạo/gửi Hóa đơn PDF
*   **Client Action:** Khi đơn hàng giao thành công, nhân viên chọn cập nhật trạng thái đơn sang `"delivered"` hoặc `"Completed"`, gửi yêu cầu `POST` tới `/staff/outbound/update-status`.
*   **Controller:** Lớp [OutboundUpdateStatusController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/OutboundUpdateStatusController.java) tiếp nhận trong `doPost` (dòng 23-100).
*   **DAO & Database:**
    *   Gọi `OutboundDAO.updateOrderStatus(orderId, status)` (dòng 41).
    *   Gọi `OutboundDAO.addOrderLog(...)` (dòng 44) để chèn bản ghi vào bảng `OrderLog`:
        ```sql
        INSERT INTO OrderLog (order_id, old_status, new_status, action_by, log_message) 
        VALUES (?, ?, ?, ?, ?)
        ```
*   **Tạo hóa đơn & Gửi Email (Chỉ chạy khi status là delivered hoặc Completed):**
    *   Hệ thống gọi lớp dịch vụ `PdfInvoiceService.generateInvoice(updatedOrder, realPath)` (dòng 56) để tạo tệp tin hóa đơn PDF chứa thông tin chi tiết đơn hàng, danh sách mã máy (Serial) tương ứng. Tệp được lưu trữ cục bộ.
    *   Lấy thông tin email khách hàng bằng SQL:
        ```sql
        SELECT email FROM [Users] WHERE user_id = ?
        ```
    *   Gọi lớp dịch vụ `EmailService.sendInvoiceEmail(customerEmail, orderCode, pdfFile)` (dòng 64) để tiến hành gửi email qua SMTP server.
    *   Cập nhật trạng thái gửi hóa đơn vào bảng `Order` (dòng 79) bằng SQL:
        ```sql
        UPDATE [Order] SET invoice_path = ?, invoice_email_sent = ? WHERE order_id = ?
        ```
*   **Response:** Redirect về trang lịch sử xuất kho hoặc trang quản lý đơn tùy tham số (dòng 90-98).

---

### Giai đoạn 2.4: Hủy đơn hàng & Hoàn trả kho (Cancel Order Rollback)
*   **Client Action:** Người dùng/Nhân viên hủy đơn hàng khi đơn đã xuất kho (`shipped`) $\rightarrow$ `POST` tới `/staff/outbound/update-status` với `status=cancelled`.
*   **Controller:** [OutboundUpdateStatusController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/OutboundUpdateStatusController.java) chuyển trạng thái `"cancelled"` vào DAO.
*   **DAO & Database (Logic Rollback tự động trong `OutboundDAO.updateOrderStatus`):**
    *   Kiểm tra nếu trạng thái hiện tại là `"delivered"` hoặc `"Completed"` thì không cho phép hủy (dòng 410-413).
    *   Nếu trạng thái cũ là `"shipped"` (đã xuất serial ra khỏi kho):
        1.  Chuyển lại trạng thái các máy (Serial) liên quan từ `"sold"` về lại `"in_stock"` và xóa dấu thời gian bán (dòng 419-426):
            ```sql
            UPDATE InventoryItem SET status = 'in_stock', sold_date = NULL, warranty_expired_date = NULL 
            WHERE item_id IN (SELECT item_id FROM OrderItemSerial ois 
            JOIN OrderDetail od ON ois.order_detail_id = od.order_detail_id WHERE od.order_id = ?)
            ```
        2.  Xóa bản ghi liên kết giữa chi tiết đơn hàng và Serial trong bảng `OrderItemSerial` (dòng 429-433):
            ```sql
            DELETE FROM OrderItemSerial WHERE order_detail_id IN (
                SELECT order_detail_id FROM OrderDetail WHERE order_id = ?
            )
            ```
        3.  Cộng hoàn trả lại số lượng tồn kho khả dụng vào bảng `Inventory` (dòng 437-445):
            ```sql
            UPDATE [Inventory] SET available_quantity = [Inventory].available_quantity + od.quantity 
            FROM [Inventory] JOIN OrderDetail od ON [Inventory].variant_id = od.variant_id 
            WHERE od.order_id = ?
            ```
    *   Cập nhật trạng thái đơn hàng trong bảng `Order` thành `"cancelled"` (dòng 450).

---

## 3. Luồng Danh mục & Sản phẩm (Product Catalog Flow)

Quy trình quản lý dữ liệu danh mục, sản phẩm gốc và cấu hình biến thể:

### Giai đoạn 3.1: Quản lý danh mục (Category CRUD)
*   **Client Request:** Nhân viên quản lý danh mục tại URL `/staff/category`.
*   **Controller:** [CategoryManagementController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/CategoryManagementController.java) (dòng 13-118).
*   **Thêm mới danh mục (`action=add`):**
    *   Controller lấy tham số `categoryName` và gọi `CategoryDAO.isCategoryExist()` để check trùng.
    *   Nếu chưa tồn tại, gọi `CategoryDAO.insertCategory(name)` để thực thi SQL:
        ```sql
        INSERT INTO Category (category_name) VALUES (?)
        ```
*   **Cập nhật danh mục (`action=update`):**
    *   Gọi `CategoryDAO.updateCategory(categoryId, name)` để thực thi SQL:
        ```sql
        UPDATE Category SET category_name = ? WHERE category_id = ?
        ```
*   **Xóa danh mục (`action=delete`):**
    *   Controller gọi `CategoryDAO.countProductsByCategory(categoryId)` (dòng 93) để đếm số lượng sản phẩm thuộc danh mục thông qua câu lệnh:
        ```sql
        SELECT COUNT(*) FROM Product WHERE category_id = ?
        ```
    *   Nếu kết quả $> 0$, controller chặn tiến trình và trả lỗi `"Không thể xóa danh mục đang có sản phẩm."`.
    *   Nếu bằng 0, gọi `CategoryDAO.deleteCategory(categoryId)` để thực thi SQL:
        ```sql
        DELETE FROM Category WHERE category_id = ?
        ```
*   **Response:** Redirect hoặc forward lại về `/staff/category`.

---

### Giai đoạn 3.2: Thêm sản phẩm & Biến thể (Add Product & Variants)
*   **Bước 1: Hiển thị Form thêm sản phẩm**
    *   **Client Request:** `GET` tới `/staff/inventory/add`.
    *   **Controller:** [AddProductController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/AddProductController.java) đón nhận và load danh mục, thương hiệu và toàn bộ dòng sản phẩm (`ProductSeriesDAO().getAllSeries()`) truyền vào request attributes.
    *   **Client JS Logic:** JavaScript lắng nghe thay đổi của Brand/Category:
        *   Nếu danh mục là Laptop (`categoryId` = 1), hiển thị dropdown chọn Dòng sản phẩm (`seriesId`), ngược lại ẩn đi.
        *   Khi chọn Hãng (`brandId`), lọc và hiển thị danh sách Dòng sản phẩm tương ứng của hãng đó.
        *   Khi chọn Nhu cầu là `"Khác"`, hiển thị thêm một ô input nhập văn bản tự do để nhập nhu cầu mới.
*   **Bước 2: Submit Form thêm sản phẩm**
    *   **Client Action:** Nhấn nút lưu sản phẩm $\rightarrow$ gửi yêu cầu `POST` tới `/staff/inventory/add`.
    *   **Controller:** [AddProductController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/AddProductController.java) xử lý (dòng 63-259).
    *   **Validate & Custom Purpose Logic:**
        *   Kiểm tra các trường bắt buộc.
        *   Đọc `purposeSelect`. Nếu là `"Khác"`, lấy giá trị chuỗi từ `purposeCustom`.
        *   Kiểm tra giá bán không được nhỏ hơn giá nhập của từng biến thể, gọi `ProductDAO.isSkuExist(sku)` kiểm tra tính duy nhất của mã SKU.
*   **Bước 3: Xử lý tệp hình ảnh & Ghi Database**
    *   **Upload:** Đọc file Part của ảnh sản phẩm qua `request.getPart("thumbnail")`. Tạo tên ngẫu nhiên UUID và lưu tệp vào thư mục `/images` trên server.
    *   **DAO & Database:**
        1.  Khởi tạo đối tượng `Product` và gọi `ProductDAO.insertProduct(product)` để thực thi chèn vào bảng `Product`:
            ```sql
            INSERT INTO Product (product_name, description, warranty_period, thumbnail, category_id, brand_id, purpose, series_id) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ```
            Lấy về khóa chính tự tăng `product_id`.
        2.  Lặp qua danh sách các biến thể khai báo trong form và thực hiện SQL:
            ```sql
            INSERT INTO ProductVariant (product_id, variant_name, sku, selling_price, import_price, thumbnail) 
            VALUES (?, ?, ?, ?, ?, ?)
            ```
            Đồng thời khởi tạo bản ghi tồn kho ban đầu cho biến thể đó trong bảng `Inventory`:
            ```sql
            INSERT INTO [Inventory] (variant_id, available_quantity) VALUES (?, 0)
            ```
*   **Response:** Redirect về trang quản lý kho `/staff/inventory`.

---

### Giai đoạn 3.3: Chỉnh sửa thông tin sản phẩm (Edit Product & Variants)
*   **Bước 1: Hiển thị Form chỉnh sửa**
    *   **Client Request:** `GET` tới `/staff/inventory/edit?variantId=...`.
    *   **Controller:** [EditProductController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/EditProductController.java) truy vấn sản phẩm bằng `ProductDAO.getProductByVariantId(variantId)` (lấy thêm các trường `purpose` và `series_id`), nạp danh mục, thương hiệu, series và chuyển hướng sang [EditProduct.jsp](file:///c:/Users/huy/Downloads/lll/SWP391/web/staff/EditProduct.jsp).
    *   **Client JS Logic:** Tự động điền giá trị cũ: nếu nhu cầu sử dụng hiện tại không thuộc các nhu cầu mặc định, chọn `"Khác"` ở dropdown và hiện ô nhập text chứa sẵn giá trị đó. Đồng thời tự động lọc và chọn Dòng sản phẩm phù hợp.
*   **Bước 2: Cập nhật thông tin sản phẩm gốc**
    *   **Client Action:** Click "Cập nhật sản phẩm" $\rightarrow$ gửi `POST` tới `/staff/inventory/edit` kèm `action=updateProduct`.
    *   **Controller:** [EditProductController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/EditProductController.java) tiếp nhận.
    *   **DAO & Database:**
        *   Nhận `productName`, `categoryId`, `brandId`, `description`, `warrantyPeriod`, `purposeSelect`/`purposeCustom`, `seriesId`.
        *   Gọi `ProductDAO.updateProduct(...)` để thực thi cập nhật:
            ```sql
            UPDATE Product SET product_name = ?, category_id = ?, brand_id = ?, description = ?, warranty_period = ?, purpose = ?, series_id = ? 
            WHERE product_id = ?
            ```
    *   **Response:** Redirect về trang danh sách kho `/staff/inventory`.
*   **Bước 3: Chỉnh sửa thông tin biến thể (Edit Variant)**
    *   **Client Action:** Chọn sửa một biến thể cụ thể, cập nhật thông tin trong Modal và bấm lưu $\rightarrow$ gửi `POST` tới `/staff/inventory/edit` kèm `action=updateVariant`.
    *   **Controller:** [EditProductController](file:///c:/Users/huy/Downloads/lll/SWP391/src/java/controller/EditProductController.java) xử lý.
    *   **DAO & Database:** Gọi `ProductDAO.updateProductVariant(variantId, sku, variantName, price)` để thực thi cập nhật:
        ```sql
        UPDATE ProductVariant SET sku = ?, variant_name = ?, selling_price = ? WHERE variant_id = ?
        ```
    *   **Response:** Redirect quay lại trang sửa `/staff/inventory/edit?variantId=variantId`.


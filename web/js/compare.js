/**
 * UniLap Product Compare JavaScript
 * Quản lý các thao tác AJAX tương tác trên bảng So Sánh Sản Phẩm.
 * 
 * LIÊN KẾT:
 * - Java Controller: controller.CompareServlet (/compare)
 * - View JSP: web/customer/compareProducts.jsp, web/customer/product_list.jsp, web/customer/product_detail.jsp
 * - Session Attribute: "compareList"
 */

const contextPath = window.contextPath || '/SWP391';

/**
 * CHỨC NĂNG: Gửi yêu cầu AJAX thêm 1 sản phẩm vào danh sách so sánh trong Session.
 * LIÊN KẾT:
 * - Endpoint: GET /compare?action=add&id={productId}&isFetch=true (CompareServlet)
 * - Reload trang web/customer/compareProducts.jsp khi phản hồi trả về "success"
 * 
 * @param {number} productId ID của sản phẩm cần thêm vào danh sách so sánh
 */
function addProductToCompare(productId) {
    const url = `${contextPath}/compare?action=add&id=${productId}&isFetch=true`;
    console.log("[Compare] Fetching URL:", url);

    fetch(url)
        .then(response => {
            console.log("[Compare] HTTP Status:", response.status, response.ok);
            if (!response.ok) throw new Error("Lỗi kết nối máy chủ");
            return response.text();
        })
        .then(result => {
            const status = result.trim();
            console.log("[Compare] Server returned:", JSON.stringify(status));
            if (status === "success") {
                window.location.reload();
            } else {
                alert("Thông báo: " + status);
            }
        })
        .catch(error => {
            console.error("[Compare] Lỗi fetch:", error);
            alert("Không thể kết nối tới máy chủ.");
        });
}

/**
 * CHỨC NĂNG: Gửi yêu cầu AJAX loại bỏ 1 sản phẩm khỏi danh sách so sánh trong Session.
 * LIÊN KẾT:
 * - Endpoint: GET /compare?action=remove&id={productId}&isFetch=true (CompareServlet)
 * - Reload lại bảng so sánh trên web/customer/compareProducts.jsp
 * 
 * @param {number} productId ID của sản phẩm cần xóa khỏi so sánh
 */
function removeProductFromCompare(productId) {
    const url = `${contextPath}/compare?action=remove&id=${productId}&isFetch=true`;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Lỗi kết nối máy chủ");
            return response.text();
        })
        .then(result => {
            if (result.trim() === "success") {
                window.location.reload();
            } else {
                alert("Lỗi khi xóa: " + result);
            }
        })
        .catch(error => {
            console.error("Lỗi fetch:", error);
        });
}

/**
 * CHỨC NĂNG: Gửi yêu cầu AJAX xóa sạch toàn bộ sản phẩm khỏi danh sách so sánh trong Session.
 * LIÊN KẾT:
 * - Endpoint: GET /compare?action=clear&isFetch=true (CompareServlet)
 * - Reload lại trang web/customer/compareProducts.jsp hiển thị trạng thái bảng trống
 */
function clearCompareList() {
    const url = `${contextPath}/compare?action=clear&isFetch=true`;

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error("Lỗi kết nối máy chủ");
            return response.text();
        })
        .then(result => {
            if (result.trim() === "success") {
                window.location.reload();
            }
        })
        .catch(error => {
            console.error("Lỗi fetch:", error);
        });
}

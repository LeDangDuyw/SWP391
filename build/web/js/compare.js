//minhbq

// Lấy contextPath của Web Application (được định nghĩa ở JSP)
const contextPath = window.contextPath || '/SWP391';

/**
 * Hàm thêm sản phẩm vào danh sách so sánh (sử dụng fetch)
 * @param {number} productId 
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
 * Hàm xóa sản phẩm khỏi danh sách so sánh (sử dụng fetch)
 * @param {number} productId 
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
                window.location.reload(); // Reload trang để danh sách cập nhật ngay
            } else {
                alert("Lỗi khi xóa: " + result);
            }
        })
        .catch(error => {
            console.error("Lỗi fetch:", error);
        });
}

/**
 * Hàm xóa sạch toàn bộ danh sách so sánh (sử dụng fetch)
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
                window.location.reload(); // Reload trang
            }
        })
        .catch(error => {
            console.error("Lỗi fetch:", error);
        });
}

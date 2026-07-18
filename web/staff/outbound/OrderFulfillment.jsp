<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Chuẩn bị đơn hàng #${order.orderCode}</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "primary": "#003ec7", "on-primary": "#ffffff", "on-surface": "#191c1e",
                        "on-surface-variant": "#434656", "surface": "#f7f9fb", "surface-container-low": "#f2f4f6",
                        "surface-container-lowest": "#ffffff", "outline-variant": "#c3c5d9",
                        "primary-container": "#0052ff", "on-primary-container": "#dfe3ff",
                        "primary-fixed": "#dde1ff", "error": "#ba1a1a"
                    },
                    "fontFamily": { "body-md": ["Inter"], "body-sm": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Space Grotesk"], "headline-md": ["Space Grotesk"] },
                    "fontSize": {
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}], "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}], "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
                    },
                    "spacing": { "gutter": "24px" }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
    <script>
        function validateForm(event) {
            const allSelects = document.querySelectorAll('select[name^="detail_"]');
            const chosen = new Set();
            for (const sel of allSelects) {
                if (!sel.value) { alert("Vui lòng chọn Serial Number cho tất cả sản phẩm."); event.preventDefault(); return false; }
                if (chosen.has(sel.value)) { alert("Lỗi: Bạn đã chọn trùng 1 Serial Number cho 2 dòng khác nhau!"); event.preventDefault(); return false; }
                chosen.add(sel.value);
            }
            return true;
        }
    </script>
</head>
<%
    model.Users u = (model.Users) session.getAttribute("user");
%>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống Quản trị</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Danh mục sản phẩm</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/serial"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu nhập kho</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Quản lý Đánh giá</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <% if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;">
                <% } else { %>
                    <span>♙</span>
                <% } %>
                <span>Hồ sơ nhân viên</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
        </div>
    </aside>

    <div class="main">
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-4 w-1/3"></div>
            <div class="flex items-center gap-4">
                <div class="h-8 w-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-label-md ml-2 border border-outline-variant/50">
                    <span class="material-symbols-outlined text-on-primary-container">person</span>
                </div>
            </div>
        </header>

        <main class="flex-1 p-gutter bg-surface-container-lowest">
            <!-- Breadcrumbs -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Chuẩn bị đơn hàng #${order.orderCode}</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Gán số Serial cụ thể cho từng sản phẩm trong đơn hàng này để xuất kho.</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/outbound/list" class="px-4 py-2 bg-surface border border-outline-variant/50 rounded-lg hover:bg-surface-container-high transition-colors font-label-md text-label-md text-on-surface flex items-center gap-2">
                    <span class="material-symbols-outlined text-[20px]">arrow_back</span> Quay lại
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 text-red-800 text-sm font-medium">${error}</div>
            </c:if>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Cột thông tin đơn hàng -->
                <div class="col-span-1">
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="font-headline-md text-headline-md text-on-surface border-b border-outline-variant/30 pb-4 mb-4" style="font-size:18px;">Thông tin giao hàng</h3>
                        <dl class="space-y-4 text-body-sm">
                            <div><dt class="font-medium text-on-surface-variant">Mã đơn</dt><dd class="mt-1 font-semibold" style="color: var(--blue);">${order.orderCode}</dd></div>
                            <div><dt class="font-medium text-on-surface-variant">Trạng thái</dt>
                                <dd class="mt-1"><span style="background: var(--blue-soft); color: var(--blue); padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600;">${order.orderStatus}</span></dd>
                            </div>
                            <div><dt class="font-medium text-on-surface-variant">Người nhận</dt><dd class="mt-1 font-medium text-on-surface">${order.shippingReceiver}</dd></div>
                            <div><dt class="font-medium text-on-surface-variant">Số điện thoại</dt><dd class="mt-1 font-medium text-on-surface">${order.shippingPhone}</dd></div>
                            <div><dt class="font-medium text-on-surface-variant">Địa chỉ</dt><dd class="mt-1 text-on-surface leading-relaxed">${order.shippingAddress}</dd></div>
                            <div><dt class="font-medium text-on-surface-variant">Tổng tiền</dt><dd class="mt-1 font-semibold text-red-600"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</dd></div>
                        </dl>
                    </div>
                </div>

                <!-- Cột gán Serial -->
                <div class="col-span-1 lg:col-span-2">
                    <form action="${pageContext.request.contextPath}/staff/outbound/fulfill" method="POST" onsubmit="return validateForm(event)" class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <h3 class="font-headline-md text-headline-md text-on-surface border-b border-outline-variant/30 pb-4 mb-6" style="font-size:18px;">Danh sách sản phẩm cần lấy</h3>

                        <div class="space-y-6">
                            <c:forEach var="detail" items="${details}">
                                <div class="bg-surface-container-low border border-outline-variant/20 rounded-lg p-5">
                                    <div class="flex items-start gap-4 mb-4">
                                        <div class="h-14 w-14 flex-shrink-0 rounded-lg border border-outline-variant/30 bg-white overflow-hidden flex items-center justify-center">
                                            <c:choose>
                                                <c:when test="${not empty detail.thumbnail}">
                                                    <img src="${pageContext.request.contextPath}/${detail.thumbnail}" alt="" class="h-full w-full object-contain">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="material-symbols-outlined text-on-surface-variant">image</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="flex-1">
                                            <h4 class="font-semibold text-on-surface">${detail.productName}</h4>
                                            <p class="text-body-sm text-on-surface-variant mt-1">Phân loại: <span class="font-medium text-on-surface">${detail.variantName}</span> &nbsp;|&nbsp; SKU: <span class="font-medium text-on-surface">${detail.sku}</span></p>
                                        </div>
                                        <div class="text-right">
                                            <p class="text-body-sm text-on-surface-variant">Số lượng cần</p>
                                            <p class="font-headline-md text-headline-md" style="color: var(--blue);">${detail.quantity}</p>
                                        </div>
                                    </div>

                                    <div class="border-t border-outline-variant/20 pt-4 space-y-3">
                                        <p class="text-body-sm font-medium text-on-surface-variant">Chọn mã Serial Number cụ thể:</p>
                                        <c:choose>
                                            <c:when test="${availableSerialsMap[detail.variantId] == null || availableSerialsMap[detail.variantId].size() < detail.quantity}">
                                                <div style="background: var(--red-soft); color: var(--red); border: 1px solid #fecaca; padding: 10px 14px; border-radius: 8px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                                                    <span class="material-symbols-outlined">warning</span>
                                                    Kho không đủ hàng (${availableSerialsMap[detail.variantId] != null ? availableSerialsMap[detail.variantId].size() : 0} / ${detail.quantity}). Không thể xuất!
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="i" begin="1" end="${detail.quantity}">
                                                    <div class="flex items-center gap-3">
                                                        <span class="text-body-sm font-semibold text-on-surface-variant w-8">#${i}</span>
                                                        <select name="detail_${detail.orderDetailId}" required class="flex-1 py-2 px-3 bg-white border border-outline-variant/50 rounded-lg text-body-sm text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                                            <option value="">-- Chọn Serial Number --</option>
                                                            <c:forEach var="item" items="${availableSerialsMap[detail.variantId]}" varStatus="status">
                                                                <option value="${item.itemId}" ${status.count == i ? 'selected' : ''}>
                                                                    SN: ${item.serialNumber}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="mt-8 flex justify-end pt-4 border-t border-outline-variant/30">
                            <c:set var="canFulfill" value="true" />
                            <c:forEach var="detail" items="${details}">
                                <c:if test="${availableSerialsMap[detail.variantId] == null || availableSerialsMap[detail.variantId].size() < detail.quantity}">
                                    <c:set var="canFulfill" value="false" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${canFulfill}">
                                    <button type="submit" style="background: var(--blue); color: white; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; border: none; cursor: pointer;">
                                        <span class="material-symbols-outlined text-[20px]">task_alt</span> Xác nhận Xuất Kho
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" disabled style="background: #e5e7eb; color: #9ca3af; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; border: none; cursor: not-allowed;">
                                        <span class="material-symbols-outlined text-[20px]">block</span> Thiếu hàng để xuất
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>

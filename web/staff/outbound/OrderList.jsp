<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Danh sách đơn chờ xuất kho</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "primary": "#003ec7",
                        "on-primary": "#ffffff",
                        "on-surface": "#191c1e",
                        "on-surface-variant": "#434656",
                        "surface": "#f7f9fb",
                        "surface-container-low": "#f2f4f6",
                        "surface-container-lowest": "#ffffff",
                        "outline-variant": "#c3c5d9",
                        "primary-container": "#0052ff",
                        "on-primary-container": "#dfe3ff",
                        "primary-fixed": "#dde1ff",
                        "on-primary-fixed": "#001452",
                        "error": "#ba1a1a"
                    },
                    "fontFamily": {
                        "body-md": ["Inter"],
                        "body-sm": ["Inter"],
                        "label-md": ["Inter"],
                        "headline-lg": ["Space Grotesk"],
                        "headline-md": ["Space Grotesk"]
                    },
                    "fontSize": {
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
                    },
                    "spacing": {
                        "gutter": "24px"
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .icon-fill { font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>
<%
    model.Users u = (model.Users) session.getAttribute("user");
%>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="outbound"/>
    </jsp:include>

    <div class="main">
        <!-- Top Navigation Bar -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-4 w-1/3"></div>
            <div class="flex items-center gap-4">
                <div class="h-8 w-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-label-md ml-2 border border-outline-variant/50" style="cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                    <% if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" alt="Avatar" class="h-full w-full object-cover rounded-full">
                    <% } else { %>
                        <span class="material-symbols-outlined text-on-primary-container">person</span>
                    <% } %>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Đơn hàng chờ xuất kho</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Danh sách các đơn hàng đã được xác nhận (Đang xử lý), cần chuẩn bị hàng hóa & gán số Serial để xuất kho.</p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="${pageContext.request.contextPath}/staff/outbound/history" class="px-4 py-2 bg-surface border border-outline-variant/50 rounded-lg hover:bg-surface-container-high transition-colors font-label-md text-label-md text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">history</span> Lịch sử xuất kho
                    </a>
                </div>
            </div>

            <!-- Báo lỗi -->
            <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 text-red-800 text-sm font-medium">${error}</div>
            </c:if>

            <!-- Thanh tìm kiếm -->
            <div class="bg-surface border border-outline-variant/30 rounded-xl p-4 mb-6 shadow-sm">
                <form action="${pageContext.request.contextPath}/staff/outbound/list" method="get" class="flex flex-wrap items-center gap-3">
                    <div class="relative flex-1 min-w-[280px]">
                        <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">search</span>
                        <input type="text" name="search" value="${search}" placeholder="Tìm kiếm theo mã đơn, tên người nhận, SĐT..." class="w-full pl-10 pr-10 py-2 bg-surface-container-low border border-outline-variant/50 rounded-lg font-body-sm text-body-sm text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary placeholder-on-surface-variant/60 transition-all outline-none">
                        <c:if test="${not empty search}">
                            <a href="${pageContext.request.contextPath}/staff/outbound/list" class="absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-red-600 transition-colors flex items-center justify-center" title="Xóa tìm kiếm">
                                <span class="material-symbols-outlined text-[18px]">close</span>
                            </a>
                        </c:if>
                    </div>
                    <button type="submit" class="px-4 py-2 bg-primary hover:bg-[#002baf] text-on-primary font-label-md text-label-md rounded-lg flex items-center gap-1.5 transition-colors shadow-xs">
                        <span class="material-symbols-outlined text-[18px]">search</span> Tìm kiếm
                    </button>
                    <c:if test="${not empty search}">
                        <a href="${pageContext.request.contextPath}/staff/outbound/list" class="px-3 py-2 bg-surface border border-outline-variant/50 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-label-md text-label-md transition-colors">
                            Bỏ lọc
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Bảng danh sách đơn -->
            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm overflow-hidden mb-6">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-surface-container-low border-b border-outline-variant/30">
                            <tr>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Mã đơn hàng</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Người nhận</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">SĐT</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Tổng tiền</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Trạng thái</th>
                                <th class="px-6 py-4 text-right text-label-md font-label-md text-on-surface-variant">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant/20">
                            <c:forEach var="order" items="${orders}">
                                <tr class="hover:bg-surface-container-low/50 transition-colors">
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm font-semibold">
                                        <a href="${pageContext.request.contextPath}/staff/order/detail?orderId=${order.orderId}" class="text-[#003ec7] hover:underline">${order.orderCode}</a>
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm text-on-surface">${order.shippingReceiver}</td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm text-on-surface">${order.shippingPhone}</td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm font-semibold text-red-600">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm">
                                         <c:set var="isPickupOrder" value="${order.shippingMethod == 'STORE_PICKUP' || (not empty order.shippingAddress && fn:contains(order.shippingAddress, 'Nhận tại cửa hàng'))}" />
                                         <c:choose>
                                             <c:when test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending'}">
                                                 <span class="px-3 py-1 bg-amber-100 text-amber-800 rounded-md font-semibold text-[12px]">${isPickupOrder ? 'Xác nhận đơn' : 'Chờ xác nhận'}</span>
                                             </c:when>
                                             <c:when test="${order.orderStatus == 'processing'}">
                                                 <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-md font-semibold text-[12px]">${isPickupOrder ? 'Xác nhận đơn' : 'Đang xử lý'}</span>
                                             </c:when>
                                             <c:otherwise>
                                                 <span class="px-3 py-1 bg-gray-100 text-gray-800 rounded-md font-semibold text-[12px]">${order.orderStatus}</span>
                                             </c:otherwise>
                                         </c:choose>
                                    </td>
                                     <td class="whitespace-nowrap px-6 py-4 text-right">
                                         <c:choose>
                                             <c:when test="${!isPickupOrder && empty order.trackingNumber}">
                                                 <button type="button" onclick="createViettelPostWaybill(${order.orderId})"
                                                         class="bg-[#6d28d9] hover:bg-[#5b21b6] text-white px-3 py-1.5 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200">
                                                     <span class="material-symbols-outlined text-[18px]">local_shipping</span> Tạo mã vận đơn
                                                 </button>
                                             </c:when>
                                             <c:otherwise>
                                                 <a href="${pageContext.request.contextPath}/staff/outbound/fulfill?orderId=${order.orderId}"
                                                    class="bg-[#003ec7] hover:bg-[#002baf] text-white px-3 py-1.5 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200">
                                                     <span class="material-symbols-outlined text-[18px]">inventory_2</span> Chuẩn bị hàng
                                                 </a>
                                             </c:otherwise>
                                         </c:choose>
                                     </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="px-6 py-16 text-center text-on-surface-variant">
                                        <span class="material-symbols-outlined text-[48px]" style="color: #ccc;">inbox</span>
                                        <p class="mt-2 font-body-sm text-body-sm">
                                            <c:choose>
                                                <c:when test="${not empty search}">
                                                    Không tìm thấy đơn hàng nào phù hợp với từ khóa "<span class="font-semibold">${search}</span>".
                                                </c:when>
                                                <c:otherwise>
                                                    Hiện không có đơn hàng nào cần xuất kho.
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Footer -->
                <c:if test="${totalPages > 0}">
                    <div class="bg-surface px-6 py-4 border-t border-outline-variant/30 flex flex-wrap items-center justify-between gap-4">
                        <div class="text-body-sm font-body-sm text-on-surface-variant">
                            Hiển thị kết quả: <span class="font-semibold text-on-surface">${orders.size()}</span> / <span class="font-semibold text-on-surface">${totalRecords}</span> đơn hàng
                            <c:if test="${not empty search}">
                                (Từ khóa: "<span class="font-medium text-primary">${search}</span>")
                            </c:if>
                        </div>

                        <c:set var="searchParam" value="" />
                        <c:if test="${not empty search}">
                            <c:set var="searchParam" value="&search=${search}" />
                        </c:if>

                        <div class="flex items-center gap-2">
                            <!-- Prev Button -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}${searchParam}" class="px-3 py-1.5 border border-outline-variant/60 rounded-lg text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low transition-colors flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[16px]">chevron_left</span> Trước
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-3 py-1.5 border border-outline-variant/30 rounded-lg text-on-surface-variant/40 font-label-md text-label-md cursor-not-allowed flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[16px]">chevron_left</span> Trước
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Page Numbers -->
                            <div class="flex gap-1 items-center flex-wrap">
                                <c:choose>
                                    <c:when test="${totalPages <= 5}">
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="?page=${i}${searchParam}" class="w-8 h-8 flex items-center justify-center rounded-lg font-label-md text-label-md transition-colors ${currentPage == i ? 'bg-primary text-on-primary shadow-xs font-bold' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- 3 trang đầu -->
                                        <c:forEach begin="1" end="3" var="i">
                                            <a href="?page=${i}${searchParam}" class="w-8 h-8 flex items-center justify-center rounded-lg font-label-md text-label-md transition-colors ${currentPage == i ? 'bg-primary text-on-primary shadow-xs font-bold' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                        </c:forEach>

                                        <!-- Jump Page Dropdown -->
                                        <div class="relative flex items-center justify-center w-8 h-8">
                                            <button type="button" onclick="toggleJumpPageInput(this)" class="w-full h-full text-on-surface-variant font-label-md hover:text-primary transition-colors cursor-pointer flex items-center justify-center">...</button>
                                            <div class="jumpPageForm absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden bg-surface border border-outline-variant/50 p-2 rounded-lg shadow-lg z-10 flex gap-2">
                                                <input type="number" min="1" max="${totalPages}" placeholder="Trang" class="jumpPageInput w-20 px-2 py-1 border border-outline-variant rounded text-body-sm focus:border-primary outline-none" onkeydown="if(event.key === 'Enter') jumpToPage(this)">
                                                <button type="button" onclick="jumpToPage(this)" class="px-2 py-1 bg-primary text-on-primary rounded text-label-md whitespace-nowrap">Đi</button>
                                            </div>
                                        </div>

                                        <!-- 2 trang cuối -->
                                        <c:forEach begin="${totalPages - 1}" end="${totalPages}" var="i">
                                            <a href="?page=${i}${searchParam}" class="w-8 h-8 flex items-center justify-center rounded-lg font-label-md text-label-md transition-colors ${currentPage == i ? 'bg-primary text-on-primary shadow-xs font-bold' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Next Button -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}${searchParam}" class="px-3 py-1.5 border border-outline-variant/60 rounded-lg text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low transition-colors flex items-center gap-1">
                                        Sau <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-3 py-1.5 border border-outline-variant/30 rounded-lg text-on-surface-variant/40 font-label-md text-label-md cursor-not-allowed flex items-center gap-1">
                                        Sau <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<script>
    function toggleJumpPageInput(button) {
        const container = button.nextElementSibling;
        container.classList.toggle('hidden');
        if (!container.classList.contains('hidden')) {
            container.querySelector('.jumpPageInput').focus();
        }
    }

    function jumpToPage(element) {
        const container = element.closest('.jumpPageForm');
        const input = container.querySelector('.jumpPageInput');
        let page = parseInt(input.value);
        const maxPage = parseInt(input.getAttribute('max'));
        
        if (page && page >= 1 && page <= maxPage) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page);
            window.location.search = urlParams.toString();
        } else {
            alert('Vui lòng nhập trang từ 1 đến ' + maxPage);
        }
    }

    function createViettelPostWaybill(orderId) {
        if (!confirm("Bạn muốn tạo yêu cầu bưu gửi/vận đơn trên hệ thống Viettel Post cho đơn hàng này?")) return;
        
        fetch("${pageContext.request.contextPath}/api/shipping-tracking?orderId=" + orderId, {
            method: "POST"
        })
        .then(res => res.json())
        .then(data => {
            if (data && data.success) {
                alert("Tạo vận đơn Viettel Post thành công! Mã vận đơn: " + data.trackingNumber);
                location.reload();
            } else {
                alert(data.message || "Lỗi khi tạo vận đơn Viettel Post!");
            }
        })
        .catch(err => {
            console.error(err);
            alert("Lỗi kết nối bưu cục!");
        });
    }
</script>
</body>
</html>

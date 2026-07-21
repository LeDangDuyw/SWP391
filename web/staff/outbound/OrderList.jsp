<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
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
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Danh sách các đơn hàng đã thanh toán / chờ xử lý, cần chuẩn bị hàng hóa để giao cho khách.</p>
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

            <!-- Bảng danh sách đơn -->
            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm overflow-hidden">
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
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending'}">
                                                <span class="px-3 py-1 bg-amber-100 text-amber-800 rounded-md font-semibold text-[12px]">Chờ xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'processing' || order.orderStatus == 'processing'}">
                                                <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-md font-semibold text-[12px]">Đang xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-3 py-1 bg-gray-100 text-gray-800 rounded-md font-semibold text-[12px]">${order.orderStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-right">
                                        <a href="${pageContext.request.contextPath}/staff/outbound/fulfill?orderId=${order.orderId}"
                                           class="bg-[#003ec7] hover:bg-[#002baf] text-white px-3 py-1.5 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200">
                                            <span class="material-symbols-outlined text-[18px]">inventory_2</span> Chuẩn bị hàng
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="px-6 py-16 text-center text-on-surface-variant">
                                        <span class="material-symbols-outlined text-[48px]" style="color: #ccc;">inbox</span>
                                        <p class="mt-2 font-body-sm text-body-sm">Hiện không có đơn hàng nào cần xuất kho.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>

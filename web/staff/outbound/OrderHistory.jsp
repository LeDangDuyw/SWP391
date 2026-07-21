<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Lịch sử xuất kho</title>
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
</head>
<%
    model.Users u = (model.Users) session.getAttribute("user");
%>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống Quản trị</small></div>
        <nav>
<<<<<<< HEAD
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Quản lý kho</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu hỗ trợ</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Đánh giá sản phẩm</a>
=======
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Danh mục sản phẩm</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/serial"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu nhập kho</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Quản lý Đánh giá</a>
>>>>>>> origin/main3
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
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Lịch sử xuất kho</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Danh sách các đơn hàng đã được xuất kho thành công (Shipped / Delivered).</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/outbound/list" style="background: var(--blue); color: white; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                    <span class="material-symbols-outlined text-[20px]">list_alt</span> Đơn hàng chờ xuất
                </a>
            </div>

            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-surface-container-low border-b border-outline-variant/30">
                            <tr>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Mã đơn hàng</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Ngày xuất kho</th>
                                <th class="px-6 py-4 text-label-md font-label-md text-on-surface-variant">Người nhận</th>
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
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm text-on-surface">
                                        ${order.formattedCompletedAt}
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm text-on-surface">${order.shippingReceiver}</td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm font-semibold text-red-600">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-body-sm">
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'shipped'}">
                                                <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-md font-semibold text-[12px]">Đang vận chuyển</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'delivered' || order.orderStatus == 'Completed'}">
                                                <span class="px-3 py-1 bg-green-100 text-green-800 rounded-md font-semibold text-[12px]">Đã giao hàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-3 py-1 bg-red-100 text-red-800 rounded-md font-semibold text-[12px]">Đã huỷ đơn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="whitespace-nowrap px-6 py-4 text-right">
                                        <a href="${pageContext.request.contextPath}/staff/outbound/print?orderId=${order.orderId}" target="_blank"
                                           class="px-3 py-1.5 bg-surface border border-outline-variant/50 rounded-lg hover:bg-surface-container-low transition-colors font-label-md text-label-md text-on-surface inline-flex items-center gap-1.5" style="font-size:13px;">
                                            <span class="material-symbols-outlined text-[18px]">print</span> Phiếu xuất
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="px-6 py-16 text-center text-on-surface-variant">
                                        <span class="material-symbols-outlined text-[48px]" style="color: #ccc;">history</span>
                                        <p class="mt-2 font-body-sm text-body-sm">Chưa có lịch sử xuất kho nào.</p>
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

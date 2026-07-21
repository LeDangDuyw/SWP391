<%-- 
 * Name: OrderDetail.jsp
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Giao diện hiển thị chi tiết đơn hàng dành cho nhân viên (Staff Order Detail View)
 --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Chi tiết đơn hàng #${order.orderCode}</title>
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
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>System Controller</small></div>
        <nav>
<<<<<<< HEAD
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Quản lý kho</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu hỗ trợ</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Đánh giá sản phẩm</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
=======
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Product Catalog</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Category</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>IMEI</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Tickets</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Orders</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Outbound</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
>>>>>>> origin/main3
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <% if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid var(--blue);">
                <% } else { %>
                    <span>♙</span>
                <% } %>
                <span>Staff Profile</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

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
            <!-- Breadcrumbs -->
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/staff/order/list" class="text-body-sm text-on-surface-variant hover:text-primary flex items-center gap-1">
                    <span class="material-symbols-outlined text-[18px]">chevron_left</span> Quay lại danh sách đơn hàng
                </a>
            </div>

            <!-- Page Title -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-[#003ec7] mb-1">Staff - Order Management</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Chi tiết đơn hàng #${order.orderCode}</p>
                </div>
            </div>

            <!-- Detail Grid Layout -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Left Side: Order Action & Products (2 Cols) -->
                <div class="lg:col-span-2 flex flex-col gap-6">
                    <!-- Action Panel -->
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface">
                            <span class="material-symbols-outlined text-primary text-[20px]">task_alt</span> Xử lý đơn hàng
                        </h3>
                        <div class="flex flex-wrap items-center justify-between gap-4">
                            <div>
                                <span class="text-body-sm text-on-surface-variant mr-2">Trạng thái hiện tại:</span>
                                <c:choose>
                                    <c:when test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending'}">
                                        <span class="px-3 py-1.5 bg-amber-100 text-amber-800 rounded-md font-semibold text-[13px]">Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'processing'}">
                                        <span class="px-3 py-1.5 bg-blue-100 text-blue-800 rounded-md font-semibold text-[13px]">Đang xử lý</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'shipped'}">
                                        <span class="px-3 py-1.5 bg-indigo-100 text-indigo-800 rounded-md font-semibold text-[13px]">Đang giao hàng</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'delivered' || order.orderStatus == 'Completed'}">
                                        <span class="px-3 py-1.5 bg-green-100 text-green-800 rounded-md font-semibold text-[13px]">Đã giao hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1.5 bg-red-100 text-red-800 rounded-md font-semibold text-[13px]">Đã huỷ đơn</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="flex items-center gap-2 flex-wrap">
                                <!-- Status Pending: Confirm order, Cancel order -->
                                <c:if test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending'}">
                                    <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="status" value="processing">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button type="submit" class="bg-[#16a34a] hover:bg-[#15803d] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                            <span class="material-symbols-outlined text-[18px]">verified</span> Xác nhận đơn hàng
                                        </button>
                                    </form>
                                    
                                    <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="status" value="cancelled">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button type="submit" class="bg-[#ba1a1a] hover:bg-[#9a1616] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                            <span class="material-symbols-outlined text-[18px]">cancel</span> Hủy đơn hàng
                                        </button>
                                    </form>
                                </c:if>

                                <!-- Status Processing: Fulfill, Cancel order -->
                                <c:if test="${order.orderStatus == 'processing'}">
                                    <a href="${pageContext.request.contextPath}/staff/outbound/fulfill?orderId=${order.orderId}"
                                       class="bg-[#003ec7] hover:bg-[#002baf] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                        <span class="material-symbols-outlined text-[18px]">inventory_2</span> Chuẩn bị hàng & Xuất kho
                                    </a>
                                    
                                    <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="status" value="cancelled">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button type="submit" class="bg-[#ba1a1a] hover:bg-[#9a1616] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                            <span class="material-symbols-outlined text-[18px]">cancel</span> Hủy đơn hàng
                                        </button>
                                    </form>
                                </c:if>

                                <!-- Shipped -> Delivered/Cancel -->
                                <c:if test="${order.orderStatus == 'shipped'}">
                                    <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="status" value="delivered">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button type="submit" class="bg-[#16a34a] hover:bg-[#15803d] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                            <span class="material-symbols-outlined text-[18px]">check_circle</span> Đã giao thành công
                                        </button>
                                    </form>
                                    
                                    <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post" onsubmit="return confirm('Bạn có chắc muốn báo hủy/trả đơn hàng này?');" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <input type="hidden" name="status" value="cancelled">
                                        <input type="hidden" name="redirect" value="detail">
                                        <button type="submit" class="bg-[#ba1a1a] hover:bg-[#9a1616] text-white px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200 shadow-sm">
                                            <span class="material-symbols-outlined text-[18px]">cancel</span> Thất bại / Trả hàng
                                        </button>
                                    </form>
                                </c:if>

                                <!-- Shipped/Delivered -> Print Delivery Slip -->
                                <c:if test="${order.orderStatus == 'shipped' || order.orderStatus == 'delivered' || order.orderStatus == 'Completed'}">
                                    <a href="${pageContext.request.contextPath}/staff/outbound/print?orderId=${order.orderId}" target="_blank"
                                       class="bg-white border border-outline-variant text-on-surface hover:bg-surface-container-low px-4 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center gap-1.5 transition-colors duration-200">
                                        <span class="material-symbols-outlined text-[18px]">print</span> Xem & In phiếu xuất kho
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Products List -->
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface">
                            <span class="material-symbols-outlined text-primary text-[20px]">shopping_bag</span> Danh sách sản phẩm mua
                        </h3>
                        <div class="divide-y divide-outline-variant/20">
                            <c:set var="subtotal" value="0" />
                            <c:forEach items="${order.details}" var="item">
                                <c:set var="itemTotal" value="${item.quantity * item.unitPrice}" />
                                <c:set var="subtotal" value="${subtotal + itemTotal}" />
                                
                                <div class="flex items-center justify-between gap-4 py-4 first:pt-0 last:pb-0">
                                    <div class="flex items-center gap-4 flex-1 min-w-0">
                                        <img src="${pageContext.request.contextPath}/images/${item.thumbnail}" 
                                             onerror="this.src='https://placehold.co/80x60/f1f5f9/94a3b8?text=UniLap'" 
                                             alt="product" class="w-16 h-16 object-cover border border-outline-variant/30 rounded-lg bg-surface-container-low">
                                        <div class="min-w-0">
                                            <h4 class="text-body-sm font-semibold text-on-surface truncate" title="${item.productName}">${item.productName}</h4>
                                            <p class="text-[12px] text-on-surface-variant mt-1">Phân loại: ${item.variantName}</p>
                                            <p class="text-[11px] text-gray-400 mt-0.5">SKU: ${item.sku}</p>
                                        </div>
                                    </div>
                                    <div class="text-right flex-shrink-0">
                                        <span class="text-body-sm font-semibold text-on-surface">
                                            <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/> đ
                                        </span>
                                        <p class="text-[12px] text-on-surface-variant mt-1">Số lượng: ${item.quantity}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Order Logs (Nhật ký hoạt động) -->
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm mt-6">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface">
                            <span class="material-symbols-outlined text-primary text-[20px]">history</span> Nhật ký xử lý & Email
                        </h3>
                        <div class="flow-root">
                            <ul class="-mb-8">
                                <c:forEach var="log" items="${logs}" varStatus="status">
                                    <li>
                                        <div class="relative pb-8">
                                            <c:if test="${!status.last}">
                                                <span class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200" aria-hidden="true"></span>
                                            </c:if>
                                            <div class="relative flex space-x-3">
                                                <div>
                                                    <span class="h-8 w-8 rounded-full bg-blue-50 flex items-center justify-center ring-8 ring-white">
                                                        <span class="material-symbols-outlined text-[18px] text-[#003ec7]">info</span>
                                                    </span>
                                                </div>
                                                <div class="flex-1 min-w-0 pt-1.5 flex justify-between space-x-4">
                                                    <div>
                                                        <p class="text-xs text-on-surface font-semibold">${log.logMessage}</p>
                                                        <p class="text-[11px] text-on-surface-variant mt-0.5">Thực hiện bởi: <span class="font-medium text-primary">${log.actionBy}</span></p>
                                                    </div>
                                                    <div class="text-right text-[10px] whitespace-nowrap text-gray-400">
                                                        ${log.formattedCreatedAt}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty logs}">
                                    <li class="text-xs text-on-surface-variant italic text-center py-4">Chưa có nhật ký hoạt động nào ghi nhận.</li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Customer Info & Cost (1 Col) -->
                <div class="flex flex-col gap-6">
                    <!-- Customer Info -->
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface border-b border-outline-variant/20 pb-3">
                            <span class="material-symbols-outlined text-primary text-[20px]">person</span> Thông tin khách hàng
                        </h3>
                        <ul class="flex flex-col gap-3 text-body-sm">
                            <li>
                                <span class="text-on-surface-variant block text-[12px]">Họ và tên người nhận</span>
                                <strong class="text-on-surface text-[14px]">${order.shippingReceiver}</strong>
                            </li>
                            <li>
                                <span class="text-on-surface-variant block text-[12px]">Số điện thoại</span>
                                <strong class="text-on-surface text-[14px]">${order.shippingPhone}</strong>
                            </li>
                            <c:if test="${order.shippingMethod != 'STORE_PICKUP'}">
                            <li>
                                <span class="text-on-surface-variant block text-[12px]">Địa chỉ giao nhận</span>
                                <strong class="text-on-surface text-[14px]">${order.shippingAddress}</strong>
                            </li>
                            <li>
                                <span class="text-on-surface-variant block text-[12px]">Ghi chú giao hàng</span>
                                <strong class="text-on-surface text-[14px]">-</strong>
                            </li>
                            </c:if>
                        </ul>
                    </div>

                    <!-- Shipping & Waybill Info -->
                    <c:if test="${order.shippingMethod != 'STORE_PICKUP'}">
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface border-b border-outline-variant/20 pb-3">
                            <span class="material-symbols-outlined text-primary text-[20px]">local_shipping</span> Đối tác & Vận đơn
                        </h3>
                        <div class="text-body-sm flex flex-col gap-3">
                            <c:choose>
                                <c:when test="${not empty order.trackingNumber}">
                                    <div>
                                        <span class="text-on-surface-variant block text-[12px]">Đối tác vận chuyển</span>
                                        <strong class="text-on-surface text-[14px]">${order.shippingPartner}</strong>
                                    </div>
                                    <div>
                                        <span class="text-on-surface-variant block text-[12px]">Mã vận đơn (Viettel Post)</span>
                                        <strong class="text-primary text-[14px] font-mono">${order.trackingNumber}</strong>
                                    </div>
                                    
                                    <!-- Journey tracking timeline container -->
                                    <div class="mt-4 border-t border-outline-variant/20 pt-3">
                                        <span class="text-on-surface-variant block text-[12px] mb-2 font-semibold">Hành trình đơn hàng:</span>
                                        <div id="viettel-post-tracking-timeline" class="flex flex-col gap-3 pl-3 border-l-2 border-primary-container relative">
                                            <div class="text-xs text-on-surface-variant italic">Đang tải thông tin hành trình từ Viettel Post...</div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-2">
                                        <p class="text-on-surface-variant text-[13px] mb-3">Đơn hàng này chưa được tạo mã vận đơn Viettel Post.</p>
                                        <c:if test="${order.orderStatus == 'shipped' || order.orderStatus == 'delivered' || order.orderStatus == 'Completed' || order.orderStatus == 'Pending' || order.orderStatus == 'processing'}">
                                            <button id="btn-create-waybill" onclick="createViettelPostWaybill(${order.orderId})"
                                                    class="w-full bg-[#003ec7] hover:bg-[#002baf] text-white px-3 py-2 rounded-lg font-semibold text-[13px] inline-flex items-center justify-center gap-1.5 transition-colors duration-200">
                                                <span class="material-symbols-outlined text-[18px]">local_post_office</span> Tạo vận đơn Viettel Post
                                            </button>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    </c:if>


                    <!-- Invoice Summary Card -->
                    <c:if test="${not empty order.invoicePath}">
                        <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                            <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface border-b border-outline-variant/20 pb-3">
                                <span class="material-symbols-outlined text-primary text-[20px]">receipt_long</span> Hóa đơn VAT (PDF)
                            </h3>
                            <div class="text-body-sm flex flex-col gap-3">
                                <div>
                                    <span class="text-on-surface-variant block text-[12px]">Hồ sơ hóa đơn</span>
                                    <a href="${pageContext.request.contextPath}/${order.invoicePath}" target="_blank"
                                       class="text-primary hover:underline font-semibold flex items-center gap-1 mt-1 text-[14px]">
                                        <span class="material-symbols-outlined text-[18px]">download</span> Tải hóa đơn VAT
                                    </a>
                                </div>
                                <div>
                                    <span class="text-on-surface-variant block text-[12px]">Trạng thái gửi Email khách hàng</span>
                                    <c:choose>
                                        <c:when test="${order.invoiceEmailSent == 1}">
                                            <span class="inline-flex items-center gap-1 text-green-600 font-semibold mt-1">
                                                <span class="material-symbols-outlined text-[18px]">check_circle</span> Đã gửi thành công
                                            </span>
                                        </c:when>
                                        <c:when test="${order.invoiceEmailSent == 2}">
                                            <span class="inline-flex items-center gap-1 text-red-600 font-semibold mt-1">
                                                <span class="material-symbols-outlined text-[18px]">error</span> Gửi thất bại (Lỗi SMTP)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1 text-amber-600 font-semibold mt-1">
                                                <span class="material-symbols-outlined text-[18px]">pending</span> Chưa gửi
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Payment Summary -->
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-6 shadow-sm">
                        <h3 class="text-label-md font-bold mb-4 flex items-center gap-2 text-on-surface border-b border-outline-variant/20 pb-3">
                            <span class="material-symbols-outlined text-primary text-[20px]">credit_card</span> Thanh toán đơn hàng
                        </h3>
                        
                        <c:set var="discount" value="${subtotal + order.shippingFee - order.totalAmount}" />
                        <c:if var="isNeg" test="${discount < 0}">
                            <c:set var="discount" value="0" />
                        </c:if>

                        <div class="flex flex-col gap-3 text-body-sm">
                            <div class="flex justify-between">
                                <span class="text-on-surface-variant">Tổng tiền hàng:</span>
                                <span class="font-semibold"><fmt:formatNumber value="${subtotal}" pattern="#,###"/> đ</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-on-surface-variant">Phí vận chuyển:</span>
                                <span class="font-semibold"><fmt:formatNumber value="${order.shippingFee}" pattern="#,###"/> đ</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-on-surface-variant">Giảm giá voucher:</span>
                                <span class="font-semibold text-red-600">-<fmt:formatNumber value="${discount}" pattern="#,###"/> đ</span>
                            </div>
                            <div class="border-t border-outline-variant/20 pt-3 flex justify-between items-center mt-1">
                                <strong class="text-on-surface text-[15px]">Tổng thanh toán:</strong>
                                <strong class="text-red-600 text-[18px]"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const trackingNum = "${order.trackingNumber}";
        const status = "${order.orderStatus}";
        if (trackingNum && trackingNum.trim() !== "") {
            fetch("${pageContext.request.contextPath}/api/shipping-tracking?trackingNumber=" + encodeURIComponent(trackingNum) + "&status=" + encodeURIComponent(status))
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById("viettel-post-tracking-timeline");
                    if (data && data.length > 0) {
                        container.innerHTML = "";
                        data.forEach((item, index) => {
                            const isLast = (index === data.length - 1);
                            const dotColor = isLast ? "bg-primary" : "bg-gray-300";
                            const textColor = isLast ? "text-on-surface font-semibold" : "text-on-surface-variant";
                            
                            const el = document.createElement("div");
                            el.className = "relative mb-4 last:mb-0 pl-4";
                            el.innerHTML = `
                                <div class="absolute -left-[21px] top-1 w-3 h-3 rounded-full ${dotColor} border-2 border-white"></div>
                                <span class="text-[10px] text-gray-400 block">${item.time} - ${item.location}</span>
                                <p class="text-xs ${textColor} mt-0.5">${item.status}</p>
                            `;
                            container.appendChild(el);
                        });
                    } else {
                        container.innerHTML = "<div class='text-xs text-red-600'>Không tìm thấy thông tin hành trình.</div>";
                    }
                })
                .catch(err => {
                    console.error(err);
                    document.getElementById("viettel-post-tracking-timeline").innerHTML = "<div class='text-xs text-red-600'>Lỗi tải hành trình.</div>";
                });
        }
    });

    function createViettelPostWaybill(orderId) {
        if (!confirm("Bạn muốn tạo yêu cầu bưu gửi/vận đơn trên hệ thống Viettel Post?")) return;
        
        const btn = document.getElementById("btn-create-waybill");
        if (btn) btn.disabled = true;
        
        fetch("${pageContext.request.contextPath}/api/shipping-tracking?orderId=" + orderId, {
            method: "POST"
        })
        .then(res => res.json())
        .then(data => {
            if (data && data.success) {
                alert("Tạo vận đơn Viettel Post thành công! Mã vận đơn: " + data.trackingNumber);
                location.reload();
            } else {
                alert("Lỗi khi tạo vận đơn Viettel Post!");
                if (btn) btn.disabled = false;
            }
        })
        .catch(err => {
            console.error(err);
            alert("Lỗi kết nối bưu cục!");
            if (btn) btn.disabled = false;
        });
    }
</script>
</body>
</html>

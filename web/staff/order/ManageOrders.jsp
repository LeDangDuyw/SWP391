<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNILAP Staff – Quản lý đơn hàng</title>
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
                    "spacing": { "gutter": "24px" }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

        /* ── Stats Cards ── */
        .stat-card {
            background: #fff; border: 1px solid #e2e8f0; border-radius: 12px;
            padding: 20px; display: flex; align-items: center; gap: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,.05); transition: transform .15s, box-shadow .15s;
        }
        .stat-card:hover { transform: translateY(-1px); box-shadow: 0 4px 16px rgba(0,0,0,.08); }
        .stat-icon {
            width: 48px; height: 48px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .stat-icon .material-symbols-outlined { font-size: 22px; }
        .stat-icon.blue   { background: #eff6ff; color: #2563eb; }
        .stat-icon.amber  { background: #fffbeb; color: #d97706; }
        .stat-icon.violet { background: #f5f3ff; color: #7c3aed; }
        .stat-icon.green  { background: #f0fdf4; color: #16a34a; }
        .stat-value { font-size: 26px; font-weight: 700; color: #0f172a; line-height: 1; }
        .stat-label { font-size: 12px; color: #64748b; margin-top: 3px; font-weight: 500; }

        /* ── Table Card ── */
        .table-card {
            background: #fff; border: 1px solid #e2e8f0; border-radius: 14px;
            box-shadow: 0 1px 3px rgba(0,0,0,.05); overflow: hidden;
        }
        .table-toolbar {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 20px; border-bottom: 1px solid #e2e8f0; flex-wrap: wrap; gap: 12px;
        }

        /* Filter pill tabs */
        .filter-tabs { display: flex; gap: 4px; flex-wrap: wrap; }
        .filter-tab {
            padding: 7px 14px; border-radius: 20px; font-size: 12.5px; font-weight: 500;
            border: none; cursor: pointer; transition: all .15s; color: #64748b; background: transparent;
            display: flex; align-items: center; gap: 5px;
        }
        .filter-tab .cnt { font-size: 11px; background: rgba(0,0,0,.07); border-radius: 10px; padding: 1px 6px; }
        .filter-tab:hover { background: #f1f5f9; color: #0f172a; }
        .filter-tab.active { background: #003ec7; color: #fff; }
        .filter-tab.active .cnt { background: rgba(255,255,255,.25); }

        /* Search box */
        .search-box {
            display: flex; align-items: center; gap: 8px;
            border: 1px solid #e2e8f0; border-radius: 8px;
            padding: 7px 12px; background: #f8fafc;
        }
        .search-box input {
            border: none; outline: none; background: transparent;
            font-size: 13px; color: #0f172a; width: 200px;
        }
        .search-box .material-symbols-outlined { font-size: 17px; color: #94a3b8; }

        /* Table */
        .orders-table { width: 100%; border-collapse: collapse; }
        .orders-table thead tr { background: #f8fafc; }
        .orders-table th {
            padding: 11px 16px; text-align: left; font-size: 11.5px; font-weight: 600;
            color: #64748b; text-transform: uppercase; letter-spacing: .05em;
            border-bottom: 1px solid #e2e8f0; white-space: nowrap;
        }
        .orders-table td {
            padding: 14px 16px; font-size: 13px; color: #0f172a;
            border-bottom: 1px solid #e2e8f0; vertical-align: middle;
        }
        .orders-table tbody tr:last-child td { border-bottom: none; }
        .orders-table tbody tr { transition: background .12s; }
        .orders-table tbody tr:hover { background: #f8fafc; }

        .order-code-link {
            font-weight: 600; color: #003ec7; text-decoration: none; font-size: 13px;
            display: flex; align-items: center; gap: 4px;
        }
        .order-code-link:hover { text-decoration: underline; }

        /* Status badges */
        .badge {
            display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px;
            border-radius: 20px; font-size: 11.5px; font-weight: 600; white-space: nowrap;
        }
        .badge::before { content:''; width:5px; height:5px; border-radius:50%; background:currentColor; }
        .badge.pending    { background:#fffbeb; color:#b45309; }
        .badge.processing { background:#eff6ff; color:#1d4ed8; }
        .badge.shipped    { background:#f5f3ff; color:#6d28d9; }
        .badge.delivered  { background:#f0fdf4; color:#15803d; }
        .badge.cancelled  { background:#fff1f2; color:#be123c; }

        /* Action buttons */
        .btn-view {
            display: inline-flex; align-items: center; gap: 5px; padding: 6px 12px;
            border-radius: 8px; background: #003ec7; color: #fff;
            font-size: 12.5px; font-weight: 600; text-decoration: none; transition: background .15s;
        }
        .btn-view:hover { background: #002baf; }
        .btn-view .material-symbols-outlined { font-size: 15px; }
        .btn-cancel {
            display: inline-flex; align-items: center; gap: 5px; padding: 6px 12px;
            border-radius: 8px; background: #fff; color: #be123c;
            border: 1px solid #fecdd3; font-size: 12.5px; font-weight: 600; cursor: pointer; transition: all .15s;
        }
        .btn-cancel:hover { background: #fff1f2; border-color: #fda4af; }
        .btn-cancel .material-symbols-outlined { font-size: 15px; }

        .receiver-name { font-weight: 500; }
        .receiver-phone { font-size: 12px; color: #64748b; margin-top: 2px; }

        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state .material-symbols-outlined { font-size: 52px; color: #cbd5e1; }
        .empty-state p { color: #64748b; font-size: 14px; margin-top: 12px; }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>
<%
    model.Users u = (model.Users) session.getAttribute("user");
%>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">

    <!-- ════ SIDEBAR (đồng nhất với trang khác) ════ -->
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="order"/>
    </jsp:include>

    <!-- ════ MAIN ════ -->
    <div class="main">
        <!-- Topbar -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-2 text-sm text-on-surface-variant">
                <span>Staff</span>
                <span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>
                <span class="font-semibold text-on-surface">Quản lý đơn hàng</span>
            </div>
            <div class="flex items-center gap-4">
                <div class="h-8 w-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-label-md ml-2 border border-outline-variant/50"
                     style="cursor:pointer;overflow:hidden;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                    <% if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" alt="Avatar" class="h-full w-full object-cover rounded-full">
                    <% } else { %>
                        <span class="material-symbols-outlined text-on-primary-container">person</span>
                    <% } %>
                </div>
            </div>
        </header>

        <!-- Content -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">

            <!-- Page Title -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-[#003ec7] mb-1">Quản lý Đơn hàng</h2>
                    <p class="text-sm text-on-surface-variant">Quản lý toàn bộ đơn hàng – xác nhận, vận chuyển, hóa đơn &amp; giao hàng</p>
                </div>
            </div>

            <!-- Delivery Method Tabs -->
            <div class="mb-6 flex border-b border-outline-variant/30">
                <button id="delivery-tab-all" class="px-5 py-2.5 font-semibold text-sm border-b-2 border-primary text-primary transition-all duration-150 flex items-center gap-2" onclick="filterDelivery('all')">
                    <span class="material-symbols-outlined text-[18px]">all_inbox</span> Tất cả đơn hàng
                </button>
                <button id="delivery-tab-home" class="px-5 py-2.5 font-semibold text-sm border-b-2 border-transparent text-on-surface-variant hover:text-on-surface transition-all duration-150 flex items-center gap-2" onclick="filterDelivery('home')">
                    <span class="material-symbols-outlined text-[18px]">home</span> Giao hàng tận nơi (Nhận tại nhà)
                </button>
                <button id="delivery-tab-store" class="px-5 py-2.5 font-semibold text-sm border-b-2 border-transparent text-on-surface-variant hover:text-on-surface transition-all duration-150 flex items-center gap-2" onclick="filterDelivery('store')">
                    <span class="material-symbols-outlined text-[18px]">store</span> Nhận tại cửa hàng
                </button>
            </div>

            <!-- ── Stats count từ server ── -->
            <c:set var="cntAll"        value="0"/>
            <c:set var="cntPending"    value="0"/>
            <c:set var="cntProcessing" value="0"/>
            <c:set var="cntShipped"    value="0"/>
            <c:set var="cntDelivered"  value="0"/>
            <c:set var="cntCancelled"  value="0"/>
            <c:forEach var="o" items="${orders}">
                <c:set var="cntAll" value="${cntAll + 1}"/>
                <c:choose>
                    <c:when test="${o.orderStatus == 'Pending' || o.orderStatus == 'pending'}">
                        <c:set var="cntPending" value="${cntPending + 1}"/>
                    </c:when>
                    <c:when test="${o.orderStatus == 'processing'}">
                        <c:set var="cntProcessing" value="${cntProcessing + 1}"/>
                    </c:when>
                    <c:when test="${o.orderStatus == 'shipped'}">
                        <c:set var="cntShipped" value="${cntShipped + 1}"/>
                    </c:when>
                    <c:when test="${o.orderStatus == 'delivered' || o.orderStatus == 'Completed'}">
                        <c:set var="cntDelivered" value="${cntDelivered + 1}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="cntCancelled" value="${cntCancelled + 1}"/>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- ── Stats Cards ── -->
            <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px;">
                <div class="stat-card">
                    <div class="stat-icon blue"><span class="material-symbols-outlined">list_alt</span></div>
                    <div><div class="stat-value" id="stat-cnt-all">${cntAll}</div><div class="stat-label">Tổng đơn hàng</div></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber"><span class="material-symbols-outlined">hourglass_top</span></div>
                    <div><div class="stat-value" id="stat-cnt-pending">${cntPending}</div><div class="stat-label">Chờ xác nhận</div></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon violet"><span class="material-symbols-outlined">local_shipping</span></div>
                    <div><div class="stat-value" id="stat-cnt-shipped">${cntShipped}</div><div class="stat-label">Đang vận chuyển</div></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><span class="material-symbols-outlined">task_alt</span></div>
                    <div><div class="stat-value" id="stat-cnt-delivered">${cntDelivered}</div><div class="stat-label">Đã giao thành công</div></div>
                </div>
            </div>

            <!-- ── Table Card ── -->
            <div class="table-card">
                <div class="table-toolbar bg-surface-container-lowest flex flex-wrap gap-4 items-center justify-between">
                    <!-- Filter tabs -->
                    <div class="filter-tabs">
                        <button class="filter-tab active" onclick="filterStatus('all',this)">
                            Tất cả <span class="cnt" id="tab-cnt-all">${cntAll}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('pending',this)">
                            Chờ xác nhận <span class="cnt" id="tab-cnt-pending">${cntPending}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('processing',this)">
                            Đang xử lý <span class="cnt" id="tab-cnt-processing">${cntProcessing}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('shipped',this)">
                            Vận chuyển <span class="cnt" id="tab-cnt-shipped">${cntShipped}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('delivered',this)">
                            Đã giao <span class="cnt" id="tab-cnt-delivered">${cntDelivered}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('cancelled',this)">
                            Đã huỷ <span class="cnt" id="tab-cnt-cancelled">${cntCancelled}</span>
                        </button>
                    </div>
                    <!-- Date Range Filter & Search Box -->
                    <div class="flex items-center gap-3 flex-wrap">
                        <div class="flex items-center gap-2 border border-outline-variant/60 rounded-lg px-3 py-1.5 bg-[#f8fafc] text-xs">
                            <span class="material-symbols-outlined text-[16px] text-on-surface-variant">calendar_month</span>
                            <span class="text-on-surface-variant">Từ:</span>
                            <input type="date" id="filter-from-date" class="border-0 bg-transparent p-0 text-xs focus:ring-0 focus:outline-none w-28 text-on-surface font-semibold" onchange="applyFilters()">
                            <span class="text-on-surface-variant">Đến:</span>
                            <input type="date" id="filter-to-date" class="border-0 bg-transparent p-0 text-xs focus:ring-0 focus:outline-none w-28 text-on-surface font-semibold" onchange="applyFilters()">
                            <button onclick="clearDates()" title="Xoá bộ lọc thời gian" class="hover:text-red-500 text-on-surface-variant transition-colors flex items-center">
                                <span class="material-symbols-outlined text-[14px]">close</span>
                            </button>
                        </div>
                        <div class="search-box">
                            <span class="material-symbols-outlined">search</span>
                            <input type="text" id="search-input" placeholder="Tìm mã đơn, tên người nhận..."
                                   oninput="applyFilters()">
                        </div>
                    </div>
                </div>

                <div style="overflow-x:auto;">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>MÃ ĐƠN HÀNG</th>
                                <th>THỜI GIAN</th>
                                <th>NGƯỜI NHẬN</th>
                                <th>TỔNG TIỀN</th>
                                <th>TRẠNG THÁI</th>
                                <th class="tracking-col">MÃ VẬN ĐƠN</th>
                                <th style="text-align:right;">HÀNH ĐỘNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <c:set var="isPickup" value="${order.shippingMethod == 'STORE_PICKUP' || (not empty order.shippingAddress && fn:contains(order.shippingAddress, 'Nhận tại cửa hàng'))}" />
                                <tr class="order-row"
                                    data-status="${order.orderStatus}"
                                    data-search="${order.orderCode} ${order.shippingReceiver} ${order.shippingPhone}"
                                    data-date="${order.completedAt}"
                                    data-pickup="${isPickup}">
                                    <td>
                                        <a href="${pageContext.request.contextPath}/staff/order/detail?orderId=${order.orderId}"
                                           class="order-code-link">
                                            <span class="material-symbols-outlined" style="font-size:14px;color:#94a3b8;">tag</span>
                                            ${order.orderCode}
                                        </a>
                                    </td>
                                    <td class="whitespace-nowrap">
                                        <span class="text-body-sm font-medium text-on-surface-variant">
                                            ${order.formattedCompletedAt}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="receiver-name">${order.shippingReceiver}</div>
                                        <div class="receiver-phone">${order.shippingPhone}</div>
                                    </td>
                                    <td>
                                        <span style="font-weight:600;">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending'}">
                                                <span class="badge pending">Chờ xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'processing'}">
                                                <span class="badge processing">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'shipped'}">
                                                <span class="badge shipped">Đang vận chuyển</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'delivered' || order.orderStatus == 'Completed'}">
                                                <span class="badge delivered">${isPickup ? 'Đã giao hàng thành công' : 'Đã giao hàng'}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge cancelled">Đã huỷ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="tracking-col">
                                        <c:choose>
                                            <c:when test="${not empty order.trackingNumber}">
                                                <span style="font-size:12px;font-family:monospace;color:#6d28d9;font-weight:600;">
                                                    ${order.trackingNumber}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#94a3b8;font-size:12px;">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display:flex;align-items:center;gap:6px;justify-content:flex-end;">
                                            <a href="${pageContext.request.contextPath}/staff/order/detail?orderId=${order.orderId}"
                                               class="btn-view">
                                                <span class="material-symbols-outlined">open_in_new</span> Chi tiết
                                            </a>
                                            <c:if test="${order.orderStatus == 'Pending' || order.orderStatus == 'pending' || order.orderStatus == 'processing'}">
                                                <form action="${pageContext.request.contextPath}/staff/outbound/update-status" method="post"
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');"
                                                      style="display:inline;">
                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                    <input type="hidden" name="status" value="cancelled">
                                                    <input type="hidden" name="redirect" value="order-list">
                                                    <button type="submit" class="btn-cancel">
                                                        <span class="material-symbols-outlined">cancel</span> Huỷ
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <span class="material-symbols-outlined">inbox</span>
                                            <p>Hiện không có đơn hàng nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- ── Pagination Bar ── -->
                <div id="pagination-bar" class="flex flex-wrap items-center justify-between px-6 py-4 border-t border-outline-variant/30 bg-surface-container-lowest text-xs">
                    <div class="text-on-surface-variant font-medium">
                        Hiển thị <span id="pag-start" class="font-bold text-on-surface">0</span> - <span id="pag-end" class="font-bold text-on-surface">0</span> trong tổng số <span id="pag-total" class="font-bold text-on-surface">0</span> đơn hàng
                    </div>
                    <div class="flex items-center gap-1.5" id="pag-buttons">
                        <!-- Rendered by JS -->
                    </div>
                </div>
            </div><!-- /table-card -->

        </main>
    </div><!-- /main -->
</div><!-- /layout -->

<script>
    var currentStatus = 'all';
    var currentDelivery = 'all';
    var currentPage = 1;
    var pageSize = 15; // 15 đơn hàng / trang

    function filterStatus(status, btn) {
        currentStatus = status;
        currentPage = 1;
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        if (btn) btn.classList.add('active');
        applyFilters();
    }

    function filterDelivery(delivery) {
        currentDelivery = delivery;
        currentPage = 1;
        
        // Update tab styles
        const tabs = ['all', 'home', 'store'];
        tabs.forEach(t => {
            const btn = document.getElementById('delivery-tab-' + t);
            if (t === delivery) {
                btn.classList.add('border-primary', 'text-primary');
                btn.classList.remove('border-transparent', 'text-on-surface-variant');
            } else {
                btn.classList.remove('border-primary', 'text-primary');
                btn.classList.add('border-transparent', 'text-on-surface-variant');
            }
        });

        // Dynamic column hiding for tracking number
        const trackingHeaders = document.querySelectorAll('th.tracking-col');
        const trackingCells = document.querySelectorAll('td.tracking-col');
        if (delivery === 'store') {
            trackingHeaders.forEach(el => el.style.display = 'none');
            trackingCells.forEach(el => el.style.display = 'none');
        } else {
            trackingHeaders.forEach(el => el.style.display = '');
            trackingCells.forEach(el => el.style.display = '');
        }

        applyFilters();
    }

    function clearDates() {
        document.getElementById('filter-from-date').value = '';
        document.getElementById('filter-to-date').value = '';
        currentPage = 1;
        applyFilters();
    }

    function goToPage(p) {
        currentPage = p;
        applyFilters(true);
    }

    function applyFilters(isPageChange) {
        if (!isPageChange) {
            // Keep current page if valid, or reset via filter handler
        }

        var q = document.getElementById('search-input').value.toLowerCase().trim();
        var fromDateStr = document.getElementById('filter-from-date').value;
        var toDateStr = document.getElementById('filter-to-date').value;

        var fromDate = fromDateStr ? new Date(fromDateStr + 'T00:00:00') : null;
        var toDate = toDateStr ? new Date(toDateStr + 'T23:59:59') : null;

        var allRows = Array.from(document.querySelectorAll('.order-row'));

        // 1. Recalculate stats dynamically for selected delivery method, search, and date
        var methodPending = 0;
        var methodProcessing = 0;
        var methodShipped = 0;
        var methodDelivered = 0;
        var methodCancelled = 0;
        var methodTotal = 0;

        allRows.forEach(row => {
            var rowStatus = row.getAttribute('data-status').toLowerCase();
            var searchText = row.getAttribute('data-search').toLowerCase();
            var isPickup = row.getAttribute('data-pickup') === 'true';
            var rawDate = row.getAttribute('data-date');

            var deliveryMatch = currentDelivery === 'all'
                || (currentDelivery === 'store' && isPickup)
                || (currentDelivery === 'home' && !isPickup);

            var searchMatch = q === '' || searchText.includes(q);

            var dateMatch = true;
            if (rawDate && rawDate !== '') {
                var orderDate = new Date(rawDate);
                if (!isNaN(orderDate.getTime())) {
                    if (fromDate && orderDate < fromDate) dateMatch = false;
                    if (toDate && orderDate > toDate) dateMatch = false;
                }
            } else if (fromDate || toDate) {
                dateMatch = false;
            }

            if (deliveryMatch && searchMatch && dateMatch) {
                methodTotal++;
                if (rowStatus === 'pending') methodPending++;
                else if (rowStatus === 'processing') methodProcessing++;
                else if (rowStatus === 'shipped') methodShipped++;
                else if (rowStatus === 'delivered' || rowStatus === 'completed') methodDelivered++;
                else if (rowStatus === 'cancelled') methodCancelled++;
            }
        });

        // Update 4 Stat Cards
        var elStatAll = document.getElementById('stat-cnt-all');
        if (elStatAll) elStatAll.textContent = methodTotal;
        var elStatPending = document.getElementById('stat-cnt-pending');
        if (elStatPending) elStatPending.textContent = methodPending;
        var elStatShipped = document.getElementById('stat-cnt-shipped');
        if (elStatShipped) elStatShipped.textContent = methodShipped;
        var elStatDelivered = document.getElementById('stat-cnt-delivered');
        if (elStatDelivered) elStatDelivered.textContent = methodDelivered;

        // Update Filter Tab Count Badges
        var elTabAll = document.getElementById('tab-cnt-all');
        if (elTabAll) elTabAll.textContent = methodTotal;
        var elTabPending = document.getElementById('tab-cnt-pending');
        if (elTabPending) elTabPending.textContent = methodPending;
        var elTabProcessing = document.getElementById('tab-cnt-processing');
        if (elTabProcessing) elTabProcessing.textContent = methodProcessing;
        var elTabShipped = document.getElementById('tab-cnt-shipped');
        if (elTabShipped) elTabShipped.textContent = methodShipped;
        var elTabDelivered = document.getElementById('tab-cnt-delivered');
        if (elTabDelivered) elTabDelivered.textContent = methodDelivered;
        var elTabCancelled = document.getElementById('tab-cnt-cancelled');
        if (elTabCancelled) elTabCancelled.textContent = methodCancelled;

        // 2. Filter matching rows for selected status
        var matchingRows = [];
        allRows.forEach(row => {
            var rowStatus = row.getAttribute('data-status').toLowerCase();
            var searchText = row.getAttribute('data-search').toLowerCase();
            var isPickup = row.getAttribute('data-pickup') === 'true';
            var rawDate = row.getAttribute('data-date');

            var statusMatch = currentStatus === 'all'
                || (currentStatus === 'pending'    && rowStatus === 'pending')
                || (currentStatus === 'processing' && rowStatus === 'processing')
                || (currentStatus === 'shipped'    && rowStatus === 'shipped')
                || (currentStatus === 'delivered'  && (rowStatus === 'delivered' || rowStatus === 'completed'))
                || (currentStatus === 'cancelled'  && rowStatus === 'cancelled');

            var deliveryMatch = currentDelivery === 'all'
                || (currentDelivery === 'store' && isPickup)
                || (currentDelivery === 'home' && !isPickup);

            var searchMatch = q === '' || searchText.includes(q);

            var dateMatch = true;
            if (rawDate && rawDate !== '') {
                var orderDate = new Date(rawDate);
                if (!isNaN(orderDate.getTime())) {
                    if (fromDate && orderDate < fromDate) dateMatch = false;
                    if (toDate && orderDate > toDate) dateMatch = false;
                }
            } else if (fromDate || toDate) {
                dateMatch = false;
            }

            if (statusMatch && deliveryMatch && searchMatch && dateMatch) {
                matchingRows.push(row);
            }
            row.style.display = 'none'; // Hide all initially
        });

        // 3. Paginate matchingRows (15 / page)
        var totalRecords = matchingRows.length;
        var totalPages = Math.ceil(totalRecords / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        var startIndex = (currentPage - 1) * pageSize;
        var endIndex = Math.min(startIndex + pageSize, totalRecords);

        for (var i = startIndex; i < endIndex; i++) {
            matchingRows[i].style.display = '';
        }

        // 4. Update Pagination Control UI
        var pagStart = document.getElementById('pag-start');
        var pagEnd = document.getElementById('pag-end');
        var pagTotal = document.getElementById('pag-total');
        var pagButtons = document.getElementById('pag-buttons');

        if (pagStart) pagStart.textContent = totalRecords > 0 ? (startIndex + 1) : 0;
        if (pagEnd) pagEnd.textContent = endIndex;
        if (pagTotal) pagTotal.textContent = totalRecords;

        if (pagButtons) {
            pagButtons.innerHTML = '';

            // Previous Button
            var prevBtn = document.createElement('button');
            prevBtn.className = 'px-3 py-1.5 rounded-lg border border-outline-variant/40 text-xs font-semibold hover:bg-surface-container-low transition-colors ' + (currentPage === 1 ? 'opacity-40 cursor-not-allowed' : 'cursor-pointer');
            prevBtn.innerHTML = '<span class="material-symbols-outlined text-[14px] align-middle">chevron_left</span> Trước';
            if (currentPage > 1) {
                prevBtn.onclick = function() { goToPage(currentPage - 1); };
            }
            pagButtons.appendChild(prevBtn);

            // Page Number Buttons
            for (var p = 1; p <= totalPages; p++) {
                (function(pageNum) {
                    var btn = document.createElement('button');
                    if (pageNum === currentPage) {
                        btn.className = 'px-3 py-1.5 rounded-lg bg-[#003ec7] text-white text-xs font-bold shadow-sm';
                    } else {
                        btn.className = 'px-3 py-1.5 rounded-lg border border-outline-variant/40 text-xs font-semibold hover:bg-surface-container-low transition-colors cursor-pointer';
                    }
                    btn.textContent = pageNum;
                    btn.onclick = function() { goToPage(pageNum); };
                    pagButtons.appendChild(btn);
                })(p);
            }

            // Next Button
            var nextBtn = document.createElement('button');
            nextBtn.className = 'px-3 py-1.5 rounded-lg border border-outline-variant/40 text-xs font-semibold hover:bg-surface-container-low transition-colors ' + (currentPage === totalPages || totalRecords === 0 ? 'opacity-40 cursor-not-allowed' : 'cursor-pointer');
            nextBtn.innerHTML = 'Sau <span class="material-symbols-outlined text-[14px] align-middle">chevron_right</span>';
            if (currentPage < totalPages && totalRecords > 0) {
                nextBtn.onclick = function() { goToPage(currentPage + 1); };
            }
            pagButtons.appendChild(nextBtn);
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        var urlParams = new URLSearchParams(window.location.search);
        var statusParam = urlParams.get('status');
        if (statusParam) {
            var tab = document.querySelector(`.filter-tab[onclick*="${statusParam}"]`);
            if (tab) {
                filterStatus(statusParam, tab);
                return;
            }
        }
        applyFilters();
    });
</script>
</body>
</html>

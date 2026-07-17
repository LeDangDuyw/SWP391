<%-- 
 * Name: ManageOrders.jsp
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Giao diện quản lý đơn hàng dành cho nhân viên (Staff Order Management List)
 --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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


        /* ── Shipping Method Selector ── */
        .shipping-method-selector {
            display: flex;
            gap: 12px;
            background: #fff;
            padding: 6px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            width: fit-content;
            box-shadow: 0 1px 3px rgba(0,0,0,.05);
        }
        .method-tab {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            color: #64748b;
            background: transparent;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .method-tab:hover {
            color: #0f172a;
            background: #f1f5f9;
        }
        .method-tab.active {
            background: #003ec7;
            color: #fff;
        }
        .method-tab .badge-count {
            font-size: 11px;
            background: rgba(0, 0, 0, 0.08);
            color: #475569;
            padding: 2px 8px;
            border-radius: 20px;
            font-weight: 700;
            transition: all 0.2s ease;
        }
        .method-tab.active .badge-count {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
        }
        .method-tab .material-symbols-outlined {
            font-size: 20px;
        }

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
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống quản lý</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Product Catalog</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Category</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>IMEI</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Tickets</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Orders</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Outbound</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
        </nav>
        <div class="profile">
            <div style="cursor:pointer;display:flex;align-items:center;gap:8px;"
                 onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <% if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>"
                         alt="Avatar" style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:1px solid var(--blue);">
                <% } else { %>
                    <span>♙</span>
                <% } %>
                <span>Hồ sơ cá nhân</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
        </div>
    </aside>

    <!-- ════ MAIN ════ -->
    <div class="main">
        <!-- Topbar -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-2 text-sm text-on-surface-variant">
                <span>Nhân viên</span>
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
                    <h2 class="font-headline-lg text-headline-lg text-[#003ec7] mb-1">Quản lý đơn hàng</h2>
                    <p class="text-sm text-on-surface-variant">Quản lý toàn bộ đơn hàng – xác nhận, vận chuyển, hóa đơn &amp; giao hàng</p>
                </div>
            </div>

            <!-- ── Stats count từ server ── -->
            <c:set var="cntHomeAll"        value="0"/>
            <c:set var="cntHomePending"    value="0"/>
            <c:set var="cntHomeProcessing" value="0"/>
            <c:set var="cntHomeShipped"    value="0"/>
            <c:set var="cntHomeDelivered"  value="0"/>
            <c:set var="cntHomeCancelled"  value="0"/>

            <c:set var="cntStoreAll"        value="0"/>
            <c:set var="cntStorePending"    value="0"/>
            <c:set var="cntStoreProcessing" value="0"/>
            <c:set var="cntStoreShipped"    value="0"/>
            <c:set var="cntStoreDelivered"  value="0"/>
            <c:set var="cntStoreCancelled"  value="0"/>

            <c:forEach var="o" items="${orders}">
                <c:choose>
                    <c:when test="${o.shippingMethod == 'STORE_PICKUP'}">
                        <c:set var="cntStoreAll" value="${cntStoreAll + 1}"/>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'Pending' || o.orderStatus == 'pending'}">
                                <c:set var="cntStorePending" value="${cntStorePending + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'processing'}">
                                <c:set var="cntStoreProcessing" value="${cntStoreProcessing + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'shipped'}">
                                <c:set var="cntStoreShipped" value="${cntStoreShipped + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'delivered' || o.orderStatus == 'Completed'}">
                                <c:set var="cntStoreDelivered" value="${cntStoreDelivered + 1}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="cntStoreCancelled" value="${cntStoreCancelled + 1}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="cntHomeAll" value="${cntHomeAll + 1}"/>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'Pending' || o.orderStatus == 'pending'}">
                                <c:set var="cntHomePending" value="${cntHomePending + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'processing'}">
                                <c:set var="cntHomeProcessing" value="${cntHomeProcessing + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'shipped'}">
                                <c:set var="cntHomeShipped" value="${cntHomeShipped + 1}"/>
                            </c:when>
                            <c:when test="${o.orderStatus == 'delivered' || o.orderStatus == 'Completed'}">
                                <c:set var="cntHomeDelivered" value="${cntHomeDelivered + 1}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="cntHomeCancelled" value="${cntHomeCancelled + 1}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- ── Shipping Method Selector ── -->
            <div class="shipping-method-selector mb-6">
                <button class="method-tab active" onclick="switchMethod('HOME_DELIVERY', this)">
                    <span class="material-symbols-outlined">local_shipping</span>
                    <span>Giao tận nhà</span>
                    <span class="badge-count">${cntHomeAll}</span>
                </button>
                <button class="method-tab" onclick="switchMethod('STORE_PICKUP', this)">
                    <span class="material-symbols-outlined">storefront</span>
                    <span>Nhận tại cửa hàng</span>
                    <span class="badge-count">${cntStoreAll}</span>
                </button>
            </div>

            <!-- ── Table Card ── -->
            <div class="table-card">
                <div class="table-toolbar">
                    <!-- Filter tabs -->
                    <!-- Filter tabs for Home Delivery -->
                    <div class="filter-tabs" id="tabs-home">
                        <button class="filter-tab active" onclick="filterStatus('all',this)">
                            Tất cả <span class="cnt">${cntHomeAll}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('pending',this)">
                            Chờ xác nhận <span class="cnt">${cntHomePending}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('processing',this)">
                            Đang xử lý <span class="cnt">${cntHomeProcessing}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('shipped',this)">
                            Vận chuyển <span class="cnt">${cntHomeShipped}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('delivered',this)">
                            Đã giao <span class="cnt">${cntHomeDelivered}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('cancelled',this)">
                            Đã huỷ <span class="cnt">${cntHomeCancelled}</span>
                        </button>
                    </div>

                    <!-- Filter tabs for Store Pickup -->
                    <div class="filter-tabs" id="tabs-store" style="display: none;">
                        <button class="filter-tab active" onclick="filterStatus('all',this)">
                            Tất cả <span class="cnt">${cntStoreAll}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('pending',this)">
                            Chờ xác nhận <span class="cnt">${cntStorePending}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('processing',this)">
                            Đang xử lý <span class="cnt">${cntStoreProcessing}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('shipped',this)">
                            Vận chuyển <span class="cnt">${cntStoreShipped}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('delivered',this)">
                            Đã giao <span class="cnt">${cntStoreDelivered}</span>
                        </button>
                        <button class="filter-tab" onclick="filterStatus('cancelled',this)">
                            Đã huỷ <span class="cnt">${cntStoreCancelled}</span>
                        </button>
                    </div>
                    <!-- Date Filters & Search -->
                    <div class="flex items-center gap-2 flex-wrap">
                        <!-- Date range presets -->
                        <select id="date-filter-preset" onchange="handleDatePresetChange()" class="text-[13px] border border-gray-200 rounded-lg px-3 py-1.5 bg-white text-gray-700 font-semibold" style="outline:none;">
                            <option value="all">Tất cả thời gian</option>
                            <option value="today">Hôm nay</option>
                            <option value="yesterday">Hôm qua</option>
                            <option value="7days">7 ngày gần đây</option>
                            <option value="this-month">Tháng này</option>
                            <option value="custom">Tùy chọn...</option>
                        </select>
                        
                        <!-- Custom date picker container -->
                        <div id="custom-date-inputs" class="flex items-center gap-1.5" style="display: none;">
                            <input type="date" id="date-from" onchange="applyFilters()" class="text-[13px] border border-gray-200 rounded-lg px-2 py-1 bg-white text-gray-700" style="outline:none;">
                            <span class="text-[12px] text-gray-500">đến</span>
                            <input type="date" id="date-to" onchange="applyFilters()" class="text-[13px] border border-gray-200 rounded-lg px-2 py-1 bg-white text-gray-700" style="outline:none;">
                        </div>

                        <!-- Search -->
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
                                <th>THỜI GIAN ĐẶT</th>
                                <th>NGƯỜI NHẬN</th>
                                <th>TỔNG TIỀN</th>
                                <th>TRẠNG THÁI</th>
                                <th class="tracking-column">MÃ VẬN ĐƠN</th>
                                <th style="text-align:right;">HÀNH ĐỘNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr class="order-row"
                                    data-status="${order.orderStatus}"
                                    data-method="${order.shippingMethod}"
                                    data-created="${order.createdAt}"
                                    data-search="${order.orderCode} ${order.shippingReceiver} ${order.shippingPhone}">
                                    <td>
                                        <a href="${pageContext.request.contextPath}/staff/order/detail?orderId=${order.orderId}"
                                           class="order-code-link">
                                            <span class="material-symbols-outlined" style="font-size:14px;color:#94a3b8;">tag</span>
                                            ${order.orderCode}
                                        </a>
                                    </td>
                                    <td>
                                        <div style="font-size: 13px; color: #475569; font-weight: 500;">
                                            ${order.formattedCreatedAt}
                                        </div>
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
                                                <span class="badge delivered">Đã giao hàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge cancelled">Đã huỷ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="tracking-column">
                                         <c:choose>
                                             <c:when test="${order.shippingMethod == 'STORE_PICKUP'}">
                                                 <span class="badge" style="background-color: #f1f5f9; color: #64748b; font-size: 11px; font-weight: 600; padding: 2px 6px; border-radius: 4px;">
                                                     Tại cửa hàng
                                                 </span>
                                             </c:when>
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

                            <!-- Dynamic empty row shown when filter has 0 results -->
                            <tr id="empty-row" style="display: none;">
                                <td colspan="7" class="empty-state-cell">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">inbox</span>
                                        <p>Không có đơn hàng nào phù hợp với bộ lọc hiện tại.</p>
                                    </div>
                                </td>
                            </tr>

                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="7" class="empty-state-cell">
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
            </div><!-- /table-card -->

        </main>
    </div><!-- /main -->
</div><!-- /layout -->

<script>
    var currentStatus = 'all';
    var currentMethod = 'HOME_DELIVERY';

    function switchMethod(method, btn) {
        currentMethod = method;
        document.querySelectorAll('.method-tab').forEach(t => t.classList.remove('active'));
        if (btn) btn.classList.add('active');

        // Show/hide tracking column and update empty state colspan
        var trackingCols = document.querySelectorAll('.tracking-column');
        var emptyStateCells = document.querySelectorAll('.empty-state-cell');
        if (currentMethod === 'STORE_PICKUP') {
            trackingCols.forEach(col => col.style.display = 'none');
            emptyStateCells.forEach(cell => cell.setAttribute('colspan', '6'));
        } else {
            trackingCols.forEach(col => col.style.display = '');
            emptyStateCells.forEach(cell => cell.setAttribute('colspan', '7'));
        }

        // Show/hide sub-status tabs
        if (currentMethod === 'HOME_DELIVERY') {
            document.getElementById('tabs-home').style.display = 'flex';
            document.getElementById('tabs-store').style.display = 'none';
            // Default to 'all' of the newly active method
            filterStatus('all', document.querySelector('#tabs-home .filter-tab:first-child'));
        } else {
            document.getElementById('tabs-home').style.display = 'none';
            document.getElementById('tabs-store').style.display = 'flex';
            filterStatus('all', document.querySelector('#tabs-store .filter-tab:first-child'));
        }
    }

    function filterStatus(status, btn) {
        currentStatus = status;
        
        // Find inside current active tab list
        var activeTabsId = currentMethod === 'HOME_DELIVERY' ? 'tabs-home' : 'tabs-store';
        document.querySelectorAll('#' + activeTabsId + ' .filter-tab').forEach(t => t.classList.remove('active'));
        if (btn) btn.classList.add('active');
        
        applyFilters();
    }

    function handleDatePresetChange() {
        var preset = document.getElementById('date-filter-preset').value;
        var customDiv = document.getElementById('custom-date-inputs');
        if (preset === 'custom') {
            customDiv.style.display = 'flex';
        } else {
            customDiv.style.display = 'none';
            // Clear inputs when not using custom
            document.getElementById('date-from').value = '';
            document.getElementById('date-to').value = '';
        }
        applyFilters();
    }

    function applyFilters() {
        var q = document.getElementById('search-input').value.toLowerCase().trim();
        var preset = document.getElementById('date-filter-preset').value;
        var dateFromVal = document.getElementById('date-from').value;
        var dateToVal = document.getElementById('date-to').value;
        
        var now = new Date();
        var todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        var yesterdayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
        var sevenDaysAgoStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 7);
        var thisMonthStart = new Date(now.getFullYear(), now.getMonth(), 1);
        
        var visibleCount = 0;

        document.querySelectorAll('.order-row').forEach(row => {
            var rowStatus = row.getAttribute('data-status').toLowerCase();
            var rowMethod = row.getAttribute('data-method');
            var searchText = row.getAttribute('data-search').toLowerCase();
            var createdStr = row.getAttribute('data-created'); // formats as YYYY-MM-DDTHH:MM:SS
            
            var methodMatch = (rowMethod === currentMethod);

            var statusMatch = currentStatus === 'all'
                || (currentStatus === 'pending'    && rowStatus === 'pending')
                || (currentStatus === 'processing' && rowStatus === 'processing')
                || (currentStatus === 'shipped'    && rowStatus === 'shipped')
                || (currentStatus === 'delivered'  && (rowStatus === 'delivered' || rowStatus === 'completed'))
                || (currentStatus === 'cancelled'  && rowStatus === 'cancelled');

            var searchMatch = q === '' || searchText.includes(q);

            var dateMatch = true;
            if (createdStr && createdStr.trim() !== "" && createdStr !== "null") {
                var orderDate = new Date(createdStr);
                
                if (preset === 'today') {
                    dateMatch = (orderDate >= todayStart);
                } else if (preset === 'yesterday') {
                    dateMatch = (orderDate >= yesterdayStart && orderDate < todayStart);
                } else if (preset === '7days') {
                    dateMatch = (orderDate >= sevenDaysAgoStart);
                } else if (preset === 'this-month') {
                    dateMatch = (orderDate >= thisMonthStart);
                } else if (preset === 'custom') {
                    if (dateFromVal) {
                        var fromDate = new Date(dateFromVal + "T00:00:00");
                        dateMatch = dateMatch && (orderDate >= fromDate);
                    }
                    if (dateToVal) {
                        var toDate = new Date(dateToVal + "T23:59:59");
                        dateMatch = dateMatch && (orderDate <= toDate);
                    }
                }
            }

            if (methodMatch && statusMatch && searchMatch && dateMatch) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show/hide empty state row if visibleCount == 0
        var emptyRow = document.getElementById('empty-row');
        if (emptyRow) {
            emptyRow.style.display = (visibleCount === 0) ? '' : 'none';
        }
    }

    // Initialize display when page loads
    window.addEventListener('DOMContentLoaded', (event) => {
        applyFilters();
    });
</script>
</body>
</html>

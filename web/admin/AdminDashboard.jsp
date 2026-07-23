<%-- 
    Page: AdminDashboard.jsp
    Mo ta: Trang giao diện (View) chính của Admin Dashboard.
    
    Created: 2026-06-03
    Updated: 2026-07-21
    Version: v1.0
    
    @author DuyLD
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Bảng Điều Khiển & Thống Kê</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
            *, *::before, *::after {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:Inter,Arial,sans-serif;
            }
            body {
                background:#f0f2f5;
                color:#171a22;
            }
            a    {
                text-decoration:none;
                color:inherit;
            }
            .layout {
                display:flex;
                min-height:100vh;
            }

            /* ══ SIDEBAR (synced with other admin pages) ══ */
            .sidebar {
                width: 280px;
                background: #eef2f7;
                border-right: 1px solid #e1e6ef;
                padding: 28px 16px;
                display: flex;
                flex-direction: column;
                position: sticky;
                top: 0;
                height: 100vh;
            }
            .sidebar .brand {
                margin: 6px 10px 44px;
                display: grid;
                gap: 6px;
            }
            .sidebar .brand span {
                color: #0b39d1;
                font-size: 24px;
                font-weight: 800;
                letter-spacing: .05em;
                display: block;
            }
            .sidebar .brand small {
                color: #343a46;
                font-size: 14px;
                display: block;
            }
            .sidebar nav {
                display: grid;
                gap: 10px;
            }
            .sidebar nav a {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 14px 14px;
                border-radius: 10px;
                color: #242a38;
                font-weight: 600;
                text-decoration: none;
                font-size: 14px;
            }
            .sidebar nav a .nav-icon {
                min-width: 20px;
                color: #1f2937;
                font-size: 16px;
            }
            .sidebar nav a:hover {
                background: #f3f4f6;
            }
            .sidebar nav a.active {
                background: #d8e8ff;
                color: #0b39d1;
            }
            .sidebar .profile {
                margin-top: auto;
                border-top: 1px solid #d4dae6;
                padding: 18px 10px 0;
                display: grid;
                gap: 12px;
                font-weight: 700;
            }
            .sidebar .profile-link {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                color: #242a38;
            }
            .sidebar .logout-link {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #ef4444 !important;
                font-size: 13px;
                font-weight: 600;
                padding: 8px 12px;
                border-radius: 6px;
                background: #fef2f2;
                border: 1px solid #fecaca;
                cursor: pointer;
                transition: all 0.2s ease;
                width: fit-content;
            }
            .sidebar .logout-link:hover {
                background: #fee2e2;
                border-color: #fca5a5;
                color: #dc2626 !important;
            }

            /* Sidebar dropdown style */
            .sidebar-dropdown {
                display: flex;
                flex-direction: column;
            }
            .sidebar-dropdown-container {
                display: none;
                flex-direction: column;
                gap: 4px;
                margin-top: 4px;
            }
            .sidebar nav .sidebar-dropdown-container a {
                padding: 8px 14px 8px 30px !important;
                font-size: 13px !important;
                font-weight: 500 !important;
            }

            /* ══ MAIN AREA ══ */
            .main {
                flex:1;
                display:flex;
                flex-direction:column;
                overflow:hidden;
                min-width:0;
            }
            .topbar {
                background:#fff;
                border-bottom:1px solid #e5e7eb;
                padding:12px 28px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                position:sticky;
                top:0;
                z-index:10;
            }
            .topbar-left {
                display:flex;
                align-items:center;
                gap:12px;
            }
            .topbar-title {
                font-size:16px;
                font-weight:700;
                color:#111;
            }
            .topbar-date  {
                font-size:12px;
                color:#9ca3af;
            }
            .topbar-right {
                display:flex;
                align-items:center;
                gap:12px;
            }
            .icon-btn {
                background:none;
                border:1px solid #e5e7eb;
                cursor:pointer;
                width:34px;
                height:34px;
                border-radius:8px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#6b7280;
                font-size:14px;
                transition:.15s;
            }
            .icon-btn:hover {
                background:#f3f4f6;
            }
            .status-pill {
                display:inline-flex;
                align-items:center;
                gap:5px;
                padding:4px 10px;
                border-radius:20px;
                font-size:11px;
                font-weight:600;
                background:#dcfce7;
                color:#166534;
            }
            .status-dot {
                width:6px;
                height:6px;
                border-radius:50%;
                background:#16a34a;
                display:inline-block;
            }

            .content {
                padding:24px 28px;
                overflow-y:auto;
                flex:1;
            }
            .page-header {
                margin-bottom:24px;
            }
            .page-title  {
                font-size:22px;
                font-weight:700;
                color:#111;
            }
            .page-sub    {
                font-size:13px;
                color:#6b7280;
                margin-top:4px;
            }

            /* ══ KPI CARDS ROW 1 ══ */
            .kpi-row {
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:16px;
                margin-bottom:20px;
            }
            .kpi-card {
                background:#fff;
                border-radius:12px;
                padding:20px 22px;
                box-shadow:0 1px 3px rgba(0,0,0,.06);
                position:relative;
                overflow:hidden;
            }
            .kpi-card::before {
                content:'';
                position:absolute;
                top:0;
                left:0;
                right:0;
                height:3px;
                border-radius:12px 12px 0 0;
            }
            .kpi-card.c-blue::before   {
                background:#3b82f6;
            }
            .kpi-card.c-green::before  {
                background:#10b981;
            }
            .kpi-card.c-amber::before  {
                background:#f59e0b;
            }
            .kpi-card.c-red::before    {
                background:#ef4444;
            }
            .kpi-card.c-indigo::before {
                background:#6366f1;
            }
            .kpi-card.c-purple::before {
                background:#8b5cf6;
            }

            .kpi-card.revenue-hero {
                background:linear-gradient(135deg,#1e3a8a,#2563eb);
                color:#fff;
            }
            .kpi-card.revenue-hero::before {
                display:none;
            }

            .kpi-top    {
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                margin-bottom:12px;
            }
            .kpi-icon   {
                width:42px;
                height:42px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:20px;
            }
            .kpi-icon.bg-blue   {
                background:#eff6ff;
            }
            .kpi-icon.bg-green  {
                background:#ecfdf5;
            }
            .kpi-icon.bg-amber  {
                background:#fffbeb;
            }
            .kpi-icon.bg-red    {
                background:#fef2f2;
            }
            .kpi-icon.bg-indigo {
                background:#eef2ff;
            }
            .kpi-icon.bg-purple {
                background:#f5f3ff;
            }
            .kpi-icon.bg-white  {
                background:rgba(255,255,255,.2);
            }
            .kpi-badge {
                font-size:11px;
                font-weight:600;
                padding:3px 7px;
                border-radius:6px;
            }
            .kpi-badge.up   {
                background:#dcfce7;
                color:#166534;
            }
            .kpi-badge.down {
                background:#fee2e2;
                color:#991b1b;
            }
            .kpi-badge.mock {
                background:#fef9c3;
                color:#854d0e;
            }

            .kpi-label {
                font-size:12px;
                font-weight:500;
                color:#6b7280;
                margin-bottom:4px;
            }
            .kpi-value {
                font-size:26px;
                font-weight:700;
                color:#111;
                line-height:1.1;
            }
            .kpi-sub   {
                font-size:11px;
                color:#9ca3af;
                margin-top:4px;
            }
            .revenue-hero .kpi-label {
                color:#bfdbfe;
            }
            .revenue-hero .kpi-value {
                color:#fff;
                font-size:22px;
            }
            .revenue-hero .kpi-sub   {
                color:#93c5fd;
            }
            .revenue-hero .kpi-badge.up {
                background:rgba(255,255,255,.2);
                color:#fff;
            }

            /* ══ SECTION HEADERS ══ */
            .section-hd {
                display:flex;
                align-items:center;
                gap:8px;
                font-size:14px;
                font-weight:700;
                color:#374151;
                margin:24px 0 14px;
            }
            .section-hd .dot {
                width:8px;
                height:8px;
                border-radius:50%;
                background:#3b82f6;
            }
            .section-hd::after {
                content:'';
                flex:1;
                height:1px;
                background:#e5e7eb;
            }

            /* ══ CHART CARDS ══ */
            .chart-card {
                background:#fff;
                border-radius:12px;
                box-shadow:0 1px 3px rgba(0,0,0,.06);
                padding:20px 22px;
            }
            .chart-card-title {
                font-size:14px;
                font-weight:700;
                color:#111;
                margin-bottom:16px;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .chart-card-title .mock-tag {
                font-size:10px;
                font-weight:600;
                padding:2px 6px;
                background:#fef9c3;
                color:#854d0e;
                border-radius:4px;
            }

            /* ══ GRID LAYOUTS ══ */
            .grid-3 {
                display:grid;
                grid-template-columns:2fr 1fr 1fr;
                gap:16px;
                margin-bottom:20px;
            }
            .grid-2 {
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
                margin-bottom:20px;
            }
            .grid-4 {
                display:grid;
                grid-template-columns:1fr 1fr 1fr 1fr;
                gap:16px;
                margin-bottom:20px;
            }
            .grid-3b {
                display:grid;
                grid-template-columns:1fr 1fr 1fr;
                gap:16px;
                margin-bottom:20px;
            }

            /* ══ TABLE STYLES ══ */
            .data-table {
                width:100%;
                border-collapse:collapse;
            }
            .data-table th {
                padding:10px 14px;
                text-align:left;
                font-size:11px;
                font-weight:600;
                color:#6b7280;
                text-transform:uppercase;
                letter-spacing:.05em;
                border-bottom:1px solid #f3f4f6;
                background:#fafafa;
            }
            .data-table td {
                padding:10px 14px;
                font-size:13px;
                border-bottom:1px solid #f9fafb;
            }
            .data-table tr:last-child td {
                border-bottom:none;
            }
            .data-table tbody tr:hover   {
                background:#fafafa;
            }

            /* Rank badges */
            .rank {
                display:inline-flex;
                align-items:center;
                justify-content:center;
                width:22px;
                height:22px;
                border-radius:50%;
                font-size:11px;
                font-weight:700;
                background:#f3f4f6;
                color:#6b7280;
            }
            .rank.r1 {
                background:#fef9c3;
                color:#a16207;
            }
            .rank.r2 {
                background:#f1f5f9;
                color:#475569;
            }
            .rank.r3 {
                background:#fef3c7;
                color:#b45309;
            }

            /* Status badges */
            .badge {
                display:inline-block;
                padding:2px 8px;
                border-radius:20px;
                font-size:11px;
                font-weight:600;
            }
            .badge-pending    {
                background:#dbeafe;
                color:#1d4ed8;
            }
            .badge-processing {
                background:#fef9c3;
                color:#854d0e;
            }
            .badge-shipping   {
                background:#f3e8ff;
                color:#7e22ce;
            }
            .badge-completed  {
                background:#dcfce7;
                color:#166534;
            }
            .badge-cancelled  {
                background:#fee2e2;
                color:#991b1b;
            }

            /* Stock quantity indicator */
            .qty-pill {
                display:inline-block;
                padding:2px 8px;
                border-radius:6px;
                font-size:12px;
                font-weight:600;
            }
            .qty-critical {
                background:#fee2e2;
                color:#991b1b;
            }
            .qty-low      {
                background:#fef9c3;
                color:#854d0e;
            }
            .qty-ok       {
                background:#dcfce7;
                color:#166534;
            }

            /* Activity feed */
            .activity-feed {
                display:grid;
                gap:0;
            }
            .activity-item {
                display:flex;
                align-items:flex-start;
                gap:12px;
                padding:11px 0;
                border-bottom:1px solid #f3f4f6;
            }
            .activity-item:last-child {
                border-bottom:none;
            }
            .activity-icon {
                font-size:16px;
                margin-top:1px;
                min-width:20px;
            }
            .activity-text {
                font-size:13px;
                color:#374151;
                flex:1;
                line-height:1.4;
            }
            .activity-time {
                font-size:11px;
                color:#9ca3af;
                white-space:nowrap;
            }

            /* No data */
            .no-data {
                padding:30px 20px;
                text-align:center;
                color:#9ca3af;
                font-size:13px;
            }

            /* ══ RESPONSIVE ══ */
            @media(max-width:1300px) {
                .grid-3  {
                    grid-template-columns:1fr 1fr;
                }
                .grid-4  {
                    grid-template-columns:repeat(2,1fr);
                }
                .grid-3b {
                    grid-template-columns:1fr 1fr;
                }
            }
            @media(max-width:1100px) {
                .kpi-row {
                    grid-template-columns:repeat(2,1fr);
                }
                .grid-2  {
                    grid-template-columns:1fr;
                }
                .sidebar {
                    width:220px;
                }
            }
            @media(max-width:760px) {
                .layout  {
                    display:block;
                }
                .sidebar {
                    position:static;
                    width:100%;
                    height:auto;
                }
                .kpi-row {
                    grid-template-columns:1fr;
                }
                .grid-3,.grid-2,.grid-4,.grid-3b {
                    grid-template-columns:1fr;
                }
                .content {
                    padding:16px;
                }
            }
            
            /* Style for clickable order counts table */
            .orders-grid-card {
                grid-column: span 2;
                background: #fff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }
            .orders-grid-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            .orders-grid-table th {
                background: #f8fafc;
                color: #475569;
                font-weight: 600;
                font-size: 13px;
                padding: 10px 12px;
                border-bottom: 2px solid #e2e8f0;
                text-align: left;
            }
            .orders-grid-table td {
                padding: 12px;
                border-bottom: 1px solid #f1f5f9;
                font-size: 13px;
                color: #1e293b;
            }
            .orders-grid-table tr:hover td {
                background: #f8fafc;
            }
            .clickable-count {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 6px;
                background: #eff6ff;
                color: #2563eb;
                font-weight: 700;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s ease;
                border: 1px solid #bfdbfe;
                text-align: center;
                min-width: 45px;
            }
            .clickable-count:hover {
                background: #2563eb;
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(37,99,235,0.2);
            }
            .clickable-count.zero {
                background: #f1f5f9;
                color: #94a3b8;
                border-color: #e2e8f0;
                cursor: default;
                pointer-events: none;
            }
            
            /* Order List Modal styles */
            .orders-modal-body {
                max-height: 400px;
                overflow-y: auto;
                margin-top: 15px;
            }
            .orders-modal-table {
                width: 100%;
                border-collapse: collapse;
            }
            .orders-modal-table th {
                position: sticky;
                top: 0;
                background: #f8fafc;
                color: #475569;
                font-weight: 600;
                font-size: 12px;
                padding: 10px;
                border-bottom: 2px solid #e2e8f0;
                text-align: left;
            }
            .orders-modal-table td {
                padding: 10px;
                border-bottom: 1px solid #f1f5f9;
                font-size: 12px;
                color: #334155;
            }
            .orders-modal-table tr:hover td {
                background: #f8fafc;
            }
            
            /* Rankings card toolbar */
            .ranking-card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                border-bottom: 1px solid #f1f5f9;
                padding-bottom: 10px;
            }
            .ranking-card-filters {
                display: flex;
                gap: 6px;
                align-items: center;
            }
            .ranking-filter-select {
                padding: 4px 8px;
                border-radius: 6px;
                border: 1px solid #cbd5e1;
                font-size: 11px;
                font-weight: 500;
                background: #fff;
                color: #334155;
                outline: none;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- ══════════ SIDEBAR (synced with other admin pages) ══════════ -->
            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="activePage" value="dashboard"/>
            </jsp:include>

            <!-- ══════════ MAIN ══════════ -->
            <div class="main">

                <!-- Topbar -->
                <div class="topbar">
                    <div class="topbar-left">
                        <span class="topbar-title">Bảng điều khiển phân tích</span>
                        <span class="topbar-date" id="currentDate"></span>
                    </div>
                    <div class="topbar-right">
                        <span class="status-pill"><span class="status-dot"></span>Hệ thống hoạt động</span>
                        <button class="icon-btn" title="Thông báo">🔔</button>
                        <button class="icon-btn" title="Làm mới" onclick="location.reload()">↻</button>
                    </div>
                </div>

                <div class="content">
                    <div class="page-header">
                        <div>
                            <div class="page-title">Tổng quan &amp; Phân tích</div>
                            <div class="page-sub">
                                <c:choose>
                                    <c:when test="${not empty dateError}">
                                        <span style="color:#ef4444; font-weight:600;">⚠️ ${dateError}</span>
                                    </c:when>
                                    <c:otherwise>
                                        Hiệu suất kinh doanh thời gian thực
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- ══ ROW 1: KPI SUMMARY CARDS ══ -->
                    <div class="kpi-row">

                        <!-- Revenue — REAL (KiotViet style with Month, Quarter, Year filter) -->
                        <div class="kpi-card revenue-hero">
                            <div class="kpi-top" style="display:flex; justify-content:space-between; align-items:center;">
                                <div class="kpi-icon bg-white">💰</div>
                                <select id="revenueTimeframeSelect" onchange="switchRevenueTimeframe(this.value)" style="background:rgba(255,255,255,0.15); color:#fff; border:1px solid rgba(255,255,255,0.3); border-radius:6px; padding:4px 8px; font-size:12px; font-weight:600; outline:none; cursor:pointer;">
                                    <option value="month" style="color:#000;">Tháng này</option>
                                    <option value="quarter" style="color:#000;">Quý này</option>
                                    <option value="year" style="color:#000;">Năm này</option>
                                </select>
                            </div>
                            <div class="kpi-label" id="revenueCardLabel" style="font-weight:600; font-size:14px; margin-top:10px;">Doanh thu tháng này</div>
                            <div class="kpi-value" id="revenueCardValue" style="font-size:26px; font-weight:800; margin:10px 0;">
                                <fmt:formatNumber value="${monthRevenue}" pattern="#,##0"/> ₫
                            </div>
                            <div class="kpi-sub" id="revenueCardSub" style="font-size:12px; font-weight:500; display:flex; align-items:center; gap:4px;">
                                <c:choose>
                                    <c:when test="${monthGrowth >= 0}">
                                        <span style="color:#4ade80; font-weight:700;">↑ <fmt:formatNumber value="${monthGrowth}" pattern="#,##0.0"/>%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#f87171; font-weight:700;">↓ <fmt:formatNumber value="${monthGrowth * -1}" pattern="#,##0.0"/>%</span>
                                    </c:otherwise>
                                </c:choose>
                                <span style="opacity:0.9;">so với tháng trước</span>
                            </div>
                        </div>

                        <!-- Orders — REAL -->
                        <div class="kpi-card c-green">
                            <div class="kpi-top" style="display:flex; justify-content:space-between; align-items:center;">
                                <div class="kpi-icon bg-green">🛒</div>
                                 <select id="ordersTimeframeSelect" onchange="switchOrdersTimeframe(this.value)" style="background:#f8fafc; color:#1e293b; border:1px solid #cbd5e1; border-radius:6px; padding:4px 8px; font-size:12px; font-weight:600; outline:none; cursor:pointer;">
                                     <option value="today">Hôm nay</option>
                                     <option value="week">Tuần này</option>
                                     <option value="month">Tháng này</option>
                                 </select>
                            </div>
                            <div class="kpi-label" id="ordersCardLabel" style="font-weight:600; font-size:14px; margin-top:10px;">Đơn hàng tháng này</div>
                            <div class="kpi-value" id="ordersCardValue" style="font-size:26px; font-weight:800; margin:10px 0;">0</div>
                            <div class="kpi-sub" id="ordersCardSub" style="font-size:12px; font-weight:500; display:flex; align-items:center; gap:4px;">
                                <span style="opacity:0.9;">Đang tính toán...</span>
                            </div>
                        </div>

                        <!-- New Customers -->
                        <div class="kpi-card c-blue" onclick="window.location.href='${pageContext.request.contextPath}/admin/users?role=3&from=${not empty from ? from : todayDate}&to=${not empty to ? to : todayDate}'" style="cursor:pointer;">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-blue">👤</div>
                            </div>
                            <div class="kpi-label">Khách hàng mới</div>
                            <div class="kpi-value">${newCustomersToday}</div>
                            <div class="kpi-sub">Đăng ký hôm nay</div>
                        </div>

                        <!-- Alerts -->
                        <div class="kpi-card c-red" onclick="openAlertsModal()" style="cursor:pointer;">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-red">⚠️</div>
                                <span class="kpi-badge down">Cần chú ý</span>
                            </div>
                            <div class="kpi-label">Cảnh báo kích hoạt</div>
                            <div class="kpi-value">${pendingAlerts}</div>
                            <div class="kpi-sub">Yêu cầu bảo hành & ticket duyệt</div>
                        </div>
                    </div>


                    <!-- ══ ROW 2: REVENUE CHART (full width) ══ -->
                    <div class="section-hd" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px;">
                        <span style="display:flex; align-items:center;"><span class="dot"></span>Phân tích doanh thu</span>
                        
                        <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" style="display:flex; align-items:center; gap:8px; background:#fff; padding:6px 12px; border-radius:8px; border:1px solid #cbd5e1; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin:0;">
                            <input type="hidden" name="revenueYear" value="${revenueYear}">
                            <div style="display:flex; align-items:center; gap:4px;">
                                <label style="font-size:12px; font-weight:600; color:#475569;">Từ ngày:</label>
                                <input type="date" name="from" value="${from}" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px; outline:none; color:#1e293b;">
                            </div>
                            <div style="display:flex; align-items:center; gap:4px;">
                                <label style="font-size:12px; font-weight:600; color:#475569;">Đến ngày:</label>
                                <input type="date" name="to" value="${to}" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px; outline:none; color:#1e293b;">
                            </div>
                            <select name="groupBy" onchange="this.form.submit()" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px;">
                                <option value="day" ${groupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                                <option value="month" ${groupBy == 'month' || empty groupBy ? 'selected' : ''}>Theo tháng</option>
                                <option value="quarter" ${groupBy == 'quarter' ? 'selected' : ''}>Theo quý</option>
                                <option value="year" ${groupBy == 'year' ? 'selected' : ''}>Theo năm</option>
                            </select>
                            <button type="submit" style="background:#2563eb; color:#fff; border:none; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; transition:background 0.2s;">Lọc</button>
                            <c:if test="${not empty from || not empty to}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard?revenueYear=${revenueYear}" style="background:#f1f5f9; color:#475569; border:1px solid #cbd5e1; text-decoration:none; padding:4px 10px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; display:inline-block;">Đặt lại</a>
                            </c:if>
                        </form>
                        <c:if test="${autoDefaultRange}">
                            <div style="font-size:12px; color:#92400e; background:#fffbeb; border:1px solid #fde68a; padding:6px 12px; border-radius:6px; margin-top:8px; display:inline-flex; align-items:center; gap:6px;">
                                ⓘ Chưa chọn khoảng ngày — đang hiển thị 30 ngày gần nhất
                            </div>
                        </c:if>
                    </div>

                    <div class="chart-card" style="margin-bottom:20px; padding: 16px;">
                        <canvas id="revenueChart" height="90"></canvas>
                    </div>

                    <!-- ══ ROW 3: Orders Status ══ -->
                    <div class="section-hd"><span class="dot"></span>Vận hành</div>
                    <div style="margin-bottom:20px;">

                        <!-- Orders Needing Attention -->
                        <div class="orders-grid-card">
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <div class="chart-card-title" style="margin-bottom:0; font-weight:700; color:#1e293b;">
                                    📋 Đơn hàng cần xử lý
                                </div>
                                <span style="font-size:12px; color:#64748b; font-weight:500;">Click vào số lượng để xem chi tiết</span>
                            </div>
                            <table class="orders-grid-table">
                                <thead>
                                    <tr>
                                        <th>Trạng thái</th>
                                        <th style="text-align:center;">Hôm nay</th>
                                        <th style="text-align:center;">Tuần này</th>
                                        <th style="text-align:center;">Tháng này</th>
                                        <th style="text-align:center;">Tất cả</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr data-status="Pending">
                                        <td style="font-weight:600; color:#d97706;">🟡 Chờ xác nhận (Pending)</td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-pending-today" onclick="viewOrdersInModal('Pending', 'today')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-pending-week" onclick="viewOrdersInModal('Pending', 'week')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-pending-month" onclick="viewOrdersInModal('Pending', 'month')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-pending-all" onclick="viewOrdersInModal('Pending', 'all')">0</span></td>
                                    </tr>
                                    <tr data-status="Processing">
                                        <td style="font-weight:600; color:#2563eb;">🔵 Đang xử lý (Processing)</td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-processing-today" onclick="viewOrdersInModal('Processing', 'today')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-processing-week" onclick="viewOrdersInModal('Processing', 'week')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-processing-month" onclick="viewOrdersInModal('Processing', 'month')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-processing-all" onclick="viewOrdersInModal('Processing', 'all')">0</span></td>
                                    </tr>
                                    <tr data-status="Shipped">
                                        <td style="font-weight:600; color:#7c3aed;">🟣 Đang giao hàng (Shipped)</td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-shipped-today" onclick="viewOrdersInModal('Shipped', 'today')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-shipped-week" onclick="viewOrdersInModal('Shipped', 'week')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-shipped-month" onclick="viewOrdersInModal('Shipped', 'month')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-shipped-all" onclick="viewOrdersInModal('Shipped', 'all')">0</span></td>
                                    </tr>
                                    <tr data-status="Delivered">
                                        <td style="font-weight:600; color:#16a34a;">🟢 Đã giao / Hoàn thành</td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-delivered-today" onclick="viewOrdersInModal('Delivered', 'today')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-delivered-week" onclick="viewOrdersInModal('Delivered', 'week')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-delivered-month" onclick="viewOrdersInModal('Delivered', 'month')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-delivered-all" onclick="viewOrdersInModal('Delivered', 'all')">0</span></td>
                                    </tr>
                                    <tr data-status="Cancelled">
                                        <td style="font-weight:600; color:#dc2626;">🔴 Đã hủy (Cancelled)</td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-cancelled-today" onclick="viewOrdersInModal('Cancelled', 'today')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-cancelled-week" onclick="viewOrdersInModal('Cancelled', 'week')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-cancelled-month" onclick="viewOrdersInModal('Cancelled', 'month')">0</span></td>
                                        <td style="text-align:center;"><span class="clickable-count zero" id="count-cancelled-all" onclick="viewOrdersInModal('Cancelled', 'all')">0</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ══ ROW 4: Top Products + Top Customers + Recent Activities ══ -->
                    <div class="section-hd"><span class="dot"></span>Bảng xếp hạng &amp; Hoạt động</div>
                    <div class="grid-3b">

                        <!-- Top Products Horizontal Bar -->
                        <div class="chart-card">
                            <div class="ranking-card-header">
                                <div class="chart-card-title" style="margin-bottom:0;">🏆 Sản phẩm bán chạy</div>
                                <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" class="ranking-card-filters">
                                    <input type="hidden" name="from" value="${from}">
                                    <input type="hidden" name="to" value="${to}">
                                    <input type="hidden" name="groupBy" value="${groupBy}">
                                    <input type="hidden" name="topCustomersTime" value="${topCustomersTime}">
                                    
                                    <select name="topProductsCriteria" onchange="this.form.submit()" class="ranking-filter-select">
                                        <option value="quantity" ${topProductsCriteria == 'quantity' ? 'selected' : ''}>Theo số lượng</option>
                                        <option value="revenue" ${topProductsCriteria == 'revenue' ? 'selected' : ''}>Theo doanh thu</option>
                                    </select>
                                    <select name="topProductsTime" onchange="this.form.submit()" class="ranking-filter-select">
                                        <option value="today" ${topProductsTime == 'today' ? 'selected' : ''}>Hôm nay</option>
                                        <option value="week" ${topProductsTime == 'week' ? 'selected' : ''}>Tuần này</option>
                                        <option value="month" ${topProductsTime == 'month' ? 'selected' : ''}>Tháng này</option>
                                        <option value="all" ${topProductsTime == 'all' ? 'selected' : ''}>Tất cả</option>
                                    </select>
                                </form>
                            </div>
                            <c:choose>
                                <c:when test="${not empty topProducts}">
                                    <canvas id="topProductsChart" height="200"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:200px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">Không có dữ liệu bán hàng trong khoảng thời gian này</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
 
                        <!-- Top Customers Horizontal Bar -->
                        <div class="chart-card">
                            <div class="ranking-card-header">
                                <div class="chart-card-title" style="margin-bottom:0;">👑 Khách hàng tiêu biểu</div>
                                <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" class="ranking-card-filters">
                                    <input type="hidden" name="from" value="${from}">
                                    <input type="hidden" name="to" value="${to}">
                                    <input type="hidden" name="groupBy" value="${groupBy}">
                                    <input type="hidden" name="topProductsCriteria" value="${topProductsCriteria}">
                                    <input type="hidden" name="topProductsTime" value="${topProductsTime}">
                                    
                                    <select name="topCustomersTime" onchange="this.form.submit()" class="ranking-filter-select">
                                        <option value="today" ${topCustomersTime == 'today' ? 'selected' : ''}>Hôm nay</option>
                                        <option value="week" ${topCustomersTime == 'week' ? 'selected' : ''}>Tuần này</option>
                                        <option value="month" ${topCustomersTime == 'month' ? 'selected' : ''}>Tháng này</option>
                                        <option value="all" ${topCustomersTime == 'all' ? 'selected' : ''}>Tất cả</option>
                                    </select>
                                </form>
                            </div>
                            <c:choose>
                                <c:when test="${not empty topCustomers}">
                                    <canvas id="topCustomersChart" height="200"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:200px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">Không có dữ liệu chi tiêu khách hàng trong khoảng thời gian này</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Recent Activities — REAL -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                🕐 Hoạt động gần đây
                            </div>
                            <div class="activity-feed">
                                <c:forEach items="${recentActivities}" var="act">
                                    <div class="activity-item">
                                        <span class="activity-icon">${act[0]}</span>
                                        <span class="activity-text">${act[1]}</span>
                                        <span class="activity-time">${act[2]}</span>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty recentActivities}">
                                    <div class="no-data">Không có hoạt động gần đây</div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                </div><%-- .content --%>
            </div><%-- .main --%>
        </div><%-- .layout --%>

        <script>
        // ── Topbar date ──────────────────────────────────────
            document.getElementById('currentDate').textContent =
                    new Date().toLocaleDateString('vi-VN', {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'});

        // ── Helpers ─────────────────────────────────────────
            function toggleSidebarDropdown(btn) {
                const container = btn.nextElementSibling;
                const arrow = btn.querySelector('.dropdown-arrow');
                if (container.style.display === 'flex') {
                    container.style.display = 'none';
                    arrow.style.transform = 'rotate(0deg)';
                } else {
                    container.style.display = 'flex';
                    arrow.style.transform = 'rotate(180deg)';
                }
            }

            function buildLabels(map) {
                return Object.keys(map);
            }
            function buildValues(map) {
                return Object.values(map);
            }

        // ── Revenue Bar Chart — REAL DATA ────────────────────
            const revenueLabels = [<c:forEach items="${monthlyRevenue}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const revenueValues = [<c:forEach items="${monthlyRevenue}" var="e" varStatus="s">${e.value / 1000000}<c:if test="${!s.last}">,</c:if></c:forEach>];

            new Chart(document.getElementById('revenueChart'), {
                type: 'bar',
                data: {
                    labels: revenueLabels,
                    datasets: [{
                            label: 'Revenue (million ₫)',
                            data: revenueValues,
                            backgroundColor: 'rgba(59,130,246,.75)',
                            borderColor: '#2563eb',
                            borderWidth: 1,
                            borderRadius: 6
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {legend: {display: false}},
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {color: '#f3f4f6'},
                            ticks: {callback: v => v + 'M ₫', font: {size: 11}}
                        },
                        x: {grid: {display: false}, ticks: {font: {size: 11}}}
                    }
                }
            });

        // ── Interactive Orders Needing Attention ────────────────
            const allOrders = [
                <c:forEach items="${allOrders}" var="o" varStatus="loop">
                    {
                        orderId: '${o[0]}',
                        orderCode: '${o[1]}',
                        receiver: '${o[2]}',
                        status: '${o[3]}',
                        total: ${not empty o[4] ? o[4] : 0.0},
                        dateStr: '${o[5]}'
                    }${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            function getNormalizedStatus(status) {
                if (!status) return 'Unknown';
                const s = status.trim().toUpperCase();
                if (s === 'PENDING') return 'Pending';
                if (s === 'PROCESSING') return 'Processing';
                if (s === 'SHIPPED') return 'Shipped';
                if (s === 'DELIVERED' || s === 'COMPLETED') return 'Delivered';
                if (s === 'CANCELLED') return 'Cancelled';
                return status;
            }

            function parseOrderDate(dateStr) {
                if (!dateStr) return null;
                const parts = dateStr.split(' ');
                const dateParts = parts[0].split('-');
                const year = parseInt(dateParts[0]);
                const month = parseInt(dateParts[1]) - 1;
                const day = parseInt(dateParts[2]);
                
                let hour = 0, min = 0, sec = 0;
                if (parts[1]) {
                    const timeParts = parts[1].split(':');
                    hour = parseInt(timeParts[0]);
                    min = parseInt(timeParts[1]);
                    sec = parseInt(timeParts[2]);
                }
                return new Date(year, month, day, hour, min, sec);
            }

            function isToday(date) {
                if (!date) return false;
                const today = new Date();
                return date.getDate() === today.getDate() &&
                       date.getMonth() === today.getMonth() &&
                       date.getFullYear() === today.getFullYear();
            }

            function isThisWeek(date) {
                if (!date) return false;
                const today = new Date();
                const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                const day = startOfToday.getDay();
                const diff = startOfToday.getDate() - day + (day === 0 ? -6 : 1);
                const monday = new Date(startOfToday.setDate(diff));
                
                const sunday = new Date(monday);
                sunday.setDate(sunday.getDate() + 6);
                sunday.setHours(23, 59, 59, 999);
                
                return date >= monday && date <= sunday;
            }

            function isThisMonth(date) {
                if (!date) return false;
                const today = new Date();
                return date.getMonth() === today.getMonth() &&
                       date.getFullYear() === today.getFullYear();
            }

            const orderCollections = {
                'Pending_today': [], 'Pending_week': [], 'Pending_month': [], 'Pending_all': [],
                'Processing_today': [], 'Processing_week': [], 'Processing_month': [], 'Processing_all': [],
                'Shipped_today': [], 'Shipped_week': [], 'Shipped_month': [], 'Shipped_all': [],
                'Delivered_today': [], 'Delivered_week': [], 'Delivered_month': [], 'Delivered_all': [],
                'Cancelled_today': [], 'Cancelled_week': [], 'Cancelled_month': [], 'Cancelled_all': []
            };

            allOrders.forEach(order => {
                const date = parseOrderDate(order.dateStr);
                const normStatus = getNormalizedStatus(order.status);
                
                if (orderCollections[normStatus + '_all'] !== undefined) {
                    orderCollections[normStatus + '_all'].push(order);
                    
                    if (isToday(date)) {
                        orderCollections[normStatus + '_today'].push(order);
                    }
                    if (isThisWeek(date)) {
                        orderCollections[normStatus + '_week'].push(order);
                    }
                    if (isThisMonth(date)) {
                        orderCollections[normStatus + '_month'].push(order);
                    }
                }
            });

            Object.keys(orderCollections).forEach(key => {
                const list = orderCollections[key];
                const elementId = 'count-' + key.replace('_', '-').toLowerCase();
                const el = document.getElementById(elementId);
                if (el) {
                    el.innerText = list.length;
                    if (list.length > 0) {
                        el.classList.remove('zero');
                    }
                }
            });

            function viewOrdersInModal(status, timeframe) {
                const key = status + '_' + timeframe;
                const orders = orderCollections[key];
                if (!orders || orders.length === 0) return;
                
                const timeframeLabels = { 'today': 'hôm nay', 'week': 'tuần này', 'month': 'tháng này', 'all': 'tất cả' };
                const statusLabels = { 'Pending': 'Chờ xác nhận', 'Processing': 'Đang xử lý', 'Shipped': 'Đang giao', 'Delivered': 'Đã giao / Hoàn thành', 'Cancelled': 'Đã hủy' };
                document.getElementById('ordersModalTitle').innerText = '📋 Đơn hàng ' + statusLabels[status] + ' (' + timeframeLabels[timeframe] + ')';
                
                const tbody = document.getElementById('ordersModalTableBody');
                tbody.innerHTML = '';
                
                orders.forEach(o => {
                    const tr = document.createElement('tr');
                    
                    const tdCode = document.createElement('td');
                    tdCode.style.fontWeight = '700';
                    tdCode.style.color = '#2563eb';
                    tdCode.innerText = o.orderCode;
                    tr.appendChild(tdCode);
                    
                    const tdReceiver = document.createElement('td');
                    tdReceiver.innerText = o.receiver;
                    tr.appendChild(tdReceiver);
                    
                    const tdDate = document.createElement('td');
                    tdDate.innerText = o.dateStr;
                    tr.appendChild(tdDate);
                    
                    const tdTotal = document.createElement('td');
                    tdTotal.style.fontWeight = '600';
                    tdTotal.innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(o.total);
                    tr.appendChild(tdTotal);
                    
                    const tdStatus = document.createElement('td');
                    let badgeColor = '#64748b', badgeBg = '#f1f5f9';
                    if (status === 'Pending') { badgeColor = '#d97706'; badgeBg = '#fffbeb'; }
                    else if (status === 'Processing') { badgeColor = '#2563eb'; badgeBg = '#eff6ff'; }
                    else if (status === 'Shipped') { badgeColor = '#7c3aed'; badgeBg = '#f5f3ff'; }
                    else if (status === 'Delivered') { badgeColor = '#16a34a'; badgeBg = '#f0fdf4'; }
                    else if (status === 'Cancelled') { badgeColor = '#dc2626'; badgeBg = '#fef2f2'; }
                    
                    tdStatus.innerHTML = '<span style="display:inline-block; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:600; color:' + badgeColor + '; background:' + badgeBg + ';">' + statusLabels[status] + '</span>';
                    tr.appendChild(tdStatus);
                    
                    tbody.appendChild(tr);
                });
                
                document.getElementById('ordersDetailModal').style.display = 'flex';
            }

            function closeOrdersModal() {
                document.getElementById('ordersDetailModal').style.display = 'none';
            }

        // ── Top Products Horizontal Bar ──────────────────────
            const tpLabels = [<c:forEach items="${topProducts}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const tpValues = [<c:forEach items="${topProducts}" var="e" varStatus="s">${topProductsCriteria == 'revenue' ? e.value / 1000000.0 : e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];
 
            const topProductsEl = document.getElementById('topProductsChart');
            if (topProductsEl) {
                new Chart(topProductsEl, {
                    type: 'bar',
                    data: {
                        labels: tpLabels,
                        datasets: [{
                                label: '${topProductsCriteria == "revenue" ? "Doanh thu (Triệu ₫)" : "Số lượng bán"}',
                                data: tpValues,
                                backgroundColor: '${topProductsCriteria == "revenue" ? "rgba(59,130,246,.75)" : "rgba(16,185,129,.75)"}',
                                borderColor: '${topProductsCriteria == "revenue" ? "#3b82f6" : "#10b981"}',
                                borderWidth: 1, borderRadius: 4
                            }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        plugins: {legend: {display: false}},
                        scales: {
                            x: {beginAtZero: true, grid: {color: '#f3f4f6'}, ticks: {font: {size: 11}}},
                            y: {grid: {display: false}, ticks: {font: {size: 11}}}
                        }
                    }
                });
            }

        // ── Top Customers Horizontal Bar — REAL DATA ─────────
            const tcLabels = [<c:forEach items="${topCustomers}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const tcValues = [<c:forEach items="${topCustomers}" var="e" varStatus="s">${e.value / 1000000}<c:if test="${!s.last}">,</c:if></c:forEach>];

            const topCustomersEl = document.getElementById('topCustomersChart');
            if (topCustomersEl) {
                new Chart(topCustomersEl, {
                    type: 'bar',
                    data: {
                        labels: tcLabels,
                        datasets: [{
                                label: 'Total Spent (M ₫)',
                                data: tcValues,
                                backgroundColor: 'rgba(139,92,246,.75)',
                                borderColor: '#8b5cf6',
                                borderWidth: 1, borderRadius: 4
                            }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        plugins: {legend: {display: false}},
                        scales: {
                            x: {
                                beginAtZero: true, grid: {color: '#f3f4f6'},
                                ticks: {callback: v => v + 'M', font: {size: 11}}
                            },
                            y: {grid: {display: false}, ticks: {font: {size: 11}}}
                        }
                    }
                });
            }

            // ── Alerts Modal Functions ─────────────────────────
            function openAlertsModal() {
                var modal = document.getElementById('alertsModal');
                if (modal) {
                    modal.style.display = 'flex';
                }
            }
            function closeAlertsModal() {
                var modal = document.getElementById('alertsModal');
                if (modal) {
                    modal.style.display = 'none';
                }
            }
            window.addEventListener('click', function(e) {
                var modal = document.getElementById('alertsModal');
                if (e.target === modal) {
                    modal.style.display = 'none';
                }
                var modal2 = document.getElementById('ordersDetailModal');
                if (e.target === modal2) {
                    modal2.style.display = 'none';
                }
            });

            // ── Timeframe revenue data from JSTL ──
            const revenueTimeframeData = {
                month: {
                    label: 'Doanh thu tháng này',
                    value: ${not empty monthRevenue ? monthRevenue : 0},
                    growth: ${not empty monthGrowth ? monthGrowth : 0.0},
                    timeLabel: 'tháng trước'
                },
                quarter: {
                    label: 'Doanh thu quý này',
                    value: ${not empty quarterRevenue ? quarterRevenue : 0},
                    growth: ${not empty quarterGrowth ? quarterGrowth : 0.0},
                    timeLabel: 'quý trước'
                },
                year: {
                    label: 'Doanh thu năm này',
                    value: ${not empty yearRevenue ? yearRevenue : 0},
                    growth: ${not empty yearGrowth ? yearGrowth : 0.0},
                    timeLabel: 'năm trước'
                }
            };

            function switchRevenueTimeframe(timeframe) {
                const data = revenueTimeframeData[timeframe];
                if (!data) return;
                
                // Update Label
                document.getElementById('revenueCardLabel').innerText = data.label;
                
                // Update Value
                const formattedVal = new Intl.NumberFormat('vi-VN').format(data.value) + ' ₫';
                document.getElementById('revenueCardValue').innerText = formattedVal;
                
                // Update Sub
                const subEl = document.getElementById('revenueCardSub');
                const sign = data.growth >= 0 ? '↑' : '↓';
                const color = data.growth >= 0 ? '#4ade80' : '#f87171';
                const absVal = Math.abs(data.growth).toFixed(1);
                
                subEl.innerHTML = '<span style="color:' + color + '; font-weight:700;">' + sign + ' ' + absVal + '%</span> <span style="opacity:0.9;">so với ' + data.timeLabel + '</span>';
            }

             // ── Timeframe orders data dynamically computed from allOrders ──
             function isYesterday(date) {
                 if (!date) return false;
                 const today = new Date();
                 const yesterday = new Date(today);
                 yesterday.setDate(yesterday.getDate() - 1);
                 return date.getDate() === yesterday.getDate() &&
                        date.getMonth() === yesterday.getMonth() &&
                        date.getFullYear() === yesterday.getFullYear();
             }

             function isLastWeek(date) {
                 if (!date) return false;
                 const today = new Date();
                 const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                 const day = startOfToday.getDay();
                 const diff = startOfToday.getDate() - day + (day === 0 ? -6 : 1) - 7;
                 const monday = new Date(startOfToday.setDate(diff));
                 
                 const sunday = new Date(monday);
                 sunday.setDate(sunday.getDate() + 6);
                 sunday.setHours(23, 59, 59, 999);
                 
                 return date >= monday && date <= sunday;
             }

             function isLastMonth(date) {
                 if (!date) return false;
                 const today = new Date();
                 let lastMonth = today.getMonth() - 1;
                 let year = today.getFullYear();
                 if (lastMonth < 0) {
                     lastMonth = 11;
                     year -= 1;
                 }
                 return date.getMonth() === lastMonth && date.getFullYear() === year;
             }

             const orderStatsData = {
                 today: { label: 'Đơn hàng hôm nay', current: 0, previous: 0, timeLabel: 'hôm qua' },
                 week: { label: 'Đơn hàng tuần này', current: 0, previous: 0, timeLabel: 'tuần trước' },
                 month: { label: 'Đơn hàng tháng này', current: 0, previous: 0, timeLabel: 'tháng trước' }
             };

             allOrders.forEach(order => {
                 const date = parseOrderDate(order.dateStr);
                 const status = order.status ? order.status.trim().toUpperCase() : '';
                 if (status === 'CANCELLED') return;

                 if (isToday(date)) {
                     orderStatsData.today.current++;
                 } else if (isYesterday(date)) {
                     orderStatsData.today.previous++;
                 }

                 if (isThisWeek(date)) {
                     orderStatsData.week.current++;
                 } else if (isLastWeek(date)) {
                     orderStatsData.week.previous++;
                 }

                 if (isThisMonth(date)) {
                     orderStatsData.month.current++;
                 } else if (isLastMonth(date)) {
                     orderStatsData.month.previous++;
                 }
             });

             function switchOrdersTimeframe(timeframe) {
                 const data = orderStatsData[timeframe];
                 if (!data) return;

                 document.getElementById('ordersCardLabel').innerText = data.label;
                 document.getElementById('ordersCardValue').innerText = data.current;

                 const subEl = document.getElementById('ordersCardSub');
                 let growthPct = 0;
                 if (data.previous > 0) {
                     growthPct = ((data.current - data.previous) / data.previous) * 100;
                 } else if (data.current > 0) {
                     growthPct = 100.0;
                 }

                 const sign = growthPct >= 0 ? '↑' : '↓';
                 const color = growthPct >= 0 ? '#4ade80' : '#f87171';
                 const absVal = Math.abs(growthPct).toFixed(1);

                 subEl.innerHTML = '<span style="color:' + color + '; font-weight:700;">' + sign + ' ' + absVal + '%</span> <span style="opacity:0.9;">so với ' + data.timeLabel + '</span>';
             }

             // Initialize orders timeframe to today
             switchOrdersTimeframe('today');
        </script>

        <!-- Alerts Details Modal -->
        <div id="alertsModal" class="modal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.4); backdrop-filter:blur(4px); align-items:center; justify-content:center;">
            <div style="background:#fff; border-radius:12px; max-width:600px; width:90%; padding:24px; box-shadow:0 10px 25px rgba(0,0,0,0.15); position:relative;">
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #e2e8f0; padding-bottom:12px; margin-bottom:16px;">
                    <h3 style="font-size:18px; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:8px; margin:0;">⚠️ Chi tiết cảnh báo kích hoạt</h3>
                    <span onclick="closeAlertsModal()" style="font-size:24px; font-weight:bold; color:#94a3b8; cursor:pointer; line-height:1;">&times;</span>
                </div>
                
                <!-- Pending Claims Section -->
                <div>
                    <h4 style="font-size:14px; font-weight:600; color:#475569; margin-top:0; margin-bottom:8px; display:flex; justify-content:space-between;">
                        <span>Yêu cầu bảo hành chưa xử lý</span>
                        <span style="background:#fee2e2; color:#ef4444; padding:2px 8px; border-radius:12px; font-size:11px;">${pendingClaimsList.size()} items</span>
                    </h4>
                    <c:choose>
                        <c:when test="${not empty pendingClaimsList}">
                            <div style="max-height:120px; overflow-y:auto; border:1px solid #e2e8f0; border-radius:8px;">
                                <table style="width:100%; border-collapse:collapse; font-size:13px; text-align:left;">
                                    <thead style="background:#f8fafc; position:sticky; top:0; z-index:1;">
                                        <tr>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Mã yêu cầu</th>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Khách hàng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pendingClaimsList}" var="c">
                                            <tr style="border-bottom:1px solid #f1f5f9; cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/warranty?action=list&statusFilter=PENDING'">
                                                <td style="padding:8px 12px; color:#2563eb; font-weight:600;">#${c[0]}</td>
                                                <td style="padding:8px 12px; color:#1e293b;">${c[1]}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="color:#94a3b8; font-size:12px; padding:8px 0; border:1px dashed #e2e8f0; border-radius:8px; text-align:center;">Không có yêu cầu bảo hành chưa xử lý</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pending Ticket Reviews Section -->
                <div style="margin-top:20px;">
                    <h4 style="font-size:14px; font-weight:600; color:#475569; margin-top:0; margin-bottom:8px; display:flex; justify-content:space-between;">
                        <span>Yêu cầu duyệt Ticket chưa xử lý</span>
                        <span style="background:#fee2e2; color:#ef4444; padding:2px 8px; border-radius:12px; font-size:11px;">${pendingTicketsList.size()} items</span>
                    </h4>
                    <c:choose>
                        <c:when test="${not empty pendingTicketsList}">
                            <div style="max-height:120px; overflow-y:auto; border:1px solid #e2e8f0; border-radius:8px;">
                                <table style="width:100%; border-collapse:collapse; font-size:13px; text-align:left;">
                                    <thead style="background:#f8fafc; position:sticky; top:0; z-index:1;">
                                        <tr>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Mã Ticket</th>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Tiêu đề</th>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Người tạo</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pendingTicketsList}" var="t">
                                            <tr style="border-bottom:1px solid #f1f5f9; cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/admin/ticket/detail?id=${t[0]}'">
                                                <td style="padding:8px 12px; color:#2563eb; font-weight:600;">#${t[0]}</td>
                                                <td style="padding:8px 12px; color:#1e293b;">${t[1]}</td>
                                                <td style="padding:8px 12px; color:#475569;">${t[2]}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="color:#94a3b8; font-size:12px; padding:8px 0; border:1px dashed #e2e8f0; border-radius:8px; text-align:center;">Không có yêu cầu duyệt Ticket chưa xử lý</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Modal: View Detailed Orders -->
        <div id="ordersDetailModal" class="modal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.4); backdrop-filter:blur(4px); align-items:center; justify-content:center;">
            <div style="background:#fff; border-radius:12px; max-width:800px; width:90%; padding:24px; box-shadow:0 10px 25px rgba(0,0,0,0.15); position:relative;">
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #e2e8f0; padding-bottom:12px; margin-bottom:16px;">
                    <h3 id="ordersModalTitle" style="font-size:18px; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:8px; margin:0;">
                        📋 Danh sách đơn hàng
                    </h3>
                    <span onclick="closeOrdersModal()" style="font-size:24px; font-weight:bold; color:#94a3b8; cursor:pointer; line-height:1;">&times;</span>
                </div>
                <div class="orders-modal-body">
                    <table class="orders-modal-table">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Người nhận</th>
                                <th>Ngày tạo</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody id="ordersModalTableBody">
                            <!-- Populated dynamically -->
                        </tbody>
                    </table>
                </div>
                <div style="display:flex; justify-content:end; margin-top:20px; border-top:1px solid #e2e8f0; padding-top:12px;">
                    <button onclick="closeOrdersModal()" style="background:#f1f5f9; color:#475569; border:1px solid #cbd5e1; padding:8px 16px; border-radius:6px; font-size:13px; font-weight:600; cursor:pointer;">Đóng</button>
                </div>
            </div>
        </div>
    </body>
</html>


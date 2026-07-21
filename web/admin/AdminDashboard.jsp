<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Analytics Dashboard</title>
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
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- ══════════ SIDEBAR (synced with other admin pages) ══════════ -->
            <aside class="sidebar">
                <div class="brand">
                    <span>UNILAP Admin</span>
                    <small>System Controller</small>
                </div>
                <nav>
                    <a class="active" href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Bảng điều khiển</a>
                    <a href="#"><span>▣</span>Đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Người dùng</a>
                    <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Thống kê</a>
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Chính sách</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Quản lý đánh giá</a>
                    <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
                    <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Duyệt Ticket</a>
                    <a href="#"><span>⚙</span>Cài đặt</a>
                </nav>
                <div class="profile">
                    <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                        <%
                            model.Users u = (model.Users) session.getAttribute("user");
                            if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                        %>
                            <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                                 alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                        <% } else { %>
                            <span>♙</span>
                        <% } %>
                        <span>Hồ sơ Admin</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                </div>
            </aside>

            <!-- ══════════ MAIN ══════════ -->
            <div class="main">

                <!-- Topbar -->
                <div class="topbar">
                    <div class="topbar-left">
                        <span class="topbar-title">Bảng Điều Khiển Thống Kê</span>
                        <span class="topbar-date" id="currentDate"></span>
                    </div>
                    <div class="topbar-right">
                        <span class="status-pill"><span class="status-dot"></span>System Online</span>
                        <button class="icon-btn" title="Notifications">🔔</button>
                        <button class="icon-btn" title="Refresh" onclick="location.reload()">↻</button>
                    </div>
                </div>

                <div class="content">
                    <div class="page-header">
                        <div>
                            <div class="page-title">Overview &amp; Analytics</div>
                            <div class="page-sub">
                                <c:choose>
                                    <c:when test="${not empty dateError}">
                                        <span style="color:#ef4444; font-weight:600;">⚠️ ${dateError}</span>
                                    </c:when>
                                    <c:otherwise>
                                        Real-time business performance
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- ══ ROW 1: KPI SUMMARY CARDS ══ -->
                    <div class="kpi-row">

                        <!-- Revenue — REAL -->
                        <div class="kpi-card revenue-hero">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-white">💰</div>
                            </div>
                            <div class="kpi-label">Total Revenue</div>
                            <div class="kpi-value">
                                <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/> ₫
                            </div>
                            <div class="kpi-sub">All orders (excl. cancelled)</div>
                        </div>

                        <!-- Orders — REAL -->
                        <div class="kpi-card c-green">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-green">🛒</div>
                            </div>
                            <div class="kpi-label">Total Orders</div>
                            <div class="kpi-value">${todayOrders}</div>
                            <div class="kpi-sub">All time order count</div>
                        </div>

                        <!-- New Customers -->
                        <div class="kpi-card c-blue" onclick="window.location.href='${pageContext.request.contextPath}/admin/users?role=3&from=${not empty from ? from : todayDate}&to=${not empty to ? to : todayDate}'" style="cursor:pointer;">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-blue">👤</div>
                            </div>
                            <div class="kpi-label">New Customers</div>
                            <div class="kpi-value">${newCustomersToday}</div>
                            <div class="kpi-sub">Registered today</div>
                        </div>

                        <!-- Alerts -->
                        <div class="kpi-card c-red" onclick="openAlertsModal()" style="cursor:pointer;">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-red">⚠️</div>
                                <span class="kpi-badge down">Needs attention</span>
                            </div>
                            <div class="kpi-label">Active Alerts</div>
                            <div class="kpi-value">${pendingAlerts}</div>
                            <div class="kpi-sub">Low stock &amp; pending claims</div>
                        </div>
                    </div>


                    <!-- ══ ROW 2: REVENUE CHART (full width) ══ -->
                    <div class="section-hd" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px;">
                        <span style="display:flex; align-items:center;"><span class="dot"></span>Revenue Analytics</span>
                        
                        <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" style="display:flex; align-items:center; gap:8px; background:#fff; padding:6px 12px; border-radius:8px; border:1px solid #cbd5e1; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin:0;">
                            <input type="hidden" name="revenueYear" value="${revenueYear}">
                            <div style="display:flex; align-items:center; gap:4px;">
                                <label style="font-size:12px; font-weight:600; color:#475569;">From:</label>
                                <input type="date" name="from" value="${from}" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px; outline:none; color:#1e293b;">
                            </div>
                            <div style="display:flex; align-items:center; gap:4px;">
                                <label style="font-size:12px; font-weight:600; color:#475569;">To:</label>
                                <input type="date" name="to" value="${to}" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px; outline:none; color:#1e293b;">
                            </div>
                            <select name="groupBy" onchange="this.form.submit()" style="padding:4px 8px; border:1px solid #cbd5e1; border-radius:6px; font-size:12px;">
                                <option value="day" ${groupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                                <option value="month" ${groupBy == 'month' || empty groupBy ? 'selected' : ''}>Theo tháng</option>
                                <option value="quarter" ${groupBy == 'quarter' ? 'selected' : ''}>Theo quý</option>
                                <option value="year" ${groupBy == 'year' ? 'selected' : ''}>Theo năm</option>
                            </select>
                            <button type="submit" style="background:#2563eb; color:#fff; border:none; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; transition:background 0.2s;">Filter</button>
                            <c:if test="${not empty from || not empty to}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard?revenueYear=${revenueYear}" style="background:#f1f5f9; color:#475569; border:1px solid #cbd5e1; text-decoration:none; padding:4px 10px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; display:inline-block;">Reset</a>
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

                    <!-- ══ ROW 3: Orders Status + Products by Category + Low Stock ══ -->
                    <div class="section-hd"><span class="dot"></span>Operations</div>
                    <div class="grid-3">

                        <!-- Orders by Status Doughnut -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                Orders by Status
                            </div>
                            <c:choose>
                                <c:when test="${not empty ordersByStatus}">
                                    <canvas id="ordersChart" height="180"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:180px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">No order status data for this period</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Products by Category Pie -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                Products by Category
                            </div>
                            <c:choose>
                                <c:when test="${not empty productsByCategory}">
                                    <canvas id="categoryChart" height="180"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:180px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">No product category data for this period</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Low Stock Panel — REAL -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                ⚠️ Low Stock Products
                            </div>
                            <c:choose>
                                <c:when test="${not empty lowStockProducts}">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Category</th>
                                                <th>Qty</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${lowStockProducts}" var="p">
                                                <tr onclick="window.location.href='${pageContext.request.contextPath}/staff/inventory'" style="cursor:pointer;">
                                                    <td style="font-weight:500;font-size:12px;">${p.productName}</td>
                                                    <td style="color:#6b7280;font-size:12px;">${p.categoryName}</td>
                                                    <td>
                                                        <span class="qty-pill <c:choose><c:when test='${p.minPrice <= 3}'>qty-critical</c:when><c:when test='${p.minPrice <= 7}'>qty-low</c:when><c:otherwise>qty-ok</c:otherwise></c:choose>">
                                                            ${p.minPrice}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">✅ No low stock products</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- ══ ROW 4: Top Products + Top Customers + Recent Activities ══ -->
                    <div class="section-hd"><span class="dot"></span>Rankings &amp; Activity</div>
                    <div class="grid-3b">

                        <!-- Top Products Horizontal Bar -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                🏆 Top Products
                            </div>
                            <c:choose>
                                <c:when test="${not empty topProducts}">
                                    <canvas id="topProductsChart" height="200"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:200px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">No product sales data for this period</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Top Customers Horizontal Bar -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                👑 Top Customers
                            </div>
                            <c:choose>
                                <c:when test="${not empty topCustomers}">
                                    <canvas id="topCustomersChart" height="200"></canvas>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data" style="height:200px; display:flex; align-items:center; justify-content:center; color:#9ca3af; font-size:13px; font-weight:500;">No customer spending data for this period</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Recent Activities — REAL -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                🕐 Recent Activities
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
                                    <div class="no-data">No recent activities</div>
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
                    new Date().toLocaleDateString('en-US', {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'});

        // ── Helpers ─────────────────────────────────────────
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

        // ── Orders Doughnut — REAL DATA ──────────────────────
            const orderLabels = [<c:forEach items="${ordersByStatus}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const orderValues = [<c:forEach items="${ordersByStatus}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];

            const ordersEl = document.getElementById('ordersChart');
            if (ordersEl) {
                new Chart(ordersEl, {
                    type: 'doughnut',
                    data: {
                        labels: orderLabels,
                        datasets: [{
                                data: orderValues,
                                backgroundColor: ['#dbeafe', '#fef9c3', '#ede9fe', '#dcfce7', '#fee2e2'],
                                borderColor: ['#3b82f6', '#f59e0b', '#8b5cf6', '#10b981', '#ef4444'],
                                borderWidth: 2
                            }]
                    },
                    options: {
                        responsive: true,
                        cutout: '62%',
                        plugins: {
                            legend: {position: 'bottom', labels: {font: {size: 11}, padding: 10}}
                        }
                    }
                });
            }

        // ── Products by Category Pie — REAL DATA ─────────────
            const catLabels = [<c:forEach items="${productsByCategory}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const catValues = [<c:forEach items="${productsByCategory}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];
            const catColors = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16'];

            const categoryEl = document.getElementById('categoryChart');
            if (categoryEl) {
                new Chart(categoryEl, {
                    type: 'pie',
                    data: {
                        labels: catLabels.length ? catLabels : ['No data'],
                        datasets: [{
                                data: catValues.length ? catValues : [1],
                                backgroundColor: catColors,
                                borderWidth: 2, borderColor: '#fff'
                            }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {position: 'bottom', labels: {font: {size: 11}, padding: 8}}
                        }
                    }
                });
            }

        // ── Top Products Horizontal Bar — REAL DATA ──────────
            const tpLabels = [<c:forEach items="${topProducts}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const tpValues = [<c:forEach items="${topProducts}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];

            const topProductsEl = document.getElementById('topProductsChart');
            if (topProductsEl) {
                new Chart(topProductsEl, {
                    type: 'bar',
                    data: {
                        labels: tpLabels,
                        datasets: [{
                                label: 'Units Sold',
                                data: tpValues,
                                backgroundColor: 'rgba(16,185,129,.75)',
                                borderColor: '#10b981',
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
            });
        </script>

        <!-- Alerts Details Modal -->
        <div id="alertsModal" class="modal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.4); backdrop-filter:blur(4px); align-items:center; justify-content:center;">
            <div style="background:#fff; border-radius:12px; max-width:600px; width:90%; padding:24px; box-shadow:0 10px 25px rgba(0,0,0,0.15); position:relative;">
                <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #e2e8f0; padding-bottom:12px; margin-bottom:16px;">
                    <h3 style="font-size:18px; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:8px; margin:0;">⚠️ Active Alerts Detail</h3>
                    <span onclick="closeAlertsModal()" style="font-size:24px; font-weight:bold; color:#94a3b8; cursor:pointer; line-height:1;">&times;</span>
                </div>
                
                <!-- Low Stock Section -->
                <div style="margin-bottom:20px;">
                    <h4 style="font-size:14px; font-weight:600; color:#475569; margin-top:0; margin-bottom:8px; display:flex; justify-content:space-between;">
                        <span>Sản phẩm sắp hết hàng</span>
                        <span style="background:#fee2e2; color:#ef4444; padding:2px 8px; border-radius:12px; font-size:11px;">${lowStockProducts.size()} items</span>
                    </h4>
                    <c:choose>
                        <c:when test="${not empty lowStockProducts}">
                            <div style="max-height:120px; overflow-y:auto; border:1px solid #e2e8f0; border-radius:8px;">
                                <table style="width:100%; border-collapse:collapse; font-size:13px; text-align:left;">
                                    <thead style="background:#f8fafc; position:sticky; top:0; z-index:1;">
                                        <tr>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; border-bottom:1px solid #e2e8f0;">Sản phẩm</th>
                                            <th style="padding:8px 12px; font-weight:600; color:#64748b; text-align:right; border-bottom:1px solid #e2e8f0;">Số lượng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${lowStockProducts}" var="p">
                                            <tr style="border-bottom:1px solid #f1f5f9; cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/staff/inventory'">
                                                <td style="padding:8px 12px; color:#1e293b;">${p.productName}</td>
                                                <td style="padding:8px 12px; color:#ef4444; font-weight:600; text-align:right;">${p.minPrice}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="color:#94a3b8; font-size:12px; padding:8px 0; border:1px dashed #e2e8f0; border-radius:8px; text-align:center;">Không có sản phẩm sắp hết hàng</div>
                        </c:otherwise>
                    </c:choose>
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
            </div>
        </div>
    </body>
</html>

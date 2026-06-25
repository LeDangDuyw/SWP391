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
            .revenue-hero .kpi-badge.mock {
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
                    <a class="active" href="${pageContext.request.contextPath}/admin/dashboard">
                        <span class="nav-icon">▦</span>Dashboard
                    </a>
                    <a href="#">
                        <span class="nav-icon">▣</span>Orders
                    </a>
                    <a href="#">
                        <span class="nav-icon">♚</span>Inventory
                    </a>
                    <a href="#">
                        <span class="nav-icon">♟</span>Users
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/promotions">
                        <span class="nav-icon">▥</span>Analytics
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/policy">
                        <span class="nav-icon">📜</span>Policies
                    </a>
                    <a href="#">
                        <span class="nav-icon">⚙</span>Settings
                    </a>
                </nav>
                <div class="profile">
                    <a href="#" class="profile-link">
                        <span class="nav-icon">●</span>Admin User Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                        Logout
                    </a>
                    <a class="active" href="AdminDashboard.jsp"><span>▦</span>Dashboard</a>
                    <a href="#"><span>▣</span>Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
                    <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
                    <a href="#"><span>⚙</span>Settings</a>
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
                        <span>Admin User Profile</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                </div>
            </aside>

            <!-- ══════════ MAIN ══════════ -->
            <div class="main">

                <!-- Topbar -->
                <div class="topbar">
                    <div class="topbar-left">
                        <span class="topbar-title">Analytics Dashboard</span>
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
                        <div class="page-title">Overview &amp; Analytics</div>
                        <div class="page-sub">Real-time business performance</div>
                    </div>

                    <!-- ══ ROW 1: KPI SUMMARY CARDS ══ -->
                    <div class="kpi-row">

                        <!-- Revenue Today — MOCK -->
                        <div class="kpi-card revenue-hero">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-white">💰</div>
                                <span class="kpi-badge mock">MOCK</span>
                            </div>
                            <div class="kpi-label">Revenue Today</div>
                            <div class="kpi-value">
                                <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/> ₫
                            </div>
                            <div class="kpi-sub">↑ 12% vs yesterday · MOCK DATA</div>
                        </div>

                        <!-- Orders Today — MOCK -->
                        <div class="kpi-card c-green">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-green">🛒</div>
                                <span class="kpi-badge mock">MOCK</span>
                            </div>
                            <div class="kpi-label">Orders Today</div>
                            <div class="kpi-value">${todayOrders}</div>
                            <div class="kpi-sub">↑ 4 orders vs yesterday</div>
                        </div>

                        <!-- New Customers — MOCK -->
                        <div class="kpi-card c-blue">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-blue">👤</div>
                                <span class="kpi-badge mock">MOCK</span>
                            </div>
                            <div class="kpi-label">New Customers</div>
                            <div class="kpi-value">${newCustomersToday}</div>
                            <div class="kpi-sub">Registered today</div>
                        </div>

                        <!-- Alerts -->
                        <div class="kpi-card c-red">
                            <div class="kpi-top">
                                <div class="kpi-icon bg-red">⚠️</div>
                                <span class="kpi-badge down">Needs attention</span>
                            </div>
                            <div class="kpi-label">Active Alerts</div>
                            <div class="kpi-value">${pendingAlerts}</div>
                            <div class="kpi-sub">Low stock &amp; pending items</div>
                        </div>
                    </div>


                    <!-- ══ ROW 2: REVENUE CHART (full width) ══ -->
                    <div class="section-hd"><span class="dot"></span>Revenue Analytics</div>

                    <div class="chart-card" style="margin-bottom:20px;">
                        <div class="chart-card-title">
                            Monthly Revenue 2026
                            <span class="mock-tag">MOCK DATA</span>
                        </div>
                        <canvas id="revenueChart" height="90"></canvas>
                    </div>

                    <!-- ══ ROW 3: Orders Status + Products by Category + Low Stock ══ -->
                    <div class="section-hd"><span class="dot"></span>Operations</div>
                    <div class="grid-3">

                        <!-- Orders by Status Doughnut — MOCK -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                Orders by Status
                                <span class="mock-tag">MOCK</span>
                            </div>
                            <canvas id="ordersChart" height="180"></canvas>
                        </div>

                        <!-- Products by Category Pie — REAL -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                Products by Category
                                <span style="font-size:10px;font-weight:600;padding:2px 6px;background:#dcfce7;color:#166534;border-radius:4px;">REAL</span>
                            </div>
                            <canvas id="categoryChart" height="180"></canvas>
                        </div>

                        <!-- Low Stock Panel — REAL -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                ⚠️ Low Stock Products
                                <span style="font-size:10px;font-weight:600;padding:2px 6px;background:#dcfce7;color:#166534;border-radius:4px;">REAL</span>
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
                                                <tr>
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

                        <!-- Top Products Horizontal Bar — MOCK -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                🏆 Top Products
                                <span class="mock-tag">MOCK</span>
                            </div>
                            <canvas id="topProductsChart" height="200"></canvas>
                        </div>

                        <!-- Top Customers Horizontal Bar — MOCK -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                👑 Top Customers
                                <span class="mock-tag">MOCK</span>
                            </div>
                            <canvas id="topCustomersChart" height="200"></canvas>
                        </div>

                        <!-- Recent Activities — MIXED -->
                        <div class="chart-card">
                            <div class="chart-card-title">
                                🕐 Recent Activities
                                <span style="font-size:10px;font-weight:500;color:#6b7280;">Mixed</span>
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

        // ── Revenue Bar Chart — MOCK DATA ────────────────────
        // MOCK DATA — Replace when Order module is implemented
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

        // ── Orders Doughnut — MOCK DATA ──────────────────────
        // MOCK DATA — Replace when Order module is implemented
            const orderLabels = [<c:forEach items="${ordersByStatus}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const orderValues = [<c:forEach items="${ordersByStatus}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];

            new Chart(document.getElementById('ordersChart'), {
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

        // ── Products by Category Pie — REAL DATA ─────────────
            const catLabels = [<c:forEach items="${productsByCategory}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const catValues = [<c:forEach items="${productsByCategory}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];
            const catColors = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16'];

            new Chart(document.getElementById('categoryChart'), {
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

        // ── Top Products Horizontal Bar — MOCK DATA ──────────
        // MOCK DATA — Replace when Order module is implemented
            const tpLabels = [<c:forEach items="${topProducts}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const tpValues = [<c:forEach items="${topProducts}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];

            new Chart(document.getElementById('topProductsChart'), {
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

        // ── Top Customers Horizontal Bar — MOCK DATA ─────────
        // MOCK DATA — Replace when Order module is implemented
            const tcLabels = [<c:forEach items="${topCustomers}" var="e" varStatus="s">'${e.key}'<c:if test="${!s.last}">,</c:if></c:forEach>];
            const tcValues = [<c:forEach items="${topCustomers}" var="e" varStatus="s">${e.value / 1000000}<c:if test="${!s.last}">,</c:if></c:forEach>];

            new Chart(document.getElementById('topCustomersChart'), {
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
        </script>
    </body>
</html>

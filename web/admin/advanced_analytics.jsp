<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Advanced Business Analytics</title>
        <!-- Chart.js CDN -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
            
            *, *::before, *::after {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, Arial, sans-serif;
            }
            
            :root {
                --primary: #2563eb;
                --primary-hover: #1d4ed8;
                --primary-light: #eff6ff;
                --success: #10b981;
                --danger: #ef4444;
                --warning: #f59e0b;
                --dark: #0f172a;
                --gray-light: #f8fafc;
                --gray-border: #cbd5e1;
                --text-muted: #64748b;
                --sidebar-bg: #eef2f7;
            }

            body {
                background: #f1f5f9;
                color: #1e293b;
                min-height: 100vh;
            }

            .layout {
                display: flex;
                min-height: 100vh;
            }

            /* ══ SIDEBAR ══ */
            .sidebar {
                width: 280px;
                background: var(--sidebar-bg);
                border-right: 1px solid #e2e8f0;
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
                color: #334155;
                font-size: 14px;
                font-weight: 500;
                display: block;
            }
            .sidebar nav {
                display: grid;
                gap: 8px;
            }
            .sidebar nav a {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 12px 14px;
                border-radius: 10px;
                color: #334155;
                font-weight: 600;
                text-decoration: none;
                font-size: 14px;
                transition: all 0.2s;
            }
            .sidebar nav a span {
                font-size: 16px;
            }
            .sidebar nav a:hover {
                background: #e2e8f0;
                color: #0f172a;
            }
            .sidebar nav a.active {
                background: #d8e8ff;
                color: #0b39d1;
            }
            .sidebar .profile {
                margin-top: auto;
                border-top: 1px solid #cbd5e1;
                padding: 18px 10px 0;
                display: grid;
                gap: 12px;
            }
            .sidebar .profile-info {
                font-size: 13px;
                font-weight: 600;
                color: #334155;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .sidebar .logout-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                color: #ef4444 !important;
                font-size: 13px;
                font-weight: 700;
                padding: 10px 14px;
                border-radius: 8px;
                background: #fef2f2;
                border: 1px solid #fecaca;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
            }
            .sidebar .logout-btn:hover {
                background: #fee2e2;
                border-color: #fca5a5;
                color: #dc2626 !important;
            }

            /* ══ MAIN AREA ══ */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                min-width: 0;
            }
            .topbar {
                background: #fff;
                border-bottom: 1px solid #e2e8f0;
                padding: 16px 28px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            .topbar-title {
                font-size: 18px;
                font-weight: 700;
                color: var(--dark);
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                background: #dcfce7;
                color: #166534;
            }
            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #16a34a;
            }

            /* ══ CONTENT & TABS ══ */
            .content {
                padding: 28px;
                overflow-y: auto;
                flex: 1;
            }
            .page-header {
                margin-bottom: 24px;
            }
            .page-title {
                font-size: 24px;
                font-weight: 800;
                color: var(--dark);
            }
            .page-sub {
                font-size: 14px;
                color: var(--text-muted);
                margin-top: 4px;
            }

            /* TAB CONTROLLER */
            .tab-nav {
                display: flex;
                gap: 8px;
                border-bottom: 1px solid var(--gray-border);
                margin-bottom: 24px;
                background: #fff;
                padding: 6px 12px 0;
                border-radius: 12px 12px 0 0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            }
            .tab-btn {
                padding: 12px 20px;
                background: none;
                border: none;
                border-bottom: 3px solid transparent;
                font-size: 14px;
                font-weight: 600;
                color: var(--text-muted);
                cursor: pointer;
                transition: all 0.2s;
            }
            .tab-btn:hover {
                color: var(--dark);
            }
            .tab-btn.active {
                color: var(--primary);
                border-bottom-color: var(--primary);
            }
            .tab-pane {
                display: none;
            }
            .tab-pane.active {
                display: block;
            }

            /* FILTER PANELS */
            .filter-panel {
                background: #fff;
                border-radius: 12px;
                padding: 20px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                margin-bottom: 24px;
            }
            .filter-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 16px;
                align-items: flex-end;
            }
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .filter-group label {
                font-size: 12px;
                font-weight: 700;
                color: #475569;
                text-transform: uppercase;
                letter-spacing: 0.02em;
            }
            .filter-input {
                padding: 8px 12px;
                border: 1px solid var(--gray-border);
                border-radius: 8px;
                font-size: 13px;
                outline: none;
                background: #fff;
                color: #1e293b;
                transition: border-color 0.15s;
                width: 100%;
            }
            .filter-input:focus {
                border-color: var(--primary);
            }
            .filter-actions {
                display: flex;
                gap: 8px;
            }
            .btn {
                padding: 9px 16px;
                font-size: 13px;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.2s;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .btn-primary {
                background: var(--primary);
                color: #fff;
            }
            .btn-primary:hover {
                background: var(--primary-hover);
            }
            .btn-secondary {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid var(--gray-border);
            }
            .btn-secondary:hover {
                background: #e2e8f0;
            }

            /* KPI BOXES */
            .kpi-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
                margin-bottom: 24px;
            }
            .kpi-box {
                background: #fff;
                border-radius: 12px;
                padding: 24px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                display: flex;
                flex-direction: column;
                gap: 8px;
                position: relative;
            }
            .kpi-box.accent-blue { border-left: 4px solid var(--primary); }
            .kpi-box.accent-green { border-left: 4px solid var(--success); }
            .kpi-box.accent-amber { border-left: 4px solid var(--warning); }
            
            .kpi-box-label {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .kpi-box-val {
                font-size: 28px;
                font-weight: 800;
                color: var(--dark);
                line-height: 1.2;
            }
            .kpi-box-sub {
                font-size: 12px;
                color: var(--text-muted);
            }

            /* CHARTS GRID */
            .charts-grid-2 {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 24px;
                margin-bottom: 24px;
            }
            @media (max-width: 1024px) {
                .charts-grid-2 {
                    grid-template-columns: 1fr;
                }
            }
            .chart-card {
                background: #fff;
                border-radius: 12px;
                padding: 24px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }
            .chart-card-hd {
                font-size: 16px;
                font-weight: 700;
                color: var(--dark);
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .chart-container {
                position: relative;
                width: 100%;
                min-height: 260px;
            }

            /* TABLES */
            .table-card {
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                overflow: hidden;
                margin-bottom: 24px;
            }
            .table-card-hd {
                padding: 20px 24px;
                background: #fff;
                border-bottom: 1px solid #e2e8f0;
                font-size: 16px;
                font-weight: 700;
                color: var(--dark);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }
            th {
                padding: 14px 24px;
                background: var(--gray-light);
                font-size: 12px;
                font-weight: 700;
                color: #475569;
                text-transform: uppercase;
                border-bottom: 1px solid #e2e8f0;
            }
            td {
                padding: 16px 24px;
                font-size: 14px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #f8fafc;
            }
            .rank-number {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                background: #f1f5f9;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 700;
                color: #475569;
            }
            tr:nth-child(1) .rank-number { background: #fef3c7; color: #d97706; }
            tr:nth-child(2) .rank-number { background: #e2e8f0; color: #475569; }
            tr:nth-child(3) .rank-number { background: #ffedd5; color: #ea580c; }

            .no-data {
                padding: 40px;
                text-align: center;
                color: var(--text-muted);
                font-size: 14px;
                font-weight: 500;
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
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- ══════════ SIDEBAR ══════════ -->
            <aside class="sidebar">
                <div class="brand">
                    <span>UNILAP Admin</span>
                    <small>System Controller</small>
                </div>
                <nav>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
                    <a href="#"><span>▣</span>Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
                    
                    <div class="sidebar-dropdown">
                        <a href="javascript:void(0)" class="sidebar-dropdown-btn active" onclick="toggleSidebarDropdown(this)" style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                            <span style="display: flex; align-items: center; gap: 14px;"><span>📊</span>Analytics</span>
                            <span class="dropdown-arrow" style="font-size: 10px; transition: transform 0.2s; transform: rotate(180deg);">▼</span>
                        </a>
                        <div class="sidebar-dropdown-container" style="display: flex; flex-direction: column; gap: 4px; margin-top: 4px;">
                            <a href="${pageContext.request.contextPath}/admin/promotions">
                                <span>▥</span>Voucher & Promotion
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/analytics" class="active">
                                <span>📈</span>Advanced Analytics
                            </a>
                        </div>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
                    <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
                    <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
                </nav>
                <div class="profile">
                    <div class="profile-info">
                        <%
                            model.Users u = (model.Users) session.getAttribute("user");
                            if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                        %>
                            <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                                 alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                        <% } else { %>
                            <span>♙</span>
                        <% } %>
                        <span>Admin Profile</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                </div>
            </aside>

            <!-- ══════════ MAIN ══════════ -->
            <div class="main">
                
                <!-- Topbar -->
                <header class="topbar">
                    <div class="topbar-title">Advanced Business Analytics</div>
                    <div class="topbar-right">
                        <span class="status-pill"><span class="status-dot"></span>System Online</span>
                    </div>
                </header>

                <div class="content">
                    <div class="page-header">
                        <h1 class="page-title">Granular Business Performance Reports</h1>
                        <p class="page-sub">Comprehensive analytical breakdowns of revenue, sales, customers, and product metrics.</p>
                    </div>

                    <!-- ══ TAB NAV CONTROLLER ══ -->
                    <div class="tab-nav">
                        <button class="tab-btn" onclick="switchTab('revenue')">💰 Revenue Analysis</button>
                        <button class="tab-btn" onclick="switchTab('sales')">🛒 Sales Analysis</button>
                        <button class="tab-btn" onclick="switchTab('customer')">👤 Customer Analytics</button>
                        <button class="tab-btn" onclick="switchTab('product')">📦 Product &amp; Inventory</button>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 1: REVENUE ANALYSIS ══ -->
                    <div id="revenue-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="revenue">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>From Date</label>
                                        <input type="date" name="revenueFrom" value="${revFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>To Date</label>
                                        <input type="date" name="revenueTo" value="${revFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Category</label>
                                        <select name="revenueCategoryId" class="filter-input">
                                            <option value="all">-- All Categories --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${revFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Brand</label>
                                        <select name="revenueBrandId" class="filter-input">
                                            <option value="all">-- All Brands --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${revFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Customer Type</label>
                                        <select name="revenueCustomerType" class="filter-input">
                                            <option value="" ${empty revFilter.customerType ? 'selected' : ''}>-- All Types --</option>
                                            <option value="new" ${revFilter.customerType == 'new' ? 'selected' : ''}>New Customer</option>
                                            <option value="returning" ${revFilter.customerType == 'returning' ? 'selected' : ''}>Returning Customer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Payment Method</label>
                                        <select name="revenuePaymentMethod" class="filter-input">
                                            <option value="" ${empty revFilter.paymentMethod ? 'selected' : ''}>-- All Methods --</option>
                                            <option value="cod" ${revFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${revFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                            <option value="momo" ${revFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${revFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Bank Transfer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Group By</label>
                                        <select name="revenueGroupBy" class="filter-input">
                                            <option value="day" ${revenueGroupBy == 'day' ? 'selected' : ''}>Day</option>
                                            <option value="month" ${revenueGroupBy == 'month' ? 'selected' : ''}>Month</option>
                                            <option value="quarter" ${revenueGroupBy == 'quarter' ? 'selected' : ''}>Quarter</option>
                                            <option value="year" ${revenueGroupBy == 'year' ? 'selected' : ''}>Year</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Apply</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=revenue" class="btn btn-secondary">Reset</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Total Revenue (Filtered)</span>
                                <span class="kpi-box-val">
                                    <c:set var="totRev" value="0"/>
                                    <c:forEach items="${revenueTrend}" var="entry">
                                        <c:set var="totRev" value="${totRev + entry.value}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totRev}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Sum of realized line-item revenue in range</span>
                            </div>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Revenue Trend Line</div>
                                <div class="chart-container">
                                    <canvas id="revenueTrendChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">🍩 Revenue Share by Category</div>
                                <div class="chart-container">
                                    <canvas id="revenueCategoryChart"></canvas>
                                </div>
                            </div>
                        </div>
                        
                        <div class="chart-card" style="margin-bottom:24px;">
                            <div class="chart-card-hd">📊 Revenue Share by Brand</div>
                            <div class="chart-container" style="min-height:220px;">
                                <canvas id="revenueBrandChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 2: SALES ANALYSIS ══ -->
                    <div id="sales-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="sales">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>From Date</label>
                                        <input type="date" name="salesFrom" value="${salesFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>To Date</label>
                                        <input type="date" name="salesTo" value="${salesFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Category</label>
                                        <select name="salesCategoryId" class="filter-input">
                                            <option value="all">-- All Categories --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${salesFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Brand</label>
                                        <select name="salesBrandId" class="filter-input">
                                            <option value="all">-- All Brands --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${salesFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Customer Type</label>
                                        <select name="salesCustomerType" class="filter-input">
                                            <option value="" ${empty salesFilter.customerType ? 'selected' : ''}>-- All Types --</option>
                                            <option value="new" ${salesFilter.customerType == 'new' ? 'selected' : ''}>New Customer</option>
                                            <option value="returning" ${salesFilter.customerType == 'returning' ? 'selected' : ''}>Returning Customer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Payment Method</label>
                                        <select name="salesPaymentMethod" class="filter-input">
                                            <option value="" ${empty salesFilter.paymentMethod ? 'selected' : ''}>-- All Methods --</option>
                                            <option value="cod" ${salesFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${salesFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                            <option value="momo" ${salesFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${salesFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Bank Transfer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Group By</label>
                                        <select name="salesGroupBy" class="filter-input">
                                            <option value="day" ${salesGroupBy == 'day' ? 'selected' : ''}>Day</option>
                                            <option value="month" ${salesGroupBy == 'month' ? 'selected' : ''}>Month</option>
                                            <option value="quarter" ${salesGroupBy == 'quarter' ? 'selected' : ''}>Quarter</option>
                                            <option value="year" ${salesGroupBy == 'year' ? 'selected' : ''}>Year</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Apply</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=sales" class="btn btn-secondary">Reset</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-green">
                                <span class="kpi-box-label">Total Orders</span>
                                <span class="kpi-box-val">
                                    <c:set var="totOrders" value="0"/>
                                    <c:forEach items="${ordersTrend}" var="entry">
                                        <c:set var="totOrders" value="${totOrders + entry.value}"/>
                                    </c:forEach>
                                    ${totOrders}
                                </span>
                                <span class="kpi-box-sub">Number of orders (valid status)</span>
                            </div>
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Average Order Value (AOV)</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${avgOrderValue}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Average transaction total amount</span>
                            </div>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Orders Volume Trend</div>
                                <div class="chart-container">
                                    <canvas id="ordersTrendChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">💳 Share by Payment Method</div>
                                <div class="chart-container">
                                    <canvas id="paymentMethodChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 3: CUSTOMER ANALYTICS ══ -->
                    <div id="customer-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="customer">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>From Date</label>
                                        <input type="date" name="customerFrom" value="${custFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>To Date</label>
                                        <input type="date" name="customerTo" value="${custFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Category</label>
                                        <select name="customerCategoryId" class="filter-input">
                                            <option value="all">-- All Categories --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${custFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Brand</label>
                                        <select name="customerBrandId" class="filter-input">
                                            <option value="all">-- All Brands --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${custFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Payment Method</label>
                                        <select name="customerPaymentMethod" class="filter-input">
                                            <option value="" ${empty custFilter.paymentMethod ? 'selected' : ''}>-- All Methods --</option>
                                            <option value="cod" ${custFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${custFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                            <option value="momo" ${custFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${custFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Bank Transfer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Group Growth By</label>
                                        <select name="customerGroupBy" class="filter-input">
                                            <option value="day" ${customerGroupBy == 'day' ? 'selected' : ''}>Day</option>
                                            <option value="month" ${customerGroupBy == 'month' ? 'selected' : ''}>Month</option>
                                            <option value="quarter" ${customerGroupBy == 'quarter' ? 'selected' : ''}>Quarter</option>
                                            <option value="year" ${customerGroupBy == 'year' ? 'selected' : ''}>Year</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Top Customers N</label>
                                        <input type="number" name="customerTopN" value="${customerTopN}" min="1" max="100" class="filter-input">
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Apply</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=customer" class="btn btn-secondary">Reset</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Cohort Customer Acquisition (Growth)</div>
                                <div class="chart-container">
                                    <canvas id="customerGrowthChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">👥 New vs Returning Customers Share</div>
                                <div class="chart-container">
                                    <canvas id="customerCohortChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Top Spending Customers table -->
                        <div class="table-card">
                            <div class="table-card-hd">🏆 Top Spending Customers (Ranked by Total Revenue)</div>
                            <c:choose>
                                <c:when test="${not empty topSpendingCustomers}">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th style="width:80px;">Rank</th>
                                                <th>Customer Name</th>
                                                <th>Email Address</th>
                                                <th>Distinct Orders</th>
                                                <th>Total Spending</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${topSpendingCustomers}" var="c" varStatus="st">
                                                <tr>
                                                    <td><span class="rank-number">${st.index + 1}</span></td>
                                                    <td style="font-weight:600;">${c[0]}</td>
                                                    <td>${c[1]}</td>
                                                    <td>${c[3]} orders</td>
                                                    <td style="font-weight:700; color:var(--primary);">
                                                        <fmt:formatNumber value="${c[2]}" pattern="#,##0"/> ₫
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">No customer spending details found.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 4: PRODUCT & INVENTORY ══ -->
                    <div id="product-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="product">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>From Date</label>
                                        <input type="date" name="productFrom" value="${prodFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>To Date</label>
                                        <input type="date" name="productTo" value="${prodFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Category</label>
                                        <select name="productCategoryId" class="filter-input">
                                            <option value="all">-- All Categories --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${prodFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Brand</label>
                                        <select name="productBrandId" class="filter-input">
                                            <option value="all">-- All Brands --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${prodFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Customer Type</label>
                                        <select name="productCustomerType" class="filter-input">
                                            <option value="" ${empty prodFilter.customerType ? 'selected' : ''}>-- All Types --</option>
                                            <option value="new" ${prodFilter.customerType == 'new' ? 'selected' : ''}>New Customer</option>
                                            <option value="returning" ${prodFilter.customerType == 'returning' ? 'selected' : ''}>Returning Customer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Payment Method</label>
                                        <select name="productPaymentMethod" class="filter-input">
                                            <option value="" ${empty prodFilter.paymentMethod ? 'selected' : ''}>-- All Methods --</option>
                                            <option value="cod" ${prodFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${prodFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                            <option value="momo" ${prodFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${prodFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Bank Transfer</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Rank limit (N)</label>
                                        <input type="number" name="productTopN" value="${productTopN}" min="1" max="100" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Rank By</label>
                                        <select name="productSortBy" class="filter-input">
                                            <option value="quantity" ${productSortBy == 'quantity' ? 'selected' : ''}>Quantity Sold</option>
                                            <option value="revenue" ${productSortBy == 'revenue' ? 'selected' : ''}>Revenue Generated</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Apply</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=product" class="btn btn-secondary">Reset</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes: Inventory Turnover -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Cost of Goods Sold (COGS)</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[0]}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Sum of import price times quantities sold</span>
                            </div>
                            <div class="kpi-box accent-amber">
                                <span class="kpi-box-label">Average Inventory Value</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[1]}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Average of beginning and ending inventory values</span>
                            </div>
                            <div class="kpi-box accent-green">
                                <span class="kpi-box-label">Inventory Turnover Ratio</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[2]}" pattern="#,##0.00"/>
                                </span>
                                <span class="kpi-box-sub">COGS divided by Average Inventory Value</span>
                            </div>
                        </div>

                        <!-- Tables: Best & Worst Selling Products -->
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:24px;">
                            <div class="table-card">
                                <div class="table-card-hd">🔥 Best Selling Products</div>
                                <c:choose>
                                    <c:when test="${not empty bestSellingProducts}">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th style="width:60px;">Rank</th>
                                                    <th>Product / Variant</th>
                                                    <th>Qty Sold</th>
                                                    <th>Revenue</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${bestSellingProducts}" var="p" varStatus="st">
                                                    <tr>
                                                        <td><span class="rank-number">${st.index + 1}</span></td>
                                                        <td>
                                                            <div style="font-weight:600;">${p[0]}</div>
                                                            <div style="font-size:12px; color:var(--text-muted);">${p[1]}</div>
                                                        </td>
                                                        <td>${p[2]} units</td>
                                                        <td style="font-weight:700; color:var(--success);">
                                                            <fmt:formatNumber value="${p[3]}" pattern="#,##0"/> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">No product sales details found.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="table-card">
                                <div class="table-card-hd">❄️ Worst Selling Products</div>
                                <c:choose>
                                    <c:when test="${not empty worstSellingProducts}">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th style="width:60px;">Rank</th>
                                                    <th>Product / Variant</th>
                                                    <th>Qty Sold</th>
                                                    <th>Revenue</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${worstSellingProducts}" var="p" varStatus="st">
                                                    <tr>
                                                        <td><span class="rank-number">${st.index + 1}</span></td>
                                                        <td>
                                                            <div style="font-weight:600;">${p[0]}</div>
                                                            <div style="font-size:12px; color:var(--text-muted);">${p[1]}</div>
                                                        </td>
                                                        <td>${p[2]} units</td>
                                                        <td style="font-weight:700; color:var(--danger);">
                                                            <fmt:formatNumber value="${p[3]}" pattern="#,##0"/> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">No product sales details found.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ════════════════════════════════════════════════════════════════════ -->
        <!-- ══ CHART.JS DRAWING SCRIPTS ══ -->
        <script>
            // Switch tabs dynamically (Vanilla JS)
            function switchTab(tabId) {
                // Clear active buttons
                document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
                // Clear active panes
                document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
                
                // Set current active
                const btn = Array.from(document.querySelectorAll('.tab-btn')).find(b => b.innerText.toLowerCase().includes(tabId));
                if (btn) btn.classList.add('active');
                
                const pane = document.getElementById(tabId + '-pane');
                if (pane) pane.classList.add('active');
            }

            // Toggle sidebar dropdown
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

            // Restore active section tab from servlet response
            window.onload = function() {
                const activeSec = "${activeSection}";
                switchTab(activeSec);
            };

            // ── REVENUE ANALYSIS DATA BINDINGS ──
            const revLabels = [];
            const revData = [];
            <c:forEach items="${revenueTrend}" var="entry">
                revLabels.push("${entry.key}");
                revData.push(${entry.value});
            </c:forEach>

            const catLabels = [];
            const catData = [];
            <c:forEach items="${revenueByCategory}" var="entry">
                catLabels.push("${entry.key}");
                catData.push(${entry.value});
            </c:forEach>

            const brandLabels = [];
            const brandData = [];
            <c:forEach items="${revenueByBrand}" var="entry">
                brandLabels.push("${entry.key}");
                brandData.push(${entry.value});
            </c:forEach>

            // Draw Revenue Line Chart
            new Chart(document.getElementById('revenueTrendChart'), {
                type: 'line',
                data: {
                    labels: revLabels,
                    datasets: [{
                        label: 'Net Sales Revenue (₫)',
                        data: revData,
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37,99,235,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35,
                        pointBackgroundColor: '#1d4ed8',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Category Pie/Doughnut Chart
            new Chart(document.getElementById('revenueCategoryChart'), {
                type: 'doughnut',
                data: {
                    labels: catLabels,
                    datasets: [{
                        data: catData,
                        backgroundColor: ['#2563eb', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            // Draw Brand Bar Chart
            new Chart(document.getElementById('revenueBrandChart'), {
                type: 'bar',
                data: {
                    labels: brandLabels,
                    datasets: [{
                        label: 'Revenue (₫)',
                        data: brandData,
                        backgroundColor: 'rgba(37,99,235,0.85)',
                        borderColor: '#2563eb',
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // ── SALES ANALYSIS DATA BINDINGS ──
            const salesLabels = [];
            const salesData = [];
            <c:forEach items="${ordersTrend}" var="entry">
                salesLabels.push("${entry.key}");
                salesData.push(${entry.value});
            </c:forEach>

            const payLabels = [];
            const payData = [];
            <c:forEach items="${salesByPaymentMethod}" var="entry">
                payLabels.push("${entry.key}");
                payData.push(${entry.value});
            </c:forEach>

            // Draw Orders Trend Line
            new Chart(document.getElementById('ordersTrendChart'), {
                type: 'line',
                data: {
                    labels: salesLabels,
                    datasets: [{
                        label: 'Order Volume',
                        data: salesData,
                        borderColor: '#10b981',
                        backgroundColor: 'rgba(16,185,129,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: '#047857',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Payment Method Bar
            new Chart(document.getElementById('paymentMethodChart'), {
                type: 'bar',
                data: {
                    labels: payLabels,
                    datasets: [{
                        label: 'Order Count',
                        data: payData,
                        backgroundColor: ['#6366f1', '#ec4899', '#f59e0b', '#3b82f6'],
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // ── CUSTOMER ANALYSIS DATA BINDINGS ──
            const growthLabels = [];
            const growthData = [];
            <c:forEach items="${customerGrowth}" var="entry">
                growthLabels.push("${entry.key}");
                growthData.push(${entry.value});
            </c:forEach>

            const cohortLabels = [];
            const cohortCounts = [];
            <c:forEach items="${newVsReturningCustomers}" var="entry">
                cohortLabels.push("${entry.key}");
                cohortCounts.push(${entry.value[0]}); // customerCount index 0
            </c:forEach>

            // Draw Customer Growth Line Chart
            new Chart(document.getElementById('customerGrowthChart'), {
                type: 'line',
                data: {
                    labels: growthLabels,
                    datasets: [{
                        label: 'Acquisition Count',
                        data: growthData,
                        borderColor: '#8b5cf6',
                        backgroundColor: 'rgba(139,92,246,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35,
                        pointBackgroundColor: '#6d28d9',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Customer Cohort Share Doughnut
            new Chart(document.getElementById('customerCohortChart'), {
                type: 'doughnut',
                data: {
                    labels: cohortLabels,
                    datasets: [{
                        data: cohortCounts,
                        backgroundColor: ['#3b82f6', '#f43f5e'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        </script>
    </body>
</html>

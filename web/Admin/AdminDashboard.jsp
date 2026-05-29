<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>UNILAP Admin – Overview Dashboard</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>

    <style>
        /* ═══════════════════════════════════════════════════
           Design tokens
        ═══════════════════════════════════════════════════ */
        :root {
            --sidebar-w:   230px;
            --blue:        #1d6ff3;
            --blue-light:  #e8f0fe;
            --red-soft:    #fff0f0;
            --red-border:  #e53e3e;
            --amber-soft:  #fffbea;
            --amber-border:#d69e2e;
            --green:       #22c55e;
            --yellow:      #f59e0b;
            --pink:        #ef4444;
            --gray-100:    #f4f6fb;
            --gray-200:    #e2e8f0;
            --gray-500:    #718096;
            --gray-700:    #374151;
            --sidebar-bg:  #ffffff;
            --body-bg:     #f4f6fb;
            --card-bg:     #ffffff;
            --text:        #1a202c;
            --text-muted:  #718096;
        }

        /* ═══════════════════════════════════════════════════
           Base
        ═══════════════════════════════════════════════════ */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: var(--body-bg);
            color: var(--text);
            display: flex;
            min-height: 100vh;
        }

       /*
        Side bar
       */
        .sidebar {
            width: var(--sidebar-w);
            background: var(--sidebar-bg);
            border-right: 1px solid var(--gray-200);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0; bottom: 0;
            z-index: 100;
            padding: 24px 0;
        }
        .sidebar-brand {
            padding: 0 20px 24px;
        }
        .sidebar-brand h2 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--blue);
            letter-spacing: -.3px;
        }
        .sidebar-brand small {
            font-size: .72rem;
            color: var(--text-muted);
        }
        .sidebar nav { flex: 1; }
        .sidebar nav a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            font-size: .875rem;
            font-weight: 500;
            color: var(--gray-700);
            text-decoration: none;
            border-radius: 8px;
            margin: 2px 10px;
            transition: background .15s, color .15s;
        }
        .sidebar nav a:hover  { background: var(--gray-100); }
        .sidebar nav a.active { background: var(--blue-light); color: var(--blue); }
        .sidebar nav a i { font-size: 1rem; }
        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: .8rem;
            color: var(--gray-700);
        }
        .avatar-sm {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: var(--blue);
            color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: .8rem;
        }

        /* ═══════════════════════════════════════════════════
           Top-bar
        ═══════════════════════════════════════════════════ */
        .topbar {
            position: fixed;
            top: 0; left: var(--sidebar-w); right: 0;
            height: 60px;
            background: #fff;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            padding: 0 28px;
            gap: 12px;
            z-index: 99;
        }
        .search-box {
            flex: 1; max-width: 340px;
            display: flex; align-items: center;
            background: var(--gray-100);
            border-radius: 8px;
            padding: 0 14px;
            gap: 8px;
        }
        .search-box input {
            border: none; background: transparent;
            font-size: .85rem; width: 100%; padding: 8px 0;
            outline: none; color: var(--text);
        }
        .topbar-actions { margin-left: auto; display: flex; align-items: center; gap: 16px; }
        .icon-btn {
            background: none; border: none; cursor: pointer;
            font-size: 1.1rem; color: var(--gray-700); position: relative;
            padding: 4px;
        }
        .badge-dot {
            position: absolute; top: 0; right: 0;
            width: 8px; height: 8px;
            background: var(--red-border);
            border-radius: 50%;
            border: 1.5px solid #fff;
        }
        .user-avatar {
            width: 34px; height: 34px;
            border-radius: 50%;
            background: var(--gray-200);
            overflow: hidden; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
        }
        .user-avatar i { font-size: 1.3rem; color: var(--gray-500); }

        /* ═══════════════════════════════════════════════════
           Main content
        ═══════════════════════════════════════════════════ */
        .main {
            margin-left: var(--sidebar-w);
            margin-top: 60px;
            padding: 28px;
            flex: 1;
            display: grid;
            grid-template-columns: 1fr 320px;
            grid-template-rows: auto auto auto;
            gap: 20px;
            align-items: start;
        }

        /* ═══════════════════════════════════════════════════
           Page header
        ═══════════════════════════════════════════════════ */
        .page-header {
            grid-column: 1 / -1;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
        }
        .page-header h1 { font-size: 1.55rem; font-weight: 700; letter-spacing: -.4px; }
        .page-header p  { font-size: .85rem; color: var(--text-muted); margin-top: 2px; }
        .btn-new {
            display: inline-flex; align-items: center; gap: 6px;
            background: var(--blue); color: #fff;
            border: none; border-radius: 8px;
            padding: 9px 18px; font-size: .875rem; font-weight: 600;
            cursor: pointer; white-space: nowrap;
            transition: background .15s;
        }
        .btn-new:hover { background: #1559d6; }

        /* ═══════════════════════════════════════════════════
           KPI stat cards
        ═══════════════════════════════════════════════════ */
        .stat-row {
            grid-column: 1 / -1;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--gray-200);
            border-radius: 12px;
            padding: 20px;
            display: flex; align-items: center; gap: 14px;
        }
        .stat-icon {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
        }
        .stat-icon.blue   { background: var(--blue-light);  color: var(--blue); }
        .stat-icon.green  { background: #dcfce7;            color: #16a34a; }
        .stat-icon.yellow { background: #fef9c3;            color: #ca8a04; }
        .stat-icon.red    { background: #fee2e2;            color: #dc2626; }
        .stat-info label { font-size: .72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: .5px; }
        .stat-info .val  { font-size: 1.35rem; font-weight: 700; line-height: 1.2; }

        /* ═══════════════════════════════════════════════════
           Card generic
        ═══════════════════════════════════════════════════ */
        .card {
            background: var(--card-bg);
            border: 1px solid var(--gray-200);
            border-radius: 12px;
            overflow: hidden;
        }
        .card-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 20px;
            border-bottom: 1px solid var(--gray-200);
        }
        .card-title {
            display: flex; align-items: center; gap: 8px;
            font-size: .95rem; font-weight: 700;
        }
        .card-title i { color: var(--blue); }
        .link-view { font-size: .82rem; color: var(--blue); text-decoration: none; font-weight: 500; }

        /* ═══════════════════════════════════════════════════
           Orders table
        ═══════════════════════════════════════════════════ */
        .tbl { width: 100%; border-collapse: collapse; }
        .tbl thead th {
            background: var(--text);
            color: #fff;
            font-size: .75rem;
            font-weight: 600;
            padding: 10px 16px;
            text-align: left;
        }
        .tbl tbody tr { border-bottom: 1px solid var(--gray-200); }
        .tbl tbody tr:last-child { border-bottom: none; }
        .tbl tbody tr:hover { background: var(--gray-100); }
        .tbl tbody td {
            padding: 12px 16px;
            font-size: .83rem;
            vertical-align: middle;
        }
        .tbl .order-id  { color: var(--text-muted); font-size: .78rem; }
        .tbl .customer  { font-weight: 600; }
        .tbl .product   { color: var(--text-muted); }

        /* Status badges */
        .badge-status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: .72rem;
            font-weight: 600;
        }
        .s-processing    { background: #dbeafe; color: #1d4ed8; }
        .s-pending       { background: #fef3c7; color: #92400e; }
        .s-payment-failed{ background: #fee2e2; color: #991b1b; }
        .s-shipped       { background: #ede9fe; color: #5b21b6; }
        .s-delivered     { background: #d1fae5; color: #065f46; }

        /* ═══════════════════════════════════════════════════
           Revenue chart
        ═══════════════════════════════════════════════════ */
        .chart-wrap { padding: 16px 20px 20px; }

        /* ═══════════════════════════════════════════════════
           Right column – stacks vertically
        ═══════════════════════════════════════════════════ */
        .right-col {
            grid-column: 2;
            grid-row: 3 / 5;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* ═══════════════════════════════════════════════════
           AI Security Alerts card
        ═══════════════════════════════════════════════════ */
        .alerts-card { border-top: 3px solid var(--red-border); }
        .alerts-count {
            background: #fee2e2;
            color: var(--red-border);
            font-size: .72rem; font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
        }
        .alert-item {
            display: flex; gap: 12px;
            padding: 14px 18px;
            border-bottom: 1px solid var(--gray-200);
        }
        .alert-item:last-of-type { border-bottom: none; }
        .alert-icon {
            width: 34px; height: 34px; flex-shrink: 0;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: .95rem;
        }
        .ai-high   { background: #fee2e2; color: #dc2626; }
        .ai-medium { background: #fef9c3; color: #ca8a04; }
        .ai-low    { background: #dcfce7; color: #16a34a; }
        .alert-body h6 { font-size: .82rem; font-weight: 600; margin-bottom: 3px; }
        .alert-body p  { font-size: .76rem; color: var(--text-muted); line-height: 1.45; margin-bottom: 4px; }
        .alert-time    { font-size: .7rem; color: var(--text-muted); }
        .btn-review {
            display: block; width: calc(100% - 36px);
            margin: 12px 18px;
            background: var(--gray-100); border: 1px solid var(--gray-200);
            border-radius: 8px; padding: 9px;
            font-size: .82rem; font-weight: 600; cursor: pointer;
            transition: background .15s;
        }
        .btn-review:hover { background: var(--gray-200); }

        /* ═══════════════════════════════════════════════════
           Live Promotions
        ═══════════════════════════════════════════════════ */
        .promo-item { padding: 14px 18px; }
        .promo-item + .promo-item { border-top: 1px solid var(--gray-200); }
        .promo-row { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
        .promo-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--blue); }
        .promo-name { font-size: .85rem; font-weight: 600; flex: 1; }
        .promo-badge {
            background: var(--gray-100); border: 1px solid var(--gray-200);
            font-size: .65rem; font-weight: 700;
            padding: 2px 7px; border-radius: 4px;
            letter-spacing: .5px;
            color: var(--gray-700);
        }
        .promo-label { font-size: .72rem; color: var(--text-muted); margin-bottom: 4px; }
        .promo-progress-wrap {
            display: flex; align-items: center; gap: 8px;
        }
        .promo-bar-bg {
            flex: 1; height: 6px; background: var(--gray-200);
            border-radius: 99px; overflow: hidden;
        }
        .promo-bar-fill { height: 100%; border-radius: 99px; background: var(--blue); }
        .promo-count { font-size: .72rem; color: var(--text-muted); white-space: nowrap; }

        /* ═══════════════════════════════════════════════════
           Responsive
        ═══════════════════════════════════════════════════ */
        @media (max-width: 1100px) {
            .main { grid-template-columns: 1fr; }
            .right-col { grid-column: 1; grid-row: auto; }
            .stat-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main, .topbar { left: 0; margin-left: 0; }
            .topbar { left: 0; }
            .stat-row { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 480px) {
            .stat-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- ══════════════════════════════════════════
     SIDEBAR
══════════════════════════════════════════ -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <h2>UNILAP Admin</h2>
        <small>System Controller</small>
    </div>

    <nav>
        <a href="#" class="active"><i class="bi bi-grid-1x2"></i> Dashboard</a>
        <a href="#"><i class="bi bi-bag"></i> Orders</a>
        <a href="#"><i class="bi bi-archive"></i> Inventory</a>
        <a href="#"><i class="bi bi-people"></i> Users</a>
        <a href="#"><i class="bi bi-bar-chart"></i> Analytics</a>
        <a href="#"><i class="bi bi-gear"></i> Settings</a>
    </nav>

    <div class="sidebar-footer">
        <div class="avatar-sm">A</div>
        <span>Admin User Profile</span>
    </div>
</aside>

<!-- ══════════════════════════════════════════
     TOP BAR
══════════════════════════════════════════ -->
<header class="topbar">
    <div class="search-box">
        <i class="bi bi-search" style="color:var(--gray-500);font-size:.85rem;"></i>
        <input type="text" placeholder="Search orders, serials…"/>
    </div>
    <div class="topbar-actions">
        <button class="icon-btn" title="Notifications">
            <i class="bi bi-bell"></i>
            <c:if test="${activeAlertCount > 0}">
                <span class="badge-dot"></span>
            </c:if>
        </button>
        <button class="icon-btn" title="Help"><i class="bi bi-question-circle"></i></button>
        <div class="user-avatar"><i class="bi bi-person-circle"></i></div>
    </div>
</header>

<!-- ══════════════════════════════════════════
     MAIN GRID
══════════════════════════════════════════ -->
<main class="main">

    <!-- Page header -->
    <div class="page-header">
        <div>
            <h1>Overview Dashboard</h1>
            <p>Real-time telemetry and operational status.</p>
        </div>
        <button class="btn-new">
            <i class="bi bi-plus-lg"></i> New Campaign
        </button>
    </div>

    <!-- ── KPI STAT CARDS ───────────────────── -->
    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-icon blue"><i class="bi bi-bag-check"></i></div>
            <div class="stat-info">
                <label>Total Orders</label>
                <div class="val">${summary.totalOrders}</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="bi bi-currency-dollar"></i></div>
            <div class="stat-info">
                <label>Total Revenue</label>
                <div class="val">
                    $<fmt:formatNumber value="${summary.totalRevenue}" pattern="#,##0.00"/>
                </div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon yellow"><i class="bi bi-people"></i></div>
            <div class="stat-info">
                <label>Customers</label>
                <div class="val">${summary.totalCustomers}</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red"><i class="bi bi-shield-exclamation"></i></div>
            <div class="stat-info">
                <label>Active Alerts</label>
                <div class="val">${summary.activeAlerts}</div>
            </div>
        </div>
    </div>

    <!-- ── LEFT COLUMN (col 1 of grid row 3) ── -->
    <div style="display:flex;flex-direction:column;gap:20px;">

        <!-- RECENT ORDERS -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <i class="bi bi-cart3"></i> Recent Orders
                </div>
                <a href="#" class="link-view">View All</a>
            </div>
            <div style="overflow-x:auto;">
                <table class="tbl">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Product</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="order-id">${o.orderCode}</td>
                                <td class="customer">${o.customerName}</td>
                                <td class="product">${o.productName}</td>
                                <td>
                                    $<fmt:formatNumber value="${o.amount}" pattern="#,##0.00"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 'Processing'}">
                                            <span class="badge-status s-processing">Processing</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Pending'}">
                                            <span class="badge-status s-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Payment Failed'}">
                                            <span class="badge-status s-payment-failed">Payment Failed</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Shipped'}">
                                            <span class="badge-status s-shipped">Shipped</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Delivered'}">
                                            <span class="badge-status s-delivered">Delivered</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status">${o.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="5" style="text-align:center;padding:24px;color:var(--text-muted);">
                                    No orders found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- REVENUE CHART -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <i class="bi bi-graph-up-arrow"></i> Monthly Revenue
                </div>
                <span style="font-size:.78rem;color:var(--text-muted);">${fn:substring(pageContext.response.locale.language,0,0)}${pageContext.response.contentType != null ? 'This Year' : 'This Year'}</span>
            </div>
            <div class="chart-wrap">
                <canvas id="revenueChart" height="120"></canvas>
            </div>
        </div>

    </div><!-- /left column -->

    <!-- ── RIGHT COLUMN ─────────────────────── -->
    <div class="right-col">

        <!-- AI SECURITY ALERTS -->
        <div class="card alerts-card">
            <div class="card-header">
                <div class="card-title">
                    <i class="bi bi-shield-fill-exclamation" style="color:#dc2626;"></i>
                    AI Security Alerts
                </div>
                <span class="alerts-count">${activeAlertCount} Active</span>
            </div>

            <c:forEach var="a" items="${alerts}">
                <div class="alert-item">
                    <div class="alert-icon
                        <c:choose>
                            <c:when test="${a.severity == 'High'}">ai-high</c:when>
                            <c:when test="${a.severity == 'Medium'}">ai-medium</c:when>
                            <c:otherwise>ai-low</c:otherwise>
                        </c:choose>
                    ">
                        <c:choose>
                            <c:when test="${a.severity == 'High'}">
                                <i class="bi bi-slash-circle"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-exclamation-triangle"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="alert-body">
                        <h6>${a.alertType}</h6>
                        <p>${a.description}</p>
                        <span class="alert-time">${a.timeAgo}</span>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty alerts}">
                <p style="padding:16px 18px;color:var(--text-muted);font-size:.82rem;">
                    No active alerts.
                </p>
            </c:if>

            <button class="btn-review">
                <i class="bi bi-journal-text me-1"></i> Review AI Logs
            </button>
        </div>

        <!-- LIVE PROMOTIONS -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">
                    <i class="bi bi-megaphone"></i> Live Promotions
                </div>
            </div>

            <c:forEach var="p" items="${promos}">
                <div class="promo-item">
                    <div class="promo-row">
                        <span class="promo-dot"></span>
                        <span class="promo-name">${p.promoName}</span>
                        <span class="promo-badge">${p.discount}</span>
                    </div>
                    <p class="promo-label">
                        Redemptions &nbsp;&nbsp;
                        <strong>
                            <fmt:formatNumber value="${p.redemptions}" pattern="#,###"/>
                            /
                            <fmt:formatNumber value="${p.maxRedemptions}" pattern="#,###"/>
                        </strong>
                    </p>
                    <div class="promo-progress-wrap">
                        <div class="promo-bar-bg">
                            <div class="promo-bar-fill"
                                 style="width:${(p.redemptions / p.maxRedemptions) * 100}%;">
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty promos}">
                <p style="padding:16px 18px;color:var(--text-muted);font-size:.82rem;">
                    No active promotions.
                </p>
            </c:if>
        </div>

    </div><!-- /right-col -->

</main><!-- /main -->

<!-- ══════════════════════════════════════════
     SCRIPTS
══════════════════════════════════════════ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>

<script>
(function () {
    'use strict';

    /* ── Chart.js data injected by servlet ── */
    const labels = ${chartLabels};
    const data   = ${chartData};

    const ctx = document.getElementById('revenueChart');
    if (!ctx) return;

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Revenue ($)',
                data: data,
                borderColor: '#1d6ff3',
                backgroundColor: 'rgba(29,111,243,0.08)',
                borderWidth: 2.5,
                pointBackgroundColor: '#1d6ff3',
                pointRadius: 4,
                pointHoverRadius: 6,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: ctx => ' $' + ctx.parsed.y.toLocaleString('en-US', { minimumFractionDigits: 2 })
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 11 } }
                },
                y: {
                    grid: { color: '#e2e8f0' },
                    ticks: {
                        font: { size: 11 },
                        callback: v => '$' + (v / 1000).toFixed(0) + 'k'
                    }
                }
            }
        }
    });
})();
</script>

</body>
</html>

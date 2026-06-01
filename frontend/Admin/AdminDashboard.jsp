<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNILAP Admin — Console</title>
    <style>
        *, *::before, *::after {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }
        body { background: #f0f2f5; color: #111; }
        a { text-decoration: none; color: inherit; }

        /* ── Layout ── */
        .layout { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 240px; flex-shrink: 0;
            background: #fff;
            border-right: 1px solid #e5e7eb;
            display: flex; flex-direction: column;
        }
        .sidebar-brand {
            padding: 24px 20px 16px;
            display: flex; align-items: center; gap: 12px;
        }
        .brand-avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: #2563eb; color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 15px;
        }
        .brand-text .brand-name { font-weight: 700; font-size: 15px; color: #2563eb; }
        .brand-text .brand-role { font-size: 12px; color: #6b7280; margin-top: 2px; }

        .sidebar-nav { list-style: none; flex: 1; padding: 8px 0; }
        .sidebar-nav li a {
            display: flex; align-items: center; gap: 10px;
            padding: 11px 20px; font-size: 14px; color: #374151;
            border-radius: 6px; margin: 2px 8px;
            transition: background .15s;
        }
        .sidebar-nav li a:hover { background: #f3f4f6; }
        .sidebar-nav li.active a {
            background: #dbeafe; color: #1d4ed8; font-weight: 600;
        }
        .sidebar-nav li a .nav-icon { width: 18px; text-align: center; }

        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid #e5e7eb;
        }
        .sidebar-footer a {
            display: flex; align-items: center; gap: 10px;
            font-size: 14px; color: #6b7280;
        }
        .sidebar-footer a:hover { color: #111; }

        /* ── Main ── */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

        /* Topbar */
        .topbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            padding: 14px 28px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .topbar-title { font-size: 18px; font-weight: 700; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .icon-btn {
            background: none; border: none; cursor: pointer;
            width: 36px; height: 36px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #6b7280; font-size: 16px;
            transition: background .15s;
        }
        .icon-btn:hover { background: #f3f4f6; }

        /* Breadcrumb */
        .breadcrumb {
            padding: 14px 28px 0;
            font-size: 13px; color: #6b7280;
            display: flex; align-items: center; gap: 6px;
        }
        .breadcrumb a { color: #6b7280; }
        .breadcrumb a:hover { color: #2563eb; }
        .breadcrumb .sep { color: #d1d5db; }
        .breadcrumb .current { color: #111; font-weight: 500; }

        /* Content */
        .content { padding: 24px 28px; overflow-y: auto; flex: 1; }

        .page-title { font-size: 26px; font-weight: 700; margin-bottom: 4px; }
        .page-sub { font-size: 14px; color: #6b7280; margin-bottom: 28px; }

        /* KPI Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px; margin-bottom: 30px;
        }
        .kpi-card {
            background: #fff; border-radius: 12px;
            padding: 22px 24px;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
        }
        .kpi-card .kpi-label {
            font-size: 13px; color: #6b7280; font-weight: 500; margin-bottom: 8px;
        }
        .kpi-card .kpi-value {
            font-size: 30px; font-weight: 700; color: #111;
        }
        .kpi-card .kpi-sub {
            font-size: 12px; color: #9ca3af; margin-top: 4px;
        }

        /* Table card */
        .table-card {
            background: #fff; border-radius: 12px;
            box-shadow: 0 1px 4px rgba(0,0,0,.06); overflow: hidden;
        }
        .table-card-header {
            padding: 20px 24px;
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid #e5e7eb;
        }
        .table-card-header h2 { font-size: 16px; font-weight: 700; }
        .table-card-header .view-all {
            font-size: 13px; color: #2563eb; cursor: pointer;
        }

        table { width: 100%; border-collapse: collapse; }
        thead { background: #111827; color: #fff; }
        th { padding: 13px 18px; text-align: left; font-size: 13px; font-weight: 600; }
        td { padding: 14px 18px; font-size: 14px; border-bottom: 1px solid #f3f4f6; }
        tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: #f9fafb; }

        .badge {
            display: inline-block; padding: 3px 9px; border-radius: 20px;
            font-size: 11px; font-weight: 600; letter-spacing: .4px;
        }
        .badge-live    { background: #dcfce7; color: #166534; }
        .badge-draft   { background: #fef9c3; color: #854d0e; }
        .badge-disabled{ background: #f3f4f6; color: #6b7280; }

        .empty-row td {
            text-align: center; color: #9ca3af; padding: 40px;
        }

        @media (max-width: 900px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .sidebar { display: none; }
        }
    </style>
</head>
<body>

<div class="layout">

    <!-- ══════ SIDEBAR ══════ -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-avatar">UA</div>
            <div class="brand-text">
                <div class="brand-name">UNILAP Admin</div>
                <div class="brand-role">System Controller</div>
            </div>
        </div>

        <ul class="sidebar-nav">
            <li class="active">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <span class="nav-icon">⊞</span> Dashboard
                </a>
            </li>
            <li>
                <a href="#">
                    <span class="nav-icon">📦</span> Orders
                </a>
            </li>
            <li>
                <a href="#">
                    <span class="nav-icon">▤</span> Inventory
                </a>
            </li>
            <li>
                <a href="#">
                    <span class="nav-icon">👥</span> Users
                </a>
            </li>
            <li>
                <a href="#">
                    <span class="nav-icon">📊</span> Analytics
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/policy">
                    <span class="nav-icon">⚙</span> Settings
                </a>
            </li>
        </ul>

        <div class="sidebar-footer">
            <a href="#">↩ Logout</a>
        </div>
    </aside>

    <!-- ══════ MAIN ══════ -->
    <div class="main">

        <!-- Topbar -->
        <div class="topbar">
            <span class="topbar-title">Console</span>
            <div class="topbar-right">
                <button class="icon-btn" title="Notifications">🔔</button>
                <button class="icon-btn" title="Help">?</button>
            </div>
        </div>

        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        </div>

        <!-- Content -->
        <div class="content">

            <div class="page-title">Overview Dashboard</div>
            <div class="page-sub">System overview and statistics</div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-label">Total Users</div>
                    <div class="kpi-value">${summary != null ? summary.totalUsers : 0}</div>
                    <div class="kpi-sub">Registered accounts</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Total Orders</div>
                    <div class="kpi-value">${summary != null ? summary.totalOrders : 0}</div>
                    <div class="kpi-sub">All time orders</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Total Products</div>
                    <div class="kpi-value">${summary != null ? summary.totalProducts : 0}</div>
                    <div class="kpi-sub">Active listings</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Total Policies</div>
                    <div class="kpi-value">${summary != null ? summary.totalPolicies : 0}</div>
                    <div class="kpi-sub">Warranty policies</div>
                </div>
            </div>

            <!-- Recent Orders Table -->
            <div class="table-card">
                <div class="table-card-header">
                    <h2>Recent Orders</h2>
                    <span class="view-all" onclick="location.href='#'">View all</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentOrders}">
                                <c:forEach items="${recentOrders}" var="o">
                                    <tr>
                                        <td>#${o.orderId}</td>
                                        <td>${o.customerName}</td>
                                        <td>$<fmt:formatNumber value="${o.amount}" pattern="#,##0.00"/></td>
                                        <td>
                                            <span class="badge
                                                <c:choose>
                                                    <c:when test='${o.status eq "LIVE"}'>badge-live</c:when>
                                                    <c:when test='${o.status eq "DRAFT"}'>badge-draft</c:when>
                                                    <c:otherwise>badge-disabled</c:otherwise>
                                                </c:choose>
                                            ">${o.status}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="empty-row">
                                    <td colspan="4">No recent orders found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </div><!-- /content -->
    </div><!-- /main -->

</div><!-- /layout -->

</body>
</html>

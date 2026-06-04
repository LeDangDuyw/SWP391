<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Console</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
            *, *::before, *::after {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family: Inter, Arial, sans-serif;
            }
            body {
                background:#f5f7fb;
                color:#171a22;
                letter-spacing: .04em;
            }
            a {
                text-decoration:none;
                color:inherit;
            }
            .layout {
                display:flex;
                min-height:100vh;
            }

            /* Sidebar */
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
            .sidebar .brand { margin: 6px 10px 44px; display: grid; gap: 6px; }
            .sidebar .brand span { color: #0b39d1; font-size: 24px; font-weight: 800; letter-spacing: .05em; display: block; }
            .sidebar .brand small { color: #343a46; font-size: 14px; display: block; }
            .sidebar nav { display: grid; gap: 10px; }
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
            .sidebar nav a span { min-width: 20px; color: #1f2937; font-size: 16px; }
            .sidebar nav a:hover { background: #f3f4f6; }
            .sidebar nav a.active { background: #d8e8ff; color: #0b39d1; }
            .sidebar .profile {
                margin-top: auto;
                border-top: 1px solid #d4dae6;
                padding: 18px 10px 0;
                display: grid;
                gap: 12px;
                font-weight: 700;
            }
            .logout-btn {
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
                text-decoration: none;
            }
            .logout-btn:hover {
                background: #fee2e2;
                border-color: #fca5a5;
                color: #dc2626 !important;
            }

            /* Main */
            .main {
                flex:1;
                display:flex;
                flex-direction:column;
                overflow:hidden;
            }
            .topbar {
                background:#fff;
                border-bottom:1px solid #e5e7eb;
                padding:14px 28px;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .topbar-title {
                font-size:18px;
                font-weight:700;
            }
            .topbar-right {
                display:flex;
                align-items:center;
                gap:16px;
            }
            .icon-btn {
                background:none;
                border:none;
                cursor:pointer;
                width:36px;
                height:36px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#6b7280;
                font-size:16px;
            }
            .icon-btn:hover {
                background:#f3f4f6;
            }
            .breadcrumb {
                padding:14px 28px 0;
                font-size:13px;
                color:#6b7280;
                display:flex;
                align-items:center;
                gap:6px;
            }
            .content {
                padding:24px 28px;
                overflow-y:auto;
                flex:1;
            }
            .page-title {
                font-size:26px;
                font-weight:700;
                margin-bottom:4px;
            }
            .page-sub {
                font-size:14px;
                color:#6b7280;
                margin-bottom:28px;
            }

            /* KPI Cards */
            .kpi-grid {
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:20px;
                margin-bottom:30px;
            }
            .kpi-card {
                background:#fff;
                border-radius:12px;
                padding:22px 24px;
                box-shadow:0 1px 4px rgba(0,0,0,.06);
            }
            .kpi-card .kpi-label {
                font-size:13px;
                color:#6b7280;
                font-weight:500;
                margin-bottom:8px;
            }
            .kpi-card .kpi-value {
                font-size:30px;
                font-weight:700;
                color:#111;
            }
            .kpi-card .kpi-sub {
                font-size:12px;
                color:#9ca3af;
                margin-top:4px;
            }

            /* Table */
            .table-card {
                background:#fff;
                border-radius:12px;
                box-shadow:0 1px 4px rgba(0,0,0,.06);
                overflow:hidden;
            }
            .table-card-header {
                padding:20px 24px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                border-bottom:1px solid #e5e7eb;
            }
            .table-card-header h2 {
                font-size:16px;
                font-weight:700;
            }
            table {
                width:100%;
                border-collapse:collapse;
            }
            thead {
                background:#111827;
                color:#fff;
            }
            th {
                padding:13px 18px;
                text-align:left;
                font-size:13px;
                font-weight:600;
            }
            td {
                padding:14px 18px;
                font-size:14px;
                border-bottom:1px solid #f3f4f6;
            }
            tr:last-child td {
                border-bottom:none;
            }
            tbody tr:hover {
                background:#f9fafb;
            }
            .badge {
                display:inline-block;
                padding:3px 9px;
                border-radius:20px;
                font-size:11px;
                font-weight:600;
            }
            .badge-live    {
                background:#dcfce7;
                color:#166534;
            }
            .badge-draft   {
                background:#fef9c3;
                color:#854d0e;
            }
            .badge-disabled{
                background:#f3f4f6;
                color:#6b7280;
            }
            .empty-row td {
                text-align:center;
                color:#9ca3af;
                padding:40px;
            }

            @media (max-width: 1100px) {
                .sidebar { width: 220px; }
                .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            }
            @media (max-width: 760px) {
                .layout { display: block; }
                .sidebar { position: static; width: 100%; height: auto; }
                .kpi-grid { grid-template-columns: 1fr; }
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <aside class="sidebar">
                <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
                <nav>
                    <a class="active" href="AdminDashboard.jsp"><span>▦</span>Dashboard</a>
                    <a href="#"><span>▣</span>Orders</a>
                    <a href="#"><span>♚</span>Users</a>
                    <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                    <a href="#"><span>⚙</span>Settings</a>
                </nav>
                <div class="profile">
                    <div>♙ <span>Admin User Profile</span></div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                </div>
            </aside>

            <div class="main">
                <div class="topbar">
                    <span class="topbar-title">Console</span>
                    <div class="topbar-right">
                        <button class="icon-btn" title="Notifications">&#128276;</button>
                        <button class="icon-btn" title="Help">?</button>
                    </div>
                </div>

                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                </div>

                <div class="content">
                    <div class="page-title">Overview Dashboard</div>
                    <div class="page-sub">System overview and statistics</div>

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

                    <div class="table-card">
                        <div class="table-card-header">
                            <h2>Recent Orders</h2>
                            <span style="font-size:13px;color:#2563eb;cursor:pointer">View all</span>
                        </div>
                        <table>
                            <thead>
                                <tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Status</th></tr>
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
                                                          </c:choose>">${o.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row"><td colspan="4">No recent orders found.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

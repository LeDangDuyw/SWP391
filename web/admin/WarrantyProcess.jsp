<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Bảo vệ trang: chỉ Staff (roleId=2) và Admin (roleId=1)
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin – Warranty Console</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
                background: #f0f2f5;
                color: #171a22;
            }

            a { text-decoration: none; color: inherit; }

            .layout { display: flex; min-height: 100vh; }

            /* ── Sidebar (synced with AdminDashboard) ── */
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

            /* ── Main ── */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
                min-width: 0;
            }

            /* ── Topbar ── */
            .topbar {
                background: #fff;
                border-bottom: 1px solid #e5e7eb;
                padding: 12px 28px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            .topbar-title {
                font-size: 17px;
                font-weight: 700;
                color: #1a1a2e;
            }
            .search-box {
                display: flex;
                align-items: center;
                gap: 8px;
                background: #f9fafb;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 6px 12px;
                flex: 1;
                max-width: 320px;
            }
            .search-box input {
                border: none;
                background: transparent;
                font-size: 13px;
                color: #374151;
                outline: none;
                width: 100%;
            }
            .search-box input::placeholder {
                color: #9ca3af;
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .icon-btn {
                background: none;
                border: 1px solid #e5e7eb;
                cursor: pointer;
                width: 34px;
                height: 34px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #6b7280;
                font-size: 14px;
                transition: .15s;
            }
            .icon-btn:hover {
                background: #f3f4f6;
            }

            /* ── Flash message ── */
            .flash-bar {
                padding: 10px 24px;
                font-size: 13.5px;
                font-weight: 500;
            }
            .flash-success {
                background: #f0fdf4;
                color: #166534;
                border-bottom: 1px solid #bbf7d0;
            }
            .flash-error   {
                background: #fef2f2;
                color: #dc2626;
                border-bottom: 1px solid #fca5a5;
            }

            /* ── Content ── */
            .content {
                flex: 1;
                padding: 24px;
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }

            /* ── Filter bar ── */
            .filter-bar {
                padding: 12px 20px;
                border-bottom: 1px solid #f0f2f5;
                display: flex;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }
            .filter-bar input[type="text"], .filter-bar select {
                border: 1px solid #e5e7eb;
                border-radius: 7px;
                padding: 6px 10px;
                font-size: 13px;
                outline: none;
                background: #fafafa;
                color: #374151;
            }
            .filter-bar input[type="text"] {
                flex: 1;
                min-width: 160px;
                max-width: 260px;
            }
            .filter-bar input[type="text"]:focus, .filter-bar select:focus {
                border-color: #2563eb;
                background:#fff;
            }
            .filter-btn {
                background: #2563eb;
                color: #fff;
                border: none;
                border-radius: 7px;
                padding: 6px 14px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
            }
            .filter-btn:hover {
                background: #1d4ed8;
            }
            .filter-reset {
                background: #fff;
                border: 1px solid #d1d5db;
                color: #6b7280;
                border-radius: 7px;
                padding: 6px 12px;
                font-size: 13px;
                cursor: pointer;
                text-decoration: none;
                display:inline-block;
            }

            /* ── Claims Table Panel ── */
            .claims-panel {
                flex: 1;
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e5e7eb;
                overflow: hidden;
            }
            .panel-header {
                padding: 20px 20px 12px;
                border-bottom: 1px solid #f0f2f5;
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
            }
            .panel-header-left h2 {
                font-size: 17px;
                font-weight: 700;
                color: #111827;
            }
            .panel-header-left p  {
                font-size: 12.5px;
                color: #6b7280;
                margin-top: 2px;
            }
            .panel-header-actions {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .btn {
                border: none;
                cursor: pointer;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                padding: 7px 14px;
                transition: all 0.15s;
            }
            .btn-outline {
                background: #fff;
                border: 1px solid #d1d5db;
                color: #374151;
            }
            .btn-outline:hover {
                background: #f9fafb;
            }
            .btn-primary {
                background: #2563eb;
                color: #fff;
            }
            .btn-primary:hover {
                background: #1d4ed8;
            }

            /* Claims Table */
            .claims-table {
                width: 100%;
                border-collapse: collapse;
            }
            .claims-table th {
                text-align: left;
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                padding: 10px 20px;
                border-bottom: 1px solid #f0f2f5;
                background: #fafafa;
            }
            .claims-table td {
                padding: 14px 20px;
                font-size: 13.5px;
                border-bottom: 1px solid #f9fafb;
                vertical-align: top;
            }
            .claims-table tr:last-child td {
                border-bottom: none;
            }
            .claims-table tr:hover td {
                background: #fafbff;
            }
            .claims-table tr.selected-row td {
                background: #eff6ff !important;
            }

            .claim-id-link {
                color: #2563eb;
                font-weight: 600;
                text-decoration: none;
                font-size: 13px;
                cursor: pointer;
            }
            .claim-id-link:hover {
                text-decoration: underline;
            }
            .customer-name {
                font-weight: 600;
                font-size: 13.5px;
            }
            .customer-email {
                font-size: 11.5px;
                color: #6b7280;
                margin-top: 2px;
            }
            .product-name {
                font-size: 13px;
            }
            .product-sn {
                font-size: 11.5px;
                color: #9ca3af;
                margin-top: 2px;
            }
            .date-cell {
                font-size: 12.5px;
                color: #6b7280;
                white-space: nowrap;
            }

            /* Badges */
            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 11.5px;
                font-weight: 600;
                white-space: nowrap;
            }
            .badge-PENDING    {
                background: #fef3c7;
                color: #92400e;
            }
            .badge-PROCESSING {
                background: #dbeafe;
                color: #1d4ed8;
            }
            .badge-APPROVED   {
                background: #d1fae5;
                color: #065f46;
            }
            .badge-REJECTED   {
                background: #fee2e2;
                color: #991b1b;
            }
            .badge-COMPLETED  {
                background: #f3f4f6;
                color: #374151;
            }
            .badge-CANCELLED  {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* Pagination */
            .pagination {
                display: flex;
                gap: 4px;
                justify-content: center;
                padding: 14px 20px;
                border-top: 1px solid #f0f2f5;
            }
            .pagination a, .pagination span {
                padding: 5px 10px;
                border-radius: 5px;
                font-size: 12.5px;
                border: 1px solid #e5e7eb;
                text-decoration: none;
                color: #374151;
            }
            .pagination a:hover {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
            }
            .pagination .pg-active {
                background: #2563eb;
                color: #fff;
                border-color: #2563eb;
                font-weight: 700;
            }

            .no-data {
                text-align: center;
                color: #9ca3af;
                padding: 40px;
                font-size: 13.5px;
            }

            /* ── Detail Panel ── */
            .detail-panel {
                width: 260px;
                flex-shrink: 0;
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e5e7eb;
                overflow: hidden;
                font-size: 13px;
            }
            .detail-empty {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 300px;
                color: #9ca3af;
                font-size: 13px;
                gap: 8px;
                text-align: center;
                padding: 24px;
            }
            .detail-claim-header {
                padding: 14px 16px 10px;
                border-bottom: 1px solid #f0f2f5;
            }
            .claim-tag {
                font-size: 11px;
                font-weight: 700;
                color: #2563eb;
                letter-spacing: 0.06em;
                text-transform: uppercase;
                margin-bottom: 6px;
            }
            .claim-status-row {
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
                gap: 8px;
            }
            .claim-title {
                font-size: 15px;
                font-weight: 700;
                color: #111827;
                line-height: 1.25;
            }
            .status-pill {
                display: inline-block;
                padding: 3px 8px;
                border-radius: 20px;
                font-size: 10px;
                font-weight: 700;
                letter-spacing: 0.04em;
                white-space: nowrap;
                flex-shrink: 0;
            }
            .status-pill-PENDING    {
                background: #fef3c7;
                color: #92400e;
            }
            .status-pill-PROCESSING {
                background: #dbeafe;
                color: #1e40af;
            }
            .status-pill-APPROVED   {
                background: #d1fae5;
                color: #065f46;
            }
            .status-pill-REJECTED   {
                background: #fee2e2;
                color: #991b1b;
            }
            .status-pill-COMPLETED  {
                background: #f3f4f6;
                color: #374151;
            }
            .status-pill-CANCELLED  {
                background: #f3f4f6;
                color: #6b7280;
            }

            .detail-meta {
                padding: 12px 16px;
                border-bottom: 1px solid #f0f2f5;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 8px;
            }
            .meta-group label {
                font-size: 10.5px;
                color: #9ca3af;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                display: block;
                margin-bottom: 2px;
            }
            .meta-group span {
                font-size: 12.5px;
                color: #111827;
                font-weight: 500;
                word-break: break-all;
            }

            /* Description */
            .detail-section {
                padding: 12px 16px;
                border-bottom: 1px solid #f0f2f5;
            }
            .section-title {
                font-size: 11px;
                font-weight: 700;
                color: #374151;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .customer-quote {
                background: #f9fafb;
                border-left: 3px solid #e5e7eb;
                border-radius: 0 6px 6px 0;
                padding: 8px 10px;
                font-size: 11.5px;
                color: #374151;
                line-height: 1.5;
                font-style: italic;
            }

            /* Timeline */
            .timeline {
                position: relative;
                padding-left: 20px;
            }
            .timeline::before {
                content:'';
                position:absolute;
                left:6px;
                top:0;
                bottom:0;
                width:2px;
                background:#e5e7eb;
            }
            .tl-item {
                position: relative;
                margin-bottom: 14px;
            }
            .tl-dot {
                position:absolute;
                left:-17px;
                top:3px;
                width:10px;
                height:10px;
                border-radius:50%;
                border:2px solid #2563eb;
                background:#fff;
            }
            .tl-status {
                font-size:11px;
                font-weight:700;
                color:#2563eb;
            }
            .tl-date   {
                font-size:10.5px;
                color:#9ca3af;
                margin:1px 0 3px;
            }
            .tl-note   {
                font-size:11.5px;
                color:#374151;
                line-height:1.4;
            }

            /* Process form inside detail panel */
            .process-form {
                padding: 12px 16px;
                border-bottom: 1px solid #f0f2f5;
            }
            .process-form label {
                font-size: 10.5px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                display: block;
                margin-bottom: 4px;
            }
            .process-form select, .process-form textarea {
                width: 100%;
                border: 1.5px solid #e5e7eb;
                border-radius: 7px;
                padding: 7px 10px;
                font-size: 12.5px;
                color: #374151;
                outline: none;
                font-family: inherit;
                margin-bottom: 8px;
            }
            .process-form select:focus, .process-form textarea:focus {
                border-color: #2563eb;
            }
            .process-form textarea {
                resize: vertical;
                min-height: 60px;
            }

            /* Actions */
            .detail-actions {
                padding: 14px 16px;
                display: flex;
                gap: 8px;
            }
            .btn-reject {
                flex: 1;
                background: #fff;
                border: 1.5px solid #ef4444;
                color: #ef4444;
                border-radius: 8px;
                padding: 9px 0;
                font-size: 12.5px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.15s;
            }
            .btn-reject:hover {
                background: #fef2f2;
            }
            .btn-approve {
                flex: 1;
                background: #2563eb;
                border: none;
                color: #fff;
                border-radius: 8px;
                padding: 9px 0;
                font-size: 12.5px;
                font-weight: 700;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-approve:hover {
                background: #1d4ed8;
            }
            .btn-full {
                width: 100%;
                background: #2563eb;
                border: none;
                color: #fff;
                border-radius: 8px;
                padding: 9px 0;
                font-size: 12.5px;
                font-weight: 700;
                cursor: pointer;
                margin: 0 16px 14px;
                width: calc(100% - 32px);
            }
            .terminal-closed {
                color: #9ca3af;
                font-size: 12px;
                text-align: center;
                padding: 10px;
            }
        </style>
    </head>
    <body>
    <div class="layout">

        <!-- ════ SIDEBAR (synced with other admin pages) ════ -->
        <aside class="sidebar">
            <div class="brand">
                <span>UNILAP Admin</span>
                <small>System Controller</small>
            </div>
            <nav>
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <span class="nav-icon">▦</span>Dashboard
                </a>
                <a href="#">
                    <span class="nav-icon">▣</span>Orders
                </a>
                <a href="#">
                    <span class="nav-icon">♟</span>Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/promotions">
                    <span class="nav-icon">▥</span>Analytics
                </a>
                <a class="active" href="${pageContext.request.contextPath}/warranty?action=list">
                    <span class="nav-icon">🛠</span>Warranty
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
            </div>
        </aside>

        <!-- ════ MAIN ════ -->
        <div class="main">

            <!-- Topbar -->
            <div class="topbar">
                <span class="topbar-title">Warranty Console</span>
                <form method="get" action="${pageContext.request.contextPath}/warranty" class="search-box">
                    <input type="hidden" name="action" value="list">
                    <input type="hidden" name="selectedId" value="${selectedClaim.claimId}">
                    <svg width="14" height="14" fill="none" stroke="#9ca3af" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                    </svg>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Search claims...">
                </form>
                <div class="topbar-right">
                    <button class="icon-btn" title="Notifications">🔔</button>
                </div>
            </div>

            <!-- Flash messages -->
            <c:if test="${not empty param.msg}">
                <div class="flash-bar flash-success">
                    <c:choose>
                        <c:when test="${param.msg == 'updated'}">✅ Trạng thái claim đã được cập nhật thành công.</c:when>
                        <c:when test="${param.msg == 'cancelled'}">🗑️ Claim đã được huỷ.</c:when>
                    </c:choose>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="flash-bar flash-error">⚠️ <c:out value="${errorMessage}"/></div>
            </c:if>

            <!-- Content -->
            <div class="content">

                <!-- ════ Claims Table Panel ════ -->
                <div class="claims-panel">
                    <div class="panel-header">
                        <div class="panel-header-left">
                            <h2>Active Claims</h2>
                            <p>Total: ${total} warranty requests</p>
                        </div>
                        <div class="panel-header-actions">
                            <%-- Filter dropdown --%>
                            <form method="get" action="${pageContext.request.contextPath}/warranty"
                                  style="display:flex;gap:6px;align-items:center;">
                                <input type="hidden" name="action" value="list">
                                <input type="hidden" name="selectedId" value="${selectedClaim.claimId}">
                                <select name="statusFilter" onchange="this.form.submit()"
                                        style="border:1px solid #d1d5db;border-radius:7px;
                                        padding:6px 10px;font-size:12.5px;color:#374151;">
                                    <option value="">All Statuses</option>
                                    <c:forEach var="s" items="${['PENDING','PROCESSING','APPROVED','REJECTED','COMPLETED','CANCELLED']}">
                                        <option value="${s}" ${statusFilter == s ? 'selected' : ''}>${s}</option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty selectedClaim}">
                                    <a href="${pageContext.request.contextPath}/warranty?action=list&selectedId=${selectedClaim.claimId}"
                                       class="filter-reset">Reset</a>
                                </c:if>

                                <c:if test="${empty selectedClaim}">
                                    <a href="${pageContext.request.contextPath}/warranty?action=list"
                                       class="filter-reset">Reset</a>
                                </c:if>
                            </form>
                        </div>
                    </div>

                    <table class="claims-table">
                        <thead>
                            <tr>
                                <th>Claim ID</th>
                                <th>Customer</th>
                                <th>Product</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Detail</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty claims}">
                                    <tr><td colspan="6" class="no-data">No warranty claims found.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="claim" items="${claims}">
                                        <tr class="${selectedClaim != null && selectedClaim.claimId == claim.claimId ? 'selected-row' : ''}">
                                            <td>
                                                <a class="claim-id-link"
                                                   href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}&statusFilter=${statusFilter}&keyword=${keyword}&page=${page}">
                                                    #${claim.claimId}
                                                </a>
                                            </td>
                                            <td>
                                                <div class="customer-name"><c:out value="${claim.customerName}"/></div>
                                            </td>
                                            <td>
                                                <div class="product-name"><c:out value="${claim.productName}"/></div>
                                                <div class="product-sn">SN: <c:out value="${claim.serialNumber}"/></div>
                                            </td>
                                            <td><span class="badge badge-${claim.status}"><c:out value="${claim.status}"/></span></td>
                                            <td class="date-cell">
                                                <fmt:formatDate value="${claim.createdAt}" pattern="MMM dd,"/>
                                                <br>
                                                <fmt:formatDate value="${claim.createdAt}" pattern="yyyy"/>
                                            </td>
                                            <td>
                                                <a class="claim-id-link"
                                                   href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}&statusFilter=${statusFilter}&keyword=${keyword}&page=${page}">
                                                    Open →
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <%-- Pagination --%>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">

                            <c:if test="${page > 1}">
                                <a href="${pageContext.request.contextPath}/warranty?action=list
                                   &page=${page-1}
                                   &statusFilter=${statusFilter}
                                   &keyword=${keyword}
                                   &selectedId=${selectedClaim.claimId}">
                                    ‹ Prev
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == page}">
                                        <span class="pg-active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/warranty?action=list
                                           &page=${p}
                                           &statusFilter=${statusFilter}
                                           &keyword=${keyword}
                                           &selectedId=${selectedClaim.claimId}">
                                            ${p}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${page < totalPages}">
                                <a href="${pageContext.request.contextPath}/warranty?action=list
                                   &page=${page+1}
                                   &statusFilter=${statusFilter}
                                   &keyword=${keyword}
                                   &selectedId=${selectedClaim.claimId}">
                                    Next ›
                                </a>
                            </c:if>

                        </div>
                    </c:if>
                </div>
                <%-- end claims panel --%>

                <!-- ════ Detail Panel ════ -->
                <div class="detail-panel">
                    <c:choose>
                        <%-- No claim selected yet --%>
                        <c:when test="${empty selectedClaim}">
                            <div class="detail-empty">
                                <span style="font-size:28px;">👈</span>
                                <span>Select a claim from the table to view details and take action.</span>
                            </div>
                        </c:when>

                        <%-- Claim selected --%>
                        <c:otherwise>
                            <c:set var="sc" value="${selectedClaim}"/>

                            <%-- Header --%>
                            <div class="detail-claim-header">
                                <div class="claim-tag">CLAIM #${sc.claimId}</div>
                                <div class="claim-status-row">
                                    <div class="claim-title"><c:out value="${sc.title}"/></div>
                                    <span class="status-pill status-pill-${sc.status}">${sc.status}</span>
                                </div>
                            </div>

                            <%-- Meta --%>
                            <div class="detail-meta">
                                <div class="meta-group">
                                    <label>Customer</label>
                                    <span><c:out value="${sc.customerName}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Product</label>
                                    <span><c:out value="${sc.productName}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Serial</label>
                                    <span><c:out value="${sc.serialNumber}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Created</label>
                                    <span><fmt:formatDate value="${sc.createdAt}" pattern="dd/MM/yyyy"/></span>
                                </div>
                            </div>

                            <%-- Description --%>
                            <div class="detail-section">
                                <div class="section-title">📝 Issue Description</div>
                                <div class="customer-quote"><c:out value="${sc.description}"/></div>
                            </div>

                            <%-- History Timeline --%>
                            <div class="detail-section">
                                <div class="section-title">🕒 History</div>
                                <c:choose>
                                    <c:when test="${empty selectedHistory}">
                                        <div style="color:#9ca3af;font-size:12px;">No history yet.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="timeline">
                                            <c:forEach var="h" items="${selectedHistory}">
                                                <div class="tl-item">
                                                    <div class="tl-dot"></div>
                                                    <div class="tl-status"><c:out value="${h.repairStatus}"/></div>
                                                    <div class="tl-date">
                                                        <fmt:formatDate value="${h.repairDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                    <c:if test="${not empty h.repairNote}">
                                                        <div class="tl-note"><c:out value="${h.repairNote}"/></div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Process Form (only if claim is still actionable) --%>
                            <c:choose>
                                <c:when test="${sc.status == 'COMPLETED' || sc.status == 'CANCELLED' || sc.status == 'REJECTED'}">
                                    <div class="terminal-closed">
                                        ✔ This claim is closed (<c:out value="${sc.status}"/>). No further actions available.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <%--
                                        PENDING → 2 lựa chọn: PROCESSING hoặc CANCELLED
                                        Mỗi action dùng form riêng với hidden newStatus cứng
                                        → không cần onclick overwrite select, không bị race condition
                                    --%>
                                    <c:choose>

                                        <%-- ── PENDING: Accept hoặc Cancel ── --%>
                                        <c:when test="${sc.status == 'PENDING'}">
                                            <div class="process-form">
                                                <label>Staff Note</label>
                                                <textarea id="note-pending" placeholder="Enter note or reason..."></textarea>
                                            </div>
                                            <div class="detail-actions">
                                                <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                      style="display:contents"
                                                      onsubmit="document.getElementById('note-cancel').value = document.getElementById('note-pending').value">
                                                    <input type="hidden" name="action"     value="process">
                                                    <input type="hidden" name="id"         value="${sc.claimId}">
                                                    <input type="hidden" name="redirectTo" value="console">
                                                    <input type="hidden" name="newStatus"  value="CANCELLED">
                                                    <input type="hidden" name="note"       id="note-cancel">
                                                    <button type="submit" class="btn-reject"
                                                            onclick="return confirm('Huỷ claim #${sc.claimId}?')">
                                                        Cancel Claim
                                                    </button>
                                                </form>
                                                <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                      style="display:contents"
                                                      onsubmit="document.getElementById('note-process').value = document.getElementById('note-pending').value">
                                                    <input type="hidden" name="action"     value="process">
                                                    <input type="hidden" name="id"         value="${sc.claimId}">
                                                    <input type="hidden" name="redirectTo" value="console">
                                                    <input type="hidden" name="newStatus"  value="PROCESSING">
                                                    <input type="hidden" name="note"       id="note-process">
                                                    <button type="submit" class="btn-approve">
                                                        Accept ✓
                                                    </button>
                                                </form>
                                            </div>
                                        </c:when>

                                        <%-- ── PROCESSING: Approve hoặc Reject ── --%>
                                        <c:when test="${sc.status == 'PROCESSING'}">
                                            <div class="process-form">
                                                <label>Staff Note</label>
                                                <textarea id="note-processing" placeholder="Enter note or reason..."></textarea>
                                            </div>
                                            <div class="detail-actions">
                                                <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                      style="display:contents"
                                                      onsubmit="document.getElementById('note-reject').value = document.getElementById('note-processing').value">
                                                    <input type="hidden" name="action"     value="process">
                                                    <input type="hidden" name="id"         value="${sc.claimId}">
                                                    <input type="hidden" name="redirectTo" value="console">
                                                    <input type="hidden" name="newStatus"  value="REJECTED">
                                                    <input type="hidden" name="note"       id="note-reject">
                                                    <button type="submit" class="btn-reject">Reject</button>
                                                </form>
                                                <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                      style="display:contents"
                                                      onsubmit="document.getElementById('note-approve').value = document.getElementById('note-processing').value">
                                                    <input type="hidden" name="action"     value="process">
                                                    <input type="hidden" name="id"         value="${sc.claimId}">
                                                    <input type="hidden" name="redirectTo" value="console">
                                                    <input type="hidden" name="newStatus"  value="APPROVED">
                                                    <input type="hidden" name="note"       id="note-approve">
                                                    <button type="submit" class="btn-approve">Approve ✓</button>
                                                </form>
                                            </div>
                                        </c:when>

                                        <%-- ── APPROVED: Complete ── --%>
                                        <c:when test="${sc.status == 'APPROVED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                  class="process-form">
                                                <input type="hidden" name="action"     value="process">
                                                <input type="hidden" name="id"         value="${sc.claimId}">
                                                <input type="hidden" name="redirectTo" value="console">
                                                <input type="hidden" name="newStatus"  value="COMPLETED">
                                                <label>Staff Note</label>
                                                <textarea name="note" placeholder="Enter completion note..."></textarea>
                                                <div style="padding:0 0 14px;">
                                                    <button type="submit" class="btn-full">Mark as Completed</button>
                                                </div>
                                            </form>
                                        </c:when>

                                    </c:choose>
                                </c:otherwise>
                            </c:choose>

                        </c:otherwise>
                    </c:choose>
                </div>
                <%-- end detail panel --%>

            </div><%-- end content --%>
        </div><%-- end main --%>

    </div><!-- end layout -->
    </body>
</html>

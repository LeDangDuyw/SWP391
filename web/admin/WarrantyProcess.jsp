<%-- 
    Page: WarrantyProcess.jsp
    Mo ta: Trang giao diện nhân viên/admin xử lý các phiếu bảo hành.
    
    Created: 2026-06-22
    Updated: 2026-07-21
    Version: v1.0
    
    @author DuyLD
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Bảo vệ trang: chỉ Admin (roleId=1)
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null || currentUser.getRoleId() != 1) {
        response.sendRedirect(request.getContextPath() + "/login");
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
    
<style>
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

        <jsp:include page="/admin/sidebar.jsp">
            <jsp:param name="activePage" value="warranty"/>
        </jsp:include>

        <!-- ════ MAIN ════ -->
        <div class="main">

            <!-- Topbar -->
            <div class="topbar">
                <span class="topbar-title">Hệ thống xử lý bảo hành</span>
                <form method="get" action="${pageContext.request.contextPath}/warranty" class="search-box">
                    <input type="hidden" name="action" value="list">
                    <input type="hidden" name="selectedId" value="${selectedClaim.claimId}">
                    <svg width="14" height="14" fill="none" stroke="#9ca3af" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                    </svg>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm kiếm yêu cầu...">
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
                        <c:when test="${param.msg == 'takeover'}">🔁 Chuyển giao/tiếp nhận yêu cầu thành công.</c:when>
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
                            <h2>Yêu cầu bảo hành đang hoạt động</h2>
                            <p>Tổng số: ${total} yêu cầu bảo hành</p>
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
                                    <option value="">Tất cả trạng thái</option>
                                    <c:forEach var="s" items="${['PENDING','PROCESSING','APPROVED','REJECTED','COMPLETED','CANCELLED']}">
                                        <option value="${s}" ${statusFilter == s ? 'selected' : ''}>
                                            <c:choose>
                                                <c:when test="${s == 'PENDING'}">Chờ xử lý</c:when>
                                                <c:when test="${s == 'PROCESSING'}">Đang xử lý</c:when>
                                                <c:when test="${s == 'APPROVED'}">Đã duyệt</c:when>
                                                <c:when test="${s == 'REJECTED'}">Đã từ chối</c:when>
                                                <c:when test="${s == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                <c:when test="${s == 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise>${s}</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty selectedClaim}">
                                    <a href="${pageContext.request.contextPath}/warranty?action=list&selectedId=${selectedClaim.claimId}"
                                       class="filter-reset">Đặt lại</a>
                                </c:if>

                                <c:if test="${empty selectedClaim}">
                                    <a href="${pageContext.request.contextPath}/warranty?action=list"
                                       class="filter-reset">Đặt lại</a>
                                </c:if>
                            </form>
                        </div>
                    </div>

                    <table class="claims-table">
                        <thead>
                            <tr>
                                <th>Mã yêu cầu</th>
                                <th>Khách hàng</th>
                                <th>Sản phẩm</th>
                                <th>Trạng thái</th>
                                <th>Ngày gửi</th>
                                <th>Chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty claims}">
                                    <tr><td colspan="6" class="no-data">Không tìm thấy yêu cầu bảo hành nào.</td></tr>
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
                                            <td>
                                                <span class="badge badge-${claim.status}">
                                                    <c:choose>
                                                        <c:when test="${claim.status == 'PENDING'}">Chờ xử lý</c:when>
                                                        <c:when test="${claim.status == 'PROCESSING'}">Đang xử lý</c:when>
                                                        <c:when test="${claim.status == 'APPROVED'}">Đã duyệt</c:when>
                                                        <c:when test="${claim.status == 'REJECTED'}">Đã từ chối</c:when>
                                                        <c:when test="${claim.status == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                        <c:when test="${claim.status == 'CANCELLED'}">Đã hủy</c:when>
                                                        <c:otherwise><c:out value="${claim.status}"/></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="date-cell">
                                                <fmt:formatDate value="${claim.createdAt}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <a class="claim-id-link"
                                                   href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}&statusFilter=${statusFilter}&keyword=${keyword}&page=${page}">
                                                    Xem →
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
                                <a href="${pageContext.request.contextPath}/warranty?action=list&page=${page - 1}&statusFilter=${statusFilter}&keyword=${keyword}"
                                   class="page-link">‹ Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == page}">
                                        <span class="pg-active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/warranty?action=list&page=${p}&statusFilter=${statusFilter}&keyword=${keyword}&selectedId=${selectedClaim.claimId}">
                                            ${p}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${page < totalPages}">
                                <a href="${pageContext.request.contextPath}/warranty?action=list&page=${page+1}&statusFilter=${statusFilter}&keyword=${keyword}&selectedId=${selectedClaim.claimId}">
                                    Sau ›
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
                                <span>Chọn một yêu cầu từ bảng để xem chi tiết và thực hiện xử lý.</span>
                            </div>
                        </c:when>

                        <%-- Claim selected --%>
                        <c:otherwise>
                            <c:set var="sc" value="${selectedClaim}"/>

                            <%-- Header --%>
                            <div class="detail-claim-header">
                                <div class="claim-tag">YÊU CẦU #${sc.claimId}</div>
                                <div class="claim-status-row">
                                    <div class="claim-title"><c:out value="${sc.title}"/></div>
                                    <span class="status-pill status-pill-${sc.status}">
                                        <c:choose>
                                            <c:when test="${sc.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${sc.status == 'PROCESSING'}">Đang xử lý</c:when>
                                            <c:when test="${sc.status == 'APPROVED'}">Đã duyệt</c:when>
                                            <c:when test="${sc.status == 'REJECTED'}">Đã từ chối</c:when>
                                            <c:when test="${sc.status == 'COMPLETED'}">Đã hoàn thành</c:when>
                                            <c:when test="${sc.status == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:otherwise>${sc.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <%-- Meta --%>
                            <div class="detail-meta">
                                <div class="meta-group">
                                    <label>Khách hàng</label>
                                    <span><c:out value="${sc.customerName}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Sản phẩm</label>
                                    <span><c:out value="${sc.productName}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Số sê-ri</label>
                                    <span><c:out value="${sc.serialNumber}"/></span>
                                </div>
                                <div class="meta-group">
                                    <label>Ngày tạo</label>
                                    <span><fmt:formatDate value="${sc.createdAt}" pattern="dd/MM/yyyy"/></span>
                                </div>
                            </div>

                            <%-- Description --%>
                            <div class="detail-section">
                                <div class="section-title">📝 Mô Tả Lỗi</div>
                                <div class="customer-quote"><c:out value="${sc.description}"/></div>
                            </div>

                            <%-- Images --%>
                            <div class="detail-section">
                                <div class="section-title">📷 Hình Ảnh Bằng Chứng</div>
                                <c:choose>
                                    <c:when test="${empty selectedImages}">
                                        <div style="color:#9ca3af;font-size:12px;">Không có hình ảnh đính kèm.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="display:flex; gap:10px; flex-wrap:wrap; margin-top:8px;">
                                            <c:forEach var="img" items="${selectedImages}">
                                                <a href="${pageContext.request.contextPath}${img.imageUrl}" target="_blank" style="display:block; width:100px; height:100px; border-radius:6px; overflow:hidden; border:1px solid #e5e7eb;">
                                                    <img src="${pageContext.request.contextPath}${img.imageUrl}" style="width:100%; height:100%; object-fit:cover;" alt="Evidence">
                                                </a>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- History Timeline --%>
                            <div class="detail-section">
                                <div class="section-title">🕒 Lịch Sử Xử Lý</div>
                                <c:choose>
                                    <c:when test="${empty selectedHistory}">
                                        <div style="color:#9ca3af;font-size:12px;">Chưa có lịch sử.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="timeline">
                                            <c:forEach var="h" items="${selectedHistory}">
                                                <div class="tl-item">
                                                    <div class="tl-dot"></div>
                                                    <div class="tl-status">
                                                        <c:choose>
                                                            <c:when test="${h.repairStatus == 'PENDING'}">Chờ xử lý</c:when>
                                                            <c:when test="${h.repairStatus == 'PROCESSING'}">Đang xử lý</c:when>
                                                            <c:when test="${h.repairStatus == 'APPROVED'}">Đã duyệt</c:when>
                                                            <c:when test="${h.repairStatus == 'REJECTED'}">Đã từ chối</c:when>
                                                            <c:when test="${h.repairStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                            <c:when test="${h.repairStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                            <c:otherwise><c:out value="${h.repairStatus}"/></c:otherwise>
                                                        </c:choose>
                                                    </div>
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
                                        ✔ Yêu cầu bảo hành này đã đóng (
                                        <c:choose>
                                            <c:when test="${sc.status == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${sc.status == 'PROCESSING'}">Đang xử lý</c:when>
                                            <c:when test="${sc.status == 'APPROVED'}">Đã duyệt</c:when>
                                            <c:when test="${sc.status == 'REJECTED'}">Đã từ chối</c:when>
                                            <c:when test="${sc.status == 'COMPLETED'}">Đã hoàn thành</c:when>
                                            <c:when test="${sc.status == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:otherwise><c:out value="${sc.status}"/></c:otherwise>
                                        </c:choose>
                                        ). Không thể thao tác thêm.
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
                                                <label>Ghi chú nhân viên</label>
                                                <textarea id="note-pending" placeholder="Nhập ghi chú hoặc lý do..."></textarea>
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
                                                            onclick="return confirm('Huỷ yêu cầu #${sc.claimId}?')">
                                                        Hủy yêu cầu
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
                                                        Tiếp nhận ✓
                                                    </button>
                                                </form>
                                            </div>
                                        </c:when>

                                        <%-- ── PROCESSING: Approve hoặc Reject ── --%>
                                        <c:when test="${sc.status == 'PROCESSING'}">
                                            <c:choose>
                                                <%-- Chỉ staff được gán mới thấy nút action --%>
                                                <c:when test="${sc.staffId == sessionScope.user.userId}">
                                                    <div class="process-form">
                                                        <label>Ghi chú nhân viên</label>
                                                        <textarea id="note-processing" placeholder="Nhập ghi chú hoặc lý do..."></textarea>
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
                                                            <button type="submit" class="btn-reject">Từ chối</button>
                                                        </form>
                                                        <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                              style="display:contents"
                                                              onsubmit="document.getElementById('note-approve').value = document.getElementById('note-processing').value">
                                                            <input type="hidden" name="action"     value="process">
                                                            <input type="hidden" name="id"         value="${sc.claimId}">
                                                            <input type="hidden" name="redirectTo" value="console">
                                                            <input type="hidden" name="newStatus"  value="APPROVED">
                                                            <input type="hidden" name="note"       id="note-approve">
                                                            <button type="submit" class="btn-approve">Duyệt ✓</button>
                                                        </form>
                                                    </div>
                                                    <%-- Nếu Admin đang tự phụ trách, cho phép Admin chuyển giao (Reassign) cho staff khác --%>
                                                    <c:if test="${sessionScope.user.roleId == 1}">
                                                        <details style="margin-top:14px;border:1px solid #fef3c7;background:#fffbeb;border-radius:8px;padding:10px;">
                                                            <summary style="font-size:13px;font-weight:600;color:#b45309;cursor:pointer;user-select:none;">
                                                                🔄 Chuyển giao cho nhân viên khác (Reassign)
                                                            </summary>
                                                            <form method="post" action="${pageContext.request.contextPath}/warranty" style="margin-top:10px;">
                                                                <input type="hidden" name="action" value="takeOver">
                                                                <input type="hidden" name="id"     value="${sc.claimId}">
                                                                <label style="display:block;margin-bottom:4px;font-size:12px;color:#374151;">Chọn nhân viên nhận chuyển giao:</label>
                                                                <select name="newStaffId" required style="width:100%;padding:6px 8px;border:1px solid #d1d5db;border-radius:6px;margin-bottom:8px;font-size:13px;" oninvalid="this.setCustomValidity('Vui lòng chọn nhân viên.')" oninput="this.setCustomValidity('')">
                                                                    <option value="">-- Chọn nhân viên --</option>
                                                                    <c:forEach var="s" items="${staffList}">
                                                                        <c:if test="${s.userId != sessionScope.user.userId}">
                                                                            <option value="${s.userId}">${s.userName}</option>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </select>
                                                                <label style="display:block;margin-bottom:4px;font-size:12px;color:#374151;">Ghi chú lý do chuyển giao:</label>
                                                                <textarea name="note" placeholder="Nhập lý do..." oninvalid="this.setCustomValidity('Vui lòng điền vào trường này.')" oninput="this.setCustomValidity('')" style="width:100%;height:55px;resize:vertical;border:1px solid #d1d5db;border-radius:6px;padding:6px 8px;font-size:13px;"></textarea>
                                                                <div style="padding-top:8px;">
                                                                    <button type="submit" class="btn-approve" style="width:100%;background:#d97706;" onclick="return confirm('Xác nhận chuyển giao yêu cầu #${sc.claimId}?')">
                                                                        Xác nhận chuyển giao
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </details>
                                                    </c:if>
                                                </c:when>
                                                <%-- Staff khác hoặc Admin chưa take over --%>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <%-- Admin: hiển form Take Over / Reassign --%>
                                                        <c:when test="${sessionScope.user.roleId == 1}">
                                                            <div class="process-form" style="border-left:3px solid #f59e0b;padding-left:12px;">
                                                                <div style="font-weight:600;color:#92400e;margin-bottom:8px;">&#9888;&#65039; Yêu cầu đang được xử lý bởi nhân viên khác</div>
                                                                <form method="post" action="${pageContext.request.contextPath}/warranty">
                                                                    <input type="hidden" name="action" value="takeOver">
                                                                    <input type="hidden" name="id"     value="${sc.claimId}">
                                                                    <label style="display:block;margin-bottom:4px;font-size:12px;">Chuyển giao cho nhân viên (bỏ trống = tự tiếp nhận)</label>
                                                                    <select name="newStaffId" style="width:100%;padding:6px 8px;border:1px solid #d1d5db;border-radius:6px;margin-bottom:8px;font-size:13px;">
                                                                        <option value="-1">&#127894; Tiếp nhận lại (Gán cho tôi)</option>
                                                                        <c:forEach var="s" items="${staffList}">
                                                                            <option value="${s.userId}">${s.userName}</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                    <label style="display:block;margin-bottom:4px;font-size:12px;">Ghi chú lý do chuyển giao</label>
                                                                    <textarea name="note" placeholder="Nhập lý do (tùy chọn)..." oninvalid="this.setCustomValidity('Vui lòng điền vào trường này.')" oninput="this.setCustomValidity('')" style="width:100%;height:60px;resize:vertical;border:1px solid #d1d5db;border-radius:6px;padding:6px 8px;font-size:13px;"></textarea>
                                                                    <div style="padding:8px 0 0;">
                                                                        <button type="submit" class="btn-approve" style="width:100%;" onclick="return confirm('Xác nhận chuyển giao yêu cầu #${sc.claimId}?')">
                                                                            &#128257; Xác nhận Tiếp nhận lại / Chuyển giao
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </c:when>
                                                        <%-- Staff thường: chỉ thấy cảnh báo --%>
                                                        <c:otherwise>
                                                            <div class="terminal-closed" style="color:#d97706;background:#fffbeb;border-color:#fde68a;">
                                                                &#9888;&#65039; Yêu cầu này đang được xử lý bởi nhân viên khác. Bạn không có quyền thực hiện hành động này.
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>

                                        <%-- ── APPROVED: Complete ── --%>
                                        <c:when test="${sc.status == 'APPROVED'}">
                                            <c:choose>
                                                <%-- Chỉ staff được gán mới thấy nút Complete --%>
                                                <c:when test="${sc.staffId == sessionScope.user.userId}">
                                                    <form method="post" action="${pageContext.request.contextPath}/warranty"
                                                          class="process-form">
                                                        <input type="hidden" name="action"     value="process">
                                                        <input type="hidden" name="id"         value="${sc.claimId}">
                                                        <input type="hidden" name="redirectTo" value="console">
                                                        <input type="hidden" name="newStatus"  value="COMPLETED">
                                                        <label>Ghi chú nhân viên</label>
                                                        <textarea name="note" placeholder="Nhập ghi chú hoàn thành..." oninvalid="this.setCustomValidity('Vui lòng điền vào trường này.')" oninput="this.setCustomValidity('')"></textarea>
                                                        <div style="padding:0 0 14px;">
                                                            <button type="submit" class="btn-full">Đánh dấu hoàn thành</button>
                                                        </div>
                                                    </form>
                                                    <%-- Nếu Admin đang tự phụ trách, cho phép Admin chuyển giao (Reassign) cho staff khác --%>
                                                    <c:if test="${sessionScope.user.roleId == 1}">
                                                        <details style="margin-top:14px;border:1px solid #fef3c7;background:#fffbeb;border-radius:8px;padding:10px;">
                                                            <summary style="font-size:13px;font-weight:600;color:#b45309;cursor:pointer;user-select:none;">
                                                                🔄 Chuyển giao cho nhân viên khác (Reassign)
                                                            </summary>
                                                            <form method="post" action="${pageContext.request.contextPath}/warranty" style="margin-top:10px;">
                                                                <input type="hidden" name="action" value="takeOver">
                                                                <input type="hidden" name="id"     value="${sc.claimId}">
                                                                <label style="display:block;margin-bottom:4px;font-size:12px;color:#374151;">Chọn nhân viên nhận chuyển giao:</label>
                                                                <select name="newStaffId" required style="width:100%;padding:6px 8px;border:1px solid #d1d5db;border-radius:6px;margin-bottom:8px;font-size:13px;" oninvalid="this.setCustomValidity('Vui lòng chọn nhân viên.')" oninput="this.setCustomValidity('')">
                                                                    <option value="">-- Chọn nhân viên --</option>
                                                                    <c:forEach var="s" items="${staffList}">
                                                                        <c:if test="${s.userId != sessionScope.user.userId}">
                                                                            <option value="${s.userId}">${s.userName}</option>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </select>
                                                                <label style="display:block;margin-bottom:4px;font-size:12px;color:#374151;">Ghi chú lý do chuyển giao:</label>
                                                                <textarea name="note" placeholder="Nhập lý do..." oninvalid="this.setCustomValidity('Vui lòng điền vào trường này.')" oninput="this.setCustomValidity('')" style="width:100%;height:55px;resize:vertical;border:1px solid #d1d5db;border-radius:6px;padding:6px 8px;font-size:13px;"></textarea>
                                                                <div style="padding-top:8px;">
                                                                    <button type="submit" class="btn-approve" style="width:100%;background:#d97706;" onclick="return confirm('Xác nhận chuyển giao yêu cầu #${sc.claimId}?')">
                                                                        Xác nhận chuyển giao
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </details>
                                                    </c:if>
                                                </c:when>
                                                <%-- Admin: Take Over / Reassign; Staff khác: chỉ đọc --%>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${sessionScope.user.roleId == 1}">
                                                            <div class="process-form" style="border-left:3px solid #f59e0b;padding-left:12px;">
                                                                <div style="font-weight:600;color:#92400e;margin-bottom:8px;">&#9888;&#65039; Yêu cầu đang được xử lý bởi nhân viên khác</div>
                                                                <form method="post" action="${pageContext.request.contextPath}/warranty">
                                                                    <input type="hidden" name="action" value="takeOver">
                                                                    <input type="hidden" name="id"     value="${sc.claimId}">
                                                                    <label style="display:block;margin-bottom:4px;font-size:12px;">Chuyển giao cho nhân viên (bỏ trống = tự tiếp nhận)</label>
                                                                    <select name="newStaffId" style="width:100%;padding:6px 8px;border:1px solid #d1d5db;border-radius:6px;margin-bottom:8px;font-size:13px;">
                                                                        <option value="-1">&#127894; Tiếp nhận lại (Gán cho tôi)</option>
                                                                        <c:forEach var="s" items="${staffList}">
                                                                            <option value="${s.userId}">${s.userName}</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                    <label style="display:block;margin-bottom:4px;font-size:12px;">Ghi chú lý do</label>
                                                                    <textarea name="note" placeholder="Nhập lý do (tùy chọn)..." oninvalid="this.setCustomValidity('Vui lòng điền vào trường này.')" oninput="this.setCustomValidity('')" style="width:100%;height:60px;resize:vertical;border:1px solid #d1d5db;border-radius:6px;padding:6px 8px;font-size:13px;"></textarea>
                                                                    <div style="padding:8px 0 0;">
                                                                        <button type="submit" class="btn-approve" style="width:100%;" onclick="return confirm('Xác nhận chuyển giao yêu cầu #${sc.claimId}?')">
                                                                            &#128257; Xác nhận Tiếp nhận lại / Chuyển giao
                                                                        </button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="terminal-closed" style="color:#d97706;background:#fffbeb;border-color:#fde68a;">
                                                                &#9888;&#65039; Yêu cầu này đang được xử lý bởi nhân viên khác. Bạn không có quyền thực hiện hành động này.
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
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
    
<script>
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
</script>
</body>
</html>


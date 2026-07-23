<%-- 
    Page: PolicyManagement.jsp
    Mo ta: Trang giao diện quản lý danh sách và chỉnh sửa chính sách của Admin.
    
    Created: 2026-06-03
    Updated: 2026-07-21
    Version: v1.0
    
    @author DuyLD
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP — Quản Lý Chính Sách</title>
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
            input,textarea,select,button {
                font-family:inherit;
            }
            .layout {
                display:flex;
                min-height:100vh;
            }
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
            .sidebar nav a span {
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
            .main {
                flex:1;
                display:flex;
                flex-direction:column;
                min-width:0;
            }
            .topbar {
                background:#fff;
                border-bottom:1px solid #e5e7eb;
                padding:14px 28px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                flex-shrink:0;
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
            .page-header-wrap {
                padding:18px 28px 0;
                flex-shrink:0;
            }
            .breadcrumb {
                font-size:13px;
                color:#6b7280;
                display:flex;
                align-items:center;
                gap:6px;
                margin-bottom:8px;
            }
            .page-title-row {
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                margin-bottom:18px;
            }
            .page-title {
                font-size:24px;
                font-weight:700;
            }
            .page-sub {
                font-size:13px;
                color:#6b7280;
                margin-top:3px;
            }
            .page-actions {
                display:flex;
                gap:10px;
            }
            .btn {
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:9px 16px;
                border-radius:7px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                border:none;
                transition:opacity .15s;
            }
            .btn:hover {
                opacity:.88;
            }
            .btn-primary   {
                background:#2563eb;
                color:#fff;
            }
            .btn-outline   {
                background:#fff;
                color:#374151;
                border:1px solid #d1d5db;
            }
            .btn-danger    {
                background:#ef4444;
                color:#fff;
            }
            .btn-sm {
                padding:6px 12px;
                font-size:12px;
            }
            .pane-body {
                display:flex;
                flex:1;
                overflow:hidden;
                border-top:1px solid #e5e7eb;
            }
            .doc-pane {
                width:310px;
                flex-shrink:0;
                background:#fff;
                border-right:1px solid #e5e7eb;
                display:flex;
                flex-direction:column;
                overflow:hidden;
            }
            .doc-pane-header {
                padding:16px 16px 10px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                border-bottom:1px solid #f3f4f6;
            }
            .doc-pane-header h3 {
                font-size:13px;
                font-weight:600;
                color:#374151;
            }
            .doc-list {
                flex:1;
                overflow-y:auto;
                padding:10px 12px;
            }
            .search-wrap {
                padding:10px 12px;
            }
            .search-form {
                display:flex;
            }
            .search-form input {
                flex:1;
                padding:8px 12px;
                border:1px solid #e5e7eb;
                border-radius:7px 0 0 7px;
                font-size:13px;
                outline:none;
            }
            .search-form input:focus {
                border-color:#2563eb;
            }
            .search-form button {
                padding:8px 12px;
                border:1px solid #e5e7eb;
                border-left:none;
                background:#f9fafb;
                cursor:pointer;
                border-radius:0 7px 7px 0;
                font-size:13px;
            }
            .doc-item {
                padding:13px 12px;
                border-radius:8px;
                cursor:pointer;
                margin-bottom:6px;
                border:1px solid transparent;
                transition:background .12s;
            }
            .doc-item:hover  {
                background:#f9fafb;
                border-color:#e5e7eb;
            }
            .doc-item.active {
                background:#eff6ff;
                border-color:#bfdbfe;
            }
            .doc-item-top {
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:5px;
            }
            .doc-item-name {
                font-size:14px;
                font-weight:600;
                color:#111;
            }
            .doc-item-meta {
                font-size:12px;
                color:#9ca3af;
            }
            .badge {
                display:inline-flex;
                align-items:center;
                padding:2px 8px;
                border-radius:20px;
                font-size:10px;
                font-weight:700;
                text-transform:uppercase;
            }
            .badge-live     {
                background:#dcfce7;
                color:#166534;
            }
            .badge-draft    {
                background:#fef9c3;
                color:#92400e;
            }
            .badge-disabled {
                background:#f3f4f6;
                color:#6b7280;
            }
            .editor-pane {
                flex:1;
                min-width:0;
                display:flex;
                flex-direction:column;
                overflow:hidden;
            }
            .editor-toolbar {
                padding:10px 24px;
                border-bottom:1px solid #e5e7eb;
                display:flex;
                align-items:center;
                justify-content:space-between;
                background:#fff;
                flex-shrink:0;
            }
            .editor-tools {
                display:flex;
                align-items:center;
                gap:4px;
            }
            .tool-btn {
                width:30px;
                height:30px;
                border:none;
                background:none;
                cursor:pointer;
                border-radius:4px;
                font-size:14px;
                color:#374151;
                display:flex;
                align-items:center;
                justify-content:center;
            }
            .tool-btn:hover {
                background:#f3f4f6;
            }
            .tool-sep {
                width:1px;
                height:20px;
                background:#e5e7eb;
                margin:0 4px;
            }
            .status-indicator {
                display:flex;
                align-items:center;
                gap:10px;
                font-size:13px;
                font-weight:600;
            }
            .toggle-wrap {
                display:flex;
                align-items:center;
                gap:8px;
            }
            .toggle {
                width:40px;
                height:22px;
                border-radius:11px;
                border:none;
                cursor:pointer;
                position:relative;
                transition:background .2s;
            }
            .toggle.on  {
                background:#2563eb;
            }
            .toggle.off {
                background:#d1d5db;
            }
            .toggle::after {
                content:'';
                position:absolute;
                top:3px;
                width:16px;
                height:16px;
                border-radius:50%;
                background:#fff;
                transition:left .2s;
            }
            .toggle.on::after {
                left:21px;
            }
            .toggle.off::after {
                left:3px;
            }
            .editor-content {
                flex:1;
                overflow-y:auto;
                padding:32px 40px;
                background:#fff;
            }
            .policy-doc-title {
                font-size:36px;
                font-weight:800;
                margin-bottom:20px;
            }
            .policy-meta-row {
                display:flex;
                align-items:flex-start;
                gap:40px;
                margin-bottom:28px;
            }
            .meta-item label {
                font-size:10px;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.8px;
                color:#9ca3af;
                display:block;
                margin-bottom:5px;
            }
            .meta-chip {
                display:inline-block;
                padding:4px 10px;
                background:#f3f4f6;
                border-radius:5px;
                font-size:13px;
                font-weight:500;
            }
            .region-chips {
                display:flex;
                gap:6px;
                flex-wrap:wrap;
            }
            .region-chip {
                padding:3px 9px;
                background:#1e293b;
                color:#fff;
                border-radius:4px;
                font-size:12px;
                font-weight:600;
            }
            .policy-text {
                font-size:14px;
                line-height:1.7;
                color:#374151;
                margin-bottom:12px;
            }
            .policy-highlight {
                background:#f8fafc;
                border-left:3px solid #2563eb;
                padding:14px 18px;
                border-radius:0 8px 8px 0;
                margin-bottom:16px;
            }
            .policy-highlight .hl-title {
                font-size:13px;
                font-weight:700;
                margin-bottom:4px;
            }
            .policy-highlight .hl-body  {
                font-size:13px;
                color:#374151;
            }
            .editor-footer {
                background:#fff;
                border-top:1px solid #e5e7eb;
                padding:14px 40px;
                display:flex;
                align-items:center;
                justify-content:flex-end;
                gap:10px;
                flex-shrink:0;
            }
            .empty-state {
                flex:1;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                text-align:center;
                color:#9ca3af;
                padding:60px;
            }
            .empty-state .empty-icon {
                font-size:48px;
                margin-bottom:16px;
                opacity:.4;
            }
            .modal-overlay {
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.45);
                z-index:1000;
                align-items:center;
                justify-content:center;
            }
            .modal-overlay.open {
                display:flex;
            }
            .modal {
                background:#fff;
                border-radius:12px;
                width:540px;
                max-width:95vw;
                box-shadow:0 20px 60px rgba(0,0,0,.2);
                overflow:hidden;
            }
            .modal-header {
                padding:20px 24px;
                border-bottom:1px solid #e5e7eb;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .modal-header h2 {
                font-size:17px;
                font-weight:700;
            }
            .modal-close {
                background:none;
                border:none;
                font-size:20px;
                cursor:pointer;
                color:#6b7280;
                line-height:1;
            }
            .modal-body {
                padding:24px;
            }
            .modal-footer {
                padding:16px 24px;
                border-top:1px solid #e5e7eb;
                display:flex;
                justify-content:flex-end;
                gap:10px;
            }
            .form-group {
                margin-bottom:16px;
            }
            .form-group label {
                display:block;
                font-size:13px;
                font-weight:600;
                color:#374151;
                margin-bottom:5px;
            }
            .form-group input[type="text"], .form-group input[type="number"], .form-group input[type="date"],
            .form-group textarea, .form-group select {
                width:100%;
                padding:9px 12px;
                border:1px solid #d1d5db;
                border-radius:7px;
                font-size:13px;
                outline:none;
            }
            .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
                border-color:#2563eb;
            }
            .form-row {
                display:flex;
                gap:14px;
            }
            .form-row .form-group {
                flex:1;
            }
            .confirm-modal .modal-body {
                text-align:center;
                padding:32px 24px;
            }
            .confirm-icon {
                font-size:40px;
                margin-bottom:12px;
            }
            .confirm-msg {
                font-size:15px;
                color:#374151;
            }
            .confirm-sub {
                font-size:13px;
                color:#9ca3af;
                margin-top:6px;
            }
            .vh-list {
                list-style:none;
            }
            .vh-item {
                padding:12px 0;
                border-bottom:1px solid #f3f4f6;
                display:flex;
                gap:14px;
            }
            .vh-item:last-child {
                border-bottom:none;
            }
            .vh-dot {
                width:32px;
                height:32px;
                border-radius:50%;
                background:#dbeafe;
                color:#1d4ed8;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:12px;
                font-weight:700;
                flex-shrink:0;
            }
            .vh-info .vh-ver  {
                font-size:13px;
                font-weight:700;
            }
            .vh-info .vh-date {
                font-size:12px;
                color:#9ca3af;
            }

            .text-danger {
                color: red;
                font-size: 13px;
                margin-top: 4px;
                display: block;
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

            /* Beautiful Pagination Styling */
            .pagination {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 20px;
                padding-top: 15px;
                border-top: 1px solid #e5e7eb;
                justify-content: flex-start;
            }
            .pagination a {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
                border-radius: 8px;
                border: 1px solid #d1d5db;
                color: #4b5563;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s ease;
                background: #ffffff;
            }
            .pagination a:hover {
                border-color: #2563eb;
                color: #2563eb;
                background: #f0f6ff;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(37, 99, 235, 0.1);
            }
            .pagination a.active {
                background: #2563eb;
                border-color: #2563eb;
                color: #ffffff;
                box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
            }
</style>
</head>
    <body>
        <div class="layout">

            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="activePage" value="policy"/>
            </jsp:include>

            <div class="main">
                <div class="topbar">
                    <span class="topbar-title"></span>
                    <div class="topbar-right">
                        <button class="icon-btn">&#128276;</button>
                        <button class="icon-btn">?</button>
                    </div>
                </div>

                <div class="page-header-wrap">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Cài đặt</a>
                        <span>&rsaquo;</span>
                        <span style="color:#2563eb;font-weight:500;">Quản lý chính sách</span>
                    </div>
                    <div class="page-title-row">
                        <div>
                            <div class="page-title">Chính sách cửa hàng</div>
                            <div class="page-sub">Quản lý điều khoản dịch vụ, quyền riêng tư và tài liệu bảo hành.</div>
                        </div>
                        <div class="page-actions">
                            <c:choose>
                                <c:when test="${activeTab == 'WARRANTY'}">
                                    <button class="btn btn-outline" onclick="openModal('vhModal')">&#128339; Lịch sử phiên bản</button>
                                    <button class="btn btn-primary" onclick="openModal('createModal')">&#65291; Tạo chính sách bảo hành</button>
                                </c:when>
                                <c:when test="${activeTab == 'FOOTER'}">
                                    <button class="btn btn-primary" onclick="openModal('createGeneralModal')">&#65291; Tạo chính sách chung</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-primary" onclick="openModal('createGeneralModal')">&#65291; Tạo bài viết tin tức mới</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="tabs-container" style="display: flex; gap: 10px; border-bottom: 2px solid #e2e8f0; margin-bottom: 20px; padding: 0 28px;">
                    <a href="${pageContext.request.contextPath}/admin/policy" class="tab-link" style="padding: 10px 20px; font-weight: 600; text-decoration: none; color: ${activeTab == 'WARRANTY' ? '#2563eb' : '#64748b'}; border-bottom: ${activeTab == 'WARRANTY' ? '3px solid #2563eb' : 'none'}; font-size: 14px;">Chính sách bảo hành</a>
                    <a href="${pageContext.request.contextPath}/admin/general-policy" class="tab-link" style="padding: 10px 20px; font-weight: 600; text-decoration: none; color: ${activeTab == 'FOOTER' ? '#2563eb' : '#64748b'}; border-bottom: ${activeTab == 'FOOTER' ? '3px solid #2563eb' : 'none'}; font-size: 14px;">Các chính sách chung</a>
                    <a href="${pageContext.request.contextPath}/admin/general-policy?tab=news" class="tab-link" style="padding: 10px 20px; font-weight: 600; text-decoration: none; color: ${activeTab == 'NEWS' ? '#2563eb' : '#64748b'}; border-bottom: ${activeTab == 'NEWS' ? '3px solid #2563eb' : 'none'}; font-size: 14px;">Bài viết Tin tức & Khuyến mãi</a>
                </div>

                <div class="pane-body">
                    <c:choose>
                        <c:when test="${not empty isFooterTab}">
                            <!-- Left pane -->
                            <div class="doc-pane">
                                <div class="doc-pane-header">
                                    <h3><c:choose><c:when test="${activeTab == 'NEWS'}">Danh sách Bài viết Tin tức & KM</c:when><c:otherwise>Tài liệu chân trang</c:otherwise></c:choose></h3>
                                </div>
                                <div class="search-wrap">
                                    <form method="get" action="${pageContext.request.contextPath}/admin/general-policy" class="search-form">
                                        <c:if test="${activeTab == 'NEWS'}"><input type="hidden" name="tab" value="news"/></c:if>
                                        <input type="text" name="keyword" placeholder="Tìm kiếm..." value="${keyword}"/>
                                        <button type="submit">Tìm</button>
                                    </form>
                                </div>
                                <div class="doc-list">
                                    <c:choose>
                                        <c:when test="${not empty generalPolicies}">
                                            <c:forEach items="${generalPolicies}" var="gp">
                                                <a href="${pageContext.request.contextPath}/admin/general-policy?id=${gp.policyId}<c:if test='${activeTab == "NEWS"}'>&amp;tab=news</c:if><c:if test='${not empty keyword}'>&amp;keyword=${keyword}</c:if>">
                                                    <div class="doc-item ${selectedGeneralPolicy != null && selectedGeneralPolicy.policyId == gp.policyId ? 'active' : ''}">
                                                        <div class="doc-item-top">
                                                            <span class="doc-item-name">${gp.title}</span>
                                                        </div>
                                                    </div>
                                                </a>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="text-align:center;color:#9ca3af;padding:30px 0;font-size:13px;">Không tìm thấy chính sách nào.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Right pane -->
                            <div class="editor-pane">
                                <c:choose>
                                    <c:when test="${selectedGeneralPolicy != null}">
                                        <div class="editor-content">
                                            <!-- Display Settings Form -->
                                            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-bottom: 24px;">
                                                <h3 style="margin-top: 0; margin-bottom: 14px; font-size: 15px; color: #0f172a;"><c:choose><c:when test="${activeTab == 'NEWS'}">Cài đặt hiển thị bài viết</c:when><c:otherwise>Cài đặt hiển thị Footer (Footer Settings)</c:otherwise></c:choose></h3>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/general-policy" style="display: flex; flex-direction: column; gap: 16px;">
                                                    <input type="hidden" name="action" value="updateFooterSettings">
                                                    <input type="hidden" name="policyId" value="${selectedGeneralPolicy.policyId}">
                                                    <c:if test="${activeTab == 'NEWS'}"><input type="hidden" name="tab" value="news"></c:if>
                                                    
                                                    <div style="display: flex; align-items: center; gap: 10px;">
                                                        <input type="checkbox" id="showInFooter" name="showInFooter" value="true" ${selectedGeneralPolicy.showInFooter ? 'checked' : ''} style="width: 16px; height: 16px; cursor: pointer;">
                                                        <label for="showInFooter" style="font-size: 14px; color: #334155; font-weight: 500; cursor: pointer;"><c:choose><c:when test="${activeTab == 'NEWS'}">Đính kèm hiển thị đường link bài viết ở Footer</c:when><c:otherwise>Hiển thị ở Footer</c:otherwise></c:choose></label>
                                                    </div>
                                                    
                                                    <div style="display: flex; flex-direction: column; gap: 6px;">
                                                        <label for="footerOrder" style="font-size: 13px; color: #475569; font-weight: 500;">Thứ tự hiển thị</label>
                                                        <input type="number" id="footerOrder" name="footerOrder" value="${selectedGeneralPolicy.footerOrder}" min="0" style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; outline: none;">
                                                    </div>
                                                    
                                                    <button type="submit" class="btn btn-primary" style="width: fit-content; padding: 8px 16px; font-size: 13px;">Lưu cài đặt</button>
                                                </form>
                                            </div>
                                            
                                            <!-- Content Preview -->
                                            <div style="border-top: 1px solid #e2e8f0; padding-top: 20px;">
                                                <h3 style="margin-top: 0; margin-bottom: 12px; font-size: 15px; color: #0f172a;">Xem trước nội dung</h3>
                                                <div class="policy-text ql-editor" style="white-space:pre-wrap; padding: 0; max-height: 400px; overflow-y: auto; border: 1px solid #f1f5f9; padding: 12px; border-radius: 8px;">
                                                    ${selectedGeneralPolicy.content}
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="editor-footer">
                                            <button class="btn btn-danger btn-sm" onclick="openDeleteGeneralConfirm(${selectedGeneralPolicy.policyId})">&#128465; Xóa</button>
                                            <button class="btn btn-primary btn-sm" onclick="openModal('editGeneralModal')">&#9998; Sửa nội dung</button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <div class="empty-icon">&#128196;</div>
                                            <h3>Chưa chọn chính sách</h3>
                                            <p>Chọn một bài viết hoặc chính sách từ danh sách để quản lý và chỉnh sửa nội dung.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <!-- Left pane -->
                            <div class="doc-pane">
                                <div class="doc-pane-header"><h3>Tài liệu đang hoạt động</h3></div>
                                <div class="search-wrap">
                                     <form method="get" action="${pageContext.request.contextPath}/admin/policy" class="search-form" style="display: flex; flex-direction: column; gap: 8px;">
                                         <div style="display: flex; width: 100%;">
                                             <input type="text" name="keyword" placeholder="Tìm kiếm..." value="${keyword}" style="flex: 1; padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 7px 0 0 7px; font-size: 13px; outline: none;"/>
                                             <button type="submit" style="padding: 8px 12px; border: 1px solid #e5e7eb; border-left: none; background: #f9fafb; cursor: pointer; border-radius: 0 7px 7px 0; font-size: 13px;">Go</button>
                                         </div>
                                         <select name="statusFilter" onchange="this.form.submit()" style="width: 100%; padding: 8px 12px; border: 1px solid #e5e7eb; border-radius: 7px; font-size: 13px; outline: none; background: #fff; cursor: pointer; color: #374151; font-weight: 500;">
                                             <option value="">-- Tất cả trạng thái --</option>
                                             <option value="DRAFT" ${statusFilter eq 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                                             <option value="LIVE" ${statusFilter eq 'LIVE' or statusFilter eq 'PUBLISHED' ? 'selected' : ''}>Hoạt động</option>
                                             <option value="DISABLED" ${statusFilter eq 'DISABLED' ? 'selected' : ''}>Vô hiệu hóa</option>
                                         </select>
                                     </form>
                                 </div>
                                 <div class="doc-list">
                                     <c:choose>
                                         <c:when test="${not empty policies}">
                                             <c:forEach items="${policies}" var="p">
                                                 <a href="${pageContext.request.contextPath}/admin/policy?id=${p.policyId}<c:if test='${not empty keyword}'>&amp;keyword=${keyword}</c:if><c:if test='${not empty statusFilter}'>&amp;statusFilter=${statusFilter}</c:if>">
                                                     <div class="doc-item ${selectedPolicy != null && selectedPolicy.policyId == p.policyId ? 'active' : ''}">
                                                         <div class="doc-item-top">
                                                             <span class="doc-item-name">${p.policyName}</span>
                                                             <span class="badge
                                                                   <c:choose>
                                                                       <c:when test='${p.status eq "LIVE" or p.status eq "PUBLISHED"}'>badge-live</c:when>
                                                                       <c:when test='${p.status eq "DRAFT"}'>badge-draft</c:when>
                                                                       <c:otherwise>badge-disabled</c:otherwise>
                                                                   </c:choose>">${p.status}</span>
                                                         </div>
                                                         <div class="doc-item-meta">
                                                              <c:choose>
                                                                  <c:when test="${p.updatedAt != null}">Cập nhật ngày <fmt:formatDate value="${p.updatedAt}" pattern="dd/MM/yyyy"/></c:when>
                                                                  <c:otherwise>Không có thông tin</c:otherwise>
                                                              </c:choose>
                                                         </div>
                                                     </div>
                                                 </a>
                                             </c:forEach>
                                         </c:when>
                                         <c:otherwise>
                                             <div style="text-align:center;color:#9ca3af;padding:30px 0;font-size:13px;">Không tìm thấy chính sách nào.</div>
                                         </c:otherwise>
                                     </c:choose>
                                 </div>
                                 <c:if test="${totalPages > 1}">
                                     <div class="pagination">
                                         <c:forEach begin="1" end="${totalPages}" var="i">
                                             <a href="${pageContext.request.contextPath}/admin/policy?page=${i}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty statusFilter}'>&statusFilter=${statusFilter}</c:if>" class="${currentPage == i ? 'active' : ''}">
                                                 ${i}
                                             </a>
                                         </c:forEach>
                                     </div>
                                 </c:if>
                            </div>

                    <!-- Right pane -->
                    <div class="editor-pane">
                        <div class="editor-toolbar">
                            <div class="status-indicator">
                                <c:if test="${selectedPolicy != null}">
                                    <span>Trạng thái:</span>
                                    <select id="statusSelect" onchange="changeStatus(${selectedPolicy.policyId}, this.value)" style="padding: 4px 8px; border-radius: 6px; border: 1px solid #d1d5db; background: #fff; font-size: 13px; font-weight: 500; cursor: pointer; outline: none; margin-left: 4px;">
                                        <option value="DRAFT" ${selectedPolicy.status eq 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                                        <option value="LIVE" ${selectedPolicy.status eq 'LIVE' or selectedPolicy.status eq 'PUBLISHED' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="DISABLED" ${selectedPolicy.status eq 'DISABLED' ? 'selected' : ''}>Vô hiệu hóa</option>
                                    </select>
                                </c:if>
                                <c:if test="${selectedPolicy == null}">
                                    <span style="color:#9ca3af;font-size:13px;">Chưa chọn tài liệu</span>
                                </c:if>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${selectedPolicy != null}">
                                <div class="editor-content" id="policyView">
                                    <h1 class="policy-doc-title">${selectedPolicy.policyName}</h1>
                                    <div class="policy-meta-row">
                                        <div class="meta-item">
                                            <label>PHIÊN BẢN</label>
                                            <span class="meta-chip">${not empty selectedPolicy.version ? selectedPolicy.version : 'v1.0'}</span>
                                        </div>
                                        <div class="meta-item">
                                            <label>THỜI HẠN HIỆU LỰC</label>
                                            <span class="meta-chip">
                                                <c:choose>
                                                    <c:when test="${selectedPolicy.effectiveDate != null}">
                                                        <fmt:formatDate value="${selectedPolicy.effectiveDate}" pattern="dd/MM/yyyy"/>
                                                        →
                                                        <c:choose>
                                                            <c:when test="${selectedPolicy.expiryDate != null}">
                                                                <fmt:formatDate value="${selectedPolicy.expiryDate}" pattern="dd/MM/yyyy"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ∞
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="meta-item">
                                            <label>KHU VỰC ÁP DỤNG</label>
                                            <div class="region-chips">
                                                <c:choose>
                                                    <c:when test="${not empty selectedPolicy.applicableRegions}">
                                                        <c:forEach items="${fn:split(selectedPolicy.applicableRegions, ',')}" var="region">
                                                            <span class="region-chip">${fn:trim(region)}</span>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise><span class="meta-chip" style="color:#9ca3af;">—</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty selectedPolicy.policyContent}">
                                             <div class="policy-text ql-editor" style="white-space:pre-wrap; padding: 0;">${selectedPolicy.policyContent}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="policy-text" style="color:#9ca3af;font-style:italic;">Chưa có nội dung chính sách. Hãy chọn Chỉnh sửa chính sách để thêm nội dung.</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty selectedPolicy.description}">
                                        <div class="policy-highlight">
                                            <div class="hl-title">Ghi chú (${not empty selectedPolicy.version ? selectedPolicy.version : 'v1.0'}):</div>
                                            <div class="hl-body">${selectedPolicy.description}</div>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="editor-footer">
                                    <button class="btn btn-danger btn-sm" onclick="openDeleteConfirm(${selectedPolicy.policyId})">&#128465; Xóa</button>
                                    <button class="btn btn-outline btn-sm" onclick="openModal('editModal')">&#9998; Chỉnh sửa chính sách</button>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                                        <input type="hidden" name="action" value="saveDraft">
                                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <button type="submit" class="btn btn-outline btn-sm">&#128190; Lưu bản nháp</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                                        <input type="hidden" name="action" value="publish">
                                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <button type="submit" class="btn btn-primary btn-sm">&#9650; Phát hành</button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">&#128196;</div>
                                    <h3>Chưa chọn chính sách</h3>
                                    <p>Chọn một chính sách từ danh sách hoặc tạo mới.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

        <!-- Modal: Create -->
        <div class="modal-overlay" id="createModal">
            <div class="modal">
                <div class="modal-header">
                    <h2>Tạo chính sách mới</h2>
                    <button class="modal-close" onclick="closeModal('createModal')">&#215;</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/policy">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="form-group"><label>Tên chính sách *</label><input type="text" name="policyName" value="${formData.policyName}" placeholder="Ví dụ: Điều khoản bảo hành toàn cầu" required pattern=".*\p{L}.*"
                                                                                   title="Tên chính sách phải chứa ít nhất một chữ cái (không được chỉ gồm số hoặc ký tự đặc biệt)"></div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" style="color: #dc2626; font-weight: 500; margin-bottom: 12px;">
                                    ${error}
                                </div>
                            </c:if>
                        <div class="form-group"><label>Mô tả</label><textarea name="description" rows="2" placeholder="Tóm tắt nội dung...">${formData.description}</textarea></div>
                        <div class="form-group">
                            <label>Nội dung chính sách</label>
                            <input type="hidden" id="createPolicyContent" name="policyContent" value="${formData.policyContent}">
                            <div id="createQuillEditor" style="height: 200px; background: #fff; border: 1px solid #d1d5db; border-radius: 6px;"></div>
                        </div>
                        <div class="form-group"><label>Khu vực áp dụng <span style="font-weight:400;color:#9ca3af;">(phân cách bằng dấu phẩy, ví dụ: NA, EU)</span></label><input type="text" name="applicableRegions"  value="${formData.applicableRegions}" placeholder="Ví dụ: NA, EU, APAC"></div>
                        <div class="form-group"><label>Số tháng bảo hành</label><input type="number" name="warrantyMonths" min="1" 
                                                                                     value="${formData.warrantyMonths}" placeholder="Ví dụ: 24" step="1" required=""></div>
                        <div class="form-group"><label>Ngày có hiệu lực</label><input type="date" name="effectiveDate"  value="${formData.effectiveDate}"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline" onclick="closeModal('createModal')">Hủy</button>
                        <button type="submit" class="btn btn-primary">Tạo chính sách</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal: Edit -->
        <c:if test="${selectedPolicy != null}">
            <div class="modal-overlay" id="editModal">
                <div class="modal">
                    <div class="modal-header">
                        <h2>Chỉnh sửa chính sách</h2>
                        <button class="modal-close" onclick="closeModal('editModal')">&#215;</button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/policy">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                        <input type="hidden" name="page" value="${currentPage}">
                        <div class="modal-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" style="color: #dc2626; font-weight: 500; margin-bottom: 12px;">
                                    ${error}
                                </div>
                            </c:if>
                            <div class="form-group"><label>Tên chính sách *</label><input type="text" name="policyName" value="${selectedPolicy.policyName}" required pattern=".*\p{L}.*" title="Tên chính sách phải chứa ít nhất một chữ cái (không được chỉ gồm số hoặc ký tự đặc biệt)"></div>
                            <div class="form-group"><label>Mô tả</label><textarea name="description" rows="2">${selectedPolicy.description}</textarea></div>
                            <div class="form-group">
                                <label>Nội dung chính sách</label>
                                <input type="hidden" id="editPolicyContent" name="policyContent" value="${selectedPolicy.policyContent}">
                                <div id="editQuillEditor" style="height: 200px; background: #fff; border: 1px solid #d1d5db; border-radius: 6px;"></div>
                            </div>
                            <div class="form-group"><label>Khu vực áp dụng</label><input type="text" name="applicableRegions" value="${selectedPolicy.applicableRegions}"></div>
                            <div class="form-group"><label>Số tháng bảo hành</label><input type="number" name="warrantyMonths" min="1" value="${selectedPolicy.warrantyMonths}" step="1" required=""></div>
                            <div class="form-row">
                                <div class="form-group"><label>Ngày có hiệu lực</label><input type="date" name="effectiveDate" value="<fmt:formatDate value='${selectedPolicy.effectiveDate}' pattern='yyyy-MM-dd'/>"></div>
                                <div class="form-group"><label>Trạng thái</label>
                                    <select name="status">
                                        <option value="DRAFT"     ${selectedPolicy.status eq 'DRAFT'     ? 'selected' : ''}>Bản nháp</option>
                                        <option value="LIVE"      ${selectedPolicy.status eq 'LIVE'      ? 'selected' : ''}>Hoạt động</option>
                                        <option value="PUBLISHED" ${selectedPolicy.status eq 'PUBLISHED' ? 'selected' : ''}>Đã phát hành</option>
                                        <option value="DISABLED"  ${selectedPolicy.status eq 'DISABLED'  ? 'selected' : ''}>Vô hiệu hóa</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Modal: Delete Confirm -->
        <div class="modal-overlay" id="deleteModal">
            <div class="modal confirm-modal">
                <div class="modal-header"><h2>Xóa chính sách</h2><button class="modal-close" onclick="closeModal('deleteModal')">&#215;</button></div>
                <div class="modal-body">
                    <div class="confirm-icon">&#128465;&#65039;</div>
                    <div class="confirm-msg">Bạn có chắc chắn muốn xóa chính sách này?</div>
                    <div class="confirm-sub">Hành động này không thể hoàn tác.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeModal('deleteModal')">Hủy</button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="policyId" id="deletePolicyId" value="">
                        <input type="hidden" name="page" value="${currentPage}">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal: Version History -->
        <div class="modal-overlay" id="vhModal">
            <div class="modal" style="width:460px;">
                <div class="modal-header"><h2>Lịch sử phiên bản</h2><button class="modal-close" onclick="closeModal('vhModal')">&#215;</button></div>
                <div class="modal-body">
                    <c:choose>
                        <c:when test="${selectedPolicy == null}">
                            <p style="color:#9ca3af;text-align:center;padding:20px;">Vui lòng chọn một chính sách để xem lịch sử phiên bản.</p>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${not empty historyList}">
                                    <ul class="vh-list">
                                        <c:forEach items="${historyList}" var="h">
                                            <li class="vh-item">
                                                <div class="vh-dot">${not empty h.version ? h.version : 'v?'}</div>
                                                <div class="vh-info">
                                                    <div class="vh-ver">${h.policyName} (${not empty h.version ? h.version : 'v?'})</div>
                                                    <div class="vh-date">
                                                        <c:choose>
                                                            <c:when test="${h.actionType eq 'CREATED'}">
                                                                Tạo mới: <fmt:formatDate value="${h.changedAt}" pattern="dd MMM yyyy HH:mm"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Cập nhật: <fmt:formatDate value="${h.changedAt}" pattern="dd MMM yyyy HH:mm"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        &nbsp;&middot;&nbsp;
                                                        <span class="badge <c:choose><c:when test='${h.status eq "LIVE" or h.status eq "PUBLISHED"}'>badge-live</c:when><c:when test='${h.status eq "DRAFT"}'>badge-draft</c:when><c:otherwise>badge-disabled</c:otherwise></c:choose>">${h.status}</span>
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:#9ca3af;text-align:center;padding:20px;">Chưa có lịch sử thay đổi nào được ghi nhận cho chính sách này.</p>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="modal-footer"><button class="btn btn-outline" onclick="closeModal('vhModal')">Đóng</button></div>
            </div>
        </div>

        <!-- Modal: Create General Policy -->
        <div class="modal-overlay" id="createGeneralModal">
            <div class="modal">
                <div class="modal-header">
                    <h2><c:choose><c:when test="${activeTab == 'NEWS'}">Tạo bài viết Tin tức / Khuyến mãi mới</c:when><c:otherwise>Tạo chính sách chân trang mới</c:otherwise></c:choose></h2>
                    <button class="modal-close" onclick="closeModal('createGeneralModal')">&#215;</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/general-policy">
                    <input type="hidden" name="action" value="create">
                    <c:if test="${activeTab == 'NEWS'}"><input type="hidden" name="tab" value="news"></c:if>
                    <div class="modal-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" style="color: #dc2626; font-weight: 500; margin-bottom: 12px;">
                                ${error}
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label>Tiêu đề *</label>
                            <input type="text" name="title" placeholder="e.g. Chính sách vận chuyển" required pattern=".*\S.*" title="Tiêu đề không được để trống">
                        </div>
                        <div class="form-group">
                            <label>Mã chính sách (Code / Type) <span style="font-weight:400;color:#9ca3af;">(Optional)</span></label>
                            <input type="text" name="policyType" placeholder="e.g. PROMOTION" pattern="[A-Za-z0-9_]*" title="Chỉ cho phép chữ cái, số và dấu gạch dưới">
                        </div>
                        <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
                            <input type="checkbox" id="createShowInFooter" name="showInFooter" value="true" style="width: 16px; height: 16px; cursor: pointer;">
                            <label for="createShowInFooter" style="cursor: pointer; font-size: 13px; color: #374151;">Hiển thị đính kèm đường link ở Footer</label>
                        </div>
                        <div class="form-group">
                            <label>Nội dung chính sách</label>
                            <input type="hidden" id="createGeneralPolicyContent" name="content" value="">
                            <div id="createGeneralQuillEditor" style="height: 200px; background: #fff; border: 1px solid #d1d5db; border-radius: 6px;"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline" onclick="closeModal('createGeneralModal')">Hủy</button>
                        <button type="submit" class="btn btn-primary">Tạo chính sách</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal: Delete General Policy Confirm -->
        <div class="modal-overlay" id="deleteGeneralModal">
            <div class="modal confirm-modal" style="max-width: 450px;">
                <div class="modal-header"><h2>Xóa bài viết</h2><button class="modal-close" onclick="closeModal('deleteGeneralModal')">&#215;</button></div>
                <div class="modal-body">
                    <div class="confirm-msg" style="margin-bottom:20px; font-size: 14px; color: #475569;">Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeModal('deleteGeneralModal')">Hủy</button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/general-policy" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="policyId" id="deleteGeneralPolicyId" value="">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal: Edit General Policy Content -->
        <c:if test="${selectedGeneralPolicy != null}">
            <div class="modal-overlay" id="editGeneralModal">
                <div class="modal">
                    <div class="modal-header">
                        <h2>Sửa nội dung bài viết</h2>
                        <button class="modal-close" onclick="closeModal('editGeneralModal')">&#215;</button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/general-policy">
                        <input type="hidden" name="action" value="updateContent">
                        <input type="hidden" name="policyId" value="${selectedGeneralPolicy.policyId}">
                        <c:if test="${activeTab == 'NEWS'}"><input type="hidden" name="tab" value="news"></c:if>
                        <div class="modal-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" style="color: #dc2626; font-weight: 500; margin-bottom: 12px;">
                                    ${error}
                                </div>
                            </c:if>
                            <div class="form-group">
                                <label>Tiêu đề *</label>
                                <input type="text" name="title" value="${selectedGeneralPolicy.title}" required pattern=".*\S.*" title="Tiêu đề không được để trống">
                            </div>
                            <div class="form-group">
                                <label>Nội dung chính sách</label>
                                <input type="hidden" id="editGeneralPolicyContent" name="content" value="${selectedGeneralPolicy.content}">
                                <div id="editGeneralQuillEditor" style="height: 250px; background: #fff; border: 1px solid #d1d5db; border-radius: 6px;"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline" onclick="closeModal('editGeneralModal')">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <script>
            function openModal(id) {
                document.getElementById(id).classList.add('open');
            }
            function closeModal(id) {
                document.getElementById(id).classList.remove('open');
            }

            function openDeleteConfirm(id) {
                document.getElementById('deletePolicyId').value = id;
                openModal('deleteModal');
            }

            document.querySelectorAll('.modal-overlay').forEach(function (el) {
                el.addEventListener('click', function (e) {
                    if (e.target === el)
                        el.classList.remove('open');
                });
            });

            function changeStatus(policyId, newStatus) {
                var newAction = '';
                var statusText = '';
                if (newStatus === 'DRAFT') {
                    newAction = 'saveDraft';
                    statusText = 'Chuyển chính sách này về trạng thái Bản nháp?';
                } else if (newStatus === 'LIVE') {
                    <c:set var="cleanText" value="${selectedPolicy.policyContent.replaceAll('<[^>]*>', '').trim()}" />
                    <c:if test="${empty cleanText}">
                        alert('Nội dung chính sách không được để trống khi phát hành lên trạng thái Live!');
                        window.location.reload();
                        return;
                    </c:if>
                    newAction = 'publish';
                    statusText = 'Phát hành chính sách này lên trạng thái Live?';
                } else if (newStatus === 'DISABLED') {
                    newAction = 'disable';
                    statusText = 'Vô hiệu hóa chính sách này?';
                }
                
                if (!newAction || !confirm(statusText)) {
                    window.location.reload();
                    return;
                }
                
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/policy';
                var a = document.createElement('input');
                a.type = 'hidden';
                a.name = 'action';
                a.value = newAction;
                form.appendChild(a);
                var i = document.createElement('input');
                i.type = 'hidden';
                i.name = 'policyId';
                i.value = policyId;
                form.appendChild(i);
                var p = document.createElement('input');
                p.type = 'hidden';
                p.name = 'page';
                p.value = '${currentPage}';
                form.appendChild(p);
                document.body.appendChild(form);
                form.submit();
            }

            // Initialize Create Editor
            var createQuill = new Quill('#createQuillEditor', {
                theme: 'snow',
                modules: {
                    toolbar: [
                        ['bold', 'italic', 'underline'],
                        [{ 'header': [1, 2, 3, false] }],
                        [{ 'size': ['small', false, 'large', 'huge'] }],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        ['link', 'clean']
                    ]
                }
            });
            var initialCreate = document.getElementById('createPolicyContent').value;
            if (initialCreate) {
                createQuill.root.innerHTML = initialCreate;
            }
            document.querySelector('#createModal form').addEventListener('submit', function() {
                document.getElementById('createPolicyContent').value = createQuill.root.innerHTML;
            });

            // Initialize Edit Editor (if edit modal is rendered)
            var editPolicyInput = document.getElementById('editPolicyContent');
            if (editPolicyInput) {
                var editQuill = new Quill('#editQuillEditor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            ['bold', 'italic', 'underline'],
                            [{ 'header': [1, 2, 3, false] }],
                            [{ 'size': ['small', false, 'large', 'huge'] }],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['link', 'clean']
                        ]
                    }
                });
                var initialEdit = editPolicyInput.value;
                if (initialEdit) {
                    editQuill.root.innerHTML = initialEdit;
                }
                document.querySelector('#editModal form').addEventListener('submit', function(event) {
                    var status = this.status.value;
                    var contentValue = editQuill.root.innerHTML;
                    var cleanContent = contentValue.replace(/<[^>]*>/g, '').trim();
                    if ((status === 'LIVE' || status === 'PUBLISHED') && cleanContent === '') {
                        alert('Nội dung chính sách không được để trống khi phát hành lên trạng thái Live!');
                        event.preventDefault();
                        return false;
                    }
                    document.getElementById('editPolicyContent').value = editQuill.root.innerHTML;
                });
            }

            // Initialize Edit General Editor
            var editGeneralPolicyInput = document.getElementById('editGeneralPolicyContent');
            if (editGeneralPolicyInput) {
                var editGeneralQuill = new Quill('#editGeneralQuillEditor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            ['bold', 'italic', 'underline'],
                            [{ 'header': [1, 2, 3, false] }],
                            [{ 'size': ['small', false, 'large', 'huge'] }],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['link', 'image', 'clean']
                        ]
                    }
                });
                var initialEditGeneral = editGeneralPolicyInput.value;
                if (initialEditGeneral) {
                    editGeneralQuill.root.innerHTML = initialEditGeneral;
                }
                document.querySelector('#editGeneralModal form').addEventListener('submit', function(event) {
                    document.getElementById('editGeneralPolicyContent').value = editGeneralQuill.root.innerHTML;
                });
            }

            // Initialize Create General Editor
            var createGeneralPolicyInput = document.getElementById('createGeneralPolicyContent');
            if (createGeneralPolicyInput) {
                var createGeneralQuill = new Quill('#createGeneralQuillEditor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            ['bold', 'italic', 'underline'],
                            [{ 'header': [1, 2, 3, false] }],
                            [{ 'size': ['small', false, 'large', 'huge'] }],
                            [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                            ['link', 'image', 'clean']
                        ]
                    }
                });
                document.querySelector('#createGeneralModal form').addEventListener('submit', function(event) {
                    document.getElementById('createGeneralPolicyContent').value = createGeneralQuill.root.innerHTML;
                });
            }

            function openDeleteGeneralConfirm(id) {
                document.getElementById('deleteGeneralPolicyId').value = id;
                openModal('deleteGeneralModal');
            }

            (function () {
                var params = new URLSearchParams(window.location.search);
                if (params.get('edit') === '1')
                    openModal('editModal');

            <c:if test="${not empty error}">
                <c:choose>
                    <c:when test="${not empty formData}">
                openModal('createModal');
                    </c:when>
                    <c:otherwise>
                openModal('editModal');
                    </c:otherwise>
                </c:choose>
            </c:if>
            })();
        </script>
    
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
<!-- touch -->


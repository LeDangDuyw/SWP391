<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP — Policy Management</title>
        <style>
            *, *::before, *::after {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',system-ui,sans-serif;
            }
            body {
                background:#f0f2f5;
                color:#111;
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
                width:240px;
                flex-shrink:0;
                background:#fff;
                border-right:1px solid #e5e7eb;
                display:flex;
                flex-direction:column;
            }
            .sidebar-brand {
                padding:24px 20px 16px;
                display:flex;
                align-items:center;
                gap:12px;
            }
            .brand-avatar {
                width:42px;
                height:42px;
                border-radius:50%;
                background:#2563eb;
                color:#fff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:15px;
            }
            .brand-text .brand-name {
                font-weight:700;
                font-size:15px;
                color:#2563eb;
            }
            .brand-text .brand-role {
                font-size:12px;
                color:#6b7280;
                margin-top:2px;
            }
            .sidebar-nav {
                list-style:none;
                flex:1;
                padding:8px 0;
            }
            .sidebar-nav li a {
                display:flex;
                align-items:center;
                gap:10px;
                padding:11px 20px;
                font-size:14px;
                color:#374151;
                border-radius:6px;
                margin:2px 8px;
                transition:background .15s;
            }
            .sidebar-nav li a:hover {
                background:#f3f4f6;
            }
            .sidebar-nav li.active a {
                background:#dbeafe;
                color:#1d4ed8;
                font-weight:600;
            }
            .sidebar-footer {
                padding:16px 20px;
                border-top:1px solid #e5e7eb;
            }
            .sidebar-footer a {
                display:flex;
                align-items:center;
                gap:10px;
                font-size:14px;
                color:#6b7280;
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
    </head>
    <body>
        <div class="layout">

            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-avatar">UA</div>
                    <div class="brand-text">
                        <div class="brand-name">UNILAP Admin</div>
                        <div class="brand-role">System Controller</div>
                    </div>
                </div>
                <ul class="sidebar-nav">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#8862; Dashboard</a></li>
                    <li><a href="#">&#128230; Orders</a></li>
                    <li><a href="#">&#9636; Inventory</a></li>
                    <li><a href="#">&#128101; Users</a></li>
                    <li><a href="#">&#128202; Analytics</a></li>
                    <li class="active"><a href="${pageContext.request.contextPath}/admin/policy">&#128220; Policies</a></li>
                    <li><a href="#">&#9881; Settings</a></li>

                </ul>
                <div class="sidebar-footer"><a href="#">&#8617; Logout</a></div>
            </aside>

            <div class="main">
                <div class="topbar">
                    <span class="topbar-title">Console</span>
                    <div class="topbar-right">
                        <button class="icon-btn">&#128276;</button>
                        <button class="icon-btn">?</button>
                    </div>
                </div>

                <div class="page-header-wrap">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Settings</a>
                        <span>&rsaquo;</span>
                        <span style="color:#2563eb;font-weight:500;">Policy Management</span>
                    </div>
                    <div class="page-title-row">
                        <div>
                            <div class="page-title">Store Policies</div>
                            <div class="page-sub">Manage terms of service, privacy, and warranty documentation.</div>
                        </div>
                        <div class="page-actions">
                            <button class="btn btn-outline" onclick="openModal('vhModal')">&#128339; Version History</button>
                            <button class="btn btn-primary" onclick="openModal('createModal')">&#65291; New Policy</button>
                        </div>
                    </div>
                </div>

                <div class="pane-body">
                    <!-- Left pane -->
                    <div class="doc-pane">
                        <div class="doc-pane-header"><h3>Active Documents</h3></div>
                        <div class="search-wrap">
                            <form method="get" action="${pageContext.request.contextPath}/admin/policy" class="search-form">
                                <input type="text" name="keyword" placeholder="Search..." value="${keyword}"/>
                                <button type="submit">Go</button>
                            </form>
                        </div>
                        <div class="doc-list">
                            <c:choose>
                                <c:when test="${not empty policies}">
                                    <c:forEach items="${policies}" var="p">
                                        <a href="${pageContext.request.contextPath}/admin/policy?id=${p.policyId}&page=${currentPage}<c:if test='${not empty keyword}'>&amp;keyword=${keyword}</c:if>">
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
                                                        <c:when test="${p.updatedAt != null}">Updated <fmt:formatDate value="${p.updatedAt}" pattern="dd MMM yyyy"/></c:when>
                                                        <c:otherwise>No update info</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align:center;color:#9ca3af;padding:30px 0;font-size:13px;">No policies found.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">

                                <c:forEach begin="1" end="${totalPages}" var="i">

                                    <a href="${pageContext.request.contextPath}/admin/policy?page=${i}
                                       <c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>"
                                       class="${currentPage == i ? 'active' : ''}">

                                        ${i}

                                    </a>

                                </c:forEach>

                            </div>
                        </c:if>
                    </div>

                    <!-- Right pane -->
                    <div class="editor-pane">
                        <div class="editor-toolbar">
                            <div class="editor-tools">
                                <button class="tool-btn" style="font-weight:700;" title="Bold">B</button>
                                <button class="tool-btn" style="font-style:italic;" title="Italic">I</button>
                                <button class="tool-btn" style="text-decoration:underline;" title="Underline">U</button>
                                <div class="tool-sep"></div>
                                <button class="tool-btn" title="Link">&#128279;</button>
                                <button class="tool-btn" title="Image">&#128444;</button>
                            </div>
                            <div class="status-indicator">
                                <c:if test="${selectedPolicy != null}">
                                    <span>Status:</span>
                                    <div class="toggle-wrap">
                                        <button class="toggle ${selectedPolicy.status eq 'LIVE' or selectedPolicy.status eq 'PUBLISHED' ? 'on' : 'off'}"
                                                id="statusToggle"
                                                onclick="toggleStatus(${selectedPolicy.policyId}, '${selectedPolicy.status}')"></button>
                                        <span id="statusLabel">
                                            <c:choose>
                                                <c:when test="${selectedPolicy.status eq 'LIVE' or selectedPolicy.status eq 'PUBLISHED'}">Published</c:when>
                                                <c:otherwise>Draft/Disabled</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </c:if>
                                <c:if test="${selectedPolicy == null}">
                                    <span style="color:#9ca3af;font-size:13px;">No document selected</span>
                                </c:if>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${selectedPolicy != null}">
                                <div class="editor-content" id="policyView">
                                    <h1 class="policy-doc-title">${selectedPolicy.policyName}</h1>
                                    <div class="policy-meta-row">
                                        <div class="meta-item">
                                            <label>VERSION</label>
                                            <span class="meta-chip">${not empty selectedPolicy.version ? selectedPolicy.version : 'v1.0'}</span>
                                        </div>
                                        <div class="meta-item">
                                            <label>EFFECTIVE DATE</label>
                                            <span class="meta-chip">
                                                <c:choose>
                                                    <c:when test="${selectedPolicy.effectiveDate != null}"><fmt:formatDate value="${selectedPolicy.effectiveDate}" pattern="MM/dd/yyyy"/></c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="meta-item">
                                            <label>APPLICABLE REGIONS</label>
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
                                            <div class="policy-text" style="white-space:pre-wrap;">${selectedPolicy.policyContent}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="policy-text" style="color:#9ca3af;font-style:italic;">No policy content yet. Use Edit Policy to add body text.</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty selectedPolicy.description}">
                                        <div class="policy-highlight">
                                            <div class="hl-title">Note (${not empty selectedPolicy.version ? selectedPolicy.version : 'v1.0'}):</div>
                                            <div class="hl-body">${selectedPolicy.description}</div>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="editor-footer">
                                    <button class="btn btn-danger btn-sm" onclick="openDeleteConfirm(${selectedPolicy.policyId})">&#128465; Delete</button>
                                    <button class="btn btn-outline btn-sm" onclick="openModal('editModal')">&#9998; Edit Policy</button>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                                        <input type="hidden" name="action" value="saveDraft">
                                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <button type="submit" class="btn btn-outline btn-sm">&#128190; Save Draft</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                                        <input type="hidden" name="action" value="publish">
                                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <button type="submit" class="btn btn-primary btn-sm">&#9650; Publish</button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">&#128196;</div>
                                    <h3>No Policy Selected</h3>
                                    <p>Select a policy from the list or create a new one.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal: Create -->
        <div class="modal-overlay" id="createModal">
            <div class="modal">
                <div class="modal-header">
                    <h2>Create New Policy</h2>
                    <button class="modal-close" onclick="closeModal('createModal')">&#215;</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/policy">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="page" value="${currentPage}">
                    <div class="modal-body">
                        <div class="form-group"><label>Policy Name *</label><input type="text" name="policyName" value="${formData.policyName}" placeholder="e.g. Global Warranty Terms" required pattern=".*\S.*"
                                                                                   title="Policy Name cannot contain only spaces"></div>
                            <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                ${error}
                            </div>
                        </c:if>
                        <div class="form-group"><label>Description</label><textarea name="description" rows="2" placeholder="Short summary...">${formData.description}</textarea></div>
                        <div class="form-group"><label>Policy Content</label><textarea name="policyContent" rows="5" placeholder="Full policy body text...">${formData.policyContent}</textarea></div>
                        <div class="form-group"><label>Applicable Regions <span style="font-weight:400;color:#9ca3af;">(comma-separated, e.g. NA, EU)</span></label><input type="text" name="applicableRegions"  value="${formData.applicableRegions}" placeholder="e.g. NA, EU, APAC"></div>
                        <div class="form-row">
                            <div class="form-group"><label>Warranty Months</label><input type="number" name="warrantyMonths" min="1" value="${formData.applicableRegions}" placeholder="e.g. 24"></div>
                            <div class="form-group"><label>Version</label><input type="text" name="version" value="${formData.applicableRegions}" placeholder="e.g. v1.0" value="v1.0"></div>
                        </div>
                        <div class="form-group"><label>Effective Date</label><input type="date" name="effectiveDate"  value="${formData.applicableRegions}"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline" onclick="closeModal('createModal')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Policy</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal: Edit -->
        <c:if test="${selectedPolicy != null}">
            <div class="modal-overlay" id="editModal">
                <div class="modal">
                    <div class="modal-header">
                        <h2>Edit Policy</h2>
                        <button class="modal-close" onclick="closeModal('editModal')">&#215;</button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/policy">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="policyId" value="${selectedPolicy.policyId}">
                        <input type="hidden" name="page" value="${currentPage}">
                        <div class="modal-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    ${error}
                                </div>
                            </c:if>
                            <div class="form-group"><label>Policy Name *</label><input type="text" name="policyName" value="${selectedPolicy.policyName}" required pattern=".*\S.*" title="Policy Name cannot be empty or contain only spaces"></div>
                            <div class="form-group"><label>Description</label><textarea name="description" rows="2">${selectedPolicy.description}</textarea></div>
                            <div class="form-group"><label>Policy Content</label><textarea name="policyContent" rows="5">${selectedPolicy.policyContent}</textarea></div>
                            <div class="form-group"><label>Applicable Regions</label><input type="text" name="applicableRegions" value="${selectedPolicy.applicableRegions}"></div>
                            <div class="form-row">
                                <div class="form-group"><label>Warranty Months</label><input type="number" name="warrantyMonths" min="0" value="${selectedPolicy.warrantyMonths}"></div>
                                <div class="form-group"><label>Version</label><input type="text" name="version" value="${selectedPolicy.version}"></div>
                            </div>
                            <div class="form-row">
                                <div class="form-group"><label>Effective Date</label><input type="date" name="effectiveDate" value="<fmt:formatDate value='${selectedPolicy.effectiveDate}' pattern='yyyy-MM-dd'/>"></div>
                                <div class="form-group"><label>Status</label>
                                    <select name="status">
                                        <option value="DRAFT"     ${selectedPolicy.status eq 'DRAFT'     ? 'selected' : ''}>Draft</option>
                                        <option value="PUBLISHED" ${selectedPolicy.status eq 'PUBLISHED' ? 'selected' : ''}>Published</option>
                                        <option value="DISABLED"  ${selectedPolicy.status eq 'DISABLED'  ? 'selected' : ''}>Disabled</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Modal: Delete Confirm -->
        <div class="modal-overlay" id="deleteModal">
            <div class="modal confirm-modal">
                <div class="modal-header"><h2>Delete Policy</h2><button class="modal-close" onclick="closeModal('deleteModal')">&#215;</button></div>
                <div class="modal-body">
                    <div class="confirm-icon">&#128465;&#65039;</div>
                    <div class="confirm-msg">Are you sure you want to delete this policy?</div>
                    <div class="confirm-sub">This action cannot be undone.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="closeModal('deleteModal')">Cancel</button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/policy" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="policyId" id="deletePolicyId" value="">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal: Version History -->
        <div class="modal-overlay" id="vhModal">
            <div class="modal" style="width:460px;">
                <div class="modal-header"><h2>Version History</h2><button class="modal-close" onclick="closeModal('vhModal')">&#215;</button></div>
                <div class="modal-body">
                    <c:choose>
                        <c:when test="${not empty policies}">
                            <ul class="vh-list">
                                <c:forEach items="${policies}" var="p">
                                    <li class="vh-item">
                                        <div class="vh-dot">${not empty p.version ? p.version : 'v?'}</div>
                                        <div class="vh-info">
                                            <div class="vh-ver">${p.policyName}</div>
                                            <div class="vh-date">
                                                <c:choose>
                                                    <c:when test="${p.updatedAt != null}">Updated: <fmt:formatDate value="${p.updatedAt}" pattern="dd MMM yyyy HH:mm"/></c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                                &nbsp;&middot;&nbsp;
                                                <span class="badge <c:choose><c:when test='${p.status eq "LIVE" or p.status eq "PUBLISHED"}'>badge-live</c:when><c:when test='${p.status eq "DRAFT"}'>badge-draft</c:when><c:otherwise>badge-disabled</c:otherwise></c:choose>">${p.status}</span>
                                                    </div>
                                                </div>
                                            </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise><p style="color:#9ca3af;text-align:center;padding:20px;">No policies available.</p></c:otherwise>
                    </c:choose>
                </div>
                <div class="modal-footer"><button class="btn btn-outline" onclick="closeModal('vhModal')">Close</button></div>
            </div>
        </div>

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

            function toggleStatus(policyId, currentStatus) {
                var isLive = (currentStatus === 'LIVE' || currentStatus === 'PUBLISHED');
                var newAction = isLive ? 'disable' : 'publish';

                if (!confirm(isLive ? 'Set this policy to Disabled?' : 'Publish this policy as Live?'))
                    return;

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

            (function () {
                var params = new URLSearchParams(window.location.search);
                if (params.get('edit') === '1')
                    openModal('editModal');
            })();
        </script>
    </body>
</html>

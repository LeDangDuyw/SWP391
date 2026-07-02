<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Manage User Accounts</title>
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

            /* Alerts */
            .alert {
                padding: 12px 18px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .alert-success {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .alert-error {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Search Bar */
            .search-bar-container {
                display: flex;
                gap: 12px;
                margin-bottom: 24px;
                align-items: center;
                background: #fff;
                padding: 16px 20px;
                border-radius: 12px;
                box-shadow: 0 1px 4px rgba(0,0,0,.06);
            }
            .search-input {
                flex: 1;
                padding: 10px 16px;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                font-size: 14px;
                outline: none;
            }
            .search-input:focus {
                border-color: #0b39d1;
            }
            .search-btn {
                background: #0b39d1;
                color: #fff;
                border: none;
                padding: 10px 24px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .search-btn:hover {
                background: #092da3;
            }
            .clear-search-btn {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid #cbd5e1;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }
            .clear-search-btn:hover {
                background: #e2e8f0;
            }

            /* Table Card */
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
                vertical-align: middle;
            }
            tr:last-child td {
                border-bottom:none;
            }
            tbody tr:hover {
                background:#f9fafb;
            }

            /* Dropdown and Buttons */
            .role-select {
                padding: 6px 10px;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                background-color: #fff;
                font-size: 13px;
                color: #334155;
                outline: none;
                cursor: pointer;
                transition: border-color 0.2s;
            }
            .role-select:focus {
                border-color: #0b39d1;
            }
            .role-select[disabled] {
                background: #f1f5f9;
                color: #94a3b8;
                cursor: not-allowed;
                border-color: #e2e8f0;
            }
            .badge {
                display:inline-block;
                padding:3px 9px;
                border-radius:20px;
                font-size:11px;
                font-weight:600;
            }
            .badge-live {
                background:#dcfce7;
                color:#166534;
            }
            .badge-disabled {
                background:#fee2e2;
                color:#991b1b;
            }

            /* Action buttons */
            .action-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.2s;
                border: 1px solid transparent;
            }
            .btn-lock {
                background: #fef2f2;
                color: #ef4444;
                border-color: #fecaca;
            }
            .btn-lock:hover {
                background: #fee2e2;
                color: #dc2626;
            }
            .btn-unlock {
                background: #f0fdf4;
                color: #16a34a;
                border-color: #bbf7d0;
            }
            .btn-unlock:hover {
                background: #dcfce7;
                color: #15803d;
            }
            .btn-disabled {
                background: #f1f5f9;
                color: #94a3b8;
                border-color: #e2e8f0;
                cursor: not-allowed;
            }

            /* Pagination */
            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin-top: 24px;
            }
            .pagination-link {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 36px;
                height: 36px;
                padding: 0 6px;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                background: #fff;
                color: #334155;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s;
            }
            .pagination-link:hover {
                background: #f8fafc;
                border-color: #94a3b8;
            }
            .pagination-link.active {
                background: #0b39d1;
                color: #fff;
                border-color: #0b39d1;
            }
            .pagination-link.disabled {
                background: #f1f5f9;
                color: #94a3b8;
                cursor: not-allowed;
                pointer-events: none;
            }

            .empty-row td {
                text-align:center;
                color:#9ca3af;
                padding:40px;
            }

            @media (max-width: 1100px) {
                .sidebar { width: 220px; }
            }
            @media (max-width: 760px) {
                .layout { display: block; }
                .sidebar { position: static; width: 100%; height: auto; }
            }

            /* Detail Button Style */
            .btn-detail {
                background: #f1f5f9;
                color: #475569;
                border-color: #cbd5e1;
            }
            .btn-detail:hover {
                background: #e2e8f0;
                color: #1e293b;
            }

            /* Modal CSS */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(17, 24, 39, 0.7);
                backdrop-filter: blur(8px);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
            }
            .modal-overlay.active {
                opacity: 1;
                pointer-events: auto;
            }
            .modal-content {
                background: #fff;
                border-radius: 16px;
                width: 480px;
                max-width: 90%;
                box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
                transform: scale(0.9);
                transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                overflow: hidden;
            }
            .modal-overlay.active .modal-content {
                transform: scale(1);
            }
            .modal-header {
                padding: 18px 24px;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #f8fafc;
            }
            .modal-header h3 {
                font-size: 16px;
                font-weight: 700;
                color: #1e293b;
            }
            .modal-close-btn {
                background: none;
                border: none;
                font-size: 22px;
                color: #64748b;
                cursor: pointer;
                line-height: 1;
                padding: 4px;
                transition: color 0.2s;
            }
            .modal-close-btn:hover {
                color: #0f172a;
            }
            .modal-body {
                padding: 24px;
            }
            .modal-profile-header {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 20px;
                padding-bottom: 16px;
                border-bottom: 1px dashed #e2e8f0;
            }
            .modal-avatar-frame {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                overflow: hidden;
                border: 2px solid #e2e8f0;
                background: #f1f5f9;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }
            .modal-avatar-frame img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .modal-avatar-frame span {
                font-size: 28px;
                color: #94a3b8;
            }
            .modal-profile-info {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .modal-profile-name {
                font-size: 16px;
                font-weight: 700;
                color: #0f172a;
            }
            .modal-detail-grid {
                display: grid;
                grid-template-columns: 1fr;
                gap: 12px;
            }
            .modal-detail-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                border-bottom: 1px solid #f1f5f9;
            }
            .modal-detail-item:last-child {
                border-bottom: none;
            }
            .modal-detail-label {
                font-size: 13px;
                font-weight: 600;
                color: #64748b;
            }
            .modal-detail-value {
                font-size: 13px;
                color: #1e293b;
                font-weight: 500;
                text-align: right;
            }
            .modal-footer {
                padding: 14px 24px;
                background: #f8fafc;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
            }
            .modal-btn-primary {
                background: #0b39d1;
                color: #fff;
                border: none;
                padding: 8px 18px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 13px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .modal-btn-primary:hover {
                background: #092da3;
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
                <nav>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
                    <a href="#"><span>▣</span>Orders</a>
                    <a class="active" href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
                    <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
                    <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
                    <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
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

            <!-- Main Panel -->
            <div class="main">
                <div class="topbar">
                    <span class="topbar-title">Account Administration</span>
                    <div class="topbar-right">
                        <button class="icon-btn" title="Notifications">&#128276;</button>
                        <button class="icon-btn" title="Help">?</button>
                    </div>
                </div>

                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &gt; <span>Users</span>
                </div>

                <div class="content">
                    <div class="page-title">Manage User Accounts</div>
                    <div class="page-sub">Monitor accounts, adjust systemic roles, and activate or lock user profiles.</div>

                    <!-- Alerts for feedback messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <span>✔</span> ${successMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <span>⚠</span> ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Search & Filter Form -->
                    <form action="${pageContext.request.contextPath}/admin/users" method="GET">
                        <input type="hidden" name="from" value="${from}">
                        <input type="hidden" name="to" value="${to}">
                        <div class="search-bar-container">
                            <input type="text" name="search" class="search-input" value="${searchKeyword}" placeholder="Tìm kiếm theo họ tên hoặc địa chỉ email...">
                            
                            <select name="role" class="role-select" style="padding: 10px 16px; font-size: 14px;" onchange="this.form.submit()">
                                <option value="">Tất cả vai trò</option>
                                <option value="1" ${selectedRole == '1' ? 'selected' : ''}>Admin</option>
                                <option value="2" ${selectedRole == '2' ? 'selected' : ''}>Staff</option>
                                <option value="3" ${selectedRole == '3' ? 'selected' : ''}>Customer</option>
                            </select>

                            <select name="status" class="role-select" style="padding: 10px 16px; font-size: 14px;" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <button type="submit" class="search-btn">Tìm kiếm</button>
                            
                            <c:if test="${not empty searchKeyword || not empty selectedRole || not empty selectedStatus || not empty from || not empty to}">
                                <a href="${pageContext.request.contextPath}/admin/users" class="clear-search-btn">Xóa lọc</a>
                            </c:if>
                            
                            <button type="button" class="search-btn" style="background: #16a34a; margin-left: auto;" onclick="openAddUserModal()">
                                ✚ Thêm tài khoản
                            </button>
                        </div>
                    </form>

                    <!-- Users Table Card -->
                    <div class="table-card">
                        <div class="table-card-header">
                            <h2>Danh sách tài khoản (${totalUsers})</h2>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty usersList}">
                                        <c:forEach items="${usersList}" var="u">
                                            <tr>
                                                <td>#${u.userId}</td>
                                                <td><c:out value="${u.userName}"/></td>
                                                <td><c:out value="${u.email}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty u.phone}"><c:out value="${u.phone}"/></c:when>
                                                        <c:otherwise><span style="color:#94a3b8; font-style:italic;">Chưa có</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <!-- Role Selection Dropdown -->
                                                    <select class="role-select" 
                                                            data-current="${u.roleId}"
                                                            onchange="submitRoleAction(${u.userId}, '${u.email}', this)"
                                                            <c:if test="${u.userId == sessionScope.user.userId}">disabled</c:if>>
                                                        <option value="1" ${u.roleId == 1 ? 'selected' : ''}>Admin</option>
                                                        <option value="2" ${u.roleId == 2 ? 'selected' : ''}>Staff</option>
                                                        <option value="3" ${u.roleId == 3 ? 'selected' : ''}>Customer</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <!-- Status Badge -->
                                                    <span class="badge ${u.status ? 'badge-live' : 'badge-disabled'}">
                                                        <c:choose>
                                                            <c:when test="${u.status}">Active</c:when>
                                                            <c:otherwise>Inactive</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <!-- Format timestamps for detail attributes -->
                                                    <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" var="formattedCreatedAt"/>
                                                    <fmt:formatDate value="${u.lastLoginAt}" pattern="dd/MM/yyyy HH:mm:ss" var="formattedLastLogin"/>

                                                    <!-- Action buttons (Detail & Lock/Unlock) -->
                                                    <div style="display: flex; gap: 6px; align-items: center;">
                                                        <button type="button" class="action-btn btn-detail"
                                                                data-id="${u.userId}"
                                                                data-name="<c:out value='${u.userName}'/>"
                                                                data-email="<c:out value='${u.email}'/>"
                                                                data-phone="<c:out value='${u.phone}'/>"
                                                                data-role="${u.roleId == 1 ? 'Admin' : (u.roleId == 2 ? 'Staff' : 'Customer')}"
                                                                data-status="${u.status ? 'Active' : 'Inactive'}"
                                                                data-avatar="<c:out value='${u.avatarUrl}'/>"
                                                                data-created="${formattedCreatedAt}"
                                                                data-last-login="${formattedLastLogin}"
                                                                onclick="openUserModal(this)">
                                                            Chi tiết
                                                        </button>
                                                        <c:choose>
                                                            <c:when test="${u.userId == sessionScope.user.userId}">
                                                                <span class="action-btn btn-disabled" title="Bạn không thể tự khóa chính mình">
                                                                    Khóa
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${u.status}">
                                                                <button type="button" class="action-btn btn-lock" onclick="submitLockAction(${u.userId}, '${u.email}', true)">
                                                                    Khóa
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="action-btn btn-unlock" onclick="submitLockAction(${u.userId}, '${u.email}', false)">
                                                                    Mở khóa
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="7">Không tìm thấy tài khoản nào phù hợp với từ khóa.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&search=${searchKeyword}&role=${selectedRole}&status=${selectedStatus}&from=${from}&to=${to}" 
                               class="pagination-link ${currentPage == 1 ? 'disabled' : ''}">
                                &lt; Trước
                            </a>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/admin/users?page=${i}&search=${searchKeyword}&role=${selectedRole}&status=${selectedStatus}&from=${from}&to=${to}" 
                                   class="pagination-link ${currentPage == i ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                            
                            <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&search=${searchKeyword}&role=${selectedRole}&status=${selectedStatus}&from=${from}&to=${to}" 
                               class="pagination-link ${currentPage == totalPages ? 'disabled' : ''}">
                                Sau &gt;
                            </a>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>

        <!-- Hidden submit form for POST actions -->
        <form id="actionForm" action="${pageContext.request.contextPath}/admin/users" method="POST" style="display: none;">
            <input type="hidden" name="action" id="formAction">
            <input type="hidden" name="userId" id="formUserId">
            <input type="hidden" name="roleId" id="formRoleId">
            <input type="hidden" name="search" value="<c:out value='${searchKeyword}'/>">
            <input type="hidden" name="page" value="${currentPage}">
            <input type="hidden" name="roleFilter" value="<c:out value='${selectedRole}'/>">
            <input type="hidden" name="statusFilter" value="<c:out value='${selectedStatus}'/>">
        </form>

        <!-- User Detail Modal -->
        <div id="userDetailModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Chi tiết tài khoản</h3>
                    <button class="modal-close-btn" onclick="closeUserModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="modal-profile-header">
                        <div class="modal-avatar-frame" id="modalAvatarFrame">
                            <!-- Avatar dynamically populated -->
                        </div>
                        <div class="modal-profile-info">
                            <div class="modal-profile-name" id="modalUserName"></div>
                            <div id="modalRoleBadgeContainer"></div>
                        </div>
                    </div>
                    <div class="modal-detail-grid">
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">User ID</span>
                            <span class="modal-detail-value" id="modalUserId"></span>
                        </div>
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">Email</span>
                            <span class="modal-detail-value" id="modalUserEmail"></span>
                        </div>
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">Số điện thoại</span>
                            <span class="modal-detail-value" id="modalUserPhone"></span>
                        </div>
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">Trạng thái</span>
                            <span class="modal-detail-value" id="modalStatusBadgeContainer"></span>
                        </div>
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">Ngày đăng ký</span>
                            <span class="modal-detail-value" id="modalUserCreated"></span>
                        </div>
                        <div class="modal-detail-item">
                            <span class="modal-detail-label">Lần đăng nhập cuối</span>
                            <span class="modal-detail-value" id="modalUserLastLogin"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-btn-primary" onclick="closeUserModal()">Đóng</button>
                </div>
            </div>
        </div>

        <!-- Add User Modal -->
        <div id="addUserModal" class="modal-overlay">
            <div class="modal-content" style="max-width: 500px; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);">
                <div class="modal-header" style="background: #f8fafc; border-bottom: 1px solid #e2e8f0; padding: 18px 24px;">
                    <h3 style="font-size: 18px; font-weight: 700; color: #1e293b; margin: 0;">Tạo tài khoản mới</h3>
                    <button class="modal-close-btn" onclick="closeAddUserModal()" style="font-size: 24px; color: #94a3b8; background: none; border: none; cursor: pointer; transition: color 0.2s;">&times;</button>
                </div>
                <form id="addUserForm" action="${pageContext.request.contextPath}/admin/users" method="POST" onsubmit="return validateAddUserForm(event)">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="search" value="<c:out value='${searchKeyword}'/>">
                    <input type="hidden" name="page" value="${currentPage}">
                    <input type="hidden" name="roleFilter" value="<c:out value='${selectedRole}'/>">
                    <input type="hidden" name="statusFilter" value="<c:out value='${selectedStatus}'/>">

                    <div class="modal-body" style="padding: 20px 24px; display: flex; flex-direction: column; gap: 16px;">
                        
                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase;">Họ và tên <span style="color: red;">*</span></label>
                            <input type="text" name="fullName" id="addFullName" required
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none;" placeholder="Nhập họ và tên">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase;">Email (Tên đăng nhập) <span style="color: red;">*</span></label>
                            <input type="email" name="email" id="addEmail" required
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none;" placeholder="example@domain.com">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase;">Số điện thoại</label>
                            <input type="text" name="phone" id="addPhone"
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none;" placeholder="Nhập số điện thoại (10 chữ số)">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase;">Mật khẩu khởi tạo <span style="color: red;">*</span></label>
                            <input type="password" name="password" id="addPassword" required minlength="6"
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none;" placeholder="Nhập ít nhất 6 ký tự">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase;">Vai trò / Phân quyền <span style="color: red;">*</span></label>
                            <select name="roleId" id="addRoleId" required
                                    style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; background-color: #fff; cursor: pointer;">
                                <option value="3">Customer (Khách hàng)</option>
                                <option value="2">Staff (Nhân viên)</option>
                                <option value="1">Admin (Quản trị viên)</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer" style="background: #f8fafc; border-top: 1px solid #e2e8f0; padding: 14px 24px; display: flex; gap: 10px; justify-content: flex-end;">
                        <button type="button" class="clear-search-btn" style="padding: 8px 18px; margin: 0; font-size: 13px;" onclick="closeAddUserModal()">Hủy</button>
                        <button type="submit" class="modal-btn-primary" style="background: #16a34a; padding: 8px 18px; font-size: 13px;">Tạo tài khoản</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Tự động ẩn các thông báo (alert) sau 3 giây
            document.addEventListener("DOMContentLoaded", function() {
                var alerts = document.querySelectorAll(".alert");
                alerts.forEach(function(alert) {
                    setTimeout(function() {
                        alert.style.maxHeight = alert.scrollHeight + "px";
                        alert.style.overflow = "hidden";
                        alert.offsetHeight; // Force reflow
                        alert.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out, max-height 0.5s ease-out, margin-bottom 0.5s ease-out, padding-top 0.5s ease-out, padding-bottom 0.5s ease-out";
                        alert.style.opacity = "0";
                        alert.style.transform = "translateY(-10px)";
                        alert.style.maxHeight = "0";
                        alert.style.paddingTop = "0";
                        alert.style.paddingBottom = "0";
                        alert.style.marginBottom = "0";
                        setTimeout(function() {
                            alert.remove();
                        }, 500);
                    }, 3000);
                });
            });

            function submitLockAction(userId, email, isLock) {
                var actionCode = isLock ? "lock" : "unlock";
                
                if (isLock) {
                    // Check active orders count before locking
                    fetch("${pageContext.request.contextPath}/admin/users?ajaxAction=checkActiveOrders&userId=" + userId)
                        .then(function(response) { return response.json(); })
                        .then(function(data) {
                            var count = data.activeOrdersCount || 0;
                            if (count > 0) {
                                alert("Không thể khóa tài khoản này vì người dùng [" + email + "] đang có " + count + " đơn hàng chưa hoàn tất!");
                                return;
                            }
                            if (confirm("Bạn có chắc chắn muốn KHÓA tài khoản [" + email + "] không?")) {
                                executeLockAction(actionCode, userId);
                            }
                        })
                        .catch(function(err) {
                            console.error("Lỗi kiểm tra đơn hàng: ", err);
                            // Fallback to normal confirm on error
                            if (confirm("Bạn có chắc chắn muốn KHÓA tài khoản [" + email + "] không?")) {
                                executeLockAction(actionCode, userId);
                            }
                        });
                } else {
                    if (confirm("Bạn có chắc chắn muốn MỞ KHÓA tài khoản [" + email + "] không?")) {
                        executeLockAction(actionCode, userId);
                    }
                }
            }

            function executeLockAction(actionCode, userId) {
                document.getElementById("formAction").value = actionCode;
                document.getElementById("formUserId").value = userId;
                document.getElementById("actionForm").submit();
            }

            function submitRoleAction(userId, email, selectElement) {
                var newRoleId = selectElement.value;
                var roleName = selectElement.options[selectElement.selectedIndex].text;
                
                if (confirm("Bạn có chắc chắn muốn đổi vai trò tài khoản [" + email + "] thành [" + roleName + "] không?")) {
                    document.getElementById("formAction").value = "change-role";
                    document.getElementById("formUserId").value = userId;
                    document.getElementById("formRoleId").value = newRoleId;
                    document.getElementById("actionForm").submit();
                } else {
                    // Reset the dropdown back to current role value if cancel
                    selectElement.value = selectElement.getAttribute("data-current");
                }
            }

            function openUserModal(btn) {
                var userId = btn.getAttribute("data-id");
                var name = btn.getAttribute("data-name");
                var email = btn.getAttribute("data-email");
                var phone = btn.getAttribute("data-phone");
                var role = btn.getAttribute("data-role");
                var status = btn.getAttribute("data-status");
                var avatar = btn.getAttribute("data-avatar");
                var created = btn.getAttribute("data-created");
                var lastLogin = btn.getAttribute("data-last-login");
                
                // Populate text fields
                document.getElementById("modalUserId").textContent = "#" + userId;
                document.getElementById("modalUserName").textContent = name;
                document.getElementById("modalUserEmail").textContent = email;
                document.getElementById("modalUserPhone").textContent = phone && phone.trim() !== "" ? phone : "Chưa có";
                document.getElementById("modalUserCreated").textContent = created && created.trim() !== "" ? created : "Chưa có dữ liệu";
                document.getElementById("modalUserLastLogin").textContent = lastLogin && lastLogin.trim() !== "" ? lastLogin : "Chưa từng đăng nhập";
                
                // Populate avatar
                var avatarFrame = document.getElementById("modalAvatarFrame");
                avatarFrame.innerHTML = "";
                if (avatar && avatar.trim() !== "" && avatar.trim() !== "null") {
                    var img = document.createElement("img");
                    img.src = "${pageContext.request.contextPath}/images/" + avatar;
                    img.alt = "Avatar";
                    img.onerror = function() {
                        avatarFrame.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 30px; height: 30px; color: #94a3b8;"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>';
                    };
                    avatarFrame.appendChild(img);
                } else {
                    avatarFrame.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 30px; height: 30px; color: #94a3b8;"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>';
                }
                
                // Populate Role Badge
                var roleContainer = document.getElementById("modalRoleBadgeContainer");
                roleContainer.innerHTML = "";
                var roleSpan = document.createElement("span");
                roleSpan.className = "badge";
                if (role === "Admin") {
                    roleSpan.style.background = "#e0e7ff";
                    roleSpan.style.color = "#4338ca";
                } else if (role === "Staff") {
                    roleSpan.style.background = "#fef3c7";
                    roleSpan.style.color = "#d97706";
                } else {
                    roleSpan.style.background = "#f3f4f6";
                    roleSpan.style.color = "#4b5563";
                }
                roleSpan.textContent = role;
                roleContainer.appendChild(roleSpan);
                
                // Populate Status Badge
                var statusContainer = document.getElementById("modalStatusBadgeContainer");
                statusContainer.innerHTML = "";
                var statusSpan = document.createElement("span");
                if (status === "Active") {
                    statusSpan.className = "badge badge-live";
                    statusSpan.textContent = "Active";
                } else {
                    statusSpan.className = "badge badge-disabled";
                    statusSpan.textContent = "Inactive";
                }
                statusContainer.appendChild(statusSpan);
                
                // Show modal
                var modal = document.getElementById("userDetailModal");
                modal.classList.add("active");
            }
            
            function closeUserModal() {
                var modal = document.getElementById("userDetailModal");
                modal.classList.remove("active");
            }

            function openAddUserModal() {
                // Clear any previous values
                document.getElementById("addFullName").value = "";
                document.getElementById("addEmail").value = "";
                document.getElementById("addPhone").value = "";
                document.getElementById("addPassword").value = "";
                document.getElementById("addRoleId").value = "3";
                
                var modal = document.getElementById("addUserModal");
                modal.classList.add("active");
            }

            function closeAddUserModal() {
                var modal = document.getElementById("addUserModal");
                modal.classList.remove("active");
            }

            function validateAddUserForm(event) {
                var email = document.getElementById("addEmail").value.trim();
                var phone = document.getElementById("addPhone").value.trim();
                var password = document.getElementById("addPassword").value.trim();

                // Basic email pattern validation
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert("Định dạng email không hợp lệ!");
                    event.preventDefault();
                    return false;
                }

                // Phone number validation (optional but must be 10 digits if present)
                if (phone !== "") {
                    var phoneRegex = /^[0-9]{10}$/;
                    if (!phoneRegex.test(phone)) {
                        alert("Số điện thoại phải bao gồm 10 chữ số!");
                        event.preventDefault();
                        return false;
                    }
                }

                // Password length check
                if (password.length < 6) {
                    alert("Mật khẩu khởi tạo phải có ít nhất 6 ký tự!");
                    event.preventDefault();
                    return false;
                }

                return true;
            }
            
            // Close modal when clicking on overlay background
            window.addEventListener("click", function(event) {
                var detailModal = document.getElementById("userDetailModal");
                var addModal = document.getElementById("addUserModal");
                if (event.target === detailModal) {
                    closeUserModal();
                }
                if (event.target === addModal) {
                    closeAddUserModal();
                }
            });

            // Close modal with Escape key
            window.addEventListener("keydown", function(event) {
                if (event.key === "Escape") {
                    closeUserModal();
                    closeAddUserModal();
                }
            });
        </script>
    </body>
</html>


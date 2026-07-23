<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* --- STAFF SIDEBAR MASTER STYLES --- */
.sidebar {
    width: 280px !important;
    min-width: 280px !important;
    max-width: 280px !important;
    background: #eef2f7 !important;
    border-right: 1px solid #e1e6ef !important;
    padding: 28px 16px !important;
    display: flex !important;
    flex-direction: column !important;
    position: sticky !important;
    top: 0 !important;
    height: 100vh !important;
    box-sizing: border-box !important;
    z-index: 100 !important;
}
.sidebar .brand {
    margin: 6px 10px 44px !important;
    display: flex !important;
    flex-direction: column !important;
    gap: 4px !important;
}
.sidebar .brand span {
    color: #0b39d1 !important;
    font-size: 24px !important;
    font-weight: 800 !important;
    letter-spacing: -0.5px !important;
    line-height: 1.2 !important;
    display: block !important;
}
.sidebar .brand small {
    color: #6b778c !important;
    font-size: 12px !important;
    font-weight: 600 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.5px !important;
    display: block !important;
}
.sidebar nav {
    display: flex !important;
    flex-direction: column !important;
    gap: 6px !important;
}
.sidebar nav a {
    display: flex !important;
    align-items: center !important;
    gap: 12px !important;
    padding: 12px 14px !important;
    border-radius: 12px !important;
    color: #44546f !important;
    font-size: 14px !important;
    font-weight: 600 !important;
    text-decoration: none !important;
    transition: all .15s ease !important;
    box-sizing: border-box !important;
}
.sidebar nav a .nav-icon {
    font-size: 16px !important;
    min-width: 20px !important;
    display: inline-block !important;
    text-align: center !important;
    color: inherit !important;
}
.sidebar nav a:hover {
    background: #e4e9f2 !important;
    color: #0b39d1 !important;
}
.sidebar nav a.active {
    background: #0b39d1 !important;
    color: #ffffff !important;
    box-shadow: 0 8px 16px rgba(11, 57, 209, .22) !important;
}
.sidebar nav a.active .nav-icon {
    color: #ffffff !important;
}
.sidebar .profile {
    margin-top: auto !important;
    padding: 16px 8px 0 !important;
    border-top: 1px solid #e1e6ef !important;
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    flex-direction: row !important;
    gap: 8px !important;
}
.sidebar .profile-info {
    cursor: pointer !important;
    display: flex !important;
    align-items: center !important;
    gap: 8px !important;
    color: #191c1e !important;
    font-size: 14px !important;
    font-weight: 600 !important;
    text-decoration: none !important;
}
.sidebar .logout-btn {
    color: #dc2626 !important;
    background: #fff5f5 !important;
    border: 1px solid #fecaca !important;
    font-size: 13px !important;
    font-weight: 600 !important;
    padding: 6px 14px !important;
    border-radius: 8px !important;
    text-decoration: none !important;
    white-space: nowrap !important;
    transition: all .15s ease !important;
    display: inline-block !important;
}
.sidebar .logout-btn:hover {
    background: #fee2e2 !important;
    border-color: #fca5a5 !important;
    color: #b91c1c !important;
}
</style>

<aside class="sidebar">
    <div class="brand">
        <span>UNILAP Staff</span>
        <small>HỆ THỐNG QUẢN TRỊ</small>
    </div>
    <nav>
        <a class="${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/dashboard">
            <span class="nav-icon">📊</span>Bảng điều khiển
        </a>
        <a class="${param.activePage == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/inventory">
            <span class="nav-icon">💻</span>Danh sách sản phẩm
        </a>
        <a class="${param.activePage == 'category' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/category">
            <span class="nav-icon">📁</span>Danh mục
        </a>
        <a class="${param.activePage == 'imei' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/imei">
            <span class="nav-icon">🏷️</span>Quản lí serial
        </a>
        <a class="${param.activePage == 'ticket' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/ticket/list">
            <span class="nav-icon">📄</span>Phiếu nhập hàng
        </a>
        <a class="${param.activePage == 'order' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/order/list">
            <span class="nav-icon">📋</span>Đơn hàng
        </a>
        <a class="${param.activePage == 'outbound' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/outbound/list">
            <span class="nav-icon">📦</span>Xuất kho
        </a>
        <a class="${param.activePage == 'warranty' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/warranty?action=list">
            <span class="nav-icon">🛠️</span>Bảo hành
        </a>
    </nav>
    <div class="profile">
        <div class="profile-info" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
            <%
                model.Users u = (model.Users) session.getAttribute("user");
                if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
            %>
                <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                     alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
            <% } else { %>
                <span>♙</span>
            <% } %>
            <span>Staff Profile</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</aside>

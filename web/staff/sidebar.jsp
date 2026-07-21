<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    Component: Staff Sidebar (Navbar bên trái dành cho Nhân viên)
    Nhận param activePage để highlight mục tương ứng:
    - inventory
    - category
    - imei
    - ticket
    - order
    - outbound
    - reviews
    - warranty
    - verifications
--%>
<aside class="sidebar">
    <div class="brand">
        <span>UNILAP Staff</span>
        <small>Quản trị hệ thống</small>
    </div>
    <nav>
        <a class="${param.activePage == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/inventory">
            <span class="nav-icon">▤</span>Kho hàng
        </a>
        <a class="${param.activePage == 'category' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/category">
            <span class="nav-icon">📁</span>Danh mục
        </a>
        <a class="${param.activePage == 'imei' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/imei">
            <span class="nav-icon">🏷</span>IMEI
        </a>
        <a class="${param.activePage == 'ticket' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/ticket/list">
            <span class="nav-icon">🎫</span>Yêu cầu hỗ trợ
        </a>
        <a class="${param.activePage == 'order' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/order/list">
            <span class="nav-icon">📋</span>Đơn hàng
        </a>
        <a class="${param.activePage == 'outbound' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/outbound/list">
            <span class="nav-icon">📦</span>Xuất kho
        </a>
        <a class="${param.activePage == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reviews">
            <span class="nav-icon">★</span>Quản lý đánh giá
        </a>
        <a class="${param.activePage == 'warranty' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/warranty?action=list">
            <span class="nav-icon">🛠</span>Bảo hành
        </a>
        <a class="${param.activePage == 'verifications' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/verifications">
            <span class="nav-icon">🎓</span>Xác thực sinh viên
        </a>
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
            <span>Hồ sơ nhân viên</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
    </div>
</aside>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    Component: Admin Sidebar (Navbar bên trái)
    Nhận param activePage để highlight mục tương ứng
--%>
<aside class="sidebar">
    <div class="brand">
        <span>UNILAP Admin</span>
        <small>Quản trị hệ thống</small>
    </div>
    <nav>
        <a class="${param.activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
            <span>▦</span>Bảng điều khiển
        </a>
        <a class="${param.activePage == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
            <span>♚</span>Người dùng
        </a>
        
        <div class="sidebar-dropdown">
            <a href="javascript:void(0)" class="sidebar-dropdown-btn" onclick="toggleSidebarDropdown(this)" style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                <span style="display: flex; align-items: center; gap: 14px;"><span>📊</span>Thống kê</span>
                <span class="dropdown-arrow" style="font-size: 10px; transition: transform 0.2s; transform: rotate(${param.activePage == 'promotions' || param.activePage == 'analytics' ? '180deg' : '0deg'});">▼</span>
            </a>
            <div class="sidebar-dropdown-container" style="display: ${param.activePage == 'promotions' || param.activePage == 'analytics' ? 'flex' : 'none'}; flex-direction: column; gap: 4px; margin-top: 4px;">
                <a class="${param.activePage == 'promotions' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/promotions">
                    <span>▥</span>Mã giảm giá & Khuyến mãi
                </a>
                <a class="${param.activePage == 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/analytics">
                    <span>📈</span>Phân tích nâng cao
                </a>
            </div>
        </div>
        
        <a class="${param.activePage == 'policy' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/policy">
            <span>📜</span>Chính sách
        </a>
        <a class="${param.activePage == 'warranty' ? 'active' : ''}" href="${pageContext.request.contextPath}/warranty?action=list">
            <span>🛠</span>Bảo hành
        </a>
        <a class="${param.activePage == 'ticket' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/ticket/list">
            <span>🎫</span>Duyệt yêu cầu hỗ trợ
        </a>
        <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
        <a class="${param.activePage == 'chatbot-feedback' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/chatbot-feedback">
            <span>💬</span>Phản hồi Chatbot
        </a>
        <a class="${param.activePage == 'chatbot-security' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/chatbot-security">
            <span>🛡</span>Bảo mật Chatbot
        </a>
        <a class="${param.activePage == 'settings' ? 'active' : ''}" href="#">
            <span>⚙</span>Cài đặt
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
            <span>Hồ sơ Admin</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
    </div>
</aside>

<script>
function toggleSidebarDropdown(btn) {
    var container = btn.nextElementSibling;
    var arrow = btn.querySelector('.dropdown-arrow');
    if (container.style.display === 'none' || container.style.display === '') {
        container.style.display = 'flex';
        if (arrow) arrow.style.transform = 'rotate(180deg)';
    } else {
        container.style.display = 'none';
        if (arrow) arrow.style.transform = 'rotate(0deg)';
    }
}
</script>

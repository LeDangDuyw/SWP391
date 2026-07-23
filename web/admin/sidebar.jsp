<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ════ MASTER SIDEBAR STYLES (Enforced across all Admin pages) ════ -->
<style>
    aside.sidebar {
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
        overflow-y: auto !important;
        flex-shrink: 0 !important;
    }

    aside.sidebar .brand {
        margin: 6px 10px 44px !important;
        display: grid !important;
        gap: 6px !important;
    }

    aside.sidebar .brand span {
        color: #0b39d1 !important;
        font-size: 24px !important;
        font-weight: 800 !important;
        letter-spacing: .05em !important;
        display: block !important;
        line-height: 1.2 !important;
    }

    aside.sidebar .brand small {
        color: #343a46 !important;
        font-size: 14px !important;
        display: block !important;
        font-weight: 500 !important;
    }

    aside.sidebar nav {
        display: grid !important;
        gap: 10px !important;
    }

    aside.sidebar nav a {
        display: flex !important;
        align-items: center !important;
        gap: 14px !important;
        padding: 14px 14px !important;
        border-radius: 10px !important;
        color: #242a38 !important;
        font-weight: 600 !important;
        text-decoration: none !important;
        font-size: 14px !important;
        transition: background 0.2s ease, color 0.2s ease !important;
        white-space: nowrap !important;
        box-sizing: border-box !important;
    }

    aside.sidebar nav a span {
        min-width: 20px !important;
        color: #1f2937 !important;
        font-size: 16px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
    }

    aside.sidebar nav a:hover {
        background: #f3f4f6 !important;
        color: #0b39d1 !important;
    }

    aside.sidebar nav a.active {
        background: #d8e8ff !important;
        color: #0b39d1 !important;
    }

    .sidebar-dropdown {
        display: flex !important;
        flex-direction: column !important;
    }

    .sidebar-dropdown-container {
        flex-direction: column !important;
        gap: 4px !important;
        margin-top: 4px !important;
    }

    aside.sidebar nav .sidebar-dropdown-container a {
        padding: 10px 14px 10px 36px !important;
        font-size: 13px !important;
        font-weight: 500 !important;
    }

    aside.sidebar .profile {
        margin-top: auto !important;
        border-top: 1px solid #d4dae6 !important;
        padding: 18px 10px 0 !important;
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        font-weight: 700 !important;
    }

    aside.sidebar .logout-btn {
        display: inline-flex !important;
        align-items: center !important;
        gap: 8px !important;
        color: #ef4444 !important;
        font-size: 13px !important;
        font-weight: 600 !important;
        padding: 8px 12px !important;
        border-radius: 6px !important;
        background: #fef2f2 !important;
        border: 1px solid #fecaca !important;
        text-decoration: none !important;
        transition: all 0.2s ease !important;
    }

    aside.sidebar .logout-btn:hover {
        background: #fee2e2 !important;
    }
</style>

<%-- Component: Admin Sidebar --%>
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
            <div class="sidebar-dropdown-container" style="display: ${param.activePage == 'promotions' || param.activePage == 'analytics' ? 'flex' : 'none'};">
                <a class="${param.activePage == 'promotions' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/promotions">
                    <span>▥</span>Mã giảm giá &amp; Khuyến mãi
                </a>
                <a class="${param.activePage == 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/analytics">
                    <span>📈</span>Phân tích nâng cao
                </a>
            </div>
        </div>
        
        <a class="${param.activePage == 'policy' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/policy">
            <span>📜</span>Chính sách
        </a>
        <a class="${param.activePage == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reviews">
            <span>★</span>Quản lý đánh giá
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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trò chuyện với AI - UniLap</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css?v=1">
        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
    </head>
    <body>
        <!-- Header (Đồng bộ từ home.jsp) -->
        <header class="header">
            <div class="container header-container">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
                    <c:forEach items="${categories}" var="cat">
                        <c:if test="${cat.categoryId == 1 || cat.categoryId == 3 || cat.categoryId == 4}">
                            <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                        </c:if>
                    </c:forEach>

                    <div class="nav-dropdown">
                        <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                        <div class="dropdown-content">
                            <c:forEach items="${categories}" var="cat">
                                <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                    <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <a href="#">Khuyến mãi</a>
                </nav>
                <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                    <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="#"><i class="fas fa-shopping-cart"></i></a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 5px; text-decoration: none; color: inherit;">
                                    <i class="fas fa-user"></i>
                                    <span style="font-size: 13px; font-weight: 500; max-width: 90px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${sessionScope.user.userName}</span>
                                </a>
                                <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 150px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Admin</a>
                                        </c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            <a href="${pageContext.request.contextPath}/staff/inventory" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Staff</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/profile" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <div style="border-top: 1px solid #f1f5f9; margin: 6px 0;"></div>
                                    <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px; font-weight: 500;">Đăng xuất</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Main Chat Layout -->
        <div class="chat-full-layout">
            <!-- Sidebar bên trái -->
            <aside class="chat-full-sidebar">
                <div class="sidebar-header">
                    <h2><i class="fas fa-robot" style="color: var(--chat-primary);"></i> UniLap AI</h2>
                </div>
                
                <div class="sidebar-section">
                    <div class="sidebar-card">
                        <h3>Tư Vấn Thông Minh</h3>
                        <p>Trợ lý AI hỗ trợ bạn so sánh cấu hình laptop, tìm linh kiện phù hợp và giải đáp các chính sách hậu mãi của UniLap.</p>
                    </div>
                    
                    <div class="sidebar-suggestions-list">
                        <h4 style="font-size: 12px; color: var(--chat-text-muted); text-transform: uppercase; margin: 10px 0 5px 0; font-family: 'Inter', sans-serif;">Gợi ý câu hỏi:</h4>
                        <button class="suggestion-item" data-question="Tìm laptop gaming dưới 25 triệu tốt nhất">
                            <i class="fas fa-laptop" style="color: #f59e0b;"></i> Laptop Gaming dưới 25tr
                        </button>
                        <button class="suggestion-item" data-question="Tư vấn bàn phím cơ gõ êm cho văn phòng">
                            <i class="fas fa-keyboard" style="color: #10b981;"></i> Bàn phím cơ gõ êm
                        </button>
                        <button class="suggestion-item" data-question="Chính sách bảo hành và đổi trả của shop thế nào?">
                            <i class="fas fa-shield-alt" style="color: #3b82f6;"></i> Chính sách bảo hành
                        </button>
                    </div>
                    
                    <button class="sidebar-footer-btn" type="button">
                        <i class="fas fa-trash-alt"></i> Xóa lịch sử chat
                    </button>
                </div>
            </aside>

            <!-- Khung Chat bên phải -->
            <main class="chat-full-panel">
                <div class="chat-full-messages-container">
                    <div class="chat-full-messages-inner">
                        <!-- Messages dynamically loaded from chat.js -->
                    </div>
                </div>
                
                <div class="chat-full-input-outer">
                    <div class="chat-full-input-inner">
                        <textarea class="chat-full-textarea" placeholder="Hỏi UniLap AI về sản phẩm và chính sách..." autocomplete="off"></textarea>
                        <button class="chat-full-send-btn" type="button" title="Gửi tin nhắn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </main>
        </div>

        <%@include file="_footer.jspf" %>

        <!-- Javascript triggers for header user menu dropdown -->
        <script>
            (function () {
                document.addEventListener('DOMContentLoaded', function () {
                    var triggers = document.querySelectorAll('.user-menu-trigger');
                    triggers.forEach(function (trigger) {
                        trigger.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var dropdown = this.nextElementSibling;
                            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                        });
                    });
                    document.addEventListener('click', function () {
                        document.querySelectorAll('.user-menu-dropdown-content').forEach(function (dropdown) {
                            dropdown.style.display = 'none';
                        });
                    });
                });
            })();
        </script>

        <script src="${pageContext.request.contextPath}/js/home.js?v=3"></script>
        <script src="${pageContext.request.contextPath}/js/chat.js?v=1"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN"/>

<c:if test="${empty categories}">
    <%
        try {
            dal.CategoryDAO catDAO = new dal.CategoryDAO();
            request.setAttribute("categories", catDAO.getAllCategories());
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</c:if>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UniLap - ${policy.title}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy.css?v=1">
    </head>
    <body>
        <!-- Header -->
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
                        <span class="dropdown-btn">Phụ kiện khác <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                        <div class="dropdown-content">
                            <c:forEach items="${categories}" var="cat">
                                <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                    <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/news">Tin tức & Khuyến mãi</a>
                </nav>
                <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                    <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                            <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                        </c:if>
                    </a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                 <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.avatarUrl}">
                                            <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}"
                                                 alt="avatar"
                                                 style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid #e2e8f0;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user"></i>
                                        </c:otherwise>
                                    </c:choose>
                                     <span style="font-size: 13px; font-weight: 500; max-width: 90px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${sessionScope.user.userName}</span>
                                 </a>
                                <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 150px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Admin</a>
                                        </c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            <a href="${pageContext.request.contextPath}/staff/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Staff</a>
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
                            <a href="${pageContext.request.contextPath}/login" style="color: #1e293b; text-decoration: none; font-size: 14px; font-weight: 500;"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Main Page Container -->
        <div class="policy-page-container">
            <!-- Sidebar -->
            <%@include file="_policySidebar.jspf" %>

            <!-- Content Area -->
            <main class="policy-main-content">
                <div class="breadcrumbs">
                    <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a> 
                    <i class="fas fa-chevron-right"></i> 
                    <span>${policy.title}</span>
                </div>
                <div class="policy-header">
                    <h1>${policy.title}</h1>
                    <c:if test="${not empty policy.updatedAt}">
                        <div class="last-updated">Cập nhật lần cuối: <fmt:formatDate value="${policy.updatedAt}" pattern="dd/MM/yyyy"/></div>
                    </c:if>
                </div>
                <div class="policy-content-body">
                    <!-- About Hero Banner -->
                    <div class="about-hero">
                        <h2>Kiến Tạo Trải Nghiệm Công Nghệ Đỉnh Cao</h2>
                        <p>UniLap đồng hành cùng bạn trên con đường chinh phục đỉnh cao công nghệ bằng những sản phẩm Laptop, chuột và bàn phím máy tính chất lượng chính hãng tốt nhất.</p>
                    </div>

                    ${policy.content}

                    <!-- Core Value Grid -->
                    <h2 style="border-left: 4px solid #2563eb; padding-left: 12px; margin-top: 40px; margin-bottom: 20px;">Giá Trị Cốt Lõi Tại UniLap</h2>
                    <div class="core-values-grid">
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-medal"></i></div>
                            <h4 class="core-value-title">Chất Lượng Chính Hãng</h4>
                            <p class="core-value-desc">Cam kết phân phối sản phẩm chính hãng 100% từ các thương hiệu hàng đầu thế giới như ASUS, Dell, HP, Apple, Logitech...</p>
                        </div>
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-brain"></i></div>
                            <h4 class="core-value-title">Công Nghệ AI Gợi Ý</h4>
                            <p class="core-value-desc">Tích hợp AI trợ lý mua sắm thông minh hỗ trợ tìm kiếm cấu hình và so sánh sản phẩm tối ưu theo nhu cầu khách hàng.</p>
                        </div>
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-headset"></i></div>
                            <h4 class="core-value-title">Hậu Mãi Tận Tâm</h4>
                            <p class="core-value-desc">Chính sách bảo hành điện tử rõ ràng, thời gian hỗ trợ nhanh chóng và cam kết 1 đổi 1 trong vòng 7 ngày đầu tiên.</p>
                        </div>
                    </div>

                    <!-- Counter Stats -->
                    <h2 style="border-left: 4px solid #2563eb; padding-left: 12px; margin-top: 40px; margin-bottom: 20px;">UniLap Qua Những Con Số</h2>
                    <div class="about-stats">
                        <div class="stat-item">
                            <div class="stat-num">10,000+</div>
                            <div class="stat-label">Khách hàng tin dùng</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">500+</div>
                            <div class="stat-label">Sản phẩm công nghệ</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">5+</div>
                            <div class="stat-label">Năm hoạt động</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">99%</div>
                            <div class="stat-label">Hài lòng dịch vụ</div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Footer -->
        <%@include file="_footer.jspf" %>
        <script>
            // Header User Menu Dropdown Toggle
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
                    document.addEventListener('click', function() {
                        var dropdowns = document.querySelectorAll('.user-menu-dropdown-content');
                        dropdowns.forEach(function(d) {
                            d.style.display = 'none';
                        });
                    });
                });
            })();
        </script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UniLap - Tin tức & Ưu đãi Khuyến Mãi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
        <style>
            .news-hero {
                background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
                color: #fff;
                padding: 45px 0;
                text-align: center;
                margin-bottom: 30px;
            }
            .news-hero h1 {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 10px;
            }
            .news-hero p {
                font-size: 15px;
                color: #94a3b8;
            }
            .news-tabs {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-bottom: 35px;
            }
            .news-tab-btn {
                padding: 10px 24px;
                border-radius: 25px;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                color: #475569;
                background: #f1f5f9;
                transition: all 0.2s ease;
            }
            .news-tab-btn.active, .news-tab-btn:hover {
                background: #2563eb;
                color: #fff;
                box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            }
            .news-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 25px;
                margin-bottom: 50px;
            }
            .news-card {
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                overflow: hidden;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
                display: flex;
                flex-direction: column;
            }
            .news-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 20px -5px rgba(0,0,0,0.1);
            }
            .news-card-body {
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex: 1;
            }
            .news-badge {
                align-self: flex-start;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                margin-bottom: 12px;
            }
            .badge-promo { background: #dbeafe; color: #1e40af; }
            .badge-newprod { background: #dcfce7; color: #166534; }
            .badge-general { background: #f3e8ff; color: #6b21a8; }
            .news-title {
                font-size: 18px;
                font-weight: 700;
                color: #0f172a;
                margin-bottom: 10px;
                line-height: 1.4;
            }
            .news-date {
                font-size: 12px;
                color: #64748b;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .news-read-more {
                margin-top: auto;
                padding-top: 15px;
                border-top: 1px dashed #f1f5f9;
                color: #2563eb;
                font-weight: 600;
                font-size: 13px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .empty-news {
                text-align: center;
                padding: 60px 20px;
                color: #64748b;
            }
        </style>
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

                    <a href="${pageContext.request.contextPath}/news" class="active">Tin tức & Khuyến mãi</a>
                </nav>
                <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                    <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="${pageContext.request.contextPath}/wishlist" class="wishlist-icon-btn" style="position: relative; color: #e11d48;" title="Sản phẩm yêu thích">
                        <i class="fas fa-heart" style="font-size: 18px;"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                            <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                        </c:if>
                    </a>
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
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" style="font-size: 13px; font-weight: 600; color: #2563eb; text-decoration: none; padding: 6px 14px; border: 1px solid #2563eb; border-radius: 20px;">Đăng nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Banner -->
        <section class="news-hero">
            <div class="container">
                <h1><i class="fas fa-newspaper"></i> Tin Tức & Chương Trình Khuyến Mãi</h1>
                <p>Cập nhật những ưu đãi giảm giá hấp dẫn nhất và sản phẩm công nghệ mới ra mắt tại UniLap</p>
            </div>
        </section>

        <!-- Main Content -->
        <main class="container">
            <div class="news-tabs">
                <a href="${pageContext.request.contextPath}/news" class="news-tab-btn ${empty activeTab || activeTab == 'ALL' ? 'active' : ''}">Tất cả bài viết</a>
                <a href="${pageContext.request.contextPath}/news?type=PROMOTION" class="news-tab-btn ${activeTab == 'PROMOTION' ? 'active' : ''}"><i class="fas fa-tags"></i> Tin Khuyến Mãi</a>
                <a href="${pageContext.request.contextPath}/news?type=NEW_PRODUCT" class="news-tab-btn ${activeTab == 'NEW_PRODUCT' ? 'active' : ''}"><i class="fas fa-laptop"></i> Sản Phẩm Mới</a>
            </div>

            <c:choose>
                <c:when test="${not empty articles}">
                    <div class="news-grid">
                        <c:forEach items="${articles}" var="a">
                            <div class="news-card">
                                <div class="news-card-body">
                                    <c:choose>
                                        <c:when test="${a.policyType eq 'PROMOTION' or a.policyType eq 'PROMO'}">
                                            <span class="news-badge badge-promo"><i class="fas fa-percent"></i> Khuyến Mãi</span>
                                        </c:when>
                                        <c:when test="${a.policyType eq 'NEW_PRODUCT' or a.policyType eq 'NEWPROD'}">
                                            <span class="news-badge badge-newprod"><i class="fas fa-box-open"></i> Sản Phẩm Mới</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="news-badge badge-general"><i class="fas fa-bullhorn"></i> Thông Báo</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <h3 class="news-title">${a.title}</h3>
                                    <div class="news-date">
                                        <i class="far fa-clock"></i> 
                                        <fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/policy?id=${a.policyId}" class="news-read-more">
                                        Đọc chi tiết <i class="fas fa-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-news">
                        <i class="far fa-newspaper" style="font-size: 48px; color: #cbd5e1; margin-bottom: 15px;"></i>
                        <h3>Hiện chưa có bài viết nào thuộc mục này</h3>
                        <p>Vui lòng quay lại sau để cập nhật thông tin mới nhất từ UniLap.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- Footer -->
        <%@include file="_footer.jspf" %>
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

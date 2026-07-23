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
            /* ── Header (synced with warranty_center.jsp) ── */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .header {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid rgba(255,255,255,0.3);
                box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            }
            .header-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 70px;
            }
            .logo {
                font-size: 24px;
                font-weight: 800;
                color: #1a56db;
                letter-spacing: -0.5px;
                text-decoration: none;
            }
            .main-nav {
                display: flex;
                align-items: center;
                gap: 32px;
            }
            .main-nav a {
                font-weight: 500;
                color: #64748b;
                font-size: 15px;
                position: relative;
                text-decoration: none;
                transition: all 0.3s ease;
                white-space: nowrap;
            }
            .main-nav a:hover, .main-nav a.active {
                color: #1a56db;
            }
            .main-nav a.active::after {
                content: '';
                position: absolute;
                bottom: -6px;
                left: 0;
                width: 100%;
                height: 2px;
                background-color: #1a56db;
                border-radius: 2px;
            }
            .header-icons {
                display: flex;
                gap: 20px;
                align-items: center;
            }
            .header-icons a {
                color: #1e293b;
                font-size: 18px;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .header-icons a:hover {
                color: #1a56db;
            }
            .nav-dropdown {
                position: relative;
                display: inline-block;
            }
            .nav-dropdown .dropdown-btn {
                display: flex;
                align-items: center;
                gap: 6px;
                cursor: pointer;
                font-weight: 500;
                color: #64748b;
                font-size: 15px;
                transition: all 0.3s ease;
                text-decoration: none;
                white-space: nowrap;
            }
            .nav-dropdown:hover .dropdown-btn {
                color: #1a56db;
            }
            .dropdown-content {
                display: none;
                position: absolute;
                top: calc(100% + 5px);
                left: 50%;
                transform: translateX(-50%) translateY(10px);
                background-color: #ffffff;
                min-width: 180px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                z-index: 999;
                padding: 8px 0;
                opacity: 0;
                transition: all 0.2s ease;
            }
            .nav-dropdown:hover .dropdown-content {
                display: block;
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
            .dropdown-content a {
                display: block;
                padding: 10px 18px;
                color: #374151;
                font-size: 14px;
                text-decoration: none;
                transition: background 0.15s;
            }
            .dropdown-content a:hover {
                background: #f1f5f9;
                color: #1a56db;
            }

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
        <%@include file="_header.jspf" %>

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

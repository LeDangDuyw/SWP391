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
        <title>UniLap - Kỷ Nguyên Công Nghệ Mới</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
        <style>
            .wishlist-card-heart-btn {
                position: absolute;
                top: 12px;
                right: 12px;
                width: 34px;
                height: 34px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.92);
                border: 1px solid #e2e8f0;
                color: #e11d48;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                z-index: 10;
                font-size: 15px;
                transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            .wishlist-card-heart-btn:hover {
                background: #ffe4e6;
                transform: scale(1.15);
                border-color: #fda4af;
            }
            .wishlist-card-heart-btn.active {
                background: #fff1f2;
                color: #e11d48;
                border-color: #f43f5e;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container header-container">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="active">Trang chủ</a>
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
                    <a href="${pageContext.request.contextPath}/wishlist" class="wishlist-icon-btn" style="position: relative; color: #e11d48;" title="Sản phẩm yêu thích">
                        <i class="fas fa-heart" style="font-size: 18px;"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                            <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                        </c:if>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" title="Thông báo &amp; Tài khoản"><i class="fas fa-bell"></i></a>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                 <a href="javascript:void(0);" class="user-menu-trigger" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
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
                                <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 160px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang quản trị Admin</a>
                                        </c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            <a href="${pageContext.request.contextPath}/staff/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang nhân viên</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/profile" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
                                        </c:otherwise>
                                    </c:choose>

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
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                            </c:otherwise>
                        </c:choose>
                </div>
            </div>
        </header>

        <!-- phần quảng cáo -->
        <section class="hero">
            <div class="container">
                <div class="hero-slider-wrapper">
                    <div class="hero-slides">
                        <c:forEach items="${banners}" var="b" varStatus="status">
                            <div class="hero-slide ${status.first ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/ProductListServlet">
                                    <img src="${b.imageUrl}" data-context="${pageContext.request.contextPath}" class="banner-img-auto" alt="Banner UniLap">
                                </a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty banners}">
                            <div class="hero-slide active">
                                <a href="${pageContext.request.contextPath}/ProductListServlet">
                                    <img src="https://images.unsplash.com/photo-1531297122539-5692f6e10821?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80" alt="Hình ảnh Laptop AI UniLap">
                                </a>
                            </div>
                        </c:if>
                    </div>
                   <!--có banner-->
                    <div class="hero-indicators">
                        <c:forEach items="${banners}" var="b" varStatus="status">
                            <span class="hero-dot ${status.first ? 'active' : ''}" data-index="${status.index}"></span>
                        </c:forEach>
                            
                            <!--Không có banner-->
                        <c:if test="${empty banners}">
                            <span class="hero-dot active" data-index="0"></span>
                        </c:if>
                    </div>
                   
                    <button class="hero-arrow hero-prev"><i class="fas fa-chevron-left"></i></button>
                    <button class="hero-arrow hero-next"><i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
        </section>
        <!-- Flash Sale -->
        <c:if test="${not empty flashsale}">
            <section class="flash-sale">
                <div class="container">
                    <div class="section-header flash-sale-header">
                        <h2><i class="fas fa-bolt flash-icon"></i> ${not empty flashsale and not empty flashsale[0].campaignDescription ? flashsale[0].campaignDescription : 'Săn Deal Thần Tốc'}</h2>
                        <!--giờ đếm ngược cho đến hết flash sale--> 
                        <div class="countdown" id="flash-sale-countdown" data-endtime="${not empty flashsale ? flashsale[0].endTime.time : ''}">
                            <span>Kết thúc trong: </span>
                            <div class="timer">
                                <span id="hours">00</span> :
                                <span id="minutes">00</span> :
                                <span id="seconds">00</span>
                            </div>
                        </div>
                    </div>
                    <!--Hiển thị sản phẩm flash sale--> 
                    <div class="product-grid flash-grid">
                        <c:forEach items="${flashsale}" var="p">

                            <div class="product-card" style="position: relative;">
                                <button type="button" class="wishlist-card-heart-btn" data-product-id="${p.productId}" onclick="toggleCardWishlist(event, ${p.productId}, this)" title="Lưu sản phẩm yêu thích">
                                    <i class="far fa-heart"></i>
                                </button>
                                <div class="product-badge discount">
                                    -${p.discountPercent}%
                                </div>

                                <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                    <div class="product-img-wrapper">
                                        <img src="${pageContext.request.contextPath}/images/${p.thumbnail}" alt="${p.productName}">
                                    </div>
                                </a>

                                <div class="product-info">

                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                        <h3>${p.productName}</h3>
                                    </a>

                                    <div class="product-price">

                                        <span class="current-price">
                                            <fmt:formatNumber
                                                value="${p.salePrice}"
                                                pattern="#,##0"/>₫
                                        </span>

                                        <span class="old-price">
                                            <fmt:formatNumber
                                                value="${p.originalPrice}"
                                                pattern="#,##0"/>₫
                                        </span>

                                    </div>

                                    <div class="progress-bar-container">

                                        <div class="progress-bar"
                                             style="width:${p.soldQuantity * 100.0 / p.quantityLimit}%;">
                                        </div>

                                    </div>

                                    <div class="stock-info">

                                        <span>
                                            Đã bán: ${p.soldQuantity}
                                        </span>

                                        <span>
                                            Còn lại:
                                            ${p.quantityLimit - p.soldQuantity}
                                        </span>

                                    </div>
                                    <!--nút mua hoặc để thêm vào trong giỏ hàng--> 
                                     <div class="actions">
                                         <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-add-cart" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;"><i class="fas fa-shopping-cart" style="margin-right: 5px;"></i> Giỏ hàng</a>
                                         <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-buy-now" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;">Mua ngay</a>
                                     </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </c:if>
        <!-- Sản phẩm bán chạy -->
        <section class="best-sellers">
            <div class="container">
                <div class="section-header">
                    <h2>Sản phẩm bán chạy</h2>
                    <!--hiển thị lựa chọn xem tất cả sản phẩm của danh mục và nhận giá trị danh mục-->  
                    <c:choose>
                        <c:when test="${bsTab == 'chuot'}">
                            <a href="ProductListServlet?category=4&sort=popular" class="view-all">Xem tất cả</a>
                        </c:when>
                        <c:when test="${bsTab == 'banphim'}">
                            <a href="ProductListServlet?category=3&sort=popular" class="view-all">Xem tất cả</a>
                        </c:when>
                        <c:otherwise>
                            <a href="ProductListServlet?category=1&sort=popular" class="view-all">Xem tất cả</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!--hiển thị nút lựa chọn danh mục của sản phẩm và nhận giá trị danh mục-->  
                <div class="tabs">
                    <a href="HomeServlet?bsTab=laptop&newTab=${newTab}" class="tab-btn ${bsTab == 'laptop' || empty bsTab ? 'active' : ''}">Laptop</a>
                    <a href="HomeServlet?bsTab=chuot&newTab=${newTab}" class="tab-btn ${bsTab == 'chuot' ? 'active' : ''}">Chuột</a>
                    <a href="HomeServlet?bsTab=banphim&newTab=${newTab}" class="tab-btn ${bsTab == 'banphim' ? 'active' : ''}">Bàn phím</a>
                </div>
                <div class="product-grid" id="best-seller-grid">
                    <!--hiển thị toàn bộ sản phẩm bán chạy theo danh mục-->
                    <c:forEach items="${products}" var="p">
                        <div class="product-card" style="position: relative;">
                            <button type="button" class="wishlist-card-heart-btn" data-product-id="${p.productId}" onclick="toggleCardWishlist(event, ${p.productId}, this)" title="Lưu sản phẩm yêu thích">
                                <i class="far fa-heart"></i>
                            </button>
                            <div class="product-badge best-seller">Bán chạy</div>
                            <c:if test="${p.discountPercent > 0}">
                                <div class="product-badge discount" style="top: 48px; left: 16px;">-${p.discountPercent}%</div>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                <div class="product-img-wrapper">
                                    <img src="${pageContext.request.contextPath}/images/${p.thumbnail}" alt="${p.productName}">
                                </div>
                            </a>
                            <div class="product-info">
                                <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                    <h3>${p.productName}</h3>
                                </a>
                                <div class="product-price">
                                    <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###"/>₫</span>
                                </div>
                                 <div class="actions">
                                     <!--nút mua bán sản phẩm và nút thêm vào giỏ hàng-->
                                     <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-add-cart" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;"><i class="fas fa-shopping-cart" style="margin-right: 5px;"></i> Giỏ hàng</a>
                                     <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-buy-now" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;">Mua ngay</a>
                                 </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <!-- Sản phẩm mới -->
        <section class="new-products" style="padding: 60px 0; background-color: var(--bg-white);">
            <div class="container">
                <div class="section-header">
                    <h2>Sản phẩm mới</h2>
                    <!--hiển thị lựa chọn xem tất cả sản phẩm của danh mục và nhận giá trị danh mục-->
                    <c:choose>
                        <c:when test="${newTab == 'chuot'}">
                            <a href="ProductListServlet?category=4&sort=new" class="view-all">Xem tất cả</a>
                        </c:when>
                        <c:when test="${newTab == 'banphim'}">
                            <a href="ProductListServlet?category=3&sort=new" class="view-all">Xem tất cả</a>
                        </c:when>
                        <c:otherwise>
                            <a href="ProductListServlet?category=1&sort=new" class="view-all">Xem tất cả</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!--hiển thị lựa chọn xem tất cả sản phẩm của danh mục và nhận giá trị danh mục-->  
                <div class="tabs">
                    <a href="HomeServlet?bsTab=${bsTab}&newTab=laptop" class="tab-btn ${newTab == 'laptop' ? 'active' : ''}">Laptop</a>
                    <a href="HomeServlet?bsTab=${bsTab}&newTab=chuot" class="tab-btn ${newTab == 'chuot' ? 'active' : ''}">Chuột</a>
                    <a href="HomeServlet?bsTab=${bsTab}&newTab=banphim" class="tab-btn ${newTab == 'banphim' ? 'active' : ''}">Bàn phím</a>
                </div>
                <!--hiển thị sản phẩm bán chạy-->
                <div class="product-grid" id="new-product-grid">
                    <c:forEach items="${new_products}" var="p">
                        <div class="product-card" style="position: relative;">
                            <button type="button" class="wishlist-card-heart-btn" data-product-id="${p.productId}" onclick="toggleCardWishlist(event, ${p.productId}, this)" title="Lưu sản phẩm yêu thích">
                                <i class="far fa-heart"></i>
                            </button>
                            <div class="product-badge new">Mới</div>
                            <c:if test="${p.discountPercent > 0}">
                                <div class="product-badge discount" style="top: 48px; left: 16px;">-${p.discountPercent}%</div>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                <div class="product-img-wrapper">
                                    <img src="${pageContext.request.contextPath}/images/${p.thumbnail}" alt="${p.productName}">
                                </div>
                            </a>
                            <div class="product-info">
                                <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="product-card-link">
                                    <h3>${p.productName}</h3>
                                </a>
                                <div class="product-price">
                                    <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###"/>₫</span>
                                </div>
                                 <div class="actions">
                                     <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-add-cart" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;"><i class="fas fa-shopping-cart" style="margin-right: 5px;"></i> Giỏ hàng</a>
                                     <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${p.productId}" class="btn-buy-now" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;">Mua ngay</a>
                                 </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <%@include file="_footer.jspf" %>
        <jsp:include page="chatbot.jsp" />

        <script src="${pageContext.request.contextPath}/js/home.js?v=3"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                syncWishlistCardButtons();
            });

            function syncWishlistCardButtons() {
                fetch('${pageContext.request.contextPath}/wishlist', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: 'action=getWishlistIds'
                })
                .then(r => r.json())
                .then(d => {
                    if (d.status === 'success' && d.ids) {
                        d.ids.forEach(id => {
                            var btns = document.querySelectorAll('.wishlist-card-heart-btn[data-product-id="' + id + '"]');
                            btns.forEach(btn => {
                                btn.classList.add('active');
                                var icon = btn.querySelector('i');
                                if (icon) icon.className = 'fas fa-heart';
                            });
                        });
                    }
                })
                .catch(err => console.log(err));
            }

            function toggleCardWishlist(event, productId, btn) {
                event.preventDefault();
                event.stopPropagation();

                fetch('${pageContext.request.contextPath}/wishlist', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: 'action=toggle&productId=' + productId
                })
                .then(r => r.json())
                .then(d => {
                    if (d.status === 'unauthorized') {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    } else if (d.status === 'success') {
                        var btns = document.querySelectorAll('.wishlist-card-heart-btn[data-product-id="' + productId + '"]');
                        btns.forEach(b => {
                            var icon = b.querySelector('i');
                            if (d.action === 'added') {
                                b.classList.add('active');
                                if (icon) icon.className = 'fas fa-heart';
                            } else {
                                b.classList.remove('active');
                                if (icon) icon.className = 'far fa-heart';
                            }
                        });
                    } else {
                        alert(d.message || "Có lỗi xảy ra");
                    }
                })
                .catch(err => console.error(err));
            }
        </script>
    </body>
</html>

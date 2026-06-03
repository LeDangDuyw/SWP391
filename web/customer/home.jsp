<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=10">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=1">
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
                        <input type="hidden" name="category" value="1">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:150px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="#"><i class="fas fa-shopping-cart"></i></a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <a href="#"><i class="fas fa-user"></i></a>
                </div>
            </div>
        </header>

        <!-- phần quảng cáo -->
        <section class="hero">
            <div class="container hero-container">
                <div class="hero-content">
                    <div class="badge-new">Ra mắt bộ sưu tập 2026</div>
                    <h1>Kỷ Nguyên Công Nghệ Mới</h1>
                    <p>Sở hữu Laptop AI & Gaming mạnh mẽ nhất 2026. Hiệu năng vượt đỉnh, thiết kế tinh xảo, trải nghiệm không giới hạn.</p>
                    <div class="hero-buttons">
                        <a href="#" class="btn btn-primary">Mua ngay</a>
                        <a href="#" class="btn btn-secondary">Khám phá</a>
                    </div>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1531297122539-5692f6e10821?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Laptop AI 2026" class="floating-img">
                </div>
            </div>
        </section>

        <!-- Flash Sale -->
        <c:if test="${not empty flashsale}">
        <section class="flash-sale">
            <div class="container">
                <div class="section-header flash-sale-header">
                    <h2><i class="fas fa-bolt flash-icon"></i> Săn Deal Thần Tốc</h2>
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

                        <div class="product-card">

                            <div class="product-badge discount">
                                -${p.discountPercent}%
                            </div>

                            <div class="product-img-wrapper">
                                <img src="images/${p.thumbnail}" alt="${p.productName}">
                            </div>

                            <div class="product-info">

                                <h3>${p.productName}</h3>

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
                                    <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Giỏ hàng</button>
                                    <button type="button" class="btn-buy-now">Mua ngay</button>
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
                                    <div class="product-card">
                                        <div class="product-badge best-seller">Bán chạy</div>
                                        <div class="product-img-wrapper">
                                            <img src="images/${p.thumbnail}" alt="${p.productName}">
                                        </div>
                                        <div class="product-info">
                                            <h3>${p.productName}</h3>
                                            <div class="product-price">
                                                <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###"/>₫</span>
                                            </div>
                                            <div class="actions">
                                            <!--nút mua bán sản phẩm và nút thêm vào giỏ hàng-->
                                                <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Giỏ hàng</button>
                                                <button type="button" class="btn-buy-now">Mua ngay</button>
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
                                    <c:when test="${param.newTab == 'chuot'}">
                                        <a href="ProductListServlet?category=4&sort=new" class="view-all">Xem tất cả</a>
                                    </c:when>
                                    <c:when test="${param.newTab == 'banphim'}">
                                        <a href="ProductListServlet?category=3&sort=new" class="view-all">Xem tất cả</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="ProductListServlet?category=1&sort=new" class="view-all">Xem tất cả</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                             <!--hiển thị lựa chọn xem tất cả sản phẩm của danh mục và nhận giá trị danh mục-->  
                            <div class="tabs">
                                <a href="HomeServlet?bsTab=${bsTab}&newTab=laptop" class="tab-btn ${param.newTab == 'laptop' || empty param.newTab ? 'active' : ''}">Laptop</a>
                                <a href="HomeServlet?bsTab=${bsTab}&newTab=chuot" class="tab-btn ${param.newTab == 'chuot' ? 'active' : ''}">Chuột</a>
                                <a href="HomeServlet?bsTab=${bsTab}&newTab=banphim" class="tab-btn ${param.newTab == 'banphim' ? 'active' : ''}">Bàn phím</a>
                            </div>
                            <!--hiển thị sản phẩm bán chạy-->
                            <div class="product-grid" id="new-product-grid">
                                <c:forEach items="${new_products}" var="p">
                                    <div class="product-card">
                                        <div class="product-badge new">Mới</div>
                                        <div class="product-img-wrapper">
                                            <img src="images/${p.thumbnail}" alt="${p.productName}">
                                        </div>
                                        <div class="product-info">
                                            <h3>${p.productName}</h3>
                                            <div class="product-price">
                                                <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###"/>₫</span>
                                            </div>
                                            <div class="actions">
                                                <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Giỏ hàng</button>
                                                <button type="button" class="btn-buy-now">Mua ngay</button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>

                    <!-- Footer -->
                    <footer class="footer">
                        <div class="container footer-grid">
                            <div class="footer-col">
                                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo footer-logo">UniLap</a>
                                <p>Nền tảng mua sắm công nghệ cao cấp hàng đầu.</p>
                                <div class="social-icons">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                    <a href="#"><i class="fab fa-youtube"></i></a>
                                </div>
                            </div>
                            <div class="footer-col">
                                <h3>Khách hàng</h3>
                                <ul>
                                    <li><a href="#">Chính sách bảo mật</a></li>
                                    <li><a href="#">Điều khoản sử dụng</a></li>
                                    <li><a href="#">Hướng dẫn mua hàng</a></li>
                                </ul>
                            </div>
                            <div class="footer-col">
                                <h3>UniLap</h3>
                                <ul>
                                    <li><a href="#">Liên hệ</a></li>
                                    <li><a href="#">Về chúng tôi</a></li>
                                </ul>
                            </div>

                        </div>
                        <div class="footer-bottom">
                            <p>&copy; 2026 UniLap. All rights reserved.</p>
                        </div>
                    </footer>

                    <script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
                    </body>
                    </html>

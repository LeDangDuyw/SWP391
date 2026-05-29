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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Ghi đè CSS cho nút a để trông giống button ban đầu */
        .tab-btn {
            display: inline-block;
            text-decoration: none;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container header-container">
            <a href="${pageContext.request.contextPath}/HomeSeverlet" class="logo">UniLap</a>
            <nav class="main-nav">
                <a href="${pageContext.request.contextPath}/HomeSeverlet" class="active">Trang chủ</a>
                <a href="#">Laptop</a>
                <a href="#">Bàn Phím</a>
                <a href="#">Chuột</a>
                <a href="#">Phụ kiện</a>
                <a href="#">Khuyến mãi</a>
            </nav>
            <div class="header-icons">
                <a href="#"><i class="fas fa-search"></i></a>
                <a href="#"><i class="fas fa-shopping-cart"></i></a>
                <a href="#"><i class="fas fa-bell"></i></a>
                <a href="#"><i class="fas fa-user"></i></a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
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

    <!-- Flash Sale Section -->
    <section class="flash-sale">
        <div class="container">
            <div class="section-header flash-sale-header">
                <h2><i class="fas fa-bolt flash-icon"></i> Săn Deal Thần Tốc</h2>
                <div class="countdown">
                    <span>Kết thúc trong: </span>
                    <div class="timer">
                        <span id="hours">02</span> : 
                        <span id="minutes">45</span> : 
                        <span id="seconds">12</span>
                    </div>
                </div>
            </div>
            <div class="product-grid flash-grid">
                <!-- Static Flash Sale -->
                <div class="product-card">
                    <div class="product-badge discount">-24%</div>
                    <div class="product-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1603302576837-37561b2e2302?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60" alt="ROG Strix Scar 18">
                    </div>
                    <div class="product-info">
                        <h3>ROG Strix Scar 18 (2024)</h3>
                        <div class="product-price">
                            <span class="current-price">89.990.000₫</span>
                            <span class="old-price">115.000.000₫</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar" style="width: 75%;"></div>
                        </div>
                        <div class="stock-info">
                            <span>Đã bán: 15</span>
                            <span>Còn lại: 5</span>
                        </div>
                    </div>
                </div>
                <div class="product-card">
                    <div class="product-badge discount">-15%</div>
                    <div class="product-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1593642632823-8f785ba67e45?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60" alt="Zenbook 14 OLED">
                    </div>
                    <div class="product-info">
                        <h3>Zenbook 14 OLED</h3>
                        <div class="product-price">
                            <span class="current-price">25.490.000₫</span>
                            <span class="old-price">29.990.000₫</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar" style="width: 80%;"></div>
                        </div>
                        <div class="stock-info">
                            <span>Đã bán: 40</span>
                            <span>Còn lại: 10</span>
                        </div>
                    </div>
                </div>
                <div class="product-card">
                    <div class="product-badge discount">-30%</div>
                    <div class="product-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60" alt="Màn hình ProArt 27 4K">
                    </div>
                    <div class="product-info">
                        <h3>Màn hình ProArt 27" 4K</h3>
                        <div class="product-price">
                            <span class="current-price">12.590.000₫</span>
                            <span class="old-price">17.990.000₫</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar" style="width: 80%;"></div>
                        </div>
                        <div class="stock-info">
                            <span>Đã bán: 8</span>
                            <span>Còn lại: 2</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Best Sellers Section -->
    <section class="best-sellers">
        <div class="container">
            <div class="section-header">
                <h2>Sản phẩm bán chạy</h2>
                <a href="#" class="view-all">Xem tất cả</a>
            </div>
            
            <div class="tabs">
                <a href="HomeSeverlet?bsTab=laptop&newTab=${newTab}" class="tab-btn ${bsTab == 'laptop' || empty bsTab ? 'active' : ''}">Laptop</a>
                <a href="HomeSeverlet?bsTab=chuot&newTab=${newTab}" class="tab-btn ${bsTab == 'chuot' ? 'active' : ''}">Chuột</a>
                <a href="HomeSeverlet?bsTab=banphim&newTab=${newTab}" class="tab-btn ${bsTab == 'banphim' ? 'active' : ''}">Bàn phím</a>
            </div>

            <div class="product-grid" id="best-seller-grid">
                <c:forEach items="${products}" var="p">
                    <div class="product-card">
                        <div class="product-badge best-seller">Bán chạy</div>
                        <div class="product-img-wrapper">
                            <img src="${p.thumbnail}" alt="${p.productName}">
                        </div>
                        <div class="product-info">
                            <h3>${p.productName}</h3>
                            <div class="product-price">
                                <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###₫"/></span>
                            </div>
                            <button class="btn btn-add-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- New Products Section -->
    <section class="new-products" style="padding: 60px 0; background-color: var(--bg-white);">
        <div class="container">
            <div class="section-header">
                <h2>Sản phẩm mới</h2>
                <a href="#" class="view-all">Xem tất cả</a>
            </div>
            
            <div class="tabs">
                <a href="HomeSeverlet?bsTab=${bsTab}&newTab=laptop" class="tab-btn ${newTab == 'laptop' || empty newTab ? 'active' : ''}">Laptop</a>
                <a href="HomeSeverlet?bsTab=${bsTab}&newTab=chuot" class="tab-btn ${newTab == 'chuot' ? 'active' : ''}">Chuột</a>
                <a href="HomeSeverlet?bsTab=${bsTab}&newTab=banphim" class="tab-btn ${newTab == 'banphim' ? 'active' : ''}">Bàn phím</a>
            </div>

            <div class="product-grid" id="new-product-grid">
                <c:forEach items="${products}" var="p">
                    <div class="product-card">
                        <div class="product-badge new">Mới</div>
                        <div class="product-img-wrapper">
                            <img src="${p.thumbnail}" alt="${p.productName}">
                        </div>
                        <div class="product-info">
                            <h3>${p.productName}</h3>
                            <div class="product-price">
                                <span class="current-price"><fmt:formatNumber value="${p.minPrice}" type="number" pattern="###,###₫"/></span>
                            </div>
                            <button class="btn btn-add-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
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
                <a href="${pageContext.request.contextPath}/HomeSeverlet" class="logo footer-logo">UniLap</a>
                <p>High-performance innovation for every user. Nền tảng mua sắm công nghệ cao cấp hàng đầu.</p>
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
            <div class="footer-col">
                <h3>Đăng ký nhận tin</h3>
                <p>Nhận thông tin ưu đãi mới nhất từ UniLap.</p>
                <form class="newsletter-form">
                    <input type="email" placeholder="Email của bạn" required>
                    <button type="submit" class="btn btn-primary">Đăng ký</button>
                </form>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 UniLap. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>

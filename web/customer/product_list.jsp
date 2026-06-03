<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniLap - Laptop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=10">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product_list.css?v=1">
    <script src="${pageContext.request.contextPath}/js/product_list.js?v=1"></script>
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
                        <a href="ProductListServlet?category=${cat.categoryId}" class="${categoryId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
                    </c:if>
                </c:forEach>
                
                <div class="nav-dropdown ${categoryId == 2 || categoryId == 5 || categoryId == 6 || categoryId == 7 ? 'active' : ''}">
                    <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                    <div class="dropdown-content">
                        <c:forEach items="${categories}" var="cat">
                            <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                <a href="ProductListServlet?category=${cat.categoryId}" class="${categoryId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <a href="#">Khuyến mãi</a>
            </nav>
            <div class="header-icons" style="display:flex; align-items:center; gap:15px;">
                <!-- Ghi chú fix lại: Thay icon bằng form tìm kiếm -->
                <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                    <input type="hidden" name="category" value="${categoryId}">
                    <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm..." style="border:none; background:transparent; outline:none; font-size:14px; width:150px; font-family:'Inter', sans-serif;">
                    <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                </form>
                <a href="#"><i class="fas fa-shopping-cart"></i></a>
                <a href="#"><i class="fas fa-bell"></i></a>
                <a href="#"><i class="fas fa-user"></i></a>
            </div>
        </div>
    </header>

    <div class="container">
        <form action="ProductListServlet" method="GET" id="filterForm">
            <input type="hidden" name="category" value="${categoryId}">
            <input type="hidden" name="page" id="pageInput" value="${currentPage != null ? currentPage : 1}">
            <!--Giữ lại keyword khi lọc -->
            <input type="hidden" name="search" value="${param.search}">

            <!-- thương hiệu -->
            <div class="brand-list" style="margin-top: 30px;">
                <label class="brand-btn">
                    <input type="radio" name="brand" value="" onchange="filterChanged()" ${empty param.brand ? 'checked' : ''}>
                    <span>All Brands</span>
                </label>
                <c:forEach items="${brands}" var="b">
                    <label class="brand-btn">
                        <input type="radio" name="brand" value="${b.brandId}" onchange="filterChanged()" ${param.brand == b.brandId.toString() ? 'checked' : ''}>
                        <span>${b.brandName}</span>
                    </label>
                </c:forEach>
            </div>

            <div class="main-layout">
                            <aside class="sidebar">
                    <div class="filter-card">
                        <h2>Bộ Lọc</h2>

                        <!-- Series -->
                        <c:if test="${categoryId == 1 && not empty serieses}">
                            <div class="filter-group">
                                <h4><i class="fas fa-layer-group"></i> Series</h4>
                                <label><input type="radio" name="series" value="" onchange="filterChanged()" ${empty param.series ? 'checked' : ''}> Tất cả Series</label>
                                <c:forEach items="${serieses}" var="s">
                                    <label>
                                        <input type="radio" name="series" value="${s.seriesId}" onchange="filterChanged()" ${param.series == s.seriesId.toString() ? 'checked' : ''}>
                                        ${s.seriesName}
                                    </label>
                                </c:forEach>
                            </div>
                        </c:if>

                        <!-- Nhu cầu Laptop -->
                        <c:if test="${categoryId == 1}">
                            <div class="filter-group">
                                <h4><i class="fas fa-briefcase"></i> Nhu cầu</h4>
                                <label><input type="radio" name="purpose" value="" onchange="filterChanged()" ${empty param.purpose ? 'checked' : ''}> Tất cả nhu cầu</label>
                                <label><input type="radio" name="purpose" value="Gaming" onchange="filterChanged()" ${param.purpose == 'Gaming' ? 'checked' : ''}> Gaming - Trải nghiệm</label>
                                <label><input type="radio" name="purpose" value="Văn phòng" onchange="filterChanged()" ${param.purpose == 'Văn phòng' ? 'checked' : ''}> Học tập - Văn phòng</label>
                                <label><input type="radio" name="purpose" value="Đồ họa" onchange="filterChanged()" ${param.purpose == 'Đồ họa' ? 'checked' : ''}> Đồ họa - Kỹ thuật</label>
                                <label><input type="radio" name="purpose" value="Mỏng nhẹ" onchange="filterChanged()" ${param.purpose == 'Mỏng nhẹ' ? 'checked' : ''}> Mỏng nhẹ - Cao cấp</label>
                            </div>
                        </c:if>

                        <!--Nhu cầu cho Chuột, Bàn phím -->
                        <c:if test="${categoryId == 4 || categoryId == 3}">
                            <div class="filter-group">
                                <h4><i class="fas fa-briefcase"></i> Nhu cầu</h4>
                                <label><input type="radio" name="purpose" value="" onchange="filterChanged()" ${empty param.purpose ? 'checked' : ''}> Tất cả nhu cầu</label>
                                <label><input type="radio" name="purpose" value="Gaming" onchange="filterChanged()" ${param.purpose == 'Gaming' ? 'checked' : ''}> Gaming</label>
                                <label><input type="radio" name="purpose" value="Văn phòng" onchange="filterChanged()" ${param.purpose == 'Văn phòng' ? 'checked' : ''}> Văn phòng</label>
                            </div>
                        </c:if>

                        <!--  bộ lọc kỹ thuật cho Chuột và Bàn phím  -->
                        <c:if test="${categoryId == 4 || categoryId == 3}">
                            <div class="filter-group">
                                <h4><i class="fas fa-wifi"></i> Độ kết nối</h4>
                                <label><input type="radio" name="connectivity" value="" onchange="filterChanged()" ${empty param.connectivity ? 'checked' : ''}> Tất cả</label>
                                <label><input type="radio" name="connectivity" value="Có dây" onchange="filterChanged()" ${param.connectivity == 'Có dây' ? 'checked' : ''}> Có dây</label>
                                <label><input type="radio" name="connectivity" value="Bluetooth" onchange="filterChanged()" ${param.connectivity == 'Bluetooth' ? 'checked' : ''}> Bluetooth</label>
                                <label><input type="radio" name="connectivity" value="Wireless 2.4GHz" onchange="filterChanged()" ${param.connectivity == 'Wireless 2.4GHz' ? 'checked' : ''}> Wireless 2.4GHz</label>
                                <label><input type="radio" name="connectivity" value="Bluetooth + Wireless 2.4GHz" onchange="filterChanged()" ${param.connectivity == 'Bluetooth + Wireless 2.4GHz' ? 'checked' : ''}> Đa kết nối (BT + 2.4G)</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 3}">
                            <!-- Switch -->
                            <div class="filter-group">
                                <h4><i class="fas fa-keyboard"></i> Switch (Phím cơ)</h4>
                                <label><input type="radio" name="switch" value="" onchange="filterChanged()" ${empty param['switch'] ? 'checked' : ''}> Tất cả</label>
                                <label><input type="radio" name="switch" value="Blue" onchange="filterChanged()" ${param['switch'] == 'Blue' ? 'checked' : ''}> Blue Switch (Clicky)</label>
                                <label><input type="radio" name="switch" value="Brown" onchange="filterChanged()" ${param['switch'] == 'Brown' ? 'checked' : ''}> Brown Switch (Tactile)</label>
                                <label><input type="radio" name="switch" value="Red" onchange="filterChanged()" ${param['switch'] == 'Red' ? 'checked' : ''}> Red Switch (Linear)</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 4}">
                            <!-- DPI -->
                            <div class="filter-group">
                                <h4><i class="fas fa-mouse"></i> DPI</h4>
                                <label><input type="radio" name="dpi" value="" onchange="filterChanged()" ${empty param.dpi ? 'checked' : ''}> Tất cả</label>
                                <label><input type="radio" name="dpi" value="3200" onchange="filterChanged()" ${param.dpi == '3200' ? 'checked' : ''}> 3200 DPI</label>
                                <label><input type="radio" name="dpi" value="8000" onchange="filterChanged()" ${param.dpi == '8000' ? 'checked' : ''}> 8000 DPI</label>
                                <label><input type="radio" name="dpi" value="12000" onchange="filterChanged()" ${param.dpi == '12000' ? 'checked' : ''}> 12000 DPI</label>
                                <label><input type="radio" name="dpi" value="18000" onchange="filterChanged()" ${param.dpi == '18000' ? 'checked' : ''}> 18000 DPI</label>
                                <label><input type="radio" name="dpi" value="26000" onchange="filterChanged()" ${param.dpi == '26000' ? 'checked' : ''}> 26000 DPI</label>
                                <label><input type="radio" name="dpi" value="30000" onchange="filterChanged()" ${param.dpi == '30000' ? 'checked' : ''}> 30000+ DPI</label>
                            </div>
                        </c:if>

                        <!-- bộ lọc laptop -->
                        <c:if test="${categoryId == 1}">
                            <!-- CPU -->
                            <div class="filter-group">
                                <h4><i class="fas fa-microchip"></i> CPU</h4>
                                <label><input type="radio" name="cpu" value="" onchange="filterChanged()" ${empty param.cpu ? 'checked' : ''}> Tất cả CPU</label>
                                <label><input type="radio" name="cpu" value="Apple M3" onchange="filterChanged()" ${param.cpu == 'Apple M3' ? 'checked' : ''}> Apple M3</label>
                                <label><input type="radio" name="cpu" value="Intel Core Ultra 7" onchange="filterChanged()" ${param.cpu == 'Intel Core Ultra 7' ? 'checked' : ''}> Intel Core Ultra 7</label>
                                <label><input type="radio" name="cpu" value="Intel Core Ultra 9" onchange="filterChanged()" ${param.cpu == 'Intel Core Ultra 9' ? 'checked' : ''}> Intel Core Ultra 9</label>
                                <label><input type="radio" name="cpu" value="Ryzen 7 8845HS" onchange="filterChanged()" ${param.cpu == 'Ryzen 7 8845HS' ? 'checked' : ''}> Ryzen 7 8845HS</label>
                                <label><input type="radio" name="cpu" value="Ryzen 9 8945HS" onchange="filterChanged()" ${param.cpu == 'Ryzen 9 8945HS' ? 'checked' : ''}> Ryzen 9 8945HS</label>
                            </div>

                            <!-- RAM -->
                        <div class="filter-group">
                            <h4><i class="fas fa-memory"></i> RAM</h4>
                            <label><input type="radio" name="ram" value="" onchange="filterChanged()" ${empty param.ram ? 'checked' : ''}> Tất cả RAM</label>
                            <label><input type="radio" name="ram" value="8GB" onchange="filterChanged()" ${param.ram == '8GB' ? 'checked' : ''}> 8GB</label>
                            <label><input type="radio" name="ram" value="16GB" onchange="filterChanged()" ${param.ram == '16GB' ? 'checked' : ''}> 16GB</label>
                            <label><input type="radio" name="ram" value="18GB" onchange="filterChanged()" ${param.ram == '18GB' ? 'checked' : ''}> 18GB</label>
                            <label><input type="radio" name="ram" value="32GB" onchange="filterChanged()" ${param.ram == '32GB' ? 'checked' : ''}> 32GB</label>
                        </div>

                        <!-- SSD -->
                        <div class="filter-group">
                            <h4><i class="fas fa-hdd"></i> SSD</h4>
                            <label><input type="radio" name="ssd" value="" onchange="filterChanged()" ${empty param.ssd ? 'checked' : ''}> Tất cả SSD</label>
                            <label><input type="radio" name="ssd" value="256GB" onchange="filterChanged()" ${param.ssd == '256GB' ? 'checked' : ''}> 256GB</label>
                            <label><input type="radio" name="ssd" value="512GB" onchange="filterChanged()" ${param.ssd == '512GB' ? 'checked' : ''}> 512GB</label>
                            <label><input type="radio" name="ssd" value="1TB" onchange="filterChanged()" ${param.ssd == '1TB' ? 'checked' : ''}> 1TB</label>
                        </div>

                        <!-- GPU -->
                        <div class="filter-group">
                            <h4><i class="fas fa-gamepad"></i> GPU</h4>
                            <label><input type="radio" name="gpu" value="" onchange="filterChanged()" ${empty param.gpu ? 'checked' : ''}> Tất cả GPU</label>
                            <label><input type="radio" name="gpu" value="RTX 2050" onchange="filterChanged()" ${param.gpu == 'RTX 2050' ? 'checked' : ''}> RTX 2050</label>
                            <label><input type="radio" name="gpu" value="RTX 3050" onchange="filterChanged()" ${param.gpu == 'RTX 3050' ? 'checked' : ''}> RTX 3050</label>
                            <label><input type="radio" name="gpu" value="RTX 4050" onchange="filterChanged()" ${param.gpu == 'RTX 4050' ? 'checked' : ''}> RTX 4050</label>
                            <label><input type="radio" name="gpu" value="RTX 4060" onchange="filterChanged()" ${param.gpu == 'RTX 4060' ? 'checked' : ''}> RTX 4060</label>
                            <label><input type="radio" name="gpu" value="RTX 4070" onchange="filterChanged()" ${param.gpu == 'RTX 4070' ? 'checked' : ''}> RTX 4070</label>
                        </div>

                        <!-- Screen -->
                        <div class="filter-group">
                            <h4><i class="fas fa-desktop"></i> Màn hình</h4>
                            <label><input type="radio" name="screen" value="" onchange="filterChanged()" ${empty param.screen ? 'checked' : ''}> Tất cả Screen</label>
                            <label><input type="radio" name="screen" value="13.6" onchange="filterChanged()" ${param.screen == '13.6' ? 'checked' : ''}> 13.6 inch</label>
                            <label><input type="radio" name="screen" value="14" onchange="filterChanged()" ${param.screen == '14' ? 'checked' : ''}> 14 inch</label>
                            <label><input type="radio" name="screen" value="16.0" onchange="filterChanged()" ${param.screen == '16.0' ? 'checked' : ''}> 16.0 inch</label>
                            <label><input type="radio" name="screen" value="16.2" onchange="filterChanged()" ${param.screen == '16.2' ? 'checked' : ''}> 16.2 inch</label>
                        </div>
                        </c:if>

                        <!-- Price -->
                        <div class="filter-group">
                            <h4><i class="fas fa-money-bill-wave"></i> Price</h4>
                            <label><input type="radio" name="price" value="" onchange="filterChanged()" ${empty param.price ? 'checked' : ''}> Tất cả mức giá</label>
                            
                            <c:choose>
                                <c:when test="${categoryId == 1}">
                                    <label><input type="radio" name="price" value="under15" onchange="filterChanged()" ${param.price == 'under15' ? 'checked' : ''}> Dưới 15 triệu</label>
                                    <label><input type="radio" name="price" value="15to20" onchange="filterChanged()" ${param.price == '15to20' ? 'checked' : ''}> 15 - 20 triệu</label>
                                    <label><input type="radio" name="price" value="20to30" onchange="filterChanged()" ${param.price == '20to30' ? 'checked' : ''}> 20 - 30 triệu</label>
                                    <label><input type="radio" name="price" value="30to40" onchange="filterChanged()" ${param.price == '30to40' ? 'checked' : ''}> 30 - 40 triệu</label>
                                    <label><input type="radio" name="price" value="over40" onchange="filterChanged()" ${param.price == 'over40' ? 'checked' : ''}> Trên 40 triệu</label>
                                </c:when>
                                <c:otherwise>
                                    <label><input type="radio" name="price" value="under500k" onchange="filterChanged()" ${param.price == 'under500k' ? 'checked' : ''}> Dưới 500.000đ</label>
                                    <label><input type="radio" name="price" value="500kto1m" onchange="filterChanged()" ${param.price == '500kto1m' ? 'checked' : ''}> 500.000đ - 1 triệu</label>
                                    <label><input type="radio" name="price" value="1mto2m" onchange="filterChanged()" ${param.price == '1mto2m' ? 'checked' : ''}> 1 - 2 triệu</label>
                                    <label><input type="radio" name="price" value="2mto3m" onchange="filterChanged()" ${param.price == '2mto3m' ? 'checked' : ''}> 2 - 3 triệu</label>
                                    <label><input type="radio" name="price" value="over3m" onchange="filterChanged()" ${param.price == 'over3m' ? 'checked' : ''}> Trên 3 triệu</label>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <button type="button" class="clear-all" onclick="window.location.href='ProductListServlet?category=${categoryId}'">Clear All Filters</button>
                    </div>
                </aside>

                <!--sort -->
                <main class="content">
                    <div class="sort-bar">
                        <span>Sắp xếp:</span>
                        <select name="sort" onchange="filterChanged()">
                            <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Phổ biến nhất</option>
                            <option value="new" ${param.sort == 'new' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                        </select>
                    </div>

                    <c:if test="${empty products}">
                        <div style="text-align: center; padding: 50px 0; color: #888;">
                            <h3>Không tìm thấy sản phẩm nào phù hợp với bộ lọc!</h3>
                        </div>
                    </c:if>

                    <div class="product-grid">
                        <c:forEach items="${products}" var="p" varStatus="status">
                            <div class="product-card">
                                <c:choose>
                                    <c:when test="${status.index % 3 == 0}">
                                        <div class="badge new-arrival">New Arrival</div>
                                    </c:when>
                                    <c:when test="${status.index % 5 == 0}">
                                        <div class="badge best-seller">Best Seller</div>
                                    </c:when>
                                </c:choose>
                                
                                <img src="images/${p.thumbnail}" alt="${p.productName}" class="product-img" onerror="this.src='https://via.placeholder.com/200x150?text=Laptop'">
                                
                                <h3 class="product-title">${p.productName}</h3>
                                
                                <div class="specs">
                                    <!-- Laptop -->
                                    <c:if test="${not empty p.cpu}"><span class="spec-chip">${p.cpu}</span></c:if>
                                    <c:if test="${not empty p.ram}"><span class="spec-chip">${p.ram}</span></c:if>
                                    <c:if test="${not empty p.gpu}"><span class="spec-chip">${p.gpu}</span></c:if>
                                    
                                    <!--Chuột, Bàn phím -->
                                    <c:if test="${not empty p.connectivity}"><span class="spec-chip">${p.connectivity}</span></c:if>
                                    <c:if test="${not empty p.switchType}"><span class="spec-chip">${p.switchType}</span></c:if>
                                    <c:if test="${not empty p.dpi}"><span class="spec-chip">${p.dpi}</span></c:if>
                                </div>
                                
                                <div class="price">
                                    <fmt:formatNumber value="${p.minPrice}" pattern="#,##0"/>₫
                                </div>
                                
                                <div class="actions">
                                    <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
                                    <button type="button" class="btn-buy-now">Mua ngay</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})"><i class="fas fa-chevron-left"></i></a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="javascript:void(0)" class="${i == currentPage ? 'active' : ''}" onclick="goToPage(${i})">${i}</a>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})"><i class="fas fa-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </main>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container footer-grid">
            <div class="footer-col">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo footer-logo">UniLap</a>
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

        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 UniLap. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
</body>
</html>

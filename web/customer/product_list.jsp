<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product_list.css?v=2">
</head>

<!--Header-->
<body class="product-list-page">
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
                    <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down dropdown-chevron"></i></span>
                    <div class="dropdown-content">
                        <c:forEach items="${categories}" var="cat">
                            <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                <a href="ProductListServlet?category=${cat.categoryId}" class="${categoryId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
              <!--Danh mục-->
                <a href="#">Khuyến mãi</a>
            </nav>
            <div class="header-icons header-icons-inline">
                <form action="ProductListServlet" method="GET" class="search-form product-search-form">
                    <c:if test="${not empty categoryId}">
                        <input type="hidden" name="category" value="${categoryId}">
                    </c:if>
                    <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm sản phẩm..." class="product-search-input">
                    <button type="submit" class="product-search-btn"><i class="fas fa-search"></i></button>
                </form>
                <a href="#"><i class="fas fa-shopping-cart"></i></a>
                <a href="#"><i class="fas fa-bell"></i></a>
                <a href="#"><i class="fas fa-user"></i></a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <c:if test="${globalSearch}">
            <!-- Chế độ tìm kiếm-->
            <div class="global-search-header">
                <div class="search-result-info">
                    <h2><i class="fas fa-search"></i> Kết quả tìm kiếm cho: "<span class="search-keyword">${searchKeyword}</span>"</h2>
                    <p>${empty products ? 0 : fn:length(products)} sản phẩm được tìm thấy</p>
                </div>
                <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back-home">
                    <i class="fas fa-arrow-left"></i> Về trang chủ
                </a>
            </div>

            <div class="product-grid global-search-grid">
                <c:forEach items="${products}" var="p">
                    <div class="product-card">
                        <div class="product-badge category-badge">${p.categoryName}</div>
                        <div class="product-img-wrap">
                            <img src="images/${p.thumbnail}" alt="${p.productName}" class="product-img">
                        </div>
                        <div class="product-meta">${p.brandName}</div>
                        <h3 class="product-title">${p.productName}</h3>
                        <div class="price-row">
                            <div class="price"><fmt:formatNumber value="${p.minPrice}" pattern="#,##0"/>₫</div>
                            <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!--Báo không tìm thấy-->
            <c:if test="${empty products}">
                <div class="empty-state">
                    <i class="fas fa-search" style="font-size: 48px; color: #cbd5e1; margin-bottom: 16px;"></i>
                    <h3>Không tìm thấy sản phẩm nào cho "${searchKeyword}"</h3>
                    <p>Hãy thử tìm kiếm với từ khóa khác</p>
                </div>
            </c:if>
            <!--Phân quyền-->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="ProductListServlet?search=${searchKeyword}&page=${currentPage - 1}" class="pagination-link"><i class="fas fa-chevron-left"></i></a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="ProductListServlet?search=${searchKeyword}&page=${i}" class="pagination-link ${i == currentPage ? 'active' : ''}">${i}</a>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="ProductListServlet?search=${searchKeyword}&page=${currentPage + 1}" class="pagination-link"><i class="fas fa-chevron-right"></i></a>
                    </c:if>
                </div>
            </c:if>
        </c:if>
          
        <c:if test="${!globalSearch}">
        <form action="ProductListServlet" method="GET" id="filterForm">
            <input type="hidden" name="category" value="${categoryId}">
            <input type="hidden" name="page" id="pageInput" value="${currentPage != null ? currentPage : 1}">
            <input type="hidden" name="search" value="${param.search}">

            <div class="brand-list">
                <label class="brand-btn">
                    <input type="radio" name="brand" value="" class="js-auto-submit" ${empty param.brand ? 'checked' : ''}>
                    <span>Tất cả thương hiệu</span>
                </label>
                <c:forEach items="${brands}" var="b">
                    <label class="brand-btn">
                        <input type="radio" name="brand" value="${b.brandId}" class="js-auto-submit" ${param.brand == b.brandId.toString() ? 'checked' : ''}>
                        <span>${b.brandName}</span>
                    </label>
                </c:forEach>
            </div>

            <div class="main-layout">
                <aside class="sidebar">
                    <div class="filter-card">
                        <h2>Bộ Lọc</h2>

                        <c:if test="${categoryId == 1 && not empty serieses}">
                            <div class="filter-group">
                                <h4><i class="fas fa-layer-group"></i> Series</h4>
                                <label><input type="radio" name="series" value="" class="js-auto-submit" ${empty param.series ? 'checked' : ''}> Tất cả Series</label>
                                <c:forEach items="${serieses}" var="s">
                                    <label>
                                        <input type="radio" name="series" value="${s.seriesId}" class="js-auto-submit" ${param.series == s.seriesId.toString() ? 'checked' : ''}>
                                        ${s.seriesName}
                                    </label>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 1}">
                            <div class="filter-group">
                                <h4><i class="fas fa-briefcase"></i> Nhu cầu</h4>
                                <label><input type="radio" name="purpose" value="" class="js-auto-submit" ${empty param.purpose ? 'checked' : ''}> Tất cả nhu cầu</label>
                                <label><input type="radio" name="purpose" value="Gaming" class="js-auto-submit" ${param.purpose == 'Gaming' ? 'checked' : ''}> Gaming - Trải nghiệm</label>
                                <label><input type="radio" name="purpose" value="Văn phòng" class="js-auto-submit" ${param.purpose == 'Văn phòng' ? 'checked' : ''}> Học tập - Văn phòng</label>
                                <label><input type="radio" name="purpose" value="Đồ họa" class="js-auto-submit" ${param.purpose == 'Đồ họa' ? 'checked' : ''}> Đồ họa - Kỹ thuật</label>
                                <label><input type="radio" name="purpose" value="Mỏng nhẹ" class="js-auto-submit" ${param.purpose == 'Mỏng nhẹ' ? 'checked' : ''}> Mỏng nhẹ - Cao cấp</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 4 || categoryId == 3}">
                            <div class="filter-group">
                                <h4><i class="fas fa-briefcase"></i> Nhu cầu</h4>
                                <label><input type="radio" name="purpose" value="" class="js-auto-submit" ${empty param.purpose ? 'checked' : ''}> Tất cả nhu cầu</label>
                                <label><input type="radio" name="purpose" value="Gaming" class="js-auto-submit" ${param.purpose == 'Gaming' ? 'checked' : ''}> Gaming</label>
                                <label><input type="radio" name="purpose" value="Văn phòng" class="js-auto-submit" ${param.purpose == 'Văn phòng' ? 'checked' : ''}> Văn phòng</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 4 || categoryId == 3}">
                            <div class="filter-group">
                                <h4><i class="fas fa-wifi"></i> Kiểu kết nối</h4>
                                <label><input type="radio" name="connectivity" value="" class="js-auto-submit" ${empty param.connectivity ? 'checked' : ''}> Tất cả kết nối</label>
                                <label><input type="radio" name="connectivity" value="wired" class="js-auto-submit" ${param.connectivity == 'wired' ? 'checked' : ''}> Có dây</label>
                                <label><input type="radio" name="connectivity" value="wireless" class="js-auto-submit" ${param.connectivity == 'wireless' ? 'checked' : ''}> Không dây</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 3}">
                            <div class="filter-group">
                                <h4><i class="fas fa-keyboard"></i> Switch (Phím cơ)</h4>
                                <label><input type="radio" name="switch" value="" class="js-auto-submit" ${empty param['switch'] ? 'checked' : ''}> Tất cả switch</label>
                                <label><input type="radio" name="switch" value="clicky" class="js-auto-submit" ${param['switch'] == 'clicky' ? 'checked' : ''}> Blue Switch (Clicky)</label>
                                <label><input type="radio" name="switch" value="tactile" class="js-auto-submit" ${param['switch'] == 'tactile' ? 'checked' : ''}> Brown Switch (Tactile)</label>
                                <label><input type="radio" name="switch" value="linear" class="js-auto-submit" ${param['switch'] == 'linear' ? 'checked' : ''}> Red/Yellow Switch (Linear)</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 4}">
                            <div class="filter-group">
                                <h4><i class="fas fa-mouse"></i> DPI</h4>
                                <label><input type="radio" name="dpi" value="" class="js-auto-submit" ${empty param.dpi ? 'checked' : ''}> Tất cả DPI</label>
                                <label><input type="radio" name="dpi" value="under10k" class="js-auto-submit" ${param.dpi == 'under10k' ? 'checked' : ''}> Dưới 10.000 DPI</label>
                                <label><input type="radio" name="dpi" value="10kto20k" class="js-auto-submit" ${param.dpi == '10kto20k' ? 'checked' : ''}> 10.000 - 20.000 DPI</label>
                                <label><input type="radio" name="dpi" value="over20k" class="js-auto-submit" ${param.dpi == 'over20k' ? 'checked' : ''}> Trên 20.000 DPI</label>
                            </div>
                        </c:if>

                        <c:if test="${categoryId == 1}">
                            <div class="filter-group">
                                <h4><i class="fas fa-microchip"></i> CPU</h4>
                                <label><input type="radio" name="cpu" value="" class="js-auto-submit" ${empty param.cpu ? 'checked' : ''}> Tất cả CPU</label>
                                <label><input type="radio" name="cpu" value="i7" class="js-auto-submit" ${param.cpu == 'i7' ? 'checked' : ''}> Intel Core i7</label>
                                <label><input type="radio" name="cpu" value="i9" class="js-auto-submit" ${param.cpu == 'i9' ? 'checked' : ''}> Intel Core i9</label>
                                <label><input type="radio" name="cpu" value="Ryzen 7" class="js-auto-submit" ${param.cpu == 'Ryzen 7' ? 'checked' : ''}> AMD Ryzen 7</label>
                                <label><input type="radio" name="cpu" value="Apple" class="js-auto-submit" ${param.cpu == 'Apple' ? 'checked' : ''}> Apple M-Series</label>
                            </div>

                            <div class="filter-group">
                                <h4><i class="fas fa-memory"></i> RAM</h4>
                                <label><input type="radio" name="ram" value="" class="js-auto-submit" ${empty param.ram ? 'checked' : ''}> Tất cả RAM</label>
                                <label><input type="radio" name="ram" value="8GB" class="js-auto-submit" ${param.ram == '8GB' ? 'checked' : ''}> 8 GB</label>
                                <label><input type="radio" name="ram" value="16GB" class="js-auto-submit" ${param.ram == '16GB' ? 'checked' : ''}> 16 GB</label>
                                <label><input type="radio" name="ram" value="32GB" class="js-auto-submit" ${param.ram == '32GB' ? 'checked' : ''}> 32 GB</label>
                            </div>

                            <div class="filter-group">
                                <h4><i class="fas fa-hdd"></i> SSD</h4>
                                <label><input type="radio" name="ssd" value="" class="js-auto-submit" ${empty param.ssd ? 'checked' : ''}> Tất cả SSD</label>
                                <label><input type="radio" name="ssd" value="512GB" class="js-auto-submit" ${param.ssd == '512GB' ? 'checked' : ''}> 512 GB</label>
                                <label><input type="radio" name="ssd" value="1TB" class="js-auto-submit" ${param.ssd == '1TB' ? 'checked' : ''}> 1 TB</label>
                            </div>

                            <div class="filter-group">
                                <h4><i class="fas fa-gamepad"></i> GPU</h4>
                                <label><input type="radio" name="gpu" value="" class="js-auto-submit" ${empty param.gpu ? 'checked' : ''}> Tất cả GPU</label>
                                <label><input type="radio" name="gpu" value="Intel" class="js-auto-submit" ${param.gpu == 'Intel' ? 'checked' : ''}> Card tích hợp (Intel/AMD)</label>
                                <label><input type="radio" name="gpu" value="NVIDIA" class="js-auto-submit" ${param.gpu == 'NVIDIA' ? 'checked' : ''}> Card rời NVIDIA GeForce</label>
                            </div>

                            <div class="filter-group">
                                <h4><i class="fas fa-desktop"></i> Màn hình</h4>
                                <label><input type="radio" name="screen" value="" class="js-auto-submit" ${empty param.screen ? 'checked' : ''}> Tất cả màn hình</label>
                                <label><input type="radio" name="screen" value="13.6" class="js-auto-submit" ${param.screen == '13.6' ? 'checked' : ''}> 13.6 inch</label>
                                <label><input type="radio" name="screen" value="14" class="js-auto-submit" ${param.screen == '14' ? 'checked' : ''}> 14 inch - 14.2 inch</label>
                                <label><input type="radio" name="screen" value="15.6" class="js-auto-submit" ${param.screen == '15.6' ? 'checked' : ''}> 15.6 inch</label>
                                <label><input type="radio" name="screen" value="16" class="js-auto-submit" ${param.screen == '16' ? 'checked' : ''}> 16 inch</label>
                                <label><input type="radio" name="screen" value="17.3" class="js-auto-submit" ${param.screen == '17.3' ? 'checked' : ''}> 17.3 inch</label>
                            </div>
                        </c:if>

                        <div class="filter-group">
                            <h4><i class="fas fa-money-bill-wave"></i> Mức giá</h4>
                            <label><input type="radio" name="price" value="" class="js-auto-submit" ${empty param.price ? 'checked' : ''}> Tất cả mức giá</label>

                            <c:choose>
                                <c:when test="${categoryId == 1}">
                                    <label><input type="radio" name="price" value="under15" class="js-auto-submit" ${param.price == 'under15' ? 'checked' : ''}> Dưới 15 triệu</label>
                                    <label><input type="radio" name="price" value="15to20" class="js-auto-submit" ${param.price == '15to20' ? 'checked' : ''}> 15 - 20 triệu</label>
                                    <label><input type="radio" name="price" value="20to30" class="js-auto-submit" ${param.price == '20to30' ? 'checked' : ''}> 20 - 30 triệu</label>
                                    <label><input type="radio" name="price" value="30to40" class="js-auto-submit" ${param.price == '30to40' ? 'checked' : ''}> 30 - 40 triệu</label>
                                    <label><input type="radio" name="price" value="over40" class="js-auto-submit" ${param.price == 'over40' ? 'checked' : ''}> Trên 40 triệu</label>
                                </c:when>
                                <c:otherwise>
                                    <label><input type="radio" name="price" value="under500k" class="js-auto-submit" ${param.price == 'under500k' ? 'checked' : ''}> Dưới 500.000đ</label>
                                    <label><input type="radio" name="price" value="500kto1m" class="js-auto-submit" ${param.price == '500kto1m' ? 'checked' : ''}> 500.000đ - 1 triệu</label>
                                    <label><input type="radio" name="price" value="1mto2m" class="js-auto-submit" ${param.price == '1mto2m' ? 'checked' : ''}> 1 - 2 triệu</label>
                                    <label><input type="radio" name="price" value="2mto3m" class="js-auto-submit" ${param.price == '2mto3m' ? 'checked' : ''}> 2 - 3 triệu</label>
                                    <label><input type="radio" name="price" value="over3m" class="js-auto-submit" ${param.price == 'over3m' ? 'checked' : ''}> Trên 3 triệu</label>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <button type="button" class="clear-all js-clear-all" data-clear-url="ProductListServlet?category=${categoryId}">Xóa tất cả bộ lọc</button>
                    </div>
                </aside>

                <main class="content">
                    <div class="results-bar">
                        <div class="results-info">
                            <h2>Danh sách sản phẩm</h2>
                            <p>${empty products ? 0 : fn:length(products)} sản phẩm phù hợp</p>
                        </div>
                        <div class="sort-bar">
                            <span>Sắp xếp:</span>
                            <select name="sort" class="js-auto-submit">
                                <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Phổ biến nhất</option>
                                <option value="new" ${param.sort == 'new' ? 'selected' : ''}>Mới nhất</option>
                                <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                            </select>
                        </div>
                    </div>

                    <c:if test="${empty products}">
                        <div class="empty-state">
                            <h3>Không tìm thấy sản phẩm nào phù hợp với bộ lọc!</h3>
                        </div>
                    </c:if>

                    <div class="product-grid">
                        <c:forEach items="${products}" var="p">
                            <div class="product-card">
                                <div class="product-img-wrap">
                                    <img src="images/${p.thumbnail}" alt="${p.productName}" class="product-img" data-fallback-src="https://via.placeholder.com/200x150?text=Laptop">
                                </div>
                                <div class="product-meta">${empty p.brandName ? p.categoryName : p.brandName}</div>
                                <h3 class="product-title">${p.productName}</h3>

                                <div class="specs">
                                    <c:if test="${not empty p.cpu}"><span class="spec-chip">${p.cpu}</span></c:if>
                                    <c:if test="${not empty p.ram}"><span class="spec-chip">${p.ram}</span></c:if>
                                    <c:if test="${not empty p.gpu}"><span class="spec-chip">${p.gpu}</span></c:if>
                                    <c:if test="${not empty p.connectivity}"><span class="spec-chip">${p.connectivity}</span></c:if>
                                    <c:if test="${not empty p.switchType}"><span class="spec-chip">${p.switchType}</span></c:if>
                                    <c:if test="${not empty p.dpi}"><span class="spec-chip">${p.dpi}</span></c:if>
                                </div>

                                <div class="price-row">
                                    <div class="price">
                                        <fmt:formatNumber value="${p.minPrice}" pattern="#,##0"/>₫
                                    </div>
                                    <button type="button" class="btn-add-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="#" class="pagination-link js-go-to-page" data-page="${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="#" class="pagination-link js-go-to-page ${i == currentPage ? 'active' : ''}" data-page="${i}">${i}</a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="#" class="pagination-link js-go-to-page" data-page="${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </main>
            </div>
        </form>
        </c:if>
    </div>

    <%
        if (request.getAttribute("footerPages") == null) {
            try {
                dal.PageContentDAO pgDAO = new dal.PageContentDAO();
                java.util.ArrayList<model.PageContent> footerPagesList = pgDAO.getAllActivePages();
                request.setAttribute("footerPages", footerPagesList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <footer class="footer">
        <div class="container footer-grid">
            <!-- Column 1: Brand & Contact -->
            <div class="footer-col">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo footer-logo">UniLap</a>
                <p class="footer-brand-desc">Nền tảng mua sắm công nghệ cao cấp hàng đầu. Chúng tôi cam kết đem lại trải nghiệm mua sắm tuyệt vời nhất với các sản phẩm laptop, bàn phím và chuột máy tính chính hãng chất lượng cao.</p>
                <div class="footer-contact-info">
                    <p><i class="fas fa-map-marker-alt"></i>Mỹ Đình, Hà Nội</p>
                    <p><i class="fas fa-phone-alt"></i> Hotline: 1900 8888 (8:00 - 22:00)</p>
                    <p><i class="fas fa-envelope"></i> Email: support@unilap.vn</p>
                </div>
                <div class="social-icons">
                    <a href="#" class="social-icon-fb"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon-yt"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="social-icon-ig"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-icon-tt"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h3>Chính sách & Hỗ trợ</h3>
                <ul>
                    <c:if test="${not empty footerPages}">
                        <c:forEach items="${footerPages}" var="pageItem">
                            <li><a href="${pageContext.request.contextPath}/page?key=${pageItem.pageKey}"><i class="fas fa-chevron-right"></i> ${pageItem.title}</a></li>
                        </c:forEach>
                    </c:if>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <div class="container footer-bottom-container">
                <p>&copy; 2026 UniLap. Tất cả các quyền được bảo hộ.</p>
                <p style="font-size: 12px; color: #94a3b8;">Thiết kế bởi <a href="#" style="color: var(--primary); font-weight: 500;">UniLap Team</a></p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/product_list.js?v=2"></script>
</body>
</html>

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
    </head>
    <body>
        <!-- Header -->
        <%@include file="_header.jspf" %>

        <!-- phần quảng cáo -->
        <section class="hero">
            <div class="container">
                <div class="hero-slider-wrapper">
                    <div class="hero-slides">
                        <c:forEach items="${banners}" var="b" varStatus="status">
                            <div class="hero-slide ${status.first ? 'active' : ''}">
                                <a href="#">
                                    <img src="${b.imageUrl}" data-context="${pageContext.request.contextPath}" class="banner-img-auto" alt="Banner">
                                </a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty banners}">
                            <div class="hero-slide active">
                                <a href="#">
                                    <img src="https://images.unsplash.com/photo-1531297122539-5692f6e10821?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80" alt="Laptop AI">
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

                            <div class="product-card">

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
                        <div class="product-card">
                            <div class="product-badge best-seller">Bán chạy</div>
                            <c:if test="${p.discountPercent > 0}">
                                <div class="product-badge discount" style="left: auto; right: 16px;">-${p.discountPercent}%</div>
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
                        <div class="product-card">
                            <div class="product-badge new">Mới</div>
                            <c:if test="${p.discountPercent > 0}">
                                <div class="product-badge discount" style="left: auto; right: 16px;">-${p.discountPercent}%</div>
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
    </body>
</html>

<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${product.productName} - UniLap</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product_detail.css?v=10">
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
                            <a href="ProductListServlet?category=${cat.categoryId}" class="${product.categoryId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
                        </c:if>
                    </c:forEach>

                    <div class="nav-dropdown ${product.categoryId == 2 || product.categoryId == 5 || product.categoryId == 6 || product.categoryId == 7 ? 'active' : ''}">
                        <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                        <div class="dropdown-content">
                            <c:forEach items="${categories}" var="cat">
                                <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                    <a href="ProductListServlet?category=${cat.categoryId}" class="${product.categoryId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
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
                    <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative; color: inherit;">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                            <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                        </c:if>
                    </a>
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
                                            <a href="#" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
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
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                            </c:otherwise>
                        </c:choose>
                </div>
            </div>
        </header>

        <div class="container">
            <!-- Breadcrumb navigation -->
            <nav class="pd-breadcrumb">
                <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
                <i class="fas fa-chevron-right"></i>
                <a href="ProductListServlet?category=${product.categoryId}">${product.categoryName}</a>
                <c:if test="${not empty product.purpose}">
                    <i class="fas fa-chevron-right"></i>
                    <a href="ProductListServlet?category=${product.categoryId}&purpose=${product.purpose}">${product.purpose}</a>
                </c:if>
                <i class="fas fa-chevron-right"></i>
                <span>${product.productName}</span>
            </nav>

            <!-- Main Product Section -->
            <div class="pd-grid">
                <!-- Left: Gallery -->
                <div class="pd-gallery">
                    <div class="pd-img-main-wrap">
                        <img id="mainProductImg" src="${pageContext.request.contextPath}/images/${product.thumbnail}" 
                             alt="${product.productName}" class="pd-img-main"
                             onerror="this.src='https://via.placeholder.com/500x400?text=UniLap'">
                    </div>
                    <div class="pd-thumbnails">
                        <div class="pd-thumb-wrap active">
                            <img src="${pageContext.request.contextPath}/images/${product.thumbnail}" alt="${product.productName}">
                        </div>
                        <div class="pd-thumb-wrap">
                            <img src="${pageContext.request.contextPath}/images/${product.thumbnail}" style="filter: hue-rotate(90deg);" alt="Detail 1">
                        </div>
                        <div class="pd-thumb-wrap">
                            <img src="${pageContext.request.contextPath}/images/${product.thumbnail}" style="filter: brightness(0.8);" alt="Detail 2">
                        </div>
                        <div class="pd-thumb-wrap">
                            <img src="${pageContext.request.contextPath}/images/${product.thumbnail}" style="filter: saturate(1.5);" alt="Detail 3">
                        </div>
                    </div>
                </div>

                <!-- Right: Info details -->
                <div class="pd-details">
                    <div class="pd-badge">
                        <c:choose>
                            <c:when test="${not empty product.purpose}">${product.purpose}</c:when>
                            <c:otherwise>Sản phẩm Hot</c:otherwise>
                        </c:choose>
                    </div>
                    <h1 class="pd-title">${product.productName}</h1>

                    <div class="pd-rating-row">
                        <div class="pd-stars">
                            <c:forEach var="i" begin="1" end="5">
                                <c:choose>
                                    <c:when test="${i <= averageRating}">
                                        <i class="fas fa-star" style="color: #f59e0b;"></i>
                                    </c:when>
                                    <c:when test="${i - 1 < averageRating && averageRating < i}">
                                        <i class="fas fa-star-half-alt" style="color: #f59e0b;"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-star" style="color: #cbd5e1;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span style="font-weight: 600; margin-left: 5px; color: #1e293b;">
                                <fmt:formatNumber value="${averageRating}" pattern="0.0"/>
                            </span>
                        </div>
                        <div class="pd-reviews-count">(${reviewsCount} đánh giá)</div>
                    </div>

                    <!-- Price Box -->
                    <div class="pd-price-box">
                        <div class="pd-price-main-row">
                            <span id="pdPrice" class="pd-price-selling">
                                <c:choose>
                                    <c:when test="${not empty variants}">
                                        <fmt:formatNumber value="${variants[0].sellingPrice}" pattern="#,##0"/>₫
                                    </c:when>
                                    <c:otherwise>Liên hệ</c:otherwise>
                                </c:choose>
                            </span>
                            <c:if test="${product.originalPrice > 0 && (empty variants || product.originalPrice > variants[0].sellingPrice)}">
                                <span class="pd-price-original"><fmt:formatNumber value="${product.originalPrice}" pattern="#,##0"/>₫</span>
                                <span class="pd-price-discount">-${product.discountPercent}%</span>
                            </c:if>
                        </div>
                        <c:if test="${product.originalPrice > 0 && not empty variants && product.originalPrice > variants[0].sellingPrice}">
                            <div class="pd-savings">Tiết kiệm: <fmt:formatNumber value="${product.originalPrice - variants[0].sellingPrice}" pattern="#,##0"/>₫</div>
                        </c:if>
                    </div>

                    <!-- Spec summary grid -->
                    <div class="pd-specs-grid">
                        <c:choose>
                            <c:when test="${product.categoryId == 1}">
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-microchip"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Vi xử lý</span>
                                        <span class="pd-spec-value" title="${product.cpu}">${empty product.cpu ? 'i9-14900HX' : product.cpu}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-gamepad"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Đồ họa</span>
                                        <span class="pd-spec-value" title="${product.gpu}">${empty product.gpu ? 'RTX 4090 16GB' : product.gpu}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-desktop"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Màn hình</span>
                                        <span class="pd-spec-value" title="${product.screen}">${empty product.screen ? '18" QHD+ Nebula' : product.screen}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-sync"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Tần số quét</span>
                                        <span class="pd-spec-value">240Hz / 3ms</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-wifi"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Kết nối</span>
                                        <span class="pd-spec-value">${empty product.connectivity ? 'Có dây / Không dây' : product.connectivity}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-cogs"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Đặc tả</span>
                                        <span class="pd-spec-value">${empty product.dpi ? (empty product.switchType ? 'Premium design' : product.switchType) : product.dpi}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-tag"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Thương hiệu</span>
                                        <span class="pd-spec-value">${product.brandName}</span>
                                    </div>
                                </div>
                                <div class="pd-spec-card">
                                    <div class="pd-spec-icon"><i class="fas fa-shield-alt"></i></div>
                                    <div class="pd-spec-info">
                                        <span class="pd-spec-label">Bảo hành</span>
                                        <span class="pd-spec-value">${product.warrantyPeriod} Tháng</span>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Product variants selection -->
                    <c:if test="${not empty variants}">
                        <div class="pd-option-group">
                            <div class="pd-option-label">Chọn cấu hình:</div>
                            <div class="pd-option-buttons">
                                <c:forEach items="${variants}" var="v" varStatus="st">
                                    <button type="button"
                                            class="pd-option-btn pd-variant-btn ${st.first ? 'active' : ''}"
                                            data-variant-id="${v.variantId}"
                                            data-price="<fmt:formatNumber value='${v.sellingPrice}' pattern='#,##0'/>₫"
                                            data-stock="${v.availableQuantity}"
                                            ${v.availableQuantity == 0 ? 'disabled' : ''}>
                                        ${v.variantName}
                                    </button>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Stock availability -->
                    <div id="pdStock" class="pd-stock ${variants[0].availableQuantity > 0 ? 'in-stock' : 'out-of-stock'}">
                        <c:choose>
                            <c:when test="${variants[0].availableQuantity > 0}">
                                <i class="fas fa-check-circle"></i> Còn hàng (${variants[0].availableQuantity})
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-times-circle"></i> Hết hàng
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Purchase quantity and action buttons -->
                    <div class="pd-actions">
                        <div class="pd-qty">
                            <button type="button" id="qtyMinus" ${variants[0].availableQuantity == 0 ? 'disabled' : ''}>−</button>
                            <input type="text" id="qtyInput" value="1" readonly>
                            <button type="button" id="qtyPlus" ${variants[0].availableQuantity == 0 ? 'disabled' : ''}>+</button>
                        </div>
                        <form id="addCartForm" method="post" action="${pageContext.request.contextPath}/CartServlet">
                            <input type="hidden" name="action" id="cartAction" value="add">
                            <input type="hidden" name="variantId" id="selectedVariantId" value="${variants[0].variantId}">
                            <input type="hidden" name="quantity" id="formQty" value="1">
                            <button type="submit" class="pd-add-cart" ${variants[0].availableQuantity == 0 ? 'disabled' : ''}><i class="fas fa-shopping-cart"></i> Giỏ hàng</button>
                        </form>
                        <button type="button" id="btnBuyNow" class="pd-btn-buy" ${variants[0].availableQuantity == 0 ? 'disabled' : ''}>
                            Mua ngay
                        </button>
                    </div>

                    <!-- Trust signals row -->
                    <div class="pd-trust-row">
                        <div class="pd-trust-item">
                            <i class="fas fa-shipping-fast"></i>
                            <span>Miễn phí giao hàng</span>
                        </div>
                        <div class="pd-trust-item">
                            <i class="fas fa-shield-alt"></i>
                            <span>Bảo hành ${product.warrantyPeriod} tháng</span>
                        </div>
                        <div class="pd-trust-item">
                            <i class="fas fa-check-double"></i>
                            <span>100% Chính hãng</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab Description Section -->
            <div class="pd-tabs">
                <div class="pd-tabs-nav">
                    <button type="button" class="pd-tab-trigger active" data-target="tab-desc">Mô tả</button>
                    <c:if test="${product.categoryId == 1 || not empty product.connectivity}">
                        <button type="button" class="pd-tab-trigger" data-target="tab-specs">Thông số kỹ thuật</button>
                    </c:if>
                    <button type="button" class="pd-tab-trigger" data-target="tab-reviews">Đánh giá</button>
                </div>

                <!-- Tab 1: Description -->
                <div id="tab-desc" class="pd-tab-content active">
                    <div class="pd-desc-layout">
                        <div class="pd-desc-text">
                            <h2>Hiệu năng tối thượng cho nhà vô địch</h2>
                            <p>${product.description}</p>
                            <div class="pd-desc-points">
                                <div class="pd-desc-point">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Hệ thống tản nhiệt thông minh tối ưu hóa năng suất</span>
                                </div>
                                <div class="pd-desc-point">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Màn hình chất lượng cao mang lại độ tương phản tuyệt vời</span>
                                </div>
                                <div class="pd-desc-point">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Thiết kế hiện đại, bền bỉ và đậm chất gaming</span>
                                </div>
                            </div>
                        </div>
                        <div class="pd-desc-img-wrap">
                            <img src="https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=600&auto=format&fit=crop" alt="Premium Hardware block representation">
                        </div>
                    </div>
                </div>

                <!-- Tab 2: Specifications -->
                <c:if test="${product.categoryId == 1 || not empty product.connectivity}">
                    <div id="tab-specs" class="pd-tab-content">
                        <table class="pd-spec-table">
                            <c:choose>
                                <c:when test="${product.categoryId == 1}">
                                    <c:if test="${not empty product.cpu}"><tr><td>CPU (Bộ vi xử lý)</td><td>${product.cpu}</td></tr></c:if>
                                    <c:if test="${not empty product.ram}"><tr><td>RAM (Bộ nhớ trong)</td><td>${product.ram}</td></tr></c:if>
                                    <c:if test="${not empty product.ssd}"><tr><td>Ổ cứng (Lưu trữ)</td><td>${product.ssd}</td></tr></c:if>
                                    <c:if test="${not empty product.gpu}"><tr><td>GPU (Đồ họa)</td><td>${product.gpu}</td></tr></c:if>
                                    <c:if test="${not empty product.screen}"><tr><td>Màn hình hiển thị</td><td>${product.screen}</td></tr></c:if>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${not empty product.connectivity}"><tr><td>Kiểu kết nối</td><td>${product.connectivity}</td></tr></c:if>
                                    <c:if test="${not empty product.switchType}"><tr><td>Loại Switch</td><td>${product.switchType}</td></tr></c:if>
                                    <c:if test="${not empty product.dpi}"><tr><td>Độ phân giải DPI</td><td>${product.dpi}</td></tr></c:if>
                                </c:otherwise>
                            </c:choose>
                            <tr><td>Thương hiệu</td><td>${product.brandName}</td></tr>
                            <tr><td>Thời hạn bảo hành</td><td>${product.warrantyPeriod} Tháng</td></tr>
                        </table>
                    </div>
                </c:if>

                <!-- Tab 3: Reviews -->
                <div id="tab-reviews" class="pd-tab-content">
                    <div style="padding: 20px 0; display: flex; flex-direction: column; gap: 20px;">
                        
                        <!-- Form gửi bình luận/đánh giá -->
                        <c:if test="${not empty sessionScope.user}">
                            <div style="background-color: #f8fafc; border-radius: 12px; padding: 24px; border: 1px solid #e2e8f0; margin-bottom: 10px;">
                                <h3 style="font-size: 16px; font-weight: 600; margin-top: 0; margin-bottom: 16px; color: #0f172a;">Viết đánh giá của bạn</h3>
                                <form action="${pageContext.request.contextPath}/ProductDetailServlet" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    
                                    <div style="margin-bottom: 16px;">
                                        <label style="display: block; font-size: 14px; font-weight: 500; margin-bottom: 8px; color: #334155;">Chọn đánh giá của bạn:</label>
                                        <div class="rating-stars-input" style="display: flex; gap: 8px; font-size: 24px; color: #cbd5e1; cursor: pointer;">
                                            <i class="fas fa-star star-btn" data-value="1" style="color: #f59e0b;"></i>
                                            <i class="fas fa-star star-btn" data-value="2" style="color: #f59e0b;"></i>
                                            <i class="fas fa-star star-btn" data-value="3" style="color: #f59e0b;"></i>
                                            <i class="fas fa-star star-btn" data-value="4" style="color: #f59e0b;"></i>
                                            <i class="fas fa-star star-btn" data-value="5" style="color: #f59e0b;"></i>
                                        </div>
                                        <input type="hidden" name="rating" id="reviewRatingInput" value="5" required>
                                    </div>

                                    <div style="margin-bottom: 16px;">
                                        <label for="reviewComment" style="display: block; font-size: 14px; font-weight: 500; margin-bottom: 8px; color: #334155;">Nhận xét:</label>
                                        <textarea id="reviewComment" name="comment" rows="4" placeholder="Hãy chia sẻ cảm nhận của bạn về sản phẩm này..." style="width: 100%; border: 1px solid #cbd5e1; border-radius: 8px; padding: 12px; font-family: inherit; font-size: 14px; resize: vertical; box-sizing: border-box; outline: none; transition: border-color 0.2s;" required></textarea>
                                    </div>

                                    <button type="submit" style="background-color: var(--primary); color: #fff; border: none; border-radius: 8px; padding: 10px 20px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background-color 0.2s;">
                                        Gửi đánh giá
                                    </button>
                                </form>
                            </div>
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    const stars = document.querySelectorAll('.star-btn');
                                    const ratingInput = document.getElementById('reviewRatingInput');
                                    
                                    stars.forEach(star => {
                                        star.addEventListener('click', function() {
                                            const value = parseInt(this.getAttribute('data-value'));
                                            ratingInput.value = value;
                                            
                                            // Highlight selected stars
                                            stars.forEach((s, idx) => {
                                                if (idx < value) {
                                                    s.classList.remove('far');
                                                    s.classList.add('fas');
                                                    s.style.color = '#f59e0b';
                                                } else {
                                                    s.classList.remove('fas');
                                                    s.classList.add('far');
                                                    s.style.color = '#cbd5e1';
                                                }
                                            });
                                        });
                                        
                                        // Hover effect
                                        star.addEventListener('mouseover', function() {
                                            const value = parseInt(this.getAttribute('data-value'));
                                            stars.forEach((s, idx) => {
                                                if (idx < value) {
                                                    s.style.color = '#f59e0b';
                                                } else {
                                                    s.style.color = '#cbd5e1';
                                                }
                                            });
                                        });
                                    });
                                    
                                    // Reset to selected value when mouse leaves the container
                                    const starContainer = document.querySelector('.rating-stars-input');
                                    if (starContainer) {
                                        starContainer.addEventListener('mouseleave', function() {
                                            const value = parseInt(ratingInput.value);
                                            stars.forEach((s, idx) => {
                                                if (idx < value) {
                                                    s.classList.remove('far');
                                                    s.classList.add('fas');
                                                    s.style.color = '#f59e0b';
                                                } else {
                                                    s.classList.remove('fas');
                                                    s.classList.add('far');
                                                    s.style.color = '#cbd5e1';
                                                }
                                            });
                                        });
                                    }
                                });
                            </script>
                        </c:if>

                        <!-- Danh sách đánh giá -->
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="r" items="${reviews}">
                                    <div style="display: flex; gap: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 16px;">
                                        <div style="width: 44px; height: 44px; background-color: var(--secondary); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--secondary-text); font-weight: 600; text-transform: uppercase;">
                                            ${fn:substring(r.userFullName, 0, 2)}
                                        </div>
                                        <div>
                                            <div style="font-weight: 600; font-size: 15px; margin-bottom: 4px;">${r.userFullName}</div>
                                            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 6px;">
                                                <div style="display: flex; gap: 4px; color: #f59e0b; font-size: 12px;">
                                                    <c:forEach var="star" begin="1" end="${r.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:forEach>
                                                    <c:forEach var="star" begin="${r.rating + 1}" end="5">
                                                        <i class="far fa-star" style="color: #cbd5e1;"></i>
                                                    </c:forEach>
                                                </div>
                                                <span style="color: #64748b; font-size: 12px; font-weight: 400;">
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                            <p style="color: var(--text-muted); font-size: 14px; margin: 0; white-space: pre-line;">${r.comment}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                                    <i class="far fa-comments" style="font-size: 48px; margin-bottom: 12px; color: #cbd5e1; display: block;"></i>
                                    Chưa có đánh giá nào cho sản phẩm này. Hãy là người đầu tiên đánh giá!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Similar Products Section -->
            <c:if test="${not empty similarProducts}">
                <div class="similar-section">
                    <div class="similar-header">
                        <div>
                            <h2>Sản phẩm tương tự</h2>
                            <p>Dành riêng cho những game thủ đích thực.</p>
                        </div>
                        <a href="ProductListServlet?category=${product.categoryId}" style="color: var(--primary); font-weight: 600; font-size: 14px;">Xem tất cả <i class="fas fa-arrow-right" style="font-size: 11px;"></i></a>
                    </div>
                    <div class="similar-grid">
                        <c:forEach items="${similarProducts}" var="sp">
                            <!-- Product Card -->
                            <div class="product-card" style="flex: none; width: auto;">
                                <c:if test="${sp.discountPercent > 0}">
                                    <div class="product-badge discount">-${sp.discountPercent}%</div>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${sp.productId}" class="product-card-link">
                                    <div class="product-img-wrapper">
                                        <img src="${pageContext.request.contextPath}/images/${sp.thumbnail}" alt="${sp.productName}">
                                    </div>
                                    <div class="product-info">
                                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600; margin-bottom: 4px;">${sp.brandName}</div>
                                        <h3 style="font-size: 14px; font-weight: 600; line-height: 1.4; margin-bottom: 12px; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">${sp.productName}</h3>
                                    </div>
                                </a>
                                <div class="product-price" style="margin-top: auto;">
                                    <span class="current-price" style="font-size: 15px; font-weight: 700; color: var(--primary);"><fmt:formatNumber value="${sp.minPrice}" pattern="#,##0"/>₫</span>
                                </div>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${sp.productId}" class="btn-add-cart" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;"><i class="fas fa-shopping-cart" style="margin-right: 5px;"></i> Giỏ hàng</a>
                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${sp.productId}" class="btn-buy-now" style="text-align: center; display: inline-flex; align-items: center; justify-content: center;">Mua ngay</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Footer -->
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
                        <p><i class="fas fa-map-marker-alt"></i> Mỹ Đình,Hà Nội</p>
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

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/product_detail.js?v=2" defer></script>
    </body>
=======
<%-- 
    Document   : product_detail
    Created on : 14 thg 6, 2026, 17:36:50
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.productName} - UniLap</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    <c:if test="${not empty errorMessage}">
        <p style="color:red">${errorMessage}</p>
        <a href="${pageContext.request.contextPath}/HomeServlet">← Về trang chủ</a>
    </c:if>

    <c:if test="${not empty product}">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
            &rsaquo; ${product.categoryName}
            &rsaquo; <span>${product.productName}</span>
        </nav>

        <div class="product-detail">
            <!-- Cột ảnh -->
            <div class="pd-images">
                <img src="${pageContext.request.contextPath}/images/${product.thumbnail}"
                     alt="${product.productName}" class="pd-main-img">
            </div>

            <!-- Cột thông tin -->
            <div class="pd-info">
                <h1>${product.productName}</h1>
                <p class="pd-brand">Thương hiệu: <strong>${product.brandName}</strong></p>

                <!-- Danh sách biến thể -->
                <h3>Phiên bản</h3>
                <c:choose>
                    <c:when test="${empty variants}">
                        <p>Sản phẩm chưa có phiên bản.</p>
                    </c:when>
                    <c:otherwise>
                        <ul class="pd-variants">
                            <c:forEach var="v" items="${variants}">
                                <li>
                                    ${v.variantName}
                                    — <fmt:formatNumber value="${v.sellingPrice}" type="number"/>đ
                                    <c:choose>
                                        <c:when test="${v.availableQuantity > 0}">(Còn hàng)</c:when>
                                        <c:otherwise>(Hết hàng)</c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>

                <button class="btn-add-cart">Thêm vào giỏ hàng</button>
                <button class="btn-buy-now">Mua ngay</button>
            </div>
        </div>

        <!-- Mô tả -->
        <section class="pd-description">
            <h2>Mô tả sản phẩm</h2>
            <p>${product.description}</p>
        </section>
    </c:if>
</body>
>>>>>>> Stashed changes
</html>
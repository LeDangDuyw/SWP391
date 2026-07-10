<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    if (request.getAttribute("categories") == null) {
        try {
            dal.CategoryDAO catDAO = new dal.CategoryDAO();
            java.util.ArrayList<model.Category> categoriesList = catDAO.getAllCategories();
            request.setAttribute("categories", categoriesList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - UniLap</title>
    <meta name="description" content="Xem và quản lý giỏ hàng của bạn tại UniLap.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=5">
</head>
<body>

<!-- ===== HEADER ===== -->
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

            <a href="#">Khuyến mãi</a>
        </nav>
        <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
            <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
            </form>
            <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-badge" id="header-cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; ${empty sessionScope.cart || fn:length(sessionScope.cart) == 0 ? 'display: none;' : 'display: flex;'} align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
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
                    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- ===== MAIN ===== -->
<main class="cart-main">
    <div class="container">
        <div class="cart-heading-block">
            <h1 class="cart-heading">Giỏ hàng của bạn</h1>
            <p class="cart-subheading" id="cart-desc" style="${empty cart ? 'display: none;' : ''}">Bạn đang có <strong id="cart-item-count">${fn:length(cart)}</strong> sản phẩm trong giỏ hàng</p>
            <p class="cart-subheading" id="cart-empty-desc" style="${not empty cart ? 'display: none;' : ''}">Giỏ hàng đang trống.</p>
        </div>

        <!-- EMPTY STATE BLOCK -->
        <div id="cart-empty-block" class="cart-empty" style="${empty cart ? '' : 'display: none;'}">
            <div class="cart-empty-icon"><i class="fas fa-cart-shopping"></i></div>
            <p class="cart-empty-msg">Chưa có sản phẩm nào trong giỏ hàng.</p>
            <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-continue-shop">
                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
            </a>
        </div>

        <!-- TWO-COLUMN CONTENT BLOCK -->
        <div id="cart-content-block" class="cart-layout" style="${empty cart ? 'display: none;' : ''}">
            <!-- LEFT: Cart items -->
            <div class="cart-items-col" id="cart-items-container">
                <c:forEach items="${cart}" var="item">
                    <div class="cart-card" data-variant-id="${item.variantId}">
                        <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${item.productId}" class="cart-card-img-link">
                            <img class="cart-card-img"
                                 src="${pageContext.request.contextPath}/images/${item.thumbnail}"
                                 onerror="this.src='https://placehold.co/130x100/f1f5f9/94a3b8?text=UniLap'"
                                 alt="${item.productName}">
                        </a>
                        <div class="cart-card-body">
                            <div class="cart-card-top">
                                <div class="cart-card-info">
                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${item.productId}" class="cart-card-name">${item.productName}</a>
                                    <p class="cart-card-spec">${item.variantName}</p>
                                    <div class="cart-card-badges">
                                        <c:if test="${item.availableQuantity > 0}">
                                            <span class="badge badge-stock">Còn hàng</span>
                                        </c:if>
                                        <span class="badge badge-warranty">
                                            Bảo hành ${item.warrantyPeriod} tháng
                                        </span>
                                    </div>
                                </div>
                                <!-- Delete button -->
                                <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="remove-item-form">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="variantId" value="${item.variantId}">
                                    <button type="submit" class="btn-delete" title="Xóa sản phẩm">
                                        <i class="fas fa-trash-can"></i>
                                    </button>
                                </form>
                            </div>

                            <div class="cart-card-bottom">
                                <!-- Quantity -->
                                <form method="post" action="${pageContext.request.contextPath}/CartServlet" class="qty-form" data-variant-id="${item.variantId}">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="variantId" value="${item.variantId}">
                                    <button type="button" class="qty-btn btn-qty-minus" data-variant-id="${item.variantId}" ${item.quantity <= 1 ? 'disabled' : ''}>−</button>
                                    <span class="qty-value" data-variant-id="${item.variantId}">${item.quantity}</span>
                                    <button type="button" class="qty-btn btn-qty-plus" data-variant-id="${item.variantId}" ${item.quantity >= item.availableQuantity ? 'disabled' : ''}>+</button>
                                </form>
                                <!-- Price -->
                                <div class="cart-card-price-block">
                                    <span class="cart-card-price" data-variant-id="${item.variantId}"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Continue shopping link -->
                <a href="${pageContext.request.contextPath}/HomeServlet" class="link-continue">
                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                </a>
            </div>

            <!-- RIGHT: Order summary -->
            <div class="cart-summary-col">
                <div class="summary-box">
                    <h2 class="summary-title">Tóm tắt đơn hàng</h2>

                    <div class="summary-row">
                        <span>Tạm tính (<span id="summary-items-count">${fn:length(cart)}</span> sản phẩm)</span>
                        <span id="summary-subtotal"><fmt:formatNumber value="${total}" pattern="#,##0"/>₫</span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển</span>
                        <span class="free-ship">Miễn phí</span>
                    </div>
                    <div class="summary-row" id="discount-row" style="${empty discountAmount || discountAmount == 0 ? 'display: none;' : ''}">
                        <span>Giảm giá mã khuyến mãi</span>
                        <span class="discount-val" id="summary-discount">- <fmt:formatNumber value="${discountAmount}" pattern="#,##0"/>₫</span>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-total-row">
                        <span>Tổng cộng</span>
                        <span class="summary-total-price" id="summary-total">
                            <fmt:formatNumber value="${finalTotal}" pattern="#,##0"/>₫
                        </span>
                    </div>
                    <p class="summary-vat">(Đã bao gồm VAT nếu có)</p>

                    <!-- Coupon input -->
                    <div class="coupon-form-container" style="margin-bottom: 16px;">
                        <div class="coupon-form">
                            <input type="text" id="coupon-input" placeholder="Nhập mã giảm giá..."
                                   class="coupon-input" value="${couponCode}">
                            <button type="button" class="coupon-btn" id="btn-apply-coupon">Áp dụng</button>
                        </div>
                        <div id="coupon-msg" class="coupon-message" style="font-size: 13px; margin-top: 6px; font-weight: 500; display: none;"></div>
                    </div>

                    <!-- Checkout button -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/CheckoutServlet" class="btn-checkout" id="btn-checkout">
                                Tiến hành đặt hàng <i class="fas fa-shopping-cart"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);" onclick="alert('Bạn cần đăng nhập để tiến hành đặt hàng!'); window.location.href='${pageContext.request.contextPath}/login';" class="btn-checkout" id="btn-checkout">
                                Tiến hành đặt hàng <i class="fas fa-shopping-cart"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <!-- Trust badges -->
                    <div class="trust-badges">
                        <div class="trust-item">
                            <i class="fas fa-shield-halved"></i>
                            <span>Thanh toán an toàn &amp; bảo mật 100%</span>
                        </div>
                        <div class="trust-item">
                            <i class="fas fa-truck-fast"></i>
                            <span>Giao hàng nhanh toàn quốc (1-3 ngày)</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- ===== FOOTER ===== -->
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

<script>
    // User dropdown toggle
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
            document.querySelectorAll('.user-menu-dropdown-content').forEach(function (d) {
                d.style.display = 'none';
            });
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/cart.js?v=2" defer></script>
<jsp:include page="chatbot.jsp" />
</body>
</html>

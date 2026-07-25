<%-- 
 * Name: cart.jsp
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Giao diện giỏ hàng của người dùng (Shopping Cart)
 --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=10">
    <style>
    /* CSS Inline để chống cache trình duyệt cho tính năng Khuyến mãi và ưu đãi */
    .promotions-trigger-box {
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        padding: 14px 16px !important;
        background: #f8fafc !important;
        border: 1px solid #e2e8f0 !important;
        border-radius: 12px !important;
        cursor: pointer !important;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1) !important;
        margin-bottom: 18px !important;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02) !important;
        width: 100% !important;
        box-sizing: border-box !important;
    }
    .promotions-trigger-box:hover {
        border-color: #cbd5e1 !important;
        background: #f1f5f9 !important;
        transform: translateY(-1px) !important;
    }
    .promotions-trigger-left {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
    }
    .promotions-trigger-title {
        font-size: 13.5px !important;
        font-weight: 600 !important;
        color: #1e293b !important;
    }
    .promo-modal {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        height: 100% !important;
        z-index: 9999 !important;
        display: none !important;
        align-items: center !important;
        justify-content: flex-end !important;
    }
    .promo-modal.open {
        display: flex !important;
    }
    .promo-modal-overlay {
        position: absolute !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        height: 100% !important;
        background: rgba(15, 23, 42, 0.5) !important;
        backdrop-filter: blur(4px) !important;
        transition: opacity 0.3s ease !important;
    }
    .promo-modal-content {
        position: relative !important;
        width: 480px !important;
        max-width: 100% !important;
        height: 100% !important;
        background: #ffffff !important;
        box-shadow: -4px 0 24px rgba(15, 23, 42, 0.15) !important;
        display: flex !important;
        flex-direction: column !important;
        transform: translateX(100%) !important;
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
        z-index: 10001 !important;
    }
    .promo-modal.open .promo-modal-content {
        transform: translateX(0) !important;
    }
    .promo-modal-header {
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        padding: 16px 20px !important;
        border-bottom: 1px solid #f1f5f9 !important;
    }
    .promo-modal-title {
        font-size: 16px !important;
        font-weight: 700 !important;
        color: #0f172a !important;
        margin: 0 !important;
    }
    .promo-close-btn {
        background: none !important;
        border: none !important;
        font-size: 28px !important;
        font-weight: 300 !important;
        color: #94a3b8 !important;
        cursor: pointer !important;
        line-height: 1 !important;
        padding: 0 !important;
        transition: color 0.2s !important;
    }
    .promo-close-btn:hover {
        color: #475569 !important;
    }
    .promo-modal-body {
        flex: 1 !important;
        overflow-y: auto !important;
        padding: 20px !important;
        display: flex !important;
        flex-direction: column !important;
        gap: 20px !important;
    }
    .promo-section-title {
        font-size: 13.5px !important;
        font-weight: 700 !important;
        color: #0f172a !important;
        margin-bottom: 10px !important;
    }
    .promo-input-wrapper {
        position: relative !important;
        display: flex !important;
        gap: 8px !important;
    }
    .promo-input-icon {
        position: absolute !important;
        left: 14px !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        color: #94a3b8 !important;
        font-size: 14px !important;
    }
    .promo-input-wrapper input {
        flex: 1 !important;
        padding: 11px 12px 11px 40px !important;
        border: 1px solid #cbd5e1 !important;
        border-radius: 8px !important;
        font-size: 13.5px !important;
        color: #0f172a !important;
        transition: all 0.2s !important;
    }
    .promo-input-wrapper input:focus {
        outline: none !important;
        border-color: #2563eb !important;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15) !important;
    }
    .promo-apply-btn {
        background: #2563eb !important;
        color: #ffffff !important;
        border: none !important;
        padding: 0 16px !important;
        border-radius: 8px !important;
        font-weight: 600 !important;
        font-size: 13px !important;
        cursor: pointer !important;
        transition: all 0.2s !important;
    }
    .promo-apply-btn:hover {
        background: #1d4ed8 !important;
    }
    .btn-use-voucher-indicator:hover i {
        color: #ef4444 !important;
    }

    /* ── VOUCHER CARD STYLES (inline to avoid cache) ── */
    .vouchers-list {
        display: flex !important;
        flex-direction: column !important;
        gap: 0 !important;
        max-height: 340px !important;
        overflow-y: auto !important;
        padding-right: 4px !important;
    }
    .voucher-item {
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        border: 1px solid #e2e8f0 !important;
        border-radius: 10px !important;
        background: #ffffff !important;
        padding: 14px 16px !important;
        position: relative !important;
        transition: all 0.2s ease !important;
        cursor: pointer !important;
        margin-bottom: 12px !important;
        box-shadow: 0 1px 3px rgba(0,0,0,0.04) !important;
    }
    .voucher-item:hover {
        border-color: #cbd5e1 !important;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06) !important;
    }
    .voucher-item.active {
        border: 1.5px dashed #3b82f6 !important;
        background: #eff6ff !important;
        box-shadow: 0 2px 10px rgba(59,130,246,0.1) !important;
    }
    .voucher-item.unavailable,
    .voucher-item.disabled,
    .voucher-item.used {
        background: #ffffff !important;
        border: 1px solid #f1f5f9 !important;
        opacity: 0.5 !important;
        cursor: not-allowed !important;
        pointer-events: none !important;
        box-shadow: none !important;
    }
    .voucher-left {
        flex: 1 !important;
        display: flex !important;
        flex-direction: column !important;
        justify-content: center !important;
        border-right: none !important;
        padding-right: 10px !important;
    }
    .voucher-left .v-code {
        font-weight: 700 !important;
        font-size: 14px !important;
        color: #0f172a !important;
        letter-spacing: 0.3px !important;
    }
    .voucher-item.active .voucher-left .v-code {
        color: #1d4ed8 !important;
    }
    .voucher-item.unavailable .voucher-left .v-code,
    .voucher-item.used .voucher-left .v-code {
        color: #94a3b8 !important;
    }
    .voucher-left .v-discount {
        font-size: 13px !important;
        color: #16a34a !important;
        font-weight: 700 !important;
        margin-top: 3px !important;
    }
    .voucher-item.active .voucher-left .v-discount {
        color: #2563eb !important;
    }
    .voucher-item.unavailable .voucher-left .v-discount,
    .voucher-item.used .voucher-left .v-discount {
        color: #94a3b8 !important;
    }
    .voucher-left .v-min {
        font-size: 12px !important;
        color: #64748b !important;
        margin-top: 2px !important;
    }
    .voucher-item.unavailable .voucher-left .v-min,
    .voucher-item.used .voucher-left .v-min {
        color: #94a3b8 !important;
    }
    .voucher-left .v-desc {
        font-size: 11px !important;
        color: #64748b !important;
        margin-top: 3px !important;
        line-height: 1.4 !important;
    }
    .voucher-item.unavailable .voucher-left .v-desc,
    .voucher-item.used .voucher-left .v-desc {
        color: #94a3b8 !important;
    }
    .voucher-left .v-status-msg {
        font-size: 11.5px !important;
        margin-top: 5px !important;
        font-weight: 600 !important;
        color: #16a34a !important;
    }
    .voucher-item.unavailable .voucher-left .v-status-msg,
    .voucher-item.used .voucher-left .v-status-msg {
        color: #ef4444 !important;
    }
    .voucher-right {
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        padding-left: 10px !important;
        min-width: 36px !important;
        flex-shrink: 0 !important;
    }

    .promo-modal-footer {
        padding: 16px 20px !important;
        border-top: 1px solid #f1f5f9 !important;
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
        background: #ffffff !important;
    }
    .promo-footer-left {
        display: flex !important;
        flex-direction: column !important;
        gap: 4px !important;
    }
    .promo-footer-selected-text {
        font-size: 11px !important;
        font-weight: 500 !important;
        color: #64748b !important;
    }
    .promo-footer-total {
        display: flex !important;
        align-items: center !important;
        gap: 6px !important;
    }
    .promo-total-label {
        font-size: 13px !important;
        color: #475569 !important;
    }
    .promo-total-val {
        font-size: 16px !important;
        font-weight: 700 !important;
        color: #ef4444 !important;
    }
    .promo-confirm-btn {
        background: #ef4444 !important;
        color: #ffffff !important;
        border: none !important;
        padding: 12px 36px !important;
        border-radius: 8px !important;
        font-weight: 700 !important;
        font-size: 14.5px !important;
        cursor: pointer !important;
        transition: all 0.2s !important;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.15) !important;
    }
    .promo-confirm-btn:hover {
        background: #dc2626 !important;
        transform: translateY(-1px) !important;
    }
    </style>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var trigger = document.getElementById('btn-open-promotions-modal');
        var modal = document.getElementById('promotions-modal');
        var closeBtn = document.getElementById('btn-close-promotions-modal');
        var confirmBtn = document.getElementById('btn-confirm-promotions');
        var overlay = document.querySelector('.promo-modal-overlay');

        if (trigger && modal) {
            trigger.addEventListener('click', function(e) {
                e.preventDefault();
                modal.classList.add('open');
            });
        }

        function closeModal() {
            if (modal) {
                modal.classList.remove('open');
            }
        }

        if (closeBtn) closeBtn.addEventListener('click', closeModal);
        if (confirmBtn) confirmBtn.addEventListener('click', closeModal);
        if (overlay) overlay.addEventListener('click', closeModal);

        // Logic chọn và áp dụng Voucher
        const vouchersListEl = document.getElementById('vouchers-list');
        const contextPath = '${pageContext.request.contextPath}';

        function applyCoupon(code) {
            const formData = new URLSearchParams();
            formData.append('action', 'coupon');
            formData.append('couponCode', code);
            formData.append('ajax', 'true');

            fetch(contextPath + '/CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                // Tải lại trang để JSP tự động render lại toàn bộ giỏ hàng và modal với coupon mới
                window.location.reload();
            })
            .catch(err => {
                console.error("Error applying coupon:", err);
                window.location.reload();
            });
        }

        if (vouchersListEl) {
            vouchersListEl.addEventListener('click', function (e) {
                const btn = e.target.closest('.btn-use-voucher-indicator');
                const activeIndicator = e.target.closest('.promo-select-indicator');
                const item = e.target.closest('.voucher-item');
                
                if (btn) {
                    e.preventDefault();
                    e.stopPropagation();
                    const code = btn.dataset.code;
                    applyCoupon(code);
                } else if (activeIndicator) {
                    e.preventDefault();
                    e.stopPropagation();
                    applyCoupon(""); // Bỏ chọn
                } else if (item) {
                    if (item.classList.contains('active')) {
                        e.preventDefault();
                        e.stopPropagation();
                        applyCoupon(""); // Bỏ chọn khi click vào voucher đang hoạt động
                    } else if (!item.classList.contains('used') && !item.classList.contains('unavailable')) {
                        e.preventDefault();
                        e.stopPropagation();
                        const code = item.dataset.code;
                        applyCoupon(code);
                    }
                }
            });
        }

        // Bấm nút "Áp dụng" khi gõ tay mã giảm giá
        const btnApplyCoupon = document.getElementById('btn-modal-apply-coupon');
        const couponInput = document.getElementById('modal-coupon-input');
        if (btnApplyCoupon && couponInput) {
            btnApplyCoupon.addEventListener('click', function(e) {
                e.preventDefault();
                const code = couponInput.value.trim();
                if (code) {
                    applyCoupon(code);
                }
            });
            couponInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const code = couponInput.value.trim();
                    if (code) {
                        applyCoupon(code);
                    }
                }
            });
        }

        // Tự động mở lại modal và hiển thị thông báo phản hồi từ Server sau khi trang reload
        <c:if test="${not empty requestScope.couponMessage}">
            if (modal) {
                modal.classList.add('open');
                var msgEl = document.getElementById('modal-coupon-msg');
                if (msgEl) {
                    msgEl.textContent = "${requestScope.couponMessage}";
                    msgEl.className = "coupon-message " + (${requestScope.couponSuccess} ? "success" : "error");
                    msgEl.style.display = 'block';
                }
            }
        </c:if>
    });
    </script>
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

            <a href="${pageContext.request.contextPath}/news">Tin tức & Khuyến mãi</a>
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
            <a href="${pageContext.request.contextPath}/profile" title="Thông báo &amp; Tài khoản"><i class="fas fa-bell"></i></a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                        <a href="javascript:void(0);" class="user-menu-trigger" style="display: flex; align-items: center; gap: 5px; text-decoration: none; color: inherit;">
                            <i class="fas fa-user"></i>
                            <span style="font-size: 13px; font-weight: 500; max-width: 90px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${sessionScope.user.userName}</span>
                        </a>
                        <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 150px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
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
                                <div class="cart-card-price-block" style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                    <span class="cart-card-price" data-variant-id="${item.variantId}" style="font-weight: 700; color: #ef4444;"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</span>
                                    <c:if test="${not empty item.originalPrice && item.unitPrice < item.originalPrice}">
                                        <span class="cart-card-original-price" data-variant-id="${item.variantId}" data-original-unit-price="${item.originalPrice}" style="text-decoration: line-through; color: #94a3b8; font-size: 13px;">
                                            <fmt:formatNumber value="${item.originalPrice * item.quantity}" pattern="#,##0"/>₫
                                        </span>
                                    </c:if>
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

                    <!-- Hộp bấm mở Modal Khuyến mãi và ưu đãi -->
                    <div class="promotions-trigger-box" id="btn-open-promotions-modal">
                        <div class="promotions-trigger-left">
                            <i class="fas fa-percent" style="color: #ef4444; font-size: 14px;"></i>
                            <span class="promotions-trigger-title" id="summary-promo-selected-title">
                                ${not empty couponCode ? 'Đã chọn 1 khuyến mãi và ưu đãi' : 'Chọn khuyến mãi và ưu đãi'}
                            </span>
                        </div>
                        <i class="fas fa-chevron-right" style="color: #94a3b8; font-size: 12px;"></i>
                    </div>


                    <!-- Checkout button -->
                    <a href="${pageContext.request.contextPath}/CheckoutServlet" class="btn-checkout" id="btn-checkout">
                        Tiến hành đặt hàng <i class="fas fa-shopping-cart"></i>
                    </a>

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
<%@include file="_footer.jspf" %>

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
<!-- Modal Khuyến mãi và ưu đãi (Drawer từ bên phải trượt ra) -->
<div class="promo-modal" id="promotions-modal">
    <div class="promo-modal-overlay" id="promo-modal-overlay"></div>
    <div class="promo-modal-content">
        <div class="promo-modal-header">
            <h2 class="promo-modal-title">Khuyến mãi và ưu đãi</h2>
            <button type="button" class="promo-close-btn" id="btn-close-promotions-modal">&times;</button>
        </div>
        
        <div class="promo-modal-body">
            <!-- 1. Ô nhập mã giảm giá -->
            <div class="promo-search-section">
                <h3 class="promo-section-title">Mã giảm giá</h3>
                <div class="promo-input-wrapper">
                    <i class="fas fa-ticket-alt promo-input-icon"></i>
                    <input type="text" id="modal-coupon-input" placeholder="Nhập mã giảm giá của bạn tại đây nhé" value="${couponCode}">
                    <button type="button" class="promo-apply-btn" id="btn-modal-apply-coupon">Áp dụng</button>
                </div>
                <div id="modal-coupon-msg" class="coupon-message" style="font-size: 12.5px; margin-top: 10px; font-weight: 600; padding: 10px 14px; border-radius: 8px; background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; display: ${not empty couponCode ? 'block' : 'none'};">
                    <c:choose>
                        <c:when test="${not empty couponCode}">Đã tự động đổi sang mã giảm giá tốt nhất phù hợp!</c:when>
                    </c:choose>
                </div>
            </div>

            <!-- 2. Danh sách khuyến mãi -->
            <div class="promo-list-section">
                <h3 class="promo-section-title">Khuyến mãi</h3>
                
                <c:if test="${empty sessionScope.user}">
                    <div style="background: #eff6ff; border: 1px solid #bfdbfe; color: #1e3a8a; padding: 10px 12px; border-radius: 8px; font-size: 12px; font-weight: 500; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-info-circle" style="color: #3b82f6;"></i>
                        <span>Đăng nhập để nhận thêm ưu đãi cá nhân của bạn nhé!</span>
                    </div>
                </c:if>

                <div class="vouchers-list" id="vouchers-list">
                     <c:forEach items="${userVouchers}" var="v">
                         <c:set var="isAct" value="${v.voucherCode == couponCode}" />
                         <c:set var="isAvail" value="${v.available}" />
                         <div class="voucher-item ${isAvail ? 'available' : 'unavailable'} ${v.used ? 'used' : ''} ${isAct ? 'active' : ''}" 
                              data-code="${v.voucherCode}">
                             <div class="voucher-left">
                                 <div class="v-code">${v.voucherCode}</div>
                                 <div class="v-discount">
                                     Giảm <fmt:formatNumber value="${v.discountValue}" pattern="#,##0"/>${v.discountValue <= 100 ? '%' : '₫'}
                                 </div>
                                 <div class="v-min">Đơn tối thiểu: <fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0"/>₫</div>
                                 <c:if test="${not empty v.description}">
                                     <div class="v-desc">
                                         ${v.description}
                                     </div>
                                 </c:if>
                                 <div class="v-status-msg">
                                     <c:choose>
                                         <c:when test="${isAvail}">Đủ điều kiện áp dụng</c:when>
                                         <c:otherwise>${not empty v.statusMessage ? v.statusMessage : 'Không đủ điều kiện áp dụng'}</c:otherwise>
                                     </c:choose>
                                 </div>
                             </div>
                             <div class="voucher-right">
                                 <c:choose>
                                     <c:when test="${isAct}">
                                         <div class="promo-select-indicator active">
                                             <i class="fas fa-check-circle" style="color: #ef4444; font-size: 22px;"></i>
                                         </div>
                                     </c:when>
                                     <c:when test="${v.used || !isAvail}">
                                         <!-- Không hiển thị nút + -->
                                     </c:when>
                                     <c:otherwise>
                                         <button type="button" class="btn-use-voucher-indicator" data-code="${v.voucherCode}" style="background: none; border: none; cursor: pointer; padding: 0;">
                                             <i class="fas fa-plus-circle" style="color: #94a3b8; font-size: 20px; transition: color 0.2s;"></i>
                                         </button>
                                     </c:otherwise>
                                 </c:choose>
                             </div>
                         </div>
                     </c:forEach>
                    <c:if test="${empty userVouchers}">
                        <p style="font-size: 12.5px; color: #64748b; font-style: italic; text-align: center; margin: 15px 0;">Bạn không sở hữu mã giảm giá nào.</p>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Footer của Modal -->
        <div class="promo-modal-footer">
            <div class="promo-footer-left">
                <span class="promo-footer-selected-text" id="modal-selected-count-text">
                    ${not empty couponCode ? 'Đã chọn 1 khuyến mãi và ưu đãi' : 'Đã chọn 0 khuyến mãi và ưu đãi'}
                </span>
                <div class="promo-footer-total">
                    <span class="promo-total-label">Tổng thanh toán:</span>
                    <strong class="promo-total-val" id="modal-total-value"><fmt:formatNumber value="${finalTotal}" pattern="#,##0"/>₫</strong>
                </div>
            </div>
            <button type="button" class="promo-confirm-btn" id="btn-confirm-promotions">Xác nhận</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/cart.js?v=4" defer></script>
<jsp:include page="chatbot.jsp" />
</body>
</html>

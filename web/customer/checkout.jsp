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
    <title>Thanh toán - UniLap</title>
    <meta name="description" content="Điền thông tin giao hàng và hoàn tất đơn hàng của bạn tại UniLap.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=5">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css?v=1">
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

<!-- ===== MAIN ===== -->
<main class="checkout-main">
    <div class="container">
        <h1 class="cart-heading" style="margin-bottom: 8px;">Thanh toán đơn hàng</h1>
        <p class="cart-subheading" style="margin-bottom: 24px;">Vui lòng kiểm tra lại thông tin và xác nhận đặt hàng.</p>

        <c:if test="${not empty error}">
            <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #ef4444; padding: 15px; border-radius: 8px; font-weight: 500; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-circle-exclamation" style="font-size: 18px;"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/CheckoutServlet" method="POST" id="checkoutForm" class="checkout-layout">
            <!-- LEFT COLUMN: Shipping & Billing -->
            <div class="billing-col">
                <div class="checkout-card" style="margin-bottom: 20px;">
                    <h2 class="card-title"><i class="fas fa-truck-fast"></i> Phương thức nhận hàng</h2>
                    <div class="payment-selector" style="margin-top: 15px;">
                        <div class="payment-option selected" id="ship-home">
                            <input type="radio" name="shippingMethod" value="HOME_DELIVERY" checked id="radio-home">
                            <i class="fas fa-house-chimney"></i>
                            <span class="payment-option-title">Giao hàng tận nhà</span>
                            <span class="payment-option-desc">Giao tận nơi từ 1 - 3 ngày làm việc.</span>
                        </div>
                        <div class="payment-option" id="ship-store">
                            <input type="radio" name="shippingMethod" value="STORE_PICKUP" id="radio-store">
                            <i class="fas fa-store"></i>
                            <span class="payment-option-title">Nhận tại cửa hàng</span>
                            <span class="payment-option-desc">Nhận hàng trực tiếp tại cửa hàng UniLap.</span>
                        </div>
                    </div>
                </div>

                <div class="checkout-card" id="shipping-info-card">
                    <h2 class="card-title"><i class="fas fa-truck"></i> Thông tin giao hàng</h2>
                    
                    <div class="form-group">
                        <label for="fullName">Họ và tên người nhận</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               placeholder="VD: Nguyễn Văn A" required value="${sessionScope.user.userName}">
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-control" 
                               placeholder="VD: 0912345678" required pattern="0[0-9]{9}" maxlength="10"
                               title="Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0" value="${sessionScope.user.phone}">
                    </div>

                    <div class="form-group">
                        <label for="address">Địa chỉ nhận hàng</label>
                        <textarea id="address" name="address" class="form-control" rows="3"
                               placeholder="VD: Số 12, Ngõ 34, Phố Duy Tân, Cầu Giấy, Hà Nội" required maxlength="500"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="notes">Ghi chú đơn hàng (Tùy chọn)</label>
                        <textarea id="notes" name="notes" class="form-control" rows="3"
                                  placeholder="VD: Giao giờ hành chính, gọi trước khi giao..." maxlength="500"></textarea>
                    </div>
                </div>

                <div class="checkout-card">
                    <h2 class="card-title"><i class="fas fa-credit-card"></i> Phương thức thanh toán</h2>
                    
                    <div class="payment-selector">
                        <div class="payment-option selected" id="payment-cod">
                            <input type="radio" name="paymentMethod" value="COD" checked id="radio-cod">
                            <i class="fas fa-truck-ramp-box"></i>
                            <span class="payment-option-title">Thanh toán khi nhận hàng (COD)</span>
                            <span class="payment-option-desc">Thanh toán bằng tiền mặt khi shipper giao hàng tận nơi.</span>
                        </div>

                        <div class="payment-option" id="payment-bank">
                            <input type="radio" name="paymentMethod" value="BANK_TRANSFER" id="radio-bank">
                            <i class="fas fa-building-columns"></i>
                            <span class="payment-option-title">Chuyển khoản ngân hàng</span>
                            <span class="payment-option-desc">Chuyển khoản qua mã QR ngân hàng hoặc internet banking.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: Order Summary -->
            <div class="summary-col">
                <div class="checkout-card">
                    <h2 class="card-title"><i class="fas fa-basket-shopping"></i> Tóm tắt đơn hàng</h2>
                    
                    <!-- Items List -->
                    <div class="checkout-items">
                        <c:forEach items="${cart}" var="item">
                            <div class="checkout-item">
                                <img src="${pageContext.request.contextPath}/images/${item.thumbnail}" 
                                     onerror="this.src='https://placehold.co/60x50/f1f5f9/94a3b8?text=UniLap'" 
                                     alt="${item.productName}" class="checkout-item-img">
                                <div class="checkout-item-info">
                                    <h3 class="checkout-item-name">${item.productName}</h3>
                                    <div class="checkout-item-meta">
                                        Cấu hình: ${item.variantName} <br>
                                        Số lượng: ${item.quantity}
                                    </div>
                                </div>
                                <div class="checkout-item-price">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Coupon Code Input -->
                    <div class="coupon-section" style="margin: 20px 0; padding-top: 15px; border-top: 1px solid #f1f5f9;">
                        <h3 style="font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;"><i class="fas fa-ticket" style="margin-right: 4px; color: #2563eb;"></i> Mã ưu đãi / Mã giảm giá</h3>
                        <div style="display: flex; gap: 8px;">
                            <input type="text" id="couponCodeInput" class="form-control" placeholder="Nhập mã ưu đãi (VD: UNILAP10)" style="margin: 0; padding: 8px 12px; font-size: 13px; text-transform: uppercase;" value="${sessionScope.couponCode}">
                            <button type="button" id="btnApplyCoupon" class="btn-submit-order" style="margin: 0; width: auto; font-size: 13px; padding: 0 16px; white-space: nowrap;">Áp dụng</button>
                        </div>
                        <div id="couponMessageLabel" style="font-size: 12px; margin-top: 6px; font-weight: 500; display: none;"></div>
                    </div>

                    <!-- Cost Summary lines -->
                    <div class="summary-totals">
                        <div class="summary-line">
                            <span>Tạm tính</span>
                            <span><fmt:formatNumber value="${total}" pattern="#,##0"/>₫</span>
                        </div>
                        
                        <div class="summary-line" id="checkout-discount-line" style="${not empty discountAmount && discountAmount > 0 ? '' : 'display: none;'}">
                            <span>Giảm giá</span>
                            <span class="discount-badge" id="checkout-discount-val">- <fmt:formatNumber value="${discountAmount}" pattern="#,##0"/>₫</span>
                        </div>

                        <div class="summary-line" id="shipping-fee-line">
                            <span>Phí vận chuyển</span>
                            <span class="shipping-badge" id="shipping-fee-val" style="${shippingFee > 0 ? 'background-color: #fee2e2; color: #ef4444;' : ''}">
                                <c:choose>
                                    <c:when test="${shippingFee > 0}">
                                        <fmt:formatNumber value="${shippingFee}" pattern="#,##0"/>₫
                                    </c:when>
                                    <c:otherwise>
                                        Miễn phí
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="summary-line total">
                            <span>Tổng thanh toán</span>
                            <span><fmt:formatNumber value="${finalTotal}" pattern="#,##0"/>₫</span>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-submit-order">
                        <i class="fas fa-check-circle"></i> Xác nhận đặt hàng
                    </button>
                </div>
            </div>
        </form>
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
    // Header user menu dropdown toggle
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

        // Payment method option switcher
        const codOption = document.getElementById('payment-cod');
        const bankOption = document.getElementById('payment-bank');
        const radioCod = document.getElementById('radio-cod');
        const radioBank = document.getElementById('radio-bank');

        if (codOption && bankOption) {
            codOption.addEventListener('click', function() {
                codOption.classList.add('selected');
                bankOption.classList.remove('selected');
                radioCod.checked = true;
            });

            bankOption.addEventListener('click', function() {
                bankOption.classList.add('selected');
                codOption.classList.remove('selected');
                radioBank.checked = true;
            });
        }

        // Cost values for calculation
        const subtotalVal = ${total};
        let discountVal = ${discountAmount};
        const baseShippingFee = subtotalVal < 500000 ? 15000 : 0;
        let currentShippingFee = baseShippingFee;

        // Shipping method option switcher
        const shipHome = document.getElementById('ship-home');
        const shipStore = document.getElementById('ship-store');
        const radioHome = document.getElementById('radio-home');
        const radioStore = document.getElementById('radio-store');
        const shippingCard = document.getElementById('shipping-info-card');
        
        const fullNameInput = document.getElementById('fullName');
        const phoneInput = document.getElementById('phone');
        const addressInput = document.getElementById('address');

        // Store pre-filled values
        let originalName = fullNameInput ? fullNameInput.value : '';
        let originalPhone = phoneInput ? phoneInput.value : '';
        let originalAddress = addressInput ? addressInput.value : '';

        function recalculateCheckoutTotals() {
            // Get shipping fee based on selected method
            const isStorePickup = radioStore.checked;
            currentShippingFee = isStorePickup ? 0 : baseShippingFee;

            // Update shipping fee badge UI
            const shippingFeeValSpan = document.getElementById('shipping-fee-val');
            if (shippingFeeValSpan) {
                if (currentShippingFee > 0) {
                    shippingFeeValSpan.innerText = formatCurrency(currentShippingFee) + '₫';
                    shippingFeeValSpan.style.backgroundColor = '#fee2e2';
                    shippingFeeValSpan.style.color = '#ef4444';
                } else {
                    shippingFeeValSpan.innerText = 'Miễn phí';
                    shippingFeeValSpan.style.backgroundColor = '';
                    shippingFeeValSpan.style.color = '';
                }
            }

            // Calculate final total
            let finalTotal = subtotalVal - discountVal + currentShippingFee;
            if (finalTotal < 0) finalTotal = 0;

            // Update Total UI
            const totalSpan = document.querySelector('.summary-line.total span:last-child');
            if (totalSpan) {
                totalSpan.innerText = formatCurrency(finalTotal) + '₫';
            }
        }

        function formatCurrency(value) {
            return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        if (shipHome && shipStore) {
            shipHome.addEventListener('click', function() {
                shipHome.classList.add('selected');
                shipStore.classList.remove('selected');
                radioHome.checked = true;
                
                // Show shipping card
                if (shippingCard) {
                    shippingCard.style.display = 'block';
                }
                
                // Show shipping fee line
                const shippingFeeLine = document.getElementById('shipping-fee-line');
                if (shippingFeeLine) {
                    shippingFeeLine.style.display = 'flex';
                }
                
                // Restore values and require them
                if (fullNameInput) {
                    fullNameInput.value = originalName;
                    fullNameInput.setAttribute('required', 'required');
                }
                if (phoneInput) {
                    phoneInput.value = originalPhone;
                    phoneInput.setAttribute('required', 'required');
                    phoneInput.setAttribute('pattern', '0[0-9]{9}');
                }
                if (addressInput) {
                    addressInput.value = originalAddress;
                    addressInput.setAttribute('required', 'required');
                }

                recalculateCheckoutTotals();
            });

            shipStore.addEventListener('click', function() {
                shipStore.classList.add('selected');
                shipHome.classList.remove('selected');
                radioStore.checked = true;
                
                // Hide shipping card
                if (shippingCard) {
                    shippingCard.style.display = 'none';
                }
                
                // Hide shipping fee line
                const shippingFeeLine = document.getElementById('shipping-fee-line');
                if (shippingFeeLine) {
                    shippingFeeLine.style.display = 'none';
                }
                
                // Keep track of current edits in inputs in case they typed before switching
                if (fullNameInput && fullNameInput.value !== 'Khách nhận tại showroom') {
                    originalName = fullNameInput.value;
                }
                if (phoneInput && phoneInput.value !== '0903333333') {
                    originalPhone = phoneInput.value;
                }
                if (addressInput && addressInput.value !== 'Nhận tại cửa hàng UniLap - Mỹ Đình, Hà Nội') {
                    originalAddress = addressInput.value;
                }

                // Remove required attributes
                if (fullNameInput) {
                    fullNameInput.removeAttribute('required');
                    fullNameInput.value = originalName ? originalName : 'Khách nhận tại showroom';
                }
                if (phoneInput) {
                    phoneInput.removeAttribute('required');
                    phoneInput.removeAttribute('pattern');
                    phoneInput.value = (originalPhone && originalPhone.match(/^0[0-9]{9}$/)) ? originalPhone : '0903333333';
                }
                if (addressInput) {
                    addressInput.removeAttribute('required');
                    addressInput.value = 'Nhận tại cửa hàng UniLap - Mỹ Đình, Hà Nội';
                }

                recalculateCheckoutTotals();
            });
        }

        // Coupon code handling
        const btnApplyCoupon = document.getElementById('btnApplyCoupon');
        const couponInput = document.getElementById('couponCodeInput');
        const couponMessageLabel = document.getElementById('couponMessageLabel');

        if (btnApplyCoupon && couponInput) {
            btnApplyCoupon.addEventListener('click', function() {
                const code = couponInput.value.trim();
                if (!code) {
                    showCouponMessage('Vui lòng nhập mã giảm giá.', false);
                    return;
                }

                btnApplyCoupon.disabled = true;
                btnApplyCoupon.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

                fetch("${pageContext.request.contextPath}/CartServlet?action=coupon&ajax=true", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'couponCode=' + encodeURIComponent(code)
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP Status ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    btnApplyCoupon.disabled = false;
                    btnApplyCoupon.innerText = 'Áp dụng';

                    showCouponMessage(data.couponMessage, data.couponSuccess);

                    if (data.success) {
                        updateTotalsUI(data.total, data.discount, data.finalTotal);
                    }
                })
                .catch(err => {
                    btnApplyCoupon.disabled = false;
                    btnApplyCoupon.innerText = 'Áp dụng';
                    showCouponMessage('Đã xảy ra lỗi khi áp dụng mã.', false);
                    console.error(err);
                });
            });
        }

        function showCouponMessage(text, success) {
            if (!couponMessageLabel) return;
            couponMessageLabel.innerText = text;
            couponMessageLabel.style.display = 'block';
            if (success) {
                couponMessageLabel.style.color = '#15803d'; // Green
            } else {
                couponMessageLabel.style.color = '#b91c1c'; // Red
            }
        }

        function updateTotalsUI(totalStr, discountStr, finalTotalStr) {
            const discountLine = document.getElementById('checkout-discount-line');
            const discountValSpan = document.getElementById('checkout-discount-val');

            discountVal = parseFloat(discountStr.replace(/[^0-9]/g, '')) || 0;
            if (discountVal > 0) {
                if (discountLine) discountLine.style.display = 'flex';
                if (discountValSpan) discountValSpan.innerText = '- ' + formatCurrency(discountVal) + '₫';
            } else {
                if (discountLine) discountLine.style.display = 'none';
            }

            recalculateCheckoutTotals();
        }
    });
</script>
</body>
</html>

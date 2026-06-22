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
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - UniLap</title>
    <meta name="description" content="Đơn hàng của bạn đã được đặt thành công tại UniLap.">
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
                <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
            </form>
            <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
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

<!-- ===== MAIN ===== -->
<main class="checkout-main">
    <div class="container">
        <div class="checkout-card success-card">
            <c:choose>
                <c:when test="${paymentMethod == 'BANK_TRANSFER' || param.paymentMethod == 'BANK_TRANSFER'}">
                    <div style="margin-bottom: 24px;">
                        <h1 class="success-title" style="margin-top: 0;">Thanh toán chuyển khoản</h1>
                        <p class="success-desc">Vui lòng quét mã QR hoặc chuyển khoản chính xác thông tin dưới đây để hoàn tất đơn hàng.</p>
                    </div>
                    <style>
                        @keyframes scaleUp {
                            from { transform: scale(0.95); opacity: 0; }
                            to { transform: scale(1); opacity: 1; }
                        }
                        .sepay-payment-container {
                            margin: 28px 0;
                            padding: 24px;
                            background: #f8fafc;
                            border: 1px dashed #cbd5e1;
                            border-radius: 12px;
                            display: flex;
                            gap: 28px;
                            align-items: center;
                            text-align: left;
                            animation: scaleUp 0.4s ease-out;
                        }
                        .sepay-qr-col {
                            flex: 0 0 180px;
                            text-align: center;
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }
                        .sepay-qr-col img {
                            width: 100%;
                            border-radius: 8px;
                            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                            border: 1px solid #e2e8f0;
                            background: white;
                            padding: 8px;
                        }
                        .sepay-qr-hint {
                            font-size: 11px;
                            color: #64748b;
                            font-weight: 500;
                        }
                        .sepay-details-col {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            gap: 10px;
                        }
                        .sepay-info-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 8px 12px;
                            background: white;
                            border-radius: 6px;
                            border: 1px solid #e2e8f0;
                        }
                        .sepay-label {
                            font-size: 13px;
                            color: #64748b;
                            font-weight: 500;
                        }
                        .sepay-val-group {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }
                        .sepay-val {
                            font-size: 14px;
                            font-weight: 600;
                            color: #0f172a;
                        }
                        .btn-copy {
                            background: #f1f5f9;
                            border: none;
                            padding: 4px 8px;
                            border-radius: 4px;
                            font-size: 11px;
                            font-weight: 600;
                            color: #475569;
                            cursor: pointer;
                            transition: all 0.2s;
                        }
                        .btn-copy:hover {
                            background: #e2e8f0;
                            color: #0f172a;
                        }
                        @media (max-width: 768px) {
                            .sepay-payment-container {
                                flex-direction: column;
                                gap: 20px;
                                align-items: stretch;
                            }
                            .sepay-qr-col {
                                align-self: center;
                                width: 160px;
                            }
                        }
                    </style>
                    <div id="sepay-payment-box" class="sepay-payment-container">
                        <div class="sepay-qr-col">
                            <img src="https://qr.sepay.vn/img?bank=MB&acc=0903333333&amount=${total}&memo=${orderId}" alt="VietQR SePay">
                            <span class="sepay-qr-hint"><i class="fas fa-qrcode"></i> Quét mã để thanh toán</span>
                        </div>
                        <div class="sepay-details-col">
                            <div class="sepay-info-row">
                                <span class="sepay-label">Ngân hàng</span>
                                <span class="sepay-val">MB Bank (Ngân hàng Quân Đội)</span>
                            </div>
                            <div class="sepay-info-row">
                                <span class="sepay-label">Số tài khoản</span>
                                <div class="sepay-val-group">
                                    <span class="sepay-val" id="sepay-acc">0903333333</span>
                                    <button type="button" class="btn-copy" onclick="copyText('sepay-acc', this)">Sao chép</button>
                                </div>
                            </div>
                            <div class="sepay-info-row">
                                <span class="sepay-label">Số tiền</span>
                                <div class="sepay-val-group">
                                    <span class="sepay-val" id="sepay-amount"><fmt:formatNumber value="${total}" pattern="#,##0"/></span><span class="sepay-val">₫</span>
                                    <button type="button" class="btn-copy" onclick="copyTextValue('${total}', this)">Sao chép</button>
                                </div>
                            </div>
                            <div class="sepay-info-row">
                                <span class="sepay-label">Nội dung chuyển khoản</span>
                                <div class="sepay-val-group">
                                    <span class="sepay-val" id="sepay-memo">${orderId}</span>
                                    <button type="button" class="btn-copy" onclick="copyText('sepay-memo', this)">Sao chép</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                        (function() {
                            // Clipboard Copy Helpers
                            window.copyText = function(elementId, btn) {
                                const el = document.getElementById(elementId);
                                if (!el) return;
                                const text = el.innerText || el.textContent;
                                window.copyTextValue(text, btn);
                            };

                            window.copyTextValue = function(value, btn) {
                                if (navigator.clipboard && navigator.clipboard.writeText) {
                                    navigator.clipboard.writeText(value).then(() => {
                                        showCopiedState(btn);
                                    }).catch(err => {
                                        fallbackCopyText(value, btn);
                                    });
                                } else {
                                    fallbackCopyText(value, btn);
                                }
                            };

                            function fallbackCopyText(text, btn) {
                                const textArea = document.createElement("textarea");
                                textArea.value = text;
                                textArea.style.position = "fixed";
                                textArea.style.top = "0";
                                textArea.style.left = "0";
                                textArea.style.width = "2em";
                                textArea.style.height = "2em";
                                textArea.style.padding = "0";
                                textArea.style.border = "none";
                                textArea.style.outline = "none";
                                textArea.style.boxShadow = "none";
                                textArea.style.background = "transparent";
                                document.body.appendChild(textArea);
                                textArea.focus();
                                textArea.select();
                                try {
                                    document.execCommand('copy');
                                    showCopiedState(btn);
                                } catch (err) {
                                    console.error('Fallback copy failed', err);
                                }
                                document.body.removeChild(textArea);
                            }

                            function showCopiedState(btn) {
                                const originalText = btn.innerHTML;
                                btn.innerHTML = '<i class="fas fa-check" style="color: #15803d;"></i> Đã chép';
                                btn.style.background = '#dcfce7';
                                btn.style.color = '#15803d';
                                setTimeout(() => {
                                    btn.innerHTML = originalText;
                                    btn.style.background = '';
                                    btn.style.color = '';
                                }, 1500);
                            }
                        })();
                    </script>
                </c:when>
                <c:otherwise>
                    <div class="success-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <h1 class="success-title">Đặt hàng thành công!</h1>
                    <p class="success-desc">
                        Cảm ơn bạn đã tin tưởng mua sắm tại UniLap. <br>
                        Đơn hàng của bạn đã được tiếp nhận hệ thống và đang trong quá trình chuẩn bị hàng.
                    </p>

                    <div class="order-info-box">
                        <div class="order-info-row">
                            <span class="order-info-label">Mã đơn hàng:</span>
                            <span class="order-info-value id">${orderId}</span>
                        </div>
                        <div class="order-info-row">
                            <span class="order-info-label">Trạng thái:</span>
                            <span class="order-info-value" id="order-status-value" style="color: #2563eb;">Đang xử lý</span>
                        </div>
                        <div class="order-info-row">
                            <span class="order-info-label">Phí vận chuyển:</span>
                            <span class="order-info-value shipping-badge">Miễn phí</span>
                        </div>
                        <div class="order-info-row">
                            <span class="order-info-label">Dự kiến giao hàng:</span>
                            <span class="order-info-value">1 - 3 ngày làm việc</span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="btn-actions">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-submit-order" style="margin-top: 0; width: auto; padding: 12px 32px;">
                    <i class="fas fa-house"></i> Tiếp tục mua sắm
                </a>
                <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-secondary">
                    Theo dõi đơn hàng
                </a>
            </div>
        </div>
    </div>
</main>

<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div class="container footer-inner">
        <div class="footer-brand">
            <a href="${pageContext.request.contextPath}/HomeServlet" class="footer-logo">UniLap</a>
            <p class="footer-desc">Trải nghiệm công nghệ đỉnh cao với các dòng laptop gaming và văn phòng cao cấp nhất hiện nay.</p>
        </div>
        <nav class="footer-links">
            <c:if test="${not empty footerPages}">
                <c:forEach items="${footerPages}" var="pageItem">
                    <a href="${pageContext.request.contextPath}/page?key=${pageItem.pageKey}">${pageItem.title}</a>
                </c:forEach>
            </c:if>
            <c:if test="${empty footerPages}">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Shipping Info</a>
                <a href="#">Returns</a>
            </c:if>
        </nav>
        <div class="footer-right">
            <p>&copy; 2024 UniLap Technologies. All rights reserved.</p>
            <div class="footer-icons">
                <a href="#" aria-label="Language"><i class="fas fa-globe"></i></a>
                <a href="#" aria-label="Share"><i class="fas fa-share-nodes"></i></a>
            </div>
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
    });
</script>
</body>
</html>

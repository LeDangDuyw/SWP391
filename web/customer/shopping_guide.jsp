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
        <title>UniLap - ${policy.title}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy.css?v=1">
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
                        <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                            <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                        </c:if>
                    </a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                 <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.avatarUrl}">
                                            <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}"
                                                 alt="avatar"
                                                 style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid #e2e8f0;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user"></i>
                                        </c:otherwise>
                                    </c:choose>
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
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" style="color: #1e293b; text-decoration: none; font-size: 14px; font-weight: 500;"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Main Page Container -->
        <div class="policy-page-container">
            <!-- Sidebar -->
            <%@include file="_policySidebar.jspf" %>

            <!-- Content Area -->
            <main class="policy-main-content">
                <div class="breadcrumbs">
                    <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a> 
                    <i class="fas fa-chevron-right"></i> 
                    <span>${policy.title}</span>
                </div>
                <div class="policy-header">
                    <h1>${policy.title}</h1>
                    <c:if test="${not empty policy.updatedAt}">
                        <div class="last-updated">Cập nhật lần cuối: <fmt:formatDate value="${policy.updatedAt}" pattern="dd/MM/yyyy"/></div>
                    </c:if>
                </div>
                <div class="policy-content-body">
                    ${policy.content}
                    
                    <!-- Vertical Stepper -->
                    <div class="vertical-stepper">
                        <div class="stepper-step">
                            <div class="step-circle">1</div>
                            <div class="step-body">
                                <h3 class="step-title"><i class="fas fa-search"></i> Bước 1: Tìm kiếm &amp; Chọn lựa</h3>
                                <p class="step-desc">Duyệt qua danh mục Laptop, Bàn phím hoặc Chuột máy tính hoặc sử dụng thanh tìm kiếm trực tuyến của UniLap để nhanh chóng lọc ra cấu hình mong muốn.</p>
                            </div>
                        </div>
                        
                        <div class="stepper-step">
                            <div class="step-circle">2</div>
                            <div class="step-body">
                                <h3 class="step-title"><i class="fas fa-balance-scale"></i> Bước 2: So sánh cấu hình</h3>
                                <p class="step-desc">Nhấp xem chi tiết kỹ thuật, các đánh giá chất lượng từ cộng đồng và bổ sung các sản phẩm cùng phân khúc để tiến hành so sánh trực tiếp, tối ưu hóa sự lựa chọn.</p>
                            </div>
                        </div>
                        
                        <div class="stepper-step">
                            <div class="step-circle">3</div>
                            <div class="step-body">
                                <h3 class="step-title"><i class="fas fa-cart-plus"></i> Bước 3: Thêm vào giỏ hàng</h3>
                                <p class="step-desc">Thêm thiết bị vào giỏ hàng của bạn. Bạn có thể chọn tiếp tục tham quan mua sắm hoặc nhấp nút "Giỏ hàng" -> "Mua ngay" để lập tức chuyển sang màn hình thanh toán.</p>
                            </div>
                        </div>
                        
                        <div class="stepper-step">
                            <div class="step-circle">4</div>
                            <div class="step-body">
                                <h3 class="step-title"><i class="fas fa-credit-card"></i> Bước 4: Thanh toán &amp; Xác nhận</h3>
                                <p class="step-desc">Lựa chọn các hình thức thanh toán đa dạng (Thanh toán khi nhận hàng COD, chuyển khoản trực tuyến ngân hàng hoặc thanh toán nhanh qua MoMo). Điền chuẩn xác địa chỉ nhận hàng và SĐT để UniLap gửi hàng tận nơi.</p>
                            </div>
                        </div>

                        <div class="stepper-step">
                            <div class="step-circle">5</div>
                            <div class="step-body">
                                <h3 class="step-title"><i class="fas fa-box-open"></i> Bước 5: Nhận hàng &amp; Bảo hành</h3>
                                <p class="step-desc">Nhận hàng, kiểm tra ngoại quan máy và xác nhận thanh toán. Thông tin số Serial Number trên thiết bị sẽ ngay lập tức được đồng bộ kích hoạt trên cổng tra cứu bảo hành điện tử của UniLap.</p>
                            </div>
                        </div>
                    </div>

                    <!-- FAQ accordion -->
                    <div class="faq-section">
                        <h2 style="border-left: 4px solid #2563eb; padding-left: 12px; margin-bottom: 20px;">Câu hỏi thường gặp (FAQ)</h2>
                        
                        <details class="faq-item">
                            <summary class="faq-summary">UniLap có chính sách hỗ trợ trả góp lãi suất 0% không?</summary>
                            <div class="faq-body">
                                Có. UniLap hỗ trợ thanh toán trả góp 0% lãi suất thông qua liên kết thẻ tín dụng của hơn 20 ngân hàng thương mại uy tín toàn quốc. Thủ tục hoàn toàn online, nhanh chóng và khách hàng không chịu thêm bất cứ chi phí ẩn nào.
                            </div>
                        </details>

                        <details class="faq-item">
                            <summary class="faq-summary">Giao hàng trên toàn quốc mất khoảng bao nhiêu ngày?</summary>
                            <div class="faq-body">
                                Đối với khu vực nội thành Hà Nội, chúng tôi hỗ trợ giao hàng hỏa tốc trong 2 giờ. Đối với các khu vực và tỉnh thành khác trên toàn quốc, thời gian vận chuyển sẽ dao động từ 2 - 4 ngày làm việc (không tính ngày lễ, Tết).
                            </div>
                        </details>

                        <details class="faq-item">
                            <summary class="faq-summary">Làm sao để tôi đổi hoặc trả sản phẩm bị lỗi?</summary>
                            <div class="faq-body">
                                UniLap áp dụng chính sách 1 đổi 1 trong vòng 7 ngày đầu tiên kể từ thời điểm nhận máy nếu sản phẩm có lỗi phần cứng phát sinh từ nhà sản xuất. Quý khách vui lòng đem thiết bị kèm hóa đơn qua trung tâm bảo hành gần nhất để được kỹ thuật kiểm tra và đổi ngay thiết bị mới.
                            </div>
                        </details>
                    </div>

                    <!-- Begin Shopping CTA -->
                    <div style="margin-top: 40px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/ProductListServlet" class="btn-cta-link">
                            <i class="fas fa-shopping-bag"></i> Bắt đầu mua sắm ngay
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <%@include file="_footer.jspf" %>
        <script>
            // Header User Menu Dropdown Toggle
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
                    document.addEventListener('click', function() {
                        var dropdowns = document.querySelectorAll('.user-menu-dropdown-content');
                        dropdowns.forEach(function(d) {
                            d.style.display = 'none';
                        });
                    });
                });
            })();
        </script>
    </body>
</html>

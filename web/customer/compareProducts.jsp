<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>So Sánh Sản Phẩm - UniLap</title>

    <!-- Google Fonts & Font Awesome Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- CSS riêng biệt -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product_detail.css?v=10">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/compare.css?v=2">

    <script>
        window.contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
    <!-- Header -->
    <c:set var="catId" value="${not empty compareProducts ? compareProducts[0].categoryId : 0}" />
    <header class="header">
        <div class="container header-container">
            <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
            <nav class="main-nav">
                <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
                <c:forEach items="${categories}" var="cat">
                    <c:if test="${cat.categoryId == 1 || cat.categoryId == 3 || cat.categoryId == 4}">
                        <a href="ProductListServlet?category=${cat.categoryId}" class="${catId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
                    </c:if>
                </c:forEach>

                <div class="nav-dropdown ${catId == 2 || catId == 5 || catId == 6 || catId == 7 ? 'active' : ''}">
                    <span class="dropdown-btn">Phụ kiện khác <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                    <div class="dropdown-content">
                        <c:forEach items="${categories}" var="cat">
                            <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                <a href="ProductListServlet?category=${cat.categoryId}" class="${catId == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
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

    <!-- Main Compare Content -->
    <c:choose>
        <c:when test="${empty compareProducts}">
            <div class="compare-container">
                <div class="empty-compare">
                    <i class="fas fa-balance-scale-left"></i>
                    <p>Chưa có sản phẩm nào trong danh sách so sánh của bạn.</p>
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back">Quay lại Trang chủ</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="compare-layout-wrapper">
                <!-- Left Column: Compare Main Content -->
                <div class="compare-main-block">
                    <div class="compare-header">
                        <h1>So Sánh Sản Phẩm</h1>
                        <button class="btn-clear" onclick="clearCompareList()">Xóa tất cả</button>
                    </div>

                    <div class="compare-table-wrapper">
                    <table class="compare-table">
                        <!-- 1. Dòng hình ảnh & tên sản phẩm -->
                        <tr>
                            <th>Sản phẩm</th>
                            <c:forEach items="${compareProducts}" var="p">
                                <td class="product-col">
                                    <button class="btn-remove"
                                        onclick="removeProductFromCompare(${p.productId})"
                                        title="Xóa sản phẩm này">×</button>
                                    <img class="product-image"
                                        src="${pageContext.request.contextPath}/images/${p.thumbnail}"
                                        alt="${p.productName}">
                                    <div class="product-name">${p.productName}</div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.minPrice}" type="currency"
                                            currencySymbol="đ" />
                                    </div>
                                    <div style="font-size: 12px; color: var(--text-muted);">Thương hiệu: ${p.brandName}</div>
                                </td>
                            </c:forEach>
                        </tr>

                        <!-- 2. Bảo hành -->
                        <tr>
                            <th>Bảo hành</th>
                            <c:forEach items="${compareProducts}" var="p">
                                <td><strong>${p.warrantyPeriod}</strong> tháng chính hãng</td>
                            </c:forEach>
                        </tr>
                        
                        <!-- Cấu hình riêng biệt theo danh mục -->
                        <c:choose>
                            <%-- 1. Cấu hình Laptop (Category 1) --%>
                            <c:when test="${catId == 1}">
                                <tr>
                                    <th>Vi xử lý (CPU)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.cpu ? p.cpu : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Bộ nhớ trong (RAM)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.ram ? p.ram : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Ổ lưu trữ (SSD)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.ssd ? p.ssd : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Card đồ họa (GPU)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.gpu ? p.gpu : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Màn hình hiển thị</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.screen ? p.screen : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Hệ điều hành</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.os ? p.os : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Dung lượng Pin</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.pin ? p.pin : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Trọng lượng</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.weight ? p.weight : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 2. Cấu hình Màn hình (Category 2) --%>
                            <c:when test="${catId == 2}">
                                <tr>
                                    <th>Kích thước màn hình</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.screen ? p.screen : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Độ phân giải</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.resolution ? p.resolution : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Tần số quét</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.refreshRate ? p.refreshRate : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Thời gian phản hồi</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.responseTime ? p.responseTime : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Cổng kết nối</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.connectivity ? p.connectivity : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 3. Cấu hình Bàn phím (Category 3) --%>
                            <c:when test="${catId == 3}">
                                <tr>
                                    <th>Kiểu kết nối</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.connectivity ? p.connectivity : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Loại Switch</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.switchType ? p.switchType : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Layout phím</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.layout ? p.layout : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Đèn LED (Backlight)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.backlight ? p.backlight : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 4. Cấu hình Chuột (Category 4) --%>
                            <c:when test="${catId == 4}">
                                <tr>
                                    <th>Kiểu kết nối</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.connectivity ? p.connectivity : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Độ nhạy (DPI tối đa)</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.dpi ? p.dpi : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Số lượng nút bấm</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.buttons ? p.buttons : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 5. Cấu hình Tai nghe (Category 5) --%>
                            <c:when test="${catId == 5}">
                                <tr>
                                    <th>Kiểu kết nối</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.connectivity ? p.connectivity : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Màu sắc</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.color ? p.color : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 6. Cấu hình Loa (Category 6) --%>
                            <c:when test="${catId == 6}">
                                <tr>
                                    <th>Kiểu kết nối</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.connectivity ? p.connectivity : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Công suất hoạt động</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.power ? p.power : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                            <%-- 7. Cấu hình Pad chuột (Category 7) --%>
                            <c:when test="${catId == 7}">
                                <tr>
                                    <th>Màu sắc / Họa tiết</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.color ? p.color : '-'}</td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th>Kích thước / Trọng lượng</th>
                                    <c:forEach items="${compareProducts}" var="p">
                                        <td>${not empty p.weight ? p.weight : '-'}</td>
                                    </c:forEach>
                                </tr>
                            </c:when>
                        </c:choose>
                    </table>
                </div> <!-- End of .compare-table-wrapper -->
            </div> <!-- End of .compare-main-block -->

            <!-- Right Column: Sidebar (Suggest Products) -->
            <c:if test="${not empty suggestProducts}">
                <div class="compare-sidebar-block">
                    <h4 class="sidebar-section-title">Gợi ý sản phẩm cùng phân khúc</h4>
                    <div class="suggest-sidebar-list">
                        <c:forEach items="${suggestProducts}" var="sp">
                            <div class="suggest-sidebar-item">
                                <img src="${pageContext.request.contextPath}/images/${sp.thumbnail}" alt="${sp.productName}">
                                <div class="suggest-info">
                                    <div class="suggest-price">
                                        <fmt:formatNumber value="${sp.minPrice}" type="currency" currencySymbol="đ" />
                                    </div>
                                    <h5 class="suggest-name" title="${sp.productName}">${sp.productName}</h5>
                                    <a href="javascript:void(0)" onclick="addProductToCompare(${sp.productId})" class="suggest-add-link">
                                        <i class="fas fa-plus-circle"></i> Thêm vào so sánh
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div> <!-- End of .compare-layout-wrapper -->
    </c:otherwise>
</c:choose>

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
                    <p><i class="fas fa-map-marker-alt"></i> Mỹ Đình, Hà Nội</p>
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

    <!-- Gọi file JavaScript thuần đã viết riêng -->
    <script src="${pageContext.request.contextPath}/js/compare.js"></script>
    <jsp:include page="chatbot.jsp" />
</body>
</html>
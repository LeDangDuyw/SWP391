<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN"/>

<c:if test="${empty categories}">
    <%
        try {
            dal.CategoryDAO catDAO = new dal.CategoryDAO();
            request.setAttribute("categories", catDAO.getAllCategories());
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</c:if>

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
        <%@include file="_header.jspf" %>

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
                    <!-- About Hero Banner -->
                    <div class="about-hero">
                        <h2>Kiến Tạo Trải Nghiệm Công Nghệ Đỉnh Cao</h2>
                        <p>UniLap đồng hành cùng bạn trên con đường chinh phục đỉnh cao công nghệ bằng những sản phẩm Laptop, chuột và bàn phím máy tính chất lượng chính hãng tốt nhất.</p>
                    </div>

                    ${policy.content}

                    <!-- Core Value Grid -->
                    <h2 style="border-left: 4px solid #2563eb; padding-left: 12px; margin-top: 40px; margin-bottom: 20px;">Giá Trị Cốt Lõi Tại UniLap</h2>
                    <div class="core-values-grid">
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-medal"></i></div>
                            <h4 class="core-value-title">Chất Lượng Chính Hãng</h4>
                            <p class="core-value-desc">Cam kết phân phối sản phẩm chính hãng 100% từ các thương hiệu hàng đầu thế giới như ASUS, Dell, HP, Apple, Logitech...</p>
                        </div>
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-brain"></i></div>
                            <h4 class="core-value-title">Công Nghệ AI Gợi Ý</h4>
                            <p class="core-value-desc">Tích hợp AI trợ lý mua sắm thông minh hỗ trợ tìm kiếm cấu hình và so sánh sản phẩm tối ưu theo nhu cầu khách hàng.</p>
                        </div>
                        <div class="core-value-card">
                            <div class="core-value-icon"><i class="fas fa-headset"></i></div>
                            <h4 class="core-value-title">Hậu Mãi Tận Tâm</h4>
                            <p class="core-value-desc">Chính sách bảo hành điện tử rõ ràng, thời gian hỗ trợ nhanh chóng và cam kết 1 đổi 1 trong vòng 7 ngày đầu tiên.</p>
                        </div>
                    </div>

                    <!-- Counter Stats -->
                    <h2 style="border-left: 4px solid #2563eb; padding-left: 12px; margin-top: 40px; margin-bottom: 20px;">UniLap Qua Những Con Số</h2>
                    <div class="about-stats">
                        <div class="stat-item">
                            <div class="stat-num">10,000+</div>
                            <div class="stat-label">Khách hàng tin dùng</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">500+</div>
                            <div class="stat-label">Sản phẩm công nghệ</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">5+</div>
                            <div class="stat-label">Năm hoạt động</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-num">99%</div>
                            <div class="stat-label">Hài lòng dịch vụ</div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Footer -->
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

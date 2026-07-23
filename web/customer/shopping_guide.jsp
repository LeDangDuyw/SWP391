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

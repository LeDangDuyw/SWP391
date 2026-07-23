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
        <title>UniLap - Chính sách bảo hành</title>
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
                    <span>Chính sách bảo hành</span>
                </div>
                <div class="policy-header">
                    <h1>Chính sách bảo hành</h1>
                    <div class="last-updated">Cung cấp các quy định dịch vụ bảo hành điện tử chính thức</div>
                </div>
                
                <div class="policy-content-body">
                    <p style="margin-bottom: 24px;">UniLap cam kết cung cấp dịch vụ bảo hành chuyên nghiệp và tận tâm. Các thông tin chính sách bảo hành chính hãng dưới đây được áp dụng tùy thuộc vào nhóm thiết bị và khu vực bán hàng tương ứng:</p>

                    <c:choose>
                        <c:when test="${not empty policies}">
                            <c:forEach items="${policies}" var="p">
                                <div class="warranty-policy-card">
                                    <div class="warranty-policy-header">
                                        <div>
                                            <h3 class="warranty-policy-title">${p.policyName}</h3>
                                            <p class="warranty-policy-desc">${p.description}</p>
                                        </div>
                                        <div class="warranty-badge-container">
                                            <span class="warranty-badge months"><i class="fas fa-calendar-alt"></i> ${p.warrantyMonths} tháng</span>
                                            <c:if test="${not empty p.applicableRegions}">
                                                <span class="warranty-badge regions"><i class="fas fa-map-marker-alt"></i> ${p.applicableRegions}</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="warranty-policy-body">
                                        <div class="warranty-policy-content">
                                            ${p.policyContent}
                                        </div>
                                    </div>
                                    <div class="warranty-policy-footer">
                                        <c:if test="${not empty p.effectiveDate}">
                                            <span>Ngày hiệu lực: <fmt:formatDate value="${p.effectiveDate}" pattern="dd/MM/yyyy"/></span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 40px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; color: #64748b; margin-bottom: 24px;">
                                <i class="fas fa-info-circle" style="font-size: 24px; margin-bottom: 12px; color: #94a3b8;"></i>
                                <p style="margin-bottom: 0;">Hiện tại chưa có chính sách bảo hành đặc thù nào được công khai.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Warranty Lookup CTA -->
                    <div style="margin-top: 40px; padding: 30px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; text-align: center; display: flex; flex-direction: column; align-items: center; gap: 12px;">
                        <h4 style="margin-bottom: 0; color: #0f172a; font-size: 15px; font-weight: 700;">Tra cứu thông tin bảo hành thiết bị của bạn</h4>
                        <p style="font-size: 13.5px; color: #64748b; margin-bottom: 8px; max-width: 480px;">Để theo dõi hạn bảo hành điện tử hoặc gửi yêu cầu bảo hành/sửa chữa sản phẩm đã mua tại UniLap, vui lòng nhấp vào liên kết dưới đây.</p>
                        <a href="${pageContext.request.contextPath}/warranty" class="btn-cta-link">
                            <i class="fas fa-search"></i> Truy cập Cổng tra cứu bảo hành
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

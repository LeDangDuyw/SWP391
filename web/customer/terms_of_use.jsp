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
                    
                    <div style="margin-top: 40px; padding: 24px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0;">
                        <h4 style="margin-bottom: 12px; color: #0f172a; font-size: 14.5px; font-weight: 700;">Xem thêm chính sách liên quan:</h4>
                        <ul style="list-style: none; padding-left: 0; margin-bottom: 0; display: flex; flex-direction: column; gap: 8px;">
                            <li><a href="${pageContext.request.contextPath}/policy/privacy" style="color: #2563eb; text-decoration: none; font-size: 13.5px; font-weight: 500;"><i class="fas fa-shield-alt" style="margin-right: 8px; color: #64748b;"></i> Chính sách bảo mật</a></li>
                            <li><a href="${pageContext.request.contextPath}/policy/warranty" style="color: #2563eb; text-decoration: none; font-size: 13.5px; font-weight: 500;"><i class="fas fa-tools" style="margin-right: 8px; color: #64748b;"></i> Chính sách bảo hành</a></li>
                        </ul>
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

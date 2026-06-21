<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/compare.css">
    
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>

    <div class="compare-container">
        
        <c:choose>
            <c:when test="${empty compareProducts}">
                <div class="empty-compare">
                    <i class="fas fa-balance-scale-left"></i>
                    <p>Chưa có sản phẩm nào trong danh sách so sánh của bạn.</p>
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back">Quay lại Trang chủ</a>
                </div>
            </c:when>
            <c:otherwise>
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
                                    <button class="btn-remove" onclick="removeProductFromCompare(${p.productId})" title="Xóa sản phẩm này">×</button>
                                    <img class="product-image" src="${pageContext.request.contextPath}/${p.thumbnail}" alt="${p.productName}">
                                    <div class="product-name">${p.productName}</div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.minPrice}" type="currency" currencySymbol="đ"/>
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

                        <!-- 3. Cấu hình Laptop (Chỉ hiện khi danh sách so sánh có chứa laptop) -->
                        <c:set var="isLaptop" value="false" />
                        <c:forEach items="${compareProducts}" var="p">
                            <c:if test="${not empty p.cpu}">
                                <c:set var="isLaptop" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${isLaptop}">
                            <tr>
                                <th>CPU</th>
                                <c:forEach items="${compareProducts}" var="p">
                                    <td>${not empty p.cpu ? p.cpu : '-'}</td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th>RAM</th>
                                <c:forEach items="${compareProducts}" var="p">
                                    <td>${not empty p.ram ? p.ram : '-'}</td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th>SSD</th>
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
                                <th>Màn hình</th>
                                <c:forEach items="${compareProducts}" var="p">
                                    <td>${not empty p.screen ? p.screen : '-'}</td>
                                </c:forEach>
                            </tr>
                        </c:if>

                        <!-- 4. Cấu hình Phụ kiện Chuột/Bàn phím (Chỉ hiện nếu có) -->
                        <c:set var="isAccessory" value="false" />
                        <c:forEach items="${compareProducts}" var="p">
                            <c:if test="${not empty p.connectivity}">
                                <c:set var="isAccessory" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${isAccessory}">
                            <tr>
                                <th>Cổng kết nối</th>
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
                                <th>DPI tối đa</th>
                                <c:forEach items="${compareProducts}" var="p">
                                    <td>${not empty p.dpi ? p.dpi : '-'}</td>
                                </c:forEach>
                            </tr>
                        </c:if>

                        <!-- 5. Mô tả ngắn -->
                        <tr>
                            <th>Mô tả tóm tắt</th>
                            <c:forEach items="${compareProducts}" var="p">
                                <td style="font-size: 13px; color: var(--text-muted); text-align: justify;">${p.description}</td>
                            </c:forEach>
                        </tr>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <!-- Gọi file JavaScript thuần đã viết riêng -->
    <script src="${pageContext.request.contextPath}/js/compare.js"></script>
</body>
</html>

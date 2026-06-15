<%-- 
    Document   : product_detail
    Created on : 14 thg 6, 2026, 17:36:50
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.productName} - UniLap</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    <c:if test="${not empty errorMessage}">
        <p style="color:red">${errorMessage}</p>
        <a href="${pageContext.request.contextPath}/HomeServlet">← Về trang chủ</a>
    </c:if>

    <c:if test="${not empty product}">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
            &rsaquo; ${product.categoryName}
            &rsaquo; <span>${product.productName}</span>
        </nav>

        <div class="product-detail">
            <!-- Cột ảnh -->
            <div class="pd-images">
                <img src="${pageContext.request.contextPath}/images/${product.thumbnail}"
                     alt="${product.productName}" class="pd-main-img">
            </div>

            <!-- Cột thông tin -->
            <div class="pd-info">
                <h1>${product.productName}</h1>
                <p class="pd-brand">Thương hiệu: <strong>${product.brandName}</strong></p>

                <!-- Danh sách biến thể -->
                <h3>Phiên bản</h3>
                <c:choose>
                    <c:when test="${empty variants}">
                        <p>Sản phẩm chưa có phiên bản.</p>
                    </c:when>
                    <c:otherwise>
                        <ul class="pd-variants">
                            <c:forEach var="v" items="${variants}">
                                <li>
                                    ${v.variantName}
                                    — <fmt:formatNumber value="${v.sellingPrice}" type="number"/>đ
                                    <c:choose>
                                        <c:when test="${v.availableQuantity > 0}">(Còn hàng)</c:when>
                                        <c:otherwise>(Hết hàng)</c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>

                <button class="btn-add-cart">Thêm vào giỏ hàng</button>
                <button class="btn-buy-now">Mua ngay</button>
            </div>
        </div>

        <!-- Mô tả -->
        <section class="pd-description">
            <h2>Mô tả sản phẩm</h2>
            <p>${product.description}</p>
        </section>
    </c:if>
</body>
</html>
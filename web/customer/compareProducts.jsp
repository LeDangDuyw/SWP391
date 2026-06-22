<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
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
                                <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back">Quay lại Trang
                                    chủ</a>
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
                                                <button class="btn-remove"
                                                    onclick="removeProductFromCompare(${p.productId})"
                                                    title="Xóa sản phẩm này">×</button>
                                                <img class="product-image"
                                                    src="${pageContext.request.contextPath}/${p.thumbnail}"
                                                    alt="${p.productName}">
                                                <div class="product-name">${p.productName}</div>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${p.minPrice}" type="currency"
                                                        currencySymbol="đ" />
                                                </div>
                                                <div style="font-size: 12px; color: var(--text-muted);">Thương hiệu:
                                                    ${p.brandName}</div>
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
                                    <!-- Xác định ID danh mục để hiển thị thông số riêng biệt -->
                                    <c:set var="catId" value="${compareProducts[0].categoryId}" />
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
                                                                <td>${not empty p.connectivity ? p.connectivity : '-'}
                                                                </td>
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
                                                                    <td>${not empty p.connectivity ? p.connectivity :
                                                                        '-'}</td>
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
                                                                        <td>${not empty p.connectivity ? p.connectivity
                                                                            : '-'}</td>
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
                                                                            <td>${not empty p.connectivity ?
                                                                                p.connectivity : '-'}</td>
                                                                        </c:forEach>
                                                                    </tr>
                                                                    <tr>
                                                                        <th>Công suất hoạt động</th>
                                                                        <c:forEach items="${compareProducts}" var="p">
                                                                            <td>${not empty p.power ? p.power : '-'}
                                                                            </td>
                                                                        </c:forEach>
                                                                    </tr>
                                                                </c:when>
                                                                <%-- 7. Cấu hình Pad chuột (Category 7) --%>
                                                                    <c:when test="${catId == 7}">
                                                                        <tr>
                                                                            <th>Màu sắc / Họa tiết</th>
                                                                            <c:forEach items="${compareProducts}"
                                                                                var="p">
                                                                                <td>${not empty p.color ? p.color : '-'}
                                                                                </td>
                                                                            </c:forEach>
                                                                        </tr>
                                                                        <tr>
                                                                            <th>Kích thước / Trọng lượng</th>
                                                                            <c:forEach items="${compareProducts}"
                                                                                var="p">
                                                                                <td>${not empty p.weight ? p.weight :
                                                                                    '-'}</td>
                                                                            </c:forEach>
                                                                        </tr>
                                                                    </c:when>
                                    </c:choose>


                                    <!-- 5. Mô tả ngắn -->
                                    <tr>
                                        <th>Mô tả tóm tắt</th>
                                        <c:forEach items="${compareProducts}" var="p">
                                            <td style="font-size: 13px; color: var(--text-muted); text-align: justify;">
                                                ${p.description}</td>
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
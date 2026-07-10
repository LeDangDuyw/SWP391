<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.List, java.util.ArrayList" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <% List<Integer> compareList = (List<Integer>) session.getAttribute("compareList");
                    if (compareList != null && !compareList.isEmpty()) {
                    dal.ProductCompareDAO compareDAO = new dal.ProductCompareDAO();
                    List<model.ProductCompareDTO> compareProducts = new ArrayList<>();
                            for (int id : compareList) {
                            model.ProductCompareDTO p = compareDAO.getProductCompareDatail(id);
                            if (p != null) {
                            compareProducts.add(p);
                            }
                            }
                            request.setAttribute("headerCompareProducts", compareProducts);
                            } else {
                            request.removeAttribute("headerCompareProducts");
                            }
                            %>

                            <c:if test="${not empty headerCompareProducts}">
                                <link rel="stylesheet"
                                    href="${pageContext.request.contextPath}/css/floatingCompareBar.css">

                                <div class="floating-compare-bar" id="floatingCompareBar">
                                    <div class="container compare-bar-container">
                                        <div class="compare-bar-left">
                                            <span class="compare-bar-title">So sánh sản phẩm
                                                (${fn:length(headerCompareProducts)}/4)</span>
                                        </div>

                                        <div class="compare-bar-items">
                                            <c:forEach items="${headerCompareProducts}" var="cp">
                                                <div class="compare-bar-item">
                                                    <img src="images/${cp.thumbnail}" alt="${cp.productName}"
                                                        class="compare-item-thumb"
                                                        onerror="this.src='https://via.placeholder.com/40x40?text=Laptop'">
                                                    <span class="compare-item-name"
                                                        title="${cp.productName}">${cp.productName}</span>
                                                    <button type="button" class="compare-item-remove"
                                                        onclick="removeProductFromCompare(${cp.productId})"
                                                        title="Xóa khỏi so sánh">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </c:forEach>

                                            <c:if test="${fn:length(headerCompareProducts) < 4}">
                                                <c:forEach begin="${fn:length(headerCompareProducts) + 1}" end="4"
                                                    var="i">
                                                    <div class="compare-bar-item placeholder">
                                                        <div class="compare-placeholder-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <span class="compare-placeholder-text">Thêm sản phẩm</span>
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </div>

                                        <div class="compare-bar-actions">
                                            <button type="button" class="btn-clear-all" onclick="clearCompareList()">Xóa
                                                tất cả</button>
                                            <a href="${pageContext.request.contextPath}/compare"
                                                class="btn-compare-now">So sánh ngay</a>
                                            <button type="button" class="compare-bar-toggle"
                                                onclick="toggleCompareBar()" title="Thu nhỏ / Mở rộng">
                                                <i class="fas fa-chevron-down" id="compareToggleIcon"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    function toggleCompareBar() {
                                        const bar = document.getElementById('floatingCompareBar');
                                        const icon = document.getElementById('compareToggleIcon');
                                        if (bar && icon) {
                                            bar.classList.toggle('collapsed');
                                            if (bar.classList.contains('collapsed')) {
                                                icon.className = 'fas fa-chevron-up';
                                            } else {
                                                icon.className = 'fas fa-chevron-down';
                                            }
                                        }
                                    }
                                </script>
                            </c:if>
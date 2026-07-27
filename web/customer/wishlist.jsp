<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN"/>
<%
    if (request.getAttribute("categories") == null) {
        try {
            dal.CategoryDAO catDAO = new dal.CategoryDAO();
            java.util.ArrayList<model.Category> categoriesList = catDAO.getAllCategories();
            request.setAttribute("categories", categoriesList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích - UniLap</title>
    <meta name="description" content="Danh sách sản phẩm laptop và phụ kiện công nghệ yêu thích của bạn tại UniLap.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --rose: #e11d48;
            --bg-gray: #f8fafc;
            --card-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
        }

        body {
            background-color: var(--bg-gray);
            font-family: 'Inter', sans-serif;
            color: #1e293b;
        }

        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 20px;
            width: 100%;
        }

        .wishlist-container {
            max-width: 1240px;
            margin: 30px auto 60px;
            padding: 0 20px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 24px;
        }

        .breadcrumb a {
            color: #64748b;
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb a:hover {
            color: var(--primary);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
            padding: 24px 30px;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            margin-bottom: 28px;
            border: 1px solid #f1f5f9;
        }

        .page-header-left h1 {
            font-size: 24px;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0 0 6px 0;
        }

        .page-header-left h1 i {
            color: var(--rose);
        }

        .page-header-left p {
            font-size: 14px;
            color: #64748b;
            margin: 0;
        }

        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }

        .wishlist-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            position: relative;
        }

        .wishlist-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -4px rgba(0, 0, 0, 0.08);
            border-color: #cbd5e1;
        }

        .btn-remove-wishlist {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #e2e8f0;
            color: var(--rose);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 5;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .btn-remove-wishlist:hover {
            background: var(--rose);
            color: #ffffff;
            transform: scale(1.1);
        }

        .card-img-wrap {
            position: relative;
            width: 100%;
            padding-top: 75%;
            background: #f8fafc;
            overflow: hidden;
        }

        .card-img-wrap img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: contain;
            padding: 16px;
            transition: transform 0.3s;
        }

        .wishlist-card:hover .card-img-wrap img {
            transform: scale(1.05);
        }

        .card-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .card-brand {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--primary);
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .card-title {
            font-size: 15px;
            font-weight: 600;
            color: #0f172a;
            line-height: 1.4;
            height: 42px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            margin-bottom: 12px;
            text-decoration: none;
        }

        .card-title:hover {
            color: var(--primary);
        }

        .card-price-row {
            margin-top: auto;
            display: flex;
            align-items: baseline;
            gap: 8px;
            margin-bottom: 16px;
        }

        .card-price {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
        }

        .card-stock {
            font-size: 12px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-bottom: 12px;
            width: fit-content;
        }

        .stock-in {
            background: #dcfce7;
            color: #166534;
        }

        .stock-out {
            background: #fee2e2;
            color: #991b1b;
        }

        .card-actions {
            display: flex;
            gap: 10px;
        }

        .btn-view-detail {
            flex: 1;
            padding: 10px 14px;
            background: #0f172a;
            color: #ffffff;
            text-align: center;
            border-radius: 10px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-view-detail:hover {
            background: var(--primary);
        }

        .empty-wishlist {
            text-align: center;
            background: #ffffff;
            padding: 60px 20px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--card-shadow);
        }

        .empty-wishlist i {
            font-size: 64px;
            color: #cbd5e1;
            margin-bottom: 18px;
        }

        .empty-wishlist h3 {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .empty-wishlist p {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 24px;
        }

        .btn-browse {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: var(--primary);
            color: #ffffff;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            transition: background 0.2s;
        }

        .btn-browse:hover {
            background: var(--primary-hover);
        }

        /* Toast notification */
        #toast-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 9999;
        }

        .toast-msg {
            background: #0f172a;
            color: #ffffff;
            padding: 14px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes slideIn {
            from { transform: translateY(100%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
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
                        <a href="${pageContext.request.contextPath}/ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                    </c:if>
                </c:forEach>
                <div class="nav-dropdown">
                    <span class="dropdown-btn">Phụ kiện khác <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                    <div class="dropdown-content">
                        <c:forEach items="${categories}" var="cat">
                            <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                <a href="${pageContext.request.contextPath}/ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/news">Tin tức & Khuyến mãi</a>
            </nav>
            <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                <form action="${pageContext.request.contextPath}/ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                    <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                    <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                </form>
                
                <!-- Wishlist Icon -->
                <a href="${pageContext.request.contextPath}/wishlist" class="wishlist-icon-btn" style="position: relative; color: #e11d48;" title="Sản phẩm yêu thích">
                    <i class="fas fa-heart" style="font-size: 18px;"></i>
                    <span id="wishlist-badge" class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #e11d48; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: ${wishlistCount > 0 ? 'flex' : 'none'}; align-items: center; justify-content: center; line-height: 1;">${wishlistCount}</span>
                </a>

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
                            <a href="#" class="user-menu-trigger" onclick="toggleUserDropdown(event)" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatarUrl}">
                                        <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}" alt="avatar" style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid #e2e8f0;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span style="font-size: 13px; font-weight: 500;">${sessionScope.user.userName}</span>
                            </a>
                            <div id="userDropdownMenu" class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 160px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                <a href="${pageContext.request.contextPath}/profile" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;"><i class="fas fa-id-card" style="margin-right:8px;"></i>Trang cá nhân</a>

                                <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;"><i class="fas fa-sign-out-alt" style="margin-right:8px;"></i>Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" style="font-size: 14px; font-weight: 500; text-decoration: none; color: #1e293b;"><i class="fas fa-user"></i> Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="wishlist-container">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/HomeServlet"><i class="fas fa-home"></i> Trang chủ</a>
            <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
            <span>Sản phẩm yêu thích</span>
        </div>

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-left">
                <h1><i class="fas fa-heart"></i> Sản Phẩm Yêu Thích</h1>
                <p>Danh sách các sản phẩm bạn đã lưu để theo dõi và xem lại bất cứ lúc nào.</p>
            </div>
            <div style="font-size: 14px; font-weight: 600; background: #fff1f2; color: #e11d48; padding: 8px 16px; border-radius: 20px; border: 1px solid #ffe4e6;">
                <span id="header-count">${wishlistCount}</span> sản phẩm
            </div>
        </div>

        <!-- Wishlist List -->
        <c:choose>
            <c:when test="${not empty wishlistItems && fn:length(wishlistItems) > 0}">
                <div class="wishlist-grid" id="wishlist-grid">
                    <c:forEach items="${wishlistItems}" var="item">
                        <div class="wishlist-card" id="card-item-${item.productId}">
                            <!-- Remove Button -->
                            <button type="button" class="btn-remove-wishlist" title="Bỏ yêu thích" onclick="removeWishlistItem(${item.productId})">
                                <i class="fas fa-heart-broken"></i>
                            </button>

                            <!-- Image -->
                            <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${item.productId}" class="card-img-wrap">
                                <c:choose>
                                    <c:when test="${not empty item.thumbnail}">
                                        <img src="${pageContext.request.contextPath}/images/${item.thumbnail}" alt="${item.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/default-laptop.jpg" alt="${item.productName}">
                                    </c:otherwise>
                                </c:choose>
                            </a>

                            <!-- Card Body -->
                            <div class="card-body">
                                <span class="card-brand">${item.brandName != null ? item.brandName : 'UNILAP'}</span>
                                <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${item.productId}" class="card-title" title="${item.productName}">
                                    ${item.productName}
                                </a>

                                <div class="card-price-row">
                                    <span class="card-price">
                                        <c:choose>
                                            <c:when test="${item.price > 0}">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                            </c:when>
                                            <c:otherwise>Liên hệ</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="card-stock ${item.stockQuantity > 0 ? 'stock-in' : 'stock-out'}">
                                    <i class="fas ${item.stockQuantity > 0 ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                    ${item.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                                </div>

                                <div class="card-actions">
                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${item.productId}" class="btn-view-detail">
                                        <i class="fas fa-eye"></i> Xem Chi Tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-wishlist">
                    <i class="far fa-heart"></i>
                    <h3>Danh sách yêu thích trống</h3>
                    <p>Bạn chưa lưu sản phẩm nào vào danh sách yêu thích. Hãy khám phá ngay các mẫu laptop mới nhất!</p>
                    <a href="${pageContext.request.contextPath}/ProductListServlet" class="btn-browse">
                        <i class="fas fa-laptop"></i> Khám Phá Sản Phẩm
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="toast-container"></div>

    <%@ include file="_footer.jspf" %>

    <script>
        function toggleUserDropdown(e) {
            e.preventDefault();
            var menu = document.getElementById("userDropdownMenu");
            if (menu) {
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            }
        }

        window.addEventListener("click", function(e) {
            var trigger = document.querySelector(".user-menu-trigger");
            var menu = document.getElementById("userDropdownMenu");
            if (menu && trigger && !trigger.contains(e.target) && !menu.contains(e.target)) {
                menu.style.display = "none";
            }
        });

        function removeWishlistItem(productId) {
            if (!confirm("Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?")) {
                return;
            }

            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: 'action=remove&productId=' + productId
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    var card = document.getElementById('card-item-' + productId);
                    if (card) {
                        card.style.transition = 'all 0.3s ease';
                        card.style.opacity = '0';
                        card.style.transform = 'scale(0.9)';
                        setTimeout(function() {
                            card.remove();
                            updateWishlistHeaderCount(data.count);
                            
                            // If zero items remain, reload to show empty state
                            var remainingGrid = document.getElementById('wishlist-grid');
                            if (remainingGrid && remainingGrid.children.length === 0) {
                                location.reload();
                            }
                        }, 300);
                    }
                    showToast("Đã xóa sản phẩm khỏi danh sách yêu thích");
                } else {
                    alert(data.message || "Có lỗi xảy ra");
                }
            })
            .catch(err => {
                console.error("Remove wishlist error:", err);
            });
        }

        function updateWishlistHeaderCount(count) {
            var headerCountSpan = document.getElementById('header-count');
            var badgeSpan = document.getElementById('wishlist-badge');

            if (headerCountSpan) headerCountSpan.innerText = count;
            if (badgeSpan) {
                badgeSpan.innerText = count;
                badgeSpan.style.display = count > 0 ? 'flex' : 'none';
            }
        }

        function showToast(msg) {
            var container = document.getElementById("toast-container");
            var toast = document.createElement("div");
            toast.className = "toast-msg";
            toast.innerHTML = '<i class="fas fa-check-circle" style="color:#22c55e;"></i> ' + msg;
            container.appendChild(toast);
            setTimeout(function() {
                toast.style.opacity = "0";
                toast.style.transition = "opacity 0.3s ease";
                setTimeout(function() { toast.remove(); }, 300);
            }, 2500);
        }
    </script>
</body>
</html>

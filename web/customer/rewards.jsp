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
    <title>Đổi Điểm Thưởng & Voucher - UniLap</title>
    <meta name="description" content="Tích điểm đổi voucher ưu đãi giảm giá độc quyền tại UniLap.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=10">
    <style>
        :root {
            --primary: #2563eb;
            --amber: #f59e0b;
            --bg-gray: #f8fafc;
            --card-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
        }

        body {
            background-color: var(--bg-gray);
            font-family: 'Inter', sans-serif;
            color: #1e293b;
        }

        .rewards-container {
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
        }

        .breadcrumb a:hover {
            color: var(--primary);
        }

        /* Hero Points Banner */
        .points-hero-card {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #ffffff;
            border-radius: 20px;
            padding: 32px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 36px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.15);
            position: relative;
            overflow: hidden;
        }

        .points-hero-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(245, 158, 11, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }

        .points-hero-left h1 {
            font-size: 26px;
            font-weight: 700;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .points-hero-left p {
            font-size: 14px;
            color: #94a3b8;
            margin: 0;
            max-width: 500px;
            line-height: 1.5;
        }

        .points-hero-right {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            padding: 18px 30px;
            border-radius: 16px;
            text-align: right;
        }

        .points-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #cbd5e1;
            margin-bottom: 4px;
            font-weight: 600;
        }

        .points-value {
            font-size: 36px;
            font-weight: 800;
            color: var(--amber);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
        }

        /* Section Title */
        .section-title-wrap {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .section-title-wrap h2 {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Rewards Grid */
        .rewards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 48px;
        }

        .reward-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 24px;
            display: flex;
            flex-direction: column;
            box-shadow: var(--card-shadow);
            transition: transform 0.25s, box-shadow 0.25s;
            position: relative;
        }

        .reward-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -4px rgba(0, 0, 0, 0.08);
            border-color: #cbd5e1;
        }

        .reward-badge {
            background: #fef3c7;
            color: #b45309;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            width: fit-content;
            margin-bottom: 14px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .reward-title {
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .reward-desc {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .reward-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top: 1px dashed #e2e8f0;
            padding-top: 16px;
        }

        .reward-cost {
            font-size: 16px;
            font-weight: 700;
            color: var(--amber);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .btn-redeem {
            padding: 10px 18px;
            background: var(--primary);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-redeem:hover {
            background: #1d4ed8;
            transform: scale(1.02);
        }

        .btn-redeem:disabled {
            background: #e2e8f0;
            color: #94a3b8;
            cursor: not-allowed;
            transform: none;
        }

        /* My Vouchers Section */
        .my-vouchers-wrap {
            background: #ffffff;
            border-radius: 16px;
            padding: 28px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--card-shadow);
        }

        .my-vouchers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .my-voucher-ticket {
            border: 1.5px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 12px;
            padding: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .my-voucher-code {
            font-family: monospace;
            font-size: 16px;
            font-weight: 700;
            color: var(--primary);
            background: #eff6ff;
            padding: 4px 10px;
            border-radius: 6px;
            display: inline-block;
            margin-bottom: 6px;
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
            </nav>
            <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                <a href="${pageContext.request.contextPath}/rewards" style="text-decoration:none; color:#f59e0b; font-weight:700; font-size:14px; display:flex; align-items:center; gap:4px; background:#fffbe8; padding:6px 12px; border-radius:20px; border:1px solid #fef08a;">
                    <i class="fas fa-star"></i> <span id="nav-user-points">${userPoints}</span> Điểm
                </a>
                <a href="${pageContext.request.contextPath}/wishlist" class="wishlist-icon-btn" style="position: relative; color: #e11d48;" title="Sản phẩm yêu thích">
                    <i class="fas fa-heart" style="font-size: 18px;"></i>
                </a>
                <a href="${pageContext.request.contextPath}/CartServlet" class="cart-icon-btn" style="position: relative;">
                    <i class="fas fa-shopping-cart"></i>
                    <c:if test="${not empty sessionScope.cart && fn:length(sessionScope.cart) > 0}">
                        <span class="cart-badge" style="position: absolute; top: -8px; right: -8px; background: #2563eb; color: #fff; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1;">${fn:length(sessionScope.cart)}</span>
                    </c:if>
                </a>
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
                                <a href="${pageContext.request.contextPath}/rewards" style="color: #f59e0b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px; font-weight: 600;"><i class="fas fa-star" style="margin-right:8px;"></i>Kho điểm thưởng</a>

                                <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;"><i class="fas fa-sign-out-alt" style="margin-right:8px;"></i>Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Content -->
    <div class="rewards-container">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/HomeServlet"><i class="fas fa-home"></i> Trang chủ</a>
            <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
            <span>Kho điểm thưởng & Đổi Voucher</span>
        </div>

        <!-- Points Hero Banner -->
        <div class="points-hero-card">
            <div class="points-hero-left">
                <h1><i class="fas fa-crown" style="color: var(--amber);"></i> Khách Hàng Thân Thiết UniLap</h1>
                <p>Tích lũy điểm thưởng từ mỗi đơn hàng hoàn thành (10.000đ = 1 điểm). Dùng điểm đổi lấy các Voucher giảm giá trực tiếp cực hấp dẫn!</p>
            </div>
            <div class="points-hero-right">
                <div class="points-label">Điểm Thưởng Hiện Có</div>
                <div class="points-value">
                    <i class="fas fa-star"></i> <span id="current-points-display">${userPoints}</span>
                </div>
            </div>
        </div>

        <!-- Section 1: Redeem Voucher Catalog -->
        <div class="section-title-wrap">
            <h2><i class="fas fa-gift" style="color: var(--primary);"></i> Gói Voucher Có Thể Đổi</h2>
        </div>

        <div class="rewards-grid">
            <c:forEach items="${rewardOptions}" var="option">
                <div class="reward-card">
                    <div class="reward-badge">
                        <i class="fas fa-tags"></i> Ưu đãi đặc biệt
                    </div>
                    <div class="reward-title">${option.title}</div>
                    <div class="reward-desc">${option.description}</div>
                    
                    <div class="reward-footer">
                        <div class="reward-cost">
                            <i class="fas fa-star"></i> ${option.pointsRequired} điểm
                        </div>
                        <button type="button" class="btn-redeem" 
                                ${userPoints < option.pointsRequired ? 'disabled' : ''}
                                onclick="redeemVoucherOption(${option.rewardVoucherId}, ${option.pointsRequired}, '${option.title}')">
                            ${userPoints >= option.pointsRequired ? 'Đổi Ngay' : 'Thiếu điểm'}
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Section 2: My Voucher Wallet -->
        <div class="my-vouchers-wrap">
            <div class="section-title-wrap" style="margin-bottom: 0;">
                <h2><i class="fas fa-wallet" style="color: #10b981;"></i> Ví Voucher Ưu Đãi Của Tôi</h2>
            </div>
            
            <c:choose>
                <c:when test="${not empty myVouchers && fn:length(myVouchers) > 0}">
                    <div class="my-vouchers-grid">
                        <c:forEach items="${myVouchers}" var="v">
                            <div class="my-voucher-ticket" style="opacity: ${v.used ? '0.6' : '1'};">
                                <div>
                                    <div class="my-voucher-code">${v.voucherCode}</div>
                                    <div style="font-size: 14px; font-weight: 700; color: #0f172a;">
                                        Giảm <fmt:formatNumber value="${v.discountValue}" pattern="#,##0"/>₫
                                    </div>
                                    <div style="font-size: 12px; color: #64748b; margin-top: 4px;">
                                        Đơn tối thiểu: <fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0"/>₫
                                    </div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${v.used}">
                                            <span style="font-size: 12px; font-weight: 700; color: #94a3b8; background: #e2e8f0; padding: 4px 10px; border-radius: 20px;">Đã sử dụng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 12px; font-weight: 700; color: #166534; background: #dcfce7; padding: 4px 10px; border-radius: 20px;">Khả dụng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #64748b; font-size: 14px; margin-top: 16px;">Bạn chưa đổi Voucher nào. Hãy chọn gói ưu đãi ở trên để đổi ngay!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div id="toast-container"></div>

    <%@ include file="_footer.jspf" %>

    <script>
        function toggleUserDropdown(e) {
            e.preventDefault();
            var menu = document.getElementById("userDropdownMenu");
            if (menu) menu.style.display = menu.style.display === "block" ? "none" : "block";
        }

        function redeemVoucherOption(rewardVoucherId, pointsRequired, title) {
            if (!confirm('Bạn có chắc chắn muốn dùng ' + pointsRequired + ' điểm thưởng để đổi "' + title + '" không?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/rewards', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: 'action=redeem&rewardVoucherId=' + rewardVoucherId
            })
            .then(r => r.json())
            .then(d => {
                if (d.status === 'success') {
                    showToast(d.message);
                    // Update points display
                    document.getElementById('current-points-display').innerText = d.newPoints;
                    document.getElementById('nav-user-points').innerText = d.newPoints;
                    setTimeout(function() {
                        location.reload();
                    }, 1200);
                } else {
                    alert(d.message || "Đổi Voucher thất bại!");
                }
            })
            .catch(err => console.error(err));
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

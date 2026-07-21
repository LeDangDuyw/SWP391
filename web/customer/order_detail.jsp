<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${order.orderCode} - UNILAP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --blue-900: #0f172a;
            --blue-800: #1e293b;
            --blue-700: #1e3a8a;
            --blue-600: #1d4ed8;
            --blue-500: #3b82f6;
            --blue-400: #60a5fa;
            --blue-100: #dbeafe;
            --blue-50:  #eff6ff;
            --gray-900: #111827;
            --gray-700: #374151;
            --gray-500: #6b7280;
            --gray-300: #d1d5db;
            --gray-200: #e5e7eb;
            --gray-100: #f3f4f6;
            --gray-50:  #f9fafb;
            --white:    #ffffff;
            --green-600:#16a34a;
            --green-100:#dcfce7;
            --red-600:  #dc2626;
            --red-100:  #fee2e2;
            --amber-600:#d97706;
            --amber-100:#fef3c7;
            --sidebar-w: 260px;
            --radius:    12px;
            --shadow:    0 4px 24px rgba(0,0,0,0.08);
            --transition: 0.22s ease;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #e8edf5 0%, #f1f5fb 50%, #e4eaf4 100%);
            min-height: 100vh;
            color: var(--gray-900);
            display: flex;
            flex-direction: column;
        }

        /* ── HEADER ─────────────────────────────────────────────────── */
        .header {
            background: linear-gradient(90deg, #1a2744 0%, #1e3a8a 100%);
            padding: 0 40px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 200;
            box-shadow: 0 2px 16px rgba(0,0,0,0.25);
        }

        .logo {
            font-size: 22px;
            font-weight: 800;
            color: #fff;
            text-decoration: none;
            letter-spacing: 2px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .logo span { color: var(--blue-400); }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .header-user {
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(255,255,255,0.85);
            font-size: 14px;
        }

        .header-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: var(--blue-600);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 14px;
            overflow: hidden;
            border: 2px solid rgba(255,255,255,0.3);
        }

        .header-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* ── PAGE LAYOUT ─────────────────────────────────────────────── */
        .page-wrap {
            flex: 1;
            display: flex;
            max-width: 1100px;
            margin: 40px auto;
            width: 100%;
            padding: 0 20px;
            gap: 28px;
            align-items: flex-start;
        }

        /* ── SIDEBAR ─────────────────────────────────────────────────── */
        .sidebar {
            width: var(--sidebar-w);
            flex-shrink: 0;
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow);
            overflow: hidden;
            position: sticky;
            top: 88px;
        }

        .sidebar-profile {
            background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 100%);
            padding: 28px 20px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .sidebar-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid rgba(255,255,255,0.4);
            overflow: hidden;
            background: rgba(255,255,255,0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            color: rgba(255,255,255,0.8);
            font-size: 32px;
            transition: var(--transition);
        }

        .sidebar-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .sidebar-name {
            font-size: 15px;
            font-weight: 700;
            color: #fff;
            text-align: center;
            line-height: 1.3;
        }

        .sidebar-email {
            font-size: 12px;
            color: rgba(255,255,255,0.65);
            text-align: center;
            word-break: break-all;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .badge-admin    { background: #fef9c3; color: #854d0e; }
        .badge-staff    { background: #dcfce7; color: #166534; }
        .badge-customer { background: rgba(255,255,255,0.2); color: #fff; border: 1px solid rgba(255,255,255,0.3); }
        .badge-student  { background: #e0f2fe; color: #0369a1; }

        .sidebar-nav {
            padding: 12px 0;
        }

        .nav-label {
            padding: 8px 20px 4px;
            font-size: 10px;
            font-weight: 700;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: var(--gray-700);
            border-left: 3px solid transparent;
            transition: var(--transition);
            user-select: none;
            text-decoration: none;
        }

        .nav-item:hover {
            background: var(--blue-50);
            color: var(--blue-700);
            border-left-color: var(--blue-200);
        }

        .nav-item.active {
            background: var(--blue-50);
            color: var(--blue-600);
            border-left-color: var(--blue-600);
            font-weight: 600;
        }

        .nav-divider {
            height: 1px;
            background: var(--gray-200);
            margin: 12px 20px;
        }

        .nav-item.danger {
            color: var(--red-600);
        }
        .nav-item.danger:hover {
            background: var(--red-100);
        }

        /* ── CONTENT ─────────────────────────────────────────────────── */
        .content {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: var(--gray-500);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 4px;
            transition: var(--transition);
        }
        .breadcrumb:hover {
            color: var(--blue-600);
        }

        .card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow);
            overflow: hidden;
            padding: 24px;
        }

        .card-title-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1.5px solid var(--gray-200);
            padding-bottom: 14px;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .order-meta-info {
            font-size: 13px;
            color: var(--gray-500);
            margin-bottom: 20px;
        }

        .order-meta-info strong {
            color: var(--gray-800);
        }

        /* ── PRODUCT LIST ────────────────────────────────────────────── */
        .product-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px dashed var(--gray-200);
        }
        .product-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .product-info-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
            min-width: 0;
            flex: 1;
        }

        .product-img {
            width: 74px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid var(--gray-200);
            background: var(--gray-50);
            flex-shrink: 0;
        }

        .product-details {
            min-width: 0;
        }

        .product-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .product-variant {
            font-size: 12px;
            color: var(--gray-500);
            margin-bottom: 4px;
        }

        .product-price-qty {
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-800);
        }
        .product-price-qty span {
            font-size: 12px;
            color: var(--gray-500);
            font-weight: 400;
            margin-left: 6px;
        }

        .btn-action-right {
            flex-shrink: 0;
        }

        .btn-buy-again {
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 600;
            color: var(--red-600);
            background: #fff;
            border: 1.5px solid var(--red-600);
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .btn-buy-again:hover {
            background: var(--red-100);
        }

        /* ── LAYOUT GRID ────────────────────────────────────────────── */
        .info-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 20px;
        }

        .info-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow);
            padding: 24px;
            margin-bottom: 20px;
        }
        .info-card:last-child {
            margin-bottom: 0;
        }

        .info-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-title i {
            color: var(--blue-600);
        }

        .info-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
            font-size: 13px;
            color: var(--gray-700);
        }

        .info-list li {
            line-height: 1.5;
        }

        .info-list strong {
            color: var(--gray-900);
        }

        /* ── BILL TABLE ──────────────────────────────────────────────── */
        .bill-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            font-size: 13px;
            color: var(--gray-700);
        }

        .bill-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .bill-row.total-row {
            border-top: 1.5px solid var(--gray-200);
            padding-top: 14px;
            margin-top: 6px;
            font-size: 15px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .bill-row.total-row .price-total {
            color: var(--red-600);
            font-size: 17px;
            font-weight: 800;
        }

        .order-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-pending-order { background-color: #fef3c7; color: #d97706; }
        .badge-processing-order { background-color: #e0f2fe; color: #0369a1; }
        .badge-shipping-order { background-color: #e0e7ff; color: #4338ca; }
        .badge-delivered-order { background-color: #dcfce7; color: #166534; }
        .badge-cancelled-order { background-color: #fee2e2; color: #991b1b; }

        .footer {
            margin-top: auto;
            background: #1a202c;
            color: #a0aec0;
            padding: 20px 0;
            text-align: center;
            font-size: 13px;
            border-top: 1px solid #2d3748;
        }

        @media (max-width: 900px) {
            .page-wrap { grid-direction: column; flex-direction: column; gap: 20px; }
            .sidebar { width: 100%; position: static; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <!-- ── HEADER ─────────────────────────────────────────────────────── -->
    <header class="header">
        <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">
            UNI<span>LAP</span>
        </a>
        <div class="header-right">
            <div class="header-user">
                <div class="header-avatar">
                    <c:choose>
                        <c:when test="${not empty profileUser.avatarUrl}">
                            <img src="${pageContext.request.contextPath}/images/${profileUser.avatarUrl}" alt="avatar">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <span>${profileUser.userName}</span>
            </div>
        </div>
    </header>

    <!-- ── PAGE BODY ─────────────────────────────────────────────────── -->
    <div class="page-wrap">

        <!-- ── SIDEBAR ────────────────────────────────────────────────── -->
        <aside class="sidebar">
            <div class="sidebar-profile">
                <div class="sidebar-avatar">
                    <c:choose>
                        <c:when test="${not empty profileUser.avatarUrl}">
                            <img src="${pageContext.request.contextPath}/images/${profileUser.avatarUrl}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-name">${profileUser.userName}</div>
                <div class="sidebar-email">${profileUser.email}</div>
                <c:choose>
                    <c:when test="${profileUser.roleId == 1}">
                        <span class="role-badge badge-admin"><i class="fas fa-crown"></i> Quản trị viên</span>
                    </c:when>
                    <c:when test="${profileUser.roleId == 2}">
                        <span class="role-badge badge-staff"><i class="fas fa-user-tie"></i> Nhân viên</span>
                    </c:when>
                    <c:when test="${profileUser.roleId == 4}">
                        <span class="role-badge badge-student"><i class="fas fa-graduation-cap"></i> Sinh viên</span>
                    </c:when>
                    <c:otherwise>
                        <span class="role-badge badge-customer"><i class="fas fa-user"></i> Khách hàng</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-label">Tài khoản</div>
                <a href="${pageContext.request.contextPath}/profile#profile" class="nav-item" id="nav-profile">
                    <div class="nav-icon"><i class="fas fa-user-circle"></i></div>
                    Hồ sơ cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/profile#password" class="nav-item" id="nav-password">
                    <div class="nav-icon"><i class="fas fa-lock"></i></div>
                    Đổi mật khẩu
                </a>

                <c:if test="${profileUser.roleId == 3 || profileUser.roleId == 4}">
                    <div class="nav-label">Dịch vụ</div>
                    <a href="${pageContext.request.contextPath}/profile#warranty" class="nav-item" id="nav-warranty">
                        <div class="nav-icon"><i class="fas fa-shield-alt"></i></div>
                        Bảo hành
                    </a>
                    <a href="${pageContext.request.contextPath}/profile#orders" class="nav-item active" id="nav-orders">
                        <div class="nav-icon"><i class="fas fa-shopping-bag"></i></div>
                        Đơn hàng của tôi
                    </a>
<%--
                    <a href="${pageContext.request.contextPath}/profile#student-verify" class="nav-item" id="nav-student-verify">
                        <div class="nav-icon"><i class="fas fa-graduation-cap"></i></div>
                        Xác minh sinh viên
                    </a>
--%>
                </c:if>

                <div class="nav-divider"></div>
                <a href="${pageContext.request.contextPath}/logout" class="nav-item danger" id="nav-logout">
                    <div class="nav-icon"><i class="fas fa-sign-out-alt"></i></div>
                    Đăng xuất
                </a>
            </nav>
        </aside>

        <!-- ── CONTENT ─────────────────────────────────────────────────── -->
        <main class="content">
            <a href="${pageContext.request.contextPath}/profile#orders" class="breadcrumb">
                <i class="fas fa-chevron-left" style="font-size: 11px;"></i> Lịch sử mua hàng / Chi tiết đơn hàng
            </a>

            <!-- Card 1: Tổng quan -->
            <div class="card">
                <div class="card-title-bar">
                    <span class="card-title">Tổng quan</span>
                    <a href="#" style="font-size: 13px; color: var(--blue-600); text-decoration: none; font-weight: 600;"><i class="fas fa-file-invoice"></i> Xem hóa đơn VAT</a>
                </div>

                <div class="order-meta-info">
                    Đơn hàng: <strong>#${order.orderCode}</strong>
                    <span style="margin: 0 8px; color: var(--gray-300);">•</span>
                    Ngày đặt hàng: <strong>
                        <c:choose>
                            <c:when test="${not empty order.completedAt}">
                                ${order.completedAt.dayOfMonth}/${order.completedAt.monthValue}/${order.completedAt.year}
                            </c:when>
                            <c:otherwise>
                                10/07/2026
                            </c:otherwise>
                        </c:choose>
                    </strong>
                    <span style="margin: 0 8px; color: var(--gray-300);">•</span>
                    <c:choose>
                        <c:when test="${order.orderStatus == 'Pending'}">
                            <span class="order-badge badge-pending-order">Chờ xác nhận</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'processing'}">
                            <span class="order-badge badge-processing-order">Đang xử lý</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'shipped'}">
                            <span class="order-badge badge-shipping-order">Đang vận chuyển</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'delivered' || order.orderStatus == 'Completed'}">
                            <span class="order-badge badge-delivered-order">Đã nhận hàng</span>
                        </c:when>
                        <c:otherwise>
                            <span class="order-badge badge-cancelled-order">Đã huỷ</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Products Purchased -->
                <div class="products-list-wrap">
                    <c:set var="subtotal" value="0" />
                    <c:forEach items="${order.details}" var="item">
                        <c:set var="itemTotal" value="${item.quantity * item.unitPrice}" />
                        <c:set var="subtotal" value="${subtotal + itemTotal}" />
                        
                        <div class="product-item">
                            <div class="product-info-wrap">
                                <img src="${pageContext.request.contextPath}/images/${item.thumbnail}" 
                                     onerror="this.src='https://placehold.co/80x60/f1f5f9/94a3b8?text=UniLap'" 
                                     alt="product" class="product-img">
                                <div class="product-details">
                                    <h4 class="product-title" title="${item.productName}">${item.productName}</h4>
                                    <p class="product-variant">Phân loại: ${item.variantName}</p>
                                    <p style="font-size: 11px; color: var(--gray-500); margin-bottom: 2px;">Thời hạn bảo hành đến: 10/07/2027</p>
                                    <div class="product-price-qty">
                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/>₫
                                        <span>Số lượng: ${item.quantity}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="btn-action-right">
                                <a href="${pageContext.request.contextPath}/ProductListServlet" class="btn-buy-again">
                                    <i class="fas fa-redo" style="margin-right: 4px; font-size: 10px;"></i> Mua lại
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Card 2 & 3: Info Grid -->
            <div class="info-grid">
                <!-- Column Left: Khách hàng & Hỗ trợ -->
                <div>
                    <!-- Thông tin khách hàng -->
                    <div class="info-card">
                        <h4 class="info-title"><i class="fas fa-map-marker-alt"></i> Thông tin khách hàng</h4>
                        <ul class="info-list">
                            <li>Họ và tên: <strong>${order.shippingReceiver}</strong></li>
                            <li>Số điện thoại: <strong>${order.shippingPhone}</strong></li>
                            <li>Địa chỉ: <strong>${order.shippingAddress}</strong></li>
                            <li>Ghi chú: <strong>-</strong></li>
                        </ul>
                    </div>

                    <!-- Thông tin hỗ trợ -->
                    <div class="info-card">
                        <h4 class="info-title"><i class="fas fa-headset"></i> Thông tin hỗ trợ</h4>
                        <ul class="info-list">
                            <li>Địa chỉ cửa hàng: <strong>42/A10 Lê Trọng Tấn, X. An Khánh, H. Hoài Đức, Hà Nội</strong></li>
                            <li>Số điện thoại: <strong>02471210042</strong></li>
                            <li>
                                <a href="#" style="color: var(--blue-600); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;">
                                    <i class="fab fa-weixin" style="color: #0084ff;"></i> Liên hệ qua Zalo
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Column Right: Thanh toán -->
                <div>
                    <div class="info-card">
                        <h4 class="info-title"><i class="fas fa-credit-card"></i> Thông tin thanh toán</h4>
                        
                        <c:set var="discount" value="${subtotal + order.shippingFee - order.totalAmount}" />
                        <c:if var="isNeg" test="${discount < 0}">
                            <c:set var="discount" value="0" />
                        </c:if>
                        
                        <div class="bill-list">
                            <div class="bill-row">
                                <span>Tạm tính:</span>
                                <strong><fmt:formatNumber value="${subtotal}" pattern="#,##0"/>₫</strong>
                            </div>
                            <div class="bill-row">
                                <span>Phí vận chuyển:</span>
                                <strong><fmt:formatNumber value="${order.shippingFee}" pattern="#,##0"/>₫</strong>
                            </div>
                            <div class="bill-row">
                                <span>Giảm giá:</span>
                                <strong style="color: var(--red-600);">-<fmt:formatNumber value="${discount}" pattern="#,##0"/>₫</strong>
                            </div>
                            
                            <div class="bill-row total-row">
                                <span>Tổng thanh toán:</span>
                                <span class="price-total"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>₫</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- ── FOOTER ─────────────────────────────────────────────────────── -->
    <footer class="footer">
        <p>© 2026 UNILAP Precision Engineering. All rights reserved.</p>
    </footer></body>
</html>

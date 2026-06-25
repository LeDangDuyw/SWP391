<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Bảo vệ trang: chỉ cho customer (roleId = 3) truy cập
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Warranty Center – UNILAP</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: #f8fafc;
                color: #1e293b;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                line-height: 1.5;
            }

            /* ── Header (synced with home.jsp) ── */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .header {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid rgba(255,255,255,0.3);
                box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            }
            .header-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 70px;
            }
            .logo {
                font-size: 24px;
                font-weight: 800;
                color: #1a56db;
                letter-spacing: -0.5px;
                text-decoration: none;
            }
            .main-nav {
                display: flex;
                gap: 32px;
            }
            .main-nav a {
                font-weight: 500;
                color: #64748b;
                font-size: 15px;
                position: relative;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .main-nav a:hover, .main-nav a.active {
                color: #1a56db;
            }
            .main-nav a.active::after {
                content: '';
                position: absolute;
                bottom: -6px;
                left: 0;
                width: 100%;
                height: 2px;
                background-color: #1a56db;
                border-radius: 2px;
            }
            .header-icons {
                display: flex;
                gap: 20px;
                align-items: center;
            }
            .header-icons a {
                color: #1e293b;
                font-size: 18px;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .header-icons a:hover {
                color: #1a56db;
            }
            .nav-dropdown {
                position: relative;
                display: inline-block;
            }
            .nav-dropdown .dropdown-btn {
                display: flex;
                align-items: center;
                gap: 6px;
                cursor: pointer;
                font-weight: 500;
                color: #64748b;
                font-size: 15px;
                transition: all 0.3s ease;
                text-decoration: none;
            }
            .nav-dropdown:hover .dropdown-btn {
                color: #1a56db;
            }
            .dropdown-content {
                display: none;
                position: absolute;
                top: calc(100% + 5px);
                left: 50%;
                transform: translateX(-50%) translateY(10px);
                background-color: #ffffff;
                min-width: 180px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                z-index: 999;
                padding: 8px 0;
                opacity: 0;
                transition: all 0.2s ease;
            }
            .nav-dropdown:hover .dropdown-content {
                display: block;
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
            .dropdown-content a {
                display: block;
                padding: 10px 18px;
                color: #374151;
                font-size: 14px;
                text-decoration: none;
                transition: background 0.15s;
            }
            .dropdown-content a:hover {
                background: #f1f5f9;
                color: #1a56db;
            }

            /* ── Alerts ── */
            .alert {
                max-width: 860px;
                margin: 16px auto 0;
                padding: 0 24px;
                width: 100%;
            }
            .alert-success, .alert-error {
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 500;
            }
            .alert-success {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .alert-error   {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fca5a5;
            }

            /* ── Page Hero ── */
            .page-hero {
                text-align: center;
                padding: 48px 24px 36px;
            }
            .page-hero h1 {
                font-size: 32px;
                font-weight: 800;
                color: #111827;
                letter-spacing: -0.5px;
            }
            .page-hero p {
                margin-top: 10px;
                font-size: 15px;
                color: #6b7280;
                max-width: 440px;
                margin-left: auto;
                margin-right: auto;
                line-height: 1.6;
            }

            /* ── Cards Grid ── */
            .cards-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                max-width: 860px;
                margin: 0 auto;
                padding: 0 24px;
            }
            .card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 14px;
                padding: 24px;
                transition: box-shadow 0.2s;
            }
            .card:hover {
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }
            .card-icon-wrap {
                width: 44px;
                height: 44px;
                border-radius: 12px;
                background: #eff6ff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                margin-bottom: 14px;
            }
            .card h3 {
                font-size: 17px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
            }
            .card p {
                font-size: 13px;
                color: #6b7280;
                line-height: 1.55;
                margin-bottom: 18px;
            }

            /* Form fields */
            .field-group {
                display: flex;
                flex-direction: column;
                gap: 4px;
                margin-bottom: 12px;
            }
            .field-group label {
                font-size: 11px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .input-row {
                display: flex;
                gap: 8px;
            }

            input[type="text"], select, textarea {
                width: 100%;
                border: 1.5px solid #e5e7eb;
                border-radius: 8px;
                padding: 9px 12px;
                font-size: 13.5px;
                color: #374151;
                background: #fff;
                outline: none;
                transition: border-color 0.15s;
                font-family: inherit;
            }
            input[type="text"]:focus, select:focus, textarea:focus {
                border-color: #2563eb;
            }
            input::placeholder, textarea::placeholder {
                color: #9ca3af;
            }
            select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='none' stroke='%236b7280' stroke-width='2' viewBox='0 0 24 24'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                padding-right: 32px;
            }
            textarea {
                resize: vertical;
                min-height: 88px;
            }

            .btn {
                border: none;
                cursor: pointer;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 600;
                padding: 9px 18px;
                transition: all 0.15s;
            }
            .btn-primary {
                background: #2563eb;
                color: #fff;
            }
            .btn-primary:hover {
                background: #1d4ed8;
            }
            .btn-outline-primary {
                background: #fff;
                border: 1.5px solid #2563eb;
                color: #2563eb;
                width: 100%;
                padding: 9px 0;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-outline-primary:hover {
                background: #eff6ff;
            }

            /* ── Submit Claim Card ── */
            .claim-card {
                grid-column: 1 / -1;
            }
            .claim-card-inner {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .claim-form-fields {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .two-col {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            /* Submit button row */
            .submit-row {
                max-width: 860px;
                margin: 16px auto 0;
                padding: 0 24px;
                display: flex;
                justify-content: flex-end;
            }
            .btn-submit-claim {
                background: #2563eb;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 11px 28px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-submit-claim:hover {
                background: #1d4ed8;
            }

            /* ── Check Eligibility Result ── */
            .eligibility-result {
                margin-top: 12px;
                padding: 10px 14px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 500;
            }
            .eligibility-valid   {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .eligibility-invalid {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fca5a5;
            }

            /* ── Recent Activity ── */
            .recent-section {
                max-width: 860px;
                margin: 32px auto 0;
                padding: 0 24px;
            }
            .recent-section h3 {
                font-size: 17px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 14px;
            }

            .activity-table {
                width: 100%;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                overflow: hidden;
                border-collapse: collapse;
            }
            .activity-table th {
                text-align: left;
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                padding: 10px 20px;
                background: #fafafa;
                border-bottom: 1px solid #f0f2f5;
            }
            .activity-table td {
                padding: 13px 20px;
                font-size: 13.5px;
                border-bottom: 1px solid #f9fafb;
                vertical-align: middle;
            }
            .activity-table tr:last-child td {
                border-bottom: none;
            }
            .activity-table tr:hover td {
                background: #fafbff;
            }

            .claim-ref {
                font-size: 12.5px;
                font-weight: 600;
                color: #2563eb;
            }
            .claim-date {
                font-size: 11.5px;
                color: #9ca3af;
                margin-top: 1px;
            }

            /* Status badges */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 11.5px;
                font-weight: 600;
                white-space: nowrap;
            }
            .badge-PENDING    {
                background: #fef3c7;
                color: #92400e;
            }
            .badge-PROCESSING {
                background: #dbeafe;
                color: #1d4ed8;
            }
            .badge-APPROVED   {
                background: #d1fae5;
                color: #065f46;
            }
            .badge-REJECTED   {
                background: #fee2e2;
                color: #991b1b;
            }
            .badge-COMPLETED  {
                background: #f3f4f6;
                color: #374151;
            }
            .badge-CANCELLED  {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* Cancel form inline */
            .cancel-form {
                display: inline;
            }
            .btn-cancel-sm {
                background: none;
                border: 1px solid #ef4444;
                color: #ef4444;
                border-radius: 6px;
                padding: 4px 10px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.15s;
            }
            .btn-cancel-sm:hover {
                background: #fef2f2;
            }

            .btn-detail-sm {
                display: inline-block;
                padding: 4px 12px;
                background: #eff6ff;
                color: #2563eb;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
            }
            .btn-detail-sm:hover {
                background: #dbeafe;
            }

            .no-claims {
                text-align: center;
                color: #9ca3af;
                padding: 32px;
                font-size: 13.5px;
            }

            /* ── Footer (synced with home.jsp) ── */
            .footer {
                background-color: #f8fafc;
                padding: 60px 0 20px;
                border-top: 1px solid #e2e8f0;
                margin-top: auto;
            }
            .footer-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                margin-bottom: 40px;
            }
            .footer-logo {
                display: inline-block;
                margin-bottom: 16px;
                font-size: 24px;
                font-weight: 800;
                color: #1a56db;
                letter-spacing: -0.5px;
                text-decoration: none;
            }
            .footer-brand-desc {
                color: #64748b;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .footer-contact-info {
                margin-bottom: 20px;
            }
            .footer-contact-info p {
                color: #64748b;
                font-size: 13px;
                margin-bottom: 6px;
            }
            .footer-contact-info i {
                width: 18px;
                color: #1a56db;
                margin-right: 6px;
            }
            .social-icons {
                display: flex;
                gap: 12px;
            }
            .social-icons a {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #e2e8f0;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #1e293b;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .social-icons a:hover {
                background-color: #1a56db;
                color: white;
            }
            .footer-col h3 {
                font-size: 16px;
                margin-bottom: 20px;
                color: #1e293b;
            }
            .footer-col ul {
                list-style: none;
                padding: 0;
            }
            .footer-col ul li {
                margin-bottom: 12px;
            }
            .footer-col ul li a {
                color: #64748b;
                font-size: 14px;
                text-decoration: none;
                transition: color 0.3s ease;
            }
            .footer-col ul li a:hover {
                color: #1a56db;
            }
            .footer-bottom {
                text-align: center;
                padding-top: 20px;
                border-top: 1px solid #e2e8f0;
                color: #64748b;
                font-size: 13px;
            }
        </style>
    </head>
    <body>

        <!-- ════ HEADER (synced with home.jsp) ════ -->
        <header class="header">
            <div class="container header-container">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
                    <c:forEach items="${categories}" var="cat">
                        <c:if test="${cat.categoryId == 1 || cat.categoryId == 3 || cat.categoryId == 4}">
                            <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                        </c:if>
                    </c:forEach>
                    <div class="nav-dropdown">
                        <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                        <div class="dropdown-content">
                            <c:forEach items="${categories}" var="cat">
                                <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                    <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <a href="#">Khuyến mãi</a>
                </nav>
                <div class="header-icons" style="display:flex; align-items:center; gap:15px;">
                    <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="#"><i class="fas fa-shopping-cart"></i></a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 5px; text-decoration: none; color: inherit;">
                                    <i class="fas fa-user"></i>
                                    <span style="font-size: 13px; font-weight: 500; max-width: 90px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${sessionScope.user.userName}</span>
                                </a>
                                <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 150px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Admin</a>
                                        </c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            <a href="${pageContext.request.contextPath}/staff/inventory" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Staff</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <div style="border-top: 1px solid #f1f5f9; margin: 6px 0;"></div>
                                    <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px; font-weight: 500;">Đăng xuất</a>
                                </div>
                            </div>
                            <script>
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
                                        document.addEventListener('click', function () {
                                            document.querySelectorAll('.user-menu-dropdown-content').forEach(function (dropdown) {
                                                dropdown.style.display = 'none';
                                            });
                                        });
                                    });
                                })();
                            </script>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- ════ FLASH MESSAGES ════ -->
    <c:if test="${not empty param.msg}">
        <div class="alert">
            <c:choose>
                <c:when test="${param.msg == 'submitted'}">
                    <div class="alert-success">✅ Yêu cầu bảo hành đã được gửi thành công!</div>
                </c:when>
                <c:when test="${param.msg == 'cancelled'}">
                    <div class="alert-success">🗑️ Yêu cầu bảo hành đã được huỷ.</div>
                </c:when>
                <c:when test="${param.msg == 'updated'}">
                    <div class="alert-success">🔄 Trạng thái yêu cầu bảo hành đã được cập nhật.</div>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert">
            <div class="alert-error">⚠️ <c:out value="${errorMessage}"/></div>
        </div>
    </c:if>

    <!-- ════ HERO ════ -->
    <section class="page-hero">
        <h1>Warranty Center</h1>
        <p>Check eligibility, submit claims, and track the status of your UNILAP precision hardware. Fast, transparent, and reliable support.</p>
    </section>

    <!-- ════ TOP CARDS: Check Eligibility + Track Status ════ -->
    <div class="cards-grid">

        <!-- Check Eligibility -->
        <div class="card">
            <div class="card-icon-wrap">📋</div>
            <h3>Check Eligibility</h3>
            <p>Enter your device serial number to instantly verify your current warranty status and coverage details.</p>
            <form method="get" action="${pageContext.request.contextPath}/warranty">
                <input type="hidden" name="action" value="checkEligibility">
                <div class="field-group">
                    <label>Serial Number</label>
                    <div class="input-row">
                        <input type="text" name="serialNumber"
                               value="${fn:trim(param.serialNumber)}"
                               placeholder="e.g., UNL-2024-XXXX">
                        <button class="btn btn-primary" type="submit">Verify Now</button>
                    </div>
                </div>
            </form>
            <%-- Eligibility result (set by controller action=checkEligibility) --%>
            <c:if test="${not empty eligibilityResult}">
                <div class="eligibility-result ${eligibilityResult == 'VALID' ? 'eligibility-valid' : 'eligibility-invalid'}">
                    <c:choose>
                        <c:when test="${eligibilityResult == 'VALID'}">
                            ✅ Sản phẩm còn trong thời hạn bảo hành.
                        </c:when>
                        <c:otherwise>
                            ❌ ${eligibilityMessage}
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- Track Status by Claim ID -->
        <div class="card">
            <div class="card-icon-wrap">🚚</div>
            <h3>Track Status</h3>
            <p>Follow the progress of your active claims or hardware returns.</p>
            <form method="get" action="${pageContext.request.contextPath}/warranty">
                <input type="hidden" name="action" value="detail">
                <div class="field-group">
                    <label>Claim ID</label>
                    <input type="text" name="id" placeholder="Enter Claim ID (e.g., 42)">
                </div>
                <button class="btn-outline-primary" type="submit">Track Claim</button>
            </form>
        </div>

        <!-- ════ Submit a Claim (full-width) ════ -->
        <div class="card claim-card">
            <div class="card-icon-wrap">🔧</div>
            <h3>Submit a Claim</h3>
            <p>Experiencing an issue? Provide your serial number and details to help our technicians diagnose the problem quickly.</p>

            <form method="post" action="${pageContext.request.contextPath}/warranty"
                  id="submitClaimForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="submit">

                <div class="claim-card-inner">
                    <!-- Form fields -->
                    <div class="claim-form-fields">
                        <div class="two-col">
                            <div class="field-group">
                                <label>Serial Number <span style="color:#ef4444">*</span></label>
                                <input type="text" name="serialNumber"
                                       value="<c:out value="${serialNumber}"/>"
                                       placeholder="e.g., UNL-2024-XXXX"
                                       required maxlength="100">
                            </div>
                            <div class="field-group">
                                <label>Issue Title <span style="color:#ef4444">*</span></label>
                                <input type="text" name="title"
                                       value="<c:out value="${title}"/>"
                                       placeholder="e.g., Screen flickering"
                                       required maxlength="200">
                            </div>
                        </div>

                        <div class="field-group">
                            <label>Detailed Description <span style="color:#ef4444">*</span></label>
                            <textarea name="description"
                                      placeholder="Please describe the issue in detail..."
                                      required maxlength="2000"><c:out value="${description}"/></textarea>
                        </div>
                    </div>

                    <!-- Image upload: tối đa 5 ảnh, mỗi ảnh tối đa 5MB -->
                    <div class="field-group" style="margin-top:4px;">
                        <label>Ảnh đính kèm (tối đa 5 ảnh, mỗi ảnh ≤ 5MB)</label>
                        <div id="imageDropZone"
                             style="border:2px dashed #bfdbfe;border-radius:12px;
                                    padding:20px;text-align:center;cursor:pointer;
                                    background:#f8faff;transition:border-color .15s;">
                            <span style="font-size:24px;">📷</span>
                            <div style="font-size:13px;color:#374151;margin-top:6px;">
                                Nhấn để chọn ảnh hoặc kéo-thả vào đây
                            </div>
                            <div style="font-size:11.5px;color:#9ca3af;margin-top:2px;">
                                JPG, PNG, WEBP — tối đa 5 ảnh, mỗi ảnh ≤ 5MB
                            </div>
                            <input type="file" id="imageInput" name="images" multiple
                                   accept="image/jpeg,image/png,image/webp"
                                   style="display:none;">
                        </div>
                        <div id="imagePreview"
                             style="display:flex;flex-wrap:wrap;gap:8px;margin-top:10px;"></div>
                        <div id="imageError"
                             style="display:none;font-size:12.5px;color:#dc2626;margin-top:6px;"></div>
                    </div>
                </div>

                <!-- Submit button -->
                <div style="display:flex;justify-content:flex-end;margin-top:16px;">
                    <button type="submit" class="btn-submit-claim">Submit Claim Request</button>
                </div>
            </form>
        </div>

    </div><!-- end cards-grid -->

    <!-- ════ RECENT WARRANTY ACTIVITY ════ -->
    <section class="recent-section">
        <h3>Recent Warranty Activity</h3>
        <table class="activity-table">
            <thead>
                <tr>
                    <th>Claim ID / Date</th>
                    <th>Product</th>
                    <th>Issue Title</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty claims}">
                    <tr>
                        <td colspan="5" class="no-claims">
                            Bạn chưa có yêu cầu bảo hành nào.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="claim" items="${claims}">
                        <tr>
                            <td>
                                <div class="claim-ref">#${claim.claimId}</div>
                                <div class="claim-date">
                                    <fmt:formatDate value="${claim.createdAt}" pattern="MMM dd, yyyy"/>
                                </div>
                            </td>
                            <td>
                                <div style="font-size:13px;font-weight:500;"><c:out value="${claim.productName}"/></div>
                                <div style="font-size:11.5px;color:#9ca3af;">SN: <c:out value="${claim.serialNumber}"/></div>
                            </td>
                            <td style="font-size:13px;"><c:out value="${claim.title}"/></td>
                            <td>
                                <span class="badge badge-${claim.status}">${claim.status}</span>
                            </td>
                            <td style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
                                <a class="btn-detail-sm"
                                   href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}">
                                    View
                                </a>
                                <%-- Cancel chỉ hiện khi PENDING --%>
                        <c:if test="${claim.status == 'PENDING'}">
                            <form class="cancel-form"
                                  action="${pageContext.request.contextPath}/warranty"
                                  method="post"
                                  onsubmit="return confirm('Huỷ yêu cầu #${claim.claimId}?')">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="id"     value="${claim.claimId}">
                                <button type="submit" class="btn-cancel-sm">Cancel</button>
                            </form>
                        </c:if>
                        </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </section>

    <!-- ════ FOOTER (synced with home.jsp) ════ -->
    <%
        if (request.getAttribute("footerPages") == null) {
            try {
                dal.PageContentDAO pgDAO = new dal.PageContentDAO();
                java.util.ArrayList<model.PageContent> footerPagesList = pgDAO.getAllActivePages();
                request.setAttribute("footerPages", footerPagesList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <footer class="footer">
        <div class="container footer-grid">
            <div class="footer-col">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo footer-logo">UniLap</a>
                <p class="footer-brand-desc">Nền tảng mua sắm công nghệ cao cấp hàng đầu. Chúng tôi cam kết đem lại trải nghiệm mua sắm tuyệt vời nhất với các sản phẩm laptop, bàn phím và chuột máy tính chính hãng chất lượng cao.</p>
                <div class="footer-contact-info">
                    <p><i class="fas fa-map-marker-alt"></i> Mỹ Đình, Hà Nội</p>
                    <p><i class="fas fa-phone-alt"></i> Hotline: 1900 8888 (8:00 - 22:00)</p>
                    <p><i class="fas fa-envelope"></i> Email: support@unilap.vn</p>
                </div>
                <div class="social-icons">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h3>Chính sách & Hỗ trợ</h3>
                <ul>
                    <c:if test="${not empty footerPages}">
                        <c:forEach items="${footerPages}" var="pageItem">
                            <li><a href="${pageContext.request.contextPath}/page?key=${pageItem.pageKey}"><i class="fas fa-chevron-right"></i> ${pageItem.title}</a></li>
                        </c:forEach>
                    </c:if>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">
                <p>&copy; 2026 UniLap. Tất cả các quyền được bảo hộ.</p>
            </div>
        </div>
    </footer>
    <!-- ════ IMAGE UPLOAD SCRIPT ════ -->
    <script>
        (function () {
            var MAX_IMAGES = 5;
            var MAX_SIZE = 5 * 1024 * 1024; // 5MB
            var ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/jpg'];

            var dropZone = document.getElementById('imageDropZone');
            var fileInput = document.getElementById('imageInput');
            var preview = document.getElementById('imagePreview');
            var errorBox = document.getElementById('imageError');
            var form = document.getElementById('submitClaimForm');

            // Danh sách file đang chọn được quản lý ở phía client để hỗ trợ
            // xoá từng ảnh trước khi submit (input[type=file] không cho xoá
            // trực tiếp 1 phần tử trong FileList, nên dùng DataTransfer để
            // build lại danh sách rồi gán ngược vào input.files).
            var selectedFiles = [];

            dropZone.addEventListener('click', function () {
                fileInput.click();
            });

            dropZone.addEventListener('dragover', function (e) {
                e.preventDefault();
                dropZone.style.borderColor = '#2563eb';
            });
            dropZone.addEventListener('dragleave', function () {
                dropZone.style.borderColor = '#bfdbfe';
            });
            dropZone.addEventListener('drop', function (e) {
                e.preventDefault();
                dropZone.style.borderColor = '#bfdbfe';
                handleNewFiles(e.dataTransfer.files);
            });

            fileInput.addEventListener('change', function () {
                handleNewFiles(fileInput.files);
            });

            function showError(msg) {
                errorBox.textContent = msg;
                errorBox.style.display = 'block';
            }

            function clearError() {
                errorBox.style.display = 'none';
                errorBox.textContent = '';
            }

            function handleNewFiles(fileList) {
                clearError();
                var incoming = Array.prototype.slice.call(fileList);

                for (var i = 0; i < incoming.length; i++) {
                    var f = incoming[i];

                    if (selectedFiles.length >= MAX_IMAGES) {
                        showError('Chỉ được tải lên tối đa ' + MAX_IMAGES + ' ảnh.');
                        break;
                    }
                    if (ALLOWED_TYPES.indexOf(f.type) === -1) {
                        showError('Ảnh "' + f.name + '" không đúng định dạng (chỉ chấp nhận JPG, PNG, WEBP).');
                        continue;
                    }
                    if (f.size > MAX_SIZE) {
                        showError('Ảnh "' + f.name + '" vượt quá 5MB.');
                        continue;
                    }

                    selectedFiles.push(f);
                }

                syncInputFiles();
                renderPreview();
            }

            function removeFile(index) {
                selectedFiles.splice(index, 1);
                clearError();
                syncInputFiles();
                renderPreview();
            }

            // Gán lại selectedFiles vào input.files để khi submit, đúng các
            // file đã được giữ lại (sau khi remove) sẽ được gửi lên server.
            function syncInputFiles() {
                var dt = new DataTransfer();
                selectedFiles.forEach(function (f) {
                    dt.items.add(f);
                });
                fileInput.files = dt.files;
            }

            function renderPreview() {
                preview.innerHTML = '';
                selectedFiles.forEach(function (file, index) {
                    var reader = new FileReader();
                    var thumb = document.createElement('div');
                    thumb.style.position = 'relative';
                    thumb.style.width = '64px';
                    thumb.style.height = '64px';
                    thumb.style.borderRadius = '8px';
                    thumb.style.overflow = 'hidden';
                    thumb.style.border = '1px solid #e5e7eb';

                    reader.onload = function (e) {
                        var img = document.createElement('img');
                        img.src = e.target.result;
                        img.style.width = '100%';
                        img.style.height = '100%';
                        img.style.objectFit = 'cover';
                        thumb.appendChild(img);
                    };
                    reader.readAsDataURL(file);

                    var removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.textContent = '×';
                    removeBtn.style.position = 'absolute';
                    removeBtn.style.top = '2px';
                    removeBtn.style.right = '2px';
                    removeBtn.style.width = '18px';
                    removeBtn.style.height = '18px';
                    removeBtn.style.lineHeight = '16px';
                    removeBtn.style.border = 'none';
                    removeBtn.style.borderRadius = '50%';
                    removeBtn.style.background = 'rgba(0,0,0,0.6)';
                    removeBtn.style.color = '#fff';
                    removeBtn.style.fontSize = '12px';
                    removeBtn.style.cursor = 'pointer';
                    removeBtn.addEventListener('click', function () {
                        removeFile(index);
                    });
                    thumb.appendChild(removeBtn);

                    preview.appendChild(thumb);
                });
            }

            // Chặn submit lần cuối ở client nếu vượt giới hạn (phòng trường hợp
            // người dùng bypass UI, ví dụ chỉnh DOM). Server vẫn validate lại.
            form.addEventListener('submit', function (e) {
                if (selectedFiles.length > MAX_IMAGES) {
                    e.preventDefault();
                    showError('Chỉ được tải lên tối đa ' + MAX_IMAGES + ' ảnh.');
                }
            });
        })();
    </script>

</body>
</html>

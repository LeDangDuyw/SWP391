<%-- 
    Page: warranty_center.jsp
    Mo ta: Trang trung tâm bảo hành dành cho khách hàng.
    
    Created: 2026-06-22
    Updated: 2026-07-21
    Version: v2.4
    
    @author DuyLD
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Bảo vệ trang: chỉ cho customer (roleId = 3) truy cập
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
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

            /* ── Step 1 Verify Result (inline error / re-used eligibility styles) ── */
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

            /* ── Submit Claim Wizard (3 steps) ── */
            /* ── Submit Claim Wizard (3 steps, one visible at a time) ── */
            .wizard-card {
                max-width: 860px;
                margin: 0 auto;
                padding: 0 24px;
            }
            .wizard-steps {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 22px;
            }
            .wizard-step-indicator {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12.5px;
                font-weight: 600;
                color: #9ca3af;
            }
            .wizard-step-indicator .dot {
                width: 22px;
                height: 22px;
                border-radius: 50%;
                background: #f3f4f6;
                color: #9ca3af;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 11.5px;
            }
            .wizard-step-indicator.is-active .dot {
                background: #2563eb;
                color: #fff;
            }
            .wizard-step-indicator.is-active {
                color: #2563eb;
            }
            .wizard-step-indicator.is-done .dot {
                background: #16a34a;
                color: #fff;
            }
            .wizard-step-indicator.is-done {
                color: #16a34a;
            }
            .wizard-step-line {
                flex: 1;
                height: 1.5px;
                background: #e5e7eb;
            }
            .wizard-step-line.is-done {
                background: #16a34a;
            }

            /* Only one step panel visible at a time; JS toggles .is-visible */
            .wizard-step-panel {
                display: none;
            }
            .wizard-step-panel.is-visible {
                display: block;
            }

            /* ── Step 1: Product Picker Table ── */
            .product-pick-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 16px;
            }
            .product-pick-table th {
                text-align: left;
                font-size: 11px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                padding: 8px 10px;
                border-bottom: 1px solid #e5e7eb;
            }
            .product-pick-table td {
                padding: 11px 10px;
                font-size: 13px;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }
            .product-pick-row {
                cursor: pointer;
                transition: background 0.12s;
            }
            .product-pick-row:hover {
                background: #f8faff;
            }
            .product-pick-row.is-selected {
                background: #eff6ff;
            }
            .product-pick-radio {
                cursor: pointer;
                accent-color: #2563eb;
            }

            .verify-success {
                display: flex;
                align-items: center;
                gap: 8px;
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
                border-radius: 8px;
                padding: 10px 14px;
                font-size: 13px;
                font-weight: 600;
                margin-top: 14px;
                margin-bottom: 4px;
            }

            .warranty-info-box {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px;
                background: #f8faff;
                border: 1px solid #dbeafe;
                border-radius: 10px;
                padding: 16px 18px;
                margin-bottom: 4px;
            }
            .warranty-info-item label {
                display: block;
                font-size: 10.5px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 3px;
            }
            .warranty-info-item span {
                font-size: 13.5px;
                font-weight: 600;
                color: #111827;
            }

            .btn-change-serial {
                background: none;
                border: none;
                color: #2563eb;
                font-size: 12.5px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: underline;
                padding: 0;
                margin-bottom: 14px;
            }

            /* Step navigation row (Next / Back) */
            .wizard-nav-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 18px;
            }
            .btn-wizard-next {
                background: #2563eb;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 10px 22px;
                font-size: 13.5px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-wizard-next:hover {
                background: #1d4ed8;
            }
            .btn-wizard-next:disabled {
                background: #cbd5e1;
                cursor: not-allowed;
            }
            .btn-wizard-back {
                background: none;
                border: none;
                color: #6b7280;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                padding: 8px 4px;
            }
            .btn-wizard-back:hover {
                color: #374151;
            }

            /* ── Track Existing Claim (separate, below the wizard) ── */
            .track-claim-section {
                max-width: 860px;
                margin: 32px auto 0;
                padding: 0 24px;
            }
            .track-claim-card {
                max-width: 420px;
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
                        <span class="dropdown-btn">Phụ kiện khác <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
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
                                 <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: inherit;">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.avatarUrl}">
                                            <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}"
                                                 alt="avatar"
                                                 style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid #e2e8f0;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user"></i>
                                        </c:otherwise>
                                    </c:choose>
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
                                            <a href="${pageContext.request.contextPath}/profile" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
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

    <!-- ════ TOP TOGGLE BUTTONS ════ -->
    <div style="display:flex; justify-content:center; gap:12px; margin-top:28px; margin-bottom:8px;">
        <a href="${pageContext.request.contextPath}/warranty?action=center"
           style="display:inline-flex; align-items:center; gap:8px; padding:10px 22px; background:#2563eb; color:#ffffff; font-size:13.5px; font-weight:600; border-radius:10px; text-decoration:none; box-shadow:0 4px 12px rgba(37,99,235,0.25);">
            <i class="fas fa-plus-circle"></i> Gửi Yêu Cầu Bảo Hành Mới
        </a>
        <a href="${pageContext.request.contextPath}/warranty?action=list"
           style="display:inline-flex; align-items:center; gap:8px; padding:10px 22px; background:#ffffff; color:#475569; border:1px solid #e2e8f0; font-size:13.5px; font-weight:500; border-radius:10px; text-decoration:none; transition:all 0.15s;">
            <i class="fas fa-list-alt"></i> Danh Sách & Theo Dõi Bảo Hành
        </a>
    </div>

    <!-- ════ HERO ════ -->
    <section class="page-hero">
        <h1>Trung Tâm Bảo Hành</h1>
        <p>Kiểm tra điều kiện bảo hành, gửi yêu cầu và theo dõi tiến trình xử lý thiết bị của bạn. Hỗ trợ nhanh chóng, minh bạch và đáng tin cậy.</p>
    </section>

    <!-- ════ SUBMIT A CLAIM — WIZARD (3 steps, one step visible at a time) ════ -->
    <div class="wizard-card">
        <div class="card claim-card">
            <div class="card-icon-wrap">🔧</div>
            <h3>Gửi Yêu Cầu Bảo Hành</h3>
            <p>Sản phẩm gặp sự cố? Vui lòng chọn sản phẩm và mô tả sự cố để kỹ thuật viên của chúng tôi chẩn đoán nhanh chóng.</p>

            <!-- Step indicator -->
            <div class="wizard-steps" id="wizardStepsIndicator">
                <div class="wizard-step-indicator" data-step-indicator="1">
                    <span class="dot">1</span> Chọn Sản Phẩm
                </div>
                <div class="wizard-step-line" data-step-line="1"></div>
                <div class="wizard-step-indicator" data-step-indicator="2">
                    <span class="dot">2</span> Trạng Thái Bảo Hành
                </div>
                <div class="wizard-step-line" data-step-line="2"></div>
                <div class="wizard-step-indicator" data-step-indicator="3">
                    <span class="dot">3</span> Xác Nhận
                </div>
                <div class="wizard-step-line" data-step-line="3"></div>
                <div class="wizard-step-indicator" data-step-indicator="4">
                    <span class="dot">4</span> Mô Tả Lỗi
                </div>
            </div>

            <c:choose>
                <%-- ════════════════════════════════════════════════════════
                     Chưa chọn sản phẩm nào (hoặc verify thất bại) — chỉ
                     render Step 1 (danh sách sản phẩm đã mua). Step 2/3/4
                     cần dữ liệu eligibilityInfo nên chưa thể render — nếu
                     không render, JS không có gì để hiện ra dù người dùng
                     cố bypass bằng nút Next.
                     ════════════════════════════════════════════════════════ --%>
                <c:when test="${eligibilityResult != 'VALID'}">
                    <!-- ─ STEP 1: Select Product ─ -->
                    <div class="wizard-step-panel is-visible" data-step-panel="1">
                        <c:if test="${eligibilityResult == 'INVALID'}">
                            <div class="eligibility-result eligibility-invalid" style="margin-top:0;margin-bottom:14px;">
                                ❌ <c:out value="${eligibilityMessage}"/>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${empty purchasedProducts}">
                                <div class="no-claims" style="padding:24px 0;">
                                    Bạn chưa có sản phẩm nào đã mua để yêu cầu bảo hành.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="product-pick-table">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Sản phẩm</th>
                                            <th>Ngày mua</th>
                                            <th>Thời hạn bảo hành</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${purchasedProducts}">
                                            <%-- Mỗi serial là 1 dòng riêng — kể cả khi 2 máy cùng model
                                                 trong cùng 1 đơn hàng, vì mỗi máy có warranty/claim
                                                 state độc lập (BR15-BR18 áp dụng theo từng serial). --%>
                                            <tr class="product-pick-row" data-serial="<c:out value="${item.serialNumber}"/>">
                                                <td>
                                                    <input type="radio" name="serialNumberRadio"
                                                           class="product-pick-radio"
                                                           value="<c:out value="${item.serialNumber}"/>">
                                                </td>
                                                <td>
                                                    <div style="font-size:13px;font-weight:600;color:#111827;"><c:out value="${item.productName}"/></div>
                                                    <div style="font-size:11.5px;color:#9ca3af;">SN: <c:out value="${item.serialNumber}"/></div>
                                                </td>
                                                <td style="font-size:13px;">
                                                    <fmt:formatDate value="${item.purchaseDate}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.underWarranty}">
                                                            <span class="badge badge-APPROVED">Còn bảo hành</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-REJECTED">Hết hạn bảo hành</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <%-- Form GET thật, submit khi bấm "Verify" sau khi chọn 1 dòng.
                                     serialNumberRadio được JS đồng bộ vào hidden input bên dưới
                                     khi người dùng click vào dòng. --%>
                                <form method="get" action="${pageContext.request.contextPath}/warranty"
                                      id="selectProductForm">
                                    <input type="hidden" name="action" value="checkEligibility">
                                    <input type="hidden" name="serialNumber" id="selectedSerialInput" value="">
                                    <div class="wizard-nav-row" style="justify-content:flex-end;">
                                        <button type="submit" class="btn-wizard-next" id="selectProductNextBtn" disabled>Tiếp theo</button>
                                    </div>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <%-- ════════════════════════════════════════════════════════
                     Sản phẩm đã được chọn và verify thành công (1 GET request
                     tới server). Step 2/3/4 đã có sẵn data ở đây — chuyển
                     giữa các step từ thời điểm này là show/hide bằng JS
                     thuần (không AJAX), KHÔNG round-trip lại server.
                     Form Step 4 vẫn là form POST duy nhất, submit 1 lần.
                     ════════════════════════════════════════════════════════ --%>
                <c:otherwise>
                    <!-- ─ STEP 1 panel (kept in DOM so "Back" can return to it without re-verifying) ─ -->
                    <div class="wizard-step-panel" data-step-panel="1">
                        <div class="field-group" style="max-width:420px;">
                            <label>Sản phẩm đã chọn</label>
                            <div class="input-row">
                                <input type="text" value="<c:out value="${eligibilityInfo.productName}"/> (SN: <c:out value="${eligibilityInfo.serialNumber}"/>)" disabled>
                            </div>
                        </div>
                        <div class="verify-success">✓ Đã xác thực sản phẩm</div>

                        <!-- Cho phép chọn lại sản phẩm khác — đây vẫn là round-trip GET thật -->
                        <form method="get" action="${pageContext.request.contextPath}/warranty" style="display:inline;">
                            <input type="hidden" name="action" value="checkEligibility">
                            <input type="hidden" name="serialNumber" value="">
                            <button type="submit" class="btn-change-serial">← Chọn sản phẩm khác</button>
                        </form>

                        <div class="wizard-nav-row" style="justify-content:flex-end;">
                            <button type="button" class="btn-wizard-next" data-go-to-step="2">Tiếp theo</button>
                        </div>
                    </div>

                    <!-- ─ STEP 2: Warranty Status (còn hạn / hết hạn) ─ -->
                    <div class="wizard-step-panel" data-step-panel="2">
                        <div class="warranty-info-box">
                            <div class="warranty-info-item">
                                <label>Sản phẩm</label>
                                <span><c:out value="${eligibilityInfo.productName}"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Số Serial</label>
                                <span><c:out value="${eligibilityInfo.serialNumber}"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Gói bảo hành</label>
                                <span><c:out value="${eligibilityInfo.coverageName}"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Trạng thái bảo hành</label>
                                <%-- Tới được Step 2 nghĩa là checkEligibility() đã pass
                                     isUnderWarranty() ở server rồi, nên luôn là "còn hạn"
                                     tại đây — nhánh "hết hạn" chỉ xảy ra ở Step 1 nếu khách
                                     chọn 1 sản phẩm hiển thị badge "Hết hạn bảo hành": khi đó
                                     server trả INVALID và khách bị giữ lại Step 1 (xem nhánh
                                     c:when ở trên), không bao giờ tới được Step 2. --%>
                                <span style="color:#16a34a;">✓ Còn bảo hành đến <fmt:formatDate value="${eligibilityInfo.warrantyExpiry}" pattern="dd/MM/yyyy"/></span>
                            </div>
                        </div>

                        <div class="wizard-nav-row">
                            <button type="button" class="btn-wizard-back" data-go-to-step="1">← Quay lại</button>
                            <button type="button" class="btn-wizard-next" data-go-to-step="3">Tiếp theo</button>
                        </div>
                    </div>

                    <!-- ─ STEP 3: Confirm — "Bạn có muốn bảo hành sản phẩm này?" ─ -->
                    <div class="wizard-step-panel" data-step-panel="3">
                        <p style="font-size:14px;font-weight:600;color:#111827;margin-bottom:14px;">
                            Bạn có muốn gửi yêu cầu bảo hành cho sản phẩm này?
                        </p>
                        <div class="warranty-info-box">
                            <div class="warranty-info-item">
                                <label>Sản phẩm</label>
                                <span><c:out value="${eligibilityInfo.productName}"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Số Serial</label>
                                <span><c:out value="${eligibilityInfo.serialNumber}"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Hạn bảo hành</label>
                                <span><fmt:formatDate value="${eligibilityInfo.warrantyExpiry}" pattern="dd/MM/yyyy"/></span>
                            </div>
                            <div class="warranty-info-item">
                                <label>Gói bảo hành</label>
                                <span><c:out value="${eligibilityInfo.coverageName}"/></span>
                            </div>
                        </div>

                        <div class="wizard-nav-row">
                            <button type="button" class="btn-wizard-back" data-go-to-step="2">← Không, quay lại</button>
                            <button type="button" class="btn-wizard-next" data-go-to-step="4">Có, tiếp tục</button>
                        </div>
                    </div>

                    <!-- ─ STEP 4: Describe Issue (the only form that actually submits) ─ -->
                    <div class="wizard-step-panel" data-step-panel="4">
                        <form method="post" action="${pageContext.request.contextPath}/warranty"
                              id="submitClaimForm" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="submit">
                            <input type="hidden" name="serialNumber" value="<c:out value="${eligibilityInfo.serialNumber}"/>">

                            <div class="claim-card-inner">
                                <!-- Form fields -->
                                <div class="claim-form-fields">
                                    <div class="field-group">
                                        <label>Tiêu đề lỗi <span style="color:#ef4444">*</span></label>
                                        <input type="text" name="title"
                                               value="<c:out value="${title}"/>"
                                               placeholder="Ví dụ: Màn hình bị nhấp nháy, sọc màn hình..."
                                               required maxlength="200">
                                    </div>

                                    <div class="field-group">
                                        <label>Mô tả chi tiết <span style="color:#ef4444">*</span></label>
                                        <textarea name="description"
                                                  placeholder="Vui lòng mô tả chi tiết lỗi bạn gặp phải..."
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

                            <div class="wizard-nav-row">
                                <button type="button" class="btn-wizard-back" data-go-to-step="3">← Quay lại</button>
                                <button type="submit" class="btn-submit-claim" id="submitClaimBtn">Gửi yêu cầu bảo hành</button>
                            </div>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ════ FOOTER ════ -->
    <%@include file="_footer.jspf" %>
    <!-- ════ STEP 1 PRODUCT PICKER SCRIPT ════ -->
    <script>
        (function () {
            var rows = document.querySelectorAll('.product-pick-row');
            var hiddenInput = document.getElementById('selectedSerialInput');
            var nextBtn = document.getElementById('selectProductNextBtn');

            // Không có gì để chọn khi danh sách rỗng hoặc đã qua Step 1.
            if (rows.length === 0 || !hiddenInput || !nextBtn) {
                return;
            }

            function selectRow(row) {
                rows.forEach(function (r) {
                    r.classList.remove('is-selected');
                });
                row.classList.add('is-selected');

                var radio = row.querySelector('.product-pick-radio');
                radio.checked = true;

                hiddenInput.value = row.getAttribute('data-serial');
                nextBtn.disabled = false;
            }

            rows.forEach(function (row) {
                // Click bất kỳ đâu trên dòng đều chọn dòng đó, không chỉ
                // bấm trúng vào radio — đúng UX "bấm vào 1 sản phẩm".
                row.addEventListener('click', function () {
                    selectRow(row);
                });

                var radio = row.querySelector('.product-pick-radio');
                radio.addEventListener('click', function (e) {
                    // Tránh double-toggle khi click trực tiếp lên radio
                    // (event bubble lên row đã xử lý rồi).
                    e.stopPropagation();
                    selectRow(row);
                });
            });
        })();
    </script>

    <!-- ════ WIZARD STEP NAVIGATION SCRIPT ════ -->
    <script>
        (function () {
            var panels = document.querySelectorAll('[data-step-panel]');
            var indicators = document.querySelectorAll('[data-step-indicator]');
            var lines = document.querySelectorAll('[data-step-line]');
            var nextBackButtons = document.querySelectorAll('[data-go-to-step]');

            // Trang này chỉ render các panel khi đã có dữ liệu cho chúng:
            // nếu chưa verify, chỉ panel Step 1 tồn tại trong DOM nên không
            // có gì để JS điều hướng tới — script tự thoát an toàn.
            if (panels.length === 0) {
                return;
            }

            // Step bắt đầu: nếu verify đã thành công (panel 2 và 3 tồn tại),
            // bắt đầu ở Step 1 (đã verify) để người dùng thấy "✓ Product
            // verified" trước khi tự bấm Next — không tự nhảy thẳng tới
            // Step 2, tránh gây bối rối khi vừa quay lại trang.
            var currentStep = 1;

            function showStep(stepNumber) {
                panels.forEach(function (panel) {
                    var isTarget = panel.getAttribute('data-step-panel') === String(stepNumber);
                    panel.classList.toggle('is-visible', isTarget);
                });

                indicators.forEach(function (ind) {
                    var stepOfIndicator = parseInt(ind.getAttribute('data-step-indicator'), 10);
                    ind.classList.remove('is-active', 'is-done');
                    if (stepOfIndicator === stepNumber) {
                        ind.classList.add('is-active');
                    } else if (stepOfIndicator < stepNumber) {
                        ind.classList.add('is-done');
                    }
                });

                lines.forEach(function (line) {
                    var stepOfLine = parseInt(line.getAttribute('data-step-line'), 10);
                    line.classList.toggle('is-done', stepOfLine < stepNumber);
                });

                currentStep = stepNumber;
            }

            // Next/Back chỉ cho phép đi tới step đã có data thật trong DOM
            // (data-step-panel tương ứng) — không cho "mở khoá" step chưa
            // sẵn sàng bằng cách gọi showStep() với số tuỳ ý từ bên ngoài.
            nextBackButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var target = parseInt(btn.getAttribute('data-go-to-step'), 10);
                    var targetPanelExists = document.querySelector('[data-step-panel="' + target + '"]');
                    if (targetPanelExists) {
                        showStep(target);
                    }
                });
            });

            showStep(currentStep);
        })();
    </script>

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

            // Khi wizard đang ở Step 1 (chưa verify serial), Step 2/3 chưa
            // được render nên các element trên không tồn tại trong DOM.
            // Bỏ qua toàn bộ script trong trường hợp này.
            if (!dropZone || !fileInput || !preview || !errorBox || !form) {
                return;
            }

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

            // Client-side text field validations (prevent empty / whitespace-only inputs)
            var titleInput = form.querySelector('input[name="title"]');
            var descInput = form.querySelector('textarea[name="description"]');

            function setupFieldValidation(inputElement, emptyMessage, whitespaceMessage) {
                if (!inputElement) return;

                // Clear custom validity on input
                inputElement.addEventListener('input', function () {
                    if (inputElement.value.trim() !== "") {
                        inputElement.setCustomValidity("");
                    }
                });

                // Check validity on blur
                inputElement.addEventListener('blur', function () {
                    var val = inputElement.value;
                    if (val === "") {
                        inputElement.setCustomValidity(emptyMessage);
                    } else if (val.trim() === "") {
                        inputElement.setCustomValidity(whitespaceMessage);
                        inputElement.reportValidity();
                    } else {
                        inputElement.setCustomValidity("");
                    }
                });
            }

            setupFieldValidation(titleInput, "Vui lòng nhập tiêu đề lỗi.", "Tiêu đề không được chỉ chứa khoảng trắng.");
            setupFieldValidation(descInput, "Vui lòng nhập mô tả chi tiết lỗi.", "Mô tả lỗi không được chỉ chứa khoảng trắng.");

            // Chặn submit lần cuối ở client nếu vượt giới hạn hoặc validation thất bại
            form.addEventListener('submit', function (e) {
                var titleVal = titleInput ? titleInput.value : "";
                var descVal = descInput ? descInput.value : "";

                if (titleInput) {
                    if (titleVal === "") {
                        titleInput.setCustomValidity("Vui lòng nhập tiêu đề lỗi.");
                    } else if (titleVal.trim() === "") {
                        titleInput.setCustomValidity("Tiêu đề không được chỉ chứa khoảng trắng.");
                    } else {
                        titleInput.setCustomValidity("");
                    }
                }

                if (descInput) {
                    if (descVal === "") {
                        descInput.setCustomValidity("Vui lòng nhập mô tả chi tiết lỗi.");
                    } else if (descVal.trim() === "") {
                        descInput.setCustomValidity("Mô tả lỗi không được chỉ chứa khoảng trắng.");
                    } else {
                        descInput.setCustomValidity("");
                    }
                }

                if (titleInput && !titleInput.checkValidity()) {
                    e.preventDefault();
                    titleInput.reportValidity();
                    return;
                }
                if (descInput && !descInput.checkValidity()) {
                    e.preventDefault();
                    descInput.reportValidity();
                    return;
                }

                if (selectedFiles.length > MAX_IMAGES) {
                    e.preventDefault();
                    showError('Chỉ được tải lên tối đa ' + MAX_IMAGES + ' ảnh.');
                }
            });
        })();
    </script>
    <jsp:include page="chatbot.jsp" />
</body>
</html>

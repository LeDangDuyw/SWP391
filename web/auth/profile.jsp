<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- isCustomer: true khi roleId == 3 --%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản Của Tôi - UNILAP</title>
    <meta name="description" content="Quản lý tài khoản, đổi mật khẩu, theo dõi bảo hành và đơn hàng của bạn tại UNILAP.">
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

        .btn-header-back {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 7px 16px;
            border-radius: 8px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            color: rgba(255,255,255,0.9);
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-header-back:hover {
            background: rgba(255,255,255,0.22);
            color: #fff;
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
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }

        .sidebar-avatar:hover {
            border-color: rgba(255,255,255,0.7);
            transform: scale(1.04);
        }

        .sidebar-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .sidebar-avatar-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            border-radius: 50%;
            transition: opacity 0.2s;
            font-size: 16px;
            color: #fff;
        }

        .sidebar-avatar:hover .sidebar-avatar-overlay { opacity: 1; }

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
            background: linear-gradient(90deg, var(--blue-50), transparent);
            color: var(--blue-700);
            border-left-color: var(--blue-600);
            font-weight: 600;
        }

        .nav-item .nav-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
            transition: var(--transition);
        }

        .nav-item:hover .nav-icon,
        .nav-item.active .nav-icon {
            background: var(--blue-100);
            color: var(--blue-700);
        }

        .nav-item .nav-icon { background: var(--gray-100); color: var(--gray-500); }

        .nav-divider {
            height: 1px;
            background: var(--gray-200);
            margin: 8px 16px;
        }

        .nav-item.danger { color: var(--red-600); }
        .nav-item.danger:hover { background: var(--red-100); border-left-color: var(--red-600); color: var(--red-600); }
        .nav-item.danger:hover .nav-icon { background: #fecaca; color: var(--red-600); }
        .nav-item.danger .nav-icon { background: #fee2e2; color: #ef4444; }

        /* ── CONTENT AREA ─────────────────────────────────────────────── */
        .content {
            flex: 1;
            min-width: 0;
        }

        /* Tab panels */
        .tab-panel {
            display: none;
        }
        .tab-panel.active {
            display: block;
        }

        /* Cards */
        .card {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 32px 36px;
            margin-bottom: 24px;
            animation: fadeUp 0.3s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 24px;
            padding-bottom: 18px;
            border-bottom: 1px solid var(--gray-200);
        }

        .card-header-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            background: var(--blue-100);
            color: var(--blue-700);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .card-header-icon.green { background: var(--green-100); color: var(--green-600); }
        .card-header-icon.amber { background: var(--amber-100); color: var(--amber-600); }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--gray-900);
        }

        .card-subtitle {
            font-size: 13px;
            color: var(--gray-500);
            margin-top: 2px;
        }

        /* ── FORM STYLES ─────────────────────────────────────────────── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full { grid-column: 1 / -1; }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: var(--gray-700);
            margin-bottom: 7px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            color: var(--gray-500);
            font-size: 15px;
            pointer-events: none;
        }

        .form-control {
            width: 100%;
            padding: 11px 14px 11px 42px;
            border: 1.5px solid var(--gray-300);
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            color: var(--gray-900);
            background: var(--white);
            transition: border-color var(--transition), box-shadow var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--blue-500);
            box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
        }

        .form-control[readonly] {
            background: var(--gray-100);
            color: var(--gray-500);
            cursor: default;
            border-color: var(--gray-200);
        }

        .form-control[readonly]:focus {
            border-color: var(--gray-200);
            box-shadow: none;
        }

        .pw-toggle {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            cursor: pointer;
            color: var(--gray-500);
            font-size: 15px;
            display: flex;
            align-items: center;
            padding: 4px;
            transition: color var(--transition);
        }
        .pw-toggle:hover { color: var(--blue-600); }

        /* Password strength */
        .strength-bar {
            height: 4px;
            border-radius: 4px;
            background: var(--gray-200);
            margin-top: 8px;
            overflow: hidden;
        }
        .strength-fill {
            height: 100%;
            border-radius: 4px;
            width: 0;
            transition: width 0.3s ease, background 0.3s ease;
        }

        .pw-rules {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 18px;
            padding: 10px 14px;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: 8px;
            margin-bottom: 18px;
            list-style: none;
        }
        .pw-rules li {
            font-size: 12px;
            color: var(--gray-500);
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.2s;
        }
        .pw-rules li i { font-size: 10px; color: var(--gray-300); transition: color 0.2s; }
        .pw-rules li.valid { color: var(--green-600); }
        .pw-rules li.valid i { color: var(--green-600); }

        /* ── BUTTONS ─────────────────────────────────────────────────── */
        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 8px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 24px;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            border: none;
            text-decoration: none;
            transition: all var(--transition);
        }

        .btn-primary {
            background: linear-gradient(135deg, #1d4ed8, #1e3a8a);
            color: #fff;
            box-shadow: 0 2px 8px rgba(29,78,216,0.3);
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(29,78,216,0.4);
        }

        .btn-outline {
            background: var(--white);
            color: var(--gray-700);
            border: 1.5px solid var(--gray-300);
        }
        .btn-outline:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
            transform: translateY(-1px);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc2626, #991b1b);
            color: #fff;
        }
        .btn-danger:hover {
            background: linear-gradient(135deg, #b91c1c, #7f1d1d);
            transform: translateY(-1px);
        }

        .btn-success {
            background: linear-gradient(135deg, #16a34a, #15803d);
            color: #fff;
        }
        .btn-success:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(22,163,74,0.35);
        }

        /* ── ALERTS ──────────────────────────────────────────────────── */
        .alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
        }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error   { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-info    { background: var(--blue-50); color: var(--blue-700); border: 1px solid var(--blue-100); }

        /* ── WARRANTY CTA ─────────────────────────────────────────────── */
        .warranty-cta {
            background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 100%);
            border-radius: var(--radius);
            padding: 28px 32px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            color: #fff;
        }

        .warranty-cta-icon {
            width: 56px;
            height: 56px;
            background: rgba(255,255,255,0.15);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }

        .warranty-cta-text h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .warranty-cta-text p {
            font-size: 13px;
            opacity: 0.8;
        }

        .warranty-cta-btn {
            margin-left: auto;
            flex-shrink: 0;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 22px;
            background: #fff;
            color: var(--blue-700);
            font-weight: 700;
            font-size: 14px;
            border-radius: 9px;
            text-decoration: none;
            transition: var(--transition);
        }

        .warranty-cta-btn:hover {
            background: var(--blue-50);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(0,0,0,0.15);
        }

        /* Quick link cards */
        .quick-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .quick-card {
            background: var(--white);
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius);
            padding: 20px 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            transition: all var(--transition);
            text-decoration: none;
            color: var(--gray-700);
        }

        .quick-card:hover {
            border-color: var(--blue-400);
            box-shadow: 0 4px 16px rgba(59,130,246,0.12);
            transform: translateY(-3px);
            color: var(--blue-700);
        }

        .quick-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .quick-card-label {
            font-size: 13px;
            font-weight: 600;
            text-align: center;
        }

        /* Avatar section in profile tab */
        .avatar-section {
            display: flex;
            align-items: center;
            gap: 24px;
            padding: 20px;
            background: var(--gray-50);
            border-radius: 10px;
            border: 1px solid var(--gray-200);
            margin-bottom: 28px;
        }

        .avatar-big {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            border: 3px solid var(--blue-200);
            overflow: hidden;
            background: var(--blue-100);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--blue-600);
            font-size: 36px;
            flex-shrink: 0;
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }

        .avatar-big:hover { border-color: var(--blue-500); }
        .avatar-big img { width: 100%; height: 100%; object-fit: cover; }

        .avatar-big-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.2s;
            color: #fff;
            font-size: 16px;
        }
        .avatar-big:hover .avatar-big-overlay { opacity: 1; }

        .avatar-info h4 { font-size: 16px; font-weight: 700; color: var(--gray-900); margin-bottom: 4px; }
        .avatar-info p  { font-size: 13px; color: var(--gray-500); margin-bottom: 10px; }

        .btn-sm {
            padding: 7px 16px;
            font-size: 13px;
            border-radius: 7px;
        }

        /* Orders tab empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-state-icon {
            width: 80px;
            height: 80px;
            background: var(--gray-100);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: var(--gray-400);
            margin: 0 auto 20px;
        }
        .empty-state h3 { font-size: 18px; color: var(--gray-700); margin-bottom: 8px; }
        .empty-state p  { font-size: 14px; color: var(--gray-500); }

        /* ── FOOTER ──────────────────────────────────────────────────── */
        .footer {
            background: var(--white);
            border-top: 1px solid var(--gray-200);
            padding: 20px 40px;
            text-align: center;
            font-size: 13px;
            color: var(--gray-500);
            margin-top: auto;
        }

        /* ── RESPONSIVE ──────────────────────────────────────────────── */
        @media (max-width: 860px) {
            .page-wrap { flex-direction: column; margin: 20px auto; }
            .sidebar { width: 100%; position: static; }
            .sidebar-nav { display: flex; flex-wrap: wrap; padding: 8px; gap: 4px; }
            .nav-label { display: none; }
            .nav-item { border-left: none; border-radius: 8px; padding: 9px 14px; font-size: 13px; }
            .nav-item.active { background: var(--blue-100); border-left: none; }
            .nav-divider { display: none; }
            .form-grid { grid-template-columns: 1fr; }
            .quick-grid { grid-template-columns: 1fr 1fr; }
            .warranty-cta { flex-wrap: wrap; }
            .warranty-cta-btn { margin-left: 0; }
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

            <c:choose>
                <c:when test="${profileUser.roleId == 1}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-header-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </c:when>
                <c:when test="${profileUser.roleId == 2}">
                    <a href="${pageContext.request.contextPath}/staff/inventory" class="btn-header-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-header-back">
                        <i class="fas fa-arrow-left"></i> Trang chủ
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- ── PAGE BODY ─────────────────────────────────────────────────── -->
    <div class="page-wrap">

        <!-- ── SIDEBAR ────────────────────────────────────────────────── -->
        <aside class="sidebar">
            <div class="sidebar-profile">
                <div class="sidebar-avatar" onclick="document.getElementById('avatarInputSidebar').click()">
                    <c:choose>
                        <c:when test="${not empty profileUser.avatarUrl}">
                            <img src="${pageContext.request.contextPath}/images/${profileUser.avatarUrl}" alt="Avatar" id="sidebarAvatarImg">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user" id="sidebarAvatarIcon"></i>
                            <img src="" alt="" id="sidebarAvatarImg" style="display:none;">
                        </c:otherwise>
                    </c:choose>
                    <div class="sidebar-avatar-overlay"><i class="fas fa-camera"></i></div>
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
                    <c:otherwise>
                        <span class="role-badge badge-customer"><i class="fas fa-user"></i> Khách hàng</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-label">Tài khoản</div>

                <div class="nav-item active" id="nav-profile" onclick="switchTab('profile')">
                    <div class="nav-icon"><i class="fas fa-user-circle"></i></div>
                    Hồ sơ cá nhân
                </div>

                <div class="nav-item" id="nav-password" onclick="switchTab('password')">
                    <div class="nav-icon"><i class="fas fa-lock"></i></div>
                    Đổi mật khẩu
                </div>

                <c:if test="${profileUser.roleId == 3}">
                <div class="nav-label">Dịch vụ</div>

                <div class="nav-item" id="nav-warranty" onclick="switchTab('warranty')">
                    <div class="nav-icon"><i class="fas fa-shield-alt"></i></div>
                    Bảo hành
                </div>

                <div class="nav-item" id="nav-orders" onclick="switchTab('orders')">
                    <div class="nav-icon"><i class="fas fa-shopping-bag"></i></div>
                    Đơn hàng của tôi
                </div>
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

            <!-- ══════════════════════════════════
                 TAB 1 – HỒ SƠ CÁ NHÂN
            ══════════════════════════════════ -->
            <div class="tab-panel active" id="tab-profile">
                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <div>
                            <div class="card-title">Hồ Sơ Cá Nhân</div>
                            <div class="card-subtitle">Xem và cập nhật thông tin cá nhân của bạn</div>
                        </div>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>${success}</span>
                        </div>
                    </c:if>

                    <!-- Avatar section -->
                    <div class="avatar-section">
                        <div class="avatar-big" onclick="document.getElementById('avatarInput').click()">
                            <c:choose>
                                <c:when test="${not empty profileUser.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}/images/${profileUser.avatarUrl}"
                                         alt="Avatar" id="avatarPreview">
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-user" id="avatarPlaceholder"></i>
                                    <img src="" alt="" id="avatarPreview" style="display:none;">
                                </c:otherwise>
                            </c:choose>
                            <div class="avatar-big-overlay"><i class="fas fa-camera"></i></div>
                        </div>
                        <div class="avatar-info">
                            <h4>${profileUser.userName}</h4>
                            <p>Click vào ảnh để thay đổi ảnh đại diện</p>
                            <label for="avatarInput" class="btn btn-outline btn-sm" style="cursor:pointer;">
                                <i class="fas fa-upload"></i> Tải ảnh lên
                            </label>
                        </div>
                    </div>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" id="profileForm">
                        <input type="file" name="avatar" id="avatarInput" accept="image/*" style="display:none;">
                        <!-- Reuse sidebar avatar preview -->
                        <input type="file" name="avatar" id="avatarInputSidebar" accept="image/*" style="display:none;">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName">Họ và Tên</label>
                                <div class="input-wrap">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" name="fullName" id="fullName"
                                           class="form-control"
                                           value="${profileUser.userName}" required
                                           placeholder="Nhập họ và tên">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="phone">Số Điện Thoại</label>
                                <div class="input-wrap">
                                    <i class="fas fa-phone input-icon"></i>
                                    <input type="text" name="phone" id="phone"
                                           class="form-control"
                                           value="${profileUser.phone}"
                                           placeholder="Nhập số điện thoại">
                                </div>
                            </div>

                            <div class="form-group full">
                                <label for="email">Địa Chỉ Email</label>
                                <div class="input-wrap">
                                    <i class="fas fa-envelope input-icon"></i>
                                    <input type="email" id="email"
                                           class="form-control"
                                           value="${profileUser.email}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn btn-primary" id="btn-save-profile">
                                <i class="fas fa-save"></i> Lưu Thay Đổi
                            </button>
                            <button type="reset" class="btn btn-outline" id="btn-reset-profile">
                                <i class="fas fa-undo"></i> Đặt Lại
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Quick Links -->
                <div class="quick-grid">
                    <div class="quick-card" onclick="switchTab('password')" id="qlink-password"
                         style="${profileUser.roleId != 3 ? 'grid-column:1/-1;' : ''}">
                        <div class="quick-card-icon" style="background:#ede9fe;color:#7c3aed;">
                            <i class="fas fa-lock"></i>
                        </div>
                        <span class="quick-card-label">Đổi Mật Khẩu</span>
                    </div>

                    <c:if test="${profileUser.roleId == 3}">
                    <div class="quick-card" onclick="switchTab('warranty')" id="qlink-warranty">
                        <div class="quick-card-icon" style="background:#dcfce7;color:#16a34a;">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <span class="quick-card-label">Bảo Hành</span>
                    </div>

                    <div class="quick-card" onclick="switchTab('orders')" id="qlink-orders">
                        <div class="quick-card-icon" style="background:#fef3c7;color:#d97706;">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <span class="quick-card-label">Đơn Hàng</span>
                    </div>
                    </c:if>
                </div>
            </div>

            <!-- ══════════════════════════════════
                 TAB 2 – ĐỔI MẬT KHẨU
            ══════════════════════════════════ -->
            <div class="tab-panel" id="tab-password">
                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon" style="background:#ede9fe;color:#7c3aed;">
                            <i class="fas fa-lock"></i>
                        </div>
                        <div>
                            <div class="card-title">Đổi Mật Khẩu</div>
                            <div class="card-subtitle">Cập nhật mật khẩu để bảo vệ tài khoản của bạn</div>
                        </div>
                    </div>

                    <c:if test="${not empty pwError}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${pwError}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty pwSuccess}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>${pwSuccess}</span>
                        </div>
                    </c:if>

                    <!-- Password rules -->
                    <ul class="pw-rules" id="pwRules">
                        <li id="rule-length"><i class="fas fa-circle"></i> Ít nhất 6 ký tự</li>
                        <li id="rule-match"><i class="fas fa-circle"></i> Xác nhận khớp</li>
                    </ul>

                    <form action="${pageContext.request.contextPath}/profile" method="post" id="changePwForm">

                        <div class="form-group">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:7px;">
                                <label for="currentPassword" style="margin-bottom:0;">Mật Khẩu Hiện Tại</label>
                                <a href="${pageContext.request.contextPath}/forgot-password"
                                   style="font-size:12px;color:var(--blue-600);text-decoration:none;font-weight:500;">
                                    <i class="fas fa-question-circle"></i> Quên mật khẩu?
                                </a>
                            </div>
                            <div class="input-wrap">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" name="currentPassword" id="currentPassword"
                                       class="form-control" style="padding-right:42px;"
                                       placeholder="Nhập mật khẩu hiện tại" autocomplete="current-password">
                                <button type="button" class="pw-toggle" onclick="togglePw('currentPassword',this)" id="toggle-current">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">Mật Khẩu Mới</label>
                            <div class="input-wrap">
                                <i class="fas fa-key input-icon"></i>
                                <input type="password" name="newPassword" id="newPassword"
                                       class="form-control" style="padding-right:42px;"
                                       placeholder="Nhập mật khẩu mới" autocomplete="new-password"
                                       oninput="checkPwStrength()">
                                <button type="button" class="pw-toggle" onclick="togglePw('newPassword',this)" id="toggle-new">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="strength-bar">
                                <div class="strength-fill" id="pwStrengthFill"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác Nhận Mật Khẩu Mới</label>
                            <div class="input-wrap">
                                <i class="fas fa-check-double input-icon"></i>
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                       class="form-control" style="padding-right:42px;"
                                       placeholder="Nhập lại mật khẩu mới" autocomplete="new-password"
                                       oninput="checkPwStrength()">
                                <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword',this)" id="toggle-confirm">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn btn-primary" id="btn-change-pw">
                                <i class="fas fa-shield-alt"></i> Đổi Mật Khẩu
                            </button>
                            <button type="reset" class="btn btn-outline" onclick="resetPwForm()" id="btn-reset-pw">
                                <i class="fas fa-undo"></i> Nhập Lại
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Security tips -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon" style="background:#fef3c7;color:#d97706;">
                            <i class="fas fa-lightbulb"></i>
                        </div>
                        <div>
                            <div class="card-title">Mẹo bảo mật</div>
                            <div class="card-subtitle">Những điều nên làm để giữ tài khoản an toàn</div>
                        </div>
                    </div>
                    <ul style="padding-left:20px;color:var(--gray-700);font-size:14px;line-height:2;">
                        <li>Sử dụng mật khẩu ít nhất 8 ký tự gồm chữ hoa, chữ thường, số.</li>
                        <li>Không sử dụng cùng một mật khẩu cho nhiều tài khoản.</li>
                        <li>Không chia sẻ mật khẩu với bất kỳ ai.</li>
                        <li>Thay đổi mật khẩu định kỳ 3-6 tháng một lần.</li>
                    </ul>
                </div>
            </div>

            <c:if test="${profileUser.roleId == 3}">
            <!-- ══════════════════════════════════
                 TAB 3 – BẢO HÀNH
            ══════════════════════════════════ -->
            <div class="tab-panel" id="tab-warranty">

                <!-- CTA Banner -->
                <div class="warranty-cta">
                    <div class="warranty-cta-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="warranty-cta-text">
                        <h3>Trung Tâm Bảo Hành</h3>
                        <p>Gửi yêu cầu bảo hành, kiểm tra tình trạng và theo dõi tiến trình xử lý.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/warranty?action=list" class="warranty-cta-btn" id="btn-go-warranty">
                        <i class="fas fa-external-link-alt"></i> Đến Trang Bảo Hành
                    </a>
                </div>

                <!-- Feature cards -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon green">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <div class="card-title">Quản Lý Bảo Hành</div>
                            <div class="card-subtitle">Tất cả chức năng liên quan đến bảo hành sản phẩm</div>
                        </div>
                    </div>

                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                        <a href="${pageContext.request.contextPath}/warranty?action=list" class="quick-card" id="warranty-list-btn">
                            <div class="quick-card-icon" style="background:#dcfce7;color:#16a34a;">
                                <i class="fas fa-list-ul"></i>
                            </div>
                            <span class="quick-card-label">Xem Yêu Cầu Của Tôi</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/warranty?action=checkEligibility" class="quick-card" id="warranty-check-btn">
                            <div class="quick-card-icon" style="background:#dbeafe;color:#1d4ed8;">
                                <i class="fas fa-search"></i>
                            </div>
                            <span class="quick-card-label">Kiểm Tra Còn Bảo Hành</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/warranty?action=list" class="quick-card" id="warranty-submit-btn" style="grid-column:1/-1;">
                            <div class="quick-card-icon" style="background:#fef3c7;color:#d97706;">
                                <i class="fas fa-plus-circle"></i>
                            </div>
                            <span class="quick-card-label">Gửi Yêu Cầu Bảo Hành Mới</span>
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon amber">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div>
                            <div class="card-title">Chính Sách Bảo Hành</div>
                            <div class="card-subtitle">Điều khoản và điều kiện bảo hành sản phẩm UNILAP</div>
                        </div>
                    </div>
                    <ul style="padding-left:20px;color:var(--gray-700);font-size:14px;line-height:2.2;">
                        <li>Bảo hành chính hãng theo thời gian ghi trên phiếu bảo hành.</li>
                        <li>Bảo hành áp dụng cho lỗi kỹ thuật do nhà sản xuất.</li>
                        <li>Không bảo hành trong trường hợp hư hỏng do va đập, nước, hoặc tự ý sửa chữa.</li>
                        <li>Khách hàng cần cung cấp số serial sản phẩm khi gửi yêu cầu.</li>
                        <li>Thời gian xử lý trung bình từ 3–7 ngày làm việc.</li>
                    </ul>
                </div>
            </div>

            <!-- ══════════════════════════════════
                 TAB 4 – ĐƠN HÀNG
            ══════════════════════════════════ -->
            <div class="tab-panel" id="tab-orders">
                <div class="card">
                    <div class="card-header">
                        <div class="card-header-icon amber">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div>
                            <div class="card-title">Đơn Hàng Của Tôi</div>
                            <div class="card-subtitle">Lịch sử và trạng thái các đơn hàng</div>
                        </div>
                    </div>

                    <div class="empty-state" id="orders-empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <h3>Chưa có đơn hàng nào</h3>
                        <p>Bạn chưa thực hiện đơn hàng nào. Hãy khám phá sản phẩm của chúng tôi!</p>
                        <a href="${pageContext.request.contextPath}/ProductListServlet"
                           class="btn btn-primary" style="margin-top:20px; display:inline-flex;" id="btn-shop-now">
                            <i class="fas fa-store"></i> Mua Sắm Ngay
                        </a>
                    </div>
                </div>
            </div>
            </c:if>

        </main>
    </div>

    <!-- ── FOOTER ─────────────────────────────────────────────────────── -->
    <footer class="footer">
        <p>© 2026 UNILAP Precision Engineering. All rights reserved.</p>
    </footer>

    <script>
        // ── TAB SWITCHING ──────────────────────────────────────────────
        function switchTab(tab) {
            // Hide all panels
            document.querySelectorAll('.tab-panel').forEach(function(p) {
                p.classList.remove('active');
            });
            // Deactivate all nav items
            document.querySelectorAll('.nav-item').forEach(function(n) {
                n.classList.remove('active');
            });

            // Activate target
            var panel = document.getElementById('tab-' + tab);
            if (panel) panel.classList.add('active');

            var navItem = document.getElementById('nav-' + tab);
            if (navItem) navItem.classList.add('active');

            // Update URL hash without scroll
            history.replaceState(null, null, '#' + tab);
        }

        // ── AVATAR PREVIEW ─────────────────────────────────────────────
        function setupAvatarPreview(inputId) {
            document.getElementById(inputId).addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (!file) return;

                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn tệp hình ảnh!');
                    this.value = '';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(ev) {
                    // Update sidebar avatar
                    var icon = document.getElementById('sidebarAvatarIcon');
                    var img  = document.getElementById('sidebarAvatarImg');
                    if (icon) icon.style.display = 'none';
                    if (img)  { img.src = ev.target.result; img.style.display = 'block'; }

                    // Update big avatar in profile tab
                    var placeholder = document.getElementById('avatarPlaceholder');
                    var preview     = document.getElementById('avatarPreview');
                    if (placeholder) placeholder.style.display = 'none';
                    if (preview)     { preview.src = ev.target.result; preview.style.display = 'block'; }
                };
                reader.readAsDataURL(file);
            });
        }

        setupAvatarPreview('avatarInput');
        setupAvatarPreview('avatarInputSidebar');

        // ── PASSWORD HELPERS ───────────────────────────────────────────
        function togglePw(fieldId, btn) {
            var input = document.getElementById(fieldId);
            var icon  = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }

        function checkPwStrength() {
            var pw      = document.getElementById('newPassword').value      || '';
            var confirm = document.getElementById('confirmPassword').value  || '';

            var ruleLength = pw.length >= 6;
            var ruleMatch  = pw.length > 0 && pw === confirm;

            setRule('rule-length', ruleLength);
            setRule('rule-match',  ruleMatch);

            var fill = document.getElementById('pwStrengthFill');
            var color, width;
            if      (pw.length === 0)  { color = ''; width = '0%'; }
            else if (pw.length < 6)    { color = '#ef4444'; width = '33%'; }
            else if (pw.length < 10)   { color = '#eab308'; width = '66%'; }
            else                       { color = '#22c55e'; width = '100%'; }
            fill.style.width      = width;
            fill.style.background = color;
        }

        function setRule(id, valid) {
            var el = document.getElementById(id);
            if (!el) return;
            if (valid) el.classList.add('valid');
            else       el.classList.remove('valid');
        }

        function resetPwForm() {
            document.getElementById('changePwForm').reset();
            ['rule-length','rule-match'].forEach(function(id){ setRule(id, false); });
            var fill = document.getElementById('pwStrengthFill');
            fill.style.width = '0';
            fill.style.background = '';
        }

        // ── ON LOAD ─────────────────────────────────────────────────────
        window.addEventListener('load', function() {
            // Auto-switch tab based on server messages or URL hash
            var hash = window.location.hash.replace('#', '');

            <c:if test="${not empty pwError or not empty pwSuccess}">
            switchTab('password');
            return;
            </c:if>

            if (hash && document.getElementById('tab-' + hash)) {
                switchTab(hash);
            }
        });
    </script>
</body>
</html>

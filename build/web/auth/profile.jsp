<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

        .btn-back-bar {
            max-width: 1100px;
            margin: 16px auto 0;
            width: 100%;
            padding: 0 20px;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 18px;
            border-radius: 9px;
            background: var(--white);
            border: 1.5px solid var(--gray-300);
            color: var(--gray-700);
            font-size: 13px;
            font-weight: 600;
            font-family: inherit;
            text-decoration: none;
            transition: var(--transition);
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }

        .btn-back:hover {
            background: var(--blue-50);
            border-color: var(--blue-400);
            color: var(--blue-700);
            transform: translateX(-2px);
            box-shadow: 0 2px 8px rgba(59,130,246,0.12);
        }

        .btn-back i {
            font-size: 11px;
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

        /* ── REVIEW MODAL ─────────────────────────────────────────────── */
        .review-modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .review-modal.show {
            opacity: 1;
        }
        .review-modal-content {
            background-color: var(--white);
            border-radius: var(--radius);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            width: 90%;
            max-width: 550px;
            max-height: 85vh;
            overflow-y: auto;
            border: 1px solid var(--gray-200);
            animation: modalSlideIn 0.3s ease-out;
        }
        @keyframes modalSlideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .review-modal-header {
            padding: 16px 24px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            background: var(--white);
            z-index: 10;
        }
        .review-modal-header h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }
        .review-modal-close {
            font-size: 24px;
            font-weight: 700;
            color: var(--gray-500);
            cursor: pointer;
            transition: color 0.2s;
            line-height: 1;
        }
        .review-modal-close:hover {
            color: var(--red-600);
        }
        .review-modal-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .review-item {
            padding: 16px;
            border: 1px solid var(--gray-200);
            border-radius: 8px;
            background: var(--gray-50);
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .review-product-info {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .review-product-img {
            width: 60px;
            height: 48px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid var(--gray-200);
            background: var(--white);
        }
        .review-product-name {
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 2px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .review-product-variant {
            font-size: 11px;
            color: var(--gray-500);
        }
        .review-stars {
            display: flex;
            gap: 6px;
            font-size: 24px;
            color: var(--gray-300);
        }
        .review-stars i {
            cursor: pointer;
            transition: color 0.2s, transform 0.1s;
        }
        .review-stars i:hover {
            transform: scale(1.15);
        }
        .review-stars i.active {
            color: #f59e0b;
        }
        .review-comment {
            width: 100%;
            min-height: 80px;
            padding: 10px;
            border: 1.5px solid var(--gray-300);
            border-radius: 6px;
            font-size: 13px;
            font-family: inherit;
            resize: vertical;
            outline: none;
            transition: border-color 0.2s;
        }
        .review-comment:focus {
            border-color: var(--blue-500);
        }
        .review-submit-btn {
            align-self: flex-end;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all var(--transition);
        }
        .review-success-badge {
            color: var(--green-600);
            background: var(--green-100);
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            align-self: flex-start;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .toast-notification {
            position: fixed;
            top: 24px;
            right: 24px;
            background: var(--gray-900);
            color: #fff;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 500;
            z-index: 2000;
            transform: translateY(-20px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        .toast-notification.show {
            transform: translateY(0);
            opacity: 1;
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

    <!-- ── NÚT QUAY LẠI (dưới header, bên trái) ──────────────────────── -->
    <div class="btn-back-bar">
        <c:choose>
            <c:when test="${profileUser.roleId == 1}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                </a>
            </c:when>
            <c:when test="${profileUser.roleId == 2}">
                <a href="${pageContext.request.contextPath}/staff/inventory" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Trang chủ
                </a>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ── PAGE BODY ─────────────────────────────────────────────────── -->
    <div class="page-wrap">

        <!-- ── SIDEBAR ────────────────────────────────────────────────── -->
        <aside class="sidebar">
            <div class="sidebar-profile">
                <div class="sidebar-avatar" onclick="document.getElementById('avatarInput').click()">
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

                <div class="nav-item active" id="nav-profile" onclick="switchTab('profile')">
                    <div class="nav-icon"><i class="fas fa-user-circle"></i></div>
                    Hồ sơ cá nhân
                </div>

                <div class="nav-item" id="nav-password" onclick="switchTab('password')">
                    <div class="nav-icon"><i class="fas fa-lock"></i></div>
                    Đổi mật khẩu
                </div>

                <c:if test="${profileUser.roleId == 3 || profileUser.roleId == 4}">
                <div class="nav-label">Dịch vụ</div>

                <div class="nav-item" id="nav-warranty" onclick="switchTab('warranty')">
                    <div class="nav-icon"><i class="fas fa-shield-alt"></i></div>
                    Bảo hành
                </div>

                <div class="nav-item" id="nav-orders" onclick="switchTab('orders')">
                    <div class="nav-icon"><i class="fas fa-shopping-bag"></i></div>
                    Đơn hàng của tôi
                </div>

                <div class="nav-item" id="nav-student-verify" onclick="switchTab('student-verify')">
                    <div class="nav-icon"><i class="fas fa-graduation-cap"></i></div>
                    Xác minh sinh viên
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
                        <!-- Single file input — dùng chung cho cả sidebar avatar và nút tải ảnh -->
                        <input type="file" name="avatar" id="avatarInput" accept="image/*" style="display:none;">

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

            <c:if test="${profileUser.roleId == 3 || profileUser.roleId == 4}">
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
                        <a href="${pageContext.request.contextPath}/warranty?action=list#recent-activity" class="quick-card" id="warranty-list-btn">
                            <div class="quick-card-icon" style="background:#dcfce7;color:#16a34a;">
                                <i class="fas fa-list-ul"></i>
                            </div>
                            <span class="quick-card-label">Xem Yêu Cầu Của Tôi</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/warranty?action=checkEligibility" class="quick-card" id="warranty-submit-btn">
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
                <div class="card" style="padding: 28px;">
                    <div class="card-header" style="margin-bottom: 20px;">
                        <div class="card-header-icon amber">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div>
                            <div class="card-title">Đơn Hàng Của Tôi</div>
                            <div class="card-subtitle">Lịch sử và trạng thái các đơn hàng của bạn</div>
                        </div>
                    </div>

                    <!-- Status Filter Tabs -->
                    <div class="order-status-tabs" style="display: flex; gap: 24px; border-bottom: 2px solid var(--gray-200); padding-bottom: 12px; margin-bottom: 20px; overflow-x: auto; -webkit-overflow-scrolling: touch;">
                        <span class="status-tab active" data-status="all" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Tất cả</span>
                        <span class="status-tab" data-status="Pending" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Chờ xác nhận</span>
                        <span class="status-tab" data-status="processing" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Đang xử lý</span>
                        <span class="status-tab" data-status="shipped" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Đang vận chuyển</span>
                        <span class="status-tab" data-status="delivered" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Đã nhận hàng</span>
                        <span class="status-tab" data-status="cancelled" style="cursor: pointer; font-size: 14px; font-weight: 600; color: var(--gray-500); padding-bottom: 12px; position: relative;">Đã huỷ</span>
                    </div>

                    <!-- Date Range Filter -->
                    <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 24px; flex-wrap: wrap;">
                        <span style="font-size: 14px; font-weight: 700; color: var(--gray-700);">Lịch sử mua hàng</span>
                        <div style="display: flex; align-items: center; border: 1.5px solid var(--gray-300); border-radius: 8px; padding: 6px 12px; background: #fff; gap: 10px;">
                            <input type="date" id="order-start-date" value="2020-12-01" style="border: none; outline: none; font-size: 13px; color: var(--gray-700); font-family: inherit;">
                            <span style="color: var(--gray-400); font-size: 13px;"><i class="fas fa-arrow-right"></i></span>
                            <input type="date" id="order-end-date" value="2026-07-10" style="border: none; outline: none; font-size: 13px; color: var(--gray-700); font-family: inherit;">
                        </div>
                    </div>

                    <!-- CSS styles for tabs -->
                    <style>
                        .status-tab {
                            transition: color var(--transition);
                            white-space: nowrap;
                        }
                        .status-tab.active {
                            color: var(--red-600) !important;
                        }
                        .status-tab.active::after {
                            content: '';
                            position: absolute;
                            bottom: -14px;
                            left: 0;
                            width: 100%;
                            height: 3px;
                            background-color: var(--red-600);
                            border-radius: 2px;
                        }
                        .order-card {
                            border: 1px solid var(--gray-200);
                            border-radius: 8px;
                            padding: 20px;
                            margin-bottom: 16px;
                            background: #fff;
                            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
                            transition: transform 0.2s ease, box-shadow 0.2s ease;
                        }
                        .order-card:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
                        }
                        .order-badge {
                            padding: 4px 12px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 600;
                        }
                        .badge-pending-order { background-color: #fef3c7; color: #d97706; }
                        .badge-processing-order { background-color: #e0f2fe; color: #0369a1; }
                        .badge-shipping-order { background-color: #e0e7ff; color: #4338ca; }
                        .badge-delivered-order { background-color: #dcfce7; color: #166534; }
                        .badge-cancelled-order { background-color: #fee2e2; color: #991b1b; }
                    </style>

                    <!-- Order Cards List -->
                    <div id="orders-list-container">
                        <c:choose>
                            <c:when test="${empty userOrders}">
                                <div class="empty-state" id="orders-empty-state" style="display: block;">
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
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" id="orders-empty-state" style="display: none;">
                                    <div class="empty-state-icon">
                                        <i class="fas fa-shopping-bag"></i>
                                    </div>
                                    <h3>Không tìm thấy đơn hàng nào</h3>
                                    <p>Không có đơn hàng nào khớp với điều kiện lọc của bạn.</p>
                                </div>
                                
                                <c:forEach items="${userOrders}" var="ord">
                                    <c:set var="details" value="${ord.details}" />
                                    <c:set var="firstDetail" value="${details[0]}" />
                                    <c:set var="itemCount" value="${fn:length(details)}" />
                                    
                                    <div class="order-card" data-status="${ord.orderStatus}" data-date="${ord.completedAt != null ? ord.completedAt.toLocalDate() : '2026-07-10'}">
                                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 16px; flex-wrap: wrap; gap: 10px;">
                                            <div style="font-size: 13px; color: var(--gray-500);">
                                                Đơn hàng: <strong style="color: var(--gray-700);">#${ord.orderCode}</strong>
                                                <span style="margin: 0 8px; color: #cbd5e1;">•</span>
                                                Ngày đặt hàng: <strong>
                                                    <c:choose>
                                                        <c:when test="${not empty ord.completedAt}">
                                                            ${ord.completedAt.dayOfMonth}/${ord.completedAt.monthValue}/${ord.completedAt.year}
                                                        </c:when>
                                                        <c:otherwise>
                                                            10/07/2026
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${ord.orderStatus == 'Pending'}">
                                                        <span class="order-badge badge-pending-order">Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${ord.orderStatus == 'processing'}">
                                                        <span class="order-badge badge-processing-order">Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${ord.orderStatus == 'shipped'}">
                                                        <span class="order-badge badge-shipping-order">Đang vận chuyển</span>
                                                    </c:when>
                                                    <c:when test="${ord.orderStatus == 'delivered' || ord.orderStatus == 'Completed'}">
                                                        <span class="order-badge badge-delivered-order">Đã nhận hàng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="order-badge badge-cancelled-order">Đã huỷ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div style="display: flex; gap: 16px; align-items: flex-start; justify-content: space-between;">
                                            <div style="display: flex; gap: 16px; flex: 1; min-width: 0;">
                                                <img src="${pageContext.request.contextPath}/images/${firstDetail.thumbnail}" 
                                                     onerror="this.src='https://placehold.co/80x60/f1f5f9/94a3b8?text=UniLap'" 
                                                     alt="product" style="width: 80px; height: 65px; object-fit: cover; border-radius: 6px; border: 1px solid #e2e8f0; background: #f8fafc; flex-shrink: 0;">
                                                <div style="min-width: 0;">
                                                    <h4 style="font-size: 14px; font-weight: 600; color: var(--gray-900); margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${firstDetail.productName}">
                                                        ${firstDetail.productName}
                                                    </h4>
                                                    <p style="font-size: 13px; color: var(--gray-500); margin-bottom: 2px;">Cấu hình: ${firstDetail.variantName}</p>
                                                    <div style="font-size: 13px; font-weight: 500; color: var(--gray-700);">
                                                        <fmt:formatNumber value="${firstDetail.unitPrice}" pattern="#,##0"/>₫ 
                                                        <span style="font-size: 12px; color: var(--gray-500); font-weight: 400; margin-left: 5px;">x ${firstDetail.quantity}</span>
                                                    </div>
                                                    <c:if test="${itemCount > 1}">
                                                        <p style="font-size: 12px; color: var(--blue-600); font-weight: 500; margin-top: 6px;">
                                                            <i class="fas fa-boxes" style="margin-right: 4px;"></i> Cùng ${itemCount - 1} sản phẩm khác
                                                        </p>
                                                    </c:if>
                                                    <c:if test="${ord.orderStatus == 'delivered' || ord.orderStatus == 'Completed'}">
                                                        <span style="display: inline-flex; align-items: center; gap: 4px; padding: 2px 8px; background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; font-size: 10px; font-weight: 600; border-radius: 4px; margin-top: 6px;">Đã xuất VAT</span>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div style="text-align: right; flex-shrink: 0; display: flex; flex-direction: column; align-items: flex-end;">
                                                <p style="font-size: 12px; color: var(--gray-500); margin-bottom: 4px;">Tổng thanh toán</p>
                                                <p style="font-size: 16px; font-weight: 800; color: var(--red-600); margin-bottom: 12px;">
                                                    <fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0"/>₫
                                                </p>
                                                <a href="${pageContext.request.contextPath}/order-detail?id=${ord.orderId}" class="btn btn-outline btn-sm" style="padding: 6px 14px; font-size: 12px; border-radius: 6px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; margin-bottom: 6px;">
                                                    Xem chi tiết <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: 4px;"></i>
                                                </a>
                                                
                                                <c:if test="${ord.orderStatus == 'delivered' || ord.orderStatus == 'Completed'}">
                                                    <c:set var="allReviewed" value="true" />
                                                    <c:forEach items="${ord.details}" var="item">
                                                        <c:if test="${!item.reviewed}">
                                                            <c:set var="allReviewed" value="false" />
                                                        </c:if>
                                                    </c:forEach>
                                                    
                                                    <div id="action-order-${ord.orderId}">
                                                        <c:choose>
                                                            <c:when test="${allReviewed}">
                                                                <span class="review-success-badge" style="font-size: 11px; padding: 4px 10px; border-radius: 20px; display: inline-flex; align-items: center; gap: 4px;">
                                                                    <i class="fas fa-check-circle"></i> Đã đánh giá
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm" onclick="openOrderReviewModal('${ord.orderId}')" style="background: linear-gradient(135deg, #16a34a, #15803d); color: #fff; font-size: 11px; border: none; padding: 6px 14px; border-radius: 6px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 4px; box-shadow: 0 2px 8px rgba(22, 163, 74, 0.2);">
                                                                    <i class="fas fa-star" style="font-size: 10px;"></i> Đánh giá
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    
                                                    <div id="order-details-json-${ord.orderId}" style="display:none;">[<c:forEach items="${ord.details}" var="item" varStatus="loop">{"productId": ${item.productId},"productName": "${fn:escapeXml(item.productName)}","variantName": "${fn:escapeXml(item.variantName)}","thumbnail": "${item.thumbnail}","reviewed": ${item.reviewed}}${not loop.last ? ',' : ''}</c:forEach>]</div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- ══════════════════════════════════
                 TAB 5 – XÁC MINH SINH VIÊN
            ══════════════════════════════════ -->
            <div class="tab-panel" id="tab-student-verify">
                <div class="card">
                    <div class="card-header" style="background:#f0f9ff;color:#0284c7;">
                        <div class="card-header-icon" style="background:#e0f2fe;color:#0284c7;">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div>
                            <div class="card-title">Xác Minh Sinh Viên</div>
                            <div class="card-subtitle">Xác minh danh tính sinh viên để nhận ưu đãi đặc biệt</div>
                        </div>
                    </div>

                    <div class="card-body" style="padding: 24px;">
                        <c:choose>
                            <c:when test="${profileUser.roleId == 4}">
                                <div class="alert alert-success" style="background:#f0fdf4; border-left:4px solid #15803d; color:#166534; padding:16px; border-radius:8px; display:flex; align-items:center; gap:12px; margin-bottom:20px;">
                                    <i class="fas fa-check-circle" style="font-size:24px;"></i>
                                    <div>
                                        <h4 style="font-weight:600; margin-bottom:4px;">Tài khoản đã xác minh thành công!</h4>
                                        <p style="font-size:14px; opacity:0.9;">Tài khoản của bạn đã được duyệt vai trò Sinh viên. Bạn có thể sử dụng các ưu đãi dành riêng cho sinh viên tại UNILAP.</p>
                                    </div>
                                </div>
                                <c:if test="${not empty studentVerify}">
                                    <div style="margin-top:20px;">
                                        <p style="font-weight:500; margin-bottom:8px; color:var(--gray-700);">Ảnh thẻ sinh viên của bạn:</p>
                                        <img src="${pageContext.request.contextPath}/images/${studentVerify.studentCardImage}" alt="Thẻ sinh viên" style="max-width:400px; border-radius:8px; box-shadow:var(--shadow); border:1px solid var(--gray-200);">
                                    </div>
                                </c:if>
                            </c:when>

                            <c:when test="${not empty studentVerify && studentVerify.status == 'pending'}">
                                <div class="alert alert-warning" style="background:#fffbeb; border-left:4px solid #b45309; color:#92400e; padding:16px; border-radius:8px; display:flex; align-items:center; gap:12px; margin-bottom:20px;">
                                    <i class="fas fa-clock" style="font-size:24px;"></i>
                                    <div>
                                        <h4 style="font-weight:600; margin-bottom:4px;">Yêu cầu đang chờ duyệt</h4>
                                        <p style="font-size:14px; opacity:0.9;">Hệ thống đang tiến hành kiểm tra ảnh thẻ sinh viên của bạn. Vui lòng chờ nhân viên kiểm duyệt.</p>
                                    </div>
                                </div>
                                <div style="margin-top:20px;">
                                    <p style="font-weight:500; margin-bottom:8px; color:var(--gray-700);">Ảnh thẻ sinh viên đã gửi:</p>
                                    <img src="${pageContext.request.contextPath}/images/${studentVerify.studentCardImage}" alt="Thẻ sinh viên" style="max-width:400px; border-radius:8px; box-shadow:var(--shadow); border:1px solid var(--gray-200);">
                                </div>
                            </c:when>
                            <c:when test="${not empty studentVerify && studentVerify.status == 'rejected'}">
                                <div class="alert alert-error" style="background:#fef2f2; border-left:4px solid #b91c1c; color:#991b1b; padding:16px; border-radius:8px; display:flex; align-items:center; gap:12px; margin-bottom:20px;">
                                    <i class="fas fa-times-circle" style="font-size:24px;"></i>
                                    <div>
                                        <h4 style="font-weight:600; margin-bottom:4px;">Yêu cầu xác minh bị từ chối</h4>
                                        <p style="font-size:14px; opacity:0.9;"><strong>Lý do từ chối:</strong> ${studentVerify.staffNote}</p>
                                    </div>
                                </div>
                                <p style="margin-bottom:20px; color:var(--gray-700);">Vui lòng tải lên ảnh thẻ sinh viên hợp lệ khác dưới đây để gửi lại yêu cầu xác minh.</p>
                                
                                <form action="${pageContext.request.contextPath}/profile/student-verify" method="post" enctype="multipart/form-data">
                                    <div class="form-group" style="margin-bottom:20px;">
                                        <label style="font-weight:600; display:block; margin-bottom:8px;">Tải lên ảnh thẻ sinh viên mới</label>
                                        <input type="file" name="studentCard" accept="image/*" required class="form-control" style="padding:10px;">
                                    </div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane"></i> Gửi lại yêu cầu xác minh
                                    </button>
                                </form>
                            </c:when>

                            <c:otherwise>
                                <p style="margin-bottom:20px; color:var(--gray-700);">Để kích hoạt tài khoản Sinh viên, vui lòng chụp ảnh thẻ sinh viên của bạn rõ ràng các thông tin cá nhân và tải lên tại đây. Nhân viên của chúng tôi sẽ tiến hành phê duyệt.</p>
                                
                                <form action="${pageContext.request.contextPath}/profile/student-verify" method="post" enctype="multipart/form-data">
                                    <div class="form-group" style="margin-bottom:20px;">
                                        <label style="font-weight:600; display:block; margin-bottom:8px;">Tải lên ảnh thẻ sinh viên</label>
                                        <input type="file" name="studentCard" accept="image/*" required class="form-control" style="padding:10px;">
                                    </div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane"></i> Gửi yêu cầu xác minh
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
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

    <!-- ── ORDER DETAIL MODAL ────────────────────────────────────────── -->
    <div id="orderDetailModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; padding: 20px; animation: fadeIn 0.2s ease;">
        <div style="background: #fff; width: 100%; max-width: 650px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.25); display: flex; flex-direction: column; max-height: 85vh; animation: zoomIn 0.2s ease;">
            <!-- Modal Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 18px 24px; border-bottom: 1px solid #e2e8f0;">
                <h3 style="font-size: 18px; font-weight: 700; color: var(--gray-900);" id="modal-order-code">Chi tiết đơn hàng</h3>
                <button type="button" onclick="closeOrderDetailModal()" style="border: none; background: none; font-size: 20px; color: var(--gray-500); cursor: pointer; padding: 4px; display: flex; align-items: center; justify-content: center;"><i class="fas fa-times"></i></button>
            </div>
            
            <!-- Modal Body (Scrollable) -->
            <div style="padding: 24px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 20px;">
                <!-- Receiver Info -->
                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: var(--gray-800); margin-bottom: 10px; display: flex; align-items: center; gap: 8px;"><i class="fas fa-map-marker-alt" style="color: var(--blue-600);"></i> Thông tin nhận hàng</h4>
                    <div style="display: flex; flex-direction: column; gap: 6px; font-size: 13px; color: var(--gray-700);">
                        <p>Người nhận: <strong id="modal-receiver">...</strong></p>
                        <p>Số điện thoại: <strong id="modal-phone">...</strong></p>
                        <p>Địa chỉ: <strong id="modal-address">...</strong></p>
                    </div>
                </div>

                <!-- Products list -->
                <div>
                    <h4 style="font-size: 14px; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;"><i class="fas fa-box" style="color: var(--blue-600);"></i> Sản phẩm đã mua</h4>
                    <div id="modal-products-list" style="display: flex; flex-direction: column; gap: 12px;">
                        <!-- Injected by JS -->
                    </div>
                </div>

                <!-- Cost Summary -->
                <div style="border-top: 1px dashed #e2e8f0; padding-top: 16px; display: flex; flex-direction: column; gap: 8px; font-size: 13px; color: var(--gray-600);">
                    <div style="display: flex; justify-content: space-between;">
                        <span>Tạm tính:</span>
                        <span id="modal-subtotal" style="font-weight: 600; color: var(--gray-800);">0₫</span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Phí vận chuyển:</span>
                        <span id="modal-shipping-fee" style="font-weight: 600; color: var(--gray-800);">0₫</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px;">
                        <span>Giảm giá:</span>
                        <span id="modal-discount" style="font-weight: 600; color: var(--red-600);">-0₫</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 15px; font-weight: 700; color: var(--gray-900); padding-top: 4px;">
                        <span>Tổng thanh toán:</span>
                        <span id="modal-final-total" style="color: var(--red-600);">0₫</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Animations -->
    <style>
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes zoomIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
    </style>

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

        // ── PURCHASE HISTORY LOGIC ──────────────────────────────────────
        function formatCurrency(value) {
            return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        // Map orderId -> details data
        const orderDetailsData = {
            <c:forEach items="${userOrders}" var="ord" varStatus="status">
                "${ord.orderId}": {
                    "orderCode": "${ord.orderCode}",
                    "receiver": "${fn:replace(ord.shippingReceiver, '"', '\\"')}",
                    "phone": "${ord.shippingPhone}",
                    "address": "${fn:replace(ord.shippingAddress, '"', '\\"')}",
                    "shippingFee": ${ord.shippingFee},
                    "totalAmount": ${ord.totalAmount},
                    "items": [
                        <c:forEach items="${ord.details}" var="item" varStatus="iStatus">
                            {
                                "productName": "${fn:replace(item.productName, '"', '\\"')}",
                                "variantName": "${fn:replace(item.variantName, '"', '\\"')}",
                                "quantity": ${item.quantity},
                                "unitPrice": ${item.unitPrice},
                                "thumbnail": "${item.thumbnail}"
                            }${not iStatus.last ? ',' : ''}
                        </c:forEach>
                    ]
                }${not status.last ? ',' : ''}
            </c:forEach>
        };

        function showOrderDetail(orderId) {
            const ord = orderDetailsData[orderId];
            if (!ord) return;

            document.getElementById('modal-order-code').innerText = "Chi tiết đơn hàng #" + ord.orderCode;
            document.getElementById('modal-receiver').innerText = ord.receiver;
            document.getElementById('modal-phone').innerText = ord.phone;
            document.getElementById('modal-address').innerText = ord.address;

            // Render products
            const productsContainer = document.getElementById('modal-products-list');
            productsContainer.innerHTML = '';
            
            let subtotal = 0;
            ord.items.forEach(item => {
                const itemSub = item.quantity * item.unitPrice;
                subtotal += itemSub;

                const itemDiv = document.createElement('div');
                itemDiv.style.display = 'flex';
                itemDiv.style.gap = '12px';
                itemDiv.style.alignItems = 'center';
                itemDiv.style.justifyContent = 'space-between';
                itemDiv.style.padding = '8px 0';
                itemDiv.style.borderBottom = '1px solid #f1f5f9';

                itemDiv.innerHTML = `
                    <div style="display: flex; gap: 12px; align-items: center; min-width: 0; flex: 1;">
                        <img src="${pageContext.request.contextPath}/images/\${item.thumbnail}" 
                             onerror="this.src='https://placehold.co/60x50/f1f5f9/94a3b8?text=UniLap'" 
                             alt="product" style="width: 50px; height: 40px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0; flex-shrink:0;">
                        <div style="min-width: 0;">
                            <p style="font-size: 13px; font-weight: 600; color: var(--gray-800); margin-bottom: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="\${item.productName}">\${item.productName}</p>
                            <p style="font-size: 12px; color: var(--gray-500);">Phân loại: \${item.variantName}</p>
                        </div>
                    </div>
                    <div style="text-align: right; flex-shrink: 0; font-size: 13px; margin-left: 10px;">
                        <p style="font-weight: 600; color: var(--gray-800);">\${formatCurrency(item.unitPrice)}₫</p>
                        <p style="color: var(--gray-500); font-size: 11px;">x\${item.quantity}</p>
                    </div>
                `;
                productsContainer.appendChild(itemDiv);
            });

            // Calculate costs
            const shippingFee = ord.shippingFee;
            const finalTotal = ord.totalAmount;
            const discount = subtotal + shippingFee - finalTotal;

            document.getElementById('modal-subtotal').innerText = formatCurrency(subtotal) + '₫';
            document.getElementById('modal-shipping-fee').innerText = formatCurrency(shippingFee) + '₫';
            document.getElementById('modal-discount').innerText = (discount > 0 ? "- " + formatCurrency(discount) : "0") + '₫';
            document.getElementById('modal-final-total').innerText = formatCurrency(finalTotal) + '₫';

            const modal = document.getElementById('orderDetailModal');
            modal.style.display = 'flex';
        }

        function closeOrderDetailModal() {
            document.getElementById('orderDetailModal').style.display = 'none';
        }

        // Close modal clicking outside
        window.addEventListener('click', function(e) {
            const modal = document.getElementById('orderDetailModal');
            if (e.target === modal) {
                closeOrderDetailModal();
            }
        });

        // Filter functionality
        const statusTabs = document.querySelectorAll('.status-tab');
        const orderCards = document.querySelectorAll('.order-card');
        const emptyState = document.getElementById('orders-empty-state');
        const startDateInput = document.getElementById('order-start-date');
        const endDateInput = document.getElementById('order-end-date');

        statusTabs.forEach(tab => {
            tab.addEventListener('click', function() {
                statusTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                filterOrders();
            });
        });

        if (startDateInput && endDateInput) {
            startDateInput.addEventListener('change', filterOrders);
            endDateInput.addEventListener('change', filterOrders);
        }

        function filterOrders() {
            const activeTab = document.querySelector('.status-tab.active');
            const selectedStatus = activeTab ? activeTab.getAttribute('data-status') : 'all';
            
            const startVal = startDateInput ? startDateInput.value : '';
            const endVal = endDateInput ? endDateInput.value : '';
            
            const startDate = startVal ? new Date(startVal) : null;
            const endDate = endVal ? new Date(endVal) : null;
            if (endDate) {
                endDate.setHours(23, 59, 59, 999);
            }

            let visibleCount = 0;

            orderCards.forEach(card => {
                const cardStatus = card.getAttribute('data-status');
                const cardDateStr = card.getAttribute('data-date');
                const cardDate = new Date(cardDateStr);

                // Check status
                let statusMatch = false;
                if (selectedStatus === 'all') {
                    statusMatch = true;
                } else if (selectedStatus === 'delivered') {
                    statusMatch = (cardStatus === 'delivered' || cardStatus === 'Completed');
                } else if (selectedStatus === 'cancelled') {
                    statusMatch = (cardStatus === 'cancelled' || cardStatus === 'Cancelled');
                } else {
                    statusMatch = (cardStatus === selectedStatus);
                }

                // Check date
                let dateMatch = true;
                if (startDate && cardDate < startDate) {
                    dateMatch = false;
                }
                if (endDate && cardDate > endDate) {
                    dateMatch = false;
                }

                if (statusMatch && dateMatch) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            if (emptyState) {
                if (visibleCount === 0) {
                    emptyState.style.display = 'block';
                } else {
                    emptyState.style.display = 'none';
                }
            }
        }

        // ── ON LOAD ─────────────────────────────────────────────────────
        window.addEventListener('load', function() {
            // Set current date to end date filter input dynamically
            if (endDateInput && !endDateInput.value) {
                const today = new Date();
                const yyyy = today.getFullYear();
                let mm = today.getMonth() + 1;
                let dd = today.getDate();
                if (dd < 10) dd = '0' + dd;
                if (mm < 10) mm = '0' + mm;
                endDateInput.value = yyyy + '-' + mm + '-' + dd;
            }

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
    <!-- Modal Đánh Giá Sản Phẩm -->
    <div id="reviewModal" class="review-modal">
        <div class="review-modal-content">
            <div class="review-modal-header">
                <h3>Đánh giá sản phẩm</h3>
                <span class="review-modal-close" onclick="closeReviewModal()">&times;</span>
            </div>
            <div class="review-modal-body" id="reviewModalBody">
                <!-- Nội dung đánh giá sẽ được chèn động ở đây -->
            </div>
        </div>
    </div>

    <script>
        // Store ratings for each product dynamically in an object
        const currentRatings = {};

        function openOrderReviewModal(orderId) {
            const jsonElement = document.getElementById('order-details-json-' + orderId);
            if (!jsonElement) return;
            const items = JSON.parse(jsonElement.textContent);
            
            let html = '';
            items.forEach(item => {
                html += `
                    <div class="review-item" id="review-item-${item.productId}">
                        <div class="review-product-info">
                            <img src="${pageContext.request.contextPath}/images/${item.thumbnail}" onerror="this.src='https://placehold.co/80x60/f1f5f9/94a3b8?text=UniLap'" class="review-product-img">
                            <div>
                                <div class="review-product-name">${item.productName}</div>
                                <div class="review-product-variant">Cấu hình: ${item.variantName}</div>
                            </div>
                        </div>
                `;
                
                if (item.reviewed) {
                    html += `
                        <div class="review-success-badge" style="margin-top: 10px;">
                            <i class="fas fa-check-circle"></i> Đã đánh giá
                        </div>
                    `;
                } else {
                    html += `
                        <div style="display:flex; flex-direction:column; gap:10px; margin-top: 10px;">
                            <div class="review-stars" id="stars-${item.productId}">
                                <i class="fa-regular fa-star" onclick="setRating(${item.productId}, 1)" data-val="1"></i>
                                <i class="fa-regular fa-star" onclick="setRating(${item.productId}, 2)" data-val="2"></i>
                                <i class="fa-regular fa-star" onclick="setRating(${item.productId}, 3)" data-val="3"></i>
                                <i class="fa-regular fa-star" onclick="setRating(${item.productId}, 4)" data-val="4"></i>
                                <i class="fa-regular fa-star" onclick="setRating(${item.productId}, 5)" data-val="5"></i>
                            </div>
                            <textarea class="review-comment" id="comment-${item.productId}" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                            <button type="button" class="btn btn-primary review-submit-btn" onclick="submitProductReview(${item.productId}, ${orderId})" id="btn-submit-${item.productId}" style="background: linear-gradient(135deg, #1d4ed8, #1e3a8a); color: #fff;">
                                Gửi đánh giá
                            </button>
                        </div>
                    `;
                }
                
                html += `</div>`;
            });
            
            document.getElementById('reviewModalBody').innerHTML = html;
            const modal = document.getElementById('reviewModal');
            modal.style.display = 'flex';
            setTimeout(() => modal.classList.add('show'), 10);
        }

        function closeReviewModal() {
            const modal = document.getElementById('reviewModal');
            modal.classList.remove('show');
            setTimeout(() => {
                modal.style.display = 'none';
            }, 300);
        }

        function setRating(productId, rating) {
            currentRatings[productId] = rating;
            const starsContainer = document.getElementById('stars-' + productId);
            const stars = starsContainer.querySelectorAll('i');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.className = 'fa-solid fa-star active';
                } else {
                    star.className = 'fa-regular fa-star';
                }
            });
        }

        function submitProductReview(productId, orderId) {
            const rating = currentRatings[productId];
            if (!rating) {
                showToast('Vui lòng chọn số sao đánh giá!', 'error');
                return;
            }
            const comment = document.getElementById('comment-' + productId).value.trim();
            if (!comment) {
                showToast('Vui lòng nhập nhận xét sản phẩm!', 'error');
                return;
            }
            
            const btn = document.getElementById('btn-submit-' + productId);
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
            
            fetch('${pageContext.request.contextPath}/ProductDetailServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productId=' + productId + '&rating=' + rating + '&comment=' + encodeURIComponent(comment) + '&ajax=true'
            })
            .then(res => res.text())
            .then(data => {
                if (data.trim() === 'success') {
                    showToast('Đánh giá sản phẩm thành công!');
                    
                    // Update dynamic review status in hidden JSON text
                    const jsonElement = document.getElementById('order-details-json-' + orderId);
                    if (jsonElement) {
                        const items = JSON.parse(jsonElement.textContent);
                        let allReviewed = true;
                        items.forEach(item => {
                            if (item.productId === productId) {
                                item.reviewed = true;
                            }
                            if (!item.reviewed) {
                                allReviewed = false;
                            }
                        });
                        jsonElement.textContent = JSON.stringify(items);
                        
                        // Update status button in order history page list
                        const actionContainer = document.getElementById('action-order-' + orderId);
                        if (actionContainer) {
                            if (allReviewed) {
                                actionContainer.innerHTML = `
                                    <span class="review-success-badge" style="font-size: 11px; padding: 4px 10px; border-radius: 20px; display: inline-flex; align-items: center; gap: 4px;">
                                        <i class="fas fa-check-circle"></i> Đã đánh giá
                                    </span>
                                `;
                            }
                        }
                    }
                    
                    // Update UI inside the modal directly
                    const container = document.getElementById('review-item-' + productId);
                    const prodName = container.querySelector('.review-product-name').textContent;
                    const prodVariant = container.querySelector('.review-product-variant').textContent;
                    const prodImg = container.querySelector('.review-product-img').src;
                    
                    container.innerHTML = `
                        <div class="review-product-info">
                            <img src="${prodImg}" class="review-product-img">
                            <div>
                                <div class="review-product-name">${prodName}</div>
                                <div class="review-product-variant">${prodVariant}</div>
                            </div>
                        </div>
                        <div class="review-success-badge" style="margin-top: 10px;">
                            <i class="fas fa-check-circle"></i> Đã đánh giá
                        </div>
                    `;
                } else {
                    showToast('Gửi đánh giá thất bại. Vui lòng thử lại!', 'error');
                    btn.disabled = false;
                    btn.innerHTML = 'Gửi đánh giá';
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Đã xảy ra lỗi kết nối!', 'error');
                btn.disabled = false;
                btn.innerHTML = 'Gửi đánh giá';
            });
        }

        function showToast(message, type = 'success') {
            let toast = document.createElement('div');
            toast.className = 'toast-notification';
            const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
            const color = type === 'success' ? '#22c55e' : '#ef4444';
            toast.innerHTML = `<i class="fas ${icon}" style="color: ${color}"></i> <span>${message}</span>`;
            document.body.appendChild(toast);
            
            // trigger reflow
            toast.offsetHeight;
            toast.classList.add('show');
            
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => {
                    toast.remove();
                }, 300);
            }, 3000);
        }

        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('reviewModal');
            if (event.target === modal) {
                closeReviewModal();
            }
        });
    </script>
</body>
</html>

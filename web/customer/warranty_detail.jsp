<%-- 
    Page: warranty_detail.jsp
    Mo ta: Trang chi tiết và theo dõi trạng thái một phiếu bảo hành của khách hàng.
    
    Created: 2026-06-26 11:52:20 +0700
    Updated: 2026-07-11 23:28:45 +0700
    Version: v1.0
    
    @author DuyLD
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<%
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warranty Claim #${selectedClaim.claimId} – UNILAP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.5;
        }

        /* ── Header (synced with warranty_center.jsp) ── */
        .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .header {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(12px);
            position: sticky; top: 0; z-index: 100;
            border-bottom: 1px solid rgba(255,255,255,0.3);
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .header-container {
            display: flex; align-items: center;
            justify-content: space-between; height: 70px;
        }
        .logo { font-size: 24px; font-weight: 800; color: #1a56db; letter-spacing: -0.5px; text-decoration: none; }
        .main-nav { display: flex; gap: 32px; }
        .main-nav a { font-weight: 500; color: #64748b; font-size: 15px; text-decoration: none; transition: color 0.2s; }
        .main-nav a:hover { color: #1a56db; }
        .header-icons { display: flex; gap: 20px; align-items: center; }
        .header-icons a { color: #1e293b; font-size: 18px; text-decoration: none; transition: color 0.2s; }
        .header-icons a:hover { color: #1a56db; }

        /* ── Page layout ── */
        .page-wrap {
            flex: 1;
            max-width: 900px;
            margin: 32px auto 48px;
            padding: 0 24px;
            width: 100%;
        }

        /* ── Breadcrumb ── */
        .breadcrumb {
            display: flex; align-items: center; gap: 8px;
            font-size: 13px; color: #9ca3af;
            margin-bottom: 20px;
        }
        .breadcrumb a { color: #2563eb; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #d1d5db; }

        /* ── Flash ── */
        .alert-success, .alert-error {
            padding: 12px 16px; border-radius: 8px;
            font-size: 13.5px; font-weight: 500; margin-bottom: 20px;
        }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error   { background: #fef2f2; color: #dc2626; border: 1px solid #fca5a5; }

        /* ── Header row ── */
        .detail-header {
            display: flex; align-items: flex-start;
            justify-content: space-between; gap: 16px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .detail-header-left h1 {
            font-size: 22px; font-weight: 800; color: #111827; letter-spacing: -0.3px;
        }
        .detail-header-left .meta {
            font-size: 13px; color: #6b7280; margin-top: 4px;
        }

        /* Status badge */
        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 5px 12px; border-radius: 20px;
            font-size: 12.5px; font-weight: 700; white-space: nowrap;
        }
        .badge-PENDING    { background: #fef3c7; color: #92400e; }
        .badge-PROCESSING { background: #dbeafe; color: #1d4ed8; }
        .badge-APPROVED   { background: #d1fae5; color: #065f46; }
        .badge-REJECTED   { background: #fee2e2; color: #991b1b; }
        .badge-COMPLETED  { background: #f3f4f6; color: #374151; }
        .badge-CANCELLED  { background: #f3f4f6; color: #6b7280; }

        /* ── Grid: info + timeline ── */
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 20px;
            align-items: start;
        }
        @media (max-width: 680px) {
            .detail-grid { grid-template-columns: 1fr; }
        }

        /* ── Card base ── */
        .card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 24px;
        }
        .card + .card { margin-top: 16px; }
        .card-title {
            font-size: 13px; font-weight: 700;
            color: #6b7280; text-transform: uppercase;
            letter-spacing: 0.06em; margin-bottom: 16px;
        }

        /* ── Claim info table ── */
        .info-table { width: 100%; border-collapse: collapse; }
        .info-table tr { border-bottom: 1px solid #f3f4f6; }
        .info-table tr:last-child { border-bottom: none; }
        .info-table th {
            text-align: left; font-size: 12px; font-weight: 600;
            color: #9ca3af; text-transform: uppercase;
            letter-spacing: 0.05em; padding: 10px 0 10px 0;
            width: 130px; vertical-align: top;
        }
        .info-table td {
            font-size: 13.5px; color: #374151;
            padding: 10px 0; vertical-align: top;
        }
        .desc-text {
            white-space: pre-wrap;
            line-height: 1.6;
            font-size: 13.5px;
            color: #374151;
        }

        /* ── Status progress bar ── */
        .status-steps {
            display: flex;
            flex-direction: column;
            gap: 0;
        }
        .step-item {
            display: flex;
            gap: 12px;
            position: relative;
        }
        .step-item:not(:last-child) .step-line {
            position: absolute;
            left: 11px; top: 24px;
            width: 2px; height: calc(100% - 8px);
            background: #e5e7eb;
        }
        .step-item.done .step-line { background: #2563eb; }

        .step-dot {
            width: 24px; height: 24px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 11px; font-weight: 700;
            border: 2px solid #e5e7eb;
            background: #fff; color: #9ca3af;
            position: relative; z-index: 1;
        }
        .step-item.done .step-dot {
            background: #2563eb; border-color: #2563eb; color: #fff;
        }
        .step-item.current .step-dot {
            background: #fff; border-color: #2563eb; color: #2563eb;
        }
        .step-item.rejected .step-dot {
            background: #ef4444; border-color: #ef4444; color: #fff;
        }
        .step-item.cancelled .step-dot {
            background: #9ca3af; border-color: #9ca3af; color: #fff;
        }

        .step-content {
            padding: 0 0 20px 0;
            flex: 1;
        }
        .step-label {
            font-size: 13px; font-weight: 600; color: #374151;
            line-height: 1.4;
        }
        .step-item.current .step-label { color: #2563eb; }
        .step-item.rejected .step-label { color: #dc2626; }
        .step-item.cancelled .step-label { color: #9ca3af; }

        .step-sub {
            font-size: 11.5px; color: #9ca3af; margin-top: 2px;
        }

        /* ── Audit history ── */
        .history-list { display: flex; flex-direction: column; gap: 12px; }
        .history-item {
            background: #f8fafc;
            border: 1px solid #f1f5f9;
            border-radius: 10px;
            padding: 12px 14px;
        }
        .history-item-header {
            display: flex; align-items: center;
            justify-content: space-between; gap: 8px;
            margin-bottom: 6px;
        }
        .history-date { font-size: 11.5px; color: #9ca3af; }
        .history-note { font-size: 13px; color: #374151; line-height: 1.5; }

        /* ── Image gallery ── */
        .image-gallery {
            display: flex; flex-wrap: wrap; gap: 10px;
        }
        .gallery-thumb {
            width: 80px; height: 80px;
            border-radius: 10px; overflow: hidden;
            border: 1px solid #e5e7eb; cursor: pointer;
            transition: transform 0.15s, box-shadow 0.15s;
            flex-shrink: 0;
        }
        .gallery-thumb:hover {
            transform: scale(1.04);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        .gallery-thumb img {
            width: 100%; height: 100%; object-fit: cover; display: block;
        }
        .no-images { font-size: 13px; color: #9ca3af; }

        /* ── Lightbox ── */
        #lightbox {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.85);
            z-index: 9999; align-items: center; justify-content: center;
        }
        #lightbox.open { display: flex; }
        #lightbox img {
            max-width: 90vw; max-height: 88vh;
            border-radius: 12px; object-fit: contain;
        }
        #lightbox-close {
            position: absolute; top: 16px; right: 20px;
            color: #fff; font-size: 28px; cursor: pointer;
            line-height: 1; background: none; border: none;
        }

        /* ── Action bar ── */
        .action-bar {
            display: flex; align-items: center;
            justify-content: space-between; gap: 12px;
            margin-top: 24px; flex-wrap: wrap;
        }
        .btn {
            display: inline-flex; align-items: center; gap: 7px;
            border: none; cursor: pointer; border-radius: 8px;
            font-size: 13.5px; font-weight: 600;
            padding: 10px 20px; transition: all 0.15s;
            text-decoration: none; font-family: inherit;
        }
        .btn-outline {
            background: #fff; border: 1.5px solid #e5e7eb; color: #374151;
        }
        .btn-outline:hover { border-color: #9ca3af; background: #f9fafb; }
        .btn-danger {
            background: #fff; border: 1.5px solid #ef4444; color: #ef4444;
        }
        .btn-danger:hover { background: #fef2f2; }

        /* ── Empty state ── */
        .empty-state {
            text-align: center; padding: 64px 24px;
        }
        .empty-state .icon { font-size: 48px; margin-bottom: 16px; }
        .empty-state h2 { font-size: 20px; font-weight: 700; color: #111827; margin-bottom: 8px; }
        .empty-state p  { font-size: 14px; color: #6b7280; margin-bottom: 20px; }

        /* ── Footer ── */
        .footer { background: #f8fafc; padding: 40px 0 20px; border-top: 1px solid #e2e8f0; margin-top: auto; }
        .footer-bottom { text-align: center; padding-top: 20px; border-top: 1px solid #e2e8f0; color: #64748b; font-size: 13px; }
    </style>
</head>
<body>

<!-- ════ HEADER ════ -->
<header class="header">
    <div class="container header-container">
        <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list" class="active">Bảo hành</a>
        </nav>
        <div class="header-icons">
            <a href="#"><i class="fas fa-shopping-cart"></i></a>
            <a href="#"><i class="fas fa-bell"></i></a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div style="position:relative;display:inline-block;">
                        <a href="#" class="user-menu-trigger"
                           style="display:flex;align-items:center;gap:5px;text-decoration:none;color:inherit;">
                            <i class="fas fa-user"></i>
                            <span style="font-size:13px;font-weight:500;">${sessionScope.user.userName}</span>
                        </a>
                        <div class="user-menu-dropdown-content"
                             style="display:none;position:absolute;right:0;background:#fff;
                                    min-width:150px;box-shadow:0 8px 16px rgba(0,0,0,0.15);
                                    z-index:1000;border-radius:8px;margin-top:8px;
                                    border:1px solid #e2e8f0;padding:6px 0;">
                            <a href="${pageContext.request.contextPath}/profile" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
                            <a href="${pageContext.request.contextPath}/warranty?action=list"
                               style="color:#1e293b;padding:8px 16px;display:block;font-size:13px;text-decoration:none;">
                                Bảo hành của tôi
                            </a>
                            <div style="border-top:1px solid #f1f5f9;margin:6px 0;"></div>
                            <a href="${pageContext.request.contextPath}/logout"
                               style="color:#ef4444;padding:8px 16px;display:block;font-size:13px;font-weight:500;text-decoration:none;">
                                Đăng xuất
                            </a>
                        </div>
                    </div>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            var trigger = document.querySelector('.user-menu-trigger');
                            if (trigger) {
                                trigger.addEventListener('click', function (e) {
                                    e.preventDefault(); e.stopPropagation();
                                    var dd = this.nextElementSibling;
                                    dd.style.display = dd.style.display === 'block' ? 'none' : 'block';
                                });
                            }
                            document.addEventListener('click', function () {
                                document.querySelectorAll('.user-menu-dropdown-content')
                                    .forEach(function (d) { d.style.display = 'none'; });
                            });
                        });
                    </script>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- ════ MAIN ════ -->
<div class="page-wrap">

    <!-- Breadcrumb -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/warranty?action=list">
            <i class="fas fa-shield-alt" style="margin-right:4px;"></i>Warranty Center
        </a>
        <span>/</span>
        <span>Claim #<c:out value="${selectedClaim.claimId}"/></span>
    </div>

    <!-- Flash messages -->
    <c:if test="${not empty param.msg}">
        <c:choose>
            <c:when test="${param.msg == 'cancelled'}">
                <div class="alert-success">🗑️ Yêu cầu bảo hành đã được huỷ thành công.</div>
            </c:when>
            <c:when test="${param.msg == 'updated'}">
                <div class="alert-success">🔄 Trạng thái yêu cầu bảo hành đã được cập nhật.</div>
            </c:when>
        </c:choose>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠️ <c:out value="${errorMessage}"/></div>
    </c:if>

    <!-- ── Empty / not found ── -->
    <c:choose>
    <c:when test="${empty selectedClaim}">
        <div class="empty-state">
            <div class="icon">🔍</div>
            <h2>Không tìm thấy yêu cầu bảo hành</h2>
            <p>Claim không tồn tại hoặc bạn không có quyền xem.</p>
            <a class="btn btn-outline" href="${pageContext.request.contextPath}/warranty?action=list">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </c:when>
    <c:otherwise>

    <!-- ── Detail header ── -->
    <div class="detail-header">
        <div class="detail-header-left">
            <h1><c:out value="${selectedClaim.title}"/></h1>
            <div class="meta">
                Claim #${selectedClaim.claimId}
                &nbsp;·&nbsp;
                Tạo lúc <fmt:formatDate value="${selectedClaim.createdAt}" pattern="HH:mm, dd/MM/yyyy"/>
                <c:if test="${not empty selectedClaim.productName}">
                    &nbsp;·&nbsp; <c:out value="${selectedClaim.productName}"/>
                </c:if>
            </div>
        </div>
        <span class="badge badge-${selectedClaim.status}">${selectedClaim.status}</span>
    </div>

    <!-- ── Main grid ── -->
    <div class="detail-grid">

        <!-- ── LEFT: Claim info + Images + History ── -->
        <div>

            <!-- Claim info -->
            <div class="card">
                <div class="card-title"><i class="fas fa-info-circle" style="margin-right:6px;"></i>Thông tin yêu cầu</div>
                <table class="info-table">
                    <tr>
                        <th>Serial Number</th>
                        <td><code style="font-size:13px;background:#f1f5f9;padding:2px 7px;border-radius:4px;">
                            <c:out value="${selectedClaim.serialNumber}"/>
                        </code></td>
                    </tr>
                    <tr>
                        <th>Sản phẩm</th>
                        <td><c:out value="${selectedClaim.productName}"/></td>
                    </tr>
                    <tr>
                        <th>Order ID</th>
                        <td>#${selectedClaim.orderId}</td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td><span class="badge badge-${selectedClaim.status}">${selectedClaim.status}</span></td>
                    </tr>
                    <tr>
                        <th>Ngày gửi</th>
                        <td><fmt:formatDate value="${selectedClaim.createdAt}" pattern="HH:mm, dd/MM/yyyy"/></td>
                    </tr>
                    <c:if test="${not empty selectedClaim.updatedAt}">
                    <tr>
                        <th>Cập nhật</th>
                        <td><fmt:formatDate value="${selectedClaim.updatedAt}" pattern="HH:mm, dd/MM/yyyy"/></td>
                    </tr>
                    </c:if>
                    <c:if test="${not empty selectedClaim.completedAt}">
                    <tr>
                        <th>Hoàn thành</th>
                        <td><fmt:formatDate value="${selectedClaim.completedAt}" pattern="HH:mm, dd/MM/yyyy"/></td>
                    </tr>
                    </c:if>
                    <tr>
                        <th>Mô tả lỗi</th>
                        <td><pre class="desc-text"><c:out value="${selectedClaim.description}"/></pre></td>
                    </tr>
                </table>
            </div>

            <!-- Evidence images -->
            <div class="card">
                <div class="card-title"><i class="fas fa-images" style="margin-right:6px;"></i>Ảnh đính kèm</div>
                <c:choose>
                    <c:when test="${empty selectedImages}">
                        <span class="no-images">Không có ảnh đính kèm.</span>
                    </c:when>
                    <c:otherwise>
                        <div class="image-gallery">
                            <c:forEach var="img" items="${selectedImages}">
                                <div class="gallery-thumb"
                                     onclick="openLightbox('${pageContext.request.contextPath}${img.imageUrl}')">
                                    <img src="${pageContext.request.contextPath}${img.imageUrl}"
                                         alt="Evidence image"
                                         onerror="this.parentElement.style.display='none'">
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Audit history -->
            <div class="card">
                <div class="card-title"><i class="fas fa-history" style="margin-right:6px;"></i>Lịch sử xử lý</div>
                <c:choose>
                    <c:when test="${empty selectedHistory}">
                        <span class="no-images">Chưa có lịch sử.</span>
                    </c:when>
                    <c:otherwise>
                        <div class="history-list">
                            <c:forEach var="h" items="${selectedHistory}">
                                <div class="history-item">
                                    <div class="history-item-header">
                                        <span class="badge badge-${h.repairStatus}">${h.repairStatus}</span>
                                        <span class="history-date">
                                            <fmt:formatDate value="${h.createdAt}" pattern="HH:mm, dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    <c:if test="${not empty h.repairNote}">
                                        <div class="history-note"><c:out value="${h.repairNote}"/></div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div><!-- end left -->

        <!-- ── RIGHT: Status timeline ── -->
        <div>
            <div class="card">
                <div class="card-title"><i class="fas fa-route" style="margin-right:6px;"></i>Tiến trình xử lý</div>

                <%-- Determine current step index for styling --%>
                <c:set var="st" value="${selectedClaim.status}"/>

                <div class="status-steps">

                    <%-- PENDING --%>
                    <div class="step-item
                        ${st == 'PENDING'    ? 'current' : ''}
                        ${st == 'PROCESSING' || st == 'APPROVED' || st == 'COMPLETED' ? 'done' : ''}
                        ${st == 'CANCELLED'  ? 'cancelled' : ''}">
                        <div class="step-line"></div>
                        <div class="step-dot">
                            <c:choose>
                                <c:when test="${st == 'PENDING'}"><i class="fas fa-clock"></i></c:when>
                                <c:when test="${st == 'CANCELLED'}"><i class="fas fa-ban"></i></c:when>
                                <c:otherwise><i class="fas fa-check"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="step-content">
                            <div class="step-label">Đã gửi yêu cầu</div>
                            <div class="step-sub">
                                <fmt:formatDate value="${selectedClaim.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                    </div>

                    <%-- PROCESSING --%>
                    <c:if test="${st != 'CANCELLED'}">
                    <div class="step-item
                        ${st == 'PROCESSING' ? 'current' : ''}
                        ${st == 'APPROVED' || st == 'COMPLETED' || st == 'REJECTED' ? 'done' : ''}">
                        <div class="step-line"></div>
                        <div class="step-dot">
                            <c:choose>
                                <c:when test="${st == 'PROCESSING'}"><i class="fas fa-spinner"></i></c:when>
                                <c:when test="${st == 'APPROVED' || st == 'COMPLETED' || st == 'REJECTED'}"><i class="fas fa-check"></i></c:when>
                                <c:otherwise>2</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="step-content">
                            <div class="step-label">Đang xử lý</div>
                            <div class="step-sub">Staff đang kiểm tra</div>
                        </div>
                    </div>
                    </c:if>

                    <%-- REJECTED branch --%>
                    <c:if test="${st == 'REJECTED'}">
                    <div class="step-item rejected">
                        <div class="step-dot"><i class="fas fa-times"></i></div>
                        <div class="step-content">
                            <div class="step-label">Bị từ chối</div>
                            <div class="step-sub">Xem lý do trong lịch sử</div>
                        </div>
                    </div>
                    </c:if>

                    <%-- APPROVED --%>
                    <c:if test="${st != 'CANCELLED' && st != 'REJECTED'}">
                    <div class="step-item
                        ${st == 'APPROVED'  ? 'current' : ''}
                        ${st == 'COMPLETED' ? 'done'    : ''}">
                        <div class="step-line"></div>
                        <div class="step-dot">
                            <c:choose>
                                <c:when test="${st == 'APPROVED'}"><i class="fas fa-thumbs-up"></i></c:when>
                                <c:when test="${st == 'COMPLETED'}"><i class="fas fa-check"></i></c:when>
                                <c:otherwise>3</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="step-content">
                            <div class="step-label">Đã duyệt</div>
                            <div class="step-sub">Bảo hành được chấp nhận</div>
                        </div>
                    </div>
                    </c:if>

                    <%-- COMPLETED --%>
                    <c:if test="${st != 'CANCELLED' && st != 'REJECTED'}">
                    <div class="step-item ${st == 'COMPLETED' ? 'done' : ''}">
                        <div class="step-dot">
                            <c:choose>
                                <c:when test="${st == 'COMPLETED'}"><i class="fas fa-check-double"></i></c:when>
                                <c:otherwise>4</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="step-content">
                            <div class="step-label">Hoàn tất</div>
                            <c:if test="${not empty selectedClaim.completedAt}">
                                <div class="step-sub">
                                    <fmt:formatDate value="${selectedClaim.completedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </c:if>
                            <c:if test="${empty selectedClaim.completedAt}">
                                <div class="step-sub">Sản phẩm được trả lại</div>
                            </c:if>
                        </div>
                    </div>
                    </c:if>

                    <%-- CANCELLED --%>
                    <c:if test="${st == 'CANCELLED'}">
                    <div class="step-item cancelled">
                        <div class="step-dot"><i class="fas fa-ban"></i></div>
                        <div class="step-content">
                            <div class="step-label">Đã huỷ</div>
                            <div class="step-sub">Yêu cầu đã bị huỷ</div>
                        </div>
                    </div>
                    </c:if>

                </div><!-- end status-steps -->
            </div><!-- end card -->
        </div><!-- end right -->

    </div><!-- end detail-grid -->

    <!-- ── Action bar ── -->
    <div class="action-bar">
        <a class="btn btn-outline"
           href="${pageContext.request.contextPath}/warranty?action=list">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>

        <c:if test="${selectedClaim.status == 'PENDING'}">
            <form action="${pageContext.request.contextPath}/warranty" method="post"
                  onsubmit="return confirm('Bạn có chắc muốn huỷ yêu cầu #${selectedClaim.claimId}?')">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id"     value="${selectedClaim.claimId}">
                <button type="submit" class="btn btn-danger">
                    <i class="fas fa-times-circle"></i> Huỷ yêu cầu
                </button>
            </form>
        </c:if>
    </div>

    </c:otherwise>
    </c:choose>

</div><!-- end page-wrap -->

<!-- Lightbox -->
<div id="lightbox" onclick="closeLightbox()">
    <button id="lightbox-close" onclick="closeLightbox()">&times;</button>
    <img id="lightbox-img" src="" alt="Evidence">
</div>

<!-- ════ FOOTER ════ -->
<%@include file="_footer.jspf" %>

<script>
    function openLightbox(src) {
        document.getElementById('lightbox-img').src = src;
        document.getElementById('lightbox').classList.add('open');
    }
    function closeLightbox() {
        document.getElementById('lightbox').classList.remove('open');
        document.getElementById('lightbox-img').src = '';
    }
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeLightbox();
    });
</script>
<jsp:include page="chatbot.jsp" />
</body>
</html>

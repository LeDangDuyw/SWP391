<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN"/>

<%
    // Bảo vệ trang: chỉ cho customer (roleId = 3) hoặc người dùng đã đăng nhập truy cập
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Yêu Cầu Bảo Hành – UNILAP</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
            }

            /* ── Header (synced with warranty_center.jsp) ── */
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
                align-items: center;
                gap: 32px;
            }
            .main-nav a {
                font-weight: 500;
                color: #64748b;
                font-size: 15px;
                position: relative;
                text-decoration: none;
                transition: all 0.3s ease;
                white-space: nowrap;
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
                white-space: nowrap;
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

            /* ── Page Layout ── */
            .page-wrap {
                max-width: 1200px;
                margin: 32px auto 60px;
                padding: 0 20px;
                width: 100%;
                flex: 1;
            }

            /* ── Tab Navigation ── */
            .warranty-tabs {
                display: flex;
                justify-content: center;
                gap: 12px;
                margin-bottom: 24px;
                border-bottom: 2px solid #e2e8f0;
                padding-bottom: 12px;
            }
            .tab-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                border-radius: 8px;
                font-size: 14.5px;
                font-weight: 600;
                text-decoration: none;
                color: #64748b;
                background: #ffffff;
                border: 1px solid #cbd5e1;
                transition: all 0.2s ease;
            }
            .tab-btn:hover {
                color: #1d4ed8;
                border-color: #93c5fd;
                background: #eff6ff;
            }
            .tab-btn.active {
                color: #ffffff;
                background: #2563eb;
                border-color: #2563eb;
                box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
            }

            /* ── Card Component ── */
            .card {
                background: #ffffff;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.04);
                padding: 24px;
                margin-bottom: 24px;
            }

            .track-claim-card {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                max-width: 600px;
                margin: 0 auto 32px;
            }
            .track-claim-card .card-icon-wrap {
                width: 52px;
                height: 52px;
                background: #eff6ff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 22px;
                margin-bottom: 12px;
            }
            .track-claim-card h3 {
                font-size: 18px;
                font-weight: 700;
                color: #0f172a;
                margin-bottom: 6px;
            }
            .track-claim-card p {
                font-size: 13.5px;
                color: #64748b;
                margin-bottom: 16px;
            }
            .track-claim-card form {
                width: 100%;
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            .track-claim-card input[type="text"] {
                flex: 1;
                max-width: 320px;
                padding: 10px 14px;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                font-size: 14px;
                outline: none;
            }
            .track-claim-card input[type="text"]:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
            }
            .btn-track {
                padding: 10px 20px;
                background: #2563eb;
                color: #ffffff;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .btn-track:hover {
                background: #1d4ed8;
            }

            /* ── Section Title ── */
            .section-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 16px;
            }
            .section-header h3 {
                font-size: 19px;
                font-weight: 700;
                color: #0f172a;
            }

            /* ── Table ── */
            .activity-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                overflow: hidden;
                background: #ffffff;
            }
            .activity-table th {
                background: #f8fafc;
                color: #475569;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                padding: 14px 16px;
                text-align: left;
                border-bottom: 1px solid #e2e8f0;
            }
            .activity-table td {
                padding: 16px;
                border-bottom: 1px solid #f1f5f9;
                font-size: 13.5px;
                color: #334155;
                vertical-align: middle;
            }
            .activity-table tr:last-child td {
                border-bottom: none;
            }
            .activity-table tr:hover td {
                background: #f8fafc;
            }

            .claim-ref {
                font-weight: 700;
                color: #2563eb;
            }
            .claim-date {
                font-size: 12px;
                color: #94a3b8;
                margin-top: 2px;
            }

            /* Status badges */
            .badge {
                display: inline-flex;
                align-items: center;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                white-space: nowrap;
            }
            .badge-PENDING    { background: #fef3c7; color: #92400e; }
            .badge-PROCESSING { background: #dbeafe; color: #1d4ed8; }
            .badge-APPROVED   { background: #d1fae5; color: #065f46; }
            .badge-REJECTED   { background: #fee2e2; color: #991b1b; }
            .badge-COMPLETED  { background: #f3f4f6; color: #374151; }
            .badge-CANCELLED  { background: #f3f4f6; color: #6b7280; }

            .btn-detail-sm {
                display: inline-block;
                padding: 6px 14px;
                background: #eff6ff;
                color: #2563eb;
                border-radius: 6px;
                font-size: 12.5px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.15s;
            }
            .btn-detail-sm:hover {
                background: #dbeafe;
            }

            .btn-cancel-sm {
                background: none;
                border: 1px solid #ef4444;
                color: #ef4444;
                border-radius: 6px;
                padding: 5px 12px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.15s;
            }
            .btn-cancel-sm:hover {
                background: #fef2f2;
            }

            .no-claims {
                text-align: center;
                color: #94a3b8;
                padding: 40px 16px;
                font-size: 14px;
            }

            /* ── Pagination Bar ── */
            .pagination-bar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-top: 20px;
                padding: 12px 16px;
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
            }
            .pagination-info {
                font-size: 13.5px;
                color: #64748b;
            }
            .pagination-controls {
                display: flex;
                gap: 6px;
            }
            .page-link {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 34px;
                height: 34px;
                padding: 0 10px;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                color: #334155;
                text-decoration: none;
                background: #ffffff;
                transition: all 0.15s;
            }
            .page-link:hover {
                border-color: #2563eb;
                color: #2563eb;
                background: #eff6ff;
            }
            .page-link.active {
                background: #2563eb;
                color: #ffffff;
                border-color: #2563eb;
            }
            .page-link.disabled {
                opacity: 0.4;
                pointer-events: none;
                background: #f1f5f9;
            }
        </style>
    </head>
    <body>

        <!-- ════ HEADER ════ -->
        <%@include file="_header.jspf" %>

        <!-- ════ MAIN PAGE WRAP ════ -->
        <div class="page-wrap">

            <!-- ── Top Tab Bar ── -->
            <div class="warranty-tabs">
                <a href="${pageContext.request.contextPath}/warranty?action=center" class="tab-btn">
                    <i class="fas fa-plus-circle"></i> Gửi Yêu Cầu Bảo Hành Mới
                </a>
                <a href="${pageContext.request.contextPath}/warranty?action=list" class="tab-btn active">
                    <i class="fas fa-list-alt"></i> Danh Sách & Theo Dõi Bảo Hành
                </a>
            </div>

            <!-- ── TRACK CLAIM SEARCH CARD ── -->
            <div class="card track-claim-card" style="max-width: 800px;">
                <div class="card-icon-wrap">🔍</div>
                <h3>Tra Cứu & Tìm Kiếm Bảo Hành</h3>
                <p>Tìm kiếm nhanh theo mã yêu cầu, tên sản phẩm, mô tả lỗi, số sê-ri hoặc lọc theo trạng thái.</p>
                <form method="get" action="${pageContext.request.contextPath}/warranty" style="flex-wrap: wrap;">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="keyword" value="<c:out value="${keyword}"/>" placeholder="Mã yêu cầu, tên sản phẩm, lỗi, số sê-ri..." style="max-width: 300px;">
                    
                    <select name="statusFilter" style="padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; background: #fff; cursor: pointer;">
                        <option value="ALL" ${empty statusFilter || statusFilter == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="PROCESSING" ${statusFilter == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                        <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Đã từ chối</option>
                        <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </select>

                    <button class="btn-track" type="submit"><i class="fas fa-search" style="margin-right: 4px;"></i> Tìm kiếm</button>
                    <c:if test="${not empty keyword || (not empty statusFilter && statusFilter != 'ALL')}">
                        <a href="${pageContext.request.contextPath}/warranty?action=list" style="padding: 10px 14px; color: #ef4444; font-size: 13.5px; text-decoration: none; display: inline-flex; align-items: center; font-weight: 500;">
                            <i class="fas fa-undo" style="margin-right: 4px;"></i> Đặt lại
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- ── WARRANTY CLAIMS TABLE ── -->
            <section>
                <div class="section-header">
                    <h3>Danh Sách Yêu Cầu Bảo Hành Cá Nhân</h3>
                    <c:if test="${not empty totalClaims}">
                        <span style="font-size: 13.5px; color: #64748b; font-weight: 500;">
                            Tổng cộng: <strong>${totalClaims}</strong> kết quả
                        </span>
                    </c:if>
                </div>

                <table class="activity-table">
                    <thead>
                        <tr>
                            <th>Mã Yêu Cầu / Ngày Tạo</th>
                            <th>Sản Phẩm</th>
                            <th>Tiêu Đề Lỗi</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty claims}">
                            <tr>
                                <td colspan="5" class="no-claims">
                                    <i class="fas fa-inbox" style="font-size:32px;margin-bottom:8px;display:block;color:#cbd5e1;"></i>
                                    Không tìm thấy yêu cầu bảo hành nào phù hợp.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="claim" items="${claims}">
                                <tr>
                                    <td>
                                        <div class="claim-ref">#${claim.claimId}</div>
                                        <div class="claim-date">
                                            <fmt:formatDate value="${claim.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:13.5px;font-weight:600;"><c:out value="${claim.productName}"/></div>
                                        <div style="font-size:11.5px;color:#94a3b8;">SN: <c:out value="${claim.serialNumber}"/></div>
                                    </td>
                                    <td style="font-size:13.5px;"><c:out value="${claim.title}"/></td>
                                    <td>
                                        <span class="badge badge-${claim.status}">
                                            <c:choose>
                                                <c:when test="${claim.status == 'PENDING'}">Chờ xử lý</c:when>
                                                <c:when test="${claim.status == 'PROCESSING'}">Đang xử lý</c:when>
                                                <c:when test="${claim.status == 'APPROVED'}">Đã duyệt</c:when>
                                                <c:when test="${claim.status == 'REJECTED'}">Đã từ chối</c:when>
                                                <c:when test="${claim.status == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                <c:when test="${claim.status == 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise>${claim.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
                                        <a class="btn-detail-sm"
                                           href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}">
                                            Xem chi tiết
                                        </a>
                                        <c:if test="${claim.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/warranty"
                                                  method="post"
                                                  style="display:inline;"
                                                  onsubmit="return confirm('Huỷ yêu cầu #${claim.claimId}?')">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="id" value="${claim.claimId}">
                                                <button type="submit" class="btn-cancel-sm">Hủy</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!-- ── PAGINATION ── -->
                <c:if test="${not empty totalPages && totalPages > 1}">
                    <div class="pagination-bar">
                        <div class="pagination-info">
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        </div>
                        <div class="pagination-controls">
                            <%-- Button Previous --%>
                            <a class="page-link ${currentPage <= 1 ? 'disabled' : ''}"
                               href="${pageContext.request.contextPath}/warranty?action=list&page=${currentPage - 1}&keyword=${keyword}&statusFilter=${statusFilter}">
                                ‹ Trước
                            </a>

                            <%-- Page Number Links --%>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <a class="page-link ${p == currentPage ? 'active' : ''}"
                                   href="${pageContext.request.contextPath}/warranty?action=list&page=${p}&keyword=${keyword}&statusFilter=${statusFilter}">
                                    ${p}
                                </a>
                            </c:forEach>

                            <%-- Button Next --%>
                            <a class="page-link ${currentPage >= totalPages ? 'disabled' : ''}"
                               href="${pageContext.request.contextPath}/warranty?action=list&page=${currentPage + 1}&keyword=${keyword}&statusFilter=${statusFilter}">
                                Sau ›
                            </a>
                        </div>
                    </div>
                </c:if>
            </section>

        </div><!-- end page-wrap -->

        <!-- ════ FOOTER ════ -->
        <%@include file="_footer.jspf" %>
        <jsp:include page="chatbot.jsp" />
    </body>
</html>

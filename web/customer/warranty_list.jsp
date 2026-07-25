<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Bảo vệ trang: chỉ cho customer (roleId = 3) hoặc user đã đăng nhập
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
        <title>Danh Sách Yêu Cầu Bảo Hành – UNILAP</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            
            /* Header */
            .header {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(12px);
                position: sticky;
                top: 0;
                z-index: 100;
                border-bottom: 1px solid #e2e8f0;
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
            .main-nav a:hover {
                color: #1a56db;
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
            }

            /* Badge Colors */
            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge-PENDING    { background: #fef3c7; color: #92400e; }
            .badge-PROCESSING { background: #dbeafe; color: #1d4ed8; }
            .badge-APPROVED   { background: #d1fae5; color: #065f46; }
            .badge-REJECTED   { background: #fee2e2; color: #991b1b; }
            .badge-COMPLETED  { background: #f3f4f6; color: #374151; }
            .badge-CANCELLED  { background: #f3f4f6; color: #6b7280; }

            /* Table Styles */
            .claims-table {
                width: 100%;
                border-collapse: collapse;
                background: #ffffff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.02);
                border: 1px solid #e2e8f0;
            }
            .claims-table th {
                background: #ffffff;
                text-align: left;
                font-size: 11px;
                font-weight: 700;
                color: #94a3b8;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                padding: 14px 18px;
                border-bottom: 1px solid #e2e8f0;
            }
            .claims-table td {
                padding: 16px 18px;
                font-size: 13.5px;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }
            .claims-table tr:hover {
                background: #f8fafc;
            }

            /* Search Box */
            .search-card {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 16px;
                padding: 28px;
                max-width: 680px;
                margin: 0 auto 36px;
                text-align: center;
                box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            }
            .search-icon-wrap {
                width: 44px;
                height: 44px;
                border-radius: 50%;
                background: #eff6ff;
                color: #2563eb;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                margin: 0 auto 12px;
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                gap: 6px;
                margin-top: 24px;
            }
            .pagination a, .pagination span {
                padding: 6px 12px;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                font-size: 13px;
                color: #475569;
                text-decoration: none;
                background: #ffffff;
            }
            .pagination .active {
                background: #2563eb;
                color: #ffffff;
                border-color: #2563eb;
                font-weight: 600;
            }
        </style>
    </head>
    <body>

        <!-- ════ HEADER ════ -->
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
                    <a href="#">Tin tức</a>
                </nav>
                <div class="header-icons">
                    <form action="ProductListServlet" method="GET" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:160px; font-family:inherit;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="${pageContext.request.contextPath}/CartServlet"><i class="fas fa-shopping-cart"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <span style="font-size: 13.5px; font-weight: 600; color: #1e293b;"><i class="fas fa-user-circle"></i> ${sessionScope.user.userName}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- ════ TOP TOGGLE BUTTONS ════ -->
        <div style="display:flex; justify-content:center; gap:12px; margin-top:28px; margin-bottom:24px;">
            <a href="${pageContext.request.contextPath}/warranty?action=center"
               style="display:inline-flex; align-items:center; gap:8px; padding:10px 22px; background:#ffffff; color:#475569; border:1px solid #e2e8f0; font-size:13.5px; font-weight:500; border-radius:10px; text-decoration:none; transition:all 0.15s;">
                <i class="fas fa-plus-circle"></i> Gửi Yêu Cầu Bảo Hành Mới
            </a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"
               style="display:inline-flex; align-items:center; gap:8px; padding:10px 22px; background:#2563eb; color:#ffffff; font-size:13.5px; font-weight:600; border-radius:10px; text-decoration:none; box-shadow:0 4px 12px rgba(37,99,235,0.25);">
                <i class="fas fa-list-alt"></i> Danh Sách & Theo Dõi Bảo Hành
            </a>
        </div>

        <div class="container" style="max-width: 960px; margin-bottom: 50px;">

            <!-- ════ SEARCH & FILTER CARD ════ -->
            <div class="search-card">
                <div class="search-icon-wrap">
                    <i class="fas fa-search"></i>
                </div>
                <h2 style="font-size:20px; font-weight:700; color:#111827; margin-bottom:6px;">Tra Cứu & Tìm Kiếm Bảo Hành</h2>
                <p style="font-size:13px; color:#64748b; margin-bottom:20px;">
                    Tìm kiếm nhanh theo mã yêu cầu, tên sản phẩm, mô tả lỗi, số sê-ri hoặc lọc theo trạng thái.
                </p>
                <form method="get" action="${pageContext.request.contextPath}/warranty" style="display:flex; gap:10px; justify-content:center; flex-wrap:wrap;">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="keyword" value="<c:out value="${keyword}"/>"
                           placeholder="Mã yêu cầu, tên sản phẩm, lỗi, số sê-ri..."
                           style="flex:1; min-width:240px; border:1px solid #cbd5e1; border-radius:8px; padding:9px 14px; font-size:13.5px; outline:none;">
                    <select name="statusFilter" style="border:1px solid #cbd5e1; border-radius:8px; padding:9px 14px; font-size:13.5px; outline:none; background:#ffffff; cursor:pointer;">
                        <option value="">Tất cả trạng thái</option>
                        <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="PROCESSING" ${statusFilter == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                        <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Đã từ chối</option>
                        <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                    <button type="submit" style="padding:9px 20px; background:#2563eb; color:#ffffff; border:none; border-radius:8px; font-size:13.5px; font-weight:600; cursor:pointer; display:inline-flex; align-items:center; gap:6px;">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </form>
            </div>

            <!-- ════ MAIN CLAIMS LIST ════ -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                <h3 style="font-size:18px; font-weight:700; color:#111827;">Danh Sách Yêu Cầu Bảo Hành Cá Nhân</h3>
                <span style="font-size:13px; color:#64748b;">Tổng cộng: <strong>${totalClaims}</strong> kết quả</span>
            </div>

            <table class="claims-table">
                <thead>
                    <tr>
                        <th>MÃ YÊU CẦU / NGÀY TẠO</th>
                        <th>SẢN PHẨM</th>
                        <th>TIÊU ĐỀ LỖI</th>
                        <th>TRẠNG THÁI</th>
                        <th>THAO TÁC</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty claims}">
                            <tr>
                                <td colspan="5" style="text-align:center; padding:40px; color:#94a3b8; font-size:14px;">
                                    Bạn chưa có yêu cầu bảo hành nào phù hợp.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="claim" items="${claims}">
                                <tr>
                                    <td>
                                        <div style="font-size:14px; font-weight:700; color:#2563eb;">#${claim.claimId}</div>
                                        <div style="font-size:11.5px; color:#94a3b8; margin-top:2px;">
                                            <fmt:formatDate value="${claim.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size:13.5px; font-weight:600; color:#1e293b;"><c:out value="${claim.productName}"/></div>
                                        <div style="font-size:11.5px; color:#94a3b8; margin-top:2px;">SN: <c:out value="${claim.serialNumber}"/></div>
                                    </td>
                                    <td style="font-size:13.5px; color:#334155; max-width:220px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                        <c:out value="${claim.title}"/>
                                    </td>
                                    <td>
                                        <span class="badge badge-${claim.status}">
                                            <c:choose>
                                                <c:when test="${claim.status == 'PENDING'}">Chờ xử lý</c:when>
                                                <c:when test="${claim.status == 'PROCESSING'}">Đang xử lý</c:when>
                                                <c:when test="${claim.status == 'APPROVED'}">Đã duyệt</c:when>
                                                <c:when test="${claim.status == 'REJECTED'}">Đã từ chối</c:when>
                                                <c:when test="${claim.status == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                <c:when test="${claim.status == 'CANCELLED'}">Đã hủy</c:when>
                                                <c:otherwise><c:out value="${claim.status}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}" style="color:#2563eb; font-size:13px; font-weight:600; text-decoration:none;">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- ════ PAGINATION ════ -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="p" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/warranty?action=list&page=${p}&keyword=${keyword}&statusFilter=${statusFilter}"
                           class="${p == currentPage ? 'active' : ''}">${p}</a>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- ════ FOOTER ════ -->
        <%@include file="_footer.jspf" %>

    </body>
</html>

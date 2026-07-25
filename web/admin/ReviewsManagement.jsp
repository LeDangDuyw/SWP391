<%-- 
    Document   : ReviewsManagement
    Created on : Jun 22, 2026, 4:14:24 AM
    Author     : MINHBQ
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.time.LocalDate" %>
<%
    String today = LocalDate.now().toString();
    request.setAttribute("today", today);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP — Quản lý Đánh giá</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
            *, *::before, *::after {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family: Inter, Arial, sans-serif;
            }
            body {
                background:#f5f7fb;
                color:#171a22;
                letter-spacing: .04em;
            }
            a {
                text-decoration:none;
                color:inherit;
            }
            .layout {
                display:flex;
                min-height:100vh;
            }
            /* Sidebar CSS: provided by sidebar.jsp Master CSS */
            /* Main Layout */
            .main {
                flex:1;
                display:flex;
                flex-direction:column;
                overflow:hidden;
            }
            .topbar {
                background:#fff;
                border-bottom:1px solid #e5e7eb;
                padding:14px 28px;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .topbar-title { font-size:18px; font-weight:700; }
            .breadcrumb { padding:14px 28px 0; font-size:13px; color:#6b7280; display:flex; gap:6px; }
            .content { padding:24px 28px; overflow-y:auto; flex:1; }
            .page-title { font-size:26px; font-weight:700; margin-bottom:4px; }
            .page-sub { font-size:14px; color:#6b7280; margin-bottom:28px; }
            /* Filter Form Styles */
            .filter-card {
                background: #fff;
                border-radius: 12px;
                padding: 20px 24px;
                margin-bottom: 24px;
                box-shadow: 0 1px 4px rgba(0,0,0,.06);
            }
            .filter-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) auto;
                gap: 16px;
                align-items: flex-end;
            }
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .filter-group label {
                font-size: 13px;
                font-weight: 600;
                color: #4b5563;
            }
            .filter-group select, .filter-group input {
                padding: 8px 12px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                outline: none;
                width: 100%;
            }
            .filter-btn {
                background: #2563eb;
                color: white;
                border: none;
                padding: 10px 24px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .filter-btn:hover { background: #1d4ed8; }
            /* Table Card */
            .table-card {
                background:#fff;
                border-radius:12px;
                box-shadow:0 1px 4px rgba(0,0,0,.06);
                overflow:hidden;
            }
            table { width:100%; border-collapse:collapse; }
            thead { background:#111827; color:#fff; }
            th { padding:14px 18px; text-align:left; font-size:13px; font-weight:600; }
            td { padding:14px 18px; font-size:14px; border-bottom:1px solid #f3f4f6; }
            tr:hover { background:#f9fafb; }
            
            /* Status Badges */
            .badge { display:inline-block; padding:4px 10px; border-radius:20px; font-size:11px; font-weight:600; }
            .badge-live { background:#dcfce7; color:#166534; }
            .badge-draft { background:#fef9c3; color:#854d0e; }
            .badge-disabled { background:#f3f4f6; color:#6b7280; }
            .stars { color: #f59e0b; font-weight: bold; }
            /* Action Buttons */
            .action-btn {
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                border: 1px solid transparent;
                margin-right: 6px;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .btn-approve { background: #dcfce7; color: #15803d; }
            .btn-approve:hover { background: #bbf7d0; }
            .btn-hide { background: #fee2e2; color: #b91c1c; }
            .btn-hide:hover { background: #fecaca; }
            .btn-reply { background: #dbeafe; color: #1d4ed8; }
            .btn-reply:hover { background: #bfdbfe; }
            /* Reply Box Styles */
            .reply-box {
                margin-top: 8px;
                padding: 8px 12px;
                background: #f3f4f6;
                border-radius: 6px;
                border-left: 3px solid #3b82f6;
                font-size: 13px;
                color: #374151;
            }
            /* Pagination */
            .pagination {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 24px;
                border-top: 1px solid #e5e7eb;
            }
            .pagination-btn {
                padding: 6px 12px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 13px;
                cursor: pointer;
                background: #fff;
            }
            .pagination-btn:hover { background: #f3f4f6; }
            .pagination-numbers { display: flex; gap: 6px; }
            .page-num {
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 6px;
                font-size: 13px;
                border: 1px solid #d1d5db;
            }
            .page-num.active { background: #2563eb; color: #fff; border-color: #2563eb; }
            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                top: 0; left: 0; right: 0; bottom: 0;
                background: rgba(0,0,0,0.5);
                backdrop-filter: blur(4px);
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }
            .modal-content {
                background: white;
                padding: 24px;
                border-radius: 12px;
                width: 500px;
                max-width: 90%;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            }
            .modal-header { font-size: 18px; font-weight: 700; margin-bottom: 16px; }
            .modal-body textarea {
                width: 100%; height: 120px; padding: 10px;
                border: 1px solid #d1d5db; border-radius: 8px;
                margin-top: 8px; font-size: 14px; outline: none;
            }
            .modal-footer {
                display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px;
            }
        </style>
    
<!-- Sidebar dropdown CSS: provided by sidebar.jsp Master CSS -->
<style>
    /* Tab Styling */
    .tabs-nav {
        display: flex;
        gap: 12px;
        margin-bottom: 24px;
        border-bottom: 2px solid #e1e6ef;
        padding-bottom: 2px;
    }
    .tab-btn {
        padding: 10px 20px;
        font-size: 14px;
        font-weight: 600;
        color: #4b5563;
        background: transparent;
        border: none;
        border-bottom: 3px solid transparent;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .tab-btn:hover {
        color: #2563eb;
        background: rgba(37, 99, 235, 0.04);
        border-radius: 8px 8px 0 0;
    }
    .tab-btn.active {
        color: #2563eb;
        border-bottom-color: #2563eb;
    }
    
    /* Stats Layout */
    .stats-row {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 20px;
        margin-bottom: 24px;
    }
    .stat-card {
        background: #ffffff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.02), 0 1px 3px rgba(0,0,0,0.03);
        display: flex;
        align-items: center;
        gap: 16px;
        border: 1px solid #e5e7eb;
        transition: transform 0.2s ease;
    }
    .stat-card:hover {
        transform: translateY(-2px);
    }
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        font-weight: bold;
    }
    .stat-info {
        display: flex;
        flex-direction: column;
    }
    .stat-value {
        font-size: 24px;
        font-weight: 800;
        color: #111827;
    }
    .stat-label {
        font-size: 13px;
        color: #6b7280;
        font-weight: 500;
    }
    
    /* Charts & Search grid */
    .analytics-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 24px;
        margin-bottom: 24px;
    }
    @media (max-width: 1024px) {
        .analytics-grid {
            grid-template-columns: 1fr;
        }
    }
    .analytic-card {
        background: #ffffff;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.02), 0 1px 3px rgba(0,0,0,0.03);
        border: 1px solid #e5e7eb;
        display: flex;
        flex-direction: column;
        gap: 18px;
    }
    .analytic-card-title {
        font-size: 16px;
        font-weight: 700;
        color: #111827;
        border-bottom: 1px solid #f3f4f6;
        padding-bottom: 12px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    /* Product Rating breakdown progress bars */
    .star-bar-row {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 13px;
        font-weight: 500;
    }
    .star-label-fixed {
        width: 45px;
        text-align: right;
    }
    .progress-bar-bg {
        flex: 1;
        height: 8px;
        background: #f3f4f6;
        border-radius: 4px;
        overflow: hidden;
    }
    .progress-bar-fill {
        height: 100%;
        border-radius: 4px;
        transition: width 0.4s ease;
    }
    .star-count-fixed {
        width: 40px;
        text-align: left;
        color: #6b7280;
    }
    
    /* Live Sync button style */
    .sync-btn-container {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 16px;
    }
    .btn-sync {
        background: #059669;
        color: white;
        border: none;
        padding: 10px 18px;
        border-radius: 8px;
        font-weight: 600;
        font-size: 13px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: background 0.2s, transform 0.1s;
        box-shadow: 0 2px 4px rgba(5, 150, 105, 0.2);
    }
    .btn-sync:hover {
        background: #047857;
    }
    .btn-sync:active {
        transform: scale(0.97);
    }
    .btn-sync.spinning i {
        animation: spin 1s linear infinite;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
    <body>
        <div class="layout">
            <!-- Sidebar: Tự động đổi giao diện theo vai trò người dùng (Admin / Staff) -->
            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="activePage" value="reviews"/>
            </jsp:include>
            <!-- Main Content Area -->
            <div class="main">
                <div class="topbar">
                    <span class="topbar-title">Hệ thống quản lý đánh giá</span>
                </div>
                <div class="breadcrumb">
                    <c:choose>
                        <c:when test="${sessionScope.user.roleId == 1}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> / Quản lý đánh giá
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/staff/inventory">Inventory</a> / Quản lý đánh giá
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="content">
                    <div class="page-title">Quản lý đánh giá sản phẩm</div>
                    <div class="page-sub">Ẩn/hiển thị bình luận và phản hồi lại đánh giá của khách hàng.</div>

                    <!-- Tabs Navigation -->
                    <div class="tabs-nav">
                        <button type="button" class="tab-btn active" id="tabBtnList" onclick="switchTab('list')">
                            📂 Danh sách đánh giá
                        </button>
                        <button type="button" class="tab-btn" id="tabBtnAnalyst" onclick="switchTab('analyst')">
                            📊 Thống kê & Phân tích
                        </button>
                    </div>

                    <!-- CONTAINER TAB 1: Danh sách đánh giá -->
                    <div id="listTabContent">
                        <!-- Nút Live Sync -->
                        <div class="sync-btn-container">
                            <button type="button" class="btn-sync" id="syncBtn" onclick="syncReviews()">
                                <span style="font-size:14px;">🔄</span> Live Sync (Fetch)
                            </button>
                        </div>

                    <!-- Card Bộ Lọc -->
                    <div class="filter-card">
                        <form id="filterForm" method="GET" onsubmit="return validateDates()">
                            <div class="filter-grid">
                                <div class="filter-group">
                                    <label>Đánh giá (Sao):</label>
                                    <select name="ratingFilter">
                                        <option value="all" ${ratingFilter eq 'all' ? 'selected' : ''}>Tất cả</option>
                                        <option value="good" ${ratingFilter eq 'good' ? 'selected' : ''}>Tốt (4-5 ★)</option>
                                        <option value="bad" ${ratingFilter eq 'bad' ? 'selected' : ''}>Xấu (1-3 ★)</option>
                                        <option value="5" ${ratingFilter eq '5' ? 'selected' : ''}>5 Sao</option>
                                        <option value="4" ${ratingFilter eq '4' ? 'selected' : ''}>4 Sao</option>
                                        <option value="3" ${ratingFilter eq '3' ? 'selected' : ''}>3 Sao</option>
                                        <option value="2" ${ratingFilter eq '2' ? 'selected' : ''}>2 Sao</option>
                                        <option value="1" ${ratingFilter eq '1' ? 'selected' : ''}>1 Sao</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label>Trạng thái:</label>
                                    <select name="status">
                                        <option value="all" ${status eq 'all' ? 'selected' : ''}>Tất cả</option>
                                        <option value="approved" ${status eq 'approved' ? 'selected' : ''}>Hiển thị (Không bị ẩn)</option>
                                        <option value="hidden" ${status eq 'hidden' ? 'selected' : ''}>Bị ẩn</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label>Từ ngày:</label>
                                  <input type="text" id="fromDate" name="fromDate" value="${fromDate}" placeholder="Từ ngày (YYYY-MM-DD)" onfocus="this.type='date'; this.max='${today}'" onblur="if(!this.value) this.type='text'" max="${today}">
                                </div>
                                <div class="filter-group">
                                    <label>Đến ngày:</label>
                                 <input type="text" id="toDate" name="toDate" value="${toDate}" placeholder="Đến ngày (YYYY-MM-DD)" onfocus="this.type='date'; this.max='${today}'" onblur="if(!this.value) this.type='text'" max="${today}">
                                </div>
                                <button type="submit" class="filter-btn">Lọc kết quả</button>
                            </div>
                        </form>
                    </div>
                    <!-- Bảng Danh Sách Đánh Giá -->
                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Đánh giá</th>
                                    <th>Nội dung</th>
                                    <th>Ngày gửi</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty reviews}">
                                        <c:forEach items="${reviews}" var="r">
                                            <tr>
                                                <td>
                                                    <strong>${r.userName}</strong>
                                                </td>
                                                <td>${r.productName}</td>
                                                <td>
                                                    <span class="stars">
                                                        <c:forEach begin="1" end="${r.rating}">★</c:forEach><c:forEach begin="${r.rating + 1}" end="5">☆</c:forEach>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div>${r.comment}</div>
                                                    <!-- Nếu đã có nội dung trả lời thì hiển thị ra dưới dạng Reply Box -->
                                                    <c:if test="${not empty r.replyContent}">
                                                        <div class="reply-box">
                                                            <strong>Phản hồi từ ${r.replierName}:</strong> ${r.replyContent}
                                                            <br><small style="color: #6b7280;">lúc <fmt:formatDate value="${r.repliedAt}" pattern="dd/MM/yyyy HH:mm"/></small>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test='${r.status eq "hidden"}'>badge-disabled</c:when>
                                                            <c:otherwise>badge-live</c:otherwise>
                                                        </c:choose>">
                                                        ${r.status eq 'hidden' ? 'Bị ẩn' : 'Hiển thị'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <!-- Nút Ẩn bình luận -->
                                                    <c:if test="${r.status ne 'hidden'}">
                                                        <form action="" method="POST" style="display:inline;">
                                                            <input type="hidden" name="action" value="hide">
                                                            <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                            <button type="submit" class="action-btn btn-hide">Ẩn</button>
                                                        </form>
                                                    </c:if>
                                                    
                                                    <!-- Nút Hiện bình luận -->
                                                    <c:if test="${r.status eq 'hidden'}">
                                                        <form action="" method="POST" style="display:inline;">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                            <button type="submit" class="action-btn btn-approve">Hiện</button>
                                                        </form>
                                                    </c:if>
                                                    <!-- Nút Trả lời (Mở Modal) -->
                                                    <button class="action-btn btn-reply" onclick="openReplyModal(${r.reviewId}, '${r.comment}', '${r.replyContent}')">Trả lời</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; color:#9ca3af; padding: 40px;">Không có đánh giá nào phù hợp bộ lọc.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <!-- Phân trang -->
                        <div class="pagination">
                            <span>Trang ${currentPage} / ${totalPages} (Tổng số: ${totalReviews} đánh giá)</span>
                            <div class="pagination-numbers">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-num ${i == currentPage ? 'active' : ''}" 
                                       href="?page=${i}&ratingFilter=${ratingFilter}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">
                                        ${i}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    </div> <!-- Close listTabContent -->

                    <!-- CONTAINER TAB 2: Thống kê & Phân tích -->
                    <div id="analystTabContent" style="display: none;">
                        <!-- Thống kê Bộ Lọc & Live Sync -->
                        <div class="filter-card">
                            <div class="filter-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) auto; align-items: flex-end;">
                                <div class="filter-group">
                                    <label>Từ ngày (Ngày bắt đầu):</label>
                                    <input type="date" id="statFromDate" value="${fromDate}">
                                </div>
                                <div class="filter-group">
                                    <label>Đến ngày (Ngày kết thúc):</label>
                                    <input type="date" id="statToDate" value="${toDate}">
                                </div>
                                <button type="button" class="btn-sync" id="syncStatsBtn" onclick="syncChartStats()" style="padding: 10px 24px; font-weight:600; margin-bottom: 0;">
                                    <span style="font-size: 14px;">🔄</span> Lọc / Xem Thống Kê
                                </button>
                            </div>
                            <div id="productFilterIndicator" style="display: none; margin-top: 14px; padding: 10px 16px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; color: #166534; font-size: 13px; font-weight: 600; align-items: center; justify-content: space-between;">
                                <span id="productFilterText">📦 Đang xem biểu đồ sản phẩm</span>
                                <button type="button" onclick="clearProductChartFilter()" style="background: #ef4444; color: white; border: none; padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer;">❌ Xem tất cả sản phẩm</button>
                            </div>
                        </div>

                        <!-- Dashboard Summary Cards -->
                        <div class="stats-row">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(37, 99, 235, 0.1); color: #2563eb;">📝</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="sumTotalReviews">0</span>
                                    <span class="stat-label">Tổng lượt đánh giá</span>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">★</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="sumAvgRating">0.0 / 5 ★</span>
                                    <span class="stat-label">Số sao trung bình</span>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">📈</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="sumGoodPct">0%</span>
                                    <span class="stat-label">Tỷ lệ đánh giá tốt (4-5★)</span>
                                </div>
                            </div>
                        </div>

                        <!-- Main Analyst Grid -->
                        <div class="analytics-grid">
                            <!-- Left: Chart Card -->
                            <div class="analytic-card">
                                <div style="display: flex; justify-content: center; margin-bottom: 18px;">
                                    <div style="background: #388e3c; color: white; padding: 10px 36px; border-radius: 24px; font-weight: 800; font-size: 17px; letter-spacing: 0.5px; box-shadow: 0 4px 12px rgba(56, 142, 60, 0.3);">
                                        Review Rating Trends (Thống Kê Đánh Giá)
                                    </div>
                                </div>
                                <div style="position: relative; height: 320px; width: 100%;">
                                    <canvas id="ratingChart"></canvas>
                                </div>
                                <div id="customChartLegend" style="display: flex; flex-wrap: wrap; justify-content: center; gap: 8px; margin-top: 16px; padding-top: 12px; border-top: 1px solid #f3f4f6;"></div>
                            </div>
                            
                            <!-- Right: Product Search & Performance Card -->
                            <div class="analytic-card">
                                <div class="analytic-card-title">
                                    <span>🔍 Đánh giá trung bình theo sản phẩm</span>
                                </div>
                                <div style="display: flex; gap: 8px;">
                                    <input type="text" id="prodSearchInput" placeholder="Tìm theo tên sản phẩm..." onkeypress="if(event.key === 'Enter') searchProductStats()" style="flex:1; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 8px; font-size:13px; outline:none;">
                                    <button type="button" class="filter-btn" onclick="searchProductStats()" style="padding: 8px 16px; border-radius: 8px; font-size:13px;">Tìm</button>
                                </div>
                                <div id="productSearchResults" style="overflow-y: auto; max-height: 280px; display: flex; flex-direction: column; gap: 8px;">
                                    <div style="text-align: center; color: #9ca3af; padding: 20px; font-size: 13px;">Nhập tên sản phẩm để xem số sao trung bình trong tổng thời gian.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Hộp thoại Trả lời bình luận (Reply Modal) -->
        <div id="replyModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Trả lời đánh giá</div>
                <div class="modal-body">
                    <p style="font-size: 13px; color: #4b5563;">Khách hàng nhận xét:</p>
                    <blockquote id="customerCommentText" style="font-style: italic; background: #f9fafb; padding: 10px; border-left: 3.5px solid #d1d5db; margin-top: 5px; font-size: 13px;"></blockquote>
                    
                    <form action="" method="POST" id="replyForm">
                        <input type="hidden" name="action" value="reply">
                        <input type="hidden" name="reviewId" id="replyReviewId">
                        <label style="font-size: 13px; font-weight:600; margin-top: 14px; display:block;">Nội dung phản hồi:</label>
                        <textarea name="replyContent" id="replyContentText" placeholder="Nhập câu trả lời cho bình luận của khách hàng..." required></textarea>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="action-btn btn-hide" onclick="closeReplyModal()">Hủy</button>
                    <button class="action-btn btn-approve" onclick="document.getElementById('replyForm').submit()">Gửi phản hồi</button>
                </div>
            </div>
        </div>
        <script>
            // JavaScript Validation: Validate ngày trước khi gửi form
            /**
             * CHỨC NĂNG: Kiểm tra và tự động đảo mốc Từ Ngày - Đến Ngày nếu ngày bắt đầu lớn hơn ngày kết thúc.
             * LIÊN KẾT: Form lọc danh sách đánh giá tại Tab 1 (listTabContent).
             */
            function validateDates() {
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;
                
                if (fromDate && toDate && fromDate > toDate) {
                    document.getElementById('fromDate').value = toDate;
                    document.getElementById('toDate').value = fromDate;
                }
                return true;
            }

            /**
             * CHỨC NĂNG: Hiển thị Hộp thoại Modal Phản Hồi nhận xét của khách hàng.
             * LIÊN KẾT: Nút "Trả lời" / "Sửa phản hồi" trong bảng danh sách đánh giá.
             * 
             * @param {number} reviewId ID đánh giá
             * @param {string} comment Nội dung bình luận khách đã viết
             * @param {string} currentReply Phản hồi đã có của Admin/Staff (nếu có)
             */
            function openReplyModal(reviewId, comment, currentReply) {
                document.getElementById('replyReviewId').value = reviewId;
                document.getElementById('customerCommentText').innerText = comment;
                document.getElementById('replyContentText').value = currentReply || '';
                document.getElementById('replyModal').style.display = 'flex';
            }

            /**
             * CHỨC NĂNG: Ẩn Hộp thoại Modal Phản Hồi.
             * LIÊN KẾT: Nút "Hủy" hoặc nút đóng trong Modal #replyModal.
             */
            function closeReplyModal() {
                document.getElementById('replyModal').style.display = 'none';
            }

            /**
             * CHỨC NĂNG: Chuyển đổi qua lại giữa Tab 1 (Danh sách đánh giá) và Tab 2 (Thống kê & Biểu đồ).
             * LIÊN KẾT: 2 nút Tab header (#tabBtnList, #tabBtnAnalyst).
             * 
             * @param {string} tab Tên tab cần mở ('list' hoặc 'analyst')
             */
            function switchTab(tab) {
                const listTab = document.getElementById('listTabContent');
                const analystTab = document.getElementById('analystTabContent');
                const btnList = document.getElementById('tabBtnList');
                const btnAnalyst = document.getElementById('tabBtnAnalyst');
                
                if (tab === 'list') {
                    listTab.style.display = 'block';
                    analystTab.style.display = 'none';
                    btnList.classList.add('active');
                    btnAnalyst.classList.remove('active');
                } else if (tab === 'analyst') {
                    listTab.style.display = 'none';
                    analystTab.style.display = 'block';
                    btnList.classList.remove('active');
                    btnAnalyst.classList.add('active');
                    
                    if (!myChart) {
                        syncChartStats();
                    }
                }
            }

            let myChart = null;
            let currentSelectedProductId = null;

            /**
             * CHỨC NĂNG: Gửi yêu cầu AJAX lấy dữ liệu số sao theo thời gian và vẽ biểu đồ Line Chart + Cập nhật 3 thẻ tổng quan.
             * LIÊN KẾT:
             * - Endpoint: GET /admin/reviews?action=getChartData (ManageReviewServlet)
             * - DAO: ProductReviewDAO.getRatingStatsWithInterval()
             * - Chart Canvas: #ratingChart
             * 
             * @param {number} [productId] ID sản phẩm tùy chọn nếu muốn lọc riêng cho sản phẩm đó
             */
            function syncChartStats(productId) {
                if (productId !== undefined) {
                    currentSelectedProductId = productId;
                }
                
                let fromDate = document.getElementById('statFromDate').value;
                let toDate = document.getElementById('statToDate').value;
                
                if (fromDate && toDate) {
                    if (fromDate > toDate) {
                        let tmp = fromDate;
                        fromDate = toDate;
                        toDate = tmp;
                        document.getElementById('statFromDate').value = fromDate;
                        document.getElementById('statToDate').value = toDate;
                    }
                }
                
                let url = '${pageContext.request.contextPath}/admin/reviews?action=getChartData';
                if (fromDate) url += '&fromDate=' + encodeURIComponent(fromDate);
                if (toDate) url += '&toDate=' + encodeURIComponent(toDate);
                if (currentSelectedProductId) url += '&productId=' + currentSelectedProductId;
                
                const btn = document.getElementById('syncStatsBtn');
                if (btn) btn.classList.add('spinning');
                
                fetch(url)
                    .then(res => res.json())
                    .then(data => {
                        if (btn) btn.classList.remove('spinning');
                        
                        if (data.fromDate) {
                            document.getElementById('statFromDate').value = data.fromDate;
                        }
                        if (data.toDate) {
                            document.getElementById('statToDate').value = data.toDate;
                        }
                        
                        const indicator = document.getElementById('productFilterIndicator');
                        const indicatorText = document.getElementById('productFilterText');
                        if (data.productName) {
                            if (indicator && indicatorText) {
                                indicatorText.innerText = '📦 Đang lọc toàn bộ dữ liệu thống kê cho sản phẩm: "' + data.productName + '" (Từ ' + data.fromDate + ' đến ' + data.toDate + ')';
                                indicator.style.display = 'flex';
                            }
                        } else {
                            if (indicator) {
                                indicator.style.display = 'none';
                            }
                        }
                        
                        let totalReviews = 0;
                        let sumRatingTimesCount = 0;
                        let goodReviews = 0;
                        
                        const star1 = data.star1 || [];
                        const star2 = data.star2 || [];
                        const star3 = data.star3 || [];
                        const star4 = data.star4 || [];
                        const star5 = data.star5 || [];
                        
                        for (let i = 0; i < data.labels.length; i++) {
                            const s1 = star1[i] || 0;
                            const s2 = star2[i] || 0;
                            const s3 = star3[i] || 0;
                            const s4 = star4[i] || 0;
                            const s5 = star5[i] || 0;
                            
                            const t = s1 + s2 + s3 + s4 + s5;
                            totalReviews += t;
                            sumRatingTimesCount += (s1*1 + s2*2 + s3*3 + s4*4 + s5*5);
                            goodReviews += (s4 + s5);
                        }
                        
                        const avgRating = totalReviews > 0 ? (sumRatingTimesCount / totalReviews).toFixed(1) : "0.0";
                        const goodPct = totalReviews > 0 ? Math.round((goodReviews / totalReviews) * 100) : 0;
                        
                        document.getElementById('sumTotalReviews').innerText = totalReviews;
                        document.getElementById('sumAvgRating').innerText = avgRating + " / 5 ★";
                        document.getElementById('sumGoodPct').innerText = goodPct + "%";
                        
                        renderChart(data.labels, star1, star2, star3, star4, star5);
                    })
                    .catch(err => {
                        if (btn) btn.classList.remove('spinning');
                        console.error("Error fetching stats:", err);
                        alert("Không thể tải dữ liệu thống kê!");
                    });
            }

            /**
             * CHỨC NĂNG: Hủy lọc sản phẩm hiện tại, quay về hiển thị thống kê tổng thể cho tất cả sản phẩm.
             * LIÊN KẾT: Nút "❌ Xem tất cả sản phẩm" trên thanh thông báo #productFilterIndicator.
             */
            function clearProductChartFilter() {
                currentSelectedProductId = null;
                syncChartStats();
            }

            /**
             * CHỨC NĂNG: Khởi tạo và vẽ đối tượng Chart.js Line Chart mượt mà (Option 1) với dải màu mờ bên dưới.
             * LIÊN KẾT: Thẻ canvas #ratingChart, thư viện Chart.js CDN.
             * 
             * @param {Array<string>} labels Danh sách mốc ngày tháng X-axis
             * @param {Array<number>} star1 Số lượng 1★
             * @param {Array<number>} star2 Số lượng 2★
             * @param {Array<number>} star3 Số lượng 3★
             * @param {Array<number>} star4 Số lượng 4★
             * @param {Array<number>} star5 Số lượng 5★
             */
            function renderChart(labels, star1, star2, star3, star4, star5) {
                const ctx = document.getElementById('ratingChart').getContext('2d');
                
                if (myChart) {
                    myChart.destroy();
                }
                
                myChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            {
                                label: '5 ★',
                                data: star5,
                                borderColor: '#388e3c',
                                backgroundColor: 'rgba(56, 142, 60, 0.12)',
                                borderWidth: 3,
                                pointStyle: 'circle',
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#388e3c',
                                pointBorderWidth: 2,
                                tension: 0.4,
                                fill: 'origin'
                            },
                            {
                                label: '4 ★',
                                data: star4,
                                borderColor: '#2563eb',
                                backgroundColor: 'rgba(37, 99, 235, 0.12)',
                                borderWidth: 3,
                                pointStyle: 'circle',
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#2563eb',
                                pointBorderWidth: 2,
                                tension: 0.4,
                                fill: 'origin'
                            },
                            {
                                label: '3 ★',
                                data: star3,
                                borderColor: '#eab308',
                                backgroundColor: 'rgba(234, 179, 8, 0.12)',
                                borderWidth: 3,
                                pointStyle: 'circle',
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#eab308',
                                pointBorderWidth: 2,
                                tension: 0.4,
                                fill: 'origin'
                            },
                            {
                                label: '2 ★',
                                data: star2,
                                borderColor: '#f97316',
                                backgroundColor: 'rgba(249, 115, 22, 0.12)',
                                borderWidth: 3,
                                pointStyle: 'circle',
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#f97316',
                                pointBorderWidth: 2,
                                tension: 0.4,
                                fill: 'origin'
                            },
                            {
                                label: '1 ★',
                                data: star1,
                                borderColor: '#ef4444',
                                backgroundColor: 'rgba(239, 68, 68, 0.12)',
                                borderWidth: 3,
                                pointStyle: 'circle',
                                pointRadius: 5,
                                pointHoverRadius: 8,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#ef4444',
                                pointBorderWidth: 2,
                                tension: 0.4,
                                fill: 'origin'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: {
                            mode: 'index',
                            intersect: false
                        },
                        scales: {
                            x: {
                                grid: { display: false },
                                ticks: { font: { family: 'Inter', size: 13, weight: '600' }, color: '#4b5563' }
                            },
                            y: {
                                beginAtZero: true,
                                grid: { color: '#f3f4f6' },
                                ticks: { precision: 0, font: { family: 'Inter', size: 13, weight: '600' }, color: '#4b5563' }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: '#1e293b',
                                padding: 12,
                                cornerRadius: 8,
                                bodyFont: { family: 'Inter', size: 13 },
                                titleFont: { family: 'Inter', size: 13, weight: '700' }
                            }
                        }
                    }
                });

                renderChartCustomLegend();
            }

            /**
             * CHỨC NĂNG: Khởi tạo và render các nút Legend tương tác tùy chỉnh bên dưới biểu đồ cho phép bật/tắt hiển thị từng loại sao.
             * LIÊN KẾT: Thẻ container #customChartLegend.
             */
            function renderChartCustomLegend() {
                const container = document.getElementById('customChartLegend');
                if (!container || !myChart) return;
                
                container.innerHTML = '';
                const legendItems = [
                    { index: 0, label: '5 ★ (Xanh lá)', color: '#388e3c', bgLight: '#f0fdf4', border: '#bbf7d0' },
                    { index: 1, label: '4 ★ (Xanh biển)', color: '#2563eb', bgLight: '#eff6ff', border: '#bfdbfe' },
                    { index: 2, label: '3 ★ (Vàng)', color: '#eab308', bgLight: '#fefce8', border: '#fef08a' },
                    { index: 3, label: '2 ★ (Cam)', color: '#f97316', bgLight: '#fff7ed', border: '#ffedd5' },
                    { index: 4, label: '1 ★ (Đỏ)', color: '#ef4444', bgLight: '#fef2f2', border: '#fecdd3' }
                ];

                legendItems.forEach(item => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    const isVisible = myChart.isDatasetVisible(item.index);
                    
                    btn.style.padding = '6px 14px';
                    btn.style.borderRadius = '20px';
                    btn.style.fontSize = '12px';
                    btn.style.fontWeight = '600';
                    btn.style.cursor = 'pointer';
                    btn.style.display = 'inline-flex';
                    btn.style.alignItems = 'center';
                    btn.style.gap = '6px';
                    btn.style.transition = 'all 0.2s ease';
                    
                    if (isVisible) {
                        btn.style.background = item.bgLight;
                        btn.style.color = item.color;
                        btn.style.border = '1.5px solid ' + item.border;
                        btn.style.opacity = '1';
                        btn.style.textDecoration = 'none';
                    } else {
                        btn.style.background = '#f3f4f6';
                        btn.style.color = '#9ca3af';
                        btn.style.border = '1.5px solid #e5e7eb';
                        btn.style.opacity = '0.55';
                        btn.style.textDecoration = 'line-through';
                    }
                    
                    btn.innerHTML = '<span style="width:10px; height:10px; border-radius:3px; background:' + (isVisible ? item.color : '#9ca3af') + ';"></span> ' + item.label;
                    
                    btn.onclick = function() {
                        const currentlyVisible = myChart.isDatasetVisible(item.index);
                        myChart.setDatasetVisibility(item.index, !currentlyVisible);
                        myChart.update();
                        renderChartCustomLegend();
                    };
                    
                    container.appendChild(btn);
                });
            }

            /**
             * CHỨC NĂNG: Gửi yêu cầu AJAX tìm kiếm sản phẩm theo tên và hiển thị thẻ tổng quan số sao trung bình + Tự động lọc biểu đồ cho sản phẩm đó.
             * LIÊN KẾT:
             * - Endpoint: GET /admin/reviews?action=searchProduct&query={query} (ManageReviewServlet)
             * - DAO: ProductReviewDAO.searchProductAverageRating()
             * - Container kết quả: #productSearchResults
             */
            function searchProductStats() {
                const query = document.getElementById('prodSearchInput').value.trim();
                if (!query) {
                    alert("Vui lòng nhập tên sản phẩm!");
                    return;
                }
                
                const url = '${pageContext.request.contextPath}/admin/reviews?action=searchProduct&query=' + encodeURIComponent(query);
                const resultsContainer = document.getElementById('productSearchResults');
                resultsContainer.innerHTML = '<div style="text-align:center; color:#6b7280; padding: 20px;">Đang tìm kiếm...</div>';
                
                fetch(url)
                    .then(res => res.json())
                    .then(products => {
                        resultsContainer.innerHTML = '';
                        if (products.length === 0) {
                            resultsContainer.innerHTML = '<div style="text-align:center; color:#ef4444; padding: 20px;">Không tìm thấy sản phẩm phù hợp!</div>';
                            return;
                        }
                        
                        // Auto-load first product onto chart if searched
                        if (products.length > 0) {
                            syncChartStats(products[0].productId);
                        }
                        
                        products.forEach(p => {
                            const total = p.totalReviews || 0;
                            const star5Pct = total > 0 ? Math.round((p.star5 / total) * 100) : 0;
                            const star4Pct = total > 0 ? Math.round((p.star4 / total) * 100) : 0;
                            const star3Pct = total > 0 ? Math.round((p.star3 / total) * 100) : 0;
                            const star2Pct = total > 0 ? Math.round((p.star2 / total) * 100) : 0;
                            const star1Pct = total > 0 ? Math.round((p.star1 / total) * 100) : 0;
                            
                            let starsHtml = '';
                            const roundedRating = Math.round(p.avgRating);
                            for (let i = 1; i <= 5; i++) {
                                starsHtml += i <= roundedRating ? '<span style="color:#f59e0b; font-size: 20px;">★</span>' : '<span style="color:#d1d5db; font-size: 20px;">☆</span>';
                            }
                            
                            const card = document.createElement('div');
                            card.style.border = '1px solid #e5e7eb';
                            card.style.borderRadius = '10px';
                            card.style.padding = '16px';
                            card.style.marginBottom = '16px';
                            card.style.background = '#f9fafb';
                            
                            card.innerHTML = 
                                '<div style="font-weight: 700; font-size: 15px; color:#111827; margin-bottom: 8px;">' + p.productName + '</div>' +
                                '<div style="display:flex; flex-wrap:wrap; gap:16px; align-items:center; margin-bottom: 12px; border-bottom: 1px solid #e5e7eb; padding-bottom: 12px;">' +
                                    '<div style="display:flex; flex-direction:column; align-items:center; background:#fff; padding:10px; border-radius:8px; border: 1px solid #e5e7eb; min-width:80px;">' +
                                        '<div style="font-size:26px; font-weight:800; color:#2563eb;">' + p.avgRating.toFixed(1) + '</div>' +
                                        '<div style="display:flex; justify-content:center;">' + starsHtml + '</div>' +
                                        '<div style="font-size:11px; color:#6b7280; margin-top:4px;">' + total + ' đánh giá</div>' +
                                    '</div>' +
                                    '<div style="flex:1; min-width:180px; display:flex; flex-direction:column; gap:4px;">' +
                                        '<div class="star-bar-row">' +
                                            '<span class="star-label-fixed">5 ★</span>' +
                                            '<div class="progress-bar-bg"><div class="progress-bar-fill" style="width: ' + star5Pct + '%; background:#388e3c;"></div></div>' +
                                            '<span class="star-count-fixed">' + p.star5 + ' (' + star5Pct + '%)</span>' +
                                        '</div>' +
                                        '<div class="star-bar-row">' +
                                            '<span class="star-label-fixed">4 ★</span>' +
                                            '<div class="progress-bar-bg"><div class="progress-bar-fill" style="width: ' + star4Pct + '%; background:#2563eb;"></div></div>' +
                                            '<span class="star-count-fixed">' + p.star4 + ' (' + star4Pct + '%)</span>' +
                                        '</div>' +
                                        '<div class="star-bar-row">' +
                                            '<span class="star-label-fixed">3 ★</span>' +
                                            '<div class="progress-bar-bg"><div class="progress-bar-fill" style="width: ' + star3Pct + '%; background:#eab308;"></div></div>' +
                                            '<span class="star-count-fixed">' + p.star3 + ' (' + star3Pct + '%)</span>' +
                                        '</div>' +
                                        '<div class="star-bar-row">' +
                                            '<span class="star-label-fixed">2 ★</span>' +
                                            '<div class="progress-bar-bg"><div class="progress-bar-fill" style="width: ' + star2Pct + '%; background:#f97316;"></div></div>' +
                                            '<span class="star-count-fixed">' + p.star2 + ' (' + star2Pct + '%)</span>' +
                                        '</div>' +
                                        '<div class="star-bar-row">' +
                                            '<span class="star-label-fixed">1 ★</span>' +
                                            '<div class="progress-bar-bg"><div class="progress-bar-fill" style="width: ' + star1Pct + '%; background:#ef4444;"></div></div>' +
                                            '<span class="star-count-fixed">' + p.star1 + ' (' + star1Pct + '%)</span>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                                '<button type="button" onclick="syncChartStats(' + p.productId + ')" style="width:100%; padding:8px 14px; background:#2563eb; color:white; border:none; border-radius:6px; font-weight:600; font-size:13px; cursor:pointer;">📊 Xem Biểu Đồ Chi Tiết Sản Phẩm Này</button>';
                            resultsContainer.appendChild(card);
                        });
                    })
                    .catch(err => {
                        console.error("Error searching product stats:", err);
                        resultsContainer.innerHTML = '<div style="text-align:center; color:#ef4444; padding: 20px;">Lỗi tìm kiếm thông tin sản phẩm!</div>';
                    });
            }

            /**
             * CHỨC NĂNG: Gửi yêu cầu AJAX tải lại danh sách đánh giá mới nhất theo bộ lọc Live Sync mà không cần tải lại toàn bộ trang.
             * LIÊN KẾT:
             * - Endpoint: GET /admin/reviews?action=syncLatestReviews (ManageReviewServlet)
             * - DAO: ProductReviewDAO.getReviewsWithFilters()
             * - View Table: Bảng danh sách đánh giá tại Tab 1 (listTabContent)
             */
            function syncReviews() {
                const ratingFilter = document.querySelector('select[name="ratingFilter"]').value;
                const status = document.querySelector('select[name="status"]').value;
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;
                
                const url = '${pageContext.request.contextPath}/admin/reviews?action=syncLatestReviews&ratingFilter=' + ratingFilter + '&status=' + status + '&fromDate=' + fromDate + '&toDate=' + toDate + '&page=1';
                
                const syncBtn = document.getElementById('syncBtn');
                if (syncBtn) {
                    syncBtn.classList.add('spinning');
                }
                
                fetch(url)
                    .then(res => res.json())
                    .then(data => {
                        if (syncBtn) {
                            syncBtn.classList.remove('spinning');
                        }
                        
                        const tbody = document.querySelector('table tbody');
                        tbody.innerHTML = '';
                        
                        if (!data.reviews || data.reviews.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color:#9ca3af; padding: 40px;">Không có đánh giá nào phù hợp bộ lọc.</td></tr>';
                            return;
                        }
                        
                        data.reviews.forEach(r => {
                            let stars = '';
                            for (let i = 1; i <= 5; i++) {
                                stars += i <= r.rating ? '★' : '☆';
                            }
                            
                            let replyBoxHtml = '';
                            if (r.replyContent) {
                                const repliedAtFormatted = r.repliedAt ? r.repliedAt.substring(0, 16) : '';
                                replyBoxHtml = '<div class="reply-box">' +
                                        '<strong>Phản hồi từ ' + r.replierName + ':</strong> ' + r.replyContent +
                                        '<br><small style="color: #6b7280;">lúc ' + repliedAtFormatted + '</small>' +
                                    '</div>';
                            }
                            
                            const dateFormatted = r.createdAt ? r.createdAt.substring(0, 16) : '';
                            
                            const badgeClass = r.status === 'hidden' ? 'badge-disabled' : 'badge-live';
                            const badgeLabel = r.status === 'hidden' ? 'Bị ẩn' : 'Hiển thị';
                            
                            let actionsHtml = '';
                            if (r.status !== 'hidden') {
                                actionsHtml += '<form action="" method="POST" style="display:inline;">' +
                                        '<input type="hidden" name="action" value="hide">' +
                                        '<input type="hidden" name="reviewId" value="' + r.reviewId + '">' +
                                        '<button type="submit" class="action-btn btn-hide">Ẩn</button>' +
                                    '</form>';
                            } else {
                                actionsHtml += '<form action="" method="POST" style="display:inline;">' +
                                        '<input type="hidden" name="action" value="approve">' +
                                        '<input type="hidden" name="reviewId" value="' + r.reviewId + '">' +
                                        '<button type="submit" class="action-btn btn-approve">Hiện</button>' +
                                    '</form>';
                            }
                            
                            const cleanComment = r.comment.replace(/'/g, "\\'").replace(/"/g, '&quot;');
                            const cleanReply = r.replyContent.replace(/'/g, "\\'").replace(/"/g, '&quot;');
                            actionsHtml += '<button class="action-btn btn-reply" onclick="openReplyModal(' + r.reviewId + ', \'' + cleanComment + '\', \'' + cleanReply + '\')">Trả lời</button>';
                            
                            const tr = document.createElement('tr');
                            tr.innerHTML = '<td><strong>' + r.userName + '</strong></td>' +
                                '<td>' + r.productName + '</td>' +
                                '<td><span class="stars">' + stars + '</span></td>' +
                                '<td>' +
                                    '<div>' + r.comment + '</div>' +
                                    replyBoxHtml +
                                '</td>' +
                                '<td>' + dateFormatted + '</td>' +
                                '<td><span class="badge ' + badgeClass + '">' + badgeLabel + '</span></td>' +
                                '<td>' + actionsHtml + '</td>';
                            tbody.appendChild(tr);
                        });
                        
                        const paginationSpan = document.querySelector('.pagination > span');
                        if (paginationSpan) {
                            paginationSpan.innerText = 'Trang ' + data.currentPage + ' / ' + data.totalPages + ' (Tổng số: ' + data.totalReviews + ' đánh giá)';
                        }
                        
                        const paginationNumbers = document.querySelector('.pagination-numbers');
                        if (paginationNumbers) {
                            paginationNumbers.innerHTML = '';
                            for (let i = 1; i <= data.totalPages; i++) {
                                const activeClass = i === data.currentPage ? 'active' : '';
                                const a = document.createElement('a');
                                a.className = 'page-num ' + activeClass;
                                a.href = '?page=' + i + '&ratingFilter=' + ratingFilter + '&status=' + status + '&fromDate=' + fromDate + '&toDate=' + toDate;
                                a.innerText = i;
                                paginationNumbers.appendChild(a);
                            }
                        }
                    })
                    .catch(err => {
                        if (syncBtn) {
                            syncBtn.classList.remove('spinning');
                        }
                        console.error("Error syncing reviews:", err);
                        alert("Lỗi đồng bộ danh sách đánh giá!");
                    });
            }
        </script>
    
<script>
            function toggleSidebarDropdown(btn) {
                const container = btn.nextElementSibling;
                const arrow = btn.querySelector('.dropdown-arrow');
                if (container.style.display === 'flex') {
                    container.style.display = 'none';
                    arrow.style.transform = 'rotate(0deg)';
                } else {
                    container.style.display = 'flex';
                    arrow.style.transform = 'rotate(180deg)';
                }
            }
</script>
</body>
</html>
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
            /* Sidebar */
            .sidebar {
                width: 280px;
                background: #eef2f7;
                border-right: 1px solid #e1e6ef;
                padding: 28px 16px;
                display: flex;
                flex-direction: column;
                position: sticky;
                top: 0;
                height: 100vh;
            }
            .sidebar .brand { margin: 6px 10px 44px; display: grid; gap: 6px; }
            .sidebar .brand span { color: #0b39d1; font-size: 24px; font-weight: 800; letter-spacing: .05em; display: block; }
            .sidebar .brand small { color: #343a46; font-size: 14px; display: block; }
            .sidebar nav { display: grid; gap: 10px; }
            .sidebar nav a {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 14px 14px;
                border-radius: 10px;
                color: #242a38;
                font-weight: 600;
                text-decoration: none;
                font-size: 14px;
            }
            .sidebar nav a span { min-width: 20px; color: #1f2937; font-size: 16px; }
            .sidebar nav a:hover { background: #f3f4f6; }
            .sidebar nav a.active { background: #d8e8ff; color: #0b39d1; }
            .sidebar .profile {
                margin-top: auto;
                border-top: 1px solid #d4dae6;
                padding: 18px 10px 0;
                display: grid;
                gap: 12px;
                font-weight: 700;
            }
            .logout-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #ef4444 !important;
                font-size: 13px;
                font-weight: 600;
                padding: 8px 12px;
                border-radius: 6px;
                background: #fef2f2;
                border: 1px solid #fecaca;
                cursor: pointer;
                transition: all 0.2s ease;
                width: fit-content;
            }
            .logout-btn:hover { background: #fee2e2; border-color: #fca5a5; color: #dc2626 !important; }
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
    </head>
    <body>
        <div class="layout">
            <!-- Sidebar: Tự động đổi giao diện theo vai trò người dùng (Admin / Staff) -->
            <aside class="sidebar">
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 1}">
                        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
                        <nav>
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
                            <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
                            <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
                            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                            <a class="active" href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
                            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
                            <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
                            <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
                            <a href="${pageContext.request.contextPath}/admin/chatbot-feedback"><span>💬</span>Chatbot Feedback</a>
                            <a href="${pageContext.request.contextPath}/admin/chatbot-security"><span>🛡</span>Chatbot Security</a>
                            <a href="#"><span>⚙</span>Settings</a>
                        </nav>
                        <div class="profile">
                            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                                <%
                                    model.Users u = (model.Users) session.getAttribute("user");
                                    if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                                %>
                                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                                         alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                                <% } else { %>
                                    <span>♙</span>
                                <% } %>
                                <span>Admin User Profile</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="brand"><span>UNILAP Staff</span><small>System Controller</small></div>
                        <nav>
                            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Inventory</a>
                            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Category</a>
                            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>IMEI</a>
                            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Tickets</a>
                            <a class="active" href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Manage Reviews</a>
                            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
                        </nav>
                        <div class="profile">
                            <div>♙ <span>${sessionScope.user.userName}</span></div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </aside>
            <!-- Main Content Area -->
            <div class="main">
                <div class="topbar">
                    <span class="topbar-title">Review Management System</span>
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
                    <div class="page-title">Quản lý Đánh giá sản phẩm</div>
                    <div class="page-sub">Ẩn/hiển thị bình luận và phản hồi lại đánh giá của khách hàng.</div>
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
            function validateDates() {
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;
                const today = '${today}';
                
              
                if (fromDate && toDate && fromDate > toDate) {
                    // Tự động đảo ngược giá trị 2 mốc ngày
                    document.getElementById('fromDate').value = toDate;
                    document.getElementById('toDate').value = fromDate;
                }
                return true;
            }
            // JavaScript mở/đóng Modal Trả lời
            function openReplyModal(reviewId, comment, currentReply) {
                document.getElementById('replyReviewId').value = reviewId;
                document.getElementById('customerCommentText').innerText = comment;
                document.getElementById('replyContentText').value = currentReply || '';
                document.getElementById('replyModal').style.display = 'flex';
            }
            function closeReplyModal() {
                document.getElementById('replyModal').style.display = 'none';
            }
        </script>
    </body>
</html>


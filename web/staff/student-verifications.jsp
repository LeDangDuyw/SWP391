<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Minh Sinh Viên - UNILAP Staff</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
    
    <style>
        :root {
            --blue-900: #0f172a;
            --blue-800: #1e293b;
            --blue-600: #2563eb;
            --blue-500: #3b82f6;
            --gray-900: #0f172a;
            --gray-700: #334155;
            --gray-500: #64748b;
            --gray-200: #e2e8f0;
            --gray-50:  #f8fafc;
            --white:    #ffffff;
            --green-600:#16a34a;
            --green-100:#dcfce7;
            --red-600:  #dc2626;
            --red-100:  #fee2e2;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--gray-50);
            color: var(--gray-700);
            margin: 0;
        }

        .main-content {
            padding: 40px;
            width: 100%;
        }

        .header-section {
            margin-bottom: 30px;
        }

        .header-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--blue-900);
            margin-bottom: 8px;
        }

        .header-subtitle {
            font-size: 14px;
            color: var(--gray-500);
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
        }

        .alert-success {
            background-color: var(--green-100);
            color: #15803d;
            border-left: 4px solid var(--green-600);
        }

        .alert-error {
            background-color: var(--red-100);
            color: #b91c1c;
            border-left: 4px solid var(--red-600);
        }

        .tab-nav {
            display: flex;
            gap: 24px;
            border-bottom: 1px solid var(--gray-200);
            margin-bottom: 30px;
        }

        .tab-btn {
            background: none;
            border: none;
            padding: 12px 4px;
            font-size: 16px;
            font-weight: 600;
            color: var(--gray-500);
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }

        .tab-btn:hover {
            color: var(--blue-600);
        }

        .tab-btn.active {
            color: var(--blue-600);
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 2px;
            background-color: var(--blue-600);
        }

        .tab-pane {
            display: none;
        }

        .tab-pane.active {
            display: block;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }

        .request-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s;
        }

        .request-card:hover {
            transform: translateY(-2px);
        }

        .card-image-wrap {
            height: 180px;
            background: #f1f5f9;
            position: relative;
            overflow: hidden;
            cursor: zoom-in;
        }

        .card-image-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            opacity: 0;
            transition: opacity 0.2s;
            font-size: 14px;
            font-weight: 500;
        }

        .card-image-wrap:hover .image-overlay {
            opacity: 1;
        }

        .card-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-size: 18px;
            font-weight: 700;
            color: var(--blue-900);
            margin-bottom: 12px;
        }

        .info-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            margin-bottom: 8px;
            color: var(--gray-700);
        }

        .info-row i {
            color: var(--gray-500);
            width: 16px;
            text-align: center;
        }

        .card-actions {
            margin-top: 20px;
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: all 0.2s;
            border: none;
        }

        .btn-success {
            background-color: var(--green-600);
            color: var(--white);
        }

        .btn-success:hover {
            background-color: #15803d;
        }

        .btn-danger {
            background-color: var(--red-600);
            color: var(--white);
        }

        .btn-danger:hover {
            background-color: #b91c1c;
        }

        .table-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            text-align: left;
        }

        th {
            background-color: var(--gray-50);
            padding: 16px;
            font-weight: 600;
            color: var(--gray-900);
            border-bottom: 1px solid var(--gray-200);
        }

        td {
            padding: 16px;
            border-bottom: 1px solid var(--gray-200);
            vertical-align: middle;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-success {
            background-color: var(--green-100);
            color: #15803d;
        }

        .badge-error {
            background-color: var(--red-100);
            color: #b91c1c;
        }

        .table-image-preview {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid var(--gray-200);
            cursor: zoom-in;
        }

        /* Modal styling */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-content {
            background: var(--white);
            border-radius: 12px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            overflow: hidden;
            animation: modalFade 0.2s ease-out;
        }

        @keyframes modalFade {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--blue-900);
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 20px;
            color: var(--gray-500);
            cursor: pointer;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 16px 20px;
            border-top: 1px solid var(--gray-200);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .textarea-control {
            width: 100%;
            height: 100px;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid var(--gray-200);
            font-family: inherit;
            font-size: 14px;
            resize: none;
            box-sizing: border-box;
        }

        .textarea-control:focus {
            outline: none;
            border-color: var(--blue-500);
        }

        .image-modal .modal-content {
            max-width: 800px;
            background: none;
            box-shadow: none;
        }

        .image-modal img {
            width: 100%;
            max-height: 80vh;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25);
        }

        .image-modal .modal-close {
            position: absolute;
            top: 20px;
            right: 20px;
            color: var(--white);
            font-size: 30px;
            background: rgba(15, 23, 42, 0.5);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="verifications"/>
    </jsp:include>

    <!-- Main Content Area -->
    <main class="main-content">
        <div class="header-section">
            <h1 class="header-title">Quản Lý Xác Minh Sinh Viên</h1>
            <p class="header-subtitle">Xét duyệt các yêu cầu đăng ký nâng cấp vai trò sinh viên của khách hàng.</p>
        </div>

        <!-- Success/Error Alerts -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${successMessage}</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <!-- Tab Switching -->
        <div class="tab-nav">
            <button class="tab-btn active" onclick="switchPane('pending-pane', this)">Yêu cầu chờ duyệt</button>
            <button class="tab-btn" onclick="switchPane('history-pane', this)">Lịch sử yêu cầu</button>
        </div>

        <!-- ── TAB PANE: PENDING REQUESTS ── -->
        <div class="tab-pane active" id="pending-pane">
            <c:choose>
                <c:when test="${empty requestsList}">
                    <div style="text-align:center; padding:60px 20px; background:#fff; border-radius:12px; border:1px solid var(--gray-200); box-shadow:var(--shadow);">
                        <i class="fas fa-inbox" style="font-size:48px; color:var(--gray-500); margin-bottom:16px;"></i>
                        <h3 style="color:var(--blue-900); font-weight:600;">Không có yêu cầu chờ duyệt</h3>
                        <p style="color:var(--gray-500); font-size:14px; margin-top:8px;">Tất cả các yêu cầu xác minh sinh viên đã được giải quyết.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Check if there are any actual pending requests in the list --%>
                    <c:set var="hasPending" value="false" />
                    <c:forEach var="req" items="${requestsList}">
                        <c:if test="${req.status == 'pending'}">
                            <c:set var="hasPending" value="true" />
                        </c:if>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${not hasPending}">
                            <div style="text-align:center; padding:60px 20px; background:#fff; border-radius:12px; border:1px solid var(--gray-200); box-shadow:var(--shadow);">
                                <i class="fas fa-inbox" style="font-size:48px; color:var(--gray-500); margin-bottom:16px;"></i>
                                <h3 style="color:var(--blue-900); font-weight:600;">Không có yêu cầu chờ duyệt</h3>
                                <p style="color:var(--gray-500); font-size:14px; margin-top:8px;">Tất cả các yêu cầu xác minh sinh viên đã được giải quyết.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card-grid">
                                <c:forEach var="req" items="${requestsList}">
                                    <c:if test="${req.status == 'pending'}">
                                        <div class="request-card">
                                            <div class="card-image-wrap" onclick="viewImage('${pageContext.request.contextPath}/images/${req.studentCardImage}')">
                                                <img src="${pageContext.request.contextPath}/images/${req.studentCardImage}" alt="Thẻ sinh viên">
                                                <div class="image-overlay">
                                                    <i class="fas fa-search-plus" style="font-size:20px; margin-bottom:8px;"></i>
                                                    <span>Xem ảnh thẻ</span>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="user-name">${req.userName}</div>
                                                <div class="info-row">
                                                    <i class="fas fa-envelope"></i>
                                                    <span>${req.userEmail}</span>
                                                </div>
                                                <div class="info-row">
                                                    <i class="fas fa-phone"></i>
                                                    <span>${not empty req.userPhone ? req.userPhone : 'Không cung cấp'}</span>
                                                </div>
                                                <div class="info-row">
                                                    <i class="fas fa-calendar-alt"></i>
                                                    <span>Gửi lúc: <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                </div>
                                                <div class="card-actions">
                                                    <button class="btn btn-success" style="flex:1;" onclick="approveRequest(${req.verificationId}, '${req.userName}')">
                                                        <i class="fas fa-check"></i> Duyệt
                                                    </button>
                                                    <button class="btn btn-danger" style="flex:1;" onclick="openRejectModal(${req.verificationId}, '${req.userName}')">
                                                        <i class="fas fa-times"></i> Từ chối
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ── TAB PANE: HISTORY ── -->
        <div class="tab-pane" id="history-pane">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Họ Tên</th>
                            <th>Email</th>
                            <th>Ảnh Thẻ</th>
                            <th>Ngày Gửi</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Xử Lý</th>
                            <th>Phản Hồi / Lý do từ chối</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="hasHistory" value="false" />
                        <c:forEach var="req" items="${requestsList}">
                            <c:if test="${req.status != 'pending'}">
                                <c:set var="hasHistory" value="true" />
                                <tr>
                                    <td style="font-weight:600; color:var(--blue-900);">${req.userName}</td>
                                    <td>${req.userEmail}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/images/${req.studentCardImage}" 
                                             class="table-image-preview" 
                                             alt="Thẻ sinh viên"
                                             onclick="viewImage('${pageContext.request.contextPath}/images/${req.studentCardImage}')">
                                    </td>
                                    <td><fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${req.status == 'approved'}">
                                                <span class="badge badge-success"><i class="fas fa-check-circle"></i> Đã duyệt</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-error"><i class="fas fa-times-circle"></i> Từ chối</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${req.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td style="max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="${req.staffNote}">
                                        ${not empty req.staffNote ? req.staffNote : '-'}
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasHistory}">
                            <tr>
                                <td colspan="7" style="text-align:center; padding:40px; color:var(--gray-500);">Chưa có lịch sử xử lý yêu cầu nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- Approve Request Invisible Form -->
<form id="approveForm" action="${pageContext.request.contextPath}/staff/verifications" method="post" style="display:none;">
    <input type="hidden" name="action" value="approve">
    <input type="hidden" name="verificationId" id="approveId">
</form>

<!-- Rejection Modal -->
<div class="modal" id="rejectModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">Từ Chối Xác Minh Sinh Viên</h3>
            <button class="modal-close" onclick="closeRejectModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/staff/verifications" method="post">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" name="verificationId" id="rejectId">
            <div class="modal-body">
                <p style="font-size:14px; margin-bottom:12px; color:var(--gray-700);">
                    Bạn đang từ chối yêu cầu của <strong id="rejectUserName"></strong>. Vui lòng nhập lý do từ chối để gửi lại cho khách hàng:
                </p>
                <textarea class="textarea-control" name="staffNote" required placeholder="Ví dụ: Ảnh mờ không nhìn rõ thông tin, Thẻ sinh viên đã hết hạn..."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn" style="background:#e2e8f0; color:var(--gray-700);" onclick="closeRejectModal()">Hủy</button>
                <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
            </div>
        </form>
    </div>
</div>

<!-- Full Image View Modal -->
<div class="modal image-modal" id="imageModal" onclick="closeImageModal()">
    <button class="modal-close" onclick="closeImageModal()">&times;</button>
    <div class="modal-content" onclick="event.stopPropagation()">
        <img id="fullImage" src="" alt="Full Card Image">
    </div>
</div>

<script>
    // Tab switching panes
    function switchPane(paneId, button) {
        document.querySelectorAll('.tab-pane').forEach(function(pane) {
            pane.classList.remove('active');
        });
        document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });

        document.getElementById(paneId).classList.add('active');
        button.classList.add('active');
    }

    // Direct approve confirmation
    function approveRequest(id, name) {
        if (confirm("Bạn có chắc chắn muốn DUYỆT yêu cầu xác minh sinh viên của \"" + name + "\"?")) {
            document.getElementById('approveId').value = id;
            document.getElementById('approveForm').submit();
        }
    }

    // Reject modal open/close
    function openRejectModal(id, name) {
        document.getElementById('rejectId').value = id;
        document.getElementById('rejectUserName').textContent = name;
        document.getElementById('rejectModal').style.display = 'flex';
    }

    function closeRejectModal() {
        document.getElementById('rejectModal').style.display = 'none';
    }

    // Image Zoom modal open/close
    function viewImage(src) {
        document.getElementById('fullImage').src = src;
        document.getElementById('imageModal').style.display = 'flex';
    }

    function closeImageModal() {
        document.getElementById('imageModal').style.display = 'none';
    }
</script>
</body>
</html>

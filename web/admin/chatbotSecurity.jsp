<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniLap Admin - Chatbot Security</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chatbot-admin.css">
</head>
<body>
<div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
            <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
            <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
            <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
            <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
            <a href="${pageContext.request.contextPath}/admin/chatbot-feedback"><span>💬</span>Chatbot Feedback</a>
            <a class="active" href="${pageContext.request.contextPath}/admin/chatbot-security"><span>🛡</span>Chatbot Security</a>
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <c:choose>
                    <c:when test="${not empty sessionScope.user && not empty sessionScope.user.avatarUrl}">
                        <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}" 
                             alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                    </c:when>
                    <c:otherwise>
                        <span>♙</span>
                    </c:otherwise>
                </c:choose>
                <span>Admin Profile</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main">
        <header class="topbar">
            <h1>Quản Lý Chatbot</h1>
            <div class="top-icons"><i class="fas fa-bell"></i> &nbsp; <i class="fas fa-user-shield"></i></div>
        </header>

        <section class="page-head">
            <div>
                <h2>Nhật Ký Bảo Mật Chatbot</h2>
                <p>Theo dõi các hành vi nguy hại, spam hoặc cố tình xâm nhập trái phép vào database hệ thống thông qua AI Chatbot.</p>
            </div>
        </section>

        <!-- Stats Grid -->
        <section class="stats-grid">
            <article class="stat-card">
                <h3>Tổng số cảnh báo</h3>
                <strong class="blue">${securityLogs.size()}</strong>
                <p>Số lần phát hiện vi phạm</p>
            </article>
            <article class="stat-card">
                <h3>Tấn công bẻ khóa (Jailbreak)</h3>
                <strong class="red">
                    <c:set var="jailbreakCount" value="0"/>
                    <c:forEach items="${securityLogs}" var="log">
                        <c:if test="${log.violationType.contains('JAILBREAK') || log.violationType.contains('PROMPT_INJECTION')}">
                            <c:set var="jailbreakCount" value="${jailbreakCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${jailbreakCount}
                </strong>
                <p>Nghiêm trọng (Cần chặn ngay)</p>
            </article>
            <article class="stat-card">
                <h3>Spam tin nhắn</h3>
                <strong class="orange">
                    <c:set var="spamCount" value="0"/>
                    <c:forEach items="${securityLogs}" var="log">
                        <c:if test="${log.violationType == 'SPAM'}">
                            <c:set var="spamCount" value="${spamCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${spamCount}
                </strong>
                <p>Tần suất gửi quá giới hạn</p>
            </article>
        </section>

        <!-- Table Panel -->
        <section class="panel">
            <div class="panel-title">
                <h2>Cảnh báo an ninh Chatbot</h2>
            </div>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Người dùng vi phạm</th>
                    <th>Loại Vi Phạm</th>
                    <th>Nội Dung Câu Hỏi Độc Hại</th>
                    <th>Trạng thái Chatbot</th>
                    <th>Hành động bảo vệ</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty securityLogs}">
                        <c:forEach items="${securityLogs}" var="log">
                            <tr>
                                <td>
                                    <div style="font-weight: 600; color: #1e293b;">${log.userName}</div>
                                    <div style="font-size: 12px; color: #64748b;">${log.userEmail}</div>
                                    <div style="font-size: 11px; color: #94a3b8; margin-top: 2px;"><i class="far fa-clock"></i> <fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                </td>
                                <td>
                                    <span class="violation-badge ${log.violationType.toLowerCase()}">
                                        ${log.violationType}
                                    </span>
                                </td>
                                <td>
                                    <div class="violation-msg">"${log.violatedMessage}"</div>
                                </td>
                                <td>
                                    <span class="user-status-text ${log.isUserBlocked ? 'blocked' : 'active'}" id="status-text-${log.userId}">
                                        <i class="fas ${log.isUserBlocked ? 'fa-ban' : 'fa-check-circle'}"></i> 
                                        ${log.isUserBlocked ? 'Đang bị chặn chat' : 'Hoạt động bình thường'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${log.isUserBlocked}">
                                            <button class="btn-block-action unblock-btn" id="btn-action-${log.userId}" onclick="toggleBlockUser(${log.userId}, 'unblock')">
                                                <i class="fas fa-unlock"></i> Bỏ chặn Chat
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-block-action block-btn" id="btn-action-${log.userId}" onclick="toggleBlockUser(${log.userId}, 'block')">
                                                <i class="fas fa-user-slash"></i> Chặn Chatbot
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #94a3b8; padding: 30px;">Hệ thống an toàn. Chưa phát hiện hành vi vi phạm nào.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </section>
    </main>
</div>

<script>
    function toggleBlockUser(userId, action) {
        const confirmMsg = action === 'block' 
            ? 'Bạn có chắc chắn muốn chặn quyền truy cập chatbot của người dùng này không?' 
            : 'Bạn có chắc chắn muốn mở chặn chatbot cho người dùng này không?';
            
        if (!confirm(confirmMsg)) return;

        // Gọi AJAX POST lên AdminChatbotController
        const params = new URLSearchParams();
        params.append('action', action);
        params.append('userId', userId);
        params.append('reason', 'Phát hiện hành vi vi phạm an toàn thông tin hệ thống.');

        fetch('${pageContext.request.contextPath}/admin/chatbot-action', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(res => {
            if (!res.ok) throw new Error('Cập nhật thất bại.');
            return res.json();
        })
        .then(data => {
            if (data.status === 'success') {
                alert(action === 'block' ? 'Đã chặn thành công!' : 'Đã mở chặn thành công!');
                
                // Cập nhật giao diện động mà không cần F5
                const statusText = document.getElementById('status-text-' + userId);
                const actionBtn = document.getElementById('btn-action-' + userId);
                
                if (action === 'block') {
                    statusText.className = 'user-status-text blocked';
                    statusText.innerHTML = '<i class="fas fa-ban"></i> Đang bị chặn chat';
                    
                    actionBtn.className = 'btn-block-action unblock-btn';
                    actionBtn.innerHTML = '<i class="fas fa-unlock"></i> Bỏ chặn Chat';
                    actionBtn.setAttribute('onclick', `toggleBlockUser(${userId}, 'unblock')`);
                } else {
                    statusText.className = 'user-status-text active';
                    statusText.innerHTML = '<i class="fas fa-check-circle"></i> Hoạt động bình thường';
                    
                    actionBtn.className = 'btn-block-action block-btn';
                    actionBtn.innerHTML = '<i class="fas fa-user-slash"></i> Chặn Chatbot';
                    actionBtn.setAttribute('onclick', `toggleBlockUser(${userId}, 'block')`);
                }
            } else {
                alert('Có lỗi xảy ra: ' + data.error);
            }
        })
        .catch(err => {
            console.error('Lỗi chặn user:', err);
            alert('Có lỗi xảy ra trong quá trình xử lý yêu cầu.');
        });
    }
</script>
</body>
</html>

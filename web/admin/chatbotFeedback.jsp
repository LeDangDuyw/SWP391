<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniLap Admin - Chatbot Feedback</title>
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
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>▣</span>Orders</a>
            <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
            <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
            <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
            <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
            <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
            <a class="active" href="${pageContext.request.contextPath}/admin/chatbot-feedback"><span>💬</span>Chatbot Feedback</a>
            <a href="${pageContext.request.contextPath}/admin/chatbot-security"><span>🛡</span>Chatbot Security</a>
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
                <h2>Đánh Giá Chất Lượng Chatbot</h2>
                <p>Xem phản hồi, bình luận và đánh giá số sao của khách hàng đối với trợ lý ảo AI.</p>
            </div>
        </section>

        <!-- Stats grid -->
        <section class="stats-grid">
            <article class="stat-card">
                <h3>Tổng số lượt đánh giá</h3>
                <strong class="blue">${feedbacks.size()}</strong>
                <p>Tất cả các phiên chat</p>
            </article>
            <article class="stat-card">
                <h3>Đánh giá 5 sao</h3>
                <strong class="green">
                    <c:set var="fiveStars" value="0"/>
                    <c:forEach items="${feedbacks}" var="f">
                        <c:if test="${f.rating == 5}"><c:set var="fiveStars" value="${fiveStars + 1}"/></c:if>
                    </c:forEach>
                    ${fiveStars}
                </strong>
                <p>Khách hàng hài lòng tuyệt đối</p>
            </article>
            <article class="stat-card">
                <h3>Cần cải thiện (< 5 sao)</h3>
                <strong class="red">
                    ${feedbacks.size() - fiveStars}
                </strong>
                <p>Khách hàng có ý kiến đóng góp</p>
            </article>
        </section>

        <!-- Panel Table -->
        <section class="panel">
            <div class="panel-title">
                <h2>Danh sách phản hồi từ Khách hàng</h2>
            </div>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Khách Hàng</th>
                    <th>Đánh Giá</th>
                    <th>Nội Dung Góp Ý</th>
                    <th>Chi Tiết Hội Thoại</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty feedbacks}">
                        <c:forEach items="${feedbacks}" var="f">
                            <tr>
                                <td>
                                    <div style="font-weight: 600; color: #1e293b;">${f.userName}</div>
                                    <div style="font-size: 12px; color: #64748b;">${f.userEmail}</div>
                                    <div style="font-size: 11px; color: #94a3b8; margin-top: 2px;"><i class="far fa-clock"></i> <fmt:formatDate value="${f.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                </td>
                                <td>
                                    <div class="star-rating">
                                        <c:forEach begin="1" end="${f.rating}">★</c:forEach><c:forEach begin="${f.rating + 1}" end="5">☆</c:forEach>
                                    </div>
                                    <span style="font-size: 11px; font-weight: 500; color: ${f.rating == 5 ? '#10b981' : '#f59e0b'};">
                                        ${f.rating}/5 sao
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty f.comment}">
                                            <div class="feedback-comment">"${f.comment}"</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #94a3b8; font-style: italic; font-size: 13px;">Không có ý kiến thêm</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn ghost" style="padding: 4px 8px; font-size: 12px;" 
                                            onclick="openDetailModal('${f.userName}', `${f.aiQuestion.replace('`','\\`').replace('"','\\"')}`, `${f.aiAnswer.replace('`','\\`').replace('"','\\"')}`)">
                                        <i class="far fa-comments"></i> Xem tin nhắn
                                    </button>
                                </td>
                                <td>
                                    <!-- Nút dạy AI phản hồi đúng (đặc biệt khi feedback thấp) -->
                                    <button class="btn-teach" onclick="openTeachModal(`${f.aiQuestion.replace('`','\\`').replace('"','\\"')}`, `${f.aiAnswer.replace('`','\\`').replace('"','\\"')}`)">
                                        <i class="fas fa-graduation-cap"></i> Sửa câu trả lời
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #94a3b8; padding: 30px;">Chưa có lượt đánh giá nào cho chatbot.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </section>
    </main>
</div>

<!-- Modal Chi tiết hội thoại -->
<div id="detailModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('detailModal')">&times;</span>
        <div class="modal-title">Chi Tiết Hội Thoại Khách Hàng</div>
        <div class="form-group">
            <label>Khách Hàng:</label>
            <input type="text" id="modalCustomerName" readonly style="background: #f1f5f9;" />
        </div>
        <div class="form-group">
            <label><i class="fas fa-user" style="color:#3b82f6;"></i> Câu hỏi của khách hàng:</label>
            <textarea id="modalUserQuestion" rows="3" readonly style="background: #f8fafc; font-weight: 500; color: #1e293b;"></textarea>
        </div>
        <div class="form-group">
            <label><i class="fas fa-robot" style="color:#10b981;"></i> Phản hồi từ AI Chatbot:</label>
            <textarea id="modalAiAnswer" rows="5" readonly style="background: #f8fafc; color: #334155;"></textarea>
        </div>
        <div class="modal-footer">
            <button class="btn-modal cancel" onclick="closeModal('detailModal')">Đóng</button>
        </div>
    </div>
</div>

<!-- Modal Sửa lỗi trả lời AI (Dạy học) -->
<div id="teachModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('teachModal')">&times;</span>
        <div class="modal-title"><i class="fas fa-graduation-cap" style="color: #10b981;"></i> Dạy Lại Chatbot AI</div>
        <form id="teachForm">
            <div class="form-group">
                <label>Câu hỏi của khách hàng:</label>
                <textarea id="teachQuestion" name="question" rows="2" readonly style="background: #f1f5f9;"></textarea>
            </div>
            <div class="form-group">
                <label>Câu trả lời chưa chuẩn hiện tại của AI:</label>
                <textarea id="teachOldAnswer" rows="2" readonly style="background: #f8fafc; color: #64748b; font-size: 13px;"></textarea>
            </div>
            <div class="form-group">
                <label style="color: #10b981; font-weight: 600;">Câu trả lời chuẩn Admin mong muốn:</label>
                <textarea id="teachCorrectAnswer" name="correctAnswer" rows="4" placeholder="Nhập câu trả lời chuẩn xác nhất..." required></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-modal cancel" onclick="closeModal('teachModal')">Hủy bỏ</button>
                <button type="submit" class="btn-modal confirm">Lưu & Huấn luyện</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openDetailModal(customerName, question, answer) {
        document.getElementById('modalCustomerName').value = customerName;
        document.getElementById('modalUserQuestion').value = question;
        document.getElementById('modalAiAnswer').value = answer;
        document.getElementById('detailModal').style.display = 'block';
    }

    function openTeachModal(question, oldAnswer) {
        document.getElementById('teachQuestion').value = question;
        document.getElementById('teachOldAnswer').value = oldAnswer;
        document.getElementById('teachCorrectAnswer').value = '';
        document.getElementById('teachModal').style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Đóng modal khi click ra ngoài
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = "none";
        }
    }

    // Xử lý gửi dạy học AI bằng FastAPI API /day của feedback_handler thông qua FastAPI endpoint (hoặc gọi trực tiếp từ JS nếu có)
    // Để giữ tính nhất quán, ta gửi lệnh /day trực tiếp thông qua API Chat của chatbot để chatbot lưu quy tắc (hoặc tạo endpoint riêng).
    // Ở đây ta gọi API chat của FastAPI từ client bằng cách gửi lệnh '/day [câu trả lời mới]' cùng session_id.
    // Hoặc ta có thể gửi request đến FastAPI trực tiếp. Vì FastAPI chạy ở port 8000.
    document.getElementById('teachForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const question = document.getElementById('teachQuestion').value;
        const correctAnswer = document.getElementById('teachCorrectAnswer').value.trim();
        
        if (!correctAnswer) return;

        // Bật chế độ train và dạy AI thông qua cổng FastAPI (http://localhost:8000/chat)
        // Bằng cách giả lập gửi tin nhắn của admin. Admin gửi tin nhắn "/day [câu trả lời]" sau khi vừa hỏi câu đó.
        // Để đơn giản và nhanh gọn, ta gọi FastAPI trực tiếp:
        fetch('http://localhost:8000/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                message: '/day ' + correctAnswer,
                session_id: 'admin_teach_session' // Một session riêng biệt
            })
        })
        .then(res => res.json())
        .then(data => {
            alert('Huấn luyện thành công! AI đã ghi nhận câu trả lời chuẩn.');
            closeModal('teachModal');
        })
        .catch(err => {
            console.error('Lỗi huấn luyện AI:', err);
            alert('Không thể kết nối trực tiếp đến FastAPI Server (localhost:8000) để huấn luyện!');
        });
    });
</script>
</body>
</html>

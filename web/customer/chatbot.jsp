<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- UniLap Floating Chatbot Widget -->

<!-- Import Chat CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css?v=2">

<!-- Define Context Path for chat.js -->
<script>
    if (!window.contextPath) {
        window.contextPath = "${pageContext.request.contextPath}";
    }
</script>

<!-- Bong bóng chat nổi -->
<div class="chat-widget-toggle">
    <i class="fas fa-comment-dots"></i>
</div>

<!-- Khung popup chat -->
<div class="chat-widget-container">
    <div class="chat-widget-header">
        <div class="chat-header-info">
            <div class="chat-header-avatar">
                <i class="fas fa-robot"></i>
            </div>
            <div class="chat-header-title">
                <h3>UniLap AI</h3>
                <div class="chat-header-status">
                    <span class="chat-status-dot"></span> Đang trực tuyến
                </div>
            </div>
        </div>
        <div class="chat-header-actions">
            <button class="chat-action-btn chat-expand-btn" title="Mở rộng"><i class="fas fa-expand-alt"></i></button>
            <button class="chat-action-btn chat-close-btn" title="Đóng"><i class="fas fa-times"></i></button>
        </div>
    </div>
    
    <div class="chat-messages-area">
        <!-- Tin nhắn tự động load từ chat.js -->
    </div>
    
    <div class="chat-quick-replies">
        <button class="quick-reply-btn" data-question="Tìm laptop gaming dưới 25 triệu tốt nhất">Laptop Gaming &lt; 25tr</button>
        <button class="quick-reply-btn" data-question="Tư vấn bàn phím cơ gõ êm cho văn phòng">Bàn phím gõ êm</button>
        <button class="quick-reply-btn" data-question="Chính sách bảo hành và đổi trả của shop thế nào?">Chính sách bảo hành</button>
    </div>
    
    <div class="chat-input-area">
        <input type="text" class="chat-input-field" placeholder="Hỏi UniLap AI về sản phẩm..." autocomplete="off">
        <button class="chat-send-button" type="button">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
</div>

<!-- Import Chat JS -->
<script src="${pageContext.request.contextPath}/js/chat.js?v=2"></script>

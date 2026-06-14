/**
 * UniLap Chatbot JavaScript - Logic & State Management
 * Author: Antigravity AI
 * Version: 1.0
 */

(function () {
    // Biến toàn cục lưu lịch sử chat trong phiên hiện tại
    let chatHistory = [];
    const HISTORY_KEY = "unilap_chat_history";
    
    // Đọc URL Servlet và API trực tiếp
    const getContextPath = () => window.contextPath || "";
    const SERVLET_URL = getContextPath() + "/chat-ai";
    const DIRECT_API_URL = "http://localhost:8000/chat";

    // Khởi chạy khi DOM đã sẵn sàng
    document.addEventListener("DOMContentLoaded", function () {
        // Kiểm tra xem trang có chứa Widget chat nhỏ không
        const isMiniChatPresent = document.getElementById("unilap-chat-popup") !== null;
        // Kiểm tra xem trang có chứa giao diện Chat lớn không
        const isFullChatPresent = document.getElementById("chat-full-container") !== null;

        // Tải lịch sử chat từ sessionStorage
        loadChatHistory();

        if (isMiniChatPresent) {
            initMiniChat();
        }
        if (isFullChatPresent) {
            initFullChat();
        }
    });

    // ==========================================================================
    // QUẢN LÝ LỊCH SỬ CHAT (State Management)
    // ==========================================================================
    function loadChatHistory() {
        const stored = sessionStorage.getItem(HISTORY_KEY);
        if (stored) {
            try {
                chatHistory = JSON.parse(stored);
            } catch (e) {
                console.error("Lỗi parse lịch sử chat:", e);
                chatHistory = [];
            }
        }
        
        // Nếu lịch sử trống, chèn tin nhắn chào mừng mặc định từ Bot
        if (chatHistory.length === 0) {
            chatHistory.push({
                sender: "bot",
                text: "Xin chào! Mình là **Trợ lý ảo UniLap AI**. Mình có thể giúp gì cho bạn về thông tin sản phẩm, chính sách mua sắm, bảo hành hoặc khuyến mãi tại UniLap?",
                time: new Date().toLocaleTimeString("vi-VN", { hour: '2-digit', minute: '2-digit' })
            });
            saveChatHistory();
        }
    }

    function saveChatHistory() {
        sessionStorage.setItem(HISTORY_KEY, JSON.stringify(chatHistory));
    }

    function addMessageToHistory(sender, text) {
        const timeStr = new Date().toLocaleTimeString("vi-VN", { hour: '2-digit', minute: '2-digit' });
        chatHistory.push({ sender, text, time: timeStr });
        saveChatHistory();
    }

    // Định dạng ký tự xuống dòng và in đậm cơ bản
    function formatMessageText(text) {
        if (!text) return "";
        let formatted = text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\n/g, "<br>")
            .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>"); // Hỗ trợ in đậm bằng **text**
        return formatted;
    }

    // Tạo HTML cho bong bóng tin nhắn
    function createMessageHTML(sender, text, time) {
        const wrapperClass = sender === "user" ? "unilap-message-wrapper user" : "unilap-message-wrapper bot";
        const avatarHTML = sender === "bot" 
            ? `<div class="unilap-chat-avatar"><i class="fas fa-robot"></i></div>` 
            : "";
            
        return `
            <div class="${wrapperClass}">
                ${avatarHTML}
                <div class="unilap-message-content">
                    <p>${formatMessageText(text)}</p>
                    <div class="unilap-message-time">${time}</div>
                </div>
            </div>
        `;
    }

    // Gửi yêu cầu API đến Servlet hoặc gọi trực tiếp FastAPI
    async function fetchBotAnswer(userInput) {
        const params = new URLSearchParams();
    params.append("message", userInput);

    try {
        console.log("Đang gọi Servlet qua: " + SERVLET_URL);

        const response = await fetch(SERVLET_URL, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        });

        if (!response.ok) {
            throw new Error("Servlet response not ok: " + response.status);
        }

        const responseText = await response.text();
        return parseBotResponse(responseText);

    } catch (servletError) {
        console.error("Lỗi kết nối Servlet:", servletError);

        return "Xin lỗi, hiện tại mình không thể kết nối tới máy chủ AI. Bạn hãy kiểm tra FastAPI, LM Studio, SQL Server và Tomcat.";
    }
    }

    // Phân tích dữ liệu JSON trả về để tìm câu trả lời hợp lệ
    function parseBotResponse(responseText) {
        try {
            const data = JSON.parse(responseText);
            // Hỗ trợ các thuộc tính trả về phổ biến: answer, response, message, text
            return data.answer || data.response || data.message || data.text || JSON.stringify(data);
        } catch (e) {
            // Nếu không phải định dạng JSON, trả về nguyên bản text
            return responseText;
        }
    }

    // ==========================================================================
    // LOGIC CHAT WIDGET NHỎ (Mini Chat Window)
    // ==========================================================================
    function initMiniChat() {
        const launcher = document.getElementById("unilap-chat-launcher");
        const popup = document.getElementById("unilap-chat-popup");
        const closeBtn = document.getElementById("unilap-chat-close");
        const expandBtn = document.getElementById("unilap-chat-expand");
        const messagesContainer = document.getElementById("unilap-chat-messages");
        const sendBtn = document.getElementById("unilap-chat-send");
        const inputField = document.getElementById("unilap-chat-input");
        const suggestionsContainer = document.getElementById("unilap-chat-suggestions");

        // Toggle ẩn/hiện popup chat
        launcher.addEventListener("click", () => {
            popup.classList.add("active");
            launcher.style.display = "none";
            renderMessages(messagesContainer);
        });

        closeBtn.addEventListener("click", () => {
            popup.classList.remove("active");
            launcher.style.display = "flex";
        });

        // Bấm mở rộng sang trang chat-full.jsp
        expandBtn.addEventListener("click", () => {
            saveChatHistory();
            window.location.href = getContextPath() + "/chat-full";
        });

        // Bấm nút gửi tin nhắn
        sendBtn.addEventListener("click", () => {
            handleSendMessageMini(inputField, messagesContainer);
        });

        // Nhấn Enter để gửi tin nhắn
        inputField.addEventListener("keydown", (e) => {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSendMessageMini(inputField, messagesContainer);
            }
        });

        // Xử lý click các nút gợi ý nhanh
        if (suggestionsContainer) {
            suggestionsContainer.addEventListener("click", (e) => {
                if (e.target.classList.contains("unilap-suggestion-chip")) {
                    const prompt = e.target.getAttribute("data-prompt");
                    if (prompt) {
                        inputField.value = prompt;
                        handleSendMessageMini(inputField, messagesContainer);
                    }
                }
            });
        }

        // Tự động mở popup nếu người dùng quay về từ trang chat lớn và có hội thoại dài
        if (chatHistory.length > 1 && sessionStorage.getItem("unilap_chat_from_full") === "true") {
            sessionStorage.removeItem("unilap_chat_from_full");
            popup.classList.add("active");
            launcher.style.display = "none";
            renderMessages(messagesContainer);
        }
    }

    // Hiển thị tin nhắn trong widget nhỏ
    function renderMessages(container) {
        container.innerHTML = "";
        chatHistory.forEach(msg => {
            container.innerHTML += createMessageHTML(msg.sender, msg.text, msg.time);
        });
        scrollBottom(container);
    }

    // Xử lý gửi tin nhắn ở widget nhỏ
    async function handleSendMessageMini(input, container) {
        const text = input.value.trim();
        if (!text) return;

        // Xóa nội dung ở input
        input.value = "";

        // Hiển thị tin nhắn người dùng ngay lập tức
        addMessageToHistory("user", text);
        container.innerHTML += createMessageHTML("user", text, chatHistory[chatHistory.length - 1].time);
        scrollBottom(container);

        // Hiển thị biểu tượng đang nhập (typing indicator)
        const typingId = "unilap-mini-typing";
        container.innerHTML += `
            <div class="unilap-message-wrapper bot" id="${typingId}">
                <div class="unilap-chat-avatar"><i class="fas fa-robot"></i></div>
                <div class="unilap-message-content">
                    <div class="unilap-typing-indicator">
                        <span></span><span></span><span></span>
                    </div>
                </div>
            </div>
        `;
        scrollBottom(container);

        // Gọi API nhận câu trả lời
        const answer = await fetchBotAnswer(text);

        // Xóa biểu tượng đang nhập
        const typingEl = document.getElementById(typingId);
        if (typingEl) typingEl.remove();

        // Thêm câu trả lời của bot vào hội thoại
        addMessageToHistory("bot", answer);
        container.innerHTML += createMessageHTML("bot", answer, chatHistory[chatHistory.length - 1].time);
        scrollBottom(container);
    }


    // ==========================================================================
    // LOGIC TRANG CHAT LỚN TOÀN MÀN HÌNH (Full Page Chat)
    // ==========================================================================
    function initFullChat() {
        const messagesList = document.getElementById("chat-full-messages-list");
        const textarea = document.getElementById("chat-full-textarea");
        const sendBtn = document.getElementById("chat-full-send");
        const clearBtn = document.getElementById("chat-full-clear");
        const viewport = document.getElementById("chat-full-messages-viewport");

        // Thiết lập trạng thái đánh dấu quay lại trang chủ vẫn mở popup
        sessionStorage.setItem("unilap_chat_from_full", "true");

        // Hiển thị các tin nhắn cũ
        renderMessagesFull(messagesList, viewport);

        // Xử lý gửi tin nhắn
        sendBtn.addEventListener("click", () => {
            handleSendMessageFull(textarea, messagesList, viewport);
        });

        // Nhấn Enter gửi (Shift + Enter để xuống dòng)
        textarea.addEventListener("keydown", (e) => {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSendMessageFull(textarea, messagesList, viewport);
            }
        });

        // Nút xóa lịch sử chat
        if (clearBtn) {
            clearBtn.addEventListener("click", () => {
                if (confirm("Bạn có chắc chắn muốn xóa toàn bộ lịch sử trò chuyện không?")) {
                    chatHistory = [];
                    sessionStorage.removeItem(HISTORY_KEY);
                    loadChatHistory();
                    renderMessagesFull(messagesList, viewport);
                }
            });
        }
    }

    // Hiển thị tin nhắn trong khung lớn
    function renderMessagesFull(list, viewport) {
        list.innerHTML = "";
        chatHistory.forEach(msg => {
            list.innerHTML += createMessageHTML(msg.sender, msg.text, msg.time);
        });
        scrollBottom(viewport);
    }

    // Xử lý gửi tin nhắn ở khung lớn
    async function handleSendMessageFull(textarea, list, viewport) {
        const text = textarea.value.trim();
        if (!text) return;

        textarea.value = "";
        textarea.style.height = "auto"; // Reset chiều cao

        // Hiển thị tin nhắn user
        addMessageToHistory("user", text);
        list.innerHTML += createMessageHTML("user", text, chatHistory[chatHistory.length - 1].time);
        scrollBottom(viewport);

        // Hiển thị biểu tượng đang nhập
        const typingId = "unilap-full-typing";
        list.innerHTML += `
            <div class="unilap-message-wrapper bot" id="${typingId}">
                <div class="unilap-chat-avatar"><i class="fas fa-robot"></i></div>
                <div class="unilap-message-content">
                    <div class="unilap-typing-indicator">
                        <span></span><span></span><span></span>
                    </div>
                </div>
            </div>
        `;
        scrollBottom(viewport);

        // Gọi API nhận phản hồi
        const answer = await fetchBotAnswer(text);

        // Xóa biểu tượng đang nhập
        const typingEl = document.getElementById(typingId);
        if (typingEl) typingEl.remove();

        // Hiển thị tin nhắn bot
        addMessageToHistory("bot", answer);
        list.innerHTML += createMessageHTML("bot", answer, chatHistory[chatHistory.length - 1].time);
        scrollBottom(viewport);
    }

    // Cuộn xuống đáy vùng hiển thị tin nhắn
    function scrollBottom(container) {
        if (!container) return;
        setTimeout(() => {
            container.scrollTop = container.scrollHeight;
        }, 50);
    }
})();

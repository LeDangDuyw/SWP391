/**
 * UniLap Chatbot Core JavaScript
 * Handles floating widget popup, full-screen chat interface, 
 * session storage synchronization, and communication with ChatServlet (/chat-ai).
 */

(function () {
    // Generate or retrieve session ID
    let sessionId = sessionStorage.getItem('unilap_chat_session_id');
    if (!sessionId) {
        sessionId = 'session_' + Math.random().toString(36).substring(2, 15);
        sessionStorage.setItem('unilap_chat_session_id', sessionId);
    }

    // Context path default to empty if not defined globally
    const baseContextPath = window.contextPath || '';
    const apiEndpoint = baseContextPath + '/chat-ai';
    const fallbackEndpoint = 'http://localhost:8000/chat';

    // DOM Elements - Widget (home.jsp)
    let widgetToggle, widgetContainer, widgetInput, widgetSendBtn, widgetMessages, widgetCloseBtn, widgetExpandBtn;
    
    // DOM Elements - Full Screen Chat (chat-full.jsp)
    let fullTextarea, fullSendBtn, fullMessagesContainer, fullMessagesInner, clearHistoryBtn;

    // Initialize after DOM load
    document.addEventListener('DOMContentLoaded', function () {
        initWidgetElements();
        initFullPageElements();
        loadChatHistory();
    });

    /**
     * Locate and bind events for the floating chat widget
     */
    function initWidgetElements() {
        widgetToggle = document.querySelector('.chat-widget-toggle');
        widgetContainer = document.querySelector('.chat-widget-container');
        widgetInput = document.querySelector('.chat-input-field');
        widgetSendBtn = document.querySelector('.chat-send-button');
        widgetMessages = document.querySelector('.chat-messages-area');
        widgetCloseBtn = document.querySelector('.chat-close-btn');
        widgetExpandBtn = document.querySelector('.chat-expand-btn');

        if (widgetToggle && widgetContainer) {
            // Toggle Chat Popup
            widgetToggle.addEventListener('click', function () {
                widgetContainer.classList.toggle('active');
                widgetToggle.classList.toggle('active');
                if (widgetContainer.classList.contains('active')) {
                    widgetInput.focus();
                    scrollToBottom(widgetMessages);
                }
            });

            // Close Chat Popup
            if (widgetCloseBtn) {
                widgetCloseBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    widgetContainer.classList.remove('active');
                    widgetToggle.classList.remove('active');
                });
            }

            // Expand to Full-screen Chat Page
            if (widgetExpandBtn) {
                widgetExpandBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    // Save history state to session storage before navigating
                    window.location.href = baseContextPath + '/chat-full';
                });
            }

            // Send via Enter key
            if (widgetInput) {
                widgetInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        handleSendMessage(widgetInput.value.trim(), 'widget');
                    }
                });
            }

            // Send via button click
            if (widgetSendBtn) {
                widgetSendBtn.addEventListener('click', function () {
                    handleSendMessage(widgetInput.value.trim(), 'widget');
                });
            }

            // Quick reply buttons
            document.querySelectorAll('.quick-reply-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    const text = this.getAttribute('data-question') || this.innerText;
                    handleSendMessage(text, 'widget');
                });
            });
        }
    }

    /**
     * Locate and bind events for the full-screen chat page
     */
    function initFullPageElements() {
        fullTextarea = document.querySelector('.chat-full-textarea');
        fullSendBtn = document.querySelector('.chat-full-send-btn');
        fullMessagesContainer = document.querySelector('.chat-full-messages-container');
        fullMessagesInner = document.querySelector('.chat-full-messages-inner');
        clearHistoryBtn = document.querySelector('.sidebar-footer-btn');

        if (fullTextarea && fullMessagesInner) {
            // Auto-resize textarea
            fullTextarea.addEventListener('input', function () {
                this.style.height = '24px';
                this.style.height = (this.scrollHeight - 16) + 'px';
            });

            // Send via Enter key (but Shift+Enter inserts newline)
            fullTextarea.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleSendMessage(this.value.trim(), 'full');
                }
            });

            // Send via click
            if (fullSendBtn) {
                fullSendBtn.addEventListener('click', function () {
                    handleSendMessage(fullTextarea.value.trim(), 'full');
                });
            }

            // Clear history
            if (clearHistoryBtn) {
                clearHistoryBtn.addEventListener('click', function () {
                    if (confirm('Bạn có chắc chắn muốn xóa toàn bộ lịch sử trò chuyện không?')) {
                        clearChatHistory();
                    }
                });
            }

            // Sidebar recommendation suggestions click
            document.querySelectorAll('.suggestion-item').forEach(item => {
                item.addEventListener('click', function () {
                    const text = this.getAttribute('data-question') || this.innerText.replace(/^\s*[\s\S]*?\s*/, '').trim();
                    handleSendMessage(text, 'full');
                });
            });
        }
    }

    /**
     * Load chat messages from sessionStorage
     */
    function loadChatHistory() {
        const historyJson = sessionStorage.getItem('unilap_chat_history');
        let history = [];

        if (historyJson) {
            try {
                history = JSON.parse(historyJson);
            } catch (e) {
                console.error("Error parsing chat history, resetting.", e);
                history = [];
            }
        }

        // If no history, add a default welcoming message
        if (history.length === 0) {
            history.push({
                sender: 'ai',
                text: 'Xin chào! Mình là trợ lý ảo **UniLap AI**. Mình có thể giúp bạn tìm kiếm laptop, bàn phím, chuột máy tính hoặc giải đáp thông tin chính sách của UniLap. Bạn cần mình hỗ trợ gì hôm nay?'
            });
            sessionStorage.setItem('unilap_chat_history', JSON.stringify(history));
        }

        // Render history in available containers
        if (widgetMessages) {
            widgetMessages.innerHTML = '';
            history.forEach(msg => appendToDOM(msg.sender, msg.text, widgetMessages));
            scrollToBottom(widgetMessages);
        }

        if (fullMessagesInner) {
            fullMessagesInner.innerHTML = '';
            history.forEach(msg => appendToDOM(msg.sender, msg.text, fullMessagesInner));
            scrollToBottom(fullMessagesContainer);
        }
    }

    /**
     * Handle validation and initiate sending flow
     */
    function handleSendMessage(text, source) {
        if (!text) return;

        // Clear active input source
        if (source === 'widget' && widgetInput) {
            widgetInput.value = '';
        } else if (source === 'full' && fullTextarea) {
            fullTextarea.value = '';
            fullTextarea.style.height = '24px';
        }

        // 1. Add user message to UI and storage
        saveAndAppendMessage('user', text);

        // 2. Display typing indicator
        const activeContainer = (source === 'widget') ? widgetMessages : fullMessagesInner;
        const scrollContainer = (source === 'widget') ? widgetMessages : fullMessagesContainer;
        
        const typingEl = showTypingIndicator(activeContainer);
        scrollToBottom(scrollContainer);

        // 3. Make AJAX post call to servlet
        fetch(apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({
                message: text,
                session_id: sessionId
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("HTTP error " + response.status);
            }
            return response.json();
        })
        .then(data => {
            removeTypingIndicator(typingEl);
            const aiAnswer = data.answer || "Không nhận được phản hồi từ AI.";
            saveAndAppendMessage('ai', aiAnswer);
        })
        .catch(error => {
            console.warn("Servlet call failed, attempting direct FastAPI connection...", error);
            
            // Fallback: Call FastAPI directly
            fetch(fallbackEndpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    message: text,
                    session_id: sessionId
                })
            })
            .then(res => {
                if (!res.ok) throw new Error("FastAPI directly returned HTTP error " + res.status);
                return res.json();
            })
            .then(data => {
                removeTypingIndicator(typingEl);
                const aiAnswer = data.answer || "Không nhận được phản hồi từ AI.";
                saveAndAppendMessage('ai', aiAnswer);
            })
            .catch(fallbackError => {
                console.error("Direct connection also failed:", fallbackError);
                removeTypingIndicator(typingEl);
                saveAndAppendMessage('ai', "Hệ thống AI hiện tại đang gặp sự cố kết nối. Vui lòng kiểm tra lại FastAPI Server tại localhost:8000!");
            });
        });
    }

    /**
     * Appends a message to the storage and prints it to the DOM (both widget & full page if present)
     */
    function saveAndAppendMessage(sender, text) {
        // Save to sessionStorage
        const historyJson = sessionStorage.getItem('unilap_chat_history');
        let history = historyJson ? JSON.parse(historyJson) : [];
        history.push({ sender, text });
        sessionStorage.setItem('unilap_chat_history', JSON.stringify(history));

        // Append to DOM dynamically
        if (widgetMessages) {
            appendToDOM(sender, text, widgetMessages);
            scrollToBottom(widgetMessages);
        }
        if (fullMessagesInner) {
            appendToDOM(sender, text, fullMessagesInner);
            scrollToBottom(fullMessagesContainer);
        }
    }

    /**
     * Render message to a target DOM container
     */
    function appendToDOM(sender, text, container) {
        const row = document.createElement('div');
        row.className = 'chat-msg-row ' + (sender === 'user' ? 'user-row' : 'ai-row');

        const bubble = document.createElement('div');
        bubble.className = 'chat-msg-bubble';
        
        // Basic Markdown conversion for formatting AI response
        bubble.innerHTML = formatMarkdown(text);

        row.appendChild(bubble);
        container.appendChild(row);
    }

    /**
     * Show animated typing dots
     */
    function showTypingIndicator(container) {
        const row = document.createElement('div');
        row.className = 'chat-msg-row ai-row temp-typing-row';

        const bubble = document.createElement('div');
        bubble.className = 'chat-msg-bubble';

        const typingIndicator = document.createElement('div');
        typingIndicator.className = 'typing-dots';
        typingIndicator.innerHTML = '<span></span><span></span><span></span>';

        bubble.appendChild(typingIndicator);
        row.appendChild(bubble);
        container.appendChild(row);
        return row;
    }

    /**
     * Remove typing dots
     */
    function removeTypingIndicator(element) {
        if (element && element.parentNode) {
            element.parentNode.removeChild(element);
        }
        // Fallback cleanup if something gets stuck
        document.querySelectorAll('.temp-typing-row').forEach(row => {
            row.parentNode.removeChild(row);
        });
    }

    /**
     * Scroll wrapper to bottom smoothly
     */
    function scrollToBottom(container) {
        if (container) {
            setTimeout(() => {
                container.scrollTop = container.scrollHeight;
            }, 50);
        }
    }

    /**
     * Call API to clear chat history on server and clear storage
     */
    function clearChatHistory() {
        sessionStorage.removeItem('unilap_chat_history');
        
        // Optional: Call FastAPI to clear backend session memory
        fetch(baseContextPath + '/chat-ai', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                message: "/clear", // Or call specific clear endpoint if backend ChatServlet handles it
                session_id: sessionId
            })
        }).catch(err => console.log("Failed to notify backend clear session:", err));

        // Reload to default state
        loadChatHistory();
    }

    /**
     * Formats basic markdown elements like strong/bold and lists, and handles newline to br
     */
    function formatMarkdown(text) {
        if (!text) return '';
        
        // Escape HTML
        let escaped = text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');

        // Bold formatting: **text** or __text__
        escaped = escaped.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        escaped = escaped.replace(/__(.*?)__/g, '<strong>$1</strong>');

        // Italic formatting: *text* or _text_
        escaped = escaped.replace(/\*(.*?)\*/g, '<em>$1</em>');

        // Code formatting: `code`
        escaped = escaped.replace(/`(.*?)`/g, '<code>$1</code>');

        // Bullet points (lines starting with - or *)
        const lines = escaped.split('\n');
        let inList = false;
        let formatted = '';

        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line.startsWith('- ') || line.startsWith('* ')) {
                if (!inList) {
                    formatted += '<ul style="margin: 6px 0; padding-left: 20px;">';
                    inList = true;
                }
                formatted += '<li>' + line.substring(2) + '</li>';
            } else {
                if (inList) {
                    formatted += '</ul>';
                    inList = false;
                }
                formatted += line + (i < lines.length - 1 ? '<br>' : '');
            }
        }
        if (inList) {
            formatted += '</ul>';
        }

        return formatted;
    }
})();

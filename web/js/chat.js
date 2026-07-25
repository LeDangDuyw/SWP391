/**
 * UniLap Chatbot Core JavaScript
 * Handles floating widget popup, full-screen chat interface, 
 * session storage synchronization, and communication with ChatServlet (/chat-ai).
 */
//minhbq
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

    // Auto-redirection timers
    let redirectTimer = null;
    let redirectInterval = null;

    let isAiResponding = false;

    function toggleChatInputs(disabled) {
        if (widgetInput) {
            widgetInput.disabled = disabled;
            if (disabled) widgetInput.placeholder = "Vui lòng chờ AI phản hồi...";
            else widgetInput.placeholder = "Hỏi UniLap AI về sản phẩm...";
        }
        if (widgetSendBtn) {
            widgetSendBtn.disabled = disabled;
            widgetSendBtn.style.opacity = disabled ? '0.5' : '1';
            widgetSendBtn.style.pointerEvents = disabled ? 'none' : 'auto';
        }
        if (fullTextarea) {
            fullTextarea.disabled = disabled;
            if (disabled) fullTextarea.placeholder = "Vui lòng chờ AI phản hồi...";
            else fullTextarea.placeholder = "Nhập tin nhắn tại đây...";
        }
        if (fullSendBtn) {
            fullSendBtn.disabled = disabled;
            fullSendBtn.style.opacity = disabled ? '0.5' : '1';
            fullSendBtn.style.pointerEvents = disabled ? 'none' : 'auto';
        }
    }

    function refocusActiveInput(source) {
        if (source === 'widget' && widgetInput) {
            widgetInput.focus();
        } else if (source === 'full' && fullTextarea) {
            fullTextarea.focus();
        }
    }

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
            history.forEach(msg => appendToDOM(msg.sender, msg.text, widgetMessages, msg.products || []));
            scrollToBottom(widgetMessages);
        }

        if (fullMessagesInner) {
            fullMessagesInner.innerHTML = '';
            history.forEach(msg => appendToDOM(msg.sender, msg.text, fullMessagesInner, msg.products || []));
            scrollToBottom(fullMessagesContainer);
        }
    }

    /**
     * Handle validation and initiate sending flow
     */
    function handleSendMessage(text, source) {
        if (!text || isAiResponding) return;
        
        isAiResponding = true;
        toggleChatInputs(true);

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
                if (response.status === 401) {
                    alert("Bạn cần phải đăng nhập để trò chuyện với AI!");
                    window.location.href = baseContextPath + "/login";
                    throw new Error("Unauthorized");
                }
                if (response.status === 403) {
                    alert("Tài khoản của bạn đã bị chặn sử dụng tính năng chatbot do vi phạm điều khoản.");
                    throw new Error("Forbidden");
                }
                if (!response.ok) {
                    throw new Error("HTTP error " + response.status);
                }
                return response.json();
            })
            .then(data => {
                removeTypingIndicator(typingEl);
                const aiAnswer = data.answer || "Không nhận được phản hồi từ AI.";
                const products = data.products || [];
                saveAndAppendMessage('ai', aiAnswer, products);
                
                isAiResponding = false;
                toggleChatInputs(false);
                refocusActiveInput(source);

                if (products && products.length > 0) {
                    handleAutoRedirect(products);
                }
            })
            .catch(error => {
                if (error.message === "Unauthorized" || error.message === "Forbidden") {
                    removeTypingIndicator(typingEl);
                    isAiResponding = false;
                    toggleChatInputs(false);
                    return;
                }
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
                        if (res.status === 401 || res.status === 403) {
                            alert("Bạn không có quyền sử dụng chatbot!");
                            throw new Error("Unauthorized/Forbidden");
                        }
                        if (!res.ok) throw new Error("FastAPI directly returned HTTP error " + res.status);
                        return res.json();
                    })
                    .then(data => {
                        removeTypingIndicator(typingEl);
                        const aiAnswer = data.answer || "Không nhận được phản hồi từ AI.";
                        const products = data.products || [];
                        saveAndAppendMessage('ai', aiAnswer, products);
                        
                        isAiResponding = false;
                        toggleChatInputs(false);
                        refocusActiveInput(source);

                        if (products && products.length > 0) {
                            handleAutoRedirect(products);
                        }
                    })
                    .catch(fallbackError => {
                        console.error("Direct connection also failed:", fallbackError);
                        removeTypingIndicator(typingEl);
                        saveAndAppendMessage('ai', "Hệ thống AI hiện tại đang gặp sự cố kết nối. Vui lòng kiểm tra lại FastAPI Server tại localhost:8000!");
                        
                        isAiResponding = false;
                        toggleChatInputs(false);
                        refocusActiveInput(source);
                    });
            });
    }

    /**
     * Appends a message to the storage and prints it to the DOM (both widget & full page if present)
     */
    function saveAndAppendMessage(sender, text, products = []) {
        // Save to sessionStorage
        const historyJson = sessionStorage.getItem('unilap_chat_history');
        let history = historyJson ? JSON.parse(historyJson) : [];
        history.push({ sender, text, products });
        sessionStorage.setItem('unilap_chat_history', JSON.stringify(history));

        // Append to DOM dynamically
        if (widgetMessages) {
            appendToDOM(sender, text, widgetMessages, products);
            scrollToBottom(widgetMessages);
        }
        if (fullMessagesInner) {
            appendToDOM(sender, text, fullMessagesInner, products);
            scrollToBottom(fullMessagesContainer);
        }
    }

    /**
     * Render message to a target DOM container
     */
    function appendToDOM(sender, text, container, products = []) {
        const row = document.createElement('div');
        row.className = 'chat-msg-row ' + (sender === 'user' ? 'user-row' : 'ai-row');
        row.style.flexDirection = 'column';
        row.style.alignItems = sender === 'user' ? 'flex-end' : 'flex-start';

        const bubble = document.createElement('div');
        bubble.className = 'chat-msg-bubble';

        // Basic Markdown conversion for formatting AI response
        bubble.innerHTML = formatMarkdown(text);

        row.appendChild(bubble);
        container.appendChild(row);

        // Hiển thị các sản phẩm được gợi ý dạng thẻ ngang bên dưới bong bóng chat
        if (sender !== 'user' && products && products.length > 0) {
            const recommendationsWrapper = document.createElement('div');
            recommendationsWrapper.className = 'chat-recommendations-wrapper';

            let html = '<div class="chat-recommendations-title"><i class="fas fa-laptop"></i> Gợi ý cho bạn:</div>';
            html += '<div class="chat-recommendations-list">';

            products.forEach(p => {
                const name = p.ProductName || p.product_name || "Sản phẩm";
                const variant = p.VariantName || p.variant_name || "";
                const displayName = variant ? `${name} - ${variant}` : name;

                const originalPrice = p.OriginalPrice || p.Price || 0;
                const finalPrice = p.FinalPrice !== undefined && p.FinalPrice !== null ? p.FinalPrice : originalPrice;
                const priceFormatted = formatMoneyJS(finalPrice);

                const productId = p.ProductID || p.product_id;
                const imgUrl = p.ImageURL || "";
                const imgSrc = imgUrl ? `${baseContextPath}/images/${imgUrl}` : `${baseContextPath}/images/default-laptop.jpg`;

                html += `
                    <div class="chat-product-card" onclick="window.location.href='${baseContextPath}/ProductDetailServlet?id=${productId}'">
                        <img class="chat-product-img" src="${imgSrc}" onerror="this.src='https://via.placeholder.com/150x110?text=UniLap'" />
                        <div class="chat-product-info">
                            <div class="chat-product-name" title="${displayName}">${displayName}</div>
                            <div class="chat-product-price-block">
                                <span class="chat-product-price">${priceFormatted}</span>
                                ${isProductOnSaleJS(p) ? `<span class="chat-product-original-price">${formatMoneyJS(originalPrice)}</span>` : ''}
                            </div>
                        </div>
                    </div>
                `;
            });

            html += '</div>';
            recommendationsWrapper.innerHTML = html;
            row.appendChild(recommendationsWrapper);
        }

        // Tự động chèn UI đánh giá 5 sao cho tin nhắn AI (trừ câu chào mừng và câu lỗi hệ thống)
        if (sender === 'ai' && !text.includes("Hệ thống AI hiện tại đang gặp sự cố") && !text.includes("Xin chào! Mình là trợ lý ảo")) {
            const feedbackWrapper = document.createElement('div');
            feedbackWrapper.className = 'chat-feedback-wrapper';
            feedbackWrapper.style.marginTop = '6px';
            feedbackWrapper.style.padding = '0 12px';
            feedbackWrapper.style.width = '100%';
            feedbackWrapper.style.boxSizing = 'border-box';

            const starContainer = document.createElement('div');
            starContainer.className = 'chatbot-stars-container';
            starContainer.style.display = 'flex';
            starContainer.style.alignItems = 'center';
            starContainer.style.gap = '6px';

            let html = '<span style="font-size:11px; color:#64748b;">Đánh giá câu trả lời:</span> ';
            html += '<div class="star-rating-stars" style="display:flex; gap:4px; cursor:pointer;">';
            for (let i = 1; i <= 5; i++) {
                html += `<span class="star-item" data-val="${i}" style="color:#cbd5e1; font-size:18px; line-height:1; transition: color 0.15s;">★</span>`;
            }
            html += '</div>';
            starContainer.innerHTML = html;
            feedbackWrapper.appendChild(starContainer);

            // Tạo khung nhập comment (ẩn theo mặc định)
            const commentBox = document.createElement('div');
            commentBox.className = 'chatbot-comment-box';
            commentBox.style.display = 'none';
            commentBox.style.marginTop = '6px';
            commentBox.style.gap = '6px';
            commentBox.style.alignItems = 'center';
            commentBox.innerHTML = `
                <input type="text" class="chatbot-comment-input" placeholder="Lý do bạn đánh giá dưới 5 sao?..." style="flex:1; padding:6px 10px; border:1px solid #cbd5e1; border-radius:4px; font-size:12px; outline:none; font-family:'Inter', sans-serif;" />
                <button class="chatbot-comment-submit" style="padding:6px 12px; background:#3b82f6; color:white; border:none; border-radius:4px; font-size:12px; cursor:pointer; font-weight:500; font-family:'Inter', sans-serif;">Gửi</button>
            `;
            feedbackWrapper.appendChild(commentBox);
            row.appendChild(feedbackWrapper);

            // Xử lý sự kiện hover và click trên các ngôi sao
            const stars = starContainer.querySelectorAll('.star-item');
            const commentInput = commentBox.querySelector('.chatbot-comment-input');
            const commentSubmit = commentBox.querySelector('.chatbot-comment-submit');
            let selectedRating = 0;

            stars.forEach(star => {
                // Di chuột hover
                star.addEventListener('mouseover', function () {
                    const val = parseInt(this.getAttribute('data-val'));
                    stars.forEach((s, idx) => {
                        s.style.color = (idx < val) ? '#f59e0b' : '#cbd5e1';
                    });
                });

                // Di chuột ra ngoài
                star.addEventListener('mouseout', function () {
                    stars.forEach((s, idx) => {
                        s.style.color = (idx < selectedRating) ? '#f59e0b' : '#cbd5e1';
                    });
                });

                // Click chọn sao
                star.addEventListener('click', function () {
                    selectedRating = parseInt(this.getAttribute('data-val'));
                    stars.forEach((s, idx) => {
                        s.style.color = (idx < selectedRating) ? '#f59e0b' : '#cbd5e1';
                    });

                    if (selectedRating < 5) {
                        // Dưới 5 sao: Mở ô nhập ý kiến đóng góp
                        commentBox.style.display = 'flex';
                        commentInput.focus();
                    } else {
                        // Đủ 5 sao: Tự động gửi đánh giá ngay lập tức mà không hiện ô bình luận
                        commentBox.style.display = 'none';
                        sendFeedbackToBackend(5, "", text, feedbackWrapper);
                    }
                });
            });

            // Click nút gửi bình luận cho trường hợp đánh giá < 5 sao
            commentSubmit.addEventListener('click', function () {
                const commentText = commentInput.value.trim();
                if (!commentText) {
                    alert('Vui lòng điền lý do đánh giá thấp để giúp shop cải thiện trợ lý ảo nhé!');
                    return;
                }
                sendFeedbackToBackend(selectedRating, commentText, text, feedbackWrapper);
            });
        }
    }

    /**
     * Gửi dữ liệu đánh giá chất lượng chatbot về Java Servlet
     */
    function sendFeedbackToBackend(rating, comment, aiAnswer, wrapperEl) {
        const historyJson = sessionStorage.getItem('unilap_chat_history');
        let history = historyJson ? JSON.parse(historyJson) : [];

        // Tìm câu hỏi gần nhất của người dùng
        let userQuestion = "";
        for (let i = history.length - 1; i >= 0; i--) {
            if (history[i].sender === 'user') {
                userQuestion = history[i].text;
                break;
            }
        }

        fetch(baseContextPath + '/chatbot-feedback', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({
                rating: rating,
                comment: comment,
                ai_question: userQuestion,
                ai_answer: aiAnswer,
                session_id: sessionId
            })
        })
            .then(res => {
                if (res.status === 401) {
                    alert('Phiên làm việc hết hạn. Bạn cần đăng nhập để thực hiện đánh giá!');
                    window.location.href = baseContextPath + '/login';
                    throw new Error("Unauthorized");
                }
                if (!res.ok) {
                    throw new Error("Server error " + res.status);
                }
                return res.json();
            })
            .then(data => {
                if (data && data.status === 'success') {
                    wrapperEl.innerHTML = '<span style="font-size:11px; color:#10b981; font-weight:600; padding:4px 0; display:inline-flex; align-items:center; gap:4px;"><i class="fas fa-check-circle"></i> Cảm ơn bạn đã gửi đánh giá!</span>';
                }
            })
            .catch(err => {
                console.error("Gửi đánh giá lỗi:", err);
            });
    }

    /**
     * Tự động điều hướng đến trang chi tiết sản phẩm đắt nhất
     */
    function handleAutoRedirect(products) {
        if (redirectTimer) clearTimeout(redirectTimer);
        if (redirectInterval) clearInterval(redirectInterval);

        let highestPriceProduct = null;
        let maxPrice = -1;

        products.forEach(p => {
            const originalPrice = p.OriginalPrice || p.Price || 0;
            const finalPrice = p.FinalPrice !== undefined && p.FinalPrice !== null ? p.FinalPrice : originalPrice;
            const price = parseFloat(finalPrice) || 0;
            if (price > maxPrice) {
                maxPrice = price;
                highestPriceProduct = p;
            }
        });

        if (!highestPriceProduct) return;

        const productId = highestPriceProduct.ProductID || highestPriceProduct.product_id;
        const productName = highestPriceProduct.ProductName || highestPriceProduct.product_name || "Sản phẩm";

        showRedirectNotification(productId, productName);
    }

    function showRedirectNotification(productId, productName) {
        const targetContainer = fullMessagesInner || widgetMessages;
        if (!targetContainer) return;

        // Clear existing redirect alerts if any
        document.querySelectorAll('.chat-redirect-alert').forEach(el => el.remove());

        const redirectAlert = document.createElement('div');
        redirectAlert.className = 'chat-redirect-alert';

        let secondsLeft = 3;
        redirectAlert.innerHTML = `
            <div class="chat-redirect-content">
                <i class="fas fa-spinner fa-spin"></i>
                <span>Tự động chuyển đến <strong>${productName}</strong> sau <span class="countdown-sec">${secondsLeft}</span>s...</span>
            </div>
            <button class="chat-redirect-cancel-btn">Hủy</button>
        `;

        targetContainer.appendChild(redirectAlert);
        scrollToBottom(fullMessagesContainer || widgetMessages);

        const countdownEl = redirectAlert.querySelector('.countdown-sec');
        const cancelBtn = redirectAlert.querySelector('.chat-redirect-cancel-btn');

        redirectInterval = setInterval(() => {
            secondsLeft--;
            if (countdownEl) {
                countdownEl.textContent = secondsLeft;
            }
            if (secondsLeft <= 0) {
                clearInterval(redirectInterval);
            }
        }, 1000);

        redirectTimer = setTimeout(() => {
            clearInterval(redirectInterval);
            window.location.href = baseContextPath + "/ProductDetailServlet?id=" + productId;
        }, 3000);

        cancelBtn.addEventListener('click', function () {
            clearTimeout(redirectTimer);
            clearInterval(redirectInterval);
            redirectTimer = null;
            redirectInterval = null;
            redirectAlert.innerHTML = `
                <div class="chat-redirect-content">
                    <i class="fas fa-info-circle" style="color: var(--chat-primary);"></i>
                    <span>Đã hủy tự động chuyển hướng.</span>
                </div>
            `;
            setTimeout(() => {
                redirectAlert.remove();
            }, 2000);
        });
    }

    // Helper functions for format and check sale status
    function formatMoneyJS(value) {
        try {
            if (value === null || value === undefined) return "Liên hệ";
            return parseFloat(value).toLocaleString('vi-VN') + " đ";
        } catch (e) {
            return value;
        }
    }

    function isProductOnSaleJS(p) {
        const is_on_sale = p.IsOnSale || p.is_on_sale;
        if (is_on_sale === 1 || is_on_sale === true || is_on_sale === '1' || is_on_sale === 'true') {
            return true;
        }
        const originalPrice = p.OriginalPrice || p.Price || 0;
        const finalPrice = p.FinalPrice !== undefined && p.FinalPrice !== null ? p.FinalPrice : originalPrice;
        return parseFloat(finalPrice) < parseFloat(originalPrice);
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
    /**
     * CHỨC NĂNG: Xóa lịch sử trò chuyện trong Session Storage và gửi tín hiệu làm sạch bộ nhớ lên Server.
     * LIÊN KẾT:
     * - Endpoint: POST /chat-ai (ChatServlet)
     * - Storage: sessionStorage 'unilap_chat_history'
     */
    function clearChatHistory() {
        sessionStorage.removeItem('unilap_chat_history');

        fetch(baseContextPath + '/chat-ai', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                message: "/clear",
                session_id: sessionId
            })
        }).catch(err => console.log("Failed to notify backend clear session:", err));

        loadChatHistory();
    }

    /**
     * CHỨC NĂNG: Gửi tin nhắn câu hỏi từ người dùng sang ChatServlet (/chat-ai) hoặc FastAPI trực tiếp.
     * LIÊN KẾT:
     * - Java Servlet: controller.ChatServlet (/chat-ai) -> FastAPI AI Server (http://127.0.0.1:8000/chat)
     * - Redirect Link: controller.ProductDetailServlet (?id=redirect_product_id) khi AI giới thiệu sản phẩm.
     * 
     * @param {string} userInput Tin nhắn câu hỏi của người dùng
     */
    function sendMessageToChatbot(userInput) {
        // 1. Hiển thị tin nhắn người dùng lên khung chat
        appendMessage("user", userInput);
        // 2. Gửi request tới FastAPI server hoặc ChatServlet proxy
        fetch(apiEndpoint, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                message: userInput,
                session_id: sessionId
            })
        })
            .then(response => response.json())
            .then(data => {
                // 3. Hiển thị câu trả lời của Chatbot lên khung chat
                appendMessage("assistant", data.answer || data.response);
                // 4. Nếu backend yêu cầu chuyển hướng sang sản phẩm chi tiết
                if (data.redirect_product_id) {
                    setTimeout(() => {
                        window.location.href = baseContextPath + "/ProductDetailServlet?id=" + data.redirect_product_id;
                    }, 2000);
                }
            })
            .catch(error => {
                console.error("Lỗi kết nối chatbot:", error);
            });
    }

    /**
     * CHỨC NĂNG: Định dạng cú pháp Markdown đơn giản (in đậm, in nghiêng, thẻ danh sách ul/li, dòng mới br).
     * LIÊN KẾT: Hiển thị nội dung tin nhắn AI trong ô tin nhắn chat (appendMessage).
     * 
     * @param {string} text Văn bản phản hồi thô từ AI
     * @returns {string} Văn bản đã biên dịch sang HTML safe
     */
    function formatMarkdown(text) {
        if (!text) return '';

        let escaped = text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');

        escaped = escaped.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        escaped = escaped.replace(/__(.*?)__/g, '<strong>$1</strong>');
        escaped = escaped.replace(/\*(.*?)\*/g, '<em>$1</em>');
        escaped = escaped.replace(/`(.*?)`/g, '<code>$1</code>');

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

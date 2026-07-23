// UniLap Cart AJAX Handler
document.addEventListener('DOMContentLoaded', function () {
    const contextPath = getContextPath();

    // Helper to get context path from scripts or urls
    function getContextPath() {
        return window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    }

    // Dynamic style for removing animation
    const style = document.createElement('style');
    style.innerHTML = `
        .cart-card {
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .cart-card.removing {
            opacity: 0;
            transform: scale(0.92) translateY(-20px);
            margin-bottom: -120px;
            pointer-events: none;
        }
        .coupon-message.success {
            color: #16a34a;
            background: #f0fdf4;
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #bbf7d0;
        }
        .coupon-message.error {
            color: #ef4444;
            background: #fef2f2;
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #fecaca;
        }
    `;
    document.head.appendChild(style);

    // --- 1. QUANTITY CHANGING ---
    const qtyForms = document.querySelectorAll('.qty-form');
    qtyForms.forEach(form => {
        const variantId = form.dataset.variantId;
        const minusBtn = form.querySelector('.btn-qty-minus');
        const plusBtn = form.querySelector('.btn-qty-plus');
        const qtyVal = form.querySelector('.qty-value');

        minusBtn.addEventListener('click', function () {
            let current = parseInt(qtyVal.textContent, 10);
            if (current > 1) {
                updateQuantity(variantId, current - 1);
            }
        });

        plusBtn.addEventListener('click', function () {
            let current = parseInt(qtyVal.textContent, 10);
            updateQuantity(variantId, current + 1);
        });
    });

    function updateQuantity(variantId, targetQty) {
        const formData = new URLSearchParams();
        formData.append('action', 'update');
        formData.append('variantId', variantId);
        formData.append('quantity', targetQty);
        formData.append('ajax', 'true');

        fetch(contextPath + '/CartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // Update quantity span
                const qtyVal = document.querySelector(`.qty-value[data-variant-id="${variantId}"]`);
                if (qtyVal) qtyVal.textContent = data.currentQty;

                // Update item subtotal
                const priceEl = document.querySelector(`.cart-card-price[data-variant-id="${variantId}"]`);
                if (priceEl) {
                    priceEl.textContent = data.itemSubtotal + '₫';
                    
                    // Update crossed-out original price if it exists
                    const card = priceEl.closest('.cart-card');
                    const origEl = card ? card.querySelector(`.cart-card-original-price[data-variant-id="${variantId}"]`) : null;
                    if (origEl && origEl.dataset.originalUnitPrice) {
                        const unitOrig = parseFloat(origEl.dataset.originalUnitPrice);
                        const newOrigSub = unitOrig * data.currentQty;
                        origEl.textContent = formatMoney(newOrigSub) + '₫';
                    }
                }

                // Update minus & plus buttons state
                const form = document.querySelector(`.qty-form[data-variant-id="${variantId}"]`);
                if (form) {
                    const minusBtn = form.querySelector('.btn-qty-minus');
                    const plusBtn = form.querySelector('.btn-qty-plus');
                    if (minusBtn) minusBtn.disabled = data.currentQty <= 1;
                    if (plusBtn) plusBtn.disabled = data.currentQty >= data.availableQty;
                }

                // Update order summary
                updateSummary(data);
            }
        })
        .catch(err => console.error("Error updating quantity:", err));
    }

    // --- 2. ITEM REMOVAL ---
    const removeForms = document.querySelectorAll('.remove-item-form');
    removeForms.forEach(form => {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            const variantId = this.querySelector('input[name="variantId"]').value;
            removeItem(variantId, this);
        });
    });

    function removeItem(variantId, formElement) {
        const card = formElement.closest('.cart-card');
        
        const formData = new URLSearchParams();
        formData.append('action', 'remove');
        formData.append('variantId', variantId);
        formData.append('ajax', 'true');

        fetch(contextPath + '/CartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // Add fade-out classes
                if (card) {
                    card.classList.add('removing');
                    setTimeout(() => {
                        card.remove();
                        // If cart is empty, show empty UI
                        if (data.cartSize === 0) {
                            toggleEmptyCart(true);
                        }
                    }, 350);
                }

                // Update order summary
                updateSummary(data);
            }
        })
        .catch(err => console.error("Error removing item:", err));
    }

    // --- 3. PROMOTIONS DRAWER MODAL CONTROL ---
    const promoModal = document.getElementById('promotions-modal');
    const btnOpenPromo = document.getElementById('btn-open-promotions-modal');
    const btnClosePromo = document.getElementById('btn-close-promotions-modal');
    const promoOverlay = document.getElementById('promo-modal-overlay');
    const btnConfirmPromo = document.getElementById('btn-confirm-promotions');

    if (btnOpenPromo && promoModal) {
        btnOpenPromo.addEventListener('click', function() {
            promoModal.classList.add('open');
        });
    }

    function closePromoModal() {
        if (promoModal) {
            promoModal.classList.remove('open');
        }
    }

    if (btnClosePromo) btnClosePromo.addEventListener('click', closePromoModal);
    if (promoOverlay) promoOverlay.addEventListener('click', closePromoModal);
    if (btnConfirmPromo) btnConfirmPromo.addEventListener('click', closePromoModal);

    // --- 4. APPLYING COUPON IN MODAL ---
    const btnApplyCoupon = document.getElementById('btn-modal-apply-coupon');
    const couponInput = document.getElementById('modal-coupon-input');
    const couponMsg = document.getElementById('modal-coupon-msg');

    if (btnApplyCoupon && couponInput) {
        btnApplyCoupon.addEventListener('click', applyCoupon);
        couponInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyCoupon();
            }
        });
    }

    function applyCoupon() {
        const code = couponInput.value.trim();
        if (!code) {
            showCouponMessage("Vui lòng nhập mã giảm giá.", false);
            return;
        }
        applyCouponWithCode(code);
    }

    function applyCouponWithCode(code) {
        const formData = new URLSearchParams();
        formData.append('action', 'coupon');
        formData.append('couponCode', code);
        formData.append('ajax', 'true');

        fetch(contextPath + '/CartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            showCouponMessage(
                data.couponMessage || data.message || "Không phản hồi từ máy chủ.", 
                data.couponSuccess !== undefined ? data.couponSuccess : (data.successCoupon !== undefined ? data.successCoupon : data.success)
            );
            updateSummary(data);
        })
        .catch(err => console.error("Error applying coupon:", err));
    }

    function showCouponMessage(text, isSuccess) {
        if (!couponMsg) return;
        couponMsg.textContent = text;
        couponMsg.className = "coupon-message " + (isSuccess ? "success" : "error");
        couponMsg.style.display = 'block';
    }

    // --- 5. SUMMARY UPDATES & DOM SYNC ---
    function updateSummary(data) {
        // Update total items count in summary
        const summaryItemsCount = document.getElementById('summary-items-count');
        if (summaryItemsCount) summaryItemsCount.textContent = data.totalItems;

        const cartItemCount = document.getElementById('cart-item-count');
        if (cartItemCount) cartItemCount.textContent = data.cartSize;

        // Update subtotal
        const subtotalEl = document.getElementById('summary-subtotal');
        if (subtotalEl) subtotalEl.textContent = data.total + '₫';

        // Update discount row
        const discountRow = document.getElementById('discount-row');
        const discountEl = document.getElementById('summary-discount');
        const discountVal = parseFloat(data.discount.replace(/,/g, ''));
        
        if (discountRow && discountEl) {
            if (discountVal > 0) {
                discountEl.textContent = '- ' + data.discount + '₫';
                discountRow.style.display = 'flex';
            } else {
                discountRow.style.display = 'none';
            }
        }

        // Update final total (Giỏ hàng chính)
        const totalEl = document.getElementById('summary-total');
        if (totalEl) totalEl.textContent = data.finalTotal + '₫';

        // Update final total (Modal footer)
        const modalTotalVal = document.getElementById('modal-total-value');
        if (modalTotalVal) modalTotalVal.textContent = data.finalTotal + '₫';

        // Update selected promo texts (Giỏ hàng chính và Modal footer)
        const hasCoupon = data.couponCode && data.couponCode.trim() !== "";
        const triggerTitle = document.getElementById('summary-promo-selected-title');
        if (triggerTitle) {
            triggerTitle.textContent = hasCoupon ? 'Đã chọn 1 khuyến mãi và ưu đãi' : 'Chọn khuyến mãi và ưu đãi';
        }
        
        const modalSelectedCountText = document.getElementById('modal-selected-count-text');
        if (modalSelectedCountText) {
            modalSelectedCountText.textContent = hasCoupon ? 'Đã chọn 1 khuyến mãi và ưu đãi' : 'Đã chọn 0 khuyến mãi và ưu đãi';
        }

        // Update header badge
        const badge = document.getElementById('header-cart-badge');
        if (badge) {
            if (data.cartSize > 0) {
                badge.textContent = data.cartSize;
                badge.style.display = 'flex';
            } else {
                badge.style.display = 'none';
            }
        }

        // Tự động cập nhật lại giá trị hiển thị trong ô nhập coupon của modal
        if (couponInput && data.couponCode !== undefined) {
            couponInput.value = data.couponCode;
        }

        // Vẽ lại danh sách Voucher cá nhân của User một cách sống động
        const vouchersList = document.getElementById('vouchers-list');
        if (vouchersList && data.userVouchers) {
            renderVouchersList(vouchersList, data.userVouchers, data.couponCode);
        }
    }

    // Lắng nghe click chọn Voucher từ danh sách (Event Delegation)
    const vouchersListEl = document.getElementById('vouchers-list');
    if (vouchersListEl) {
        vouchersListEl.addEventListener('click', function (e) {
            // Nhấp chọn qua container hoặc icon dấu cộng
            const btn = e.target.closest('.btn-use-voucher-indicator');
            const activeIndicator = e.target.closest('.promo-select-indicator');
            const item = e.target.closest('.voucher-item');
            
            if (btn) {
                const code = btn.dataset.code;
                applyCouponWithCode(code);
            } else if (activeIndicator) {
                applyCouponWithCode(""); // Bỏ chọn voucher
            } else if (item) {
                if (item.classList.contains('active')) {
                    // Nếu bấm lại vào voucher đang kích hoạt thì bỏ chọn
                    applyCouponWithCode("");
                } else if (!item.classList.contains('used') && !item.classList.contains('unavailable')) {
                    const code = item.dataset.code;
                    applyCouponWithCode(code);
                }
            }
        });
    }

    function renderVouchersList(container, vouchers, activeCode) {
        if (!vouchers || vouchers.length === 0) {
            container.innerHTML = `<p style="font-size: 12.5px; color: #64748b; font-style: italic; text-align: center; margin: 15px 0;">Bạn không sở hữu mã giảm giá nào.</p>`;
            return;
        }

        let html = '';
        vouchers.forEach(v => {
            const isActive = v.voucherCode === activeCode;
            const isAvail = v.isAvailable || v.available;
            const isUsed = v.isUsed || v.used;
            const itemClass = `voucher-item ${isAvail ? 'available' : 'unavailable'} ${isUsed ? 'used' : ''} ${isActive ? 'active' : ''}`;
            
            const discValFormatted = formatMoney(v.discountValue);
            const minValFormatted = formatMoney(v.minOrderValue);

             let rightContent = '';
             if (isActive) {
                 rightContent = `
                     <div class="promo-select-indicator active">
                         <i class="fas fa-check-circle" style="color: #ef4444; font-size: 22px;"></i>
                     </div>
                 `;
             } else if (isUsed || !isAvail) {
                 rightContent = ''; // Không cho chọn
             } else {
                 rightContent = `
                     <button type="button" class="btn-use-voucher-indicator" data-code="${v.voucherCode}" style="background: none; border: none; cursor: pointer; padding: 0;">
                         <i class="fas fa-plus-circle" style="color: #94a3b8; font-size: 20px; transition: color 0.2s;"></i>
                     </button>
                 `;
             }

             const statusText = isAvail ? 'Đủ điều kiện áp dụng' : (v.statusMessage || 'Không đủ điều kiện áp dụng');
             const statusColor = isAvail ? '#16a34a' : '#ef4444';

             html += `
                 <div class="${itemClass}" data-code="${v.voucherCode}">
                     <div class="voucher-left">
                          <div class="v-code">${v.voucherCode}</div>
                          <div class="v-discount">
                              Giảm ${discValFormatted}${v.discountValue <= 100 ? '%' : '₫'}
                          </div>
                          <div class="v-min">Đơn tối thiểu: ${minValFormatted}₫</div>
                          ${v.description ? `<div class="v-desc">${v.description}</div>` : ''}
                          <div class="v-status-msg">
                              ${statusText}
                          </div>
                     </div>
                     <div class="voucher-right">
                         ${rightContent}
                     </div>
                 </div>
             `;
        });
        container.innerHTML = html;
    }

    function formatMoney(num) {
        if (num === undefined || num === null) return "0";
        let str = typeof num === 'string' ? num : num.toString();
        const dotIndex = str.indexOf('.');
        if (dotIndex !== -1) {
            str = str.substring(0, dotIndex);
        }
        str = str.replace(/[^0-9]/g, '');
        if (!str) return "0";
        return parseInt(str, 10).toLocaleString('vi-VN');
    }

    function toggleEmptyCart(isEmpty) {
        const emptyBlock = document.getElementById('cart-empty-block');
        const contentBlock = document.getElementById('cart-content-block');
        const cartDesc = document.getElementById('cart-desc');
        const emptyDesc = document.getElementById('cart-empty-desc');

        if (isEmpty) {
            if (emptyBlock) emptyBlock.style.display = 'block';
            if (contentBlock) contentBlock.style.display = 'none';
            if (cartDesc) cartDesc.style.display = 'none';
            if (emptyDesc) emptyDesc.style.display = 'block';
        } else {
            if (emptyBlock) emptyBlock.style.display = 'none';
            if (contentBlock) contentBlock.style.display = 'grid';
            if (cartDesc) cartDesc.style.display = 'block';
            if (emptyDesc) emptyDesc.style.display = 'none';
        }
    }
});

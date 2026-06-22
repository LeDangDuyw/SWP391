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
                if (priceEl) priceEl.textContent = data.itemSubtotal + '₫';

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

    // --- 3. APPLYING COUPON ---
    const btnApplyCoupon = document.getElementById('btn-apply-coupon');
    const couponInput = document.getElementById('coupon-input');
    const couponMsg = document.getElementById('coupon-msg');

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
            showCouponMessage(data.message, data.success);
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

    // --- 4. SUMMARY UPDATES ---
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

        // Update final total
        const totalEl = document.getElementById('summary-total');
        if (totalEl) totalEl.textContent = data.finalTotal + '₫';

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

/* Premium JS for Product Detail Page */
document.addEventListener('DOMContentLoaded', function () {
    // 1. Thumbnail Gallery Swapping
    const mainImg = document.getElementById('mainProductImg');
    const thumbs = document.querySelectorAll('.pd-thumb-wrap');
    
    thumbs.forEach(thumb => {
        thumb.addEventListener('click', function () {
            thumbs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            const thumbImg = this.querySelector('img');
            mainImg.src = thumbImg.src;
            mainImg.style.filter = thumbImg.style.filter || 'none';
        });
    });

    // 2. Variant Selector Options
    const priceEl = document.getElementById('pdPrice');
    const stockEl = document.getElementById('pdStock');
    const qtyInput = document.getElementById('qtyInput');
    const variantIdInput = document.getElementById('selectedVariantId');
    const variantBtns = document.querySelectorAll('.pd-variant-btn');

    variantBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            variantBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            // Update price
            if (priceEl && this.dataset.price) {
                priceEl.textContent = this.dataset.price;
            }

            // Update hidden variant ID
            if (variantIdInput && this.dataset.variantId) {
                variantIdInput.value = this.dataset.variantId;
            }

            // Update stock info
            const stock = parseInt(this.dataset.stock, 10);
            if (stockEl) {
                if (stock > 0) {
                    stockEl.className = 'pd-stock in-stock';
                    stockEl.innerHTML = '<i class="fas fa-check-circle"></i> Còn hàng (' + stock + ')';
                    // Re-enable quantity selector and buttons if disabled
                    enablePurchase(true);
                } else {
                    stockEl.className = 'pd-stock out-of-stock';
                    stockEl.innerHTML = '<i class="fas fa-times-circle"></i> Hết hàng';
                    enablePurchase(false);
                }
            }

            // Reset quantity to 1
            if (qtyInput) {
                qtyInput.value = 1;
            }
        });
    });

    function enablePurchase(enable) {
        const cartBtn = document.querySelector('.pd-add-cart');
        const buyBtn = document.querySelector('.pd-btn-buy');
        const minusBtn = document.getElementById('qtyMinus');
        const plusBtn = document.getElementById('qtyPlus');

        if (cartBtn) cartBtn.disabled = !enable;
        if (buyBtn) buyBtn.disabled = !enable;
        if (minusBtn) minusBtn.disabled = !enable;
        if (plusBtn) plusBtn.disabled = !enable;
    }

    // 3. Quantity Controls
    const qtyMinus = document.getElementById('qtyMinus');
    const qtyPlus = document.getElementById('qtyPlus');

    if (qtyMinus && qtyPlus && qtyInput) {
        qtyMinus.addEventListener('click', function () {
            let v = parseInt(qtyInput.value, 10);
            if (v > 1) {
                qtyInput.value = v - 1;
            }
        });

        qtyPlus.addEventListener('click', function () {
            let v = parseInt(qtyInput.value, 10);
            // Get stock limit from active variant
            const activeBtn = document.querySelector('.pd-variant-btn.active');
            const stockLimit = activeBtn ? parseInt(activeBtn.dataset.stock, 10) : 999;
            
            if (v < stockLimit) {
                qtyInput.value = v + 1;
            } else {
                alert('Vượt quá số lượng sản phẩm có sẵn trong kho!');
            }
        });
    }

    // 4. Tab Navigation Toggling
    const tabTriggers = document.querySelectorAll('.pd-tab-trigger');
    const tabContents = document.querySelectorAll('.pd-tab-content');

    tabTriggers.forEach(trigger => {
        trigger.addEventListener('click', function () {
            const targetId = this.dataset.target;
            
            tabTriggers.forEach(t => t.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));
            
            this.classList.add('active');
            const targetContent = document.getElementById(targetId);
            if (targetContent) {
                targetContent.classList.add('active');
            }
        });
    });

    // 5. Header Dropdown Menu for User (Trigger logic matching product_list.js)
    const userTrigger = document.querySelector('.user-menu-trigger');
    if (userTrigger) {
        userTrigger.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const dropdown = this.nextElementSibling;
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        });
        
        document.addEventListener('click', function () {
            const dropdowns = document.querySelectorAll('.user-menu-dropdown-content');
            dropdowns.forEach(d => {
                d.style.display = 'none';
            });
        });
    }

    // 6. Handle Add to Cart & Buy Now submits
    const addCartForm = document.getElementById('addCartForm');
    const formQty = document.getElementById('formQty');
    const btnBuyNow = document.getElementById('btnBuyNow');

    if (addCartForm && formQty && qtyInput) {
        addCartForm.addEventListener('submit', function (e) {
            formQty.value = qtyInput.value;
        });
    }

    if (btnBuyNow && addCartForm && qtyInput && formQty) {
        btnBuyNow.addEventListener('click', function () {
            formQty.value = qtyInput.value;
            addCartForm.submit();
        });
    }
});

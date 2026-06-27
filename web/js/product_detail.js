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

            // Update dynamic specifications based on variant name
            const variantName = this.textContent.trim();
            if (variantName) {
                const parts = variantName.split(/\s*\/\s*/);
                
                let cpu = '';
                let ram = '';
                let ssd = '';
                let gpu = '';
                let connectivity = '';
                let switchType = '';
                const gbParts = [];

                parts.forEach(part => {
                    const lowerPart = part.toLowerCase();
                    if (lowerPart.includes('intel') || lowerPart.includes('core') || lowerPart.includes('ryzen') || 
                        lowerPart.includes('amd') || lowerPart.includes('ultra') || lowerPart.includes('snapdragon') ||
                        lowerPart.startsWith('i3') || lowerPart.startsWith('i5') || lowerPart.startsWith('i7') || 
                        lowerPart.startsWith('i9') || lowerPart.startsWith('m1') || lowerPart.startsWith('m2') || 
                        lowerPart.startsWith('m3') || lowerPart.startsWith('m4') || lowerPart.startsWith('m5')) {
                        cpu = part;
                    } else if (lowerPart.includes('rtx') || lowerPart.includes('gtx') || lowerPart.includes('radeon') || 
                               lowerPart.includes('graphics') || lowerPart.includes('iris') || lowerPart.includes('geforce') ||
                               lowerPart.includes('rx ')) {
                        gpu = part;
                    } else if (lowerPart.includes('switch')) {
                        switchType = part;
                    } else if (lowerPart.includes('wired') || lowerPart.includes('wireless') || 
                               lowerPart.includes('bluetooth') || lowerPart.includes('usb')) {
                        connectivity = part;
                    } else if (lowerPart.includes('gb') || lowerPart.includes('tb')) {
                        gbParts.push(part);
                    }
                });

                if (gbParts.length > 0) {
                    if (gbParts.length === 1) {
                        const val = parseInt(gbParts[0], 10);
                        if (val <= 64) {
                            ram = gbParts[0];
                        } else {
                            ssd = gbParts[0];
                        }
                    } else if (gbParts.length >= 2) {
                        const parsed = gbParts.map(p => {
                            let size = parseFloat(p);
                            if (p.toLowerCase().includes('tb')) {
                                size *= 1024;
                            }
                            return { text: p, size: size };
                        });
                        parsed.sort((a, b) => a.size - b.size);
                        ram = parsed[0].text;
                        ssd = parsed[1].text;
                    }
                }

                if (!cpu && parts.length > 0) {
                    const usedParts = [ram, ssd, connectivity, switchType, gpu];
                    const unused = parts.filter(p => !usedParts.includes(p));
                    if (unused.length > 0) {
                        cpu = unused[0];
                    }
                }

                // Quick spec elements at the top
                const cpuEl = document.getElementById('specCpu');
                const ramEl = document.getElementById('specRam');
                const ssdEl = document.getElementById('specSsd');
                const connEl = document.getElementById('specConnectivity');
                const switchEl = document.getElementById('specSwitchType');

                // Specs table elements in the tab
                const tblCpuEl = document.getElementById('tblSpecCpu');
                const tblRamEl = document.getElementById('tblSpecRam');
                const tblSsdEl = document.getElementById('tblSpecSsd');
                const tblGpuEl = document.getElementById('tblSpecGpu');
                const tblConnEl = document.getElementById('tblSpecConnectivity');
                const tblSwitchEl = document.getElementById('tblSpecSwitchType');

                if (cpuEl && cpu) {
                    cpuEl.textContent = cpu;
                    cpuEl.title = cpu;
                }
                if (tblCpuEl && cpu) {
                    tblCpuEl.textContent = cpu;
                }

                if (ramEl && ram) {
                    ramEl.textContent = ram;
                    ramEl.title = ram;
                }
                if (tblRamEl && ram) {
                    tblRamEl.textContent = ram;
                }

                if (ssdEl && ssd) {
                    ssdEl.textContent = ssd;
                    ssdEl.title = ssd;
                }
                if (tblSsdEl && ssd) {
                    tblSsdEl.textContent = ssd;
                }

                if (tblGpuEl && gpu) {
                    tblGpuEl.textContent = gpu;
                }

                if (connEl && connectivity) {
                    connEl.textContent = connectivity;
                    connEl.title = connectivity;
                }
                if (tblConnEl && connectivity) {
                    tblConnEl.textContent = connectivity;
                }

                if (switchEl && switchType) {
                    switchEl.textContent = switchType;
                    switchEl.title = switchType;
                }
                if (tblSwitchEl && switchType) {
                    tblSwitchEl.textContent = switchType;
                }
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

    // Trigger initial click on the active variant button to sync UI
    const activeVariantBtn = document.querySelector('.pd-variant-btn.active');
    if (activeVariantBtn) {
        activeVariantBtn.click();
    }
});

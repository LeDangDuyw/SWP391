document.addEventListener('DOMContentLoaded', () => {
    // 1. Countdown Timer Logic
    const hoursSpan = document.getElementById('hours');
    const minutesSpan = document.getElementById('minutes');
    const secondsSpan = document.getElementById('seconds');

    if (hoursSpan && minutesSpan && secondsSpan) {
        let timeInSeconds = 2 * 3600 + 45 * 60 + 12;

        const updateTimer = () => {
            if (timeInSeconds <= 0) return;
            
            timeInSeconds--;
            
            const h = Math.floor(timeInSeconds / 3600);
            const m = Math.floor((timeInSeconds % 3600) / 60);
            const s = timeInSeconds % 60;

            hoursSpan.textContent = h.toString().padStart(2, '0');
            minutesSpan.textContent = m.toString().padStart(2, '0');
            secondsSpan.textContent = s.toString().padStart(2, '0');
        };

        setInterval(updateTimer, 1000);
    }

    // 2. Product Slider Logic
    const productGrids = document.querySelectorAll('.product-grid');
    
    productGrids.forEach(grid => {
        // Wrap grid in slider-wrapper
        const wrapper = document.createElement('div');
        wrapper.className = 'slider-wrapper';
        grid.parentNode.insertBefore(wrapper, grid);
        wrapper.appendChild(grid);
        
        // Create buttons
        const prevBtn = document.createElement('button');
        prevBtn.className = 'slider-btn slider-prev';
        prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
        
        const nextBtn = document.createElement('button');
        nextBtn.className = 'slider-btn slider-next';
        nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
        
        wrapper.appendChild(prevBtn);
        wrapper.appendChild(nextBtn);
        
        prevBtn.addEventListener('click', () => {
            if (!grid.firstElementChild) return;
            const scrollAmount = grid.firstElementChild.offsetWidth + 24;
            grid.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
        });
        
        nextBtn.addEventListener('click', () => {
            if (!grid.firstElementChild) return;
            const scrollAmount = grid.firstElementChild.offsetWidth + 24;
            grid.scrollBy({ left: scrollAmount, behavior: 'smooth' });
        });
        
        // Show/hide buttons based on scroll position
        const updateButtons = () => {
            if (grid.scrollLeft <= 0) {
                prevBtn.style.opacity = '0';
                prevBtn.style.pointerEvents = 'none';
            } else {
                prevBtn.style.opacity = '1';
                prevBtn.style.pointerEvents = 'auto';
            }
            
            // Add a 5px threshold to account for rounding errors in scrollWidth/clientWidth
            if (grid.scrollLeft + grid.clientWidth >= grid.scrollWidth - 5) {
                nextBtn.style.opacity = '0';
                nextBtn.style.pointerEvents = 'none';
            } else {
                nextBtn.style.opacity = '1';
                nextBtn.style.pointerEvents = 'auto';
            }
        };
        
        grid.addEventListener('scroll', updateButtons);
        window.addEventListener('resize', updateButtons);
        // Initial check
        setTimeout(updateButtons, 100);
    });

    // 3. AJAX Tabs Logic
    document.querySelectorAll('.tabs').forEach(tabsContainer => {
        tabsContainer.addEventListener('click', async (e) => {
            const btn = e.target.closest('.tab-btn');
            if (btn) {
                e.preventDefault();
                const href = btn.getAttribute('href');
                
                // Cập nhật giao diện tab active ngay lập tức
                tabsContainer.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                try {
                    const response = await fetch(href);
                    const html = await response.text();
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    // Xác định phần nào đang được click
                    const section = btn.closest('section');
                    const targetGridId = section.classList.contains('best-sellers') ? '#best-seller-grid' : '#new-product-grid';
                    
                    const newGrid = doc.querySelector(targetGridId);
                    const currentGrid = document.querySelector(targetGridId);
                    
                    if (newGrid && currentGrid) {
                        // Thay thế nội dung các sản phẩm
                        currentGrid.innerHTML = newGrid.innerHTML;
                        // Reset thanh cuộn về vị trí đầu
                        currentGrid.scrollLeft = 0;
                        // Cập nhật lại nút mũi tên
                        currentGrid.dispatchEvent(new Event('scroll'));
                    }
                    
                    // Cập nhật lại href của tất cả các tab để tránh click bị sai param cho các lần tiếp theo
                    const newTabs = doc.querySelectorAll('.tab-btn');
                    const currentTabs = document.querySelectorAll('.tab-btn');
                    currentTabs.forEach((tab, index) => {
                        if (newTabs[index]) {
                            tab.href = newTabs[index].href;
                        }
                    });
                    
                    // Thay đổi URL trên trình duyệt mà không reload
                    window.history.pushState({}, '', href);
                    
                } catch (err) {
                    console.error("Lỗi khi load sản phẩm tab", err);
                    window.location.href = href; // Fallback
                }
            }
        });
    });
});

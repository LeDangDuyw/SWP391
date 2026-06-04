document.addEventListener('DOMContentLoaded', () => {
    // đếm ngược giờ
    const countdownEl = document.getElementById('flash-sale-countdown');
    if (countdownEl) {
        const hoursSpan = document.getElementById('hours');
        const minutesSpan = document.getElementById('minutes');
        const secondsSpan = document.getElementById('seconds');

        if (hoursSpan && minutesSpan && secondsSpan) {
            let endTimeMs = Number(countdownEl.dataset.endtime);
            if (!endTimeMs) {
                endTimeMs = Date.now() + (2 * 3600 + 45 * 60 + 12) * 1000;
            }
            
            const updateTimer = () => {
                const now = Date.now();
                const timeInSeconds = Math.max(0, Math.floor((endTimeMs - now) / 1000));
                
                if (timeInSeconds <= 0) {
                    hoursSpan.textContent = '00';
                    minutesSpan.textContent = '00';
                    secondsSpan.textContent = '00';
                    return;
                }
                
                const h = Math.floor(timeInSeconds / 3600);
                const m = Math.floor((timeInSeconds % 3600) / 60);
                const s = timeInSeconds % 60;

                hoursSpan.textContent = h.toString().padStart(2, '0');
                minutesSpan.textContent = m.toString().padStart(2, '0');
                secondsSpan.textContent = s.toString().padStart(2, '0');
            };

            updateTimer();
            setInterval(updateTimer, 1000);
        }
    }

    const productGrids = document.querySelectorAll('.product-grid');
    
    productGrids.forEach(grid => {
        const wrapper = document.createElement('div');
        wrapper.className = 'slider-wrapper';
        grid.parentNode.insertBefore(wrapper, grid);
        wrapper.appendChild(grid);
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
        
        const updateButtons = () => {
            if (grid.scrollLeft <= 0) {
                prevBtn.style.opacity = '0';
                prevBtn.style.pointerEvents = 'none';
            } else {
                prevBtn.style.opacity = '1';
                prevBtn.style.pointerEvents = 'auto';
            }
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
        setTimeout(updateButtons, 100);
    });

    document.querySelectorAll('.tabs').forEach(tabsContainer => {
        tabsContainer.addEventListener('click', async (e) => {
            const btn = e.target.closest('.tab-btn');
            if (btn) {
                e.preventDefault();
                const href = btn.getAttribute('href');
                tabsContainer.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                try {
                    const response = await fetch(href);
                    const html = await response.text();
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const section = btn.closest('section');
                    const targetGridId = section.classList.contains('best-sellers') ? '#best-seller-grid' : '#new-product-grid';
                    
                    const newGrid = doc.querySelector(targetGridId);
                    const currentGrid = document.querySelector(targetGridId);
                    
                    if (newGrid && currentGrid) {
                        currentGrid.innerHTML = newGrid.innerHTML;
                        currentGrid.scrollLeft = 0;
                        currentGrid.dispatchEvent(new Event('scroll'));
                    }
                    const newTabs = doc.querySelectorAll('.tab-btn');
                    const currentTabs = document.querySelectorAll('.tab-btn');
                    currentTabs.forEach((tab, index) => {
                        if (newTabs[index]) {
                            tab.href = newTabs[index].href;
                        }
                    });
                    
                    // Cập nhật link "Xem tất cả" (View all) cho mục hiện tại
                    let sectionSelector = '';
                    if (section.classList.contains('best-sellers')) {
                        sectionSelector = '.best-sellers';
                    } else if (section.classList.contains('new-products')) {
                        sectionSelector = '.new-products';
                    }
                    if (sectionSelector) {
                        const newViewAll = doc.querySelector(`${sectionSelector} .view-all`);
                        const currentViewAll = section.querySelector('.view-all');
                        if (newViewAll && currentViewAll) {
                            currentViewAll.href = newViewAll.getAttribute('href');
                        }
                    }
                    
                    window.history.pushState({}, '', href);
                    
                } catch (err) {
                    console.error("Lỗi khi load sản phẩm tab", err);
                    window.location.href = href; // Fallback
                }
            }
        });
    });
    document.querySelectorAll('.search-form').forEach(form => {
        const searchInput = form.querySelector('input[name="search"]');
        if (!searchInput) return;

        const keywordsMap = {
            "1": ["laptop", "lap", "máy tính xách tay"],
            "2": ["màn hình", "man hinh", "monitor", "display"],
            "3": ["bàn phím", "ban phim", "keyboard", "phím", "phim"],
            "4": ["chuột", "mouse", "chuot"]
        };

        form.addEventListener('submit', (e) => {
            const query = searchInput.value.trim().toLowerCase();
            if (!query) {
                e.preventDefault();
                return;
            }
            
            // Tìm category phù hợp với keyword
            let matchedId = null;
            for (const [catId, keywords] of Object.entries(keywordsMap)) {
                const found = keywords.some(keyword => query.includes(keyword) || keyword.includes(query));
                if (found) {
                    matchedId = catId;
                    break;
                }
            }

            // có -> thêm/cập nhật hidden input
            let categoryInput = form.querySelector('input[name="category"]');
            if (matchedId) {
                if (!categoryInput) {
                    categoryInput = document.createElement('input');
                    categoryInput.type = 'hidden';
                    categoryInput.name = 'category';
                    form.appendChild(categoryInput);
                }
                categoryInput.value = matchedId;
            } else {
                // Không-> bỏ category để search toàn bộ
                if (categoryInput && !categoryInput.dataset.keep) {
                    categoryInput.remove();
                }
            }
        });
    });

    // Image URL Context Path fixer
    document.querySelectorAll('.banner-img-auto').forEach(img => {
        let src = img.getAttribute('src');
        if (src && !src.startsWith('http://') && !src.startsWith('https://')) {
            const context = img.getAttribute('data-context') || '';
            if (!src.startsWith(context)) {
                img.src = context + (src.startsWith('/') ? '' : '/') + src;
            }
        }
    });

    // Hero Banner Slider
    const slides = document.querySelectorAll('.hero-slide');
    const dots = document.querySelectorAll('.hero-dot');
    const prevBtn = document.querySelector('.hero-prev');
    const nextBtn = document.querySelector('.hero-next');
    
    if (slides.length > 1) {
        let currentSlide = 0;
        let slideInterval;
        
        const showSlide = (index) => {
            slides.forEach(slide => slide.classList.remove('active'));
            dots.forEach(dot => dot.classList.remove('active'));
            
            currentSlide = (index + slides.length) % slides.length;
            slides[currentSlide].classList.add('active');
            if (dots[currentSlide]) dots[currentSlide].classList.add('active');
        };
        
        const nextSlide = () => showSlide(currentSlide + 1);
        const prevSlide = () => showSlide(currentSlide - 1);
        
        const startAutoSlide = () => {
            stopAutoSlide();
            slideInterval = setInterval(nextSlide, 5000);
        };
        
        const stopAutoSlide = () => {
            if (slideInterval) clearInterval(slideInterval);
        };
        
        if (nextBtn) nextBtn.addEventListener('click', () => {
            nextSlide();
            startAutoSlide();
        });
        
        if (prevBtn) prevBtn.addEventListener('click', () => {
            prevSlide();
            startAutoSlide();
        });
        
        dots.forEach(dot => {
            dot.addEventListener('click', () => {
                const index = parseInt(dot.dataset.index);
                showSlide(index);
                startAutoSlide();
            });
        });
        
        const sliderWrapper = document.querySelector('.hero-slider-wrapper');
        if (sliderWrapper) {
            sliderWrapper.addEventListener('mouseenter', stopAutoSlide);
            sliderWrapper.addEventListener('mouseleave', startAutoSlide);
        }
        
        startAutoSlide();
    } else if (slides.length === 1) {
        if (prevBtn) prevBtn.style.display = 'none';
        if (nextBtn) nextBtn.style.display = 'none';
    }
});

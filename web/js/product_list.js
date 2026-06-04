document.addEventListener('DOMContentLoaded', () => {
    // tự động load khi thay đổi filter
    document.querySelectorAll('.js-auto-submit').forEach(el => {
        el.addEventListener('change', () => {
            const pageInput = document.getElementById('pageInput');
            if (pageInput) pageInput.value = 1;
            const form = document.getElementById('filterForm');
            if (form) form.submit();
        });
    });

    
    document.querySelectorAll('.js-go-to-page').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const page = link.dataset.page;
            const pageInput = document.getElementById('pageInput');
            if (pageInput) {
                pageInput.value = page;
                document.getElementById('filterForm').submit();
            }
        });
    });

    // xóa toàn bộ bộ lọc 
    document.querySelectorAll('.js-clear-all').forEach(btn => {
        btn.addEventListener('click', () => {
            const url = btn.dataset.clearUrl;
            if (url) window.location.href = url;
        });
    });

  
    document.querySelectorAll('.product-img').forEach(img => {
        img.addEventListener('error', () => {
            const fallback = img.dataset.fallbackSrc;
            if (fallback && img.src !== fallback) {
                img.src = fallback;
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
                // Không -> bỏ category để search toàn bộ
                if (categoryInput && !categoryInput.dataset.keep) {
                    categoryInput.remove();
                }
            }
        });
    });
});

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Tạo Phiếu Nhập Kho</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-tertiary-container": "#dde4ff",
                        "tertiary-fixed": "#dae2fd",
                        "on-secondary-fixed-variant": "#38485d",
                        "primary": "#003ec7",
                        "on-primary-container": "#dfe3ff",
                        "surface-container-highest": "#e0e3e5",
                        "error": "#ba1a1a",
                        "inverse-on-surface": "#eff1f3",
                        "secondary-container": "#d0e1fb",
                        "primary-fixed": "#dde1ff",
                        "on-tertiary-fixed-variant": "#3f465c",
                        "surface-container-high": "#e6e8ea",
                        "secondary-fixed": "#d3e4fe",
                        "on-primary": "#ffffff",
                        "tertiary-fixed-dim": "#bec6e0",
                        "outline-variant": "#c3c5d9",
                        "on-primary-fixed-variant": "#0038b6",
                        "on-background": "#191c1e",
                        "on-surface": "#191c1e",
                        "outline": "#737688",
                        "inverse-primary": "#b7c4ff",
                        "surface": "#f7f9fb",
                        "surface-dim": "#d8dadc",
                        "secondary": "#505f76",
                        "primary-fixed-dim": "#b7c4ff",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary": "#ffffff",
                        "background": "#f7f9fb",
                        "on-secondary": "#ffffff",
                        "on-surface-variant": "#434656",
                        "on-secondary-container": "#54647a",
                        "surface-container": "#eceef0",
                        "primary-container": "#0052ff",
                        "tertiary-container": "#5e667d",
                        "on-error": "#ffffff",
                        "surface-variant": "#e0e3e5",
                        "surface-tint": "#004ced",
                        "surface-container-low": "#f2f4f6",
                        "on-tertiary-fixed": "#131b2e",
                        "on-secondary-fixed": "#0b1c30",
                        "on-primary-fixed": "#001452",
                        "error-container": "#ffdad6",
                        "secondary-fixed-dim": "#b7c8e1",
                        "on-error-container": "#93000a",
                        "inverse-surface": "#2d3133",
                        "tertiary": "#464e64",
                        "surface-bright": "#f7f9fb"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "spacing": {
                        "margin-desktop": "64px",
                        "container-max": "1440px",
                        "gutter": "24px",
                        "margin-mobile": "20px",
                        "unit": "8px"
                    },
                    "fontFamily": {
                        "body-lg": ["Inter"],
                        "headline-lg": ["Space Grotesk"],
                        "headline-xl": ["Space Grotesk"],
                        "code-sm": ["monospace"],
                        "headline-xl-mobile": ["Space Grotesk"],
                        "body-sm": ["Inter"],
                        "label-md": ["Inter"],
                        "body-md": ["Inter"],
                        "headline-md": ["Space Grotesk"]
                    },
                    "fontSize": {
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                        "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "code-sm": ["13px", {"lineHeight": "18px", "fontWeight": "400"}],
                        "headline-xl-mobile": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .icon-fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>

<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống Quản trị</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Danh mục sản phẩm</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>Quản lý Serial</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu nhập kho</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Đánh giá sản phẩm</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
            <a href="${pageContext.request.contextPath}/staff/verifications"><span>🎓</span>Xác thực sinh viên</a>
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <%
                    model.Users u = (model.Users) session.getAttribute("user");
                    if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                %>
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                         alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid var(--blue);">
                <% } else { %>
                    <span>♙</span>
                <% } %>
                <span>Hồ sơ nhân viên</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
        </div>
    </aside>

    <div class="main">

        <!-- Top Header -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-4 w-1/3"></div>
            <div class="flex items-center gap-4">
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">help_outline</span>
                </button>
                <div class="h-8 w-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-label-md ml-2 border border-outline-variant/50">
                    <span class="material-symbols-outlined">person</span>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">

            <!-- Page Header -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <div class="flex items-center gap-3 mb-1">
                        <a href="${pageContext.request.contextPath}/staff/ticket/list" 
                           class="p-1 text-on-surface-variant hover:text-primary hover:bg-primary/10 rounded-lg transition-all">
                            <span class="material-symbols-outlined text-[20px]">arrow_back</span>
                        </a>
                        <h2 class="font-headline-lg text-headline-lg text-on-surface">Tạo Phiếu Nhập Kho</h2>
                    </div>
                    <p class="font-body-sm text-body-sm text-on-surface-variant ml-9">Tạo phiếu yêu cầu nhập kho mới gửi Admin phê duyệt.</p>
                </div>
            </div>

            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="mb-6 flex items-center gap-3 px-4 py-3 bg-error-container border border-error-container rounded-xl text-on-error-container font-label-md text-label-md">
                    <span class="material-symbols-outlined text-[20px]">error</span>
                    ${error}
                </div>
            </c:if>

            <!-- Create Form Card -->
            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm max-w-5xl">
                <div class="px-6 py-4 border-b border-outline-variant/20">
                    <h3 class="font-headline-md text-headline-md font-bold text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">edit_note</span>
                        Thông tin Phiếu
                    </h3>
                </div>

                <form action="${pageContext.request.contextPath}/staff/ticket/create" method="post" id="ticketForm" class="p-6 flex flex-col gap-6">
                    
                    <!-- Title -->
                    <div>
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Tiêu đề phiếu nhập</label>
                        <input type="text" name="title" required placeholder="VD: Nhập lô chuột Logitech tháng 7" value="${title}"
                               class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm">
                    </div>
                    
                    <!-- Product Search & Filter Bar -->
                    <div class="bg-surface-container-low p-4 rounded-xl border border-outline-variant/30 flex flex-col gap-3">
                        <label class="block font-label-md text-label-md text-on-surface-variant font-bold flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-primary text-[18px]">search</span>
                            Tìm kiếm & Lọc sản phẩm nhập kho
                        </label>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <!-- Search Keyword Input -->
                            <div class="relative col-span-1 sm:col-span-1">
                                <input type="text" id="productSearchInput" onkeyup="filterProducts()" placeholder="Nhập tên sản phẩm..."
                                       class="w-full pl-9 pr-4 py-2.5 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm">
                                <span class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-[18px]">search</span>
                            </div>
                            <!-- Category Filter -->
                            <div class="relative">
                                <select id="categoryFilter" onchange="filterProducts()"
                                        class="w-full appearance-none px-4 py-2.5 pr-8 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm">
                                    <option value="">-- Tất cả danh mục --</option>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.categoryId}">${c.categoryName}</option>
                                    </c:forEach>
                                </select>
                                <span class="material-symbols-outlined absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                            </div>
                            <!-- Brand Filter -->
                            <div class="relative">
                                <select id="brandFilter" onchange="filterProducts()"
                                        class="w-full appearance-none px-4 py-2.5 pr-8 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none text-sm">
                                    <option value="">-- Tất cả thương hiệu --</option>
                                    <c:forEach var="b" items="${brands}">
                                        <option value="${b.brandId}">${b.brandName}</option>
                                    </c:forEach>
                                </select>
                                <span class="material-symbols-outlined absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                            </div>
                        </div>

                        <!-- Product Select Dropdown & Add Button -->
                        <div class="flex items-end gap-3 mt-1">
                            <div class="flex-1">
                                <div class="relative">
                                    <select id="productSelect"
                                            class="w-full appearance-none px-4 py-3 pr-10 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm">
                                        <option value="">-- Chọn sản phẩm --</option>
                                        <c:forEach var="p" items="${products}">
                                            <option value="${p.productId}">${p.productName}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                                </div>
                            </div>
                            <button type="button" id="addProductBtn"
                                    class="px-5 py-3 bg-[#d0e1fb] text-[#003ec7] font-bold hover:bg-blue-200 transition-all rounded-lg flex items-center gap-1.5 h-[48px] flex-shrink-0">
                                <span class="material-symbols-outlined text-[20px]">add_circle</span>
                                Thêm vào phiếu
                            </button>
                        </div>
                    </div>

                    <!-- Variant Table (rendered dynamically by JS) -->
                    <div id="variantSection" class="hidden">
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Danh sách biến thể đã thêm</label>
                        <p class="text-[12px] text-on-surface-variant mb-3 flex items-start gap-1.5">
                            <span class="material-symbols-outlined text-[14px] mt-0.5 flex-shrink-0">info</span>
                            Nhập số lượng (> 0) và giá nhập cho các dòng biến thể. Bấm biểu tượng Thùng rác nếu muốn gỡ bỏ biến thể khỏi phiếu.
                        </p>
                        <div class="border border-outline-variant/30 rounded-xl overflow-hidden">
                            <table class="w-full text-left">
                                <thead class="bg-[#2d3133] text-white text-xs font-bold tracking-wider">
                                    <tr>
                                        <th class="px-4 py-3 uppercase">SKU</th>
                                        <th class="px-4 py-3 uppercase">Tên biến thể</th>
                                        <th class="px-4 py-3 uppercase text-center w-[120px]">Số lượng nhập</th>
                                        <th class="px-4 py-3 uppercase text-center w-[160px]">Giá nhập (VNĐ)</th>
                                        <th class="px-4 py-3 uppercase text-center w-[80px]">Gỡ bỏ</th>
                                    </tr>
                                </thead>
                                <tbody id="variantTableBody" class="divide-y divide-outline-variant/30">
                                    <!-- Dynamic rows rendered by JS -->
                                </tbody>
                                <tfoot id="totalFooter" class="hidden">
                                    <tr class="bg-surface-container-high font-bold text-on-surface text-[14px]">
                                        <td colspan="3" class="px-4 py-3 text-right">Tổng giá trị dự kiến:</td>
                                        <td class="px-4 py-3 text-center text-primary" id="totalValueDisplay">0 VNĐ</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Submit Buttons -->
                    <div class="flex justify-end gap-3 pt-2 border-t border-outline-variant/20">
                        <a href="${pageContext.request.contextPath}/staff/ticket/list"
                           class="px-6 py-2.5 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg font-label-md text-label-md">
                            Hủy bỏ
                        </a>
                        <button type="submit" 
                                class="px-6 py-2.5 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 font-label-md text-label-md flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">send</span>
                            Gửi phê duyệt
                        </button>
                    </div>
                </form>
            </div>

        </main>
    </div>
</div>

<!-- JavaScript: Xử lý tìm kiếm, lọc sản phẩm và thêm biến thể vào bảng nhập kho phía Client -->
<script>
    // Danh sách tất cả sản phẩm được nạp từ Server truyền sang
    const allProducts = [
        <c:forEach var="p" items="${products}" varStatus="loop">
            {
                productId: ${p.productId},
                productName: "<c:out value="${p.productName}"/>",
                categoryId: ${p.categoryId},
                brandId: ${p.brandId}
            }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    // Danh sách tất cả biến thể sản phẩm (SKU, giá nhập...)
    const allVariants = [
        <c:forEach var="v" items="${variants}" varStatus="loop">
            {
                variantId: ${v.variantId},
                productId: ${v.productId},
                sku: "<c:out value="${v.sku}"/>",
                variantName: "<c:out value="${v.variantName}"/>",
                importPrice: parseFloat("<c:out value="${empty v.importPrice ? 0 : v.importPrice}"/>")
            }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    // Lấy các element trên giao diện DOM
    const productSelect = document.getElementById('productSelect');
    const addProductBtn = document.getElementById('addProductBtn');
    const variantSection = document.getElementById('variantSection');
    const variantTableBody = document.getElementById('variantTableBody');

    /**
     * Hàm lọc danh mục sản phẩm theo từ khóa tìm kiếm, danh mục và thương hiệu trên client.
     * Cập nhật danh sách option hiển thị trong thẻ <select id="productSelect">.
     */
    function filterProducts() {
        const searchVal = document.getElementById('productSearchInput').value.trim().toLowerCase();
        const catVal = document.getElementById('categoryFilter').value;
        const brandVal = document.getElementById('brandFilter').value;
        
        const filtered = allProducts.filter(p => {
            const matchesSearch = !searchVal || p.productName.toLowerCase().includes(searchVal);
            const matchesCat = !catVal || p.categoryId == catVal;
            const matchesBrand = !brandVal || p.brandId == brandVal;
            return matchesSearch && matchesCat && matchesBrand;
        });

        const selectedVal = productSelect.value;
        productSelect.innerHTML = '<option value="">-- Chọn sản phẩm (' + filtered.length + ' kết quả) --</option>';
        filtered.forEach(p => {
            const opt = document.createElement('option');
            opt.value = p.productId;
            opt.textContent = p.productName;
            if (p.productId == selectedVal) {
                opt.selected = true;
            }
            productSelect.appendChild(opt);
        });
    }

    /**
     * Lắng nghe sự kiện bấm nút "Thêm":
     * Lấy các biến thể thuộc sản phẩm được chọn và thêm từng dòng biến thể vào bảng nhập kho.
     */
    addProductBtn.addEventListener('click', function() {
        const selectedProductId = parseInt(productSelect.value);
        if (!selectedProductId) {
            alert('Vui lòng chọn một sản phẩm trước khi bấm Thêm.');
            return;
        }

        // Lọc các biến thể thuộc sản phẩm được chọn
        const filtered = allVariants.filter(v => v.productId === selectedProductId);

        if (filtered.length === 0) {
            alert('Sản phẩm này không có biến thể nào để nhập.');
            return;
        }

        variantSection.classList.remove('hidden');

        filtered.forEach(v => {
            // Kiểm tra xem variant này đã được thêm vào bảng hay chưa để tránh trùng lặp
            const isExist = document.querySelector('input[name="variantId"][value="' + v.variantId + '"]');
            if (isExist) {
                return; // Nếu đã tồn tại thì bỏ qua
            }

            const tr = document.createElement('tr');
            tr.className = 'hover:bg-surface-container-lowest/50';
            tr.innerHTML = 
                '<td class="px-4 py-3 font-mono text-sm text-on-surface-variant">' + v.sku + '</td>' +
                '<td class="px-4 py-3 text-sm text-on-surface font-medium">' + v.variantName + '</td>' +
                '<td class="px-4 py-3 text-center">' +
                    '<input type="hidden" name="variantId" value="' + v.variantId + '">' +
                    '<input type="number" name="quantity" min="0" value="0" onchange="updateTotal()" onkeyup="updateTotal()" ' +
                           'class="w-[100px] px-3 py-2 border border-outline-variant/50 rounded-lg bg-white text-on-surface text-sm text-center focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all">' +
                '</td>' +
                '<td class="px-4 py-3 text-center">' +
                    '<input type="number" name="expectedPrice" min="0" step="1000" value="' + v.importPrice + '" onchange="updateTotal()" onkeyup="updateTotal()" ' +
                           'class="w-[150px] px-3 py-2 border border-outline-variant/50 rounded-lg bg-white text-on-surface text-sm text-center focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all">' +
                '</td>' +
                '<td class="px-4 py-3 text-center">' +
                    '<button type="button" onclick="removeVariantRow(this)" class="text-error hover:text-red-700 transition-colors p-1 flex items-center justify-center mx-auto">' +
                        '<span class="material-symbols-outlined text-[20px]">delete</span>' +
                    '</button>' +
                '</td>';
            variantTableBody.appendChild(tr);
        });

        // Reset lại giá trị dropdown chọn sản phẩm
        productSelect.value = '';
    });

    /**
     * Gỡ bỏ một dòng biến thể khỏi bảng nhập kho và tính toán lại tổng tiền.
     * @param {HTMLElement} button Nút xóa dòng tương ứng
     */
    window.removeVariantRow = function(button) {
        button.closest('tr').remove();
        
        // Nếu không còn biến thể nào trong bảng, ẩn bảng biến thể đi
        if (variantTableBody.children.length === 0) {
            variantSection.classList.add('hidden');
        }
        updateTotal();
    };

    /**
     * Tính toán tổng giá trị dự kiến của phiếu nhập kho dựa trên số lượng và giá nhập của từng biến thể.
     */
    function updateTotal() {
        let total = 0;
        const rows = variantTableBody.querySelectorAll('tr');
        rows.forEach(row => {
            const qty = parseInt(row.querySelector('input[name="quantity"]').value) || 0;
            const price = parseFloat(row.querySelector('input[name="expectedPrice"]').value) || 0;
            total += qty * price;
        });
        document.getElementById('totalValueDisplay').innerText = total.toLocaleString('vi-VN') + ' VNĐ';
        if (rows.length > 0) {
            document.getElementById('totalFooter').classList.remove('hidden');
        } else {
            document.getElementById('totalFooter').classList.add('hidden');
        }
    }
</script>

</body>
</html>

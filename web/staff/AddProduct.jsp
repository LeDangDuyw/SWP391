<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.*" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html class="light" lang="en">

            <head>
                <meta charset="utf-8">
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <title>UNILAP Admin - Thêm sản phẩm mới</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;family=Space+Grotesk:wght@600;700&amp;display=swap"
                    rel="stylesheet">
                <script id="tailwind-config">
                    tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                "colors": {
                                    "primary": "#003ec7",
                                    "surface-container": "#eceef0",
                                    "surface-container-lowest": "#ffffff",
                                    "surface-container-low": "#f2f4f6",
                                    "surface-container-highest": "#e0e3e5",
                                    "on-surface": "#191c1e",
                                    "on-surface-variant": "#434656",
                                    "outline-variant": "#c3c5d9",
                                    "secondary-container": "#d0e1fb",
                                    "on-secondary-container": "#54647a",
                                    "primary-container": "#0052ff",
                                    "on-primary-container": "#dfe3ff",
                                    "on-primary": "#ffffff",
                                    "background": "#f7f9fb",
                                    "error": "#ba1a1a",
                                    "surface": "#ffffff"
                                },
                                "fontFamily": {
                                    "body-sm": ["Inter"],
                                    "body-md": ["Inter"],
                                    "label-md": ["Inter"],
                                    "headline-md": ["Space Grotesk"],
                                    "headline-lg": ["Space Grotesk"]
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
            </head>
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
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống Quản trị</small></div>
        <nav>
            <a class="active" href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Danh mục sản phẩm</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu nhập kho</a>
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

    <!-- Main Content -->
    <div class="main">
        <main class="flex-1 p-8">
            <!-- Header Section -->
            <form action="${pageContext.request.contextPath}/staff/inventory/add" method="post" enctype="multipart/form-data" onsubmit="return validateProductForm()">
                <div class="flex justify-between items-end mb-6">
                    <div>
                        <div class="flex items-center text-sm text-on-surface-variant mb-2">
                            <a href="${pageContext.request.contextPath}/staff/inventory" class="hover:text-primary transition-colors">Kho hàng</a>
                            <span class="material-symbols-outlined text-[16px] mx-1">chevron_right</span>
                            <span class="text-primary font-medium">Thêm sản phẩm</span>
                        </div>
                        <h2 class="font-headline-lg text-3xl font-bold text-on-surface">Thêm sản phẩm mới</h2>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/staff/inventory" class="px-6 py-2 bg-surface border border-outline-variant rounded-lg text-on-surface font-medium text-sm hover:bg-surface-container-low transition-colors">Hủy</a>
                        <button type="submit" class="px-6 py-2 bg-[#003ec7] text-white rounded-lg font-medium text-sm hover:bg-blue-700 transition-colors">Lưu sản phẩm</button>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6"
                        role="alert">
                        <span class="block sm:inline font-medium">${errorMessage}</span>
                    </div>
                </c:if>

                            <!-- General Information -->
                            <div class="bg-surface border border-outline-variant/30 rounded-xl mb-6 shadow-sm">
                                <div class="px-6 py-4 border-b border-outline-variant/30">
                                    <h3 class="text-xl font-semibold text-on-surface">Thông tin chung</h3>
                                </div>

                                <div class="p-6 flex flex-col gap-8">
                                    <div class="flex-1 space-y-6">
                                        <!-- Product Name -->
                                        <div>
                                            <label
                                                class="block text-sm font-medium text-on-surface-variant mb-2">Tên sản phẩm</label>
                                            <input type="text" name="productName"
                                                placeholder="Ví dụ: ZenBook Pro 16X OLED"
                                                class="w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all placeholder-on-surface-variant/50"
                                                required>
                                        </div>

                                        <div class="flex gap-6">
                                            <!-- Category -->
                                            <div class="flex-1">
                                                <label
                                                    class="block text-sm font-medium text-on-surface-variant mb-2">Danh mục</label>
                                                <div class="relative">
                                                    <select name="categoryId"
                                                        class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none"
                                                        required>
                                                        <option value="" disabled selected>Chọn danh mục</option>
                                                        <c:forEach var="c" items="${categories}">
                                                            <option value="${c.categoryId}">${c.categoryName}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <span
                                                        class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                                </div>
                                            </div>

                                            <!-- Brand -->
                                            <div class="flex-1">
                                                <div class="flex items-center justify-between mb-2">
                                                    <label class="block text-sm font-medium text-on-surface-variant">Thương hiệu</label>
                                                    <button type="button" onclick="openAddBrandModal()" class="text-xs text-primary hover:underline flex items-center gap-1 font-semibold">
                                                        <span class="material-symbols-outlined text-[14px]">add</span>Thêm thương hiệu
                                                    </button>
                                                </div>
                                                <div class="relative">
                                                    <select name="brandId"
                                                        class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none"
                                                        required>
                                                        <option value="" disabled selected>Chọn thương hiệu</option>
                                                        <c:forEach var="b" items="${brands}">
                                                            <option value="${b.brandId}">${b.brandName}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <span
                                                        class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                                </div>
                                            </div>

                                            <!-- Warranty Period -->
                                            <div class="flex-1">
                                                <label
                                                    class="block text-sm font-medium text-on-surface-variant mb-2">Bảo hành (tháng)</label>
                                                <input type="number" name="warrantyPeriod" min="0" placeholder="Ví dụ: 12" value="12"
                                                    class="w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all placeholder-on-surface-variant/50"
                                                    required>
                                            </div>
                                        </div>

                                        <div class="flex gap-6">
                                            <!-- Purpose / Nhu cầu sử dụng -->
                                            <div class="flex-1">
                                                <label class="block text-sm font-medium text-on-surface-variant mb-2">Nhu cầu sử dụng</label>
                                                <div class="flex flex-col gap-2">
                                                    <div class="relative">
                                                        <select name="purposeSelect" id="purposeSelect" onchange="toggleCustomPurpose(this, 'purposeCustom')"
                                                            class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none">
                                                            <option value="">-- Chọn nhu cầu --</option>
                                                            <option value="Văn phòng">Học tập - Văn phòng</option>
                                                            <option value="Gaming">Gaming - Trải nghiệm</option>
                                                            <option value="Đồ họa">Đồ họa - Kỹ thuật</option>
                                                            <option value="Mỏng nhẹ">Mỏng nhẹ - Cao cấp</option>
                                                            <option value="Khác">Khác...</option>
                                                        </select>
                                                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                                    </div>
                                                    <input type="text" name="purposeCustom" id="purposeCustom" placeholder="Nhập nhu cầu khác..."
                                                        class="hidden w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none placeholder-on-surface-variant/50">
                                                </div>
                                            </div>

                                            <!-- Product Series / Dòng sản phẩm -->
                                            <div class="flex-1" id="series-container">
                                                <div class="flex items-center justify-between mb-2">
                                                    <label class="block text-sm font-medium text-on-surface-variant">Dòng sản phẩm</label>
                                                    <button type="button" onclick="openAddSeriesModal()" class="text-xs text-primary hover:underline flex items-center gap-1 font-semibold">
                                                        <span class="material-symbols-outlined text-[14px]">add</span>Thêm dòng sản phẩm
                                                    </button>
                                                </div>
                                                <div class="relative">
                                                    <select name="seriesId" id="seriesId"
                                                        class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none">
                                                        <option value="">-- Chọn dòng sản phẩm --</option>
                                                    </select>
                                                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Description -->
                                        <div>
                                            <label
                                                class="block text-sm font-medium text-on-surface-variant mb-2">Mô tả sản phẩm</label>
                                            <div
                                                class="border border-outline-variant/50 rounded-lg overflow-hidden flex flex-col">

                                                <textarea name="description" rows="5"
                                                    placeholder="Mô tả thông số kỹ thuật và điểm nổi bật của sản phẩm..."
                                                    class="w-full px-4 py-3 bg-surface text-on-surface resize-none focus:outline-none placeholder-on-surface-variant/50"></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thumbnail -->
                                    <div class="w-full lg:w-72 flex-shrink-0">
                                        <label class="block text-sm font-medium text-on-surface-variant mb-2">Ảnh đại diện sản phẩm</label>
                                        <div
                                            class="border-2 border-dashed border-outline-variant/50 rounded-xl bg-surface-container-lowest flex flex-col items-center justify-center p-6 h-[280px] hover:bg-surface-container-low transition-colors cursor-pointer relative overflow-hidden group">
                                            <input type="file" name="thumbnail"
                                                class="absolute inset-0 opacity-0 cursor-pointer z-10" accept="image/*">
                                            <div
                                                class="w-16 h-16 bg-[#0052ff] rounded-xl flex items-center justify-center text-white mb-4 shadow-sm group-hover:scale-105 transition-transform">
                                                <span class="material-symbols-outlined text-3xl">cloud_upload</span>
                                            </div>
                                            <p class="text-sm font-bold text-on-surface text-center mb-1">Nhấp để tải lên hoặc kéo thả</p>
                                            <p class="text-xs text-on-surface-variant text-center">SVG, PNG, JPG hoặc WEBP<br>(Tối đa 800×400px)</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Variants -->
                            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm">
                                <div
                                    class="px-6 py-4 flex justify-between items-center border-b border-outline-variant/30">
                                    <h3 class="text-xl font-semibold text-on-surface">Biến thể sản phẩm</h3>
                                    <button type="button" onclick="addVariantRow()"
                                        class="flex items-center gap-2 px-4 py-2 bg-[#d0e1fb] text-[#003ec7] rounded-lg font-medium text-sm hover:bg-blue-200 transition-colors">
                                        <span class="material-symbols-outlined text-[18px]">add_circle</span> Thêm biến thể
                                    </button>
                                </div>

                                <div class="w-full">
                                    <table class="w-full text-left">
                                        <thead class="bg-[#2d3133] text-white text-xs font-bold tracking-wider">
                                            <tr>
                                                <th class="px-6 py-4 uppercase">SKU</th>
                                                <th class="px-6 py-4 uppercase">GIÁ NHẬP (VNĐ)</th>
                                                <th class="px-6 py-4 uppercase">GIÁ BÁN (VNĐ)</th>
                                                <th class="px-6 py-4 uppercase">THUỘC TÍNH<br><span
                                                        class="text-[10px] font-normal text-gray-300">(RAM/MÀU SẮC)</span>
                                                </th>
                                                <th class="px-6 py-4 uppercase">ẢNH ĐẠI DIỆN</th>
                                                <th class="px-6 py-4 uppercase text-right">HÀNH ĐỘNG</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-outline-variant/30" id="variants-container">
                                            <!-- Dynamic rows will be added here -->
                                        </tbody>
                                    </table>
                                </div>

                                <div
                                    class="px-6 py-4 bg-surface-container-low rounded-b-xl border-t border-outline-variant/30 text-sm text-on-surface-variant italic">
                                    * Các mã SKU được tự động kiểm tra để tránh trùng lặp trong hệ thống.
                                </div>
                            </div>
                        </form>
                    </main>
                </div>
            </div>

                <!-- Scripts for dynamic functionality -->
                <script>
                    function validateProductForm() {
                        const productName = document.querySelector('input[name="productName"]');
                        const categorySelect = document.querySelector('select[name="categoryId"]');
                        const brandSelect = document.querySelector('select[name="brandId"]');
                        const warrantyPeriod = document.querySelector('input[name="warrantyPeriod"]');

                        if (!productName || !productName.value.trim()) {
                            alert("Tên sản phẩm không được để trống!");
                            if (productName) productName.focus();
                            return false;
                        }
                        if (!categorySelect || !categorySelect.value) {
                            alert("Vui lòng chọn Danh mục sản phẩm!");
                            if (categorySelect) categorySelect.focus();
                            return false;
                        }
                        if (!brandSelect || !brandSelect.value) {
                            alert("Vui lòng chọn Thương hiệu sản phẩm!");
                            if (brandSelect) brandSelect.focus();
                            return false;
                        }
                        if (warrantyPeriod) {
                            const wVal = parseInt(warrantyPeriod.value);
                            if (isNaN(wVal) || wVal < 0) {
                                alert("Thời gian bảo hành phải là số không âm (>= 0)!");
                                warrantyPeriod.focus();
                                return false;
                            }
                        }

                        const importPrices = document.querySelectorAll('input[name="importPrice[]"]');
                        const prices = document.querySelectorAll('input[name="price[]"]');
                        const skus = document.querySelectorAll('input[name="sku[]"]');
                        
                        if (skus.length === 0) {
                            alert("Vui lòng thêm ít nhất một biến thể sản phẩm!");
                            return false;
                        }

                        for (let i = 0; i < skus.length; i++) {
                            const sku = skus[i].value.trim();
                            const ip = parseFloat(importPrices[i].value);
                            const sp = parseFloat(prices[i].value);

                            if (!sku) {
                                alert("Mã SKU của biến thể thứ " + (i + 1) + " không được để trống!");
                                skus[i].focus();
                                return false;
                            }

                            if (isNaN(ip) || ip <= 0) {
                                alert("Giá nhập của SKU '" + sku + "' phải là số dương lớn hơn 0!");
                                importPrices[i].focus();
                                return false;
                            }

                            if (isNaN(sp) || sp <= 0) {
                                alert("Giá bán của SKU '" + sku + "' phải là số dương lớn hơn 0!");
                                prices[i].focus();
                                return false;
                            }

                            if (sp < ip) {
                                alert("Giá bán không được nhỏ hơn giá nhập (SKU: " + sku + ")!");
                                prices[i].focus();
                                return false;
                            }
                        }
                        return true;
                    }
                    // --- Xử lý xem trước ảnh (Image Preview) khi người dùng chọn file ---
                    document.querySelector('input[name="thumbnail"]').addEventListener('change', function (e) {
                        const file = e.target.files[0];
                        if (file) {
                            // Sử dụng FileReader để đọc file ảnh dưới dạng Data URL hiển thị tạm thời
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const container = document.querySelector('.border-dashed');

                                // Nếu đã có ảnh preview trước đó thì xóa đi
                                const existingPreview = container.querySelector('.img-preview-container');
                                if (existingPreview) existingPreview.remove();

                                // Ẩn các đoạn text hướng dẫn (Click to upload...) và icon mặc định
                                Array.from(container.children).forEach(child => {
                                    if (child.tagName !== 'INPUT') {
                                        child.style.display = 'none';
                                    }
                                });

                                // Tạo thẻ div chứa thẻ img để hiển thị ảnh vừa chọn
                                const previewDiv = document.createElement('div');
                                previewDiv.className = 'img-preview-container absolute inset-0 w-full h-full pointer-events-none';
                                previewDiv.innerHTML = `
                        <img src="\${e.target.result}" class="w-full h-full object-cover rounded-xl" alt="Preview">
                        <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center text-white rounded-xl">
                            <span class="font-bold">Thay đổi ảnh</span>
                        </div>
                    `;
                                container.appendChild(previewDiv);
                            }
                            reader.readAsDataURL(file);
                        }
                    });

                    // --- Xử lý giao diện thêm các biến thể (Dynamic Variants) ---
                    const variantsContainer = document.getElementById('variants-container');
                    let variantCount = 0; // Đếm số lượng variant để tạo placeholder tên SKU tự động

                    // Hàm thêm một dòng (hàng) nhập biến thể mới vào bảng
                    function addVariantRow() {
                        variantCount++;
                        const tr = document.createElement('tr');
                        tr.className = 'hover:bg-surface-container-lowest/50';
                        tr.innerHTML = `
                <td class="px-6 py-5 w-1/6">
                    <input type="text" name="sku[]" placeholder="SKU-\${variantCount}" class="w-full px-3 py-2 border border-outline-variant/50 rounded bg-surface-container-low text-on-surface-variant font-mono text-sm focus:outline-none focus:border-primary" required>
                </td>
                <td class="px-6 py-5 w-1/6">
                    <div class="relative">
                        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">đ</span>
                        <input type="number" step="1" min="1" name="importPrice[]" placeholder="100000" class="w-full pl-7 pr-3 py-2 border border-outline-variant/50 rounded bg-surface text-on-surface text-sm focus:outline-none focus:border-primary" required>
                    </div>
                </td>
                <td class="px-6 py-5 w-1/6">
                    <div class="relative">
                        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">đ</span>
                        <input type="number" step="1" min="1" name="price[]" placeholder="120000" class="w-full pl-7 pr-3 py-2 border border-outline-variant/50 rounded bg-surface text-on-surface text-sm focus:outline-none focus:border-primary" required>
                    </div>
                </td>
                <td class="px-6 py-5">
                    <div class="flex flex-wrap items-center gap-2 attribute-container">
                        <button type="button" onclick="addAttribute(this)" class="text-[#003ec7] hover:bg-blue-100 rounded-full flex items-center justify-center p-1"><span class="material-symbols-outlined text-[18px]">add</span></button>
                    </div>
                    <input type="hidden" name="variantName[]" value="" class="variant-name-hidden">
                </td>
                <td class="px-6 py-5">
                    <label class="flex items-center gap-2 cursor-pointer border border-dashed border-outline-variant/50 rounded-lg px-3 py-2 hover:bg-surface-container-low transition-colors">
                        <span class="material-symbols-outlined text-[18px] text-on-surface-variant">image</span>
                        <span class="text-xs text-on-surface-variant variant-thumb-label">Chọn ảnh</span>
                        <input type="file" name="variantThumbnail[]" accept="image/*" class="hidden" onchange="previewVariantThumb(this)">
                    </label>
                    <img class="variant-thumb-preview mt-1 w-10 h-10 object-cover rounded hidden" alt="Preview">
                </td>
                <td class="px-6 py-5 text-right">
                    <button type="button" onclick="this.closest('tr').remove()" class="text-on-surface-variant hover:text-error transition-colors p-2"><span class="material-symbols-outlined">delete</span></button>
                </td>
            `;
                        variantsContainer.appendChild(tr);
                    }

                    // Hàm thêm thuộc tính (màu sắc, RAM...) cho biến thể bằng cách bật hộp thoại prompt
                    function addAttribute(btn) {
                        const attrName = prompt("Nhập thuộc tính (ví dụ: 32GB RAM, Màu đen):");
                        if (attrName && attrName.trim() !== "") {
                            // Tạo thẻ span chứa tên thuộc tính (hiển thị dưới dạng nhãn/badge)
                            const span = document.createElement('span');
                            span.className = 'px-2 py-1 bg-[#d0e1fb] text-[#003ec7] text-xs font-semibold rounded cursor-pointer attribute-badge';
                            span.textContent = attrName.trim();
                            span.title = "Nhấp để xóa";
                            span.onclick = function () { this.remove(); updateHiddenVariantName(btn.closest('td')); };

                            // Chèn nhãn thuộc tính vào trước nút Add (+)
                            const container = btn.parentElement;
                            container.insertBefore(span, btn);
                            updateHiddenVariantName(btn.closest('td')); // Cập nhật lại chuỗi tên gộp
                        }
                    }

                    // Cập nhật giá trị vào input hidden để gửi lên Server dạng "Thuộc tính 1 / Thuộc tính 2"
                    function updateHiddenVariantName(td) {
                        const badges = td.querySelectorAll('.attribute-badge');
                        const hiddenInput = td.querySelector('.variant-name-hidden');
                        const values = Array.from(badges).map(b => b.textContent);
                        hiddenInput.value = values.join(' / ');
                    }

                    // Xem trước ảnh thumbnail của biến thể
                    function previewVariantThumb(input) {
                        const preview = input.closest('td').querySelector('.variant-thumb-preview');
                        const label = input.closest('td').querySelector('.variant-thumb-label');
                        if (input.files && input.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function(e) {
                                preview.src = e.target.result;
                                preview.classList.remove('hidden');
                                label.textContent = input.files[0].name.substring(0, 12) + '...';
                            };
                            reader.readAsDataURL(input.files[0]);
                        }
                    }

                    // Khởi tạo dòng nhập biến thể đầu tiên lúc vừa load trang
                    addVariantRow();

                    // --- Xử lý lọc dòng sản phẩm động theo hãng và ẩn/hiện theo danh mục ---
                    const allSeries = [
                        <c:forEach var="s" items="${serieses}" varStatus="loop">
                            { id: ${s.seriesId}, name: "${s.seriesName}", brandId: ${s.brandId} }${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    /**
                     * Xử lý lọc danh sách Dòng sản phẩm (Series) động theo Thương hiệu (Brand) được chọn,
                     * đồng thời ẩn/hiện trường chọn Dòng sản phẩm (chỉ hiển thị đối với danh mục Laptop).
                     */
                    function filterSeriesAndCategory() {
                        const categorySelect = document.querySelector('select[name="categoryId"]');
                        const brandSelect = document.querySelector('select[name="brandId"]');
                        const seriesSelect = document.getElementById('seriesId');
                        const seriesContainer = document.getElementById('series-container');

                        if (!categorySelect || !brandSelect || !seriesSelect || !seriesContainer) return;

                        const selectedCategoryId = categorySelect.value;
                        const selectedBrandId = parseInt(brandSelect.value) || 0;

                        // Chỉ danh mục Laptop (categoryId = 1) mới hiển thị chọn Dòng sản phẩm (Series)
                        if (selectedCategoryId === "1") {
                            seriesContainer.style.display = "block";
                            seriesSelect.disabled = false;
                            
                            const prevVal = seriesSelect.value;
                            seriesSelect.innerHTML = '<option value="">-- Chọn dòng sản phẩm --</option>';
                            
                            const filtered = allSeries.filter(s => s.brandId === selectedBrandId);
                            filtered.forEach(s => {
                                const opt = document.createElement('option');
                                opt.value = s.id;
                                opt.textContent = s.name;
                                if (parseInt(prevVal) === s.id) {
                                    opt.selected = true;
                                }
                                seriesSelect.appendChild(opt);
                            });
                        } else {
                            // Ẩn dropdown dòng sản phẩm nếu thuộc danh mục khác
                            seriesContainer.style.display = "none";
                            seriesSelect.value = "";
                            seriesSelect.disabled = true;
                        }
                    }

                    /**
                     * Ẩn/hiện ô nhập dữ liệu tùy chỉnh khi người dùng chọn tùy chọn "Khác".
                     * @param {HTMLSelectElement} select Thẻ select mục đích sử dụng
                     * @param {string} inputId ID của ô input nhập tùy chỉnh
                     */
                    function toggleCustomPurpose(select, inputId) {
                        const input = document.getElementById(inputId);
                        if (!input) return;
                        if (select.value === "Khác") {
                            input.classList.remove('hidden');
                            input.setAttribute('required', 'required');
                            input.focus();
                        } else {
                            input.classList.add('hidden');
                            input.removeAttribute('required');
                            input.value = "";
                        }
                    }

                    /**
                     * Mở Modal thêm nhanh Dòng sản phẩm (Series) mới.
                     */
                    function openAddSeriesModal() {
                        const brandSelect = document.querySelector('select[name="brandId"]');
                        if (!brandSelect || !brandSelect.value) {
                            alert("Vui lòng chọn Thương hiệu trước!");
                            return;
                        }
                        document.getElementById('newSeriesName').value = "";
                        document.getElementById('addSeriesError').classList.add('hidden');
                        document.getElementById('addSeriesModal').classList.remove('hidden');
                    }

                    /**
                     * Đóng Modal thêm Dòng sản phẩm.
                     */
                    function closeAddSeriesModal() {
                        document.getElementById('addSeriesModal').classList.add('hidden');
                    }

                    /**
                     * Gửi yêu cầu AJAX tạo mới Dòng sản phẩm và nạp trực tiếp vào danh sách lựa chọn.
                     */
                    function submitAddSeries() {
                        const brandSelect = document.querySelector('select[name="brandId"]');
                        const brandId = brandSelect.value;
                        const seriesNameInput = document.getElementById('newSeriesName');
                        const seriesName = seriesNameInput.value.trim();
                        const errorDiv = document.getElementById('addSeriesError');
                        
                        if (!seriesName) {
                            errorDiv.textContent = "Tên dòng sản phẩm không được để trống!";
                            errorDiv.classList.remove('hidden');
                            return;
                        }
                        
                        const xhr = new XMLHttpRequest();
                        xhr.open("POST", "${pageContext.request.contextPath}/staff/series/add", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    try {
                                        const response = JSON.parse(xhr.responseText);
                                        if (response.success) {
                                            allSeries.push({
                                                id: response.id,
                                                name: response.name,
                                                brandId: response.brandId
                                            });
                                            
                                            const seriesSelect = document.getElementById('seriesId');
                                            
                                            // Cập nhật lại dropdown và tự động chọn phần tử vừa thêm
                                            filterSeriesAndCategory();
                                            seriesSelect.value = response.id;
                                            
                                            closeAddSeriesModal();
                                        } else {
                                            errorDiv.textContent = response.message;
                                            errorDiv.classList.remove('hidden');
                                        }
                                    } catch (e) {
                                        errorDiv.textContent = "Có lỗi xảy ra khi xử lý phản hồi từ server!";
                                        errorDiv.classList.remove('hidden');
                                    }
                                } else {
                                    errorDiv.textContent = "Có lỗi hệ thống: HTTP " + xhr.status;
                                    errorDiv.classList.remove('hidden');
                                }
                            }
                        };
                        xhr.send("seriesName=" + encodeURIComponent(seriesName) + "&brandId=" + encodeURIComponent(brandId));
                    }

                    /**
                     * Mở Modal thêm nhanh Thương hiệu (Brand) mới.
                     */
                    function openAddBrandModal() {
                        document.getElementById('newBrandName').value = "";
                        document.getElementById('addBrandError').classList.add('hidden');
                        document.getElementById('addBrandModal').classList.remove('hidden');
                    }

                    /**
                     * Đóng Modal thêm Thương hiệu.
                     */
                    function closeAddBrandModal() {
                        document.getElementById('addBrandModal').classList.add('hidden');
                    }

                    /**
                     * Gửi yêu cầu AJAX tạo mới Thương hiệu và nạp trực tiếp vào danh sách lựa chọn.
                     */
                    function submitAddBrand() {
                        const brandNameInput = document.getElementById('newBrandName');
                        const brandName = brandNameInput.value.trim();
                        const errorDiv = document.getElementById('addBrandError');
                        
                        if (!brandName) {
                            errorDiv.textContent = "Tên thương hiệu không được để trống!";
                            errorDiv.classList.remove('hidden');
                            return;
                        }
                        
                        const xhr = new XMLHttpRequest();
                        xhr.open("POST", "${pageContext.request.contextPath}/staff/brand/add", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    try {
                                        const response = JSON.parse(xhr.responseText);
                                        if (response.success) {
                                            const brandSelect = document.querySelector('select[name="brandId"]');
                                            const opt = document.createElement('option');
                                            opt.value = response.id;
                                            opt.textContent = response.name;
                                            opt.selected = true;
                                            brandSelect.appendChild(opt);
                                            
                                            // Tải lại danh sách series tương ứng với thương hiệu mới
                                            filterSeriesAndCategory();
                                            closeAddBrandModal();
                                        } else {
                                            errorDiv.textContent = response.message;
                                            errorDiv.classList.remove('hidden');
                                        }
                                    } catch (e) {
                                        errorDiv.textContent = "Có lỗi xảy ra khi xử lý phản hồi từ server!";
                                        errorDiv.classList.remove('hidden');
                                    }
                                } else {
                                    errorDiv.textContent = "Có lỗi hệ thống: HTTP " + xhr.status;
                                    errorDiv.classList.remove('hidden');
                                }
                            }
                        };
                        xhr.send("brandName=" + encodeURIComponent(brandName));
                    }

                    document.addEventListener('DOMContentLoaded', () => {
                        const categorySelect = document.querySelector('select[name="categoryId"]');
                        const brandSelect = document.querySelector('select[name="brandId"]');
                        if (categorySelect) categorySelect.addEventListener('change', filterSeriesAndCategory);
                        if (brandSelect) brandSelect.addEventListener('change', filterSeriesAndCategory);
                        
                        filterSeriesAndCategory();
                    });
                </script>

                <!-- Add Brand Modal -->
                <div id="addBrandModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
                    <div class="bg-white border border-outline-variant/35 rounded-xl shadow-2xl w-full max-w-md p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="text-lg font-bold text-on-surface">Thêm thương hiệu mới</h3>
                            <button type="button" onclick="closeAddBrandModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors flex items-center justify-center">
                                <span class="material-symbols-outlined flex items-center justify-center">close</span>
                            </button>
                        </div>
                        <div class="flex flex-col gap-4">
                            <div>
                                <label class="block text-sm font-medium text-on-surface-variant mb-1">Tên thương hiệu</label>
                                <input type="text" id="newBrandName" class="w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-on-surface" placeholder="Nhập tên thương hiệu (ví dụ: Apple, ASUS, Dell)"/>
                            </div>
                            <div id="addBrandError" class="text-red-600 text-sm hidden"></div>
                            <div class="mt-6 flex justify-end gap-3">
                                <button type="button" onclick="closeAddBrandModal()" class="px-6 py-2 border border-outline-variant/50 text-on-surface font-semibold hover:bg-surface-container-high transition-all rounded-lg text-sm">Hủy</button>
                                <button type="button" onclick="submitAddBrand()" class="px-6 py-2 bg-primary text-white font-semibold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 text-sm">Thêm</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Series Modal -->
                <div id="addSeriesModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
                    <div class="bg-white border border-outline-variant/35 rounded-xl shadow-2xl w-full max-w-md p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="text-lg font-bold text-on-surface">Thêm dòng sản phẩm mới</h3>
                            <button type="button" onclick="closeAddSeriesModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors flex items-center justify-center">
                                <span class="material-symbols-outlined flex items-center justify-center">close</span>
                            </button>
                        </div>
                        <div class="flex flex-col gap-4">
                            <div>
                                <label class="block text-sm font-medium text-on-surface-variant mb-1">Tên dòng sản phẩm</label>
                                <input type="text" id="newSeriesName" class="w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-on-surface" placeholder="Nhập tên dòng sản phẩm (ví dụ: ROG, TUF, Zenbook)"/>
                            </div>
                            <div id="addSeriesError" class="text-red-600 text-sm hidden"></div>
                            <div class="mt-6 flex justify-end gap-3">
                                <button type="button" onclick="closeAddSeriesModal()" class="px-6 py-2 border border-outline-variant/50 text-on-surface font-semibold hover:bg-surface-container-high transition-all rounded-lg text-sm">Hủy</button>
                                <button type="button" onclick="submitAddSeries()" class="px-6 py-2 bg-primary text-white font-semibold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 text-sm">Thêm</button>
                            </div>
                        </div>
                    </div>
                </div>
            </body>

            </html>
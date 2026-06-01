<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Admin - Add Product</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;family=Space+Grotesk:wght@600;700&amp;display=swap" rel="stylesheet">
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
<body class="bg-background text-on-surface font-body-md min-h-screen flex">
    <!-- Sidebar -->
    <nav class="fixed left-0 top-0 h-full w-64 bg-surface border-r border-outline-variant/20 flex flex-col py-2 z-40">
        <div class="px-6 py-4 mb-4">
            <h1 class="font-headline-md text-[24px] font-bold text-primary">UNILAP</h1>
            <p class="font-body-sm text-[12px] font-bold text-on-surface-variant uppercase tracking-wider mt-1">Admin Portal</p>
        </div>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">grid_view</span> Dashboard
        </a>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">shopping_cart</span> Orders
        </a>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg bg-surface-container-low text-primary font-label-md text-sm font-medium border-l-4 border-primary" href="${pageContext.request.contextPath}/admin/inventory">
            <span class="material-symbols-outlined icon-fill mr-3 text-[20px]">inventory_2</span> Inventory
        </a>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">group</span> Users
        </a>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">analytics</span> Analytics
        </a>
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">settings</span> Settings
        </a>
        
        <div class="mt-auto mb-4 border-t border-outline-variant/20 pt-4">
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="#">
                <span class="material-symbols-outlined mr-3 text-[20px]">help</span> Support
            </a>
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-error hover:bg-error/10 transition-colors font-label-md text-sm font-medium" href="#">
                <span class="material-symbols-outlined mr-3 text-[20px]">logout</span> Logout
            </a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 ml-64 flex flex-col min-h-screen bg-background">
        <main class="flex-1 p-8">
            <!-- Header Section -->
            <form action="${pageContext.request.contextPath}/admin/inventory/add" method="post" enctype="multipart/form-data">
                <div class="flex justify-between items-end mb-6">
                    <div>
                        <div class="flex items-center text-sm text-on-surface-variant mb-2">
                            <a href="${pageContext.request.contextPath}/admin/inventory" class="hover:text-primary transition-colors">Inventory</a>
                            <span class="material-symbols-outlined text-[16px] mx-1">chevron_right</span>
                            <span class="text-primary font-medium">Add Product</span>
                        </div>
                        <h2 class="font-headline-lg text-3xl font-bold text-on-surface">Add New Product</h2>
                    </div>
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/admin/inventory" class="px-6 py-2 bg-surface border border-outline-variant rounded-lg text-on-surface font-medium text-sm hover:bg-surface-container-low transition-colors">Cancel</a>
                        <button type="submit" class="px-6 py-2 bg-[#003ec7] text-white rounded-lg font-medium text-sm hover:bg-blue-700 transition-colors">Save Product</button>
                    </div>
                </div>

                <!-- General Information -->
                <div class="bg-surface border border-outline-variant/30 rounded-xl mb-6 shadow-sm">
                    <div class="px-6 py-4 border-b border-outline-variant/30">
                        <h3 class="text-xl font-semibold text-on-surface">General Information</h3>
                    </div>
                    
                    <div class="p-6 flex flex-col gap-8">
                        <div class="flex-1 space-y-6">
                            <!-- Product Name -->
                            <div>
                                <label class="block text-sm font-medium text-on-surface-variant mb-2">Product Name</label>
                                <input type="text" name="productName" placeholder="e.g. ZenBook Pro 16X OLED" class="w-full px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all placeholder-on-surface-variant/50" required>
                            </div>
                            
                            <div class="flex gap-6">
                                <!-- Category -->
                                <div class="flex-1">
                                    <label class="block text-sm font-medium text-on-surface-variant mb-2">Category</label>
                                    <div class="relative">
                                        <select name="categoryId" class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required>
                                            <option value="" disabled selected>Select Category</option>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.categoryId}">${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                    </div>
                                </div>
                                
                                <!-- Brand -->
                                <div class="flex-1">
                                    <label class="block text-sm font-medium text-on-surface-variant mb-2">Brand</label>
                                    <div class="relative">
                                        <select name="brandId" class="w-full appearance-none px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required>
                                            <option value="" disabled selected>Select Brand</option>
                                            <c:forEach var="b" items="${brands}">
                                                <option value="${b.brandId}">${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Description -->
                            <div>
                                <label class="block text-sm font-medium text-on-surface-variant mb-2">Description</label>
                                <div class="border border-outline-variant/50 rounded-lg overflow-hidden flex flex-col">
                                    
                                    <textarea name="description" rows="5" placeholder="Describe the product technical specifications and highlights..." class="w-full px-4 py-3 bg-surface text-on-surface resize-none focus:outline-none placeholder-on-surface-variant/50"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Thumbnail -->
                        <div class="w-full lg:w-72 flex-shrink-0">
                            <label class="block text-sm font-medium text-on-surface-variant mb-2">Product Thumbnail</label>
                            <div class="border-2 border-dashed border-outline-variant/50 rounded-xl bg-surface-container-lowest flex flex-col items-center justify-center p-6 h-[280px] hover:bg-surface-container-low transition-colors cursor-pointer relative overflow-hidden group">
                                <input type="file" name="thumbnail" class="absolute inset-0 opacity-0 cursor-pointer z-10" accept="image/*">
                                <div class="w-16 h-16 bg-[#0052ff] rounded-xl flex items-center justify-center text-white mb-4 shadow-sm group-hover:scale-105 transition-transform">
                                    <span class="material-symbols-outlined text-3xl">cloud_upload</span>
                                </div>
                                <p class="text-sm font-bold text-on-surface text-center mb-1">Click to upload or drag and drop</p>
                                <p class="text-xs text-on-surface-variant text-center">SVG, PNG, JPG or WEBP<br>(MAX. 800×400px)</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Variants -->
                <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm">
                    <div class="px-6 py-4 flex justify-between items-center border-b border-outline-variant/30">
                        <h3 class="text-xl font-semibold text-on-surface">Product Variants</h3>
                        <button type="button" onclick="addVariantRow()" class="flex items-center gap-2 px-4 py-2 bg-[#d0e1fb] text-[#003ec7] rounded-lg font-medium text-sm hover:bg-blue-200 transition-colors">
                            <span class="material-symbols-outlined text-[18px]">add_circle</span> Add Variant
                        </button>
                    </div>
                    
                    <div class="w-full">
                        <table class="w-full text-left">
                            <thead class="bg-[#2d3133] text-white text-xs font-bold tracking-wider">
                                <tr>
                                    <th class="px-6 py-4 uppercase">SKU</th>
                                    <th class="px-6 py-4 uppercase">PRICE</th>
                                    <th class="px-6 py-4 uppercase">ATTRIBUTES<br><span class="text-[10px] font-normal text-gray-300">(RAM/COLOR)</span></th>
                                    <th class="px-6 py-4 uppercase text-center">STOCK<br>QUANTITY</th>
                                    <th class="px-6 py-4 uppercase text-right">ACTIONS</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/30" id="variants-container">
                                <!-- Dynamic rows will be added here -->
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="px-6 py-4 bg-surface-container-low rounded-b-xl border-t border-outline-variant/30 text-sm text-on-surface-variant italic">
                        * SKUs are automatically validated for uniqueness against the current catalog.
                    </div>
                </div>
            </form>
        </main>
    </div>

    <!-- Scripts for dynamic functionality -->
    <script>
        // --- Xử lý xem trước ảnh (Image Preview) khi người dùng chọn file ---
        document.querySelector('input[name="thumbnail"]').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Sử dụng FileReader để đọc file ảnh dưới dạng Data URL hiển thị tạm thời
                const reader = new FileReader();
                reader.onload = function(e) {
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
                            <span class="font-bold">Change Image</span>
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
                <td class="px-6 py-5 w-1/4">
                    <input type="text" name="sku[]" placeholder="SKU-\${variantCount}" class="w-full px-3 py-2 border border-outline-variant/50 rounded bg-surface-container-low text-on-surface-variant font-mono text-sm focus:outline-none focus:border-primary" required>
                </td>
                <td class="px-6 py-5 w-1/5">
                    <div class="relative">
                        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">$</span>
                        <input type="number" step="0.01" name="price[]" placeholder="0.00" class="w-full pl-7 pr-3 py-2 border border-outline-variant/50 rounded bg-surface text-on-surface text-sm focus:outline-none focus:border-primary" required>
                    </div>
                </td>
                <td class="px-6 py-5">
                    <div class="flex flex-wrap items-center gap-2 attribute-container">
                        <button type="button" onclick="addAttribute(this)" class="text-[#003ec7] hover:bg-blue-100 rounded-full flex items-center justify-center p-1"><span class="material-symbols-outlined text-[18px]">add</span></button>
                    </div>
                    <input type="hidden" name="variantName[]" value="" class="variant-name-hidden">
                </td>
                <td class="px-6 py-5 w-32 text-center">
                    <input type="number" name="stock[]" value="0" class="w-16 px-2 py-2 border border-outline-variant/50 rounded bg-surface text-on-surface text-sm focus:outline-none focus:border-primary text-center mx-auto" required>
                </td>
                <td class="px-6 py-5 text-right">
                    <button type="button" onclick="this.closest('tr').remove()" class="text-on-surface-variant hover:text-error transition-colors p-2"><span class="material-symbols-outlined">delete</span></button>
                </td>
            `;
            variantsContainer.appendChild(tr);
        }

        // Hàm thêm thuộc tính (màu sắc, RAM...) cho biến thể bằng cách bật hộp thoại prompt
        function addAttribute(btn) {
            const attrName = prompt("Enter attribute (e.g. 32GB RAM, Midnight Black):");
            if (attrName && attrName.trim() !== "") {
                // Tạo thẻ span chứa tên thuộc tính (hiển thị dưới dạng nhãn/badge)
                const span = document.createElement('span');
                span.className = 'px-2 py-1 bg-[#d0e1fb] text-[#003ec7] text-xs font-semibold rounded cursor-pointer attribute-badge';
                span.textContent = attrName.trim();
                span.title = "Click to remove";
                span.onclick = function() { this.remove(); updateHiddenVariantName(btn.closest('td')); };
                
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

        // Khởi tạo dòng nhập biến thể đầu tiên lúc vừa load trang
        addVariantRow();
    </script>
</body>
</html>

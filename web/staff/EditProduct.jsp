<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.Product"%>
<%@page import="model.ProductVariant"%>
<%@page import="model.Category"%>
<%@page import="model.Brand"%>
<%
    Product product = (Product) request.getAttribute("product");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Brand> brands = (List<Brand>) request.getAttribute("brands");
    if (variants == null) {
        variants = new ArrayList<>();
    }
    if (categories == null) {
        categories = new ArrayList<>();
    }
    if (brands == null) {
        brands = new ArrayList<>();
    }
    NumberFormat moneyFormat = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
    int totalStock = 0;
    java.math.BigDecimal totalPrice = java.math.BigDecimal.ZERO;
    java.math.BigDecimal totalValue = java.math.BigDecimal.ZERO;
    boolean published = false;
    for (ProductVariant v : variants) {
        totalStock += v.getAvailableQuantity();
        java.math.BigDecimal price = v.getSellingPrice() == null ? java.math.BigDecimal.ZERO : v.getSellingPrice();
        totalPrice = totalPrice.add(price);
        totalValue = totalValue.add(price.multiply(java.math.BigDecimal.valueOf(v.getAvailableQuantity())));
        if ("active".equalsIgnoreCase(v.getStatus())) {
            published = true;
        }
    }
    java.math.BigDecimal avgPrice = variants.isEmpty()
            ? java.math.BigDecimal.ZERO
            : totalPrice.divide(java.math.BigDecimal.valueOf(variants.size()), 2, java.math.RoundingMode.HALF_UP);
    String productName = product == null ? "" : product.getProductName();
    String description = product == null || product.getDescription() == null ? "" : product.getDescription();
    String thumbnail = product == null ? "" : product.getThumbnail();
    boolean hasThumbnail = thumbnail != null && !thumbnail.trim().isEmpty();
%>
<!DOCTYPE html>
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Chỉnh sửa sản phẩm: <%= productName %> | UNILAP Admin</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&amp;family=Space+Grotesk:wght@600;700&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&amp;family=Space+Grotesk:wght@100..900&amp;display=swap" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .glass-nav {
            backdrop-filter: blur(12px);
            background-color: rgba(255, 255, 255, 0.7);
        }
        ::-webkit-scrollbar {
            width: 6px;
        }
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        ::-webkit-scrollbar-thumb {
            background: #e2e8f0;
            border-radius: 10px;
        }
    </style>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-container-highest": "#e0e3e5",
                        "tertiary": "#464e64",
                        "on-tertiary-fixed-variant": "#3f465c",
                        "error": "#ba1a1a",
                        "surface-container-lowest": "#ffffff",
                        "primary-container": "#0052ff",
                        "surface-tint": "#004ced",
                        "on-background": "#191c1e",
                        "outline-variant": "#c3c5d9",
                        "primary": "#003ec7",
                        "on-surface-variant": "#434656",
                        "on-tertiary": "#ffffff",
                        "primary-fixed": "#dde1ff",
                        "secondary": "#505f76",
                        "on-secondary-container": "#54647a",
                        "secondary-container": "#d0e1fb",
                        "on-tertiary-container": "#dde4ff",
                        "on-secondary-fixed-variant": "#38485d",
                        "inverse-primary": "#b7c4ff",
                        "on-primary": "#ffffff",
                        "surface-variant": "#e0e3e5",
                        "on-secondary-fixed": "#0b1c30",
                        "on-primary-fixed-variant": "#0038b6",
                        "secondary-fixed": "#d3e4fe",
                        "error-container": "#ffdad6",
                        "tertiary-fixed-dim": "#bec6e0",
                        "surface-container": "#eceef0",
                        "on-surface": "#191c1e",
                        "surface-container-high": "#e6e8ea",
                        "on-error-container": "#93000a",
                        "inverse-on-surface": "#eff1f3",
                        "primary-fixed-dim": "#b7c4ff",
                        "inverse-surface": "#2d3133",
                        "on-tertiary-fixed": "#131b2e",
                        "on-secondary": "#ffffff",
                        "on-primary-container": "#dfe3ff",
                        "tertiary-container": "#5e667d",
                        "outline": "#737688",
                        "on-error": "#ffffff",
                        "tertiary-fixed": "#dae2fd",
                        "surface-dim": "#d8dadc",
                        "surface-container-low": "#f2f4f6",
                        "background": "#f7f9fb",
                        "surface-bright": "#f7f9fb",
                        "surface": "#f7f9fb",
                        "secondary-fixed-dim": "#b7c8e1",
                        "on-primary-fixed": "#001452"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "spacing": {
                        "margin-desktop": "64px",
                        "unit": "8px",
                        "gutter": "24px",
                        "margin-mobile": "20px",
                        "container-max": "1440px"
                    },
                    "fontFamily": {
                        "headline-xl": ["Space Grotesk"],
                        "headline-lg": ["Space Grotesk"],
                        "code-sm": ["monospace"],
                        "body-md": ["Inter"],
                        "body-sm": ["Inter"],
                        "headline-md": ["Space Grotesk"],
                        "body-lg": ["Inter"],
                        "label-md": ["Inter"],
                        "headline-xl-mobile": ["Space Grotesk"]
                    },
                    "fontSize": {
                        "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                        "code-sm": ["13px", {"lineHeight": "18px", "fontWeight": "400"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "headline-xl-mobile": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}]
                    }
                },
            },
        }
    </script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>
<body class="bg-background font-body-md text-on-surface selection:bg-primary-fixed selection:text-on-primary-fixed">

<div class="layout">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>Hệ thống Quản trị</small></div>
        <nav>
            <a class="active" href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Danh mục sản phẩm</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a href="${pageContext.request.contextPath}/staff/serial"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu nhập kho</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Quản lý Đánh giá</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
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
        <!-- Main Content Area -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">
<!-- Header Section -->
<section class="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6">
<div>
<nav class="flex items-center gap-2 mb-3 text-on-surface-variant">
<a class="font-label-md text-label-md hover:text-primary transition-colors" href="${pageContext.request.contextPath}/staff/inventory">Kho hàng</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<a class="font-label-md text-label-md hover:text-primary transition-colors" href="${pageContext.request.contextPath}/staff/inventory">Sản phẩm</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<span class="font-label-md text-label-md text-on-surface">Chỉnh sửa</span>
</nav>
<h1 class="font-headline-lg text-headline-lg text-on-surface">Chỉnh sửa sản phẩm: <%= productName %></h1>
</div>
<div class="flex items-center gap-4">
<span class="hidden lg:inline text-body-sm text-on-surface-variant mr-2">Biến thể: <%= variants.size() %></span>
<a href="${pageContext.request.contextPath}/staff/inventory" class="px-6 py-2 border border-primary text-primary font-bold hover:bg-primary-container/10 transition-all rounded-lg active:scale-95 flex items-center justify-center">
                        Hủy bỏ
                    </a>
<button class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 active:scale-95">
                        Cập nhật sản phẩm
                    </button>
</div>
</section>
<!-- Grid Layout for Content -->
<div class="grid grid-cols-12 gap-gutter">
<!-- Left Column: General Information -->
<div class="col-span-12 lg:col-span-8 flex flex-col gap-gutter">
<!-- General Information Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<div class="flex items-center gap-2 mb-6 text-primary">
<span class="material-symbols-outlined" data-icon="info">info</span>
<h2 class="font-headline-md text-headline-md">Thông tin chung</h2>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<div class="col-span-2">
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Tên sản phẩm</label>
<input class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" type="text" name="productName" value="<%= productName %>"/>
</div>
<div>
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Danh mục</label>
<select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all appearance-none" name="categoryId">
<% for (Category c : categories) { %>
<option value="<%= c.getCategoryId() %>" <%= product != null && product.getCategoryId() == c.getCategoryId() ? "selected" : "" %>><%= c.getCategoryName() %></option>
<% } %>
</select>
</div>
<div>
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Thương hiệu</label>
<select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all appearance-none" name="brandId">
<% for (Brand b : brands) { %>
<option value="<%= b.getBrandId() %>" <%= product != null && product.getBrandId() == b.getBrandId() ? "selected" : "" %>><%= b.getBrandName() %></option>
<% } %>
</select>
</div>
<div class="col-span-2">
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Mô tả</label>
<div class="border border-outline-variant rounded-lg overflow-hidden">
<div class="flex items-center gap-1 p-2 bg-surface-container border-b border-outline-variant">
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_bold</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_italic</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_list_bulleted</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">link</span></button>
</div>
<textarea class="w-full p-4 bg-white border-none focus:ring-0 text-body-md outline-none" name="description" rows="6"><%= description %></textarea>
</div>
</div>
</div>
</div>
<!-- Product Variants Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<div class="flex items-center justify-between mb-6">
<div class="flex items-center gap-2 text-primary">
<span class="material-symbols-outlined" data-icon="layers">layers</span>
<h2 class="font-headline-md text-headline-md">Biến thể sản phẩm</h2>
</div>
<button class="flex items-center gap-2 px-4 py-2 bg-surface-container-high text-on-surface font-bold hover:bg-surface-container-highest transition-all rounded-lg active:scale-95">
<span class="material-symbols-outlined">add</span>
                                Thêm biến thể
                            </button>
</div>
<div class="overflow-x-auto border border-outline-variant rounded-lg">
<table class="w-full text-left border-collapse">
<thead>
<tr class="bg-inverse-surface text-white">
<th class="px-4 py-3 font-label-md text-label-md">SKU</th>
<th class="px-4 py-3 font-label-md text-label-md">Giá bán (VNĐ)</th>
<th class="px-4 py-3 font-label-md text-label-md">Thuộc tính</th>
<th class="px-4 py-3 font-label-md text-label-md text-center">Tồn kho</th>
<th class="px-4 py-3 font-label-md text-label-md text-right">Hành động</th>
</tr>
</thead>
<tbody class="divide-y divide-outline-variant">
<% if (variants.isEmpty()) { %>
<tr>
<td class="px-4 py-6 text-center text-on-surface-variant" colspan="5">Không tìm thấy biến thể nào cho sản phẩm này.</td>
</tr>
<% } else { %>
<% for (int i = 0; i < variants.size(); i++) {
    ProductVariant v = variants.get(i);
    String rowClass = (i % 2 == 0 ? "" : "bg-surface-container-low/30 ") + "hover:bg-surface-container-low transition-colors group";
    String stockClass = v.getAvailableQuantity() > 5
            ? "bg-emerald-100 text-emerald-800"
            : "bg-amber-100 text-amber-800";
    String variantName = v.getVariantName() == null ? "" : v.getVariantName();
    String variantNameAttr = variantName.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
%>
<tr class="<%= rowClass %>" data-variant-id="<%= v.getVariantId() %>" data-variant-name="<%= variantNameAttr %>">
<td class="px-4 py-4"><span class="font-code-sm text-code-sm"><%= v.getSku() %></span></td>
<td class="px-4 py-4 font-bold" data-price="<%= v.getSellingPrice() == null ? "0" : v.getSellingPrice().toPlainString() %>"><%= moneyFormat.format(v.getSellingPrice() == null ? 0 : v.getSellingPrice()) %>₫</td>
<td class="px-4 py-4">
<div class="flex flex-wrap gap-2">
<% if (variantName.trim().isEmpty()) { %>
<span class="text-on-surface-variant text-body-sm">Không có thuộc tính</span>
<% } else {
    String[] attrs = variantName.split("\\s*/\\s*|\\s*,\\s*");
    for (String attr : attrs) {
        if (attr != null && !attr.trim().isEmpty()) {
%>
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold"><%= attr.trim() %></span>
<%      }
    }
} %>
</div>
</td>
<td class="px-4 py-4 text-center">
<span class="px-3 py-1 <%= stockClass %> text-[12px] rounded-full font-bold"><%= v.getAvailableQuantity() %></span>
</td>
<td class="px-4 py-4 text-right">
<div class="flex justify-end gap-2">
<button type="button" onclick="openEditVariantModal(this)" class="p-1 hover:text-primary transition-colors"><span class="material-symbols-outlined text-[20px]">edit</span></button>
<button class="p-1 hover:text-error transition-colors"><span class="material-symbols-outlined text-[20px]">delete</span></button>
</div>
</td>
</tr>
<% } %>
<% } %>
</tbody>
</table>
</div>
</div>
</div>
<!-- Right Column: Thumbnail & Stats -->
<div class="col-span-12 lg:col-span-4 flex flex-col gap-gutter">
<!-- Thumbnail Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<div class="flex items-center justify-between mb-6">
<div class="flex items-center gap-2 text-primary">
<span class="material-symbols-outlined" data-icon="image">image</span>
<h2 class="font-headline-md text-headline-md">Ảnh đại diện</h2>
</div>
<button class="text-primary font-bold text-label-md hover:underline">Thay đổi ảnh</button>
</div>
<div class="bg-surface-container rounded-lg overflow-hidden border border-outline-variant group relative aspect-video flex items-center justify-center">
<% if (hasThumbnail) { %>
<img alt="<%= productName %> Thumbnail" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" src="${pageContext.request.contextPath}/images/<%= thumbnail %>"/>
<% } else { %>
<div class="text-center text-on-surface-variant">
<span class="material-symbols-outlined text-5xl mb-2">image_not_supported</span>
<p>Không có ảnh đại diện</p>
</div>
<% } %>
<div class="absolute inset-0 bg-primary/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
<span class="material-symbols-outlined text-white text-4xl">zoom_in</span>
</div>
</div>
<p class="mt-4 text-center text-on-surface-variant text-body-sm">
                            Định dạng hỗ trợ: JPG, PNG, WEBP. Dung lượng tối đa: 2MB.
                        </p>
</div>
<!-- Meta Data / Quick Stats Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<h2 class="font-headline-md text-headline-md text-primary mb-6">Tổng quan tồn kho</h2>
<div class="space-y-4">
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Tổng tồn kho</span>
<span class="font-bold"><%= totalStock %> sản phẩm</span>
</div>
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Giá bán trung bình</span>
<span class="font-bold"><%= moneyFormat.format(avgPrice) %>₫</span>
</div>
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Tổng giá trị</span>
<span class="font-bold text-primary"><%= moneyFormat.format(totalValue) %>₫</span>
</div>
<div class="flex justify-between items-center py-2">
<span class="text-on-surface-variant text-body-sm">Trạng thái hiển thị</span>
<div class="flex items-center gap-2">
<span class="w-3 h-3 <%= published ? "bg-emerald-500" : "bg-amber-500" %> rounded-full"></span>
<span class="font-bold <%= published ? "text-emerald-600" : "text-amber-600" %> uppercase text-[12px]"><%= published ? "Đang hiển thị" : "Đã ẩn" %></span>
</div>
</div>
</div>
</div>

                        </div>
                    </div>
                </main>
    </div>
</div>

<!-- Edit Variant Modal -->
<div id="editVariantModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-md p-6">
        <div class="flex items-center justify-between mb-6">
            <h3 class="font-headline-md text-headline-md font-bold text-on-surface">Chỉnh sửa biến thể</h3>
            <button type="button" onclick="closeEditVariantModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/staff/inventory/edit" method="post" class="flex flex-col gap-4">
            <input type="hidden" name="action" value="updateVariant"/>
            <input type="hidden" name="variantId" id="editVariantId" value=""/>
            
            <div>
                <label class="block font-label-md text-label-md text-on-surface-variant mb-1">SKU</label>
                <input type="text" name="sku" id="editSku" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
            </div>
            
            <div>
                <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Thuộc tính biến thể</label>
                <input type="text" name="variantName" id="editVariantName" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
            </div>
            
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Giá bán (VNĐ)</label>
                    <input type="number" step="1" name="price" id="editPrice" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Tồn kho (Chỉ đọc)</label>
                    <input type="number" name="stock" id="editStock" class="w-full px-4 py-3 bg-slate-100 text-on-surface-variant/70 border border-outline-variant rounded-lg cursor-not-allowed outline-none transition-all" readonly required/>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end gap-3">
                <button type="button" onclick="closeEditVariantModal()" class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg">Hủy</button>
                <button type="submit" class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Simple Interaction: Change button state on click
    const updateBtn = document.querySelector('button.bg-primary');
    if (updateBtn) {
        updateBtn.addEventListener('click', () => {
            const originalContent = updateBtn.innerHTML;
            updateBtn.innerHTML = '<span class="material-symbols-outlined animate-spin">sync</span> Đang cập nhật...';
            updateBtn.classList.add('opacity-80');
            setTimeout(() => {
                updateBtn.innerHTML = '<span class="material-symbols-outlined">check_circle</span> Đã cập nhật';
                updateBtn.classList.replace('bg-primary', 'bg-emerald-600');
                setTimeout(() => {
                    updateBtn.innerHTML = originalContent;
                    updateBtn.classList.replace('bg-emerald-600', 'bg-primary');
                    updateBtn.classList.remove('opacity-80');
                }, 2000);
            }, 1200);
        });
    }

    // Add a subtle parallax effect to the product image on mouse move
    const cardImg = document.querySelector('.group img');
    if (cardImg) {
        cardImg.parentElement.addEventListener('mousemove', (e) => {
            const { left, top, width, height } = cardImg.parentElement.getBoundingClientRect();
            const x = (e.clientX - left) / width - 0.5;
            const y = (e.clientY - top) / height - 0.5;
            cardImg.style.transform = `scale(1.1) translate(${x * 10}px, ${y * 10}px)`;
        });
        cardImg.parentElement.addEventListener('mouseleave', () => {
            cardImg.style.transform = `scale(1) translate(0, 0)`;
        });
    }

    function openEditVariantModal(btn) {
        const tr = btn.closest('tr');
        const sku = tr.querySelector('td:nth-child(1) span').innerText.trim();
        const priceCell = tr.querySelector('td:nth-child(2)');
        const priceText = priceCell.dataset.price || priceCell.innerText.replace(/[^\d.]/g, '').trim();
        
        const attrSpans = tr.querySelectorAll('td:nth-child(3) span');
        let variantName = tr.dataset.variantName || Array.from(attrSpans).map(s => s.innerText.trim()).join(', ');
        
        const stock = tr.querySelector('td:nth-child(4) span').innerText.trim();
        
        const variantId = tr.dataset.variantId || 1;
        
        document.getElementById('editVariantId').value = variantId;
        document.getElementById('editSku').value = sku;
        document.getElementById('editVariantName').value = variantName;
        document.getElementById('editPrice').value = priceText;
        document.getElementById('editStock').value = stock;
        
        document.getElementById('editVariantModal').classList.remove('hidden');
    }

    function closeEditVariantModal() {
        document.getElementById('editVariantModal').classList.add('hidden');
    }
</script>
</body>
</html>


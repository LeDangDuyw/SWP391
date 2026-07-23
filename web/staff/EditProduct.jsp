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
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="inventory"/>
    </jsp:include>

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
<button form="productForm" type="submit" class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 active:scale-95">
                        Cập nhật sản phẩm
                    </button>
</div>
</section>
<!-- Grid Layout for Content -->
<div class="grid grid-cols-12 gap-gutter">
<!-- Left Column: General Information -->
<div class="col-span-12 lg:col-span-8 flex flex-col gap-gutter">
<!-- General Information Card -->
<form id="productForm" action="${pageContext.request.contextPath}/staff/inventory/edit" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="updateProduct"/>
    <input type="hidden" name="productId" value="<%= product != null ? product.getProductId() : "" %>"/>
    <input type="hidden" name="variantId" value="${selectedVariantId}"/>
    <div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
        <div class="flex items-center gap-2 mb-6 text-primary">
            <span class="material-symbols-outlined" data-icon="info">info</span>
            <h2 class="font-headline-md text-headline-md">Thông tin chung</h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="col-span-3">
                <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Tên sản phẩm</label>
                <input class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" type="text" name="productName" value="<%= productName %>" required/>
            </div>
            <div class="col-span-1">
                <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Danh mục</label>
                <div class="relative">
                    <select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none appearance-none" name="categoryId" onchange="filterSeriesAndCategory()">
                        <% for (Category c : categories) { %>
                            <option value="<%= c.getCategoryId() %>" <%= product != null && product.getCategoryId() == c.getCategoryId() ? "selected" : "" %>><%= c.getCategoryName() %></option>
                        <% } %>
                    </select>
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                </div>
            </div>
            <div class="col-span-1">
                <div class="flex items-center justify-between mb-2">
                    <label class="block font-label-md text-label-md text-on-surface-variant">Thương hiệu</label>
                    <button type="button" onclick="openAddBrandModal()" class="text-xs text-primary hover:underline flex items-center gap-1 font-semibold">
                        <span class="material-symbols-outlined text-[14px]">add</span>Thêm thương hiệu
                    </button>
                </div>
                <div class="relative">
                    <select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none appearance-none" name="brandId" id="brandId" onchange="filterSeriesAndCategory()">
                        <% for (Brand b : brands) { %>
                            <option value="<%= b.getBrandId() %>" <%= product != null && product.getBrandId() == b.getBrandId() ? "selected" : "" %>><%= b.getBrandName() %></option>
                        <% } %>
                    </select>
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                </div>
            </div>
            <div class="col-span-1">
                <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Thời gian bảo hành (tháng)</label>
                <input class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none" type="number" name="warrantyPeriod" min="0" value="<%= product != null ? product.getWarrantyPeriod() : 0 %>" required/>
            </div>
            <div class="col-span-1">
                <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Nhu cầu sử dụng</label>
                <%
                    String currentPurpose = product != null ? product.getPurpose() : "";
                    boolean isCustomPurpose = false;
                    if (currentPurpose != null && !currentPurpose.trim().isEmpty()) {
                        if (!"Học tập - Văn phòng".equals(currentPurpose) && 
                            !"Đồ họa - Kỹ thuật".equals(currentPurpose) && 
                            !"Gaming - Trải nghiệm".equals(currentPurpose) && 
                            !"Cao cấp - Sang trọng".equals(currentPurpose) && 
                            !"Tài chính - Kế toán".equals(currentPurpose)) {
                            isCustomPurpose = true;
                        }
                    }
                %>
                <div class="flex flex-col gap-2">
                    <div class="relative">
                        <select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none appearance-none" name="purposeSelect" id="purposeSelect" onchange="toggleCustomPurpose(this, 'purposeCustom')">
                            <option value="">-- Chọn nhu cầu --</option>
                            <option value="Học tập - Văn phòng" <%= "Học tập - Văn phòng".equals(currentPurpose) ? "selected" : "" %>>Học tập - Văn phòng</option>
                            <option value="Đồ họa - Kỹ thuật" <%= "Đồ họa - Kỹ thuật".equals(currentPurpose) ? "selected" : "" %>>Đồ họa - Kỹ thuật</option>
                            <option value="Gaming - Trải nghiệm" <%= "Gaming - Trải nghiệm".equals(currentPurpose) ? "selected" : "" %>>Gaming - Trải nghiệm</option>
                            <option value="Cao cấp - Sang trọng" <%= "Cao cấp - Sang trọng".equals(currentPurpose) ? "selected" : "" %>>Cao cấp - Sang trọng</option>
                            <option value="Tài chính - Kế toán" <%= "Tài chính - Kế toán".equals(currentPurpose) ? "selected" : "" %>>Tài chính - Kế toán</option>
                            <option value="Khác" <%= isCustomPurpose ? "selected" : "" %>>Khác...</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                    </div>
                    <input type="text" name="purposeCustom" id="purposeCustom" placeholder="Nhập nhu cầu khác..." value="<%= isCustomPurpose ? currentPurpose : "" %>"
                        class="<%= isCustomPurpose ? "" : "hidden" %> w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none" <%= isCustomPurpose ? "required" : "" %>>
                </div>
            </div>
            <div class="col-span-1" id="series-container">
                <div class="flex items-center justify-between mb-2">
                    <label class="block font-label-md text-label-md text-on-surface-variant">Dòng sản phẩm</label>
                    <button type="button" onclick="openAddSeriesModal()" class="text-xs text-primary hover:underline flex items-center gap-1 font-semibold">
                        <span class="material-symbols-outlined text-[14px]">add</span>Thêm dòng sản phẩm
                    </button>
                </div>
                <div class="relative">
                    <select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none appearance-none" name="seriesId" id="seriesId">
                        <option value="">-- Chọn dòng sản phẩm --</option>
                    </select>
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant">expand_more</span>
                </div>
            </div>
            <div class="col-span-3">
                <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Mô tả</label>
                <div class="border border-outline-variant rounded-lg overflow-hidden">
                    <div class="flex items-center gap-1 p-2 bg-surface-container border-b border-outline-variant">
                        <button type="button" class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_bold</span></button>
                        <button type="button" class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_italic</span></button>
                        <button type="button" class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_list_bulleted</span></button>
                        <button type="button" class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">link</span></button>
                    </div>
                    <textarea class="w-full p-4 bg-white border-none focus:ring-0 text-body-md outline-none" name="description" rows="6"><%= description %></textarea>
                </div>
            </div>
        </div>
    </div>
</form>
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
<th class="px-4 py-3 font-label-md text-label-md">Giá nhập (VNĐ)</th>
<th class="px-4 py-3 font-label-md text-label-md">Giá bán (VNĐ)</th>
<th class="px-4 py-3 font-label-md text-label-md">Thuộc tính / Cấu hình</th>
<th class="px-4 py-3 font-label-md text-label-md text-center">Tồn kho</th>
<th class="px-4 py-3 font-label-md text-label-md text-right">Hành động</th>
</tr>
</thead>
<tbody class="divide-y divide-outline-variant">
<% if (variants.isEmpty()) { %>
<tr>
<td class="px-4 py-6 text-center text-on-surface-variant" colspan="6">Không tìm thấy biến thể nào cho sản phẩm này.</td>
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
<tr class="<%= rowClass %>" 
    data-variant-id="<%= v.getVariantId() %>" 
    data-sku="<%= v.getSku() %>"
    data-import-price="<%= v.getImportPrice() == null ? "0" : v.getImportPrice().toPlainString() %>"
    data-price="<%= v.getSellingPrice() == null ? "0" : v.getSellingPrice().toPlainString() %>"
    data-stock="<%= v.getAvailableQuantity() %>"
    data-variant-name="<%= variantNameAttr %>">
<td class="px-4 py-4"><span class="font-code-sm text-code-sm"><%= v.getSku() %></span></td>
<td class="px-4 py-4 text-on-surface-variant font-medium"><%= moneyFormat.format(v.getImportPrice() == null ? 0 : v.getImportPrice()) %>₫</td>
<td class="px-4 py-4 font-bold text-primary"><%= moneyFormat.format(v.getSellingPrice() == null ? 0 : v.getSellingPrice()) %>₫</td>
<td class="px-4 py-4">
<div class="flex flex-wrap gap-2">
<% if (variantName.trim().isEmpty()) { %>
<span class="text-on-surface-variant text-body-sm">Mặc định</span>
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
<button type="button" onclick="openEditVariantModal(this)" class="px-3 py-1.5 bg-primary/10 text-primary hover:bg-primary hover:text-white rounded-lg text-xs font-bold transition-all flex items-center gap-1">
    <span class="material-symbols-outlined text-[16px]">edit</span>Sửa
</button>
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

<!-- Edit Variant Modal -->
<div id="editVariantModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-xl p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between mb-6 pb-3 border-b border-outline-variant">
            <h3 class="font-headline-md text-headline-md font-bold text-on-surface">Chỉnh sửa biến thể</h3>
            <button type="button" onclick="closeEditVariantModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/staff/inventory/edit" method="post" enctype="multipart/form-data" class="flex flex-col gap-4">
            <input type="hidden" name="action" value="updateVariant"/>
            <input type="hidden" name="variantId" id="editVariantId" value=""/>
            <input type="hidden" name="productId" value="<%= product != null ? product.getProductId() : "" %>"/>
            
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Mã SKU</label>
                    <input type="text" name="sku" id="editSku" class="w-full px-4 py-2.5 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Tên cấu hình / Thuộc tính</label>
                    <input type="text" name="variantName" id="editVariantName" placeholder="VD: 8GB, 16GB..." class="w-full px-4 py-2.5 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
            </div>
            
            <div class="grid grid-cols-3 gap-4">
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Giá nhập (VNĐ)</label>
                    <input type="number" step="1" min="0" name="importPrice" id="editImportPrice" class="w-full px-4 py-2.5 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Giá bán (VNĐ)</label>
                    <input type="number" step="1" min="0" name="price" id="editPrice" class="w-full px-4 py-2.5 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Tồn kho (Chỉ đọc)</label>
                    <input type="number" name="stock" id="editStock" class="w-full px-4 py-2.5 bg-slate-100 text-on-surface-variant/70 border border-outline-variant rounded-lg cursor-not-allowed outline-none transition-all" readonly required/>
                </div>
            </div>

            <div>
                <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Ảnh đại diện biến thể (Tùy chọn)</label>
                <input type="file" name="variantThumbnail" accept="image/*" class="w-full px-3 py-2 border border-outline-variant rounded-lg text-sm bg-white outline-none">
            </div>

            <!-- Dynamic Category Specifications -->
            <div class="border-t border-outline-variant pt-4 mt-2">
                <h4 class="font-bold text-sm text-primary mb-3 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[18px]">tune</span>Thông số kỹ thuật chi tiết
                </h4>
                <div id="editVariantSpecsContainer" class="grid grid-cols-2 gap-3">
                    <p class="text-xs text-slate-500 animate-pulse col-span-2">Đang tải thông số kỹ thuật...</p>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end gap-3 pt-3 border-t border-outline-variant">
                <button type="button" onclick="closeEditVariantModal()" class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg text-sm">Hủy</button>
                <button type="submit" class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 text-sm">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>
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

    function previewMainThumb(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.getElementById('mainProductPreview');
                if (img) {
                    img.src = e.target.result;
                    img.classList.remove('hidden');
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    /**
     * Mở modal chỉnh sửa thông tin biến thể sản phẩm và điền thông tin hiện tại vào form.
     * @param {HTMLElement} btn Nút Chỉnh sửa trên dòng tương ứng
     */
    function openEditVariantModal(btn) {
        const tr = btn.closest('tr');
        const variantId = tr.dataset.variantId;
        const sku = tr.dataset.sku || '';
        const importPrice = tr.dataset.importPrice || '0';
        const price = tr.dataset.price || '0';
        const variantName = tr.dataset.variantName || '';
        const stock = tr.dataset.stock || '0';
        
        document.getElementById('editVariantId').value = variantId;
        document.getElementById('editSku').value = sku;
        document.getElementById('editVariantName').value = variantName;
        document.getElementById('editImportPrice').value = Math.round(parseFloat(importPrice));
        document.getElementById('editPrice').value = Math.round(parseFloat(price));
        document.getElementById('editStock').value = stock;
        
        loadEditVariantSpecs(variantId);
        
        document.getElementById('editVariantModal').classList.remove('hidden');
    }

    function loadEditVariantSpecs(variantId) {
        const container = document.getElementById('editVariantSpecsContainer');
        if (!container) return;
        const categorySelect = document.querySelector('select[name="categoryId"]');
        const categoryId = categorySelect ? categorySelect.value : '1';
        container.innerHTML = '<p class="text-xs text-slate-500 animate-pulse col-span-2">Đang tải thông số kỹ thuật...</p>';

        Promise.all([
            fetch('${pageContext.request.contextPath}/staff/category?action=getSpecs&categoryId=' + categoryId).then(r => r.json()),
            fetch('${pageContext.request.contextPath}/staff/category?action=getVariantSpecs&variantId=' + variantId).then(r => r.json()).catch(() => ({specs: {}}))
        ]).then(([catData, varData]) => {
            const catSpecs = catData.categorySpecs || [];
            const currentSpecs = varData.specs || {};
            container.innerHTML = '';
            if (catSpecs.length === 0) {
                container.innerHTML = '<p class="text-xs text-slate-400 italic col-span-2">Không có thông số kỹ thuật riêng cho danh mục này.</p>';
                return;
            }
            catSpecs.forEach(spec => {
                const val = currentSpecs[spec.specId] || '';
                const div = document.createElement('div');
                div.className = 'flex flex-col gap-1';
                div.innerHTML = `
                    <label class="text-[12px] font-semibold text-slate-700">\${spec.specName}</label>
                    <input type="text" name="spec_\${spec.specId}" value="\${val.replace(/"/g, '&quot;')}" placeholder="\${spec.specName}..." class="w-full px-3 py-2 border border-outline-variant rounded-lg text-sm bg-white focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none">
                `;
                container.appendChild(div);
            });
        }).catch(err => {
            container.innerHTML = '<p class="text-xs text-slate-400 italic col-span-2">Không thể tải thông số kỹ thuật.</p>';
        });
    }

    /**
     * Đóng modal chỉnh sửa biến thể sản phẩm.
     */
    function closeEditVariantModal() {
        document.getElementById('editVariantModal').classList.add('hidden');
    }

    // --- Xử lý lọc dòng sản phẩm động theo hãng và ẩn/hiện theo danh mục cho Edit ---
    const allSeries = [
        <% List<model.ProductSeries> seriesList = (List<model.ProductSeries>) request.getAttribute("serieses");
           if (seriesList != null) {
               for (int i = 0; i < seriesList.size(); i++) {
                   model.ProductSeries s = seriesList.get(i);
        %>
            { id: <%= s.getSeriesId() %>, name: "<%= s.getSeriesName().replace("\"", "\\\"") %>", brandId: <%= s.getBrandId() %> }<%= i < seriesList.size() - 1 ? "," : "" %>
        <%     }
           }
        %>
    ];

    const initialSeriesId = <%= product != null ? product.getSeriesId() : 0 %>;

    /**
     * Lọc danh sách Dòng sản phẩm (Series) động theo Thương hiệu (Brand) được chọn cho màn hình cập nhật sản phẩm.
     */
    function filterSeriesAndCategory() {
        const categorySelect = document.querySelector('select[name="categoryId"]');
        const brandSelect = document.querySelector('select[name="brandId"]');
        const seriesSelect = document.getElementById('seriesId');
        const seriesContainer = document.getElementById('series-container');

        if (!categorySelect || !brandSelect || !seriesSelect || !seriesContainer) return;

        const selectedCategoryId = categorySelect.value;
        const selectedBrandId = parseInt(brandSelect.value) || 0;

        // Chỉ danh mục Laptop (categoryId = 1) mới hiển thị dòng sản phẩm (Series)
        if (selectedCategoryId === "1") {
            seriesContainer.style.display = "block";
            seriesSelect.disabled = false;

            // Lấy giá trị được chọn hiện tại (hoặc giá trị ban đầu nếu mới load)
            let currentVal = seriesSelect.value || initialSeriesId;

            seriesSelect.innerHTML = '<option value="">-- Chọn dòng sản phẩm --</option>';

            const filtered = allSeries.filter(s => s.brandId === selectedBrandId);
            filtered.forEach(s => {
                const opt = document.createElement('option');
                opt.value = s.id;
                opt.textContent = s.name;
                if (parseInt(currentVal) === s.id) {
                    opt.selected = true;
                }
                seriesSelect.appendChild(opt);
            });
        } else {
            // Ẩn dropdown dòng sản phẩm nếu không phải laptop
            seriesContainer.style.display = "none";
            seriesSelect.value = "";
            seriesSelect.disabled = true;
        }
    }

    /**
     * Ẩn/hiện ô nhập dữ liệu tùy chỉnh khi chọn tùy chọn "Khác".
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
     * Gửi yêu cầu AJAX tạo mới Dòng sản phẩm và cập nhật danh sách chọn.
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
                            
                            // Cập nhật lại dropdown và chọn phần tử mới
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

    function openAddBrandModal() {
        document.getElementById('newBrandName').value = "";
        document.getElementById('addBrandError').classList.add('hidden');
        document.getElementById('addBrandModal').classList.remove('hidden');
    }

    function closeAddBrandModal() {
        document.getElementById('addBrandModal').classList.add('hidden');
    }

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


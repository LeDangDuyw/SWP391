<%-- 
    Document   : AddProductImei
    Created on : Jun 14, 2026, 4:50:41 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Add New Serial - UNILAP Staff</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&family=Space+Grotesk:wght@100..900&display=swap" rel="stylesheet"/>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .glass-effect {
            backdrop-filter: blur(12px);
            background: rgba(255, 255, 255, 0.7);
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
        ::-webkit-scrollbar-thumb:hover {
            background: #cbd5e1;
        }
    </style>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-error": "#ffffff",
                        "on-tertiary-container": "#dde4ff",
                        "surface-container-highest": "#e0e3e5",
                        "surface-variant": "#e0e3e5",
                        "on-error-container": "#93000a",
                        "outline": "#737688",
                        "tertiary-fixed-dim": "#bec6e0",
                        "tertiary": "#464e64",
                        "on-tertiary-fixed-variant": "#3f465c",
                        "on-primary": "#ffffff",
                        "inverse-on-surface": "#eff1f3",
                        "background": "#f7f9fb",
                        "primary-fixed-dim": "#b7c4ff",
                        "on-surface": "#191c1e",
                        "secondary-fixed-dim": "#b7c8e1",
                        "primary-fixed": "#dde1ff",
                        "on-surface-variant": "#434656",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary": "#ffffff",
                        "on-primary-fixed-variant": "#0038b6",
                        "secondary": "#505f76",
                        "primary": "#003ec7",
                        "on-secondary-fixed": "#0b1c30",
                        "on-background": "#191c1e",
                        "inverse-surface": "#2d3133",
                        "surface-container": "#eceef0",
                        "surface-container-low": "#f2f4f6",
                        "surface-bright": "#f7f9fb",
                        "on-secondary-container": "#54647a",
                        "secondary-container": "#d0e1fb",
                        "secondary-fixed": "#d3e4fe",
                        "tertiary-fixed": "#dae2fd",
                        "error": "#ba1a1a",
                        "on-primary-fixed": "#001452",
                        "on-primary-container": "#dfe3ff",
                        "primary-container": "#0052ff",
                        "surface-dim": "#d8dadc",
                        "surface-tint": "#004ced",
                        "on-secondary": "#ffffff",
                        "outline-variant": "#c3c5d9",
                        "inverse-primary": "#b7c4ff",
                        "on-tertiary-fixed": "#131b2e",
                        "tertiary-container": "#5e667d",
                        "surface-container-high": "#e6e8ea",
                        "error-container": "#ffdad6",
                        "surface": "#f7f9fb",
                        "on-secondary-fixed-variant": "#38485d"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "spacing": {
                        "container-max": "1440px",
                        "gutter": "24px",
                        "unit": "8px",
                        "margin-mobile": "20px",
                        "margin-desktop": "64px"
                    },
                    "fontFamily": {
                        "headline-xl": ["Space Grotesk"],
                        "label-md": ["Inter"],
                        "body-md": ["Inter"],
                        "headline-md": ["Space Grotesk"],
                        "code-sm": ["monospace"],
                        "headline-lg": ["Space Grotesk"],
                        "body-sm": ["Inter"],
                        "headline-xl-mobile": ["Space Grotesk"],
                        "body-lg": ["Inter"]
                    },
                    "fontSize": {
                        "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                        "code-sm": ["13px", {"lineHeight": "18px", "fontWeight": "400"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "headline-xl-mobile": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}]
                    }
                },
            },
        }
    </script>
</head>
<body class="bg-background text-on-background font-body-md">
<!-- SideNavBar Component -->
<aside class="w-64 h-screen fixed left-0 top-0 bg-surface-container-lowest border-r border-outline-variant flex flex-col p-4 z-50">
<div class="mb-8 px-2">
<h1 class="font-headline-md text-headline-md font-bold text-primary">UNILAP Staff</h1>
<p class="font-body-sm text-body-sm text-on-surface-variant">Admin Portal</p>
</div>
<nav class="flex-1 space-y-1">
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="${pageContext.request.contextPath}/admin/dashboard">
<span class="material-symbols-outlined" data-icon="dashboard">dashboard</span>
                Dashboard
            </a>
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="${pageContext.request.contextPath}/staff/inventory">
<span class="material-symbols-outlined" data-icon="inventory_2">inventory_2</span>
                Inventory
            </a>
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="${pageContext.request.contextPath}/staff/category">
<span class="material-symbols-outlined" data-icon="category">category</span>
                Category
            </a>
<a class="flex items-center gap-3 px-4 py-3 bg-secondary-container text-on-secondary-container rounded-lg font-label-md text-label-md" href="${pageContext.request.contextPath}/staff/imei">
<span class="material-symbols-outlined" data-icon="barcode_scanner">barcode_scanner</span>
                IMEI
            </a>
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="${pageContext.request.contextPath}/staff/ticket/list">
<span class="material-symbols-outlined" data-icon="receipt_long">receipt_long</span>
                Tickets
            </a>
</nav>
<div class="mt-auto pt-4 border-t border-outline-variant">
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="#">
<span class="material-symbols-outlined" data-icon="settings">settings</span>
                Settings
            </a>
<a class="flex items-center gap-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-high transition-colors rounded-lg font-label-md text-label-md" href="#">
<span class="material-symbols-outlined" data-icon="logout">logout</span>
                Logout
            </a>
<div class="mt-4 flex items-center gap-3 px-2">
<div class="w-8 h-8 rounded-full bg-secondary-container flex items-center justify-center overflow-hidden">
<img alt="Staff Profile" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCmZ0PhCwJquC1EUCFzkfKPxJBNCYg4O2Zt4fKmR3dgAyEXLUu2jndg3DT7cSuE4CbWJfNqKFUhUQbUt6y3P6Cp-WtRasCisHzKbLxBT80VABuSr3l9Qm_6KfqiLmxbm9Dbqar6L1ue4EkaisdH3ENRJCIbnpqp5ouVIYhGmbC-ejmATQQNT5dN1pfrv6DZIivvjT5AUKtdtuQ8b5_hBfHTcgcbeL_U8I2wTzHkxHuXVFMNwyKli06qVZ_GMHS-0Y2Z0uhiHzdAgOZ6"/>
</div>
<div>
<p class="font-label-md text-label-md text-on-surface">Alex Rivera</p>
<p class="text-[10px] uppercase tracking-wider text-outline">Warehouse Lead</p>
</div>
</div>
</div>
</aside>
<!-- TopNavBar Component -->
<header class="fixed top-0 right-0 w-[calc(100%-16rem)] h-16 bg-surface border-b border-outline-variant flex justify-between items-center px-gutter z-40">
<div class="flex items-center flex-1 max-w-xl">
<div class="relative w-full">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-sm" data-icon="search">search</span>
<input class="w-full bg-surface-container-low border-none rounded-full pl-10 pr-4 py-2 text-body-sm focus:ring-2 focus:ring-primary/20 transition-all" placeholder="Search serial numbers, models, or batches..." type="text"/>
</div>
</div>
<div class="flex items-center gap-4">
<button class="p-2 text-on-surface-variant hover:bg-surface-container-high rounded-full transition-transform active:scale-90">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
</button>
<button class="p-2 text-on-surface-variant hover:bg-surface-container-high rounded-full transition-transform active:scale-90">
<span class="material-symbols-outlined" data-icon="help_outline">help_outline</span>
</button>
</div>
</header>
<!-- Main Content Area -->
<main class="ml-64 mt-16 p-gutter min-h-[calc(100vh-4rem)]">
<!-- Breadcrumbs & Header -->
<nav class="mb-6">
<ol class="flex items-center gap-2 text-on-surface-variant font-label-md text-label-md">
<li>Inventory</li>
<li class="flex items-center gap-2"><span class="material-symbols-outlined text-sm" data-icon="chevron_right">chevron_right</span>Serial Management</li>
<li class="flex items-center gap-2 text-primary"><span class="material-symbols-outlined text-sm text-on-surface-variant" data-icon="chevron_right">chevron_right</span>Add New Serial</li>
</ol>
<h2 class="font-headline-lg text-headline-lg mt-2 text-on-surface">Add New Serial / IMEI</h2>
</nav>
<div class="max-w-5xl">
<c:if test="${not empty param.error}">
    <div class="mb-6 flex items-center gap-3 px-4 py-3 bg-[#ffdad6] border border-[#ba1a1a]/20 rounded-xl text-[#ba1a1a] font-label-md text-label-md">
        <span class="material-symbols-outlined text-[20px]">error</span>
        <c:choose>
            <c:when test="${param.error == 'TooManyImeis'}">
                Lỗi: Bạn nhập thừa IMEI! Yêu cầu nhập đúng ${param.expected} IMEI (Bạn đã nhập ${param.actual}).
            </c:when>
            <c:when test="${param.error == 'TooFewImeis'}">
                Lỗi: Bạn nhập thiếu IMEI! Yêu cầu nhập đủ ${param.expected} IMEI (Bạn đã nhập ${param.actual}).
            </c:when>
            <c:when test="${param.error == 'MissingRequiredFields'}">
                Lỗi: Vui lòng điền đầy đủ các trường yêu cầu.
            </c:when>
            <c:when test="${param.error == 'MismatchLists'}">
                Lỗi: Số lượng IMEI, Serial Number và Barcode nhập vào không khớp nhau. Vui lòng kiểm tra lại.
            </c:when>
            <c:otherwise>
                Đã xảy ra lỗi: ${param.error}
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
<form action="${pageContext.request.contextPath}/staff/imei/add" method="POST" class="space-y-6">
<input type="hidden" name="ticketId" value="${param.ticketId}">
<!-- Section 1: Product Information -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center gap-2 mb-6 text-primary">
<span class="material-symbols-outlined" data-icon="laptop_mac">laptop_mac</span>
<h3 class="font-headline-md text-headline-md">Product Information</h3>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Parent Product</label>
<select id="productSelect" onchange="filterVariants()" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none">
<option value="" disabled selected>Select a Product</option>
<c:forEach var="p" items="${products}">
    <option value="${p.productId}">${p.productName}</option>
</c:forEach>
</select>
</div>
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Variant</label>
<select id="variantSelect" name="variantId" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none">
<option value="" disabled selected>Select a Variant</option>
<c:forEach var="v" items="${variants}">
    <option value="${v.variantId}" data-product-id="${v.productId}">${v.sku} - ${v.variantName}</option>
</c:forEach>
</select>
</div>
</div>
</div>
<!-- Section 2: Unit Details -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center justify-between mb-6">
<div class="flex items-center gap-2 text-primary">
<span class="material-symbols-outlined" data-icon="qr_code_scanner">qr_code_scanner</span>
<h3 class="font-headline-md text-headline-md">Unit Details</h3>
</div>
<span class="font-label-md text-label-md px-3 py-1 bg-surface-container-high rounded-full text-on-surface-variant">Bulk Entry Mode</span>
</div>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">IMEI Numbers (one per line)</label>
<textarea name="serials" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-3 font-code-sm text-code-sm focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none resize-none" rows="6"></textarea>
</div>
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Serial Numbers (one per line)</label>
<textarea name="serialNumbers" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-3 font-code-sm text-code-sm focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none resize-none" rows="6"></textarea>
</div>
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Barcodes (one per line)</label>
<textarea name="barcodes" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-3 font-code-sm text-code-sm focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none resize-none" rows="6"></textarea>
</div>
</div>
</div>
<!-- Section 3: Storage & Status -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center gap-2 mb-6 text-primary">
<span class="material-symbols-outlined" data-icon="inventory_2">inventory_2</span>
<h3 class="font-headline-md text-headline-md">Storage & Status</h3>
</div>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Warehouse Location</label>
<input name="warehouseLocation" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" type="text" placeholder="e.g. Shelf A1"/>
</div>
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Import Date</label>
<input name="receivedDate" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" type="date"/>
</div>
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Initial Status</label>
<div class="relative">
<select name="initialStatus" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none appearance-none">
<option value="Available">Available</option>
<option value="Reserved">Reserved</option>
<option value="QC Pending">QC Pending</option>
</select>
<div class="absolute right-4 top-1/2 -translate-y-1/2 flex items-center pointer-events-none">
<span class="w-2.5 h-2.5 rounded-full bg-green-500 mr-2"></span>
<span class="material-symbols-outlined text-on-surface-variant" data-icon="expand_more">expand_more</span>
</div>
</div>
</div>
</div>
</div>
<!-- Form Actions -->
<div class="flex items-center justify-end gap-4 py-6 border-t border-outline-variant">
<a href="${pageContext.request.contextPath}/staff/imei" class="px-6 py-2.5 rounded-lg font-label-md text-label-md text-on-surface-variant hover:bg-surface-container-high transition-colors">
                        Cancel
                    </a>
<button class="px-8 py-2.5 rounded-lg bg-primary text-white font-label-md text-label-md hover:bg-primary/90 shadow-md transition-all active:scale-95 flex items-center gap-2" type="submit">
<span class="material-symbols-outlined" data-icon="check_circle">check_circle</span>
                        Register Units
                    </button>
</div>
</form>
</div>

</main>
<script>
        // Simple micro-interaction for unit counter
        const textarea = document.querySelector('textarea');
        const unitCount = document.getElementById('unitCount');

        textarea.addEventListener('input', () => {
            const lines = textarea.value.split('\n').filter(line => line.trim() !== '');
            unitCount.textContent = lines.length;
            
            if (lines.length > 0) {
                unitCount.classList.add('scale-125');
                setTimeout(() => unitCount.classList.remove('scale-125'), 200);
            }
        });

        function filterVariants() {
            filterVariantsWithoutReset();
            const variantSelect = document.getElementById('variantSelect');
            variantSelect.selectedIndex = 0;
        }

        function filterVariantsWithoutReset() {
            const productSelect = document.getElementById('productSelect');
            const variantSelect = document.getElementById('variantSelect');
            const selectedProductId = productSelect.value;

            // Show/Hide options
            Array.from(variantSelect.options).forEach(option => {
                if (option.value === "") return; // Skip placeholder
                if (option.getAttribute('data-product-id') === selectedProductId) {
                    option.style.display = 'block';
                } else {
                    option.style.display = 'none';
                }
            });
        }
        
        // Run once on load to auto select variant from URL params if present
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const urlVariantId = urlParams.get('variantId');
            
            if (urlVariantId) {
                const variantSelect = document.getElementById('variantSelect');
                const option = Array.from(variantSelect.options).find(opt => opt.value === urlVariantId);
                if (option) {
                    const productId = option.getAttribute('data-product-id');
                    const productSelect = document.getElementById('productSelect');
                    productSelect.value = productId;
                    
                    // Filter variants based on product without resetting choice
                    filterVariantsWithoutReset();
                    
                    variantSelect.value = urlVariantId;
                }
            } else {
                filterVariants();
            }
        });
    </script>
</body></html>

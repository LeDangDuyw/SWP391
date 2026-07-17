<%-- 
    Document   : AddProductImei
    Created on : Jun 14, 2026, 4:50:41 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
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
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Product Catalog</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Category</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>IMEI</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Tickets</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Orders</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Outbound</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
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
                <span>Staff Profile</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

    <div class="main">
        <!-- TopNavBar Component -->
        <header class="sticky top-0 z-50 bg-surface border-b border-outline-variant flex justify-between items-center px-gutter h-16 w-full">
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
        <main class="p-gutter flex-1 bg-surface-container-lowest">
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
    <div class="mb-6 p-4 rounded-lg bg-error-container text-on-error-container flex items-center gap-3">
        <span class="material-symbols-outlined text-[20px]">error</span>
        <c:choose>
            <c:when test="${param.error == 'MismatchImeisQuantity'}">
                Lỗi: Số lượng Serial Number nhập vào không khớp với yêu cầu! Yêu cầu: ${param.expected} (Thực tế: ${param.actual}).
            </c:when>
            <c:when test="${param.error == 'MissingRequiredFields'}">
                Lỗi: Vui lòng điền đầy đủ các trường yêu cầu.
            </c:when>
            <c:when test="${param.error == 'InvalidImportDate'}">
                Lỗi: Ngày nhập sản phẩm (Import Date) không được là ngày tương lai.
            </c:when>
            <c:otherwise>
                Đã xảy ra lỗi: ${param.error}
            </c:otherwise>
        </c:choose>
    </div>
</c:if>
<form action="${pageContext.request.contextPath}/staff/imei/add" method="POST" onsubmit="return validateForm(event)" class="space-y-6">
<input type="hidden" name="ticketId" value="${not empty ticketId ? ticketId : param.ticketId}">
<!-- Section 1: Product Information -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center gap-2 mb-6 text-primary">
<span class="material-symbols-outlined" data-icon="laptop_mac">laptop_mac</span>
<h3 class="font-headline-md text-headline-md">Product Information</h3>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<c:choose>
    <c:when test="${not empty selectedProduct and not empty selectedVariant}">
        <div class="space-y-2">
            <label class="font-label-md text-label-md text-on-surface-variant">Parent Product</label>
            <input type="text" readonly value="${selectedProduct.productName}" class="w-full bg-surface-container border border-outline-variant rounded-lg px-4 py-2.5 text-body-md text-on-surface-variant outline-none cursor-not-allowed">
        </div>
        <div class="space-y-2">
            <label class="font-label-md text-label-md text-on-surface-variant">Variant</label>
            <input type="text" readonly value="${selectedVariant.sku} - ${selectedVariant.variantName}" class="w-full bg-surface-container border border-outline-variant rounded-lg px-4 py-2.5 text-body-md text-on-surface-variant outline-none cursor-not-allowed">
            <input type="hidden" name="variantId" value="${selectedVariant.variantId}">
        </div>
    </c:when>
    <c:otherwise>
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
    </c:otherwise>
</c:choose>
</div>
<!-- Section 2: Unit Details -->
<!-- Section 2: Unit Details -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center justify-between mb-6">
<div class="flex items-center gap-2 text-primary">
<span class="material-symbols-outlined" data-icon="qr_code_scanner">qr_code_scanner</span>
<h3 class="font-headline-md text-headline-md">Unit Details</h3>
</div>
<div class="flex items-center gap-4">
<c:if test="${not empty expectedQuantity}">
<span class="font-label-md text-label-md px-3 py-1 bg-[#d3e4fe] text-[#001452] rounded-full">Required Quantity: ${expectedQuantity}</span>
</c:if>
</div>
</div>
<div class="space-y-4">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 font-label-md text-label-md text-on-surface-variant hidden md:grid">
        <label>IMEI Number</label>
        <label>Serial Number</label>
        <label>Barcode</label>
    </div>
    
    <div id="unitRowsContainer" class="space-y-3">
        <c:set var="rowCount" value="${not empty expectedQuantity ? expectedQuantity : 1}" />
        <c:forEach begin="1" end="${rowCount}" varStatus="status">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 md:p-0 border border-outline-variant md:border-none rounded-lg bg-surface-container-lowest md:bg-transparent">
                <div class="space-y-1">
                    <label class="font-label-md text-label-md text-on-surface-variant md:hidden">IMEI Number</label>
                    <input type="text" name="serials" required pattern="[0-9]{15}" title="IMEI phải chứa chính xác 15 chữ số" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="IMEI #${status.index}">
                </div>
                <div class="space-y-1">
                    <label class="font-label-md text-label-md text-on-surface-variant md:hidden">Serial Number</label>
                    <input type="text" name="serialNumbers" required pattern="[A-Za-z0-9_\-]{3,30}" title="Serial phải từ 3-30 ký tự, gồm chữ, số và dấu gạch" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="Serial #${status.index}">
                </div>
                <div class="space-y-1">
                    <label class="font-label-md text-label-md text-on-surface-variant md:hidden">Barcode</label>
                    <input type="text" name="barcodes" required pattern="[0-9]{8,15}" title="Barcode phải từ 8-15 chữ số" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="Barcode #${status.index}">
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<!-- Section 3: Storage & Status -->
<div class="bg-surface-container-lowest border border-outline-variant p-6 rounded-xl">
<div class="flex items-center gap-2 mb-6 text-primary">
<span class="material-symbols-outlined" data-icon="inventory_2">inventory_2</span>
<h3 class="font-headline-md text-headline-md">Storage & Status</h3>
</div>
<div class="grid grid-cols-1 gap-6">
<div class="space-y-2">
<label class="font-label-md text-label-md text-on-surface-variant">Import Date</label>
<input name="receivedDate" required class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" type="date"/>
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
    </div>
</div>
<script>
    const expectedQty = parseInt("${expectedQuantity}");
    const isTicketContext = ${not empty expectedQuantity && expectedQuantity > 0};

    function addUnitRow() {
        const container = document.getElementById('unitRowsContainer');
        const rowCount = container.children.length + 1;
        const row = document.createElement('div');
        row.className = 'grid grid-cols-1 md:grid-cols-3 gap-6 p-4 md:p-0 border border-outline-variant md:border-none rounded-lg bg-surface-container-lowest md:bg-transparent';
        row.innerHTML = `
            <div class="space-y-1">
                <label class="font-label-md text-label-md text-on-surface-variant md:hidden">IMEI Number</label>
                <input type="text" name="serials" required pattern="[0-9]{15}" title="IMEI phải chứa chính xác 15 chữ số" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="IMEI #${rowCount}">
            </div>
            <div class="space-y-1">
                <label class="font-label-md text-label-md text-on-surface-variant md:hidden">Serial Number</label>
                <input type="text" name="serialNumbers" required pattern="[A-Za-z0-9_\\-]{3,30}" title="Serial phải từ 3-30 ký tự, gồm chữ, số và dấu gạch" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="Serial #${rowCount}">
            </div>
            <div class="space-y-1">
                <label class="font-label-md text-label-md text-on-surface-variant md:hidden">Barcode</label>
                <input type="text" name="barcodes" required pattern="[0-9]{8,15}" title="Barcode phải từ 8-15 chữ số" class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2.5 text-body-md focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all outline-none" placeholder="Barcode #${rowCount}">
            </div>
        `;
        container.appendChild(row);
    }

    function validateForm(event) {
        const rows = document.querySelectorAll('#unitRowsContainer > div');
        let filledRowsCount = 0;
        let hasPartial = false;
        
        rows.forEach(row => {
            const imeiInput = row.querySelector('input[name="serials"]');
            const snInput = row.querySelector('input[name="serialNumbers"]');
            const bcInput = row.querySelector('input[name="barcodes"]');
            
            if (!imeiInput || !snInput || !bcInput) return;
            
            const imei = imeiInput.value.trim();
            const sn = snInput.value.trim();
            const bc = bcInput.value.trim();
            
            if (imei || sn || bc) {
                if (!imei || !sn || !bc) {
                    hasPartial = true;
                } else {
                    filledRowsCount++;
                }
            }
        });
        
        if (filledRowsCount === 0) {
            alert("Vui lòng điền thông tin cho ít nhất 1 dòng sản phẩm.");
            event.preventDefault();
            return false;
        }
        
        if (hasPartial) {
            alert("Vui lòng điền đầy đủ cả 3 thông tin (IMEI, Serial Number, Barcode) cho các dòng đã nhập.");
            event.preventDefault();
            return false;
        }
        
        if (isTicketContext && filledRowsCount > expectedQty) {
            alert("Số lượng sản phẩm nhập vào (" + filledRowsCount + ") vượt quá số lượng yêu cầu trong ticket (" + expectedQty + ").");
            event.preventDefault();
            return false;
        }
        
        const dateInput = document.querySelector('input[name="receivedDate"]');
        if (dateInput) {
            const selectedDateStr = dateInput.value;
            if (selectedDateStr) {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                const [year, month, day] = selectedDateStr.split('-').map(Number);
                const selectedDate = new Date(year, month - 1, day);
                selectedDate.setHours(0, 0, 0, 0);
                
                if (selectedDate > today) {
                    alert("Lỗi: Ngày nhập sản phẩm (Import Date) không được là ngày tương lai.");
                    event.preventDefault();
                    return false;
                }
            }
        }
        
        return true;
    }

    function filterVariants() {
        filterVariantsWithoutReset();
        const variantSelect = document.getElementById('variantSelect');
        if (variantSelect) {
            variantSelect.selectedIndex = 0;
        }
    }

    function filterVariantsWithoutReset() {
        const productSelect = document.getElementById('productSelect');
        const variantSelect = document.getElementById('variantSelect');
        if (!productSelect || !variantSelect) return;
        
        const selectedProductId = productSelect.value;

        Array.from(variantSelect.options).forEach(option => {
            if (option.value === "") return;
            if (option.getAttribute('data-product-id') === selectedProductId) {
                option.style.display = 'block';
            } else {
                option.style.display = 'none';
            }
        });
    }
    
    window.addEventListener('DOMContentLoaded', () => {
        if (!isTicketContext) {
            // Auto select variant from URL params if present
            const urlParams = new URLSearchParams(window.location.search);
            const urlVariantId = urlParams.get('variantId');
            
            if (urlVariantId) {
                const variantSelect = document.getElementById('variantSelect');
                if (variantSelect) {
                    const option = Array.from(variantSelect.options).find(opt => opt.value === urlVariantId);
                    if (option) {
                        const productId = option.getAttribute('data-product-id');
                        const productSelect = document.getElementById('productSelect');
                        if (productSelect) {
                            productSelect.value = productId;
                        }
                        filterVariantsWithoutReset();
                        variantSelect.value = urlVariantId;
                    }
                }
            } else {
                filterVariants();
            }
        }
    });
</script>
</body></html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Create Inbound Ticket</title>
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

<body class="bg-background text-on-surface font-body-md min-h-screen flex">

    <!-- Sidebar Navigation -->
    <aside class="fixed h-full left-0 top-0 w-64 bg-surface border-r border-outline-variant/20 flex flex-col py-4 z-40">
        <div class="px-6 py-4 mb-4">
            <h1 class="font-headline-md text-[24px] font-bold text-primary flex items-center gap-2">
                <span class="material-symbols-outlined text-[28px]">laptop_mac</span>
                UNILAP Staff
            </h1>
            <p class="font-body-sm text-[12px] font-bold text-on-surface-variant uppercase tracking-wider mt-1">System Controller</p>
        </div>
        
        <nav class="flex-1 flex flex-col gap-1 px-2">
            <!-- Dashboard -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="${pageContext.request.contextPath}/admin/dashboard">
                <span class="material-symbols-outlined mr-3 text-[20px]">grid_view</span> Dashboard
            </a>
            
            <!-- Inventory -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/inventory">
                <span class="material-symbols-outlined mr-3 text-[20px]">inventory_2</span> Inventory
            </a>
            
            <!-- Category -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="${pageContext.request.contextPath}/staff/category">
                <span class="material-symbols-outlined mr-3 text-[20px]">category</span> Category
            </a>
            
            <!-- IMEI -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/imei">
                <span class="material-symbols-outlined mr-3 text-[20px]">barcode_scanner</span> IMEI
            </a>

            <!-- Tickets (Active) -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg bg-surface-container-low text-primary font-bold border-l-4 border-primary font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/ticket/list">
                <span class="material-symbols-outlined icon-fill mr-3 text-[20px]">receipt_long</span> Tickets
            </a>
        </nav>
        
        <div class="mt-auto border-t border-outline-variant/20 pt-4 flex flex-col gap-1 px-2">
            <!-- Logout -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-error hover:bg-error/10 transition-colors font-label-md text-sm font-medium" href="#">
                <span class="material-symbols-outlined mr-3 text-[20px]">logout</span> Logout
            </a>
        </div>
    </aside>

    <div class="flex-1 ml-64 flex flex-col min-h-screen">

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
                        <h2 class="font-headline-lg text-headline-lg text-on-surface">Create Inbound Ticket</h2>
                    </div>
                    <p class="font-body-sm text-body-sm text-on-surface-variant ml-9">Create a new inbound request ticket to send to Admin for approval.</p>
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
            <div class="bg-surface border border-outline-variant/30 rounded-xl shadow-sm max-w-2xl">
                <div class="px-6 py-4 border-b border-outline-variant/20">
                    <h3 class="font-headline-md text-headline-md font-bold text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">edit_note</span>
                        Ticket Information
                    </h3>
                </div>

                <form action="${pageContext.request.contextPath}/staff/ticket/create" method="post" class="p-6 flex flex-col gap-6">
                    
                    <!-- Title -->
                    <div>
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Ticket Title</label>
                        <input type="text" name="title" required placeholder="Ex: October Batch 1 Inbound" value="${title}"
                               class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm">
                    </div>
                    
                    <!-- Variant Select -->
                    <div>
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Select Product (Variant)</label>
                        <div class="relative">
                            <select name="variantId" required
                                    class="w-full appearance-none px-4 py-3 pr-10 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm">
                                <c:forEach var="v" items="${variants}">
                                    <option value="${v.variantId}" ${v.variantId == selectedVariantId ? 'selected' : ''}>
                                        ${v.sku} - ${v.variantName} (Fixed Import Price: ${v.importPrice})
                                    </option>
                                </c:forEach>
                            </select>
                            <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                        </div>
                    </div>
                    
                    <!-- Quantity -->
                    <div>
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Expected Quantity</label>
                        <input type="number" name="quantity" min="1" required value="${quantity}"
                               class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm"
                               placeholder="Enter quantity">
                    </div>

                    <!-- Expected Price -->
                    <div>
                        <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Expected Import Price</label>
                        <input type="number" name="expectedPrice" min="0" step="1000" placeholder="Ex: 22000000" value="${expectedPrice}"
                               class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all font-body-sm text-body-sm">
                        <p class="mt-2 text-on-surface-variant text-[12px] flex items-start gap-1.5">
                            <span class="material-symbols-outlined text-[14px] mt-0.5 flex-shrink-0">info</span>
                            Purchase price from the supplier. Must be less than or equal to the fixed import price of the product.
                        </p>
                    </div>
                    
                    <!-- Submit Buttons -->
                    <div class="flex justify-end gap-3 pt-2 border-t border-outline-variant/20">
                        <a href="${pageContext.request.contextPath}/staff/ticket/list"
                           class="px-6 py-2.5 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg font-label-md text-label-md">
                            Cancel
                        </a>
                        <button type="submit" 
                                class="px-6 py-2.5 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 font-label-md text-label-md flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">send</span>
                            Submit for Approval
                        </button>
                    </div>
                </form>
            </div>

        </main>
    </div>

</body>
</html>

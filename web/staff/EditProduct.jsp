<%-- 
    Document   : EditProduct
    Created on : Jun 1, 2026, 8:08:34 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Edit Product: UNILAP Pro 16 | UNILAP Admin</title>
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
<!-- TopNavBar -->
<header class="sticky top-0 z-50 flex justify-between items-center px-gutter w-full h-16 bg-surface-container-lowest border-b border-outline-variant">
<div class="flex items-center gap-6">
<span class="font-headline-md text-headline-md font-bold text-primary">UNILAP</span>
<div class="hidden md:flex items-center bg-surface-container rounded-full px-4 py-2 gap-2 w-96 border border-outline-variant focus-within:border-primary transition-all">
<span class="material-symbols-outlined text-on-surface-variant">search</span>
<input class="bg-transparent border-none focus:ring-0 text-body-sm w-full outline-none" placeholder="Search tech retail ecosystem..." type="text"/>
</div>
</div>
<div class="flex items-center gap-4">
<button class="p-2 hover:bg-surface-container-high rounded-full transition-colors relative">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
<span class="absolute top-2 right-2 w-2 h-2 bg-primary rounded-full border border-surface-container-lowest"></span>
</button>
<button class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
<span class="material-symbols-outlined" data-icon="help">help</span>
</button>
<div class="h-8 w-8 rounded-full overflow-hidden border border-outline-variant">
<img alt="Admin Profile Avatar" data-alt="A professional studio portrait of a high-level technology administrator in a bright, modern corporate environment. The person has a friendly, confident expression, with soft, high-key lighting that emphasizes clarity and precision. The background is a blurred high-tech workspace with clean lines and cool blue and silver tones, maintaining a premium light-mode aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuB451IzG945lwtHnmq9gifjRptaBxRjxE34iL8JZ35yUf-CQ0f42LLBBirnrTBu65A6JArN5hpnmXIs7CmKq2y5zw4wLQxqM8Mpal0qudCnBLdu4wtw4tfyDRBrAFT3cucFOrPEtcbznV09ghix7eoo_g-bNuS5E6cFm8ANBVzCjTgyzqVDqFwjCQ7ON9emmYAu0akdHhtZ5uIzWNsLjzJY0sDrlvUnOx_ntehY6kWDsEwLpArAJyRLsZKikg-DzYuRR-c-WyoK8E7q"/>
</div>
</div>
</header>
<div class="flex">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Inventory</a>
            <a href="#"><span>♚</span>Users</a>
            <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
            <a href="#"><span>⚙</span>Settings</a>
        </nav>
        <div class="profile">♙ <span>Admin User Profile</span></div>
    </aside>
<!-- Main Content Area -->
<main class="flex-1 ml-0 md:ml-72 p-gutter max-w-container-max mx-auto">
<!-- Header Section -->
<section class="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6">
<div>
<nav class="flex items-center gap-2 mb-3 text-on-surface-variant">
<a class="font-label-md text-label-md hover:text-primary transition-colors" href="#">Inventory</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<a class="font-label-md text-label-md hover:text-primary transition-colors" href="#">Products</a>
<span class="material-symbols-outlined text-[16px]">chevron_right</span>
<span class="font-label-md text-label-md text-on-surface">Edit</span>
</nav>
<h1 class="font-headline-lg text-headline-lg text-on-surface">Edit Product: UNILAP Pro 16</h1>
</div>
<div class="flex items-center gap-4">
<span class="hidden lg:inline text-body-sm text-on-surface-variant mr-2">Last updated: 2 hours ago by Admin</span>
<button class="px-6 py-2 border border-primary text-primary font-bold hover:bg-primary-container/10 transition-all rounded-lg active:scale-95">
                        Discard Changes
                    </button>
<button class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20 active:scale-95">
                        Update Product
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
<h2 class="font-headline-md text-headline-md">General Information</h2>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<div class="col-span-2">
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Product Name</label>
<input class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" type="text" value="UNILAP Pro 16"/>
</div>
<div>
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Category</label>
<select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all appearance-none">
<option>Laptops</option>
<option>Desktops</option>
<option>Monitors</option>
<option>Accessories</option>
</select>
</div>
<div>
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Brand</label>
<select class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all appearance-none">
<option>Apple</option>
<option>UNILAP Native</option>
<option>Dell</option>
<option>Razer</option>
</select>
</div>
<div class="col-span-2">
<label class="block font-label-md text-label-md text-on-surface-variant mb-2">Description</label>
<div class="border border-outline-variant rounded-lg overflow-hidden">
<div class="flex items-center gap-1 p-2 bg-surface-container border-b border-outline-variant">
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_bold</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_italic</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">format_list_bulleted</span></button>
<button class="p-1 hover:bg-surface-container-high rounded transition-colors"><span class="material-symbols-outlined text-[20px]">link</span></button>
</div>
<textarea class="w-full p-4 bg-white border-none focus:ring-0 text-body-md outline-none" rows="6">The UNILAP Pro 16 is engineered for elite performance. Featuring the latest M3 Max chip with a 16-core CPU and 40-core GPU, it delivers unprecedented speed for creative workflows. The 16.2-inch Liquid Retina XDR display offers extreme dynamic range and a million-to-one contrast ratio. Experience professional-grade connectivity and all-day battery life in a precision-milled aluminum chassis.</textarea>
</div>
</div>
</div>
</div>
<!-- Product Variants Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<div class="flex items-center justify-between mb-6">
<div class="flex items-center gap-2 text-primary">
<span class="material-symbols-outlined" data-icon="layers">layers</span>
<h2 class="font-headline-md text-headline-md">Product Variants</h2>
</div>
<button class="flex items-center gap-2 px-4 py-2 bg-surface-container-high text-on-surface font-bold hover:bg-surface-container-highest transition-all rounded-lg active:scale-95">
<span class="material-symbols-outlined">add</span>
                                Add Variant
                            </button>
</div>
<div class="overflow-x-auto border border-outline-variant rounded-lg">
<table class="w-full text-left border-collapse">
<thead>
<tr class="bg-inverse-surface text-white">
<th class="px-4 py-3 font-label-md text-label-md">SKU</th>
<th class="px-4 py-3 font-label-md text-label-md">Price</th>
<th class="px-4 py-3 font-label-md text-label-md">Attributes</th>
<th class="px-4 py-3 font-label-md text-label-md text-center">Stock</th>
<th class="px-4 py-3 font-label-md text-label-md text-right">Actions</th>
</tr>
</thead>
<tbody class="divide-y divide-outline-variant">
<tr class="hover:bg-surface-container-low transition-colors group">
<td class="px-4 py-4"><span class="font-code-sm text-code-sm">ULP-16-SG-32</span></td>
<td class="px-4 py-4 font-bold">$2,499.00</td>
<td class="px-4 py-4">
<div class="flex gap-2">
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">32GB RAM</span>
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">Space Grey</span>
</div>
</td>
<td class="px-4 py-4 text-center">
<span class="px-3 py-1 bg-emerald-100 text-emerald-800 text-[12px] rounded-full font-bold">12</span>
</td>
<td class="px-4 py-4 text-right">
<div class="flex justify-end gap-2">
<button class="p-1 hover:text-primary transition-colors"><span class="material-symbols-outlined text-[20px]">edit</span></button>
<button class="p-1 hover:text-error transition-colors"><span class="material-symbols-outlined text-[20px]">delete</span></button>
</div>
</td>
</tr>
<tr class="bg-surface-container-low/30 hover:bg-surface-container-low transition-colors group">
<td class="px-4 py-4"><span class="font-code-sm text-code-sm">ULP-16-SG-64</span></td>
<td class="px-4 py-4 font-bold">$3,199.00</td>
<td class="px-4 py-4">
<div class="flex gap-2">
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">64GB RAM</span>
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">Space Grey</span>
</div>
</td>
<td class="px-4 py-4 text-center">
<span class="px-3 py-1 bg-emerald-100 text-emerald-800 text-[12px] rounded-full font-bold">8</span>
</td>
<td class="px-4 py-4 text-right">
<div class="flex justify-end gap-2">
<button class="p-1 hover:text-primary transition-colors"><span class="material-symbols-outlined text-[20px]">edit</span></button>
<button class="p-1 hover:text-error transition-colors"><span class="material-symbols-outlined text-[20px]">delete</span></button>
</div>
</td>
</tr>
<tr class="hover:bg-surface-container-low transition-colors group">
<td class="px-4 py-4"><span class="font-code-sm text-code-sm">ULP-16-SL-32</span></td>
<td class="px-4 py-4 font-bold">$2,499.00</td>
<td class="px-4 py-4">
<div class="flex gap-2">
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">32GB RAM</span>
<span class="px-2 py-1 bg-secondary-container text-on-secondary-container text-[11px] rounded uppercase font-bold">Silver</span>
</div>
</td>
<td class="px-4 py-4 text-center">
<span class="px-3 py-1 bg-amber-100 text-amber-800 text-[12px] rounded-full font-bold">5</span>
</td>
<td class="px-4 py-4 text-right">
<div class="flex justify-end gap-2">
<button class="p-1 hover:text-primary transition-colors"><span class="material-symbols-outlined text-[20px]">edit</span></button>
<button class="p-1 hover:text-error transition-colors"><span class="material-symbols-outlined text-[20px]">delete</span></button>
</div>
</td>
</tr>
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
<h2 class="font-headline-md text-headline-md">Thumbnail</h2>
</div>
<button class="text-primary font-bold text-label-md hover:underline">Change Image</button>
</div>
<div class="bg-surface-container rounded-lg overflow-hidden border border-outline-variant group relative aspect-video flex items-center justify-center">
<img alt="UNILAP Pro 16 Thumbnail" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" data-alt="A high-end, sleek laptop presented in a professional product photography style. The laptop is finished in premium Space Grey aluminum, resting on a clean, minimalist surface with soft, diffused cyber-silver lighting. The scene highlights the precision engineering and sharp lines of the device, set against a pristine, bright studio background that reinforces a modern, corporate high-tech aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBbRpuVam0wbB79-60GNTg-hBeeEdyH7m6Sw4HfK-hccGd1B0lYNTggwjWTKF3uY3oqPjz0rP_Tzd_h3snnUJWFvY25pLaS-K74dArL-K-fK2YM7LsxuBwJgLKXqyuEK2H024oT_VuXdaSoaHzhxpgBYP3M1kmebfOcHc-rdwymgh0DVqMpCDRS7x3Z5x3damVcaEthVLpnxpwK3gJTK_FWglZChXI0VvdhtJVpydSQ8hgAE9Ql2gB2l6aFE61RY1hz3E9sEgfsyDCY"/>
<div class="absolute inset-0 bg-primary/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
<span class="material-symbols-outlined text-white text-4xl">zoom_in</span>
</div>
</div>
<p class="mt-4 text-center text-on-surface-variant text-body-sm">
                            Supported formats: JPG, PNG, WEBP. Max size: 2MB.
                        </p>
</div>
<!-- Meta Data / Quick Stats Card -->
<div class="bg-surface-container-lowest border border-outline-variant p-gutter rounded-xl">
<h2 class="font-headline-md text-headline-md text-primary mb-6">Inventory Summary</h2>
<div class="space-y-4">
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Total Stock</span>
<span class="font-bold">25 Units</span>
</div>
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Avg. Variant Price</span>
<span class="font-bold">$2,732.33</span>
</div>
<div class="flex justify-between items-center py-2 border-b border-outline-variant">
<span class="text-on-surface-variant text-body-sm">Total Value</span>
<span class="font-bold text-primary">$68,308.25</span>
</div>
<div class="flex justify-between items-center py-2">
<span class="text-on-surface-variant text-body-sm">Store Visibility</span>
<div class="flex items-center gap-2">
<span class="w-3 h-3 bg-emerald-500 rounded-full"></span>
<span class="font-bold text-emerald-600 uppercase text-[12px]">Published</span>
</div>
</div>
</div>
</div>
<!-- Advanced Settings Prompt -->
<div class="p-gutter rounded-xl bg-gradient-to-br from-primary to-primary-container text-white shadow-xl">
<h3 class="font-bold text-lg mb-2">Need SEO customization?</h3>
<p class="text-white/80 text-body-sm mb-4">Edit meta tags, URL handles, and social sharing previews in advanced settings.</p>
<button class="w-full py-2 bg-white text-primary font-bold rounded-lg hover:bg-primary-fixed transition-colors">
                            Manage SEO Settings
                        </button>
</div>
</div>
</div>
</main>
</div>
<!-- Mobile Navigation Toggle -->
<button class="md:hidden fixed bottom-6 right-6 w-14 h-14 bg-primary text-white rounded-full shadow-2xl z-50 flex items-center justify-center active:scale-90 transition-transform">
<span class="material-symbols-outlined">menu</span>
</button>
<script>
        // Simple Interaction: Change button state on click
        const updateBtn = document.querySelector('button.bg-primary');
        if (updateBtn) {
            updateBtn.addEventListener('click', () => {
                const originalContent = updateBtn.innerHTML;
                updateBtn.innerHTML = '<span class="material-symbols-outlined animate-spin">sync</span> Updating...';
                updateBtn.classList.add('opacity-80');
                setTimeout(() => {
                    updateBtn.innerHTML = '<span class="material-symbols-outlined">check_circle</span> Updated';
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
    </script>
</body></html>

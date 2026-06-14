<%-- 
    Document   : InventoryManagement
    Created on : May 29, 2026, 9:20:02 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Product"%>
<%@page import="viewmodel.ProductInventory"%>
<%@page import="java.math.BigInteger" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Admin - Inventory Management</title>
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

<%
    // ── Lấy dữ liệu từ request attributes ──────────────────────────────────
    List<ProductInventory> products = (List<ProductInventory>) request.getAttribute("products");
    if (products == null) products = new ArrayList<ProductInventory>();

    List<Product> product = (List<Product>) request.getAttribute("product");
    if (product == null) product = new ArrayList<Product>();

    // Xác định tab đang active (mặc định: products)
    String activeTab = request.getParameter("tab") != null ? request.getParameter("tab") : "products";

    // ── Pagination — Products tab ───────────────────────────────────────────
    Integer currentPageP = (Integer) request.getAttribute("currentPageProduct");
    Integer totalPagesP  = (Integer) request.getAttribute("totalPagesProduct");
    if (currentPageP == null) currentPageP = 1;
    if (totalPagesP  == null) totalPagesP  = 1;

    String qP = "tab=products"
              + (request.getParameter("searchInput") != null ? "&searchInput=" + request.getParameter("searchInput") : "")
              + (request.getParameter("category")    != null ? "&category="    + request.getParameter("category")    : "")
              + (request.getParameter("sortBy")      != null ? "&sortBy="      + request.getParameter("sortBy")      : "");

    // ── Pagination — Variants tab ───────────────────────────────────────────
    Integer currentPageV = (Integer) request.getAttribute("currentPage");
    Integer totalPagesV  = (Integer) request.getAttribute("totalPages");
    if (currentPageV == null) currentPageV = 1;
    if (totalPagesV  == null) totalPagesV  = 1;

    String qV = "tab=variants"
              + (request.getParameter("searchInput") != null ? "&searchInput=" + request.getParameter("searchInput") : "")
              + (request.getParameter("category")    != null ? "&category="    + request.getParameter("category")    : "")
              + (request.getParameter("sortBy")      != null ? "&sortBy="      + request.getParameter("sortBy")      : "")
              + (request.getParameter("stockStatus") != null ? "&stockStatus=" + request.getParameter("stockStatus") : "");
%>

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
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg bg-surface-container-low text-primary font-bold border-l-4 border-primary font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/inventory">
                <span class="material-symbols-outlined icon-fill mr-3 text-[20px]">inventory_2</span> Inventory
            </a>
            
            <!-- Category -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium" href="${pageContext.request.contextPath}/staff/category">
                <span class="material-symbols-outlined mr-3 text-[20px]">category</span> Category
            </a>
            
            <!-- IMEI -->
            <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-on-surface-variant hover:bg-surface-container-highest transition-colors font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/imei">
                <span class="material-symbols-outlined mr-3 text-[20px]">barcode_scanner</span> IMEI
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
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Inventory Management</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Manage product listings, monitor stock levels, and audit adjustments.</p>
                </div>
                <div class="flex gap-3">
                    <button class="px-4 py-2.5 bg-surface border border-outline-variant/50 rounded-lg hover:bg-surface-container-high transition-colors font-label-md text-label-md text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">download</span> Export
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/inventory/add"
                       class="px-4 py-2.5 bg-primary text-on-primary rounded-lg hover:bg-primary/90 transition-colors font-label-md text-label-md flex items-center gap-2 shadow-sm">
                        <span class="material-symbols-outlined text-[20px]">add</span> Add Product
                    </a>
                </div>
            </div>

            <!-- Tab Navigation (link-based, đồng bộ với server) -->
            <div class="mb-6 border-b border-outline-variant/30">
                <div class="flex gap-8">
                    <a href="?tab=products"
                       class="pb-3 border-b-2 <%= activeTab.equals("products") ? "border-primary text-primary" : "border-transparent text-on-surface-variant hover:text-on-surface" %> font-label-md text-label-md transition-all">
                        Products
                    </a>
                    <a href="?tab=variants"
                       class="pb-3 border-b-2 <%= activeTab.equals("variants") ? "border-primary text-primary" : "border-transparent text-on-surface-variant hover:text-on-surface" %> font-label-md text-label-md transition-all">
                        Product Variants
                    </a>
                </div>
            </div>

            <!-- Filter & Search Bar -->
            <div class="bg-surface border border-outline-variant/30 rounded-xl p-4 flex flex-wrap items-center gap-4 shadow-sm mb-6">
                <form action="${pageContext.request.contextPath}/staff/inventory" method="get"
                      class="flex flex-wrap items-center gap-4 flex-1">

                    <!-- Giữ tab hiện tại khi submit form -->
                    <input type="hidden" name="tab" value="<%= activeTab %>">

                    <div class="relative flex-1 min-w-[280px]">
                        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
                        <input type="text" name="searchInput" value="${param.searchInput}"
                               placeholder="Search by product name, SKU, or category..."
                               class="w-full pl-12 pr-4 py-2.5 bg-surface-container-low border border-outline-variant/50 
                                      rounded-lg font-body-sm text-body-sm text-on-surface focus:ring-2 
                                      focus:ring-primary/20 focus:border-primary placeholder-on-surface-variant/60 transition-all">
                        <button type="submit"
                                class="absolute right-1 top-1 bottom-1 px-3 bg-blue-600 hover:bg-blue-700 
                                       text-white rounded flex items-center justify-center transition-colors">
                            <span class="material-symbols-outlined text-sm">search</span>
                        </button>
                    </div>

                    <div class="relative">
                        <select name="category" class="appearance-none pl-4 pr-10 py-2.5 bg-surface border 
                                border-outline-variant/50 rounded-lg text-on-surface font-label-md text-label-md 
                                focus:ring-0 focus:border-primary outline-none">
                            <option value="">All Categories</option>
                            <option value="laptops"    ${param.category == 'laptops'    ? 'selected' : ''}>Laptops</option>
                            <option value="mice"       ${param.category == 'mice'       ? 'selected' : ''}>Mice</option>
                            <option value="keyboards"  ${param.category == 'keyboards'  ? 'selected' : ''}>Keyboards</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 
                                     pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                    </div>

                    <div class="relative">
                        <select name="sortBy" class="appearance-none pl-4 pr-10 py-2.5 bg-surface border 
                                border-outline-variant/50 rounded-lg text-on-surface font-label-md text-label-md 
                                focus:ring-0 focus:border-primary outline-none">
                            <option value="all"       ${param.sortBy == 'all'       ? 'selected' : ''}>All</option>
                            <option value="highToLow" ${param.sortBy == 'highToLow' ? 'selected' : ''}>Price: High → Low</option>
                            <option value="lowToHigh" ${param.sortBy == 'lowToHigh' ? 'selected' : ''}>Price: Low → High</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 
                                     pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                    </div>

                    <!-- Stock Status chỉ hiện ở tab variants -->
                    <% if (activeTab.equals("variants")) { %>
                    <div class="relative">
                        <select name="stockStatus" class="appearance-none pl-4 pr-10 py-2.5 bg-surface border 
                                border-outline-variant/50 rounded-lg text-on-surface font-label-md text-label-md 
                                focus:ring-0 focus:border-primary outline-none">
                            <option value="">Stock Status</option>
                            <option value="inStock"    ${param.stockStatus == 'inStock'    ? 'selected' : ''}>In Stock</option>
                            <option value="lowStock"   ${param.stockStatus == 'lowStock'   ? 'selected' : ''}>Low Stock</option>
                            <option value="outOfStock" ${param.stockStatus == 'outOfStock' ? 'selected' : ''}>Out of Stock</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 
                                     pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                    </div>
                    <% } %>
                </form>
            </div>

            <!-- ===================== -->
            <!-- TAB: PRODUCTS         -->
            <!-- ===================== -->
            <div id="tab-products" class="<%= activeTab.equals("products") ? "" : "hidden" %>">
                <div class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-on-surface text-on-primary font-label-md text-label-md">
                                    <th class="py-3 px-4 border-b border-outline-variant/20 w-12">
                                        <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                    </th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Product Details</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Category</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Brand</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="font-body-sm text-body-sm">
                                <% for (Product p : product) { %>
                                <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest">
                                    <td class="py-2 px-4">
                                        <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                    </td>
                                    <td class="py-2 px-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 bg-surface-container rounded border border-outline-variant/30 overflow-hidden flex-shrink-0 flex items-center justify-center">
                                                <img src="${pageContext.request.contextPath}/images/<%= p.getThumbnail() %>"
                                                     alt="Product Image"
                                                     class="w-full h-full object-cover">
                                            </div>
                                            <div>
                                                <div class="font-bold text-on-surface"><%= p.getProductName() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-2 px-4"><%= p.getCategoryName() %></td>
                                    <td class="py-2 px-4"><%= p.getBrandName() %></td>
                                    <td class="py-2 px-4 text-right">
                                        <a class="p-1 text-on-surface-variant hover:text-primary transition-colors"
                                           href="${pageContext.request.contextPath}/staff/inventory/edit?variantId=<%= p.getProductId() %>">
                                            <span class="material-symbols-outlined text-[20px]">edit</span>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/staff/inventory" method="post" class="inline">
                                            <input type="hidden" name="variantIdToDelete" value="<%= p.getProductId() %>">
                                            <button class="p-1 text-on-surface-variant hover:text-error transition-colors"
                                                    name="action" value="delete"
                                                    onclick="return confirm('Bạn có chắc chắn muốn ẩn sản phẩm này không?');">
                                                <span class="material-symbols-outlined text-[20px]">block</span>
                                            </button>
                                            <button class="p-1 text-on-surface-variant hover:text-primary transition-colors"
                                                    name="action" value="restore"
                                                    onclick="return confirm('Bạn có chắc chắn muốn hiển thị lại sản phẩm này không?');">
                                                <span class="material-symbols-outlined text-[20px]">settings_backup_restore</span>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>

                                <%-- FIX: dùng đúng list "product" (List<Product>) thay vì "products" --%>
                                <% if (product.isEmpty()) { %>
                                <tr>
                                    <td class="py-4 px-4 text-center text-on-surface-variant font-body-sm text-body-sm" colspan="5">
                                        No products found.
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination Products -->
                    <div class="bg-surface px-4 py-3 border-t border-outline-variant/30 flex items-center justify-between">
                        <a href="?<%= qP %>&page=<%= currentPageP > 1 ? currentPageP - 1 : 1 %>"
                           class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md 
                                  text-label-md hover:bg-surface-container-low <%= currentPageP == 1 ? "pointer-events-none opacity-50" : "" %>">
                            Previous
                        </a>
                        <div class="flex gap-1">
                            <% for (int i = 1; i <= totalPagesP; i++) { %>
                            <a href="?<%= qP %>&page=<%= i %>"
                               class="w-8 h-8 flex items-center justify-center rounded 
                                      <%= currentPageP == i ? "bg-primary text-on-primary" : "text-on-surface hover:bg-surface-container-low" %> 
                                      font-label-md text-label-md">
                                <%= i %>
                            </a>
                            <% } %>
                        </div>
                        <a href="?<%= qP %>&page=<%= currentPageP < totalPagesP ? currentPageP + 1 : totalPagesP %>"
                           class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md 
                                  text-label-md hover:bg-surface-container-low 
                                  <%= currentPageP.equals(totalPagesP) || totalPagesP == 0 ? "pointer-events-none opacity-50" : "" %>">
                            Next
                        </a>
                    </div>
                </div>
            </div>

            <!-- ========================= -->
            <!-- TAB: PRODUCT VARIANTS     -->
            <!-- ========================= -->
            <div id="tab-variants" class="<%= activeTab.equals("variants") ? "" : "hidden" %>">
                <div class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-on-surface text-on-primary font-label-md text-label-md">
                                    <th class="py-3 px-4 border-b border-outline-variant/20 w-12">
                                        <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                    </th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Product details</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">SKU</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Category</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Price (VND)</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20">Stock Status</th>
                                    <th class="py-3 px-4 border-b border-outline-variant/20 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="font-body-sm text-body-sm">
                                <% for (ProductInventory p : products) { %>
                                <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest">
                                    <td class="py-2 px-4">
                                        <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                    </td>
                                    <td class="py-2 px-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 bg-surface-container rounded border border-outline-variant/30 overflow-hidden flex-shrink-0 flex items-center justify-center">
                                                <img src="${pageContext.request.contextPath}/images/<%= p.getThumbnail() %>"
                                                     alt="Product Image"
                                                     class="w-full h-full object-cover">
                                            </div>
                                            <div>
                                                <div class="font-bold text-on-surface"><%= p.getProductName() %></div>
                                                <div class="text-on-surface-variant text-[12px]"><%= p.getVariantName() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-2 px-4 font-code-sm text-code-sm text-on-surface-variant"><%= p.getSku() %></td>
                                    <td class="py-2 px-4"><%= p.getCategoryName() %></td>
                                    <% BigInteger priceInt = p.getSellingPrice().toBigInteger(); %>
                                    <td class="py-2 px-4 font-bold"><%= priceInt %></td>
                                    <td class="py-2 px-4">
                                        <span class="inline-flex items-center px-2 py-1 rounded bg-[#E6F4EA] text-[#137333] text-[12px] font-bold">
                                            <%= p.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="py-2 px-4 text-right">
                                        <a class="p-1 text-on-surface-variant hover:text-primary transition-colors"
                                           href="${pageContext.request.contextPath}/staff/inventory/edit?variantId=<%= p.getProductId() %>">
                                            <span class="material-symbols-outlined text-[20px]">edit</span>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/staff/inventory" method="post" class="inline">
                                            <input type="hidden" name="variantIdToDelete" value="<%= p.getProductId() %>">
                                            <button class="p-1 text-on-surface-variant hover:text-error transition-colors"
                                                    name="action" value="delete"
                                                    onclick="return confirm('Bạn có chắc chắn muốn ẩn biến thể này không?');">
                                                <span class="material-symbols-outlined text-[20px]">block</span>
                                            </button>
                                            <button class="p-1 text-on-surface-variant hover:text-primary transition-colors"
                                                    name="action" value="restore"
                                                    onclick="return confirm('Bạn có chắc chắn muốn hiển thị lại biến thể này không?');">
                                                <span class="material-symbols-outlined text-[20px]">settings_backup_restore</span>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>

                                <% if (products.isEmpty()) { %>
                                <tr>
                                    <td class="py-4 px-4 text-center text-on-surface-variant font-body-sm text-body-sm" colspan="7">
                                        No variants found.
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination Variants — FIX: dùng đúng qV, currentPageV, totalPagesV -->
                    <div class="bg-surface px-4 py-3 border-t border-outline-variant/30 flex items-center justify-between">
                        <a href="?<%= qV %>&page=<%= currentPageV > 1 ? currentPageV - 1 : 1 %>"
                           class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md 
                                  text-label-md hover:bg-surface-container-low <%= currentPageV == 1 ? "pointer-events-none opacity-50" : "" %>">
                            Previous
                        </a>
                        <div class="flex gap-1">
                            <% for (int i = 1; i <= totalPagesV; i++) { %>
                            <a href="?<%= qV %>&page=<%= i %>"
                               class="w-8 h-8 flex items-center justify-center rounded 
                                      <%= currentPageV == i ? "bg-primary text-on-primary" : "text-on-surface hover:bg-surface-container-low" %> 
                                      font-label-md text-label-md">
                                <%= i %>
                            </a>
                            <% } %>
                        </div>
                        <a href="?<%= qV %>&page=<%= currentPageV < totalPagesV ? currentPageV + 1 : totalPagesV %>"
                           class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md 
                                  text-label-md hover:bg-surface-container-low 
                                  <%= currentPageV.equals(totalPagesV) || totalPagesV == 0 ? "pointer-events-none opacity-50" : "" %>">
                            Next
                        </a>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <%-- 
        Tab switching: không dùng localStorage nữa.
        Server đã render đúng tab qua class "hidden", 
        script này chỉ giữ lại để hỗ trợ nếu cần toggle phía client.
        activeTab từ server được truyền xuống trực tiếp.
    --%>
    <script>
        // Không cần switchTab() nữa vì tab được kiểm soát hoàn toàn bởi server
        // thông qua URL param ?tab=products|variants và class "hidden" trong JSP.
        // Nếu muốn giữ client-side toggle (không reload trang), dùng đoạn dưới:

        function switchTab(tab) {
            ['products', 'variants'].forEach(function(t) {
                var section = document.getElementById('tab-' + t);
                if (section) {
                    section.classList.toggle('hidden', t !== tab);
                }
            });
        }

        // Đồng bộ trạng thái tab từ server (activeTab được inject từ JSP)
        switchTab('<%= activeTab %>');
    </script>
</body>
</html>

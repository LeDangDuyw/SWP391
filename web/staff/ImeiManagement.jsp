<%-- 
    Document   : ImeiManagement
    Created on : Jun 13, 2026, 10:18:05 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<!DOCTYPE html>

<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>UNILAP Admin - Serial &amp; IMEI Management</title>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&amp;family=Space+Grotesk:wght@600;700&amp;display=swap" rel="stylesheet"/>
<!-- Material Symbols -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<!-- Shared Components JSON & Style Guidance Logic -->
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "primary-container": "#0052ff",
                    "on-primary": "#ffffff",
                    "secondary-fixed-dim": "#b7c8e1",
                    "on-surface": "#191c1e",
                    "on-error": "#ffffff",
                    "tertiary-fixed": "#dae2fd",
                    "surface-tint": "#004ced",
                    "primary": "#003ec7",
                    "surface-variant": "#e0e3e5",
                    "tertiary-fixed-dim": "#bec6e0",
                    "inverse-on-surface": "#eff1f3",
                    "surface-container-lowest": "#ffffff",
                    "surface-dim": "#d8dadc",
                    "secondary-fixed": "#d3e4fe",
                    "secondary": "#505f76",
                    "tertiary": "#464e64",
                    "background": "#f7f9fb",
                    "outline": "#737688",
                    "surface-container-highest": "#e0e3e5",
                    "on-tertiary-container": "#dde4ff",
                    "error": "#ba1a1a",
                    "on-background": "#191c1e",
                    "secondary-container": "#d0e1fb",
                    "on-secondary": "#ffffff",
                    "surface-container-low": "#f2f4f6",
                    "tertiary-container": "#5e667d",
                    "on-secondary-fixed-variant": "#38485d",
                    "on-tertiary-fixed": "#131b2e",
                    "on-primary-container": "#dfe3ff",
                    "outline-variant": "#c3c5d9",
                    "on-surface-variant": "#434656",
                    "primary-fixed": "#dde1ff",
                    "on-primary-fixed": "#001452",
                    "on-primary-fixed-variant": "#0038b6",
                    "surface-container": "#eceef0",
                    "on-secondary-container": "#54647a",
                    "surface-container-high": "#e6e8ea",
                    "on-secondary-fixed": "#0b1c30",
                    "on-tertiary": "#ffffff",
                    "on-tertiary-fixed-variant": "#3f465c",
                    "primary-fixed-dim": "#b7c4ff",
                    "surface": "#f7f9fb",
                    "inverse-primary": "#b7c4ff",
                    "on-error-container": "#93000a",
                    "surface-bright": "#f7f9fb",
                    "inverse-surface": "#2d3133",
                    "error-container": "#ffdad6"
            },
            "borderRadius": {
                    "DEFAULT": "0.125rem",
                    "lg": "0.25rem",
                    "xl": "0.5rem",
                    "full": "0.75rem"
            },
            "spacing": {
                    "unit": "8px",
                    "margin-desktop": "64px",
                    "gutter": "24px",
                    "container-max": "1440px",
                    "margin-mobile": "20px"
            },
            "fontFamily": {
                    "headline-xl-mobile": ["Space Grotesk"],
                    "body-md": ["Inter"],
                    "body-sm": ["Inter"],
                    "headline-md": ["Space Grotesk"],
                    "label-md": ["Inter"],
                    "headline-xl": ["Space Grotesk"],
                    "code-sm": ["monospace"],
                    "headline-lg": ["Space Grotesk"],
                    "body-lg": ["Inter"]
            },
            "fontSize": {
                    "headline-xl-mobile": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                    "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "code-sm": ["13px", {"lineHeight": "18px", "fontWeight": "400"}],
                    "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                    "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}]
            }
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            vertical-align: middle;
        }
        body {
            background-color: #f7f9fb;
            font-family: 'Inter', sans-serif;
            color: #191c1e;
        }
        /* Custom Table Scrollbar */
        .table-container::-webkit-scrollbar {
            height: 6px;
        }
        .table-container::-webkit-scrollbar-track {
            background: transparent;
        }
        .table-container::-webkit-scrollbar-thumb {
            background: #e0e3e5;
            border-radius: 10px;
        }
    </style>
</head>
<body class="min-h-screen overflow-x-hidden">
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
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg bg-surface-container-low text-primary font-bold border-l-4 border-primary font-label-md text-sm font-medium transition-all" href="${pageContext.request.contextPath}/staff/imei">
            <span class="material-symbols-outlined icon-fill mr-3 text-[20px]">barcode_scanner</span> IMEI
        </a>
    </nav>
    
    <div class="mt-auto border-t border-outline-variant/20 pt-4 flex flex-col gap-1 px-2">
        <!-- Logout -->
        <a class="flex items-center px-4 py-3 mx-2 rounded-lg text-error hover:bg-error/10 transition-colors font-label-md text-sm font-medium" href="#">
            <span class="material-symbols-outlined mr-3 text-[20px]">logout</span> Logout
        </a>
    </div>
</aside>
<!-- Main Content Wrapper -->
<div class="md:ml-64 flex flex-col min-h-screen">
<!-- Top Navigation Bar -->
<header class="sticky top-0 z-50 flex justify-between items-center px-gutter w-full h-16 bg-surface-container-lowest border-b border-outline-variant">
<div class="flex items-center gap-4">
<div class="md:hidden">
<span class="material-symbols-outlined text-primary cursor-pointer" data-icon="menu">menu</span>
</div>
<div class="hidden sm:flex items-center bg-surface-container-high px-3 py-1.5 rounded-lg border border-outline-variant">
<span class="material-symbols-outlined text-on-surface-variant mr-2" data-icon="search">search</span>
<input class="bg-transparent border-none focus:ring-0 text-sm w-48 lg:w-64" placeholder="Global Search..." type="text"/>
</div>
</div>
<div class="flex items-center gap-4">
<button class="relative p-2 text-on-surface-variant hover:bg-surface-container-high rounded-full transition-colors">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
<span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full"></span>
</button>
<button class="p-2 text-on-surface-variant hover:bg-surface-container-high rounded-full transition-colors">
<span class="material-symbols-outlined" data-icon="help">help</span>
</button>
<div class="h-8 w-px bg-outline-variant"></div>
<div class="flex items-center gap-3 ml-2 cursor-pointer group">
<div class="text-right hidden sm:block">
<p class="text-label-md font-bold text-on-surface leading-tight">Admin User</p>
<p class="text-[10px] text-on-surface-variant uppercase tracking-tighter">Senior Manager</p>
</div>
<img alt="Admin Profile Avatar" class="w-10 h-10 rounded-full object-cover border border-outline-variant group-hover:border-primary transition-colors" data-alt="A professional close-up portrait of a senior tech executive with short-cropped hair, wearing a navy blue blazer and a crisp white shirt. The lighting is bright and directional, typical of a high-end corporate setting, with a soft-focus office background that aligns with the premium technical and modern aesthetic of the brand. The overall mood is confident, reliable, and sophisticated." src="https://lh3.googleusercontent.com/aida-public/AB6AXuA1Sau4ioT1_HXKgFYVEcjmnlVdseL3fnR1vmkUaGydsGHnGyABuvmG-G4yYKUjd7SgfCGOULZSgHXbrlJGCw3FQrnKBF47Hq6JEe6GHDByIOFflrGBwA08hIFur6Bl4XNOzOrAJz-wmwpzHnbpVGzTTFCTR2pKBVeCgSILvjkiesewPiQNCztghCxXRey7-j4zcxjrVxYmwKbNdSuotYK9g7mqyrzL1Dq4baccgIbNosb7MYCAAef9fZ6gw7FjBF2umSu7KL7lTALx"/>
</div>
</div>
</header>
<!-- Main Content Canvas -->
<main class="p-gutter lg:p-margin-desktop space-y-gutter">
<!-- Breadcrumbs & Header -->
<div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
<div>
<nav class="flex items-center gap-2 text-on-surface-variant mb-2">
<span class="text-body-sm font-body-sm hover:text-primary cursor-pointer">Inventory</span>
<span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
<span class="text-body-sm font-body-sm hover:text-primary cursor-pointer">Laptops</span>
<span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
<span class="text-body-sm font-body-sm text-primary font-bold">Serial Management</span>
</nav>
<h2 class="font-headline-lg text-headline-lg text-primary">Serial / IMEI Management</h2>

</div>
<div class="flex items-center gap-3">
<button class="bg-surface-container-high text-on-surface-variant px-4 py-2.5 rounded-lg border border-outline-variant flex items-center gap-2 hover:bg-surface-variant transition-colors font-label-md text-label-md">
<span class="material-symbols-outlined" data-icon="file_upload">file_upload</span> Bulk Import
                    </button>
    <a class="bg-primary text-on-primary px-4 py-2.5 rounded-lg flex items-center gap-2 shadow-sm hover:opacity-90 transition-opacity font-label-md text-label-md" href="/UniLap/staff/imei/add">
<span class="material-symbols-outlined" data-icon="add">add</span> Add New Serial
                    </a>
</div>
</div>
<!-- Inventory Stats Grid -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-gutter">
<div class="bg-surface-container-lowest p-6 border border-outline-variant rounded-xl flex items-center gap-4">
<div class="p-3 bg-primary-fixed text-on-primary-fixed rounded-lg">
<span class="material-symbols-outlined text-[32px]" data-icon="inventory">inventory</span>
</div>
<div>
<p class="text-label-md font-label-md text-on-surface-variant">Total Units</p>
<p class="text-headline-md font-headline-md">${totalUnits != null ? totalUnits : 0}</p>
</div>
</div>
<div class="bg-surface-container-lowest p-6 border border-outline-variant rounded-xl flex items-center gap-4">
<div class="p-3 bg-secondary-fixed text-on-secondary-fixed rounded-lg" style="background-color: #e8f5e9; color: #2e7d32;">
<span class="material-symbols-outlined text-[32px]" data-icon="check_circle">check_circle</span>
</div>
<div>
<p class="text-label-md font-label-md text-on-surface-variant">Available</p>
<p class="text-headline-md font-headline-md">${availableUnits != null ? availableUnits : 0}</p>
</div>
</div>
<div class="bg-surface-container-lowest p-6 border border-outline-variant rounded-xl flex items-center gap-4">
<div class="p-3 bg-secondary-fixed text-on-secondary-fixed rounded-lg" style="background-color: #fff3e0; color: #ef6c00;">
<span class="material-symbols-outlined text-[32px]" data-icon="sell">sell</span>
</div>
<div>
<p class="text-label-md font-label-md text-on-surface-variant">Sold / Active</p>
<p class="text-headline-md font-headline-md">${soldUnits != null ? soldUnits : 0}</p>
</div>
</div>
<div class="bg-surface-container-lowest p-6 border border-outline-variant rounded-xl flex items-center gap-4">
<div class="p-3 bg-secondary-fixed text-on-secondary-fixed rounded-lg" style="background-color: #ffebee; color: #c62828;">
<span class="material-symbols-outlined text-[32px]" data-icon="warning">warning</span>
</div>
<div>
<p class="text-label-md font-label-md text-on-surface-variant">Faulty / RMA</p>
<p class="text-headline-md font-headline-md">${faultyUnits != null ? faultyUnits : 0}</p>
</div>
</div>
</div>
<!-- Table Controls -->
<div class="bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden shadow-sm">
<form action="${pageContext.request.contextPath}/staff/imei" method="get" class="m-0">
<div class="p-4 border-b border-outline-variant bg-surface-container-low flex flex-col lg:flex-row gap-4 justify-between items-center">
<div class="flex items-center gap-3 w-full lg:w-auto">
<div class="relative w-full lg:w-80">
<span class="absolute left-3 top-1/2 -translate-y-1/2 material-symbols-outlined text-on-surface-variant text-[20px]" data-icon="search">search</span>
<input name="searchInput" value="${searchInput}" class="pl-10 pr-4 py-2 w-full bg-surface-container-lowest border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary-container focus:border-primary-container transition-all text-sm" placeholder="Search Serial or IMEI..." type="text"/>
</div>
<button type="submit" class="p-2 border border-outline-variant rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant bg-primary text-white" title="Search">
<span class="material-symbols-outlined" data-icon="search">search</span>
</button>
</div>
<div class="flex items-center gap-3 w-full lg:w-auto">
<select name="status" onchange="this.form.submit()" class="bg-surface-container-lowest border border-outline-variant rounded-lg text-sm px-4 py-2 focus:ring-primary-container">
<option value="All" ${statusFilter == 'All' ? 'selected' : ''}>Status: All</option>
<option value="Available" ${statusFilter == 'Available' ? 'selected' : ''}>Available</option>
<option value="Sold" ${statusFilter == 'Sold' ? 'selected' : ''}>Sold</option>
<option value="Reserved" ${statusFilter == 'Reserved' ? 'selected' : ''}>Reserved</option>
<option value="Damaged" ${statusFilter == 'Damaged' ? 'selected' : ''}>Damaged</option>
</select>
</div>
</div>
</form>
<!-- Identifier Table -->
<div class="table-container overflow-x-auto">
<table class="w-full text-left border-collapse min-w-[1000px]">
<thead>
<tr class="bg-inverse-surface text-on-primary">
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider">Serial / IMEI Number</th>
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider">Status</th>
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider">Received Date</th>
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider">Batch/Lot ID</th>
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider">Linked Order</th>
<th class="px-6 py-4 font-label-md text-label-md uppercase tracking-wider text-right">Actions</th>
</tr>
</thead>
<tbody class="divide-y divide-outline-variant">
<c:choose>
    <c:when test="${not empty items}">
        <c:forEach var="item" items="${items}">
            <tr class="hover:bg-surface-container-low transition-colors group">
            <td class="px-6 py-4">
            <p class="font-code-sm text-code-sm font-bold text-primary">${item.serialNumber != null ? item.serialNumber : "N/A"}</p>
            <p class="text-[11px] text-on-surface-variant font-code-sm">IMEI: ${item.imei != null ? item.imei : "N/A"}</p>
            <p class="text-[11px] text-on-surface-variant font-code-sm mt-1">Product: ${item.productName} (${item.sku})</p>
            </td>
            <td class="px-6 py-4">
            <c:choose>
                <c:when test="${item.status == 'Available'}">
                    <span class="px-2.5 py-1 rounded-full text-[12px] font-bold bg-[#e8f5e9] text-[#2e7d32] border border-[#a5d6a7]">Available</span>
                </c:when>
                <c:when test="${item.status == 'Sold'}">
                    <span class="px-2.5 py-1 rounded-full text-[12px] font-bold bg-[#fff3e0] text-[#ef6c00] border border-[#ffcc80]">Sold</span>
                </c:when>
                <c:when test="${item.status == 'Damaged'}">
                    <span class="px-2.5 py-1 rounded-full text-[12px] font-bold bg-[#ffebee] text-[#c62828] border border-[#ef9a9a]">Damaged</span>
                </c:when>
                <c:otherwise>
                    <span class="px-2.5 py-1 rounded-full text-[12px] font-bold bg-[#f3e5f5] text-[#7b1fa2] border border-[#ce93d8]">${item.status}</span>
                </c:otherwise>
            </c:choose>
            </td>
            <td class="px-6 py-4 text-body-sm font-body-sm text-on-surface-variant">${item.importDate}</td>
            <td class="px-6 py-4 text-body-sm font-body-sm text-on-surface-variant">${item.warehouseLocation != null ? item.warehouseLocation : "—"}</td>
            <td class="px-6 py-4 text-body-sm font-body-sm text-on-surface-variant italic">${item.note != null ? item.note : "—"}</td>
            <td class="px-6 py-4 text-right">
            <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
            <button class="p-1.5 hover:text-primary transition-colors"><span class="material-symbols-outlined" data-icon="edit">edit</span></button>
            <button class="p-1.5 hover:text-primary transition-colors"><span class="material-symbols-outlined" data-icon="history">history</span></button>
            </div>
            </td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <tr>
            <td colspan="6" class="px-6 py-8 text-center text-on-surface-variant">No items found matching your criteria.</td>
        </tr>
    </c:otherwise>
</c:choose>
</tbody>
</table>
</div>
<!-- Pagination Footer -->
<div class="p-4 bg-surface-container-lowest border-t border-outline-variant flex items-center justify-between">
<p class="text-body-sm font-body-sm text-on-surface-variant">
    Showing ${totalItems > 0 ? (currentPage - 1) * 10 + 1 : 0} to ${currentPage * 10 > totalItems ? totalItems : currentPage * 10} of ${totalItems} entries
</p>
<div class="flex items-center gap-1">
<c:set var="queryParams" value="" />
<c:if test="${not empty searchInput}"><c:set var="queryParams" value="${queryParams}&searchInput=${searchInput}" /></c:if>
<c:if test="${not empty statusFilter}"><c:set var="queryParams" value="${queryParams}&status=${statusFilter}" /></c:if>

<c:choose>
    <c:when test="${currentPage > 1}">
        <a href="?page=${currentPage - 1}${queryParams}" class="p-2 border border-outline-variant rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant">
            <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
        </a>
    </c:when>
    <c:otherwise>
        <a href="#" class="p-2 border border-outline-variant rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant pointer-events-none opacity-50">
            <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
        </a>
    </c:otherwise>
</c:choose>

<c:forEach begin="1" end="${totalPages}" var="i">
    <a href="?page=${i}${queryParams}" class="w-8 h-8 flex items-center justify-center rounded-lg text-sm font-bold transition-colors ${currentPage == i ? 'bg-primary text-on-primary' : 'hover:bg-surface-container-high text-on-surface'}">${i}</a>
</c:forEach>

<c:choose>
    <c:when test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}${queryParams}" class="p-2 border border-outline-variant rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant">
            <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
        </a>
    </c:when>
    <c:otherwise>
        <a href="#" class="p-2 border border-outline-variant rounded-lg hover:bg-surface-container-high transition-colors text-on-surface-variant pointer-events-none opacity-50">
            <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
        </a>
    </c:otherwise>
</c:choose>
</div>
</div>
</div>
</main>
<!-- Footer -->
<footer class="mt-auto p-gutter border-t border-outline-variant bg-surface-container-lowest">
<div class="flex flex-col sm:flex-row justify-between items-center gap-4 text-on-surface-variant text-body-sm font-body-sm">
<p>© 2023 UNILAP Enterprise Ecosystem. All rights reserved.</p>
<div class="flex gap-6">
<a class="hover:text-primary" href="#">System Logs</a>
<a class="hover:text-primary" href="#">API Reference</a>
<a class="hover:text-primary" href="#">Security Audit</a>
</div>
</div>
</footer>
</div>
<!-- Micro-interaction Script -->
<script>
        document.addEventListener('DOMContentLoaded', () => {
            // Simple animation for numbers (counter effect placeholder)
            const stats = document.querySelectorAll('.text-headline-md');
            stats.forEach(stat => {
                stat.style.opacity = '0';
                stat.style.transform = 'translateY(10px)';
                setTimeout(() => {
                    stat.style.transition = 'all 0.6s cubic-bezier(0.22, 1, 0.36, 1)';
                    stat.style.opacity = '1';
                    stat.style.transform = 'translateY(0)';
                }, 200);
            });

            // Table row highlight logic
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                row.addEventListener('mouseenter', () => {
                    row.classList.add('shadow-inner');
                });
                row.addEventListener('mouseleave', () => {
                    row.classList.remove('shadow-inner');
                });
            });
        });
    </script>
</body></html>

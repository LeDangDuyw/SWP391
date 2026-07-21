<%-- 
    Document   : ImeiManagement
    Created on : Jun 13, 2026, 10:18:05 PM
    Author     : huy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Admin - Serial &amp; IMEI Management</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&amp;family=Space+Grotesk:wght@600;700&amp;display=swap" rel="stylesheet">
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
    model.Users u = (model.Users) session.getAttribute("user");
%>
<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Quản lý kho</a>
            <a href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Danh mục</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/imei"><span>🏷</span>Quản lý Serial</a>
            <a href="${pageContext.request.contextPath}/staff/ticket/list"><span>🎫</span>Phiếu hỗ trợ</a>
            <a href="${pageContext.request.contextPath}/staff/order/list"><span>📋</span>Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>📦</span>Xuất kho</a>
            <a href="${pageContext.request.contextPath}/staff/reviews"><span>★</span>Đánh giá sản phẩm</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Bảo hành</a>
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <%
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
        <!-- Top Navigation Bar -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-4 w-1/3"></div>
            <div class="flex items-center gap-4">
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">help_outline</span>
                </button>
                <div class="h-8 w-8 rounded-full overflow-hidden ml-2 border border-outline-variant/50 flex items-center justify-center bg-primary-container" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                    <%
                        if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                    %>
                        <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                             alt="Avatar" class="h-full w-full object-cover">
                    <% } else { %>
                        <span class="material-symbols-outlined text-on-primary-container">person</span>
                    <% } %>
                </div>
            </div>
        </header>

        <!-- Main Content Canvas -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">
            <!-- Breadcrumbs & Header -->
            <div class="flex justify-between items-end mb-4">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Serial / IMEI Management</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Manage product serial numbers and IMEIs for stock tracking.</p>
                </div>
                <div class="flex items-center gap-2">
                    <button class="px-4 py-2 bg-surface border border-outline-variant/50 rounded-lg hover:bg-surface-container-high transition-colors font-label-md text-label-md text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">file_upload</span> Bulk Import
                    </button>
                </div>
            </div>

            <!-- Inventory Stats Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                <div class="bg-surface border border-outline-variant/30 rounded-xl p-5 flex items-center gap-4 shadow-sm">
                    <div class="p-3 bg-primary-fixed text-on-primary-fixed rounded-lg">
                        <span class="material-symbols-outlined text-[32px]">inventory</span>
                    </div>
                    <div>
                        <p class="text-label-md font-label-md text-on-surface-variant">Total Units</p>
                        <p class="text-headline-md font-headline-md text-on-surface">${totalUnits != null ? totalUnits : 0}</p>
                    </div>
                </div>
                <div class="bg-surface border border-outline-variant/30 rounded-xl p-5 flex items-center gap-4 shadow-sm">
                    <div class="p-3 bg-secondary-fixed text-on-secondary-fixed rounded-lg" style="background-color: #e8f5e9; color: #2e7d32;">
                        <span class="material-symbols-outlined text-[32px]">check_circle</span>
                    </div>
                    <div>
                        <p class="text-label-md font-label-md text-on-surface-variant">In Stock</p>
                        <p class="text-headline-md font-headline-md text-on-surface">${inStockUnits != null ? inStockUnits : 0}</p>
                    </div>
                </div>
                <div class="bg-surface border border-outline-variant/30 rounded-xl p-5 flex items-center gap-4 shadow-sm">
                    <div class="p-3 bg-secondary-fixed text-on-secondary-fixed rounded-lg" style="background-color: #fff3e0; color: #ef6c00;">
                        <span class="material-symbols-outlined text-[32px]">sell</span>
                    </div>
                    <div>
                        <p class="text-label-md font-label-md text-on-surface-variant">Sold / Active</p>
                        <p class="text-headline-md font-headline-md text-on-surface">${soldUnits != null ? soldUnits : 0}</p>
                    </div>
                </div>
            </div>

            <!-- Table Controls -->
            <div class="flex flex-col gap-4 mb-6">
                <form action="${pageContext.request.contextPath}/staff/imei" method="get" class="w-full">
                    <div class="bg-surface border border-outline-variant/30 rounded-xl p-4 flex flex-wrap items-center gap-4 shadow-sm">
                        <div class="relative flex-1 min-w-[300px]">
                            <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
                            <input type="text" name="searchInput" value="${searchInput}" placeholder="Search Serial or IMEI..." class="w-full pl-12 pr-4 py-2.5 bg-surface-container-low border border-outline-variant/50 rounded-lg font-body-sm text-body-sm text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary placeholder-on-surface-variant/60 transition-all">
                            <button type="submit" class="absolute right-1 top-1 bottom-1 px-3 bg-blue-600 hover:bg-blue-700 text-white rounded flex items-center justify-center transition-colors">
                                <span class="material-symbols-outlined text-sm">search</span>
                            </button>
                        </div>

                        <div class="relative">
                            <select name="status" onchange="this.form.submit()" class="appearance-none pl-4 pr-10 py-2.5 bg-surface border border-outline-variant/50 rounded-lg text-on-surface font-label-md text-label-md focus:ring-0 focus:border-primary outline-none cursor-pointer">
                                <option value="All" ${statusFilter == 'All' ? 'selected' : ''}>Status: All</option>
                                <option value="in_stock" ${statusFilter == 'in_stock' ? 'selected' : ''}>In Stock</option>
                                <option value="sold" ${statusFilter == 'sold' ? 'selected' : ''}>Sold</option>
                            </select>
                            <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-on-surface-variant text-[18px]">expand_more</span>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Identifier Table -->
            <div class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-on-surface text-on-primary font-label-md text-label-md">
                                <th class="px-6 py-4">Serial / IMEI Number</th>
                                <th class="px-6 py-4">Status</th>
                                <th class="px-6 py-4">Received Date</th>
                                <th class="px-6 py-4">Linked Order</th>
                                <th class="px-6 py-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant/30 bg-surface-container-lowest font-body-sm text-body-sm">
                            <c:choose>
                                <c:when test="${not empty items}">
                                    <c:forEach var="item" items="${items}">
                                        <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest group">
                                            <td class="px-6 py-4">
                                                <p class="font-code-sm text-code-sm font-bold text-primary">${item.serialNumber != null ? item.serialNumber : "N/A"}</p>
                                                <p class="text-[11px] text-on-surface-variant font-code-sm">IMEI: ${item.imei != null ? item.imei : "N/A"}</p>
                                                <p class="text-[11px] text-on-surface-variant font-code-sm mt-1">Product: ${item.productName} (${item.sku})</p>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${item.status == 'in_stock'}">
                                                        <span class="inline-flex items-center px-2 py-1 rounded bg-emerald-50 text-emerald-700 border border-emerald-200 text-[12px] font-bold">in_stock</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'sold'}">
                                                        <span class="inline-flex items-center px-2 py-1 rounded bg-orange-50 text-orange-700 border border-orange-200 text-[12px] font-bold">sold</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-2 py-1 rounded bg-purple-50 text-purple-700 border border-purple-200 text-[12px] font-bold">${item.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-on-surface-variant">${item.importDate}</td>
                                            <td class="px-6 py-4 text-on-surface-variant italic">${item.note != null ? item.note : "—"}</td>
                                            <td class="px-6 py-4 text-right">
                                                <div class="flex items-center justify-end gap-2">
                                                    <button class="p-1.5 text-on-surface-variant hover:text-primary transition-colors" title="Edit">
                                                        <span class="material-symbols-outlined text-[20px]">edit</span>
                                                    </button>
                                                    <button class="p-1.5 text-on-surface-variant hover:text-primary transition-colors" title="History">
                                                        <span class="material-symbols-outlined text-[20px]">history</span>
                                                    </button>
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
                <div class="bg-surface px-4 py-3 border-t border-outline-variant/30 flex items-center justify-between">
                    <c:set var="queryParams" value="" />
                    <c:if test="${not empty searchInput}"><c:set var="queryParams" value="${queryParams}&searchInput=${searchInput}" /></c:if>
                    <c:if test="${not empty statusFilter}"><c:set var="queryParams" value="${queryParams}&status=${statusFilter}" /></c:if>

                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}${queryParams}" class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low">
                                Previous
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md pointer-events-none opacity-50">
                                Previous
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <div class="flex gap-1 items-center flex-wrap">
                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="?page=${i}${queryParams}" class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == i ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Page 1 -->
                                <a href="?page=1${queryParams}" class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == 1 ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">1</a>

                                <c:if test="${currentPage > 4}">
                                    <span class="px-1 text-on-surface-variant font-label-md">...</span>
                                </c:if>

                                <!-- Middle pages -->
                                <c:set var="startPage" value="${currentPage - 2}" />
                                <c:set var="endPage" value="${currentPage + 2}" />
                                
                                <c:if test="${startPage < 2}">
                                    <c:set var="startPage" value="2" />
                                    <c:set var="endPage" value="6" />
                                </c:if>
                                <c:if test="${endPage >= totalPages}">
                                    <c:set var="startPage" value="${totalPages - 5}" />
                                    <c:set var="endPage" value="${totalPages - 1}" />
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <a href="?page=${i}${queryParams}" class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == i ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 3}">
                                    <span class="px-1 text-on-surface-variant font-label-md">...</span>
                                </c:if>

                                <!-- Last page -->
                                <a href="?page=${totalPages}${queryParams}" class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == totalPages ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}${queryParams}" class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low">
                                Next
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md pointer-events-none opacity-50">
                                Next
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Micro-interaction Script -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Simple animation for numbers
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
    });
</script>
</body>
</html>

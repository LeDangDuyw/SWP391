<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@page import="java.util.*" %>
            <%@page import="model.Category" %>
                <!DOCTYPE html>
                <html class="light" lang="en">

                <head>
                    <meta charset="utf-8">
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <title>UNILAP Admin - Quản lý Danh mục</title>
                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                        rel="stylesheet">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&amp;family=Space+Grotesk:wght@600;700&amp;display=swap"
                        rel="stylesheet">
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
                                        "on-primamaner": "#dfe3ff",
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
                                        "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
                                        "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "600" }],
                                        "headline-xl": ["48px", { "lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                                        "code-sm": ["13px", { "lineHeight": "18px", "fontWeight": "400" }],
                                        "headline-xl-mobile": ["32px", { "lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700" }],
                                        "body-sm": ["14px", { "lineHeight": "20px", "fontWeight": "400" }],
                                        "label-md": ["14px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600" }],
                                        "body-md": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
                                        "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "600" }]
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
                <% model.Users u=(model.Users) session.getAttribute("user"); List<Category> categories = (List<Category>
                        ) request.getAttribute("categories");
                        if (categories == null) {
                        categories = new ArrayList<Category>();
                            }
                            %>

                            <body class="bg-background text-on-surface font-body-md min-h-screen">
                                <div class="layout">
                                    <!-- Sidebar Navigation -->
                                    <jsp:include page="/staff/sidebar.jsp">
                                        <jsp:param name="activePage" value="category" />
                                    </jsp:include>

                                    <div class="main">

                                        <header
                                            class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
                                            <div class="flex items-center gap-4 w-1/3"></div>
                                            <div class="flex items-center gap-4">
                                                <button
                                                    class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                                                    <span class="material-symbols-outlined">help_outline</span>
                                                </button>
                                                <div class="h-8 w-8 rounded-full overflow-hidden ml-2 border border-outline-variant/50 flex items-center justify-center bg-primary-container"
                                                    style="cursor: pointer;"
                                                    onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                                                    <% if (u !=null && u.getAvatarUrl() !=null &&
                                                        !u.getAvatarUrl().trim().isEmpty()) { %>
                                                        <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>"
                                                            alt="Avatar" class="h-full w-full object-cover">
                                                        <% } else { %>
                                                            <span
                                                                class="material-symbols-outlined text-on-primary-container">person</span>
                                                            <% } %>
                                                </div>
                                            </div>
                                        </header>

                                        <main class="flex-1 p-gutter bg-surface-container-lowest relative">

                                            <div class="flex justify-between items-end mb-4">
                                                <div>
                                                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">
                                                        Quản lý Danh mục</h2>
                                                    <p class="font-body-sm text-body-sm text-on-surface-variant">Quản lý
                                                        các danh mục sản phẩm để phân loại kho hàng.</p>
                                                </div>
                                            </div>

                                            <div class="flex flex-col gap-4 mb-8">
                                                <div
                                                    class="bg-surface border border-outline-variant/30 rounded-xl p-4 flex flex-wrap items-center gap-4 shadow-sm">
                                                    <form action="${pageContext.request.contextPath}/staff/category"
                                                        method="get" class="flex-1 flex gap-4">
                                                        <div class="relative flex-1 min-w-[300px]">
                                                            <span
                                                                class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
                                                            <input type="text" name="searchInput"
                                                                value="${param.searchInput}"
                                                                placeholder="Tìm kiếm danh mục theo tên..."
                                                                class="w-full pl-12 pr-4 py-2.5 bg-surface-container-low border border-outline-variant/50 rounded-lg font-body-sm text-body-sm text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary placeholder-on-surface-variant/60 transition-all">
                                                            <button type="submit"
                                                                class="absolute right-1 top-1 bottom-1 px-3 bg-blue-600 hover:bg-blue-700 text-white rounded flex items-center justify-center transition-colors">
                                                                <span
                                                                    class="material-symbols-outlined text-sm">search</span>
                                                            </button>
                                                        </div>
                                                    </form>

                                                    <div class="flex items-center gap-2 ml-auto">
                                                        <button onclick="openAddModal()"
                                                            class="px-4 py-2.5 bg-primary text-on-primary rounded-lg hover:bg-primary/90 transition-colors font-label-md text-label-md flex items-center gap-2 shadow-sm">
                                                            <span
                                                                class="material-symbols-outlined text-[20px]">add</span>
                                                            Thêm danh mục
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div
                                                class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                                                <div class="overflow-x-auto">
                                                    <table class="w-full text-left border-collapse">
                                                        <thead>
                                                            <tr
                                                                class="bg-on-surface text-on-primary font-label-md text-label-md">
                                                                <th
                                                                    class="py-3 px-4 border-b border-outline-variant/20 w-32">
                                                                    Mã danh mục</th>
                                                                <th
                                                                    class="py-3 px-4 border-b border-outline-variant/20">
                                                                    Tên danh mục</th>
                                                                <th
                                                                    class="py-3 px-4 border-b border-outline-variant/20 text-right w-32">
                                                                    Hành động</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="font-body-sm text-body-sm">
                                                            <% for(Category c: categories) { %>
                                                                <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest"
                                                                    data-id="<%= c.getCategoryId() %>"
                                                                    data-name="<%= c.getCategoryName() %>">
                                                                    <td class="py-2 px-4 font-bold">
                                                                        <%= c.getCategoryId() %>
                                                                    </td>
                                                                    <td class="py-2 px-4">
                                                                        <%= c.getCategoryName() %>
                                                                    </td>
                                                                    <td
                                                                        class="py-2 px-4 text-right flex items-center justify-end gap-2">
                                                                        <button type="button"
                                                                            onclick="openSpecsModal(<%= c.getCategoryId() %>, '<%= c.getCategoryName().replace("'", "\\'") %>')"
                                                                            title="Quản lý thông số cấu hình"
                                                                            class="px-2.5 py-1 text-blue-600 hover:bg-blue-50 border border-blue-200 rounded-lg transition-colors flex items-center gap-1 font-semibold text-xs">
                                                                            <span
                                                                                class="material-symbols-outlined text-[16px]">tune</span>
                                                                            Thông số
                                                                        </button>
                                                                        <button type="button"
                                                                            onclick="openEditModal(this)"
                                                                            title="Chỉnh sửa tên danh mục"
                                                                            class="p-1 text-on-surface-variant hover:text-primary transition-colors">
                                                                            <span
                                                                                class="material-symbols-outlined text-[20px]">edit</span>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <!-- Pagination Footer -->
                                                <div
                                                    class="bg-surface px-4 py-3 border-t border-outline-variant/30 flex items-center justify-between">
                                                    <c:set var="queryParams" value="" />
                                                    <c:if test="${not empty searchInput}">
                                                        <c:set var="queryParams"
                                                            value="${queryParams}&searchInput=${searchInput}" />
                                                    </c:if>

                                                    <c:choose>
                                                        <c:when test="${currentPage > 1}">
                                                            <a href="?page=${currentPage - 1}${queryParams}"
                                                                class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low">
                                                                Trước
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="#"
                                                                class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md pointer-events-none opacity-50">
                                                                Trước
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <div class="flex gap-1 items-center flex-wrap">
                                                        <c:choose>
                                                            <c:when test="${totalPages <= 5}">
                                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                                    <a href="?page=${i}${queryParams}"
                                                                        class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == i ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- 3 trang đầu tiên -->
                                                                <c:forEach begin="1" end="3" var="i">
                                                                    <a href="?page=${i}${queryParams}"
                                                                        class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == i ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                                                </c:forEach>

                                                                <!-- Nút ... và ô nhập số trang -->
                                                                <div
                                                                    class="relative flex items-center justify-center w-8 h-8">
                                                                    <button type="button"
                                                                        onclick="toggleJumpPageInput(this)"
                                                                        class="w-full h-full text-on-surface-variant font-label-md hover:text-primary transition-colors cursor-pointer">...</button>
                                                                    <div
                                                                        class="jumpPageForm absolute bottom-full left-1/2 -translate-x-1/2 mb-2 hidden bg-surface border border-outline-variant/50 p-2 rounded-lg shadow-lg z-10 flex gap-2">
                                                                        <input type="number" min="1" max="${totalPages}"
                                                                            placeholder="Trang"
                                                                            class="jumpPageInput w-20 px-2 py-1 border border-outline-variant rounded text-body-sm focus:border-primary outline-none"
                                                                            onkeydown="if(event.key === 'Enter') jumpToPage(this)">
                                                                        <button type="button" onclick="jumpToPage(this)"
                                                                            class="px-2 py-1 bg-primary text-on-primary rounded text-label-md whitespace-nowrap">Đi</button>
                                                                    </div>
                                                                </div>

                                                                <!-- 2 trang cuối -->
                                                                <c:forEach begin="${totalPages - 1}" end="${totalPages}"
                                                                    var="i">
                                                                    <a href="?page=${i}${queryParams}"
                                                                        class="w-8 h-8 flex items-center justify-center rounded font-label-md text-label-md ${currentPage == i ? 'bg-primary text-on-primary' : 'text-on-surface hover:bg-surface-container-low'}">${i}</a>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <c:choose>
                                                        <c:when test="${currentPage < totalPages}">
                                                            <a href="?page=${currentPage + 1}${queryParams}"
                                                                class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low">
                                                                Sau
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="#"
                                                                class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md pointer-events-none opacity-50">
                                                                Sau
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                        </main>
                                    </div>

                                    <!-- Modals -->
                                    <!-- Add Modal -->
                                    <div id="addModal"
                                        class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
                                        <div
                                            class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-md p-6">
                                            <div class="flex items-center justify-between mb-6">
                                                <h3 class="font-headline-md text-headline-md font-bold text-on-surface">
                                                    Thêm danh mục</h3>
                                                <button type="button" onclick="closeAddModal()"
                                                    class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                                                    <span class="material-symbols-outlined">close</span>
                                                </button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/staff/category"
                                                method="post" class="flex flex-col gap-4">
                                                <input type="hidden" name="action" value="add" />
                                                <% if(request.getParameter("searchInput") !=null) { %>
                                                    <input type="hidden" name="searchInput"
                                                        value="${param.searchInput}">
                                                    <% } %>

                                                        <div>
                                                            <label
                                                                class="block font-label-md text-label-md text-on-surface-variant mb-1">Tên
                                                                danh mục</label>
                                                            <input type="text" name="categoryName"
                                                                class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all"
                                                                required placeholder="Nhập tên danh mục" />
                                                        </div>

                                                        <div class="mt-6 flex justify-end gap-3">
                                                            <button type="button" onclick="closeAddModal()"
                                                                class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg">Hủy</button>
                                                            <button type="submit"
                                                                class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20">Thêm</button>
                                                        </div>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Edit Modal -->
                                    <div id="editModal"
                                        class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
                                        <div
                                            class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-md p-6">
                                            <div class="flex items-center justify-between mb-6">
                                                <h3 class="font-headline-md text-headline-md font-bold text-on-surface">
                                                    Chỉnh sửa danh mục</h3>
                                                <button type="button" onclick="closeEditModal()"
                                                    class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                                                    <span class="material-symbols-outlined">close</span>
                                                </button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/staff/category"
                                                method="post" class="flex flex-col gap-4">
                                                <input type="hidden" name="action" value="update" />
                                                <input type="hidden" name="categoryId" id="editCategoryId" value="" />
                                                <% if(request.getParameter("searchInput") !=null) { %>
                                                    <input type="hidden" name="searchInput"
                                                        value="${param.searchInput}">
                                                    <% } %>

                                                        <div>
                                                            <label
                                                                class="block font-label-md text-label-md text-on-surface-variant mb-1">Tên
                                                                danh mục</label>
                                                            <input type="text" name="categoryName" id="editCategoryName"
                                                                class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all"
                                                                required />
                                                        </div>

                                                        <div class="mt-6 flex justify-end gap-3">
                                                            <button type="button" onclick="closeEditModal()"
                                                                class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg">Hủy</button>
                                                            <button type="submit"
                                                                class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20">Lưu</button>
                                                        </div>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Specs Management Modal -->
                                    <div id="specsModal"
                                        class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
                                        <div
                                            class="bg-white border border-slate-200 rounded-xl shadow-2xl w-full max-w-lg p-6 max-h-[85vh] flex flex-col">
                                            <div
                                                class="flex items-center justify-between pb-4 border-b border-slate-100 mb-4">
                                                <div>
                                                    <h3 class="font-bold text-lg text-slate-800" id="specsModalTitle">
                                                        Thông số cấu hình</h3>
                                                    <p class="text-xs text-slate-500">Tích chọn các thuộc tính cấu hình
                                                        hiển thị cho danh mục này.</p>
                                                </div>
                                                <button type="button" onclick="closeSpecsModal()"
                                                    class="p-1 text-slate-400 hover:text-slate-600 rounded-full">
                                                    <span class="material-symbols-outlined">close</span>
                                                </button>
                                            </div>

                                            <div class="flex-1 overflow-y-auto pr-1">
                                                <div class="mb-4">
                                                    <label class="block text-xs font-semibold text-slate-700 mb-2">DANH
                                                        SÁCH THUỘC TÍNH CẤU HÌNH CÓ SẴN:</label>
                                                    <div id="specsListContainer" class="grid grid-cols-2 gap-2">
                                                        <!-- Dynamic checkboxes loaded via JS -->
                                                    </div>
                                                </div>

                                                <div class="mt-6 pt-4 border-t border-slate-100">
                                                    <label class="block text-xs font-semibold text-slate-700 mb-1">THÊM
                                                        THUỘC TÍNH KỸ THUẬT MỚI:</label>
                                                    <div class="flex gap-2">
                                                        <input type="text" id="newSpecNameInput"
                                                            placeholder="VD: Tần số quét, Tỷ lệ khung hình..."
                                                            class="flex-1 px-3 py-2 text-sm border border-slate-300 rounded-lg outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600">
                                                        <button type="button" onclick="addCustomSpecMaster()"
                                                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-semibold text-xs transition-colors flex items-center gap-1">
                                                            <span
                                                                class="material-symbols-outlined text-[16px]">add</span>
                                                            Thêm mới
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="pt-4 border-t border-slate-100 mt-4 flex justify-end">
                                                <button type="button" onclick="closeSpecsModal()"
                                                    class="px-5 py-2 bg-slate-800 text-white font-semibold text-xs rounded-lg hover:bg-slate-900 transition-colors">Xong</button>
                                            </div>
                                        </div>
                                    </div>

                                    <script>
                                        let currentSpecCategoryId = null;

                                        function openAddModal() {
                                            document.getElementById('addModal').classList.remove('hidden');
                                        }

                                        function closeAddModal() {
                                            document.getElementById('addModal').classList.add('hidden');
                                        }

                                        function openEditModal(btn) {
                                            const tr = btn.closest('tr');
                                            const id = tr.getAttribute('data-id');
                                            const name = tr.getAttribute('data-name');

                                            document.getElementById('editCategoryId').value = id;
                                            document.getElementById('editCategoryName').value = name;

                                            document.getElementById('editModal').classList.remove('hidden');
                                        }

                                        function closeEditModal() {
                                            document.getElementById('editModal').classList.add('hidden');
                                        }

                                        function openSpecsModal(categoryId, categoryName) {
                                            currentSpecCategoryId = categoryId;
                                            document.getElementById('specsModalTitle').innerText = 'Thông số cấu hình: ' + categoryName;
                                            document.getElementById('specsModal').classList.remove('hidden');
                                            loadCategorySpecs(categoryId);
                                        }

                                        function closeSpecsModal() {
                                            document.getElementById('specsModal').classList.add('hidden');
                                            currentSpecCategoryId = null;
                                        }

                                        function loadCategorySpecs(categoryId) {
                                            const container = document.getElementById('specsListContainer');
                                            container.innerHTML = '<div class="col-span-2 text-center text-slate-400 py-4 text-xs">Đang tải thuộc tính...</div>';

                                            fetch('${pageContext.request.contextPath}/staff/category?action=getSpecs&categoryId=' + categoryId)
                                                .then(res => res.json())
                                                .then(data => {
                                                    const activeSpecIds = new Set(data.categorySpecs.map(s => s.specId));
                                                    container.innerHTML = '';

                                                    if (!data.masterSpecs || data.masterSpecs.length === 0) {
                                                        container.innerHTML = '<div class="col-span-2 text-center text-slate-400 py-2 text-xs">Chưa có thuộc tính nào.</div>';
                                                        return;
                                                    }

                                                    data.masterSpecs.forEach(s => {
                                                        const checked = activeSpecIds.has(s.specId);
                                                        const item = document.createElement('label');
                                                        item.className = 'flex items-center gap-2 p-2 rounded-lg border ' + (checked ? 'border-blue-300 bg-blue-50/50 text-blue-900 font-semibold' : 'border-slate-200 hover:bg-slate-50 text-slate-700') + ' cursor-pointer text-xs transition-colors';
                                                        item.innerHTML = '<input type="checkbox" ' + (checked ? 'checked' : '') + ' onchange="toggleCategorySpec(' + categoryId + ', ' + s.specId + ', this.checked)" class="rounded text-blue-600 focus:ring-blue-500"> <span>' + s.specName + '</span>';
                                                        container.appendChild(item);
                                                    });
                                                })
                                                .catch(err => {
                                                    console.error(err);
                                                    container.innerHTML = '<div class="col-span-2 text-center text-red-500 py-2 text-xs">Lỗi tải dữ liệu.</div>';
                                                });
                                        }

                                        function toggleCategorySpec(categoryId, specId, isChecked) {
                                            const action = isChecked ? 'addCategorySpec' : 'removeCategorySpec';
                                            const params = new URLSearchParams();
                                            params.append('action', action);
                                            params.append('categoryId', categoryId);
                                            params.append('specId', specId);

                                            fetch('${pageContext.request.contextPath}/staff/category', {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                body: params.toString()
                                            })
                                                .then(res => res.json())
                                                .then(data => {
                                                    if (data.success) {
                                                        loadCategorySpecs(categoryId);
                                                    }
                                                });
                                        }

                                        function addCustomSpecMaster() {
                                            const input = document.getElementById('newSpecNameInput');
                                            const name = input.value.trim();
                                            if (!name || !currentSpecCategoryId) return;

                                            const params = new URLSearchParams();
                                            params.append('action', 'addMasterSpec');
                                            params.append('categoryId', currentSpecCategoryId);
                                            params.append('specName', name);

                                            fetch('${pageContext.request.contextPath}/staff/category', {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                body: params.toString()
                                            })
                                                .then(res => res.json())
                                                .then(data => {
                                                    if (data.success) {
                                                        input.value = '';
                                                        loadCategorySpecs(currentSpecCategoryId);
                                                    }
                                                });
                                        }

                                        function toggleJumpPageInput(button) {
                                            const container = button.nextElementSibling;
                                            container.classList.toggle('hidden');
                                            if (!container.classList.contains('hidden')) {
                                                container.querySelector('.jumpPageInput').focus();
                                            }
                                        }

                                        function jumpToPage(element) {
                                            const container = element.closest('.jumpPageForm');
                                            const input = container.querySelector('.jumpPageInput');
                                            let page = parseInt(input.value);
                                            const maxPage = parseInt(input.getAttribute('max'));

                                            if (page && page >= 1 && page <= maxPage) {
                                                const urlParams = new URLSearchParams(window.location.search);
                                                urlParams.set('page', page);
                                                window.location.search = urlParams.toString();
                                            } else {
                                                alert('Vui lòng nhập trang từ 1 đến ' + maxPage);
                                            }
                                        }
                                    </script>
                            </body>

                </html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Category"%>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Admin - Category Management</title>
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
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    if (categories == null) {
        categories = new ArrayList<Category>(); 
    }
%>
<body class="bg-background text-on-surface font-body-md min-h-screen flex">

        <aside class="sidebar">
        <div class="brand"><span>UNILAP Staff</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
            <a href="${pageContext.request.contextPath}/staff/inventory"><span>▤</span>Inventory</a>
            <a class="active" href="${pageContext.request.contextPath}/staff/category"><span>📁</span>Category</a>
        </nav>
        <div class="profile">♙ <span>Admin User Profile</span></div>
    </aside>

    <div class="flex-1 ml-72 flex flex-col min-h-screen">
        
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

        <main class="flex-1 p-gutter bg-surface-container-lowest relative">
            
            <div class="flex justify-between items-end mb-4">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Category Management</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Manage product categories for inventory classification.</p>
                </div>
            </div>

            <div class="flex flex-col gap-4 mb-8">
                <div class="bg-surface border border-outline-variant/30 rounded-xl p-4 flex flex-wrap items-center gap-4 shadow-sm">
                    <form action="${pageContext.request.contextPath}/staff/category" method="get" class="flex-1 flex gap-4">
                        <div class="relative flex-1 min-w-[300px]">
                            <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
                            <input type="text" name="searchInput" value="${param.searchInput}" placeholder="Search category by name..." class="w-full pl-12 pr-4 py-2.5 bg-surface-container-low border border-outline-variant/50 rounded-lg font-body-sm text-body-sm text-on-surface focus:ring-2 focus:ring-primary/20 focus:border-primary placeholder-on-surface-variant/60 transition-all">
                            <button type="submit" 
                                    class="absolute right-1 top-1 bottom-1 px-3 bg-blue-600 hover:bg-blue-700 text-white rounded flex items-center justify-center transition-colors">
                                <span class="material-symbols-outlined text-sm">search</span>
                            </button>
                        </div>
                    </form>

                    <div class="flex items-center gap-2 ml-auto">
                        <button onclick="openAddModal()" class="px-4 py-2.5 bg-primary text-on-primary rounded-lg hover:bg-primary/90 transition-colors font-label-md text-label-md flex items-center gap-2 shadow-sm">
                            <span class="material-symbols-outlined text-[20px]">add</span> Add Category
                        </button>
                    </div>
                </div>
            </div>

            <div class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-on-surface text-on-primary font-label-md text-label-md">
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-12"><input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox"></th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-32">Category ID</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20">Category Name</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 text-right w-32">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="font-body-sm text-body-sm">
                            <% 
                               for(Category c: categories) { 
                            %>
                            <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest" data-id="<%= c.getCategoryId() %>" data-name="<%= c.getCategoryName() %>">
                                <td class="py-2 px-4"><input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox"></td>
                                <td class="py-2 px-4 font-bold"><%= c.getCategoryId() %></td>
                                <td class="py-2 px-4"><%= c.getCategoryName() %></td>
                                <td class="py-2 px-4 text-right">
                                    <button type="button" onclick="openEditModal(this)" class="p-1 text-on-surface-variant hover:text-primary transition-colors">
                                        <span class="material-symbols-outlined text-[20px]">edit</span>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/staff/category" method="post" class="inline-block">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="categoryIdToDelete" value="<%= c.getCategoryId() %>">
                                        <% if(request.getParameter("searchInput") != null) { %>
                                            <input type="hidden" name="searchInput" value="${param.searchInput}">
                                        <% } %>
                                        <button class="p-1 text-on-surface-variant hover:text-error transition-colors" onclick="return confirm('Bạn có chắc chắn muốn xóa category này không? Thao tác này sẽ xóa cứng (Hard Delete) khỏi Database!');">
                                            <span class="material-symbols-outlined text-[20px]">delete</span>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %> 
                        </tbody>
                    </table>
                </div>
                
                <div class="bg-surface px-4 py-3 border-t border-outline-variant/30 flex items-center justify-between">
                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    if (currentPage == null) currentPage = 1;
                    if (totalPages == null) totalPages = 1; 

                    String searchInputAttr = request.getParameter("searchInput") != null ? "&searchInput=" + request.getParameter("searchInput") : "";
                    String queryStr = searchInputAttr;
                %>
                    <a href="?page=<%= currentPage > 1 ? currentPage - 1 : 1 %><%= queryStr %>" 
                       class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low <%= currentPage == 1 ? "pointer-events-none opacity-50" : "" %>">
                       Previous
                    </a>
                    <div class="flex gap-1">
                    <% for(int i = 1; i <= totalPages; i++) { %>
                        <a href="?page=<%= i %><%= queryStr %>" 
                           class="w-8 h-8 flex items-center justify-center rounded <%= currentPage == i ? "bg-primary text-on-primary" : "text-on-surface hover:bg-surface-container-low" %> font-label-md text-label-md">
                           <%= i %>
                        </a>
                    <% } %>
                    </div>
                    <a href="?page=<%= currentPage < totalPages ? currentPage + 1 : totalPages %><%= queryStr %>" 
                       class="px-3 py-1 border border-outline-variant rounded text-on-surface-variant font-label-md text-label-md hover:bg-surface-container-low <%= currentPage == totalPages || totalPages == 0 ? "pointer-events-none opacity-50" : "" %>">
                       Next
                    </a>
                </div>
            </div>
            
        </main>
    </div>

    <!-- Modals -->
    <!-- Add Modal -->
    <div id="addModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-md p-6">
            <div class="flex items-center justify-between mb-6">
                <h3 class="font-headline-md text-headline-md font-bold text-on-surface">Add Category</h3>
                <button type="button" onclick="closeAddModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/category" method="post" class="flex flex-col gap-4">
                <input type="hidden" name="action" value="add"/>
                <% if(request.getParameter("searchInput") != null) { %>
                    <input type="hidden" name="searchInput" value="${param.searchInput}">
                <% } %>
                
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Category Name</label>
                    <input type="text" name="categoryName" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required placeholder="Enter category name"/>
                </div>
                
                <div class="mt-6 flex justify-end gap-3">
                    <button type="button" onclick="closeAddModal()" class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg">Cancel</button>
                    <button type="submit" class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20">Add</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center">
        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-2xl w-full max-w-md p-6">
            <div class="flex items-center justify-between mb-6">
                <h3 class="font-headline-md text-headline-md font-bold text-on-surface">Edit Category</h3>
                <button type="button" onclick="closeEditModal()" class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/category" method="post" class="flex flex-col gap-4">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="categoryId" id="editCategoryId" value=""/>
                <% if(request.getParameter("searchInput") != null) { %>
                    <input type="hidden" name="searchInput" value="${param.searchInput}">
                <% } %>
                
                <div>
                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1">Category Name</label>
                    <input type="text" name="categoryName" id="editCategoryName" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" required/>
                </div>
                
                <div class="mt-6 flex justify-end gap-3">
                    <button type="button" onclick="closeEditModal()" class="px-6 py-2 border border-outline-variant text-on-surface font-bold hover:bg-surface-container-high transition-all rounded-lg">Cancel</button>
                    <button type="submit" class="px-6 py-2 bg-primary text-white font-bold hover:bg-primary/90 transition-all rounded-lg shadow-lg shadow-primary/20">Save</button>
                </div>
            </form>
        </div>
    </div>

    <script>
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
    </script>
</body>
</html>

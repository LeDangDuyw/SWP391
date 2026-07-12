<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Admin - Inbound Ticket Details #${ticket.ticketId}</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "primary": "#003ec7",
                        "error": "#ba1a1a",
                        "surface-container-low": "#f2f4f6",
                        "surface-container-lowest": "#ffffff",
                        "on-surface": "#191c1e",
                        "on-surface-variant": "#434656",
                        "outline-variant": "#c3c5d9",
                        "surface": "#f7f9fb",
                        "primary-fixed": "#dde1ff",
                        "on-primary-fixed": "#001452",
                        "error-container": "#ffdad6",
                        "on-error-container": "#93000a"
                    },
                    "fontFamily": {
                        "body-lg": ["Inter"],
                        "headline-lg": ["Space Grotesk"],
                        "headline-xl": ["Space Grotesk"],
                        "body-sm": ["Inter"],
                        "label-md": ["Inter"],
                        "body-md": ["Inter"],
                        "headline-md": ["Space Grotesk"]
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

<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
            <a href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
            <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
            <a class="active" href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
            <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
            <a href="${pageContext.request.contextPath}/admin/chatbot-feedback"><span>💬</span>Chatbot Feedback</a>
            <a href="${pageContext.request.contextPath}/admin/chatbot-security"><span>🛡</span>Chatbot Security</a>
            <a href="#"><span>⚙</span>Settings</a>
        </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <%
                    model.Users u = (model.Users) session.getAttribute("user");
                    if (u != null && u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty()) {
                %>
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarUrl() %>" 
                         alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                <% } else { %>
                    <span>♙</span>
                <% } %>
                <span>Admin User Profile</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

    <div class="main">

        <!-- Top Header -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-6 h-16">
            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/admin/ticket/list" class="flex items-center gap-2 text-on-surface-variant hover:text-primary transition-colors font-label-md">
                    <span class="material-symbols-outlined">arrow_back</span>
                    Back to List
                </a>
            </div>
            <div class="flex items-center gap-4">
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <div class="h-8 w-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-label-md ml-2 border border-primary/20">
                    <span class="material-symbols-outlined">person</span>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 p-6 bg-surface-container-lowest">
            
            <div class="max-w-5xl mx-auto">
                <!-- Page Header -->
                <div class="flex justify-between items-start mb-6">
                    <div>
                        <h2 class="font-headline-lg text-3xl text-on-surface mb-2">Ticket Details #${ticket.ticketId}</h2>
                        <p class="font-body-md text-on-surface-variant">${ticket.title}</p>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${ticket.status == 'COMPLETED'}">
                                <span class="inline-flex items-center px-3 py-1.5 rounded-lg bg-[#E6F4EA] text-[#137333] font-bold gap-2">
                                    <span class="material-symbols-outlined">check_circle</span>
                                    ${ticket.status}
                                </span>
                            </c:when>
                            <c:when test="${ticket.status == 'CANCELLED' || ticket.status == 'REJECTED'}">
                                <span class="inline-flex items-center px-3 py-1.5 rounded-lg bg-error-container text-on-error-container font-bold gap-2">
                                    <span class="material-symbols-outlined">cancel</span>
                                    ${ticket.status}
                                </span>
                            </c:when>
                            <c:when test="${ticket.status == 'WAITING_FOR_ADMIN_REVIEW'}">
                                <span class="inline-flex items-center px-3 py-1.5 rounded-lg bg-[#FEF7E0] text-[#B06000] font-bold gap-2 animate-pulse">
                                    <span class="material-symbols-outlined">pending</span>
                                    ${ticket.status}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="inline-flex items-center px-3 py-1.5 rounded-lg bg-primary-fixed text-on-primary-fixed font-bold gap-2">
                                    <span class="material-symbols-outlined">info</span>
                                    ${ticket.status}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Info Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- General Info -->
                    <div class="bg-surface border border-outline-variant/50 rounded-xl p-6">
                        <h3 class="font-headline-md text-lg text-on-surface mb-4 flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">info</span>
                            General Information
                        </h3>
                        <div class="space-y-4 font-body-md">
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Ticket ID</span>
                                <span class="font-bold">#${ticket.ticketId}</span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Title</span>
                                <span class="font-bold">${ticket.title}</span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Created At</span>
                                <span class="font-medium">${ticket.createdAt}</span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Last Updated</span>
                                <span class="font-medium">${ticket.updatedAt != null ? ticket.updatedAt : '-'}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Processing Info -->
                    <div class="bg-surface border border-outline-variant/50 rounded-xl p-6">
                        <h3 class="font-headline-md text-lg text-on-surface mb-4 flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">admin_panel_settings</span>
                            Processing Information
                        </h3>
                        <div class="space-y-4 font-body-md">
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Creator (ID)</span>
                                <span class="font-bold">Staff ID: ${ticket.createdBy}</span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-on-surface-variant text-sm mb-1">Reason / Notes</span>
                                <div class="bg-surface-container-low p-3 rounded-lg border border-outline-variant/30 min-h-[60px]">
                                    <c:choose>
                                        <c:when test="${not empty ticket.reason}">
                                            <span class="italic text-on-surface">${ticket.reason}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-on-surface-variant italic">No notes available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Actions if Waiting -->
                            <c:if test="${ticket.status == 'WAITING_FOR_ADMIN_REVIEW'}">
                                <div class="mt-4 pt-4 border-t border-outline-variant/30">
                                    <form action="${pageContext.request.contextPath}/admin/ticket/review" method="post" class="flex flex-col gap-3">
                                        <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                        <div class="flex flex-col gap-1">
                                            <label class="text-sm font-bold text-on-surface">Response (Reason for Approval/Rejection):</label>
                                            <textarea name="reason" rows="2" placeholder="Enter reason..." 
                                                      class="w-full px-3 py-2 border border-outline-variant rounded-lg focus:ring-1 focus:ring-primary focus:border-primary"></textarea>
                                        </div>
                                        <div class="flex justify-end gap-3 mt-2">
                                            <button type="submit" name="action" value="reject" 
                                                    class="flex items-center gap-2 px-4 py-2 bg-error text-white font-bold rounded-lg hover:bg-error/90 transition-colors">
                                                <span class="material-symbols-outlined">close</span>
                                                Reject
                                            </button>
                                            <button type="submit" name="action" value="approve" 
                                                    class="flex items-center gap-2 px-4 py-2 bg-[#137333] text-white font-bold rounded-lg hover:bg-[#0d5c28] transition-colors">
                                                <span class="material-symbols-outlined">check</span>
                                                Approve
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="bg-surface border border-outline-variant/50 rounded-xl overflow-hidden mb-8">
                    <div class="px-6 py-4 border-b border-outline-variant/30 flex justify-between items-center bg-surface-container-low">
                        <h3 class="font-headline-md text-lg text-on-surface flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">inventory_2</span>
                            Inbound Product List
                        </h3>
                        <span class="px-3 py-1 bg-primary/10 text-primary font-bold rounded-full text-sm">
                            ${ticket.details.size()} products
                        </span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-surface text-on-surface-variant font-label-md text-sm border-b border-outline-variant/30">
                                    <th class="py-3 px-6 w-16">#</th>
                                    <th class="py-3 px-6">Product (Variant)</th>
                                    <th class="py-3 px-6 w-32">SKU</th>
                                    <th class="py-3 px-6 w-32 text-right">Quantity</th>
                                    <th class="py-3 px-6 w-48 text-right">Expected Import Price</th>
                                    <th class="py-3 px-6 w-48 text-right">Total Amount</th>
                                </tr>
                            </thead>
                            <tbody class="font-body-md">
                                <c:set var="totalAmount" value="0"/>
                                <c:forEach var="detail" items="${ticket.details}" varStatus="status">
                                    <c:set var="itemTotal" value="${detail.quantity * detail.expectedPrice}"/>
                                    <c:set var="totalAmount" value="${totalAmount + itemTotal}"/>
                                    <tr class="border-b border-outline-variant/20 hover:bg-surface-container-lowest/50 transition-colors">
                                        <td class="py-4 px-6 text-on-surface-variant">${status.index + 1}</td>
                                        <td class="py-4 px-6 font-medium text-on-surface">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-lg bg-surface-container-low border border-outline-variant/30 flex items-center justify-center">
                                                    <span class="material-symbols-outlined text-outline-variant">laptop_mac</span>
                                                </div>
                                                ${detail.variantName != null ? detail.variantName : 'Unknown Variant'}
                                            </div>
                                        </td>
                                        <td class="py-4 px-6 font-code-sm text-sm text-on-surface-variant">${detail.sku}</td>
                                        <td class="py-4 px-6 text-right font-bold">${detail.quantity}</td>
                                        <td class="py-4 px-6 text-right">
                                            <fmt:formatNumber value="${detail.expectedPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="py-4 px-6 text-right font-bold text-primary">
                                            <fmt:formatNumber value="${itemTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty ticket.details}">
                                    <tr>
                                        <td colspan="6" class="py-8 text-center text-on-surface-variant">
                                            No product details available.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                            <c:if test="${not empty ticket.details}">
                                <tfoot class="bg-surface-container-low font-bold">
                                    <tr>
                                        <td colspan="5" class="py-4 px-6 text-right text-on-surface">Total:</td>
                                        <td class="py-4 px-6 text-right text-primary text-lg">
                                            <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </tfoot>
                            </c:if>
                        </table>
                    </div>
                </div>
                
            </div>
        </main>
    </div>
</div>
</body>
</html>

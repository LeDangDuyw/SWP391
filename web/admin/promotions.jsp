<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNILAP Admin - Promotions</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">

<style>
            /* Sidebar dropdown style */
            .sidebar-dropdown {
                display: flex;
                flex-direction: column;
            }
            .sidebar-dropdown-container {
                display: none;
                flex-direction: column;
                gap: 4px;
                margin-top: 4px;
            }
            .sidebar nav .sidebar-dropdown-container a {
                padding: 8px 14px 8px 30px !important;
                font-size: 13px !important;
                font-weight: 500 !important;
            }
</style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
                    
                    <div class="sidebar-dropdown">
                        <a href="javascript:void(0)" class="sidebar-dropdown-btn active" onclick="toggleSidebarDropdown(this)" style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                            <span style="display: flex; align-items: center; gap: 14px;"><span>📊</span>Analytics</span>
                            <span class="dropdown-arrow" style="font-size: 10px; transition: transform 0.2s; transform: rotate(180deg);">▼</span>
                        </a>
                        <div class="sidebar-dropdown-container" style="display: flex; flex-direction: column; gap: 4px; margin-top: 4px;">
                            <a class="active" href="${pageContext.request.contextPath}/admin/promotions">
                                <span>▥</span>Voucher & Promotion
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/analytics">
                                <span>📈</span>Advanced Analytics
                            </a>
                        </div>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
                    <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
                    <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
                    <div style="border-top: 1px solid #334155; margin: 10px 0;"></div>
                    <a href="${pageContext.request.contextPath}/admin/chatbot-feedback"><span>💬</span>Chatbot Feedback</a>
                    <a href="${pageContext.request.contextPath}/admin/chatbot-security"><span>🛡</span>Chatbot Security</a>
                    <a href="#"><span>⚙</span>Settings</a>
                </nav>
        <div class="profile">
            <div style="cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                <c:choose>
                    <c:when test="${not empty sessionScope.user && not empty sessionScope.user.avatarUrl}">
                        <img src="${pageContext.request.contextPath}/images/${sessionScope.user.avatarUrl}" 
                             alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 1px solid #cbd5e1;">
                    </c:when>
                    <c:otherwise>
                        <span>♙</span>
                    </c:otherwise>
                </c:choose>
                <span>Admin User Profile</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>Console</h1>
            <form action="${pageContext.request.contextPath}/admin/promotions" method="get" class="top-search">
                <input name="keyword" value="<c:out value="${keyword}"/>" placeholder="Search promotions...">
            </form>
            <div class="top-icons">⌕ &nbsp; ◴</div>
        </header>

        <section class="page-head">
            <div>
                <h2>Vouchers &amp; Promotions</h2>
                <p>Manage active campaigns, discount codes, and seasonal promotions.</p>
            </div>
            <div class="head-actions">
                <c:url var="exportUrl" value="/admin/promotions">
                    <c:param name="action" value="export" />
                    <c:param name="keyword" value="${keyword}" />
                </c:url>
                <a class="btn ghost" href="${exportUrl}">Export Report</a>
                <a class="btn primary" href="${pageContext.request.contextPath}/admin/campaign-form">＋ Create Campaign</a>
            </div>
        </section>

        <c:if test="${not empty msg}">
            <div class="alert success"><c:out value="${msg}"/></div>
        </c:if>

        <section class="stats-grid">
            <article class="stat-card">
                <h3>Active Campaigns</h3>
                <strong class="blue">${stats.activeCampaigns}</strong>
                <p><span class="up">↗</span> running now</p>
            </article>
            <article class="stat-card">
                <h3>Total Redemptions (MTD)</h3>
                <strong><fmt:formatNumber value="${stats.totalRedemptions}" type="number"/></strong>
                <p><span class="up blue-text">↗</span> voucher usage</p>
            </article>
            <article class="stat-card">
                <h3>Pending Approvals</h3>
                <strong class="red">${stats.pendingApprovals}</strong>
                <p>Requires Admin Review</p>
            </article>
        </section>

        <section class="panel">
            <div class="panel-title">
                <h2>Active &amp; Scheduled Campaigns</h2>
                <div class="panel-icons">≡ &nbsp; ⋮</div>
            </div>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Campaign Name</th>
                    <th>Code / Type</th>
                    <th>Status</th>
                    <th>Redemptions</th>
                    <th>Valid Until</th>
                    <th class="right">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty campaigns}">
                    <tr><td colspan="6" class="empty">Không có campaign nào. Bấm Create Campaign để tạo mới.</td></tr>
                </c:if>
                <c:forEach var="c" items="${campaigns}">
                    <tr>
                        <td>
                            <b><c:out value="${c.campaignName}"/></b>
                            <small><c:out value="${c.campaignDescription}"/></small>
                        </td>
                        <td>
                            <code><c:out value="${c.promoCode}"/></code>
                            <small>
                                <c:out value="${c.campaignType}"/>
                                <c:if test="${not empty c.discountValue}">
                                    <br>Val: <b>
                                        <c:choose>
                                            <c:when test="${c.campaignType == 'percentage' || c.campaignType == 'flash' || c.campaignType == 'bundle_discount'}">
                                                <c:choose>
                                                    <c:when test="${c.discountValue == 0}">0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${c.discountValue}" pattern="#.##"/>%
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${c.discountValue}" pattern="#,##0"/>₫
                                            </c:otherwise>
                                        </c:choose>
                                    </b>
                                </c:if>
                                <c:if test="${not empty c.minOrderValue && c.minOrderValue > 0}">
                                    <br>Min: <fmt:formatNumber value="${c.minOrderValue}" pattern="#,##0"/>₫
                                </c:if>
                            </small>
                        </td>
                        <td><span class="badge ${c.statusClass}"><c:out value="${c.formattedStatus}"/></span></td>
                        <td><fmt:formatNumber value="${c.usedCount}" type="number"/> / <c:choose><c:when test="${empty c.usageLimit}">∞</c:when><c:otherwise><fmt:formatNumber value="${c.usageLimit}" type="number"/></c:otherwise></c:choose></td>
                        <td><c:out value="${c.formattedEndDateDateOnly}"/></td>
                        <td class="actions right">
                            <a href="${pageContext.request.contextPath}/admin/campaign-detail?id=${c.campaignId}">◎ Show</a>
                            <c:choose>
                                <c:when test="${c.status == 'active'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/promotions">
                                        <input type="hidden" name="id" value="${c.campaignId}">
                                        <input type="hidden" name="action" value="stop">
                                        <button class="link danger" onclick="return confirm('Stop campaign này?')">Stop</button>
                                    </form>
                                </c:when>
                                <c:when test="${c.status == 'scheduled' || c.status == 'paused'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/promotions">
                                        <input type="hidden" name="id" value="${c.campaignId}">
                                        <input type="hidden" name="action" value="resume">
                                        <button class="link">Resume</button>
                                    </form>
                                </c:when>
                                <c:when test="${c.status == 'pending_approval'}">
                                    <a href="${pageContext.request.contextPath}/admin/campaign-detail?id=${c.campaignId}&review=true">Review</a>
                                </c:when>
                            </c:choose>
                            <c:if test="${c.status != 'pending_approval'}">
                                <a href="${pageContext.request.contextPath}/admin/campaign-form?id=${c.campaignId}">Edit</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="table-footer">
                <span>Showing ${empty campaigns ? 0 : (page - 1) * pageSize + 1}-${page * pageSize < total ? page * pageSize : total} of ${total} campaigns</span>
                <div class="pager">
                    <c:url var="prevUrl" value="/admin/promotions">
                        <c:param name="page" value="${page > 1 ? page - 1 : 1}" />
                        <c:param name="keyword" value="${keyword}" />
                    </c:url>
                    <a class="page-btn ${page <= 1 ? 'disabled' : ''}" href="${prevUrl}">‹</a>
                    <span>${page}/${totalPages}</span>
                    <c:url var="nextUrl" value="/admin/promotions">
                        <c:param name="page" value="${page < totalPages ? page + 1 : totalPages}" />
                        <c:param name="keyword" value="${keyword}" />
                    </c:url>
                    <a class="page-btn ${page >= totalPages ? 'disabled' : ''}" href="${nextUrl}">›</a>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
            function toggleSidebarDropdown(btn) {
                const container = btn.nextElementSibling;
                const arrow = btn.querySelector('.dropdown-arrow');
                if (container.style.display === 'flex') {
                    container.style.display = 'none';
                    arrow.style.transform = 'rotate(0deg)';
                } else {
                    container.style.display = 'flex';
                    arrow.style.transform = 'rotate(180deg)';
                }
            }
</script>
</body>
</html>

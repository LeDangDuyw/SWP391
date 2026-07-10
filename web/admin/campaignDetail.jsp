<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Campaign Performance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/promotion.css" />
    <style>
        .sidebar-dropdown { display: flex; flex-direction: column; }
        .sidebar-dropdown-container { display: none; flex-direction: column; gap: 4px; margin-top: 4px; }
        .sidebar nav .sidebar-dropdown-container a { padding: 8px 14px 8px 30px !important; font-size: 13px !important; font-weight: 500 !important; }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css" />
</head>
<body>
<div class="layout detail-layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a href="${pageContext.request.contextPath}/admin/users"><span>♚</span>Users</a>
            
            <div class="sidebar-dropdown">
                <a href="javascript:void(0)" class="sidebar-dropdown-btn active" onclick="toggleSidebarDropdown(this)" style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
                    <span style="display: flex; align-items: center; gap: 14px;"><span>📊</span>Analytics</span>
                    <span class="dropdown-arrow" style="font-size: 10px; transition: transform 0.2s; transform: rotate(180deg);">▼</span>
                </a>
                <div class="sidebar-dropdown-container" style="display: flex; flex-direction: column; gap: 4px; margin-top: 4px;">
                    <a href="${pageContext.request.contextPath}/admin/promotions" class="active">
                        <span>▥</span>Voucher & Promotion
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/analytics">
                        <span>📈</span>Advanced Analytics
                    </a>
                </div>
            </div>
            
            <a href="<%=request.getContextPath()%>/admin/policy"><span>📜</span>Policies</a>
            <a href="<%=request.getContextPath()%>/admin/reviews"><span>★</span>Manage Reviews</a>
            <a class="active" href="${pageContext.request.contextPath}/admin/promotions"><span>▥</span>Analytics</a>
            <a href="${pageContext.request.contextPath}/admin/policy"><span>📜</span>Policies</a>
            <a href="${pageContext.request.contextPath}/admin/reviews"><span>★</span>Manage Reviews</a>
            <a href="${pageContext.request.contextPath}/warranty?action=list"><span>🛠</span>Warranty</a>
            <a href="${pageContext.request.contextPath}/admin/ticket/list"><span>🎫</span>Ticket Review</a>
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

                <main class="main performance-page">
                    <header class="topbar slim">
                        <form action="${pageContext.request.contextPath}/admin/promotions" method="get" class="top-search wide">
                            <input name="keyword" placeholder="Search campaign data...">
                        </form>
                        <div class="top-icons">⚑ &nbsp; ? &nbsp; <b>Console</b></div>
                    </header>

                    <section class="page-head">
                        <div>
                            <div class="date-range">▣ ${campaign.formattedStartDateDateOnly} - ${campaign.formattedEndDateDateOnly}</div>
                            <h2>Campaign Performance: <c:out value="${campaign.campaignName}"/></h2>
                            <p><c:out value="${campaign.campaignDescription}"/></p>
                        </div>
                        <div class="head-actions">
                            <a class="btn ghost" target="_blank" href="${pageContext.request.contextPath}/admin/campaign-detail?action=exportPdf&id=${campaign.campaignId}">⇩ Export PDF</a>
                            <a class="btn primary" href="${pageContext.request.contextPath}/admin/campaign-detail?id=${campaign.campaignId}">⟳ Live Sync</a>
                            <a class="btn ghost" href="${pageContext.request.contextPath}/admin/campaign-form?id=${campaign.campaignId}">Edit</a>
                        </div>
                    </section>

                    <c:if test="${campaign.status == 'pending_approval'}">
                    <div class="review-bar">
                        <b>Campaign đang chờ duyệt.</b>
                        <form method="post" action="${pageContext.request.contextPath}/admin/campaign-detail">
                            <input type="hidden" name="id" value="${campaign.campaignId}">
                            <button class="btn primary" name="action" value="approve">Approve</button>
                            <button class="btn danger-fill" name="action" value="reject">Reject</button>
                        </form>
                    </div>
                    </c:if>

                    <div class="campaign-summary-bar" style="background: white; border: 1px solid var(--line); border-radius: 7px; padding: 18px; margin-bottom: 24px; display: flex; gap: 40px; box-shadow: var(--shadow); flex-wrap: wrap;">
                        <div>
                            <small style="color: var(--muted); display: block; margin-bottom: 4px; text-transform: uppercase; font-size: 11px; font-weight: 700;">Promo Code</small>
                            <code style="font-size: 16px; font-weight: 700; color: var(--blue);"><c:out value="${campaign.promoCode}"/></code>
                        </div>
                        <div>
                            <small style="color: var(--muted); display: block; margin-bottom: 4px; text-transform: uppercase; font-size: 11px; font-weight: 700;">Campaign Type</small>
                            <span style="font-weight: 600;"><c:out value="${campaign.campaignType}"/></span>
                        </div>
                        <div>
                            <small style="color: var(--muted); display: block; margin-bottom: 4px; text-transform: uppercase; font-size: 11px; font-weight: 700;">Discount Value</small>
                            <span style="font-weight: 700; color: #111827;">
                                <c:choose>
                                    <c:when test="${campaign.campaignType == 'percentage' || campaign.campaignType == 'flash' || campaign.campaignType == 'bundle_discount'}">
                                        <c:choose>
                                            <c:when test="${campaign.discountValue == 0}">0%</c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${campaign.discountValue}" pattern="#.##"/>%
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${campaign.discountValue}" pattern="#,##0"/>₫
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div>
                            <small style="color: var(--muted); display: block; margin-bottom: 4px; text-transform: uppercase; font-size: 11px; font-weight: 700;">Min Order (Condition)</small>
                            <span style="font-weight: 600;"><fmt:formatNumber value="${campaign.minOrderValue}" pattern="#,##0"/>₫</span>
                        </div>
                        <div>
                            <small style="color: var(--muted); display: block; margin-bottom: 4px; text-transform: uppercase; font-size: 11px; font-weight: 700;">Status</small>
                            <span class="badge ${campaign.statusClass}" style="padding: 2px 8px; font-size: 12px;"><c:out value="${campaign.formattedStatus}"/></span>
                        </div>
                    </div>

                    <section class="metric-grid four">
                        <article class="metric-card"><span class="icon">▭</span><small>TOTAL UNITS SOLD</small><b><fmt:formatNumber value="${totalUnits}" type="number"/></b><div class="bar"><i style="width:${totalUnitsProgress}%"></i></div></article>
                        <article class="metric-card"><span class="icon">▣</span><small>TOTAL REVENUE</small><b>${revenueShort}</b><div class="bar"><i style="width:${revenueProgress}%"></i></div></article>
                        <article class="metric-card"><span class="icon">◉</span><small>CONVERSION RATE</small><b><fmt:formatNumber value="${conversion}" maxFractionDigits="1"/>%</b><div class="bar"><i style="width:${conversionProgress}%"></i></div></article>
                        <article class="metric-card"><span class="icon">♙</span><small>CUSTOMER GROWTH</small><b>${customerGrowth > 0 ? '+' : ''}<fmt:formatNumber value="${customerGrowth}" type="number"/></b><div class="bar"><i style="width:${customerGrowthProgress}%"></i></div></article>
                    </section>

                    <div class="analytics-grid">
                        <section class="chart-card">
                            <div class="inline-title"><div><b>Sales Volume Over Time</b><small>Units sold by assignment date from real order serial data.</small></div><span class="pill"><c:out value="${salesRangeLabel}"/></span></div>
                            <c:choose>
                                <c:when test="${empty salesVolume}">
                                    <div class="chart-empty">No sales volume data for this campaign.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bar-chart">
                                        <c:forEach var="point" items="${salesVolume}">
                                            <span style="height:${point.heightPercent}%"
                                                  title="<c:out value="${point.saleDate}"/>: ${point.unitsSold} units"></span>
                                        </c:forEach>
                                    </div>
                                    <div class="axis">
                                        <c:forEach var="label" items="${salesAxisLabels}">
                                            <span><c:out value="${label}"/></span>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </section>
                    </div>

                    <section class="panel performance-table">
                        <div class="panel-title">
                            <h2>Product Performance Breakdown</h2>
                            <input id="tableFilter" class="mini-search" placeholder="Filter product...">
                        </div>
                        <table class="data-table" id="productTable">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>Original Price</th>
                                    <th>Sale Price</th>
                                    <th>Units Sold</th>
                                    <th>Revenue</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty products}">
                                    <tr><td colspan="6" class="empty">Campaign này chưa chọn sản phẩm nào.</td></tr>
                                </c:if>
                                <c:forEach var="p" items="${products}">
                                    <tr data-row="<c:out value="${p.productName.toLowerCase()} ${p.sku.toLowerCase()}"/>">
                                        <td><b><c:out value="${p.productName}"/></b><small><c:out value="${p.sku}"/> · <c:out value="${p.categoryName}"/></small></td>
                                        <td><fmt:formatNumber value="${p.originalPrice}" pattern="#,##0"/>₫</td>
                                        <td class="blue-text strong"><fmt:formatNumber value="${p.salePrice}" pattern="#,##0"/>₫</td>
                                        <td><fmt:formatNumber value="${p.unitsSold}" type="number"/></td>
                                        <td class="strong"><fmt:formatNumber value="${p.revenue}" pattern="#,##0"/>₫</td>
                                        <td><span class="stock ${p.status.toLowerCase().replace(' ', '-')}"><c:out value="${p.status}"/></span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="table-footer"><span>Showing ${products.size()} promotion items</span><a class="btn ghost" href="${pageContext.request.contextPath}/admin/promotions">Back to Campaigns</a></div>
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

                const input = document.getElementById('tableFilter');
                input?.addEventListener('input', () => {
                    const key = input.value.toLowerCase();
                    document.querySelectorAll('#productTable tbody tr[data-row]').forEach(row => {
                        row.style.display = row.dataset.row.includes(key) ? '' : 'none';
                    });
                });
            </script>
        </body>
    </html>

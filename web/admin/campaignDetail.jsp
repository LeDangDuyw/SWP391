<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Campaign Performance</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css" />
</head>
<body>
<div class="layout detail-layout">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="activePage" value="promotions"/>
    </jsp:include>

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
                                    <c:when test="${campaign.campaignType == 'percentage' || campaign.campaignType == 'flash'}">
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
                        <article class="metric-card">
                            <span class="icon">📈</span>
                            <small>INCREMENTAL SALES (DOANH THU GIA TĂNG)</small>
                            <b title="<fmt:formatNumber value="${incrementalSales}" pattern="#,##0"/>₫">${incrementalSalesShort}</b>
                            <div class="bar"><i style="width: 100%; background: #059669;"></i></div>
                        </article>
                        <article class="metric-card">
                            <span class="icon">💳</span>
                            <small>AVERAGE ORDER VALUE (AOV)</small>
                            <b title="<fmt:formatNumber value="${aov}" pattern="#,##0"/>₫">${aovShort}</b>
                            <div class="bar"><i style="width: 100%; background: #2563eb;"></i></div>
                        </article>
                        <article class="metric-card">
                            <span class="icon">🎯</span>
                            <small>ROAS (HIỆU QUẢ GIẢM GIÁ)</small>
                            <b style="color: #7c3aed;">${roasRatio}</b>
                            <div class="bar"><i style="width: 100%; background: #7c3aed;"></i></div>
                        </article>
                        <article class="metric-card">
                            <span class="icon">🎟</span>
                            <small>REDEMPTIONS (LƯỢT DÙNG VOUCHER)</small>
                            <b><fmt:formatNumber value="${campaign.usedCount}" type="number"/> <span style="font-size: 14px; font-weight: normal; color: #6b7280;">/ ${empty campaign.usageLimit ? '∞' : campaign.usageLimit}</span></b>
                            <div class="bar"><i style="width:${redemptionsProgress}%"></i></div>
                        </article>
                    </section>

                    <div class="analytics-grid">
                        <section class="chart-card" style="position: relative; padding: 24px; background: #fff; border-radius: 12px; border: 1px solid #e5e7eb;">
                            <div class="inline-title" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                <div>
                                    <b style="font-size: 16px; font-weight: 700; color: #111827;">Sales Volume Over Time</b>
                                    <small style="display: block; color: #6b7280; margin-top: 2px;">Units sold by assignment date from real order serial data.</small>
                                </div>
                                <span class="pill" style="background: #f3f4f6; color: #4b5563; padding: 4px 12px; border-radius: 16px; font-size: 12px; font-weight: 600;"><c:out value="${salesRangeLabel}"/></span>
                            </div>
                            <c:choose>
                                <c:when test="${empty salesVolume}">
                                    <div class="chart-empty" style="text-align: center; color: #9ca3af; padding: 40px;">No sales volume data for this campaign.</div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; height: 260px; gap: 16px;">
                                        <!-- Y-AXIS (Left side: 0, 5, 10, 20...) -->
                                        <div style="display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; width: 36px; padding-bottom: 24px; font-size: 12px; font-weight: 600; color: #6b7280; font-family: Inter, sans-serif;">
                                            <c:forEach var="tick" items="${yAxisTicks}">
                                                <span>${tick}</span>
                                            </c:forEach>
                                        </div>
                                        
                                        <!-- CHART BARS + GRID -->
                                        <div style="flex: 1; display: flex; flex-direction: column; position: relative;">
                                            <div style="flex: 1; display: flex; align-items: flex-end; gap: 4px; border-bottom: 2px solid #e5e7eb; border-left: 2px solid #e5e7eb; padding-left: 8px; padding-right: 8px; position: relative; background: linear-gradient(to bottom, rgba(243,244,246,0.2) 0%, transparent 100%);">
                                                <c:forEach var="point" items="${salesVolume}">
                                                    <c:set var="calcH" value="${salesMaxUnits > 0 ? (point.unitsSold * 100.0 / salesMaxUnits) : 0}"/>
                                                    <div style="flex: 1; height: 100%; display: flex; align-items: flex-end; justify-content: center; position: relative;" class="bar-col">
                                                        <span style="width: 80%; max-width: 28px; height: ${calcH}%; min-height: ${point.unitsSold > 0 ? '4px' : '0px'}; background: #3b82f6; border-radius: 4px 4px 0 0; transition: height 0.3s ease, background 0.2s;"
                                                              title="<c:out value="${point.saleDate}"/>: ${point.unitsSold} units"></span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            
                                            <!-- X-AXIS (Bottom side: Date, month, year) -->
                                            <div style="display: flex; justify-content: space-between; padding-top: 8px; padding-left: 8px; padding-right: 8px; font-size: 12px; font-weight: 600; color: #6b7280; font-family: Inter, sans-serif;">
                                                <c:forEach var="label" items="${salesAxisLabels}">
                                                    <span><c:out value="${label}"/></span>
                                                </c:forEach>
                                            </div>
                                        </div>
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.*, java.math.*, model.Campaign, model.CampaignProduct, model.CampaignSalesVolume" %>
<%!
    String h(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;"); }
    String money(Number n) { return NumberFormat.getCurrencyInstance(new Locale("vi", "VN")).format(n == null ? 0 : n); }
    String shortMoney(BigDecimal n) {
        if (n == null) return "0";
        BigDecimal million = new BigDecimal("1000000");
        if (n.compareTo(million) >= 0) return n.divide(million, 1, RoundingMode.HALF_UP) + "M";
        return money(n);
    }
    String date(Object d) { return d == null ? "-" : d.toString().replace('T', ' ').substring(0, Math.min(10, d.toString().length())); }
    String statusClass(String s) { return s == null ? "" : s.toLowerCase().replace(' ', '-'); }
%>
<%
    String listBase = request.getContextPath() + "/admin/promotions";
    String formBase = request.getContextPath() + "/admin/campaign-form";
    String detailBase = request.getContextPath() + "/admin/campaign-detail";
    Campaign c = (Campaign) request.getAttribute("campaign");
    List<CampaignProduct> products = (List<CampaignProduct>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    int totalUnits = request.getAttribute("totalUnits") == null ? 0 : (Integer) request.getAttribute("totalUnits");
    BigDecimal revenue = request.getAttribute("revenue") == null ? BigDecimal.ZERO : (BigDecimal) request.getAttribute("revenue");
    double conversion = request.getAttribute("conversion") == null ? 0 : (Double) request.getAttribute("conversion");
    int customerGrowth = request.getAttribute("customerGrowth") == null ? 0 : (Integer) request.getAttribute("customerGrowth");
    int totalUnitsProgress = request.getAttribute("totalUnitsProgress") == null ? 0 : (Integer) request.getAttribute("totalUnitsProgress");
    int revenueProgress = request.getAttribute("revenueProgress") == null ? 0 : (Integer) request.getAttribute("revenueProgress");
    int conversionProgress = request.getAttribute("conversionProgress") == null ? 0 : (Integer) request.getAttribute("conversionProgress");
    int customerGrowthProgress = request.getAttribute("customerGrowthProgress") == null ? 0 : (Integer) request.getAttribute("customerGrowthProgress");
    List<CampaignSalesVolume> salesVolume = (List<CampaignSalesVolume>) request.getAttribute("salesVolume");
    if (salesVolume == null) salesVolume = new ArrayList<>();
    List<String> salesAxisLabels = (List<String>) request.getAttribute("salesAxisLabels");
    if (salesAxisLabels == null) salesAxisLabels = new ArrayList<>();
    String salesRangeLabel = request.getAttribute("salesRangeLabel") == null ? "Last 30 Sale Days" : (String) request.getAttribute("salesRangeLabel");
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaign Performance</title>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Campaign Performance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/promotion.css" />
</head>
<body>
<div class="layout detail-layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="AdminDashboard.jsp"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a href="#"><span>♚</span>Users</a>
            <a class="active" href="<%=listBase%>"><span>▥</span>Analytics</a>
            <a href="<%=request.getContextPath()%>/admin/policy"><span>📜</span>Policies</a>
            <a href="#"><span>⚙</span>Settings</a>
        </nav>
        <div class="profile">
            <div>♙ <span>Admin User Profile</span></div>
            <a href="<%=request.getContextPath()%>/logout" class="logout-btn">Logout</a>
        </div>
    </aside>

    <main class="main performance-page">
        <header class="topbar slim">
            <form action="<%=listBase%>" method="get" class="top-search wide">
                <input name="keyword" placeholder="Search campaign data...">
            </form>
            <div class="top-icons">⚑ &nbsp; ? &nbsp; <b>Console</b></div>
        </header>

        <section class="page-head">
            <div>
                <div class="date-range">▣ <%=date(c.getStartDate())%> - <%=date(c.getEndDate())%></div>
                <h2>Campaign Performance: <%=h(c.getCampaignName())%></h2>
                <p><%=h(c.getCampaignDescription())%></p>
            </div>
            <div class="head-actions">
                <a class="btn ghost" target="_blank" href="<%=detailBase%>?action=exportPdf&id=<%=c.getCampaignId()%>">⇩ Export PDF</a>
                <a class="btn primary" href="<%=detailBase%>?id=<%=c.getCampaignId()%>">⟳ Live Sync</a>
                <a class="btn ghost" href="<%=formBase%>?id=<%=c.getCampaignId()%>">Edit</a>
            </div>
        </section>

        <% if ("pending_approval".equals(c.getStatus())) { %>
        <div class="review-bar">
            <b>Campaign đang chờ duyệt.</b>
            <form method="post" action="<%=detailBase%>">
                <input type="hidden" name="id" value="<%=c.getCampaignId()%>">
                <button class="btn primary" name="action" value="approve">Approve</button>
                <button class="btn danger-fill" name="action" value="reject">Reject</button>
            </form>
        </div>
        <% } %>

        <section class="metric-grid four">
            <article class="metric-card"><span class="icon">▭</span><small>TOTAL UNITS SOLD</small><b><%=NumberFormat.getNumberInstance(Locale.US).format(totalUnits)%></b><div class="bar"><i style="width:<%=totalUnitsProgress%>%"></i></div></article>
            <article class="metric-card"><span class="icon">▣</span><small>TOTAL REVENUE</small><b><%=shortMoney(revenue)%></b><div class="bar"><i style="width:<%=revenueProgress%>%"></i></div></article>
            <article class="metric-card"><span class="icon">◉</span><small>CONVERSION RATE</small><b><%=String.format(Locale.US, "%.1f", conversion)%>%</b><div class="bar"><i style="width:<%=conversionProgress%>%"></i></div></article>
            <article class="metric-card"><span class="icon">♙</span><small>CUSTOMER GROWTH</small><b><%=customerGrowth > 0 ? "+" : ""%><%=NumberFormat.getNumberInstance(Locale.US).format(customerGrowth)%></b><div class="bar"><i style="width:<%=customerGrowthProgress%>%"></i></div></article>
        </section>

        <div class="analytics-grid">
            <section class="chart-card">
                <div class="inline-title"><div><b>Sales Volume Over Time</b><small>Units sold by assignment date from real order serial data.</small></div><span class="pill"><%=h(salesRangeLabel)%></span></div>
                <% if (salesVolume.isEmpty()) { %>
                <div class="chart-empty">No sales volume data for this campaign.</div>
                <% } else { %>
                <div class="bar-chart">
                    <% for (CampaignSalesVolume point : salesVolume) { %>
                    <span style="height:<%=point.getHeightPercent()%>%"
                          title="<%=point.getSaleDate()%>: <%=point.getUnitsSold()%> units"></span>
                    <% } %>
                </div>
                <div class="axis">
                    <% for (String label : salesAxisLabels) { %>
                    <span><%=h(label)%></span>
                    <% } %>
                </div>
                <% } %>
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
                <% if (products.isEmpty()) { %>
                <tr><td colspan="6" class="empty">Campaign này chưa chọn sản phẩm nào.</td></tr>
                <% } %>
                <% for (CampaignProduct p : products) { %>
                <tr data-row="<%=h((p.getProductName()+" "+p.getSku()).toLowerCase())%>">
                    <td><b><%=h(p.getProductName())%></b><small><%=h(p.getSku())%> · <%=h(p.getCategoryName())%></small></td>
                    <td><%=money(p.getOriginalPrice())%></td>
                    <td class="blue-text strong"><%=money(p.getSalePrice())%></td>
                    <td><%=NumberFormat.getNumberInstance(Locale.US).format(p.getUnitsSold())%></td>
                    <td class="strong"><%=money(p.getRevenue())%></td>
                    <td><span class="stock <%=statusClass(p.getStatus())%>"><%=h(p.getStatus())%></span></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <div class="table-footer"><span>Showing <%=products.size()%> promotion items</span><a class="btn ghost" href="<%=listBase%>">Back to Campaigns</a></div>
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

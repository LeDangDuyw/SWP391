<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.*, java.math.*, model.Campaign, model.CampaignProduct" %>
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
    String base = request.getContextPath() + "/admin/promotions";
    Campaign c = (Campaign) request.getAttribute("campaign");
    List<CampaignProduct> products = (List<CampaignProduct>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    int totalUnits = request.getAttribute("totalUnits") == null ? 0 : (Integer) request.getAttribute("totalUnits");
    BigDecimal revenue = request.getAttribute("revenue") == null ? BigDecimal.ZERO : (BigDecimal) request.getAttribute("revenue");
    double conversion = request.getAttribute("conversion") == null ? 0 : (Double) request.getAttribute("conversion");
    int customerGrowth = request.getAttribute("customerGrowth") == null ? 0 : (Integer) request.getAttribute("customerGrowth");
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaign Performance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/promotion.css">
</head>
<body>
<div class="layout detail-layout">
    <aside class="sidebar narrow">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="#">▦ Dashboard</a>
            <a class="active" href="<%=base%>">▥ Analytics</a>
            <a href="#">▣ Orders</a>
            <a href="#">▤ Inventory</a>
            <a href="#">♚ Users</a>
            <a href="#">⚙ Settings</a>
        </nav>
        <div class="profile">◎ <span>Admin User<br><small>SUPER ADMIN</small></span></div>
    </aside>

    <main class="main performance-page">
        <header class="topbar slim">
            <form action="<%=base%>" method="get" class="top-search wide">
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
                <a class="btn ghost" target="_blank" href="<%=base%>?action=exportPdf&id=<%=c.getCampaignId()%>">⇩ Export PDF</a>
                <a class="btn primary" href="<%=base%>?action=show&id=<%=c.getCampaignId()%>">⟳ Live Sync</a>
                <a class="btn ghost" href="<%=base%>?action=edit&id=<%=c.getCampaignId()%>">Edit</a>
            </div>
        </section>

        <% if ("pending_approval".equals(c.getStatus())) { %>
        <div class="review-bar">
            <b>Campaign đang chờ duyệt.</b>
            <form method="post" action="<%=base%>">
                <input type="hidden" name="id" value="<%=c.getCampaignId()%>">
                <button class="btn primary" name="action" value="approve">Approve</button>
                <button class="btn danger-fill" name="action" value="reject">Reject</button>
            </form>
        </div>
        <% } %>

        <section class="metric-grid four">
            <article class="metric-card"><span class="icon">▭</span><small>TOTAL UNITS SOLD</small><b><%=NumberFormat.getNumberInstance(Locale.US).format(totalUnits)%></b><div class="bar"><i style="width:82%"></i></div></article>
            <article class="metric-card"><span class="icon">▣</span><small>TOTAL REVENUE</small><b><%=shortMoney(revenue)%></b><div class="bar"><i style="width:64%"></i></div></article>
            <article class="metric-card"><span class="icon">◉</span><small>CONVERSION RATE</small><b><%=String.format(Locale.US, "%.1f", conversion)%>%</b><div class="bar"><i style="width:<%=Math.min(100, (int)conversion)%>%"></i></div></article>
            <article class="metric-card"><span class="icon">♙</span><small>CUSTOMER GROWTH</small><b>+<%=NumberFormat.getNumberInstance(Locale.US).format(customerGrowth)%></b><div class="bar"><i style="width:70%"></i></div></article>
        </section>

        <div class="analytics-grid">
            <section class="chart-card">
                <div class="inline-title"><div><b>Sales Volume Over Time</b><small>Comparison between current and projected trend.</small></div><span class="pill">Last 30 Days</span></div>
                <div class="bar-chart">
                    <span style="height:38%"></span><span style="height:54%"></span><span style="height:47%"></span><span style="height:68%"></span><span style="height:84%"></span><span style="height:58%"></span><span style="height:98%"></span><span style="height:72%"></span><span style="height:88%"></span><span style="height:100%"></span><span style="height:92%"></span><span style="height:97%"></span>
                </div>
                <div class="axis"><span>Aug 1</span><span>Aug 15</span><span>Sept 1</span><span>Today</span></div>
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
            <div class="table-footer"><span>Showing <%=products.size()%> promotion items</span><a class="btn ghost" href="<%=base%>">Back to Campaigns</a></div>
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

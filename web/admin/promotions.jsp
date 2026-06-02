<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.*, model.Campaign, model.CampaignStats" %>
<%!
    String h(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;"); }
    String money(Number n) { return NumberFormat.getCurrencyInstance(new Locale("vi", "VN")).format(n == null ? 0 : n); }
    String date(Object d) { return d == null ? "-" : d.toString().replace('T', ' ').substring(0, Math.min(10, d.toString().length())); }
 String statusText(String s) {
        if (s == null) {
            return "Unknown";
        }

        switch (s) {
            case "active":
                return "Active";
            case "scheduled":
                return "Scheduled";
            case "pending_approval":
                return "Pending Approval";
            case "paused":
                return "Paused";
            case "stopped":
                return "Stopped";
            case "expired":
                return "Expired";
            default:
                return s;
        }
    }
    String statusClass(String s) { return s == null ? "" : s.replace('_', '-'); }
%>
<%
    String base = request.getContextPath() + "/admin/promotions";
    List<Campaign> campaigns = (List<Campaign>) request.getAttribute("campaigns");
    CampaignStats stats = (CampaignStats) request.getAttribute("stats");
    if (campaigns == null) campaigns = new ArrayList<>();
    if (stats == null) stats = new CampaignStats();
    String keyword = (String) request.getAttribute("keyword");
    int pageNo = request.getAttribute("page") == null ? 1 : (Integer) request.getAttribute("page");
    int pageSize = request.getAttribute("pageSize") == null ? 6 : (Integer) request.getAttribute("pageSize");
    int total = request.getAttribute("total") == null ? campaigns.size() : (Integer) request.getAttribute("total");
    int totalPages = Math.max(1, (int)Math.ceil(total * 1.0 / pageSize));
    String msg = (String) request.getAttribute("msg");
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNILAP Admin - Promotions</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/promotion.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand"><span>UNILAP Admin</span><small>System Controller</small></div>
        <nav>
            <a href="#"><span>▦</span>Dashboard</a>
            <a href="#"><span>▣</span>Orders</a>
            <a href="#"><span>▤</span>Inventory</a>
            <a href="#"><span>♚</span>Users</a>
            <a class="active" href="<%=base%>"><span>▥</span>Analytics</a>
            <a href="#"><span>⚙</span>Settings</a>
        </nav>
        <div class="profile">♙ <span>Admin User Profile</span></div>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>Console</h1>
            <form action="<%=base%>" method="get" class="top-search">
                <input name="keyword" value="<%=h(keyword)%>" placeholder="Search promotions...">
            </form>
            <div class="top-icons">⌕ &nbsp; ◴</div>
        </header>

        <section class="page-head">
            <div>
                <h2>Vouchers &amp; Promotions</h2>
                <p>Manage active campaigns, discount codes, and seasonal promotions.</p>
            </div>
            <div class="head-actions">
                <a class="btn ghost" href="<%=base%>?action=export&keyword=<%=java.net.URLEncoder.encode(keyword == null ? "" : keyword, java.nio.charset.StandardCharsets.UTF_8)%>">Export Report</a>
                <a class="btn primary" href="<%=base%>?action=create">＋ Create Campaign</a>
            </div>
        </section>

        <% if (msg != null && !msg.isBlank()) { %>
        <div class="alert success"><%=h(msg)%></div>
        <% } %>

        <section class="stats-grid">
            <article class="stat-card">
                <h3>Active Campaigns</h3>
                <strong class="blue"><%=stats.getActiveCampaigns()%></strong>
                <p><span class="up">↗</span> running now</p>
            </article>
            <article class="stat-card">
                <h3>Total Redemptions (MTD)</h3>
                <strong><%=NumberFormat.getNumberInstance(Locale.US).format(stats.getTotalRedemptions())%></strong>
                <p><span class="up blue-text">↗</span> voucher usage</p>
            </article>
            <article class="stat-card">
                <h3>Pending Approvals</h3>
                <strong class="red"><%=stats.getPendingApprovals()%></strong>
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
                <% if (campaigns.isEmpty()) { %>
                <tr><td colspan="6" class="empty">Không có campaign nào. Bấm Create Campaign để tạo mới.</td></tr>
                <% } %>
                <% for (Campaign c : campaigns) { %>
                <tr>
                    <td>
                        <b><%=h(c.getCampaignName())%></b>
                        <small><%=h(c.getCampaignDescription())%></small>
                    </td>
                    <td><code><%=h(c.getPromoCode())%></code><small><%=h(c.getCampaignType())%></small></td>
                    <td><span class="badge <%=statusClass(c.getStatus())%>"><%=statusText(c.getStatus())%></span></td>
                    <td><%=NumberFormat.getNumberInstance(Locale.US).format(c.getUsedCount())%> / <%=c.getUsageLimit() == null ? "∞" : NumberFormat.getNumberInstance(Locale.US).format(c.getUsageLimit())%></td>
                    <td><%=date(c.getEndDate())%></td>
                    <td class="actions right">
                        <a href="<%=base%>?action=show&id=<%=c.getCampaignId()%>">◎ Show</a>
                        <% if ("active".equals(c.getStatus())) { %>
                        <form method="post" action="<%=base%>"><input type="hidden" name="id" value="<%=c.getCampaignId()%>"><input type="hidden" name="action" value="stop"><button class="link danger" onclick="return confirm('Stop campaign này?')">Stop</button></form>
                        <% } else if ("scheduled".equals(c.getStatus()) || "paused".equals(c.getStatus())) { %>
                        <form method="post" action="<%=base%>"><input type="hidden" name="id" value="<%=c.getCampaignId()%>"><input type="hidden" name="action" value="resume"><button class="link">Resume</button></form>
                        <% } else if ("pending_approval".equals(c.getStatus())) { %>
                        <a href="<%=base%>?action=show&id=<%=c.getCampaignId()%>&review=true">Review</a>
                        <% } %>
                        <% if (!"pending_approval".equals(c.getStatus())) { %>
                        <a href="<%=base%>?action=edit&id=<%=c.getCampaignId()%>">Edit</a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <div class="table-footer">
                <span>Showing <%=campaigns.isEmpty() ? 0 : ((pageNo - 1) * pageSize + 1)%>-<%=Math.min(pageNo * pageSize, total)%> of <%=total%> campaigns</span>
                <div class="pager">
                    <a class="page-btn <%=pageNo <= 1 ? "disabled" : ""%>" href="<%=base%>?page=<%=Math.max(1, pageNo-1)%>&keyword=<%=java.net.URLEncoder.encode(keyword == null ? "" : keyword, java.nio.charset.StandardCharsets.UTF_8)%>">‹</a>
                    <span><%=pageNo%>/<%=totalPages%></span>
                    <a class="page-btn <%=pageNo >= totalPages ? "disabled" : ""%>" href="<%=base%>?page=<%=Math.min(totalPages, pageNo+1)%>&keyword=<%=java.net.URLEncoder.encode(keyword == null ? "" : keyword, java.nio.charset.StandardCharsets.UTF_8)%>">›</a>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>

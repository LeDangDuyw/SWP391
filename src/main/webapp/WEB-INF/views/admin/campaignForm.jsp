<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Campaign" %>
<%@ page import="model.ProductSearchItem" %>

<%!
    String h(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    String dateValue(Object d) {
        if (d == null) {
            return "";
        }

        String text = d.toString();

        if (text.length() >= 10) {
            return text.substring(0, 10);
        }

        return text;
    }

    String checked(boolean v) {
        if (v) {
            return "checked";
        }
        return "";
    }

    String selected(String a, String b) {
        if (a == null && b == null) {
            return "selected";
        }

        if (a != null && a.equals(b)) {
            return "selected";
        }

        return "";
    }

    String money(Number n) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

        if (n == null) {
            return nf.format(0);
        }

        return nf.format(n);
    }

    String numberValue(Object n) {
        if (n == null) {
            return "";
        }

        return n.toString();
    }
%>
<%
    String base = request.getContextPath() + "/admin/promotions";

    Campaign c = (Campaign) request.getAttribute("campaign");

    boolean editing = false;

    if (c != null && c.getCampaignId() > 0) {
        editing = true;
    }

    if (c == null) {
        c = new Campaign();
    }

    List<ProductSearchItem> products = (List<ProductSearchItem>) request.getAttribute("products");

if (products == null) {
    products = new ArrayList<ProductSearchItem>();
}

String discountValueText = "";
if (c.getDiscountValue() != null) {
    discountValueText = c.getDiscountValue().toString();
}

String usageLimitText = "";
if (c.getUsageLimit() != null) {
    usageLimitText = String.valueOf(c.getUsageLimit());
}
%>
    



<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= editing ? "Edit Campaign" : "Create Campaign" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/promotion.css">
</head>

<body>
<div class="layout">

    <aside class="sidebar compact">
        <div class="brand">
            <span>UNILAP</span>
            <small>System Administrator</small>
        </div>

        <nav>
            <a href="#"><span>▦</span> Dashboard</a>
            <a class="active" href="<%= base %>"><span>🛒</span> Orders</a>
            <a href="#"><span>▤</span> Inventory</a>
            <a href="#"><span>♚</span> Users</a>
            <a href="#"><span>▥</span> Analytics</a>
            <a href="#"><span>⚙</span> Settings</a>
        </nav>

        <div class="side-bottom">
            <a href="#">? Support</a>
            <a href="#">↪ Logout</a>
        </div>
    </aside>

    <main class="main form-page">

        <header class="topbar">
            <h1>UNILAP Console</h1>
            <div class="top-search">
                <input placeholder="Search resources...">
            </div>
            <div class="avatar">AD</div>
        </header>

        <div class="crumb">
            Campaigns <span>›</span>
            <b><%= editing ? "Edit Campaign" : "New Campaign" %></b>
        </div>

        <form method="post" action="<%= base %>" class="campaign-form" id="campaignForm">

            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" value="<%= c.getCampaignId() %>">

            <section class="page-head no-margin">
                <div>
                    <h2><%= editing ? "Edit Campaign" : "Create New Campaign" %></h2>
                </div>

                <div class="head-actions">
                    <a class="btn ghost" href="<%= base %>">Cancel</a>
                    <button class="btn primary" type="submit">▣ Save Campaign</button>
                </div>
            </section>

            <div class="form-grid">

                <div class="left-stack">

                    <section class="form-card">
                        <h3>📣 Campaign Details</h3>

                        <label>Campaign Name</label>
                        <input name="campaignName"
                               required
                               value="<%= h(c.getCampaignName()) %>"
                               placeholder="e.g. Summer Tech Extravaganza 2026">

                        <label>Campaign Description</label>
                        <textarea name="campaignDescription"
                                  rows="4"
                                  placeholder="Provide internal details or customer-facing teaser text..."><%= h(c.getCampaignDescription()) %></textarea>

                        <div class="two-cols">
                            <div>
                                <label>Campaign Type</label>
                                <select name="campaignType" id="campaignType">
                                    <option value="percentage" <%= selected(c.getCampaignType(), "percentage") %>>
                                        Percentage Discount
                                    </option>
                                    <option value="fixed" <%= selected(c.getCampaignType(), "fixed") %>>
                                        Fixed Amount Discount
                                    </option>
                                    <option value="flash" <%= selected(c.getCampaignType(), "flash") %>>
                                        Flash Sale / Auto Apply
                                    </option>
                                </select>
                            </div>

                            <div>
                                <label>Targeting Group</label>
                                <select name="targetGroup">
                                    <option value="All Customers" <%= selected(c.getTargetGroup(), "All Customers") %>>
                                        All Customers
                                    </option>
                                    <option value="New Customers" <%= selected(c.getTargetGroup(), "New Customers") %>>
                                        New Customers
                                    </option>
                                    <option value="Students" <%= selected(c.getTargetGroup(), "Students") %>>
                                        Students
                                    </option>
                                    <option value="B2B Customers" <%= selected(c.getTargetGroup(), "B2B Customers") %>>
                                        B2B Customers
                                    </option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <section class="form-card">
                        <h3>🎟 Voucher Configuration</h3>

                        <label>Promo Code</label>
                        <div class="input-button">
                            <input name="promoCode"
                                   id="promoCode"
                                   required
                                   value="<%= h(c.getPromoCode()) %>"
                                   placeholder="SUMMER24">

                            <button type="button" class="btn ghost" id="generateBtn">
                                ↻ Generate
                            </button>
                        </div>

                        <div class="two-cols">
                            <div>
                                <label>Discount Value</label>
                                <input name="discountValue"
                                       type="number"
                                       step="0.01"
                                       min="0"
                                       value="<%= numberValue(c.getDiscountValue()) %>">
                            </div>

                            <div>
                                <label>Usage Limit</label>
                                <input name="usageLimit"
                                       type="number"
                                       min="0"
                                       value="<%= numberValue(c.getUsageLimit()) %>"
                                       placeholder="1000">
                            </div>
                        </div>
                    </section>

                    <section class="form-card product-picker">
                        <div class="inline-title">
                            <h3>🔎 Applicable Products</h3>
                            <small>Chọn trực tiếp sản phẩm/variant trong database.</small>
                        </div>

                        <input type="search"
                               id="productFilter"
                               placeholder="Tìm sản phẩm, SKU, category...">

                        <div class="product-list" id="productList">

                            <%
                                for (int i = 0; i < products.size(); i++) {
                                    ProductSearchItem p = products.get(i);

                                    String searchText =
                                            String.valueOf(p.getProductName()) + " " +
                                            String.valueOf(p.getVariantName()) + " " +
                                            String.valueOf(p.getSku()) + " " +
                                            String.valueOf(p.getCategoryName());

                                    searchText = searchText.toLowerCase();
                            %>

                            <label class="product-option" data-search="<%= h(searchText) %>">
                                <input type="checkbox"
                                       name="variantIds"
                                       value="<%= p.getVariantId() %>"
                                       <%= checked(p.isSelected()) %>>

                                <span>
                                    <b><%= h(p.getProductName()) %></b>
                                    <small>
                                        <%= h(p.getVariantName()) %>
                                        · <%= h(p.getSku()) %>
                                        · <%= h(p.getCategoryName()) %>
                                    </small>
                                </span>

                                <em>
                                    <%= money(p.getPrice()) %>
                                    <br>
                                    <small>Stock: <%= p.getStock() %></small>
                                </em>
                            </label>

                            <%
                                }
                            %>

                        </div>
                    </section>

                </div>

                <aside class="right-stack">

                    <section class="form-card side-card">
                        <h3>▣ Scheduling</h3>

                        <label>Start Date</label>
                        <input name="startDate"
                               type="date"
                               required
                               value="<%= dateValue(c.getStartDate()) %>">

                        <label>End Date</label>
                        <input name="endDate"
                               type="date"
                               required
                               value="<%= dateValue(c.getEndDate()) %>">

                        <div class="info-box">
                            ⓘ This campaign will automatically activate at 12:00 AM on the start date.
                        </div>
                    </section>

                    <section class="form-card side-card">
                        <h3>≋ Conditions</h3>

                        <label>Minimum Order Value</label>
                        <input name="minOrderValue"
                               type="number"
                               step="0.01"
                               min="0"
                               value="<%= numberValue(c.getMinOrderValue()) %>"
                               placeholder="500000">

                        <label>Status</label>
                        <select name="status">
                            <option value="scheduled" <%= selected(c.getStatus(), "scheduled") %>>
                                Scheduled
                            </option>
                            <option value="active" <%= selected(c.getStatus(), "active") %>>
                                Active
                            </option>
                            <option value="paused" <%= selected(c.getStatus(), "paused") %>>
                                Paused
                            </option>
                            <option value="pending_approval" <%= selected(c.getStatus(), "pending_approval") %>>
                                Pending Approval
                            </option>
                            <option value="stopped" <%= selected(c.getStatus(), "stopped") %>>
                                Stopped
                            </option>
                        </select>
                    </section>

                    <section class="preview-card">
                        <div>
                            <b>Visual Asset Preview</b>
                            <span>Summer Campaign Banner Auto-generated</span>
                        </div>
                    </section>

                </aside>

            </div>
        </form>

    </main>
</div>

<script>
    var filter = document.getElementById("productFilter");
    var options = document.getElementsByClassName("product-option");

    if (filter != null) {
        filter.onkeyup = function () {
            var key = filter.value;
            key = key.replace(/^\s+|\s+$/g, "").toLowerCase();

            for (var i = 0; i < options.length; i++) {
                var row = options[i];
                var search = row.getAttribute("data-search");

                if (search == null) {
                    search = "";
                }

                if (search.indexOf(key) >= 0) {
                    row.style.display = "grid";
                } else {
                    row.style.display = "none";
                }
            }
        };
    }

    var generateBtn = document.getElementById("generateBtn");

    if (generateBtn != null) {
        generateBtn.onclick = function () {
            var xhr = new XMLHttpRequest();

            xhr.open("GET", "<%= base %>?action=generate", true);

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var input = document.getElementById("promoCode");

                    if (xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            input.value = data.code;
                        } catch (e) {
                            input.value = "UNI" + Math.random().toString(36).substring(2, 8).toUpperCase();
                        }
                    } else {
                        input.value = "UNI" + Math.random().toString(36).substring(2, 8).toUpperCase();
                    }
                }
            };

            xhr.send();
        };
    }
</script>

</body>
</html>
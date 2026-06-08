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
    String base = request.getContextPath() + "/admin/campaign-form";
    String listBase = request.getContextPath() + "/admin/promotions";

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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/promotion.css">
    <style>
        .selected-product-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 14px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            border-radius: 8px;
            margin-bottom: 8px;
            font-size: 13px;
            transition: all 0.2s ease;
        }
        .selected-product-row:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .selected-product-row strong {
            color: var(--blue);
        }
        .btn-remove {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            font-size: 20px;
            line-height: 1;
            padding: 0 6px;
            border-radius: 4px;
            transition: all 0.15s ease;
        }
        .btn-remove:hover {
            background: #fee2e2;
            color: #dc2626;
        }
        .product-picker-options {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr auto;
            gap: 12px;
            margin: 15px 0;
            align-items: end;
        }
        .product-picker-options div {
            display: flex;
            flex-direction: column;
        }
        .product-picker-options label {
            margin: 0 0 6px 0 !important;
            font-size: 12px !important;
            color: var(--muted);
        }
        .product-picker-options select, .product-picker-options input {
            height: 40px;
            padding: 8px 12px;
            border: 1px solid var(--line);
            background: #f8fafc;
            outline: none;
            border-radius: 6px;
        }
        .input-error {
            border-color: #ef4444 !important;
            background-color: #fef2f2 !important;
        }
    </style>
</head>

<body>
<div class="layout">

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
                    <a class="btn ghost" href="<%= listBase %>">Cancel</a>
                    <button class="btn primary" type="submit">▣ Save Campaign</button>
                </div>
            </section>

            <div class="form-grid">

                <div class="left-stack">

                    <section class="form-card">
                        <h3>📣 Campaign Details</h3>

                        <label>Campaign Name</label>
                        <input name="campaignName"
                               id="campaignName"
                               required
                               value="<%= h(c.getCampaignName()) %>"
                               placeholder="e.g. Summer Tech Extravaganza 2026">
                        <span class="validation-error" id="campaignNameError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>

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
                                    <option value="bundle_discount" <%= selected(c.getCampaignType(), "bundle_discount") %>>
                                        Buy Together Discount
                                    </option>
                                    <option value="gift_with_purchase" <%= selected(c.getCampaignType(), "gift_with_purchase") %>>
                                        Gift With Purchase
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

                    <section class="form-card" id="voucherConfigCard">
                        <h3>🎟 Voucher Configuration</h3>

                        <div id="promoCodeGroup" style="margin-bottom: 15px;">
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
                            <span class="validation-error" id="promoCodeError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                        </div>

                        <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                            <div id="discountValueGroup" style="flex: 1; min-width: 200px;">
                                <label>Discount Value <span id="discountUnit"></span></label>
                                <input name="discountValue"
                                       id="discountValue"
                                       type="number"
                                       step="1"
                                       min="0"
                                       value="<%= numberValue(c.getDiscountValue()) %>"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="discountValueError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                            </div>

                            <div id="usageLimitGroup" style="flex: 1; min-width: 200px;">
                                <label>Usage Limit</label>
                                <input name="usageLimit"
                                       id="usageLimit"
                                       type="number"
                                       min="0"
                                       value="<%= numberValue(c.getUsageLimit()) %>"
                                       placeholder="1000"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="usageLimitError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                            </div>
                        </div>
                    </section>

                    <!-- Khu vực hiển thị sản phẩm đã chọn -->
                    <section class="form-card" id="selectedProductsCard">
                        <div class="inline-title">
                            <h3>🛒 Sản phẩm đã chọn (<span id="selectedCount">0</span>)</h3>
                            <small>Các sản phẩm/biến thể đã chọn áp dụng cho chiến dịch này.</small>
                        </div>
                        <div class="selected-products-list" id="selectedProductsList" style="margin-top: 14px; display: flex; flex-direction: column; gap: 8px;">
                            <!-- Danh sách sẽ được chèn động bởi JS -->
                        </div>
                    </section>

                    <section class="form-card product-picker">
                        <div class="inline-title">
                            <h3>🔎 Applicable Products</h3>
                            <small>Chọn trực tiếp sản phẩm/variant trong database.</small>
                        </div>

                        <div style="display: flex; gap: 10px; margin-bottom: 12px; margin-top: 10px;">
                            <input type="search"
                                   id="productFilter"
                                   placeholder="Tìm sản phẩm, SKU, category..."
                                   style="flex: 1; margin: 0; padding: 10px 14px; border: 1px solid var(--line); border-radius: 6px;">
                        </div>

                        <div class="product-picker-options">
                            <div>
                                <label>Lọc theo tiêu chí</label>
                                <select id="optionType">
                                    <option value="all">Tất cả sản phẩm</option>
                                    <option value="best_seller">Sản phẩm bán chạy nhất</option>
                                    <option value="least_bought">Sản phẩm ít được mua nhất</option>
                                </select>
                            </div>
                            <div id="dateFilterStartGroup" style="display: none;">
                                <label>Từ ngày</label>
                                <input type="date" id="salesStartDate">
                            </div>
                            <div id="dateFilterEndGroup" style="display: none;">
                                <label>Đến ngày</label>
                                <input type="date" id="salesEndDate">
                            </div>
                            <div>
                                <button type="button" class="btn primary" id="btnApplySalesFilter" style="height: 40px; min-height: unset; padding: 8px 20px; font-size: 13px; font-weight: bold; border-radius: 6px;">
                                    Lọc
                                </button>
                            </div>
                        </div>

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
                                       class="picker-checkbox"
                                       data-id="<%= p.getVariantId() %>"
                                       data-name="<%= h(p.getProductName()) %>"
                                       data-variant="<%= h(p.getVariantName()) %>"
                                       data-sku="<%= h(p.getSku()) %>"
                                       data-category="<%= h(p.getCategoryName()) %>"
                                       data-price="<%= p.getPrice() %>"
                                       data-stock="<%= p.getStock() %>"
                                       data-gift="<%= p.isGift() %>"
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
                               id="startDate"
                               type="date"
                               required
                               value="<%= dateValue(c.getStartDate()) %>">

                        <label>End Date</label>
                        <input name="endDate"
                               id="endDate"
                               type="date"
                               required
                               value="<%= dateValue(c.getEndDate()) %>">

                        <div class="info-box">
                            ⓘ This campaign will automatically activate at 12:00 AM on the start date.
                        </div>
                    </section>

                    <section class="form-card side-card">
                        <h3>≋ Conditions</h3>

                        <div id="minOrderValueGroup">
                            <label>Minimum Order Value VND</label>
                            <input name="minOrderValue"
                                   id="minOrderValue"
                                   type="number"
                                   step="1"
                                   min="0"
                                   value="<%= numberValue(c.getMinOrderValue()) %>"
                                   placeholder="500000 Đ">
                            <span class="validation-error" id="minOrderValueError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                        </div>

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
    // State management for selected products
    var selectedProductsMap = {};

    // Global date/time validation configuration
    var today = new Date();
    var yyyy = today.getFullYear();
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    var dd = String(today.getDate()).padStart(2, '0');
    var todayStr = yyyy + '-' + mm + '-' + dd;
    //calculate 6 month max
    var maxDate = new Date();
    maxDate.setMonth(maxDate.getMonth() + 6);
    var maxYyyy = maxDate.getFullYear();
    var maxMm = String(maxDate.getMonth() + 1).padStart(2, '0');
    var maxDd = String(maxDate.getDate()).padStart(2, '0');
    var maxDateStr = maxYyyy + '-' + maxMm + '-' + maxDd;

    window.addEventListener("DOMContentLoaded", function() {
        var startDateInput = document.getElementById("startDate");
        var endDateInput = document.getElementById("endDate");

        if (startDateInput && endDateInput) {
            startDateInput.setAttribute("min", todayStr);
            startDateInput.setAttribute("max", maxDateStr);
            endDateInput.setAttribute("min", todayStr);
            endDateInput.setAttribute("max", maxDateStr);

            startDateInput.addEventListener("change", function() {
                if (startDateInput.value) {
                    endDateInput.setAttribute("min", startDateInput.value);
                }
            });
            if (startDateInput.value) {
                endDateInput.setAttribute("min", startDateInput.value);
            }
        }

        var salesStartDateInput = document.getElementById("salesStartDate");
        var salesEndDateInput = document.getElementById("salesEndDate");

        if (salesStartDateInput && salesEndDateInput) {
            salesStartDateInput.setAttribute("max", todayStr);
            salesEndDateInput.setAttribute("max", todayStr);

            salesStartDateInput.addEventListener("change", function() {
                if (salesStartDateInput.value) {
                    salesEndDateInput.setAttribute("min", salesStartDateInput.value);
                }
            });
        }

        // Live validation for Campaign Name uniqueness
        var campaignNameInput = document.getElementById("campaignName");
        var campaignNameError = document.getElementById("campaignNameError");
        var isNameValid = true;

        function validateCampaignName() {
            var name = campaignNameInput.value.trim();
            if (!name) {
                campaignNameError.textContent = "Tên chiến dịch không được để trống!";
                campaignNameError.style.display = "block";
                campaignNameInput.classList.add("input-error");
                isNameValid = false;
                return;
            }
            var campaignId = "<%= c.getCampaignId() %>";
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "<%= base %>?action=check-name&name=" + encodeURIComponent(name) + "&id=" + campaignId, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    try {
                        var res = JSON.parse(xhr.responseText);
                        if (res.exists) {
                            campaignNameError.textContent = "Tên chiến dịch '" + name + "' đã được sử dụng!";
                            campaignNameError.style.display = "block";
                            campaignNameInput.classList.add("input-error");
                            isNameValid = false;
                        } else {
                            campaignNameError.style.display = "none";
                            campaignNameInput.classList.remove("input-error");
                            isNameValid = true;
                        }
                    } catch (e) {}
                }
            };
            xhr.send();
        }

        if (campaignNameInput) {
            campaignNameInput.addEventListener("blur", validateCampaignName);
            campaignNameInput.addEventListener("input", function() {
                campaignNameError.style.display = "none";
                campaignNameInput.classList.remove("input-error");
                isNameValid = true;
            });
        }

        var form = document.getElementById("campaignForm");
        if (form && startDateInput && endDateInput) {
            form.addEventListener("submit", function(e) {
                var isValid = true;

                // 1. Campaign Name validation
                var name = campaignNameInput ? campaignNameInput.value.trim() : "";
                if (!name) {
                    campaignNameError.textContent = "Tên chiến dịch không được để trống!";
                    campaignNameError.style.display = "block";
                    campaignNameInput.classList.add("input-error");
                    isValid = false;
                } else if (!isNameValid) {
                    campaignNameError.style.display = "block";
                    campaignNameInput.classList.add("input-error");
                    isValid = false;
                }

                // 2. Promo Code validation
                var campaignTypeSelect = document.getElementById("campaignType");
                var type = campaignTypeSelect ? campaignTypeSelect.value : "";
                var promoCodeInput = document.getElementById("promoCode");
                var promoCodeError = document.getElementById("promoCodeError");
                if (promoCodeInput && promoCodeError) {
                    promoCodeError.style.display = "none";
                    promoCodeInput.classList.remove("input-error");

                    if (type === "percentage" || type === "fixed") {
                        var code = promoCodeInput.value.trim();
                        if (!code) {
                            promoCodeError.textContent = "Mã khuyến mãi không được để trống!";
                            promoCodeError.style.display = "block";
                            promoCodeInput.classList.add("input-error");
                            isValid = false;
                        } else if (code.length !== 9) {
                            promoCodeError.textContent = "Mã khuyến mãi phải nhập đủ 9 ký tự!";
                            promoCodeError.style.display = "block";
                            promoCodeInput.classList.add("input-error");
                            isValid = false;
                        }
                    }
                }

                // 3. Discount Value validation
                var discountValueInput = document.getElementById("discountValue");
                var discountValueError = document.getElementById("discountValueError");
                if (discountValueInput && discountValueError) {
                    discountValueError.style.display = "none";
                    discountValueInput.classList.remove("input-error");

                    var discVal = parseFloat(discountValueInput.value);
                    if (!isNaN(discVal)) {
                        if (discVal < 0) {
                            discountValueError.textContent = "Giá trị giảm giá không được nhập số âm!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                        } else if ((type === "percentage" || type === "flash") && discVal > 99) {
                            discountValueError.textContent = "Đối với phần trăm (%), giá trị giảm giá chỉ được nhập tối đa là 99%!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                        } else if ((type === "fixed" || type === "bundle_discount") && discVal > 10000000) {
                            discountValueError.textContent = "Đối với tiền mặt (VND), giá trị giảm giá chỉ được nhập tối đa là 10,000,000 VND!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                        }
                    }
                }

                // 4. Min Order Value validation
                var minOrderInput = document.getElementById("minOrderValue");
                var minOrderError = document.getElementById("minOrderValueError");
                if (minOrderInput && minOrderError) {
                    minOrderError.style.display = "none";
                    minOrderInput.classList.remove("input-error");

                    var minVal = parseFloat(minOrderInput.value);
                    if (!isNaN(minVal) && minVal < 0) {
                        minOrderError.textContent = "Giá trị đơn hàng tối thiểu không được nhập số âm!";
                        minOrderError.style.display = "block";
                        minOrderInput.classList.add("input-error");
                        isValid = false;
                    }
                }

                // 5. Usage Limit validation
                var usageLimitInput = document.getElementById("usageLimit");
                var usageLimitError = document.getElementById("usageLimitError");
                if (usageLimitInput && usageLimitError) {
                    usageLimitError.style.display = "none";
                    usageLimitInput.classList.remove("input-error");

                    var limitVal = parseFloat(usageLimitInput.value);
                    if (!isNaN(limitVal) && limitVal < 0) {
                        usageLimitError.textContent = "Giới hạn sử dụng không được nhập số âm!";
                        usageLimitError.style.display = "block";
                        usageLimitInput.classList.add("input-error");
                        isValid = false;
                    }
                }

                // 6. Dates validation
                var startVal = startDateInput.value;
                var endVal = endDateInput.value;
                if (startVal < todayStr) {
                    alert("Ngày bắt đầu chiến dịch phải từ ngày hôm nay trở đi!");
                    isValid = false;
                } else if (endVal > maxDateStr) {
                    alert("Thời gian kết thúc không được vượt quá 6 tháng kể từ hôm nay!");
                    isValid = false;
                } else if (startVal > endVal) {
                    alert("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu!");
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                    var firstError = document.querySelector(".input-error");
                    if (firstError) {
                        firstError.focus();
                        firstError.scrollIntoView({ behavior: "smooth", block: "center" });
                    }
                    return false;
                }
            });
        }
    });

    function escapeHtml(string) {
        if (!string) return "";
        return String(string)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // Function to render selected products rows & create hidden inputs for form submission
    function updateSelectedList() {
        var container = document.getElementById("selectedProductsList");
        var countSpan = document.getElementById("selectedCount");
        
        container.innerHTML = "";
        
        var keys = Object.keys(selectedProductsMap);
        countSpan.textContent = keys.length;
        
        if (keys.length === 0) {
            container.innerHTML = '<div style="color: var(--muted); font-style: italic; padding: 10px 0;">Chưa có sản phẩm nào được chọn. Hãy chọn sản phẩm ở danh sách dưới.</div>';
            return;
        }
        
        keys.forEach(function(key) {
            var p = selectedProductsMap[key];
            
            var row = document.createElement("div");
            row.className = "selected-product-row";
            
            // update gift with purchase
            var giftCheckboxHtml = "";
            var campType = document.getElementById("campaignType").value;
            var isGiftChecked = p.isGift ? "checked" : "";
            
            if (campType === "gift_with_purchase") {
                giftCheckboxHtml = 
                    '<label style="display: inline-flex; align-items: center; gap: 6px; margin-left: 15px; font-weight: normal; cursor: pointer; color: var(--green-text); font-weight: 600;">' +
                    '    <input type="checkbox" class="gift-checkbox" data-id="' + p.variantId + '" ' + isGiftChecked + '> ' +
                    '    🎁 Quà tặng' +
                    '</label>';
            }
            
            row.innerHTML = 
                '<div>' +
                '    <strong style="color: var(--blue);">' + escapeHtml(p.productName) + '</strong>' +
                '    <span style="color: var(--muted); margin-left: 8px;">' +
                '        ' + escapeHtml(p.variantName) + ' · ' + escapeHtml(p.sku) + ' · ' + escapeHtml(p.categoryName) +
                '    </span>' +
                '    ' + giftCheckboxHtml +
                '    <input type="hidden" name="variantIds" value="' + p.variantId + '">' +
                '    <input type="hidden" id="gift_input_' + p.variantId + '" name="giftVariantIds" value="' + (p.isGift ? p.variantId : "") + '" ' + (p.isGift ? "" : "disabled") + '>' +
                '</div>' +
                '<button type="button" class="btn-remove" data-id="' + p.variantId + '">' +
                '    &times;' +
                '</button>';
            
            container.appendChild(row);
        });
        
        // Bind click events to remove buttons
        container.querySelectorAll('.btn-remove').forEach(function(btn) {
            btn.onclick = function() {
                var id = btn.getAttribute('data-id');
                delete selectedProductsMap[id];
                
                // Uncheck corresponding checkbox in picker if visible
                var cb = document.querySelector('.picker-checkbox[data-id="' + id + '"]');
                if (cb) {
                    cb.checked = false;
                }
                
                updateSelectedList();
            };
        });

        // Lắng nghe sự kiện click chọn làm Quà tặng
        container.querySelectorAll('.gift-checkbox').forEach(function(gcb) {
            gcb.onchange = function() {
                var id = gcb.getAttribute('data-id');
                var isGift = gcb.checked;
                selectedProductsMap[id].isGift = isGift;
                
                var hiddenInput = document.getElementById("gift_input_" + id);
                if (hiddenInput) {
                    hiddenInput.value = isGift ? id : "";
                    hiddenInput.disabled = !isGift; // Tắt input để không gửi về server nếu không phải quà tặng
                }
            };
        });
    }

    // Initial load sync
    document.querySelectorAll('.picker-checkbox').forEach(function(cb) {
        if (cb.checked) {
            var id = cb.getAttribute('data-id');
            selectedProductsMap[id] = {
                variantId: id,
                productName: cb.getAttribute('data-name'),
                variantName: cb.getAttribute('data-variant'),
                sku: cb.getAttribute('data-sku'),
                categoryName: cb.getAttribute('data-category'),
                price: cb.getAttribute('data-price'),
                stock: cb.getAttribute('data-stock'),
                isGift: cb.getAttribute('data-gift') === "true"
            };
        }
    });
    updateSelectedList();

    // Bind change event to checkboxes in search picker list
    function bindCheckboxEvents() {
        var checkboxes = document.querySelectorAll('.picker-checkbox');
        checkboxes.forEach(function(cb) {
            cb.onchange = function() {
                var id = cb.getAttribute('data-id');
                if (cb.checked) {
                    selectedProductsMap[id] = {
                        variantId: id,
                        productName: cb.getAttribute('data-name'),
                        variantName: cb.getAttribute('data-variant'),
                        sku: cb.getAttribute('data-sku'),
                        categoryName: cb.getAttribute('data-category'),
                        price: cb.getAttribute('data-price'),
                        stock: cb.getAttribute('data-stock'),
                        isGift: cb.getAttribute('data-gift') === "true"
                    };
                } else {
                    delete selectedProductsMap[id];
                }
                updateSelectedList();
            };
        });
    }
    bindCheckboxEvents();

    // Local client-side filtering (onkeyup)
    var filter = document.getElementById("productFilter");
    if (filter != null) {
        filter.onkeyup = function () {
            var key = filter.value;
            key = key.replace(/^\s+|\s+$/g, "").toLowerCase();
            var options = document.getElementsByClassName("product-option");

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

    // AJAX product loader based on advanced filters
    function loadProducts() {
        var keyword = document.getElementById("productFilter").value;
        var optionType = document.getElementById("optionType").value;
        var startDate = document.getElementById("salesStartDate").value;
        var endDate = document.getElementById("salesEndDate").value;
        var campaignId = "<%= c.getCampaignId() %>";

        // Date validation: no future dates allowed for sales filtering
        if (startDate > todayStr || endDate > todayStr) {
            alert("Thời gian lọc không được chọn ngày tương lai!");
            return;
        }
        if (startDate && endDate && startDate > endDate) {
            alert("Ngày kết thúc lọc phải lớn hơn hoặc bằng ngày bắt đầu!");
            return;
        }

        var productListContainer = document.getElementById("productList");
        productListContainer.innerHTML = '<div style="text-align: center; color: var(--muted); padding: 30px;">⏳ Đang tải sản phẩm...</div>';

        var url = "<%= base %>?action=products" +
                  "&keyword=" + encodeURIComponent(keyword) +
                  "&optionType=" + encodeURIComponent(optionType) +
                  "&startDate=" + encodeURIComponent(startDate) +
                  "&endDate=" + encodeURIComponent(endDate) +
                  "&campaignId=" + encodeURIComponent(campaignId);

        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var products = JSON.parse(xhr.responseText);
                        renderProductList(products);
                    } catch (e) {
                        productListContainer.innerHTML = '<div style="text-align: center; color: var(--red); padding: 20px;">Lỗi tải dữ liệu.</div>';
                    }
                } else {
                    productListContainer.innerHTML = '<div style="text-align: center; color: var(--red); padding: 20px;">Lỗi kết nối máy chủ.</div>';
                }
            }
        };
        xhr.send();
    }

    function renderProductList(products) {
        var container = document.getElementById("productList");
        container.innerHTML = "";

        if (products.length === 0) {
            container.innerHTML = '<div style="text-align: center; color: var(--muted); padding: 30px;">Không tìm thấy sản phẩm phù hợp.</div>';
            return;
        }

        products.forEach(function(p) {
            var isChecked = selectedProductsMap[p.variantId] ? "checked" : "";
            var searchText = (p.name + " " + p.variant + " " + p.sku + " " + p.category).toLowerCase();
            
            var formatter = new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            });
            var priceFormatted = formatter.format(p.price);

            var label = document.createElement("label");
            label.className = "product-option";
            label.setAttribute("data-search", searchText);

            var soldInfo = "";
            var optionType = document.getElementById("optionType").value;
            if (optionType === "best_seller" || optionType === "least_bought") {
                soldInfo = '<br><span style="color: var(--green-text); font-weight: bold; font-size: 11px; background: #e8f7ee; padding: 2px 6px; border-radius: 4px; display: inline-block; margin-top: 4px;">🔥 Đã bán: ' + p.soldQty + '</span>';
            }

            label.innerHTML = 
                '<input type="checkbox" class="picker-checkbox" ' +
                '       data-id="' + p.variantId + '" ' +
                '       data-name="' + escapeHtml(p.name) + '" ' +
                '       data-variant="' + escapeHtml(p.variant) + '" ' +
                '       data-sku="' + escapeHtml(p.sku) + '" ' +
                '       data-category="' + escapeHtml(p.category) + '" ' +
                '       data-price="' + p.price + '" ' +
                '       data-stock="' + p.stock + '" ' +
                '       data-gift="' + (p.gift ? "true" : "false") + '" ' +
                '       ' + isChecked + '> ' +
                '<span> ' +
                '    <b>' + escapeHtml(p.name) + '</b> ' +
                '    <small>' +
                '        ' + escapeHtml(p.variant) +
                '        · ' + escapeHtml(p.sku) +
                '        · ' + escapeHtml(p.category) +
                '    </small> ' +
                '</span> ' +
                '<em> ' +
                '    ' + priceFormatted + ' ' +
                '    <br> ' +
                '    <small>Stock: ' + p.stock + '</small> ' +
                '    ' + soldInfo + ' ' +
                '</em>';
            
            container.appendChild(label);
        });

        bindCheckboxEvents();
    }

    // Dynamic visibility of date range groups
    var optionTypeSelect = document.getElementById("optionType");
    var dateFilterStartGroup = document.getElementById("dateFilterStartGroup");
    var dateFilterEndGroup = document.getElementById("dateFilterEndGroup");

    function updateDateFiltersVisibility() {
        var val = optionTypeSelect.value;
        if (val === "best_seller" || val === "least_bought") {
            dateFilterStartGroup.style.display = "block";
            dateFilterEndGroup.style.display = "block";
        } else {
            dateFilterStartGroup.style.display = "none";
            dateFilterEndGroup.style.display = "none";
        }
    }

    if (optionTypeSelect) {
        optionTypeSelect.addEventListener("change", function() {
            updateDateFiltersVisibility();
            loadProducts();
        });
        updateDateFiltersVisibility();
    }

    var btnApplySalesFilter = document.getElementById("btnApplySalesFilter");
    if (btnApplySalesFilter) {
        btnApplySalesFilter.onclick = loadProducts;
    }

    // Existing Promo Code Generator
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
    
    // Existing Campaign Type handler
    var campaignTypeSelect = document.getElementById("campaignType");
    var discountUnitSpan = document.getElementById("discountUnit");
    function updateDiscountUnit() {
        if (campaignTypeSelect && discountUnitSpan) {
            var val = campaignTypeSelect.value;
            if (val === "percentage" || val === "flash") {
                discountUnitSpan.textContent = " (%)";
            } else {
                discountUnitSpan.textContent = " (VND)";
            }
        }
    }

    function toggleCampaignTypeFields() {
        var campTypeSelect = document.getElementById("campaignType");
        var voucherConfigCard = document.getElementById("voucherConfigCard");
        var promoCodeGroup = document.getElementById("promoCodeGroup");
        var discountValueGroup = document.getElementById("discountValueGroup");
        var usageLimitGroup = document.getElementById("usageLimitGroup");
        var minOrderValueGroup = document.getElementById("minOrderValueGroup");
        var promoCodeInput = document.getElementById("promoCode");
        var discountValueInput = document.getElementById("discountValue");
        
        if (!campTypeSelect) return;
        
        var val = campTypeSelect.value;
        
        // Dynamic limits setup
        if (discountValueInput) {
            if (val === "percentage" || val === "flash") {
                discountValueInput.setAttribute("max", "99");
                discountValueInput.setAttribute("placeholder", "e.g. 10 (%)");
            } else {
                discountValueInput.setAttribute("max", "10000000");
                discountValueInput.setAttribute("placeholder", "e.g. 500000 (VND)");
            }
        }

        if (promoCodeInput) {
            if (val === "percentage" || val === "fixed") {
                promoCodeInput.setAttribute("minlength", "9");
                promoCodeInput.setAttribute("maxlength", "9");
            } else {
                promoCodeInput.removeAttribute("minlength");
                promoCodeInput.removeAttribute("maxlength");
            }
        }
        
        if (val === "percentage" || val === "fixed") {
            // Show Voucher Configuration and Minimum Order Value Condition
            if (voucherConfigCard) voucherConfigCard.style.display = "block";
            if (promoCodeGroup) promoCodeGroup.style.display = "block";
            if (discountValueGroup) discountValueGroup.style.display = "block";
            if (usageLimitGroup) usageLimitGroup.style.display = "block";
            if (minOrderValueGroup) minOrderValueGroup.style.display = "block";
            
            if (promoCodeInput) {
                promoCodeInput.setAttribute("required", "required");
                // If it was auto-generated before, clear it so the user can enter a real one
                if (promoCodeInput.value.startsWith("AUTO-")) {
                    promoCodeInput.value = "";
                }
            }
        } else if (val === "flash" || val === "bundle_discount") {
            // Only show discount value, hide promo code and usage limit
            if (voucherConfigCard) voucherConfigCard.style.display = "block";
            if (promoCodeGroup) promoCodeGroup.style.display = "none";
            if (discountValueGroup) discountValueGroup.style.display = "block";
            if (usageLimitGroup) usageLimitGroup.style.display = "none";
            if (minOrderValueGroup) minOrderValueGroup.style.display = "none";
            
            if (promoCodeInput) {
                promoCodeInput.removeAttribute("required");
                // Auto-generate promo code if empty or clear/fill with AUTO code
                if (!promoCodeInput.value || promoCodeInput.value.trim() === "" || promoCodeInput.value.startsWith("AUTO-")) {
                    var rand = Math.random().toString(36).substring(2, 8).toUpperCase();
                    promoCodeInput.value = "AUTO-" + val.toUpperCase() + "-" + rand;
                }
            }
        } else {
            // Hide Voucher Configuration and Minimum Order Value Condition
            if (voucherConfigCard) voucherConfigCard.style.display = "none";
            if (minOrderValueGroup) minOrderValueGroup.style.display = "none";
            
            if (promoCodeInput) {
                promoCodeInput.removeAttribute("required");
                // Auto-generate promo code if empty or clear/fill with AUTO code
                if (!promoCodeInput.value || promoCodeInput.value.trim() === "" || promoCodeInput.value.startsWith("AUTO-")) {
                    var rand = Math.random().toString(36).substring(2, 8).toUpperCase();
                    promoCodeInput.value = "AUTO-" + val.toUpperCase() + "-" + rand;
                }
            }
            
            // Set default values so backend parser doesn't choke or get invalid data
            if (discountValueInput && (!discountValueInput.value || discountValueInput.value.trim() === "")) {
                discountValueInput.value = "0";
            }
        }
    }

    if (campaignTypeSelect) {
        campaignTypeSelect.addEventListener("change", function(){
            updateDiscountUnit();
            updateSelectedList();
            toggleCampaignTypeFields();
        });
        
        // Initial setup on load
        updateDiscountUnit();
        toggleCampaignTypeFields();
    }
</script>

</body>
</html>

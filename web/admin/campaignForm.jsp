<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${editing ? 'Chỉnh Sửa Chiến Dịch' : 'Tạo Chiến Dịch Mới'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
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

    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="activePage" value="promotions"/>
    </jsp:include>

    <main class="main form-page">

        <header class="topbar">
            <h1>UNILAP Admin</h1>
            <div class="top-search">
                <input placeholder="Tìm kiếm chiến dịch, mã voucher...">
            </div>
            <div class="avatar">AD</div>
        </header>

        <div class="crumb">
            Quản Lý Khuyến Mãi <span>›</span>
            <b>${editing ? "Chỉnh Sửa Chiến Dịch" : "Tạo Chiến Dịch Mới"}</b>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/campaign-form" class="campaign-form" id="campaignForm" novalidate>

            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" value="${campaign.campaignId}">

            <section class="page-head no-margin">
                <div>
                    <h2>${editing ? "Chỉnh Sửa Chiến Dịch Khuyến Mãi" : "Tạo Chiến Dịch Khuyến Mãi Mới"}</h2>
                </div>

                <div class="head-actions">
                    <a class="btn ghost" href="${pageContext.request.contextPath}/admin/promotions">Hủy Bỏ</a>
                    <button class="btn primary" type="submit">▣ Lưu Chiến Dịch</button>
                </div>
            </section>

            <div class="form-grid">

                <div class="left-stack">

                    <section class="form-card">
                        <h3>📣 Thông Tin Chiến Dịch</h3>

                        <label>Tên Chiến Dịch Khuyến Mãi</label>
                        <input name="campaignName"
                               id="campaignName"
                               required
                               value="<c:out value="${campaign.campaignName}"/>"
                               placeholder="Ví dụ: Siêu Khuyến Mãi Mùa Hè 2026">
                        <span class="validation-error" id="campaignNameError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>

                        <label>Mô Tả Chi Tiết Chiến Dịch</label>
                        <textarea name="campaignDescription"
                                  rows="4"
                                  placeholder="Nhập thông tin chi tiết nội bộ hoặc mô tả hiển thị cho khách hàng..."><c:out value="${campaign.campaignDescription}"/></textarea>

                        <div class="two-cols">
                            <div>
                                <label>Loại Chiến Dịch Khuyến Mãi</label>
                                <select name="campaignType" id="campaignType">
                                    <option value="percentage" ${campaign.campaignType == 'percentage' ? 'selected' : ''}>
                                        Giảm Giá Theo Phần Trăm (%)
                                    </option>
                                    <option value="fixed" ${campaign.campaignType == 'fixed' ? 'selected' : ''}>
                                        Giảm Giá Số Tiền Cố Định (VNĐ)
                                    </option>
                                    <option value="reward_points" ${campaign.campaignType == 'reward_points' ? 'selected' : ''}>
                                        Mã Voucher Đổi Điểm Thưởng
                                    </option>
                                    <option value="flash" ${campaign.campaignType == 'flash' ? 'selected' : ''}>
                                        Flash Sale / Giảm Giá Giờ Vàng
                                    </option>
                                </select>
                            </div>

                            <div>
                                <label>Nhóm Khách Hàng Áp Dụng</label>
                                <select name="targetGroup">
                                    <option value="All Customers" ${campaign.targetGroup == 'All Customers' ? 'selected' : ''}>
                                        Tất Cả Khách Hàng
                                    </option>
                                    <option value="New Customers" ${campaign.targetGroup == 'New Customers' ? 'selected' : ''}>
                                        Khách Hàng Mới
                                    </option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <section class="form-card" id="voucherConfigCard">
                        <h3>🎟 Cấu Hình Voucher & Giảm Giá</h3>

                        <div id="promoCodeGroup" style="margin-bottom: 15px;">
                            <label>Mã Giảm Giá (Promo Code)</label>
                            <div class="input-button">
                                <input name="promoCode"
                                       id="promoCode"
                                       required
                                       value="<c:out value="${campaign.promoCode}"/>"
                                       placeholder="Ví dụ: SUMMER2026">

                                <button type="button" class="btn ghost" id="generateBtn">
                                    ↻ Tạo Tự Động
                                </button>
                            </div>
                            <span class="validation-error" id="promoCodeError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                        </div>

                        <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                            <div id="discountValueGroup" style="flex: 1; min-width: 200px;">
                                <label>Mức Giảm Giá <span id="discountUnit"></span></label>
                                <input name="discountValue"
                                       id="discountValue"
                                       type="number"
                                       step="1"
                                       min="0"
                                       value="${campaign.discountValue}"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="discountValueError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                            </div>

                            <div id="pointsRequiredGroup" style="flex: 1; min-width: 200px; display: none;">
                                <label>Số Điểm Thưởng Cần Đổi (Điểm)</label>
                                <input name="pointsRequired"
                                       id="pointsRequired"
                                       type="number"
                                       min="1"
                                       value="${not empty campaign.pointsRequired ? campaign.pointsRequired : 100}"
                                       placeholder="Ví dụ: 100 điểm"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="pointsRequiredError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                            </div>

                            <div id="usageLimitGroup" style="flex: 1; min-width: 200px;">
                                <label>Giới Hạn Số Lượt Sử Dụng (Toàn Hệ Thống)</label>
                                <input name="usageLimit"
                                       id="usageLimit"
                                       type="number"
                                       min="0"
                                       value="${campaign.usageLimit}"
                                       placeholder="Ví dụ: 1000 lượt (Bỏ trống nếu không giới hạn)"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="usageLimitError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                            </div>

                            <div id="userUsageLimitGroup" style="flex: 1; min-width: 200px; display: none;">
                                <label>Giới Hạn Số Lượt Sử Dụng / Khách Hàng</label>
                                <input name="userUsageLimit"
                                       id="userUsageLimit"
                                       type="number"
                                       min="0"
                                       value="${campaign.userUsageLimit}"
                                       placeholder="Ví dụ: 1 lượt"
                                       style="width: 100%; box-sizing: border-box;">
                                <span class="validation-error" id="userUsageLimitError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
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
                            <h3>🔎 Danh Sách Sản Phẩm Áp Dụng</h3>
                            <small>Chọn trực tiếp sản phẩm/biến thể trong kho hàng.</small>
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
                            <div style="display: flex; gap: 8px;">
                                <button type="button" class="btn primary" id="btnApplySalesFilter" style="height: 40px; min-height: unset; padding: 8px 16px; font-size: 13px; font-weight: bold; border-radius: 6px;">
                                    Lọc
                                </button>
                                <button type="button" class="btn ghost" id="btnSelectAllProducts" style="height: 40px; min-height: unset; padding: 8px 16px; font-size: 13px; font-weight: bold; border-radius: 6px; border: 1px solid var(--line); color: var(--blue); background: #ffffff;">
                                    ☑ Chọn Tất Cả
                                </button>
                            </div>
                        </div>

                        <div class="product-list" id="productList">
                            <c:forEach var="p" items="${products}">
                                <c:set var="searchText" value="${p.productName} ${p.variantName} ${p.sku} ${p.categoryName}" />
                                <label class="product-option" data-search="<c:out value="${searchText.toLowerCase()}"/>">
                                    <input type="checkbox"
                                           class="picker-checkbox"
                                           data-id="${p.variantId}"
                                           data-name="<c:out value="${p.productName}"/>"
                                           data-variant="<c:out value="${p.variantName}"/>"
                                           data-sku="<c:out value="${p.sku}"/>"
                                           data-category="<c:out value="${p.categoryName}"/>"
                                           data-price="${p.price}"
                                           data-stock="${p.stock}"
                                           data-gift="${p.gift}"
                                           ${p.selected ? 'checked' : ''}>

                                    <span>
                                        <b><c:out value="${p.productName}"/></b>
                                        <small>
                                            <c:out value="${p.variantName}"/>
                                            · <c:out value="${p.sku}"/>
                                            · <c:out value="${p.categoryName}"/>
                                        </small>
                                    </span>

                                    <em>
                                        <fmt:formatNumber value="${p.price}" pattern="#,##0"/>₫
                                        <br>
                                        <small>Stock: ${p.stock}</small>
                                    </em>
                                </label>
                            </c:forEach>
                        </div>
                    </section>

                </div>

                <aside class="right-stack">

                    <section class="form-card side-card">
                        <h3>⏰ Thời Gian Hoạt Động</h3>

                        <label>Thời Gian Bắt Đầu</label>
                        <input name="startDate"
                               id="startDate"
                               type="datetime-local"
                               required
                               value="${campaign.formattedStartDate}">

                        <label>Thời Gian Kết Thúc</label>
                        <input name="endDate"
                               id="endDate"
                               type="datetime-local"
                               required
                               value="${campaign.formattedEndDate}">

                        <div class="info-box">
                            ⓘ Chiến dịch này sẽ tự động kích hoạt vào thời gian bắt đầu đã cài đặt.
                        </div>
                    </section>

                    <section class="form-card side-card">
                        <h3>⚙️ Điều Kiện Khuyến Mãi</h3>

                        <div id="minOrderValueGroup">
                            <label>Giá Trị Đơn Hàng Tối Thiểu (VNĐ)</label>
                            <input name="minOrderValue"
                                   id="minOrderValue"
                                   type="number"
                                   step="1"
                                   min="0"
                                   value="${campaign.minOrderValue}"
                                   placeholder="Ví dụ: 500.000₫">
                            <span class="validation-error" id="minOrderValueError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></span>
                        </div>

                        <label>Trạng Thái Chiến Dịch</label>
                        <select name="status">
                            <option value="scheduled" ${campaign.status == 'scheduled' ? 'selected' : ''}>
                                Đã Lên Lịch (Scheduled)
                            </option>
                            <option value="active" ${campaign.status == 'active' ? 'selected' : ''}>
                                Đang Hoạt Động (Active)
                            </option>
                            <option value="paused" ${campaign.status == 'paused' ? 'selected' : ''}>
                                Tạm Dừng (Paused)
                            </option>
                            <option value="pending_approval" ${campaign.status == 'pending_approval' ? 'selected' : ''}>
                                Chờ Duyệt (Pending Approval)
                            </option>
                            <option value="stopped" ${campaign.status == 'stopped' ? 'selected' : ''}>
                                Đã Kết Thúc (Stopped)
                            </option>
                        </select>
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
            startDateInput.setAttribute("min", todayStr + "T00:00");
            startDateInput.setAttribute("max", maxDateStr + "T23:59");
            endDateInput.setAttribute("min", todayStr + "T00:00");
            endDateInput.setAttribute("max", maxDateStr + "T23:59");

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
            var campaignId = "${campaign.campaignId}";
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "${pageContext.request.contextPath}/admin/campaign-form?action=check-name&name=" + encodeURIComponent(name) + "&id=" + campaignId, true);
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

        function parseInputDate(valStr) {
            if (!valStr) return null;
            valStr = valStr.trim();
            if (valStr.includes("/")) {
                var parts = valStr.split(" ");
                var dateParts = parts[0].split("/");
                if (dateParts.length === 3) {
                    var day = parseInt(dateParts[0], 10);
                    var month = parseInt(dateParts[1], 10) - 1;
                    var year = parseInt(dateParts[2], 10);
                    var hours = 0, mins = 0;
                    if (parts.length > 1 && parts[1].includes(":")) {
                        var timeParts = parts[1].split(":");
                        hours = parseInt(timeParts[0], 10) || 0;
                        mins = parseInt(timeParts[1], 10) || 0;
                    }
                    return new Date(year, month, day, hours, mins);
                }
            }
            return new Date(valStr);
        }

        var form = document.getElementById("campaignForm");
        if (form) {
            form.addEventListener("submit", function(e) {
                var isValid = true;
                var errorMsg = "";

                // 1. Campaign Name validation
                var name = campaignNameInput ? campaignNameInput.value.trim() : "";
                if (!name) {
                    campaignNameError.textContent = "Tên chiến dịch không được để trống!";
                    campaignNameError.style.display = "block";
                    campaignNameInput.classList.add("input-error");
                    isValid = false;
                    if (!errorMsg) errorMsg = "Vui lòng nhập Tên Chiến Dịch Khuyến Mãi!";
                } else if (campaignNameError && campaignNameError.style.display === "block" && campaignNameError.textContent.includes("đã được sử dụng")) {
                    isValid = false;
                    if (!errorMsg) errorMsg = campaignNameError.textContent;
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
                            if (!errorMsg) errorMsg = "Vui lòng nhập Mã Giảm Giá (Promo Code)!";
                        } else if (code.length < 3 || code.length > 20) {
                            promoCodeError.textContent = "Mã khuyến mãi phải từ 3 đến 20 ký tự!";
                            promoCodeError.style.display = "block";
                            promoCodeInput.classList.add("input-error");
                            isValid = false;
                            if (!errorMsg) errorMsg = "Mã khuyến mãi phải từ 3 đến 20 ký tự!";
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
                    if (type === "percentage" || type === "fixed" || type === "flash") {
                        if (isNaN(discVal) || discountValueInput.value.trim() === "") {
                            discountValueError.textContent = "Mức giảm giá không được để trống!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                            if (!errorMsg) errorMsg = "Vui lòng nhập Mức Giảm Giá (ví dụ: 10% hoặc 50,000đ)!";
                        } else if (discVal < 0) {
                            discountValueError.textContent = "Giá trị giảm giá không được nhập số âm!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                            if (!errorMsg) errorMsg = "Giá trị giảm giá không được nhập số âm!";
                        } else if ((type === "percentage" || type === "flash") && discVal > 99) {
                            discountValueError.textContent = "Đối với phần trăm (%), giá trị giảm giá chỉ được nhập tối đa là 99%!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                            if (!errorMsg) errorMsg = "Đối với phần trăm (%), giá trị giảm giá chỉ được nhập tối đa là 99%!";
                        } else if (type === "fixed" && discVal > 10000000) {
                            discountValueError.textContent = "Đối với tiền mặt (VND), giá trị giảm giá chỉ được nhập tối đa là 10,000,000 VND!";
                            discountValueError.style.display = "block";
                            discountValueInput.classList.add("input-error");
                            isValid = false;
                            if (!errorMsg) errorMsg = "Đối với tiền mặt (VND), giá trị giảm giá chỉ được nhập tối đa là 10,000,000 VND!";
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
                        if (!errorMsg) errorMsg = "Giá trị đơn hàng tối thiểu không được nhập số âm!";
                    }
                }

                // 5. Usage Limit and User Usage Limit validation
                var usageLimitInput = document.getElementById("usageLimit");
                var usageLimitError = document.getElementById("usageLimitError");
                var userUsageLimitInput = document.getElementById("userUsageLimit");
                var userUsageLimitError = document.getElementById("userUsageLimitError");
                var typeSelect = document.getElementById("campaignType");

                if (usageLimitInput && usageLimitError) {
                    usageLimitError.style.display = "none";
                    usageLimitInput.classList.remove("input-error");

                    var limitVal = parseFloat(usageLimitInput.value);
                    if (!isNaN(limitVal) && limitVal < 0) {
                        usageLimitError.textContent = "Giới hạn sử dụng không được nhập số âm!";
                        usageLimitError.style.display = "block";
                        usageLimitInput.classList.add("input-error");
                        isValid = false;
                        if (!errorMsg) errorMsg = "Giới hạn sử dụng không được nhập số âm!";
                    }
                }

                if (userUsageLimitInput && userUsageLimitError) {
                    userUsageLimitError.style.display = "none";
                    userUsageLimitError.classList.remove("input-error");

                    var userLimitVal = parseFloat(userUsageLimitInput.value);
                    if (!isNaN(userLimitVal) && userLimitVal < 0) {
                        userUsageLimitError.textContent = "Giới hạn sử dụng mỗi user không được nhập số âm!";
                        userUsageLimitError.style.display = "block";
                        userUsageLimitInput.classList.add("input-error");
                        isValid = false;
                        if (!errorMsg) errorMsg = "Giới hạn sử dụng mỗi user không được nhập số âm!";
                    }
                }

                if (typeSelect && typeSelect.value === "percentage") {
                    var hasUsageLimit = usageLimitInput && usageLimitInput.value && usageLimitInput.value.trim() !== "";
                    var hasUserUsageLimit = userUsageLimitInput && userUsageLimitInput.value && userUsageLimitInput.value.trim() !== "";
                    if (hasUsageLimit && hasUserUsageLimit) {
                        usageLimitError.textContent = "Chỉ được nhập 1 trong 2 ô: Giới hạn toàn bộ HOẶC Giới hạn mỗi User!";
                        usageLimitError.style.display = "block";
                        usageLimitInput.classList.add("input-error");

                        userUsageLimitError.textContent = "Chỉ được nhập 1 trong 2 ô: Giới hạn toàn bộ HOẶC Giới hạn mỗi User!";
                        userUsageLimitError.style.display = "block";
                        userUsageLimitInput.classList.add("input-error");
                        isValid = false;
                        if (!errorMsg) errorMsg = "Chỉ được nhập 1 trong 2 ô: Giới hạn toàn bộ HOẶC Giới hạn mỗi User!";
                    }
                }

                // 6. Dates validation
                if (!startDateInput || !startDateInput.value) {
                    isValid = false;
                    if (!errorMsg) errorMsg = "Vui lòng chọn Thời Gian Bắt Đầu!";
                } else if (!endDateInput || !endDateInput.value) {
                    isValid = false;
                    if (!errorMsg) errorMsg = "Vui lòng chọn Thời Gian Kết Thúc!";
                } else {
                    var startDateObj = parseInputDate(startDateInput.value);
                    var endDateObj = parseInputDate(endDateInput.value);

                    var todayObj = new Date();
                    todayObj.setMinutes(todayObj.getMinutes() - 10);

                    var maxDateObj = new Date();
                    maxDateObj.setMonth(maxDateObj.getMonth() + 6);

                    if (startDateObj) {
                        var startDateZero = new Date(startDateObj.getFullYear(), startDateObj.getMonth(), startDateObj.getDate());
                        var todayZero = new Date(todayObj.getFullYear(), todayObj.getMonth(), todayObj.getDate());
                        if (startDateZero < todayZero) {
                            isValid = false;
                            if (!errorMsg) errorMsg = "Ngày bắt đầu chiến dịch phải từ ngày hôm nay trở đi!";
                        }
                    }

                    if (isValid && endDateObj && endDateObj.getTime() > maxDateObj.getTime()) {
                        isValid = false;
                        if (!errorMsg) errorMsg = "Thời gian kết thúc không được vượt quá 6 tháng kể từ hôm nay!";
                    }

                    if (isValid && startDateObj && endDateObj && startDateObj.getTime() > endDateObj.getTime()) {
                        isValid = false;
                        if (!errorMsg) errorMsg = "Thời gian kết thúc phải lớn hơn hoặc bằng thời gian bắt đầu!";
                    }
                }

                if (!isValid) {
                    e.preventDefault();
                    if (errorMsg) {
                        alert(errorMsg);
                    }
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

    var isAllSelectedMode = false;

    // Function to render selected products rows & create hidden inputs for form submission
    function updateSelectedList() {
        var container = document.getElementById("selectedProductsList");
        var countSpan = document.getElementById("selectedCount");
        
        container.innerHTML = "";
        
        var keys = Object.keys(selectedProductsMap);
        var totalAvailable = document.querySelectorAll('.picker-checkbox').length;
        
        var isAllSelected = (totalAvailable > 0 && keys.length === totalAvailable) || isAllSelectedMode;

        if (keys.length === 0) {
            countSpan.textContent = "0";
            container.innerHTML = '<div style="color: var(--muted); font-style: italic; padding: 10px 0;">Chưa có sản phẩm nào được chọn. Hãy chọn sản phẩm ở danh sách dưới.</div>';
            return;
        }
        
        if (isAllSelected) {
            countSpan.textContent = "Tất cả (" + keys.length + ")";
            
            var hiddenInputsHtml = "";
            keys.forEach(function(key) {
                var p = selectedProductsMap[key];
                hiddenInputsHtml += '<input type="hidden" name="variantIds" value="' + p.variantId + '">';
            });
            
            container.innerHTML = 
                '<div class="selected-product-row" style="background: #eff6ff; border: 1px solid #bfdbfe; padding: 12px 16px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center;">' +
                '    <div style="display: flex; align-items: center; gap: 10px;">' +
                '        <span style="font-size: 18px;">✨</span>' +
                '        <div>' +
                '            <strong style="color: #1d4ed8; font-size: 14px;">Đã chọn tất cả sản phẩm</strong>' +
                '            <span style="color: #64748b; font-size: 12.5px; margin-left: 8px;">(Áp dụng toàn bộ ' + keys.length + ' sản phẩm trong hệ thống)</span>' +
                '        </div>' +
                '    </div>' +
                '    <button type="button" class="btn-remove" id="btnDeselectAll" style="color: #ef4444; font-size: 22px; border: none; background: none; cursor: pointer; line-height: 1;" title="Bỏ chọn tất cả">&times;</button>' +
                '    ' + hiddenInputsHtml +
                '</div>';
                
            var deselectBtn = document.getElementById("btnDeselectAll");
            if (deselectBtn) {
                deselectBtn.onclick = function() {
                    selectedProductsMap = {};
                    isAllSelectedMode = false;
                    document.querySelectorAll('.picker-checkbox').forEach(function(cb) {
                        cb.checked = false;
                    });
                    updateSelectedList();
                };
            }
            return;
        }
        
        countSpan.textContent = keys.length;
        
        keys.forEach(function(key) {
            var p = selectedProductsMap[key];
            
            var row = document.createElement("div");
            row.className = "selected-product-row";
            
            row.innerHTML = 
                '<div>' +
                '    <strong style="color: var(--blue);">' + escapeHtml(p.productName) + '</strong>' +
                '    <span style="color: var(--muted); margin-left: 8px;">' +
                '        ' + escapeHtml(p.variantName) + ' · ' + escapeHtml(p.sku) + ' · ' + escapeHtml(p.categoryName) +
                '    </span>' +
                '    <input type="hidden" name="variantIds" value="' + p.variantId + '">' +
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
                isAllSelectedMode = false;
                
                // Uncheck corresponding checkbox in picker if visible
                var cb = document.querySelector('.picker-checkbox[data-id="' + id + '"]');
                if (cb) {
                    cb.checked = false;
                }
                
                updateSelectedList();
            };
        });
    }

    // Bind event to "Chọn Tất Cả" button
    var btnSelectAllProducts = document.getElementById("btnSelectAllProducts");
    if (btnSelectAllProducts) {
        btnSelectAllProducts.onclick = function() {
            var checkboxes = document.querySelectorAll('.picker-checkbox');
            var allChecked = true;
            checkboxes.forEach(function(cb) {
                if (!cb.checked) allChecked = false;
            });
            
            var targetState = !allChecked;
            isAllSelectedMode = targetState;
            
            checkboxes.forEach(function(cb) {
                cb.checked = targetState;
                var id = cb.getAttribute('data-id');
                if (targetState) {
                    selectedProductsMap[id] = {
                        variantId: id,
                        productName: cb.getAttribute('data-name'),
                        variantName: cb.getAttribute('data-variant'),
                        sku: cb.getAttribute('data-sku'),
                        categoryName: cb.getAttribute('data-category'),
                        price: cb.getAttribute('data-price'),
                        stock: cb.getAttribute('data-stock')
                    };
                } else {
                    delete selectedProductsMap[id];
                }
            });
            updateSelectedList();
        };
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
                    isAllSelectedMode = false;
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
        var campaignId = "${campaign.campaignId}";

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

        var url = "${pageContext.request.contextPath}/admin/campaign-form?action=products" +
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
            xhr.open("GET", "${pageContext.request.contextPath}/admin/campaign-form?action=generate", true);
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
        var pointsRequiredGroup = document.getElementById("pointsRequiredGroup");
        var usageLimitGroup = document.getElementById("usageLimitGroup");
        var userUsageLimitGroup = document.getElementById("userUsageLimitGroup");
        var minOrderValueGroup = document.getElementById("minOrderValueGroup");
        var promoCodeInput = document.getElementById("promoCode");
        var discountValueInput = document.getElementById("discountValue");
        
        if (!campTypeSelect) return;
        
        var val = campTypeSelect.value;
        
        // Dynamic limits setup
        if (discountValueInput) {
            if (val === "percentage" || val === "flash") {
                discountValueInput.setAttribute("max", "99");
                discountValueInput.setAttribute("placeholder", "Ví dụ: 10 (%)");
            } else {
                discountValueInput.setAttribute("max", "10000000");
                discountValueInput.setAttribute("placeholder", "Ví dụ: 200.000 (VNĐ)");
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

        if (pointsRequiredGroup) {
            pointsRequiredGroup.style.display = (val === "reward_points") ? "block" : "none";
        }
        
        if (val === "percentage" || val === "fixed" || val === "reward_points") {
            // Show Voucher Configuration and Minimum Order Value Condition
            if (voucherConfigCard) voucherConfigCard.style.display = "block";
            if (promoCodeGroup) promoCodeGroup.style.display = "block";
            if (discountValueGroup) discountValueGroup.style.display = "block";
            if (usageLimitGroup) usageLimitGroup.style.display = "block";
            if (minOrderValueGroup) minOrderValueGroup.style.display = "block";
            
            if (val === "percentage") {
                if (userUsageLimitGroup) userUsageLimitGroup.style.display = "block";
            } else {
                if (userUsageLimitGroup) userUsageLimitGroup.style.display = "none";
            }

            if (promoCodeInput) {
                promoCodeInput.setAttribute("required", "required");
                if (val === "reward_points") {
                    promoCodeInput.setAttribute("placeholder", "Ví dụ: RW200K_32_7516");
                } else {
                    promoCodeInput.setAttribute("placeholder", "Ví dụ: SUMMER2026");
                }
                if (promoCodeInput.value.startsWith("AUTO-")) {
                    promoCodeInput.value = "";
                }
            }
        } else if (val === "flash") {
            // Only show discount value, hide promo code and usage limit
            if (voucherConfigCard) voucherConfigCard.style.display = "block";
            if (promoCodeGroup) promoCodeGroup.style.display = "none";
            if (discountValueGroup) discountValueGroup.style.display = "block";
            if (usageLimitGroup) usageLimitGroup.style.display = "none";
            if (userUsageLimitGroup) userUsageLimitGroup.style.display = "none";
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
            if (userUsageLimitGroup) userUsageLimitGroup.style.display = "none";
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

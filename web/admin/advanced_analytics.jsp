<%-- 
    Page: advanced_analytics.jsp
    Mo ta: Trang giao diện phân tích báo cáo nâng cao tích hợp biểu đồ Chart.js.
    
    Created: 2026-07-09
    Updated: 2026-07-21
    Version: v1.0
    
    @author DuyLD
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNILAP Admin — Advanced Business Analytics</title>
        <!-- Chart.js CDN -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
            
            *, *::before, *::after {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, Arial, sans-serif;
            }
            
            :root {
                --primary: #2563eb;
                --primary-hover: #1d4ed8;
                --primary-light: #eff6ff;
                --success: #10b981;
                --danger: #ef4444;
                --warning: #f59e0b;
                --dark: #0f172a;
                --gray-light: #f8fafc;
                --gray-border: #cbd5e1;
                --text-muted: #64748b;
                --sidebar-bg: #eef2f7;
            }

            body {
                background: #f1f5f9;
                color: #1e293b;
                min-height: 100vh;
            }

            .layout {
                display: flex;
                min-height: 100vh;
            }

            /* ══ SIDEBAR CSS: provided by sidebar.jsp Master CSS ══ */


            /* ══ MAIN AREA ══ */
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
                min-width: 0;
            }
            .topbar {
                background: #fff;
                border-bottom: 1px solid #e2e8f0;
                padding: 16px 28px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            .topbar-title {
                font-size: 18px;
                font-weight: 700;
                color: var(--dark);
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                background: #dcfce7;
                color: #166534;
            }
            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #16a34a;
            }

            /* ══ CONTENT & TABS ══ */
            .content {
                padding: 28px;
                overflow-y: auto;
                flex: 1;
            }
            .page-header {
                margin-bottom: 24px;
            }
            .page-title {
                font-size: 24px;
                font-weight: 800;
                color: var(--dark);
            }
            .page-sub {
                font-size: 14px;
                color: var(--text-muted);
                margin-top: 4px;
            }

            /* TAB CONTROLLER */
            .tab-nav {
                display: flex;
                gap: 8px;
                border-bottom: 1px solid var(--gray-border);
                margin-bottom: 24px;
                background: #fff;
                padding: 6px 12px 0;
                border-radius: 12px 12px 0 0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            }
            .tab-btn {
                padding: 12px 20px;
                background: none;
                border: none;
                border-bottom: 3px solid transparent;
                font-size: 14px;
                font-weight: 600;
                color: var(--text-muted);
                cursor: pointer;
                transition: all 0.2s;
            }
            .tab-btn:hover {
                color: var(--dark);
            }
            .tab-btn.active {
                color: var(--primary);
                border-bottom-color: var(--primary);
            }
            .tab-pane {
                display: none;
            }
            .tab-pane.active {
                display: block;
            }

            /* FILTER PANELS */
            .filter-panel {
                background: #fff;
                border-radius: 12px;
                padding: 20px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                margin-bottom: 24px;
            }
            .filter-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 16px;
                align-items: flex-end;
            }
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .filter-group label {
                font-size: 12px;
                font-weight: 700;
                color: #475569;
                text-transform: uppercase;
                letter-spacing: 0.02em;
            }
            .filter-input {
                padding: 8px 12px;
                border: 1px solid var(--gray-border);
                border-radius: 8px;
                font-size: 13px;
                outline: none;
                background: #fff;
                color: #1e293b;
                transition: border-color 0.15s;
                width: 100%;
            }
            .filter-input:focus {
                border-color: var(--primary);
            }
            .filter-actions {
                display: flex;
                gap: 8px;
            }
            .btn {
                padding: 9px 16px;
                font-size: 13px;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.2s;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .btn-primary {
                background: var(--primary);
                color: #fff;
            }
            .btn-primary:hover {
                background: var(--primary-hover);
            }
            .btn-secondary {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid var(--gray-border);
            }
            .btn-secondary:hover {
                background: #e2e8f0;
            }

            /* KPI BOXES */
            .kpi-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
                margin-bottom: 24px;
            }
            .kpi-box {
                background: #fff;
                border-radius: 12px;
                padding: 24px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                display: flex;
                flex-direction: column;
                gap: 8px;
                position: relative;
            }
            .kpi-box.accent-blue { border-left: 4px solid var(--primary); }
            .kpi-box.accent-green { border-left: 4px solid var(--success); }
            .kpi-box.accent-amber { border-left: 4px solid var(--warning); }
            
            .kpi-box-label {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .kpi-box-val {
                font-size: 28px;
                font-weight: 800;
                color: var(--dark);
                line-height: 1.2;
            }
            .kpi-box-sub {
                font-size: 12px;
                color: var(--text-muted);
            }

            /* CHARTS GRID */
            .charts-grid-2 {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 24px;
                margin-bottom: 24px;
            }
            @media (max-width: 1024px) {
                .charts-grid-2 {
                    grid-template-columns: 1fr;
                }
            }
            .chart-card {
                background: #fff;
                border-radius: 12px;
                padding: 24px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }
            .chart-card-hd {
                font-size: 16px;
                font-weight: 700;
                color: var(--dark);
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .chart-container {
                position: relative;
                width: 100%;
                min-height: 260px;
            }

            /* TABLES */
            .table-card {
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                overflow: hidden;
                margin-bottom: 24px;
            }
            .table-card-hd {
                padding: 20px 24px;
                background: #fff;
                border-bottom: 1px solid #e2e8f0;
                font-size: 16px;
                font-weight: 700;
                color: var(--dark);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }
            th {
                padding: 14px 24px;
                background: var(--gray-light);
                font-size: 12px;
                font-weight: 700;
                color: #475569;
                text-transform: uppercase;
                border-bottom: 1px solid #e2e8f0;
            }
            td {
                padding: 16px 24px;
                font-size: 14px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #f8fafc;
            }
            .rank-number {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                background: #f1f5f9;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 700;
                color: #475569;
            }
            tr:nth-child(1) .rank-number { background: #fef3c7; color: #d97706; }
            tr:nth-child(2) .rank-number { background: #e2e8f0; color: #475569; }
            tr:nth-child(3) .rank-number { background: #ffedd5; color: #ea580c; }

            .no-data {
                padding: 40px;
                text-align: center;
                color: var(--text-muted);
                font-size: 14px;
                font-weight: 500;
            }

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

            <!-- ══════════ SIDEBAR ══════════ -->
            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="activePage" value="analytics"/>
            </jsp:include>

            <!-- ══════════ MAIN ══════════ -->
            <div class="main">
                
                <!-- Topbar -->
                <header class="topbar">
                    <div class="topbar-title">Advanced Business Analytics</div>
                    <div class="topbar-right">
                        <span class="status-pill"><span class="status-dot"></span>System Online</span>
                    </div>
                </header>

                <div class="content">
                    <div class="page-header">
                        <h1 class="page-title">Báo cáo hiệu suất kinh doanh chi tiết</h1>
                        <p class="page-sub">Phân tích toàn diện về doanh thu, bán hàng, khách hàng và chỉ số sản phẩm.</p>
                    </div>

                    <!-- ══ TAB NAV CONTROLLER ══ -->
                    <div class="tab-nav">
                        <button class="tab-btn" onclick="switchTab('revenue')">💰 Phân tích doanh thu</button>
                        <button class="tab-btn" onclick="switchTab('sales')">🛒 Phân tích bán hàng</button>
                        <button class="tab-btn" onclick="switchTab('customer')">👤 Phân tích khách hàng</button>
                        <button class="tab-btn" onclick="switchTab('product')">📦 Sản phẩm &amp; Tồn kho</button>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 1: REVENUE ANALYSIS ══ -->
                    <div id="revenue-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="revenue">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>Từ ngày</label>
                                        <input type="date" name="revenueFrom" value="${revFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Đến ngày</label>
                                        <input type="date" name="revenueTo" value="${revFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Danh mục</label>
                                        <select name="revenueCategoryId" class="filter-input">
                                            <option value="all">-- Tất cả danh mục --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${revFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Thương hiệu</label>
                                        <select name="revenueBrandId" class="filter-input">
                                            <option value="all">-- Tất cả thương hiệu --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${revFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Loại khách hàng</label>
                                        <select name="revenueCustomerType" class="filter-input">
                                            <option value="" ${empty revFilter.customerType ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="new" ${revFilter.customerType == 'new' ? 'selected' : ''}>Khách hàng mới</option>
                                            <option value="returning" ${revFilter.customerType == 'returning' ? 'selected' : ''}>Khách hàng quay lại</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Phương thức thanh toán</label>
                                        <select name="revenuePaymentMethod" class="filter-input">
                                            <option value="" ${empty revFilter.paymentMethod ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="cod" ${revFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${revFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Thẻ tín dụng</option>
                                            <option value="momo" ${revFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${revFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Chuyển khoản</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Gom nhóm theo</label>
                                        <select name="revenueGroupBy" class="filter-input">
                                            <option value="day" ${revenueGroupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                                            <option value="month" ${revenueGroupBy == 'month' ? 'selected' : ''}>Theo tháng</option>
                                            <option value="quarter" ${revenueGroupBy == 'quarter' ? 'selected' : ''}>Theo quý</option>
                                            <option value="year" ${revenueGroupBy == 'year' ? 'selected' : ''}>Theo năm</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=revenue" class="btn btn-secondary">Đặt lại</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Tổng doanh thu (Đã lọc)</span>
                                <span class="kpi-box-val">
                                    <c:set var="totRev" value="0"/>
                                    <c:forEach items="${revenueTrend}" var="entry">
                                        <c:set var="totRev" value="${totRev + entry.value}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totRev}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Tổng doanh thu thực tế trong khoảng thời gian</span>
                            </div>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Xu hướng doanh thu</div>
                                <div class="chart-container">
                                    <canvas id="revenueTrendChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">📊 Cơ cấu doanh thu theo danh mục</div>
                                <div class="chart-container">
                                    <canvas id="revenueCategoryChart"></canvas>
                                </div>
                            </div>
                        </div>
                        
                        <div class="chart-card" style="margin-bottom:24px;">
                            <div class="chart-card-hd">📊 Cơ cấu doanh thu theo thương hiệu</div>
                            <div class="chart-container" style="min-height:220px;">
                                <canvas id="revenueBrandChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 2: SALES ANALYSIS ══ -->
                    <div id="sales-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="sales">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>Từ ngày</label>
                                        <input type="date" name="salesFrom" value="${salesFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Đến ngày</label>
                                        <input type="date" name="salesTo" value="${salesFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Danh mục</label>
                                        <select name="salesCategoryId" class="filter-input">
                                            <option value="all">-- Tất cả danh mục --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${salesFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Thương hiệu</label>
                                        <select name="salesBrandId" class="filter-input">
                                            <option value="all">-- Tất cả thương hiệu --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${salesFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Loại khách hàng</label>
                                        <select name="salesCustomerType" class="filter-input">
                                            <option value="" ${empty salesFilter.customerType ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="new" ${salesFilter.customerType == 'new' ? 'selected' : ''}>Khách hàng mới</option>
                                            <option value="returning" ${salesFilter.customerType == 'returning' ? 'selected' : ''}>Khách hàng quay lại</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Phương thức thanh toán</label>
                                        <select name="salesPaymentMethod" class="filter-input">
                                            <option value="" ${empty salesFilter.paymentMethod ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="cod" ${salesFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${salesFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Thẻ tín dụng</option>
                                            <option value="momo" ${salesFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${salesFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Chuyển khoản</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Gom nhóm theo</label>
                                        <select name="salesGroupBy" class="filter-input">
                                            <option value="day" ${salesGroupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                                            <option value="month" ${salesGroupBy == 'month' ? 'selected' : ''}>Theo tháng</option>
                                            <option value="quarter" ${salesGroupBy == 'quarter' ? 'selected' : ''}>Theo quý</option>
                                            <option value="year" ${salesGroupBy == 'year' ? 'selected' : ''}>Theo năm</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=sales" class="btn btn-secondary">Đặt lại</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-green">
                                <span class="kpi-box-label">Tổng số đơn hàng</span>
                                <span class="kpi-box-val">
                                    <c:set var="totOrders" value="0"/>
                                    <c:forEach items="${ordersTrend}" var="entry">
                                        <c:set var="totOrders" value="${totOrders + entry.value}"/>
                                    </c:forEach>
                                    ${totOrders}
                                </span>
                                <span class="kpi-box-sub">Số lượng đơn hàng (trạng thái hợp lệ)</span>
                            </div>
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Giá trị đơn hàng trung bình (AOV)</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${avgOrderValue}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Giá trị trung bình mỗi giao dịch</span>
                            </div>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Xu hướng số lượng đơn hàng</div>
                                <div class="chart-container">
                                    <canvas id="ordersTrendChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">💳 Tỷ lệ theo phương thức thanh toán</div>
                                <div class="chart-container">
                                    <canvas id="paymentMethodChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 3: CUSTOMER ANALYTICS ══ -->
                    <div id="customer-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="customer">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>Từ ngày</label>
                                        <input type="date" name="customerFrom" value="${custFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Đến ngày</label>
                                        <input type="date" name="customerTo" value="${custFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Danh mục</label>
                                        <select name="customerCategoryId" class="filter-input">
                                            <option value="all">-- Tất cả danh mục --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${custFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Thương hiệu</label>
                                        <select name="customerBrandId" class="filter-input">
                                            <option value="all">-- Tất cả thương hiệu --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${custFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Phương thức thanh toán</label>
                                        <select name="customerPaymentMethod" class="filter-input">
                                            <option value="" ${empty custFilter.paymentMethod ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="cod" ${custFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${custFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Thẻ tín dụng</option>
                                            <option value="momo" ${custFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${custFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Chuyển khoản</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Gom nhóm theo</label>
                                        <select name="customerGroupBy" class="filter-input">
                                            <option value="day" ${customerGroupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                                            <option value="month" ${customerGroupBy == 'month' ? 'selected' : ''}>Theo tháng</option>
                                            <option value="quarter" ${customerGroupBy == 'quarter' ? 'selected' : ''}>Theo quý</option>
                                            <option value="year" ${customerGroupBy == 'year' ? 'selected' : ''}>Theo năm</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Giới hạn top khách hàng (N)</label>
                                        <input type="number" name="customerTopN" value="${customerTopN}" min="1" max="100" class="filter-input">
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=customer" class="btn btn-secondary">Đặt lại</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Charts Grid -->
                        <div class="charts-grid-2">
                            <div class="chart-card">
                                <div class="chart-card-hd">📈 Tăng trưởng lượng khách hàng mới</div>
                                <div class="chart-container">
                                    <canvas id="customerGrowthChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-card">
                                <div class="chart-card-hd">👥 Tỷ lệ khách hàng mới vs khách hàng quay lại</div>
                                <div class="chart-container">
                                    <canvas id="customerCohortChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Top Spending Customers table -->
                        <div class="table-card">
                            <div class="table-card-hd">🏆 Khách hàng chi tiêu nhiều nhất (Xếp hạng theo tổng doanh thu)</div>
                            <c:choose>
                                <c:when test="${not empty topSpendingCustomers}">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th style="width:80px;">Xếp hạng</th>
                                                <th>Khách hàng</th>
                                                <th>Địa chỉ Email</th>
                                                <th>Số đơn hàng</th>
                                                <th>Tổng chi tiêu</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${topSpendingCustomers}" var="c" varStatus="st">
                                                <tr>
                                                    <td><span class="rank-number">${st.index + 1}</span></td>
                                                    <td style="font-weight:600;">${c[0]}</td>
                                                    <td>${c[1]}</td>
                                                    <td>${c[3]} đơn hàng</td>
                                                    <td style="font-weight:700; color:var(--primary);">
                                                        <fmt:formatNumber value="${c[2]}" pattern="#,##0"/> ₫
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">Không tìm thấy thông tin chi tiêu của khách hàng.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- ════════════════════════════════════════════════════════════════════ -->
                    <!-- ══ TAB 4: PRODUCT & INVENTORY ══ -->
                    <div id="product-pane" class="tab-pane">
                        
                        <!-- Filters Form -->
                        <div class="filter-panel">
                            <form method="get" action="${pageContext.request.contextPath}/admin/analytics">
                                <input type="hidden" name="section" value="product">
                                <div class="filter-grid">
                                    <div class="filter-group">
                                        <label>Từ ngày</label>
                                        <input type="date" name="productFrom" value="${prodFilter.fromDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Đến ngày</label>
                                        <input type="date" name="productTo" value="${prodFilter.toDate}" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Danh mục</label>
                                        <select name="productCategoryId" class="filter-input">
                                            <option value="all">-- Tất cả danh mục --</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${prodFilter.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Thương hiệu</label>
                                        <select name="productBrandId" class="filter-input">
                                            <option value="all">-- Tất cả thương hiệu --</option>
                                            <c:forEach items="${brands}" var="b">
                                                <option value="${b.brandId}" ${prodFilter.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Loại khách hàng</label>
                                        <select name="productCustomerType" class="filter-input">
                                            <option value="" ${empty prodFilter.customerType ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="new" ${prodFilter.customerType == 'new' ? 'selected' : ''}>Khách hàng mới</option>
                                            <option value="returning" ${prodFilter.customerType == 'returning' ? 'selected' : ''}>Khách hàng quay lại</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Phương thức thanh toán</label>
                                        <select name="productPaymentMethod" class="filter-input">
                                            <option value="" ${empty prodFilter.paymentMethod ? 'selected' : ''}>-- Tất cả --</option>
                                            <option value="cod" ${prodFilter.paymentMethod == 'cod' ? 'selected' : ''}>COD</option>
                                            <option value="credit_card" ${prodFilter.paymentMethod == 'credit_card' ? 'selected' : ''}>Thẻ tín dụng</option>
                                            <option value="momo" ${prodFilter.paymentMethod == 'momo' ? 'selected' : ''}>MoMo</option>
                                            <option value="bank_transfer" ${prodFilter.paymentMethod == 'bank_transfer' ? 'selected' : ''}>Chuyển khoản</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label>Giới hạn top (N)</label>
                                        <input type="number" name="productTopN" value="${productTopN}" min="1" max="100" class="filter-input">
                                    </div>
                                    <div class="filter-group">
                                        <label>Xếp hạng theo</label>
                                        <select name="productSortBy" class="filter-input">
                                            <option value="quantity" ${productSortBy == 'quantity' ? 'selected' : ''}>Số lượng bán</option>
                                            <option value="revenue" ${productSortBy == 'revenue' ? 'selected' : ''}>Doanh thu tạo ra</option>
                                        </select>
                                    </div>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                                        <a href="${pageContext.request.contextPath}/admin/analytics?section=product" class="btn btn-secondary">Đặt lại</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- KPI Boxes: Inventory Turnover -->
                        <div class="kpi-grid">
                            <div class="kpi-box accent-blue">
                                <span class="kpi-box-label">Giá vốn hàng bán (COGS)</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[0]}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Tổng giá nhập nhân số lượng bán</span>
                            </div>
                            <div class="kpi-box accent-amber">
                                <span class="kpi-box-label">Giá trị tồn kho trung bình</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[1]}" pattern="#,##0"/> ₫
                                </span>
                                <span class="kpi-box-sub">Trung bình giá trị tồn kho đầu kỳ và cuối kỳ</span>
                            </div>
                            <div class="kpi-box accent-green">
                                <span class="kpi-box-label">Hệ số vòng quay tồn kho</span>
                                <span class="kpi-box-val">
                                    <fmt:formatNumber value="${inventoryTurnover[2]}" pattern="#,##0.00"/>
                                </span>
                                <span class="kpi-box-sub">COGS chia cho Giá trị tồn kho trung bình</span>
                            </div>
                        </div>

                        <!-- Tables: Best & Sản phẩm bán chậm nhất -->
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:24px;">
                            <div class="table-card">
                                <div class="table-card-hd">🔥 Sản phẩm bán chạy nhất</div>
                                <c:choose>
                                    <c:when test="${not empty bestSellingProducts}">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th style="width:60px;">Xếp hạng</th>
                                                    <th>Sản phẩm / Biến thể</th>
                                                    <th>SL bán</th>
                                                    <th>Doanh thu</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${bestSellingProducts}" var="p" varStatus="st">
                                                    <tr>
                                                        <td><span class="rank-number">${st.index + 1}</span></td>
                                                        <td>
                                                            <div style="font-weight:600;">${p[0]}</div>
                                                            <div style="font-size:12px; color:var(--text-muted);">${p[1]}</div>
                                                        </td>
                                                        <td>${p[2]} sản phẩm</td>
                                                        <td style="font-weight:700; color:var(--success);">
                                                            <fmt:formatNumber value="${p[3]}" pattern="#,##0"/> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">Không tìm thấy chi tiết bán hàng của sản phẩm.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="table-card">
                                <div class="table-card-hd">❄️ Sản phẩm bán chậm nhất</div>
                                <c:choose>
                                    <c:when test="${not empty worstSellingProducts}">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th style="width:60px;">Xếp hạng</th>
                                                    <th>Sản phẩm / Biến thể</th>
                                                    <th>SL bán</th>
                                                    <th>Doanh thu</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${worstSellingProducts}" var="p" varStatus="st">
                                                    <tr>
                                                        <td><span class="rank-number">${st.index + 1}</span></td>
                                                        <td>
                                                            <div style="font-weight:600;">${p[0]}</div>
                                                            <div style="font-size:12px; color:var(--text-muted);">${p[1]}</div>
                                                        </td>
                                                        <td>${p[2]} units</td>
                                                        <td style="font-weight:700; color:var(--danger);">
                                                            <fmt:formatNumber value="${p[3]}" pattern="#,##0"/> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">Không tìm thấy chi tiết bán hàng của sản phẩm.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ════════════════════════════════════════════════════════════════════ -->
        <!-- ══ CHART.JS DRAWING SCRIPTS ══ -->
        <script>
            // Switch tabs dynamically (Vanilla JS)
            function switchTab(tabId) {
                if (!tabId || tabId.trim() === '') {
                    tabId = 'revenue';
                }
                // Clear active buttons
                document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
                // Clear active panes
                document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
                
                // Activate matching button by index mapping or keyword match
                const btnMap = { 'revenue': 0, 'sales': 1, 'customer': 2, 'product': 3 };
                const btns = document.querySelectorAll('.tab-btn');
                if (btnMap[tabId] !== undefined && btns[btnMap[tabId]]) {
                    btns[btnMap[tabId]].classList.add('active');
                } else {
                    const btn = Array.from(btns).find(b => b.innerText.toLowerCase().includes(tabId));
                    if (btn) btn.classList.add('active');
                }
                
                const pane = document.getElementById(tabId + '-pane');
                if (pane) {
                    pane.classList.add('active');
                } else {
                    const defaultPane = document.getElementById('revenue-pane');
                    if (defaultPane) defaultPane.classList.add('active');
                }
            }

            // Toggle sidebar dropdown
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

            // Restore active section tab from servlet response
            window.onload = function() {
                let activeSec = "${activeSection}";
                if (!activeSec || activeSec.trim() === '') {
                    activeSec = 'revenue';
                }
                switchTab(activeSec);
            };

            // ── REVENUE ANALYSIS DATA BINDINGS ──
            const revLabels = [];
            const revData = [];
            <c:forEach items="${revenueTrend}" var="entry">
                revLabels.push("${entry.key}");
                revData.push(${entry.value});
            </c:forEach>

            const catLabels = [];
            const catData = [];
            <c:forEach items="${revenueByCategory}" var="entry">
                catLabels.push("${entry.key}");
                catData.push(${entry.value});
            </c:forEach>

            const brandLabels = [];
            const brandData = [];
            <c:forEach items="${revenueByBrand}" var="entry">
                brandLabels.push("${entry.key}");
                brandData.push(${entry.value});
            </c:forEach>

            // Draw Revenue Line Chart
            new Chart(document.getElementById('revenueTrendChart'), {
                type: 'line',
                data: {
                    labels: revLabels,
                    datasets: [{
                        label: 'Doanh thu thuần (₫)',
                        data: revData,
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37,99,235,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35,
                        pointBackgroundColor: '#1d4ed8',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Category Bar Chart
            new Chart(document.getElementById('revenueCategoryChart'), {
                type: 'bar',
                data: {
                    labels: catLabels,
                    datasets: [{
                        label: 'Revenue (₫)',
                        data: catData,
                        backgroundColor: ['rgba(37, 99, 235, 0.85)', 'rgba(16, 185, 129, 0.85)', 'rgba(245, 158, 11, 0.85)', 'rgba(139, 92, 246, 0.85)', 'rgba(239, 68, 68, 0.85)', 'rgba(6, 182, 212, 0.85)'],
                        borderColor: ['#2563eb', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4'],
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', { notation: 'compact' }).format(value) + ' ₫';
                                }
                            }
                        }
                    }
                }
            });

            // Draw Brand Bar Chart
            new Chart(document.getElementById('revenueBrandChart'), {
                type: 'bar',
                data: {
                    labels: brandLabels,
                    datasets: [{
                        label: 'Revenue (₫)',
                        data: brandData,
                        backgroundColor: 'rgba(37,99,235,0.85)',
                        borderColor: '#2563eb',
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // ── SALES ANALYSIS DATA BINDINGS ──
            const salesLabels = [];
            const salesData = [];
            <c:forEach items="${ordersTrend}" var="entry">
                salesLabels.push("${entry.key}");
                salesData.push(${entry.value});
            </c:forEach>

            const payLabels = [];
            const payData = [];
            <c:forEach items="${salesByPaymentMethod}" var="entry">
                payLabels.push("${entry.key}");
                payData.push(${entry.value});
            </c:forEach>

            // Draw Orders Trend Line
            new Chart(document.getElementById('ordersTrendChart'), {
                type: 'line',
                data: {
                    labels: salesLabels,
                    datasets: [{
                        label: 'Order Volume',
                        data: salesData,
                        borderColor: '#10b981',
                        backgroundColor: 'rgba(16,185,129,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: '#047857',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Payment Method Bar
            new Chart(document.getElementById('paymentMethodChart'), {
                type: 'bar',
                data: {
                    labels: payLabels,
                    datasets: [{
                        label: 'Order Count',
                        data: payData,
                        backgroundColor: ['#6366f1', '#ec4899', '#f59e0b', '#3b82f6'],
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // ── CUSTOMER ANALYSIS DATA BINDINGS ──
            const growthLabels = [];
            const growthData = [];
            <c:forEach items="${customerGrowth}" var="entry">
                growthLabels.push("${entry.key}");
                growthData.push(${entry.value});
            </c:forEach>

            const cohortLabels = [];
            const cohortCounts = [];
            <c:forEach items="${newVsReturningCustomers}" var="entry">
                cohortLabels.push("${entry.key}");
                cohortCounts.push(${entry.value[0]}); // customerCount index 0
            </c:forEach>

            // Draw Customer Growth Line Chart
            new Chart(document.getElementById('customerGrowthChart'), {
                type: 'line',
                data: {
                    labels: growthLabels,
                    datasets: [{
                        label: 'Acquisition Count',
                        data: growthData,
                        borderColor: '#8b5cf6',
                        backgroundColor: 'rgba(139,92,246,0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.35,
                        pointBackgroundColor: '#6d28d9',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // Draw Customer Cohort Share Doughnut
            new Chart(document.getElementById('customerCohortChart'), {
                type: 'doughnut',
                data: {
                    labels: cohortLabels,
                    datasets: [{
                        data: cohortCounts,
                        backgroundColor: ['#3b82f6', '#f43f5e'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        </script>
    </body>
</html>


<%-- 
    Page: StaffDashboard.jsp
    Mo ta: Trang giao diện (View) chính của Bảng điều khiển Nhân viên (Staff Dashboard).
    
    Created: 2026-07-21
    Updated: 2026-07-21
    Version: v1.0
    
    @author DuyLD
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff — Dashboard</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#003ec7",
                        "primary-container": "#0052ff",
                        "surface": "#f7f9fb",
                        "background": "#f7f9fb",
                        "on-surface": "#191c1e",
                        "on-surface-variant": "#434656",
                        "outline-variant": "#c3c5d9"
                    }
                }
            }
        }
    </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Inter, Arial, sans-serif;
        }
        body {
            background: #f0f2f5;
            color: #171a22;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR (Synced with Staff Navigation) */
        .sidebar {
            width: 280px;
            background: #eef2f7;
            border-right: 1px solid #e1e6ef;
            padding: 28px 16px;
            display: flex;
            flex-direction: column;
            position: sticky;
            top: 0;
            height: 100vh;
        }
        .sidebar .brand {
            margin: 6px 10px 44px;
            display: grid;
            gap: 6px;
        }
        .sidebar .brand span {
            color: #0b39d1;
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -.5px;
        }
        .sidebar .brand small {
            color: #6b778c;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .sidebar nav {
            display: grid;
            gap: 6px;
        }
        .sidebar nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 12px;
            color: #44546f;
            font-size: 14px;
            font-weight: 600;
            transition: all .15s ease;
        }
        .sidebar nav a:hover {
            background: #e4e9f2;
            color: #0b39d1;
        }
        .sidebar nav a.active {
            background: #0b39d1;
            color: #fff;
            box-shadow: 0 8px 16px rgba(11, 57, 209, .22);
        }
        .sidebar .profile {
            margin-top: auto;
            padding: 16px 12px;
            border-top: 1px solid #e1e6ef;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .sidebar .profile .logout-btn {
            color: #dc2626;
            font-size: 13px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 6px;
            transition: background .15s ease;
        }
        .sidebar .profile .logout-btn:hover {
            background: #fee2e2;
        }

        /* MAIN CONTENT AREA */
        .main-content {
            flex: 1;
            padding: 32px 40px;
            overflow-y: auto;
        }

        /* HEADER TITLE BAR */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }
        .page-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -.5px;
        }
        .page-header p {
            color: #64748b;
            font-size: 14px;
            margin-top: 2px;
        }

        /* METRICS / STATS CARDS */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }
        .stat-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 18px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }
        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }
        .icon-blue { background: #eff6ff; color: #2563eb; }
        .icon-orange { background: #fff7ed; color: #ea580c; }
        .icon-purple { background: #faf5ff; color: #9333ea; }
        .icon-emerald { background: #ecfdf5; color: #059669; }

        .stat-info h3 {
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.2;
        }
        .stat-info p {
            font-size: 13px;
            font-weight: 600;
            color: #64748b;
            margin-top: 4px;
        }

        /* CARDS / TABLES */
        .card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin-bottom: 28px;
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .card-header h2 {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* TABLES */
        table.data-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        table.data-table th {
            background: #f8fafc;
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        table.data-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            color: #1e293b;
        }
        table.data-table tr:last-child td {
            border-bottom: none;
        }
        table.data-table tr:hover td {
            background: #f8fafc;
        }
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-processing { background: #dbeafe; color: #2563eb; }
        .badge-shipped { background: #f3e8ff; color: #7c3aed; }
        .badge-delivered { background: #dcfce7; color: #16a34a; }
        .badge-cancelled { background: #fee2e2; color: #dc2626; }
    </style>
</head>
<body>
<div class="layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <!-- Main Content Area -->
    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Bảng điều khiển Nhân viên (Staff Dashboard)</h1>
                <p>Tổng quan xử lý công việc kho hàng, bảo hành &amp; yêu cầu kiểm duyệt</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/staff/ticket/create" style="padding: 10px 18px; background: #2563eb; color: #fff; border-radius: 10px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                    <span>+</span> Tạo Ticket nhập hàng
                </a>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="stats-grid">
            <div class="stat-card" onclick="window.location.href='${pageContext.request.contextPath}/warranty?action=list&statusFilter=PENDING'">
                <div class="stat-icon icon-orange">🛠</div>
                <div class="stat-info">
                    <h3>${pendingClaimsCount != null ? pendingClaimsCount : 0}</h3>
                    <p>Bảo hành chờ xử lý</p>
                </div>
            </div>

            <div class="stat-card" onclick="window.location.href='${pageContext.request.contextPath}/staff/ticket/list'">
                <div class="stat-icon icon-purple">🎫</div>
                <div class="stat-info">
                    <h3>${pendingTicketsCount != null ? pendingTicketsCount : 0}</h3>
                    <p>Ticket chờ duyệt</p>
                </div>
            </div>

            <div class="stat-card" onclick="window.location.href='${pageContext.request.contextPath}/staff/order/list'">
                <div class="stat-icon icon-blue">📋</div>
                <div class="stat-info">
                    <h3 id="card-pending-count">0</h3>
                    <p>Đơn hàng chờ xác nhận</p>
                </div>
            </div>

            <div class="stat-card" onclick="window.location.href='${pageContext.request.contextPath}/staff/outbound/list'">
                <div class="stat-icon icon-emerald">📦</div>
                <div class="stat-info">
                    <h3 id="card-processing-count">0</h3>
                    <p>Đơn hàng đang xử lý xuất kho</p>
                </div>
            </div>
        </div>

        <!-- 2 Column Section: Orders Overview & Operations Tasks -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
            <!-- Column 1: Order Processing Table -->
            <div class="card">
                <div class="card-header">
                    <h2>📋 Quản lý đơn hàng cần xử lý</h2>
                    <a href="${pageContext.request.contextPath}/staff/order/list" style="font-size: 13px; color: #2563eb; font-weight: 600;">Xem tất cả &rarr;</a>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Trạng thái đơn hàng</th>
                            <th style="text-align: center;">Hôm nay</th>
                            <th style="text-align: center;">Tuần này</th>
                            <th style="text-align: center;">Tháng này</th>
                            <th style="text-align: center;">Tất cả</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/staff/order/list?status=pending'">
                            <td><a href="${pageContext.request.contextPath}/staff/order/list?status=pending" style="text-decoration:none;"><span class="badge badge-pending">🟡 Chờ xác nhận (Pending)</span></a></td>
                            <td style="text-align: center; font-weight: 600;" id="count-pending-today">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-pending-week">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-pending-month">0</td>
                            <td style="text-align: center; font-weight: 700; color: #2563eb;" id="count-pending-all">0</td>
                        </tr>
                        <tr style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/staff/order/list?status=processing'">
                            <td><a href="${pageContext.request.contextPath}/staff/order/list?status=processing" style="text-decoration:none;"><span class="badge badge-processing">🔵 Đang xử lý (Processing)</span></a></td>
                            <td style="text-align: center; font-weight: 600;" id="count-processing-today">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-processing-week">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-processing-month">0</td>
                            <td style="text-align: center; font-weight: 700; color: #2563eb;" id="count-processing-all">0</td>
                        </tr>
                        <tr style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/staff/order/list?status=shipped'">
                            <td><a href="${pageContext.request.contextPath}/staff/order/list?status=shipped" style="text-decoration:none;"><span class="badge badge-shipped">🟣 Đang giao hàng (Shipped)</span></a></td>
                            <td style="text-align: center; font-weight: 600;" id="count-shipped-today">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-shipped-week">0</td>
                            <td style="text-align: center; font-weight: 600;" id="count-shipped-month">0</td>
                            <td style="text-align: center; font-weight: 700; color: #2563eb;" id="count-shipped-all">0</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Column 2: Quick Links & Actions -->
            <div class="card">
                <div class="card-header">
                    <h2>⚡ Thao tác nhanh</h2>
                </div>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/staff/inventory" style="padding: 12px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 14px; color: #1e293b; transition: all 0.2s;">
                        <span>▤ Danh mục sản phẩm kho</span>
                        <span style="color: #2563eb;">&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/ticket/create" style="padding: 12px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 14px; color: #1e293b; transition: all 0.2s;">
                        <span>🎫 Tạo Ticket nhập hàng</span>
                        <span style="color: #2563eb;">&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/outbound/list" style="padding: 12px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 14px; color: #1e293b; transition: all 0.2s;">
                        <span>📦 Xử lý xuất kho (Outbound)</span>
                        <span style="color: #2563eb;">&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/warranty?action=list" style="padding: 12px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 14px; color: #1e293b; transition: all 0.2s;">
                        <span>🛠 Tiếp nhận &amp; Xử lý bảo hành</span>
                        <span style="color: #2563eb;">&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/verifications" style="padding: 12px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 14px; color: #1e293b; transition: all 0.2s;">
                        <span>🎓 Duyệt xác minh Sinh viên</span>
                        <span style="color: #2563eb;">&rarr;</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Low Stock Products Card (Transferred from Admin Dashboard) -->
        <div class="card" style="margin-top: 24px;">
            <div class="card-header">
                <h2>⚠️ Sản phẩm sắp hết hàng (Low Stock Products)</h2>
                <a href="${pageContext.request.contextPath}/staff/inventory" style="font-size: 13px; color: #2563eb; font-weight: 600;">Đến trang quản lý kho &rarr;</a>
            </div>
            <c:choose>
                <c:when test="${not empty lowStockProducts}">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Danh mục</th>
                                <th style="text-align: center;">Số lượng còn lại</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${lowStockProducts}" var="p">
                                <tr onclick="window.location.href='${pageContext.request.contextPath}/staff/inventory'" style="cursor: pointer;">
                                    <td style="font-weight: 600; color: #1e293b;">${p.productName}</td>
                                    <td style="color: #64748b; font-size: 13px;">${p.categoryName}</td>
                                    <td style="text-align: center;">
                                        <span class="badge ${p.minPrice <= 3 ? 'badge-cancelled' : 'badge-pending'}">
                                            ⚠️ Còn lại: ${p.minPrice}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 20px; color: #64748b; font-size: 14px;">
                        ✅ Không có sản phẩm nào sắp hết hàng trong kho
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script>
    // Khởi tạo mảng thông tin đơn hàng từ danh sách tất cả đơn hàng truyền từ Controller
    const allOrders = [
        <c:forEach items="${allOrders}" var="o" varStatus="loop">
            {
                orderId: '${o[0]}',
                orderCode: '${o[1]}',
                receiver: '${o[2]}',
                status: '${o[3]}',
                total: ${not empty o[4] ? o[4] : 0.0},
                dateStr: '${o[5]}'
            }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    /**
     * Chuẩn hóa chuỗi trạng thái đơn hàng về dạng chuẩn
     */
    function getNormalizedStatus(status) {
        // Kiểm tra điều kiện dữ liệu trạng thái rỗng
        if (!status) return 'Unknown';
        const s = status.trim().toUpperCase();
        // Kiểm tra từng trường hợp trạng thái đơn hàng
        if (s === 'PENDING') return 'Pending';
        if (s === 'PROCESSING') return 'Processing';
        if (s === 'SHIPPED') return 'Shipped';
        return status;
    }

    /**
     * Chuyển đổi chuỗi ngày tháng dạng 'YYYY-MM-DD HH:mm:ss' sang đối tượng Date
     */
    function parseOrderDate(dateStr) {
        // Kiểm tra chuỗi ngày tháng rỗng
        if (!dateStr) return null;
        const parts = dateStr.split(' ');
        const dateParts = parts[0].split('-');
        const year = parseInt(dateParts[0]);
        const month = parseInt(dateParts[1]) - 1;
        const day = parseInt(dateParts[2]);
        let hour = 0, min = 0, sec = 0;
        // Nếu có thông tin giờ phút giây
        if (parts[1]) {
            const timeParts = parts[1].split(':');
            hour = parseInt(timeParts[0]);
            min = parseInt(timeParts[1]);
            sec = parseInt(timeParts[2]);
        }
        return new Date(year, month, day, hour, min, sec);
    }

    /**
     * Kiểm tra xem ngày chỉ định có phải là hôm nay không
     */
    function isToday(date) {
        // Kiểm tra điều kiện dữ liệu ngày rỗng
        if (!date) return false;
        const today = new Date();
        return date.getDate() === today.getDate() &&
               date.getMonth() === today.getMonth() &&
               date.getFullYear() === today.getFullYear();
    }

    /**
     * Kiểm tra xem ngày chỉ định có thuộc tuần này không
     */
    function isThisWeek(date) {
        // Kiểm tra điều kiện dữ liệu ngày rỗng
        if (!date) return false;
        const today = new Date();
        const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        const day = startOfToday.getDay();
        const diff = startOfToday.getDate() - day + (day === 0 ? -6 : 1);
        const monday = new Date(startOfToday.setDate(diff));
        return date >= monday;
    }

    /**
     * Kiểm tra xem ngày chỉ định có thuộc tháng này không
     */
    function isThisMonth(date) {
        // Kiểm tra điều kiện dữ liệu ngày rỗng
        if (!date) return false;
        const today = new Date();
        return date.getMonth() === today.getMonth() &&
               date.getFullYear() === today.getFullYear();
    }

    // Khởi tạo đối tượng lưu trữ ma trận số lượng đơn hàng theo trạng thái và thời gian
    const counts = {
        'Pending': { today: 0, week: 0, month: 0, all: 0 },
        'Processing': { today: 0, week: 0, month: 0, all: 0 },
        'Shipped': { today: 0, week: 0, month: 0, all: 0 }
    };

    // Vòng lặp duyệt qua tất cả đơn hàng để phân loại và cộng dồn số lượng
    allOrders.forEach(o => {
        const normStatus = getNormalizedStatus(o.status);
        // Kiểm tra trạng thái đơn hàng thuộc danh sách theo dõi của Staff
        if (counts[normStatus]) {
            const d = parseOrderDate(o.dateStr);
            counts[normStatus].all++;
            // Kiểm tra điều kiện rơi vào hôm nay
            if (isToday(d)) counts[normStatus].today++;
            // Kiểm tra điều kiện rơi vào tuần này
            if (isThisWeek(d)) counts[normStatus].week++;
            // Kiểm tra điều kiện rơi vào tháng này
            if (isThisMonth(d)) counts[normStatus].month++;
        }
    });

    // Vòng lặp cập nhật số liệu hiển thị lên bảng ma trận theo dõi đơn hàng
    ['Pending', 'Processing', 'Shipped'].forEach(st => {
        const lower = st.toLowerCase();
        document.getElementById('count-' + lower + '-today').innerText = counts[st].today;
        document.getElementById('count-' + lower + '-week').innerText = counts[st].week;
        document.getElementById('count-' + lower + '-month').innerText = counts[st].month;
        document.getElementById('count-' + lower + '-all').innerText = counts[st].all;
    });

    // Cập nhật số liệu lên các thẻ tổng quan ở đầu trang
    document.getElementById('card-pending-count').innerText = counts['Pending'].all;
    document.getElementById('card-processing-count').innerText = counts['Processing'].all;
</script>
</body>
</html>

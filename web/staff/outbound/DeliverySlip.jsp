<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phiếu Giao Hàng - ${order.orderCode}</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f3f4f6; color: #111; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .toolbar { position: sticky; top: 0; z-index: 10; background: white; border-bottom: 1px solid #e5e7eb; padding: 12px 32px; display: flex; align-items: center; justify-content: space-between; }
        .toolbar a { font-size: 14px; font-weight: 600; color: #374151; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; }
        .toolbar .success { color: #16a34a; display: inline-flex; align-items: center; gap: 4px; font-size: 14px; font-weight: 600; }
        .toolbar .print-btn { background: #0b39d1; color: white; border: none; padding: 8px 20px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; }
        .toolbar .print-btn:hover { background: #092cb0; }
        .page { background: white; max-width: 800px; margin: 2rem auto; padding: 2.5rem; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #111; padding-bottom: 1.5rem; margin-bottom: 1.5rem; }
        .header h1 { font-size: 28px; font-weight: 700; text-transform: uppercase; }
        .header .subtitle { font-size: 13px; color: #6b7280; margin-top: 4px; }
        .header .order-code { font-size: 22px; font-weight: 700; letter-spacing: 0.05em; text-align: right; }
        .header .order-date { font-size: 13px; color: #6b7280; margin-top: 4px; text-align: right; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem; }
        .info-grid h3 { font-size: 11px; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 8px; }
        .info-grid .name { font-size: 18px; font-weight: 600; }
        .info-grid p { font-size: 14px; color: #4b5563; margin-top: 4px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 2rem; }
        thead tr { border-bottom: 2px solid #111; }
        th { padding: 12px 0; font-size: 13px; font-weight: 700; text-align: left; }
        th:last-child { text-align: right; }
        th.center { text-align: center; }
        tbody tr { border-bottom: 1px solid #e5e7eb; }
        td { padding: 14px 0; font-size: 14px; vertical-align: top; }
        td:last-child { text-align: right; }
        td.center { text-align: center; }
        .product-name { font-weight: 600; }
        .product-variant { color: #6b7280; }
        .imei-box { margin-top: 8px; font-size: 12px; color: #4b5563; background: #f9fafb; padding: 8px 10px; border-radius: 6px; border: 1px solid #f3f4f6; }
        .imei-box strong { display: block; margin-bottom: 4px; }
        .imei-box ul { list-style: disc; padding-left: 18px; }
        .imei-box li { margin: 3px 0; }
        .imei-box code { font-family: monospace; background: white; padding: 1px 4px; border: 1px solid #e5e7eb; border-radius: 3px; }
        tfoot tr { border-top: 2px solid #111; }
        tfoot td { padding: 14px 0; font-size: 14px; font-weight: 700; }
        tfoot td:last-child { font-size: 18px; }
        .signatures { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 4rem; text-align: center; }
        .signatures p { font-weight: 700; font-size: 14px; }
        .signatures small { font-size: 12px; color: #9ca3af; }
        .signatures .line { margin-top: 6rem; border-bottom: 1px solid #d1d5db; width: 66%; margin-left: auto; margin-right: auto; }
        .footer { margin-top: 3rem; text-align: center; font-size: 12px; color: #9ca3af; border-top: 1px solid #e5e7eb; padding-top: 1.5rem; }
        @media print {
            body { background: white; }
            .page { margin: 0; box-shadow: none; padding: 1rem; max-width: 100%; }
            .toolbar { display: none !important; }
        }
    </style>
</head>
<body>

<!-- Toolbar (ẩn khi in) -->
<div class="toolbar">
    <div style="display:flex;align-items:center;gap:16px;">
        <a href="${pageContext.request.contextPath}/staff/outbound/history">
            <span class="material-symbols-outlined" style="font-size:20px;">arrow_back</span> Trở lại
        </a>
        <span style="color:#d1d5db;">|</span>
        <span class="success">
            <span class="material-symbols-outlined" style="font-size:20px;">check_circle</span> Đã xuất kho thành công
        </span>
    </div>
    <button class="print-btn" onclick="window.print()">
        <span class="material-symbols-outlined" style="font-size:20px;">print</span> In / Tải PDF
    </button>
</div>

<!-- Nội dung phiếu giao hàng -->
<div class="page">
    <div class="header">
        <div>
            <h1>Phiếu Giao Hàng</h1>
            <div class="subtitle">Delivery Slip</div>
        </div>
        <div>
            <div class="order-code">${order.orderCode}</div>
            <div class="order-date">
                <c:if test="${not empty order.completedAt}">
                    Ngày xuất: <fmt:parseDate value="${order.completedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                    <fmt:formatDate pattern="dd/MM/yyyy HH:mm" value="${parsedDate}" />
                </c:if>
            </div>
        </div>
    </div>

    <div class="info-grid">
        <div>
            <h3>Đơn vị gửi hàng</h3>
            <div class="name">UNILAP STORE</div>
            <p>Khu Công Nghệ Cao Hòa Lạc</p>
            <p>Thạch Thất, Hà Nội</p>
            <p>Hotline: 1900 1234</p>
        </div>
        <div>
            <h3>Thông tin người nhận</h3>
            <div class="name">${order.shippingReceiver}</div>
            <p style="font-weight:500;color:#111;">SĐT: ${order.shippingPhone}</p>
            <p style="line-height:1.6;">${order.shippingAddress}</p>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width:40px;">STT</th>
                <th>Tên Sản Phẩm</th>
                <th class="center">SL</th>
                <th>Đơn Giá</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="index" value="1" />
            <c:forEach var="detail" items="${details}">
                <tr>
                    <td>${index}</td>
                    <td>
                        <span class="product-name">${detail.productName}</span><br>
                        <span class="product-variant">Phân loại: ${detail.variantName} (SKU: ${detail.sku})</span>
                        <c:if test="${not empty detail.assignedItems}">
                            <div class="imei-box">
                                <strong>Mã Serial / IMEI:</strong>
                                <ul>
                                    <c:forEach var="item" items="${detail.assignedItems}">
                                        <li><code>${item.imei}</code> (SN: ${item.serialNumber})</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                    </td>
                    <td class="center" style="font-weight:600;">${detail.quantity}</td>
                    <td><fmt:formatNumber value="${detail.unitPrice}" pattern="#,###"/> đ</td>
                </tr>
                <c:set var="index" value="${index + 1}" />
            </c:forEach>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" style="text-align:right;">TỔNG TIỀN:</td>
                <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</td>
            </tr>
        </tfoot>
    </table>

    <div class="signatures">
        <div>
            <p>Người xuất kho</p>
            <small>(Ký, ghi rõ họ tên)</small>
            <div class="line"></div>
        </div>
        <div>
            <p>Khách hàng nhận</p>
            <small>(Ký, ghi rõ họ tên)</small>
            <div class="line"></div>
        </div>
    </div>

    <div class="footer">
        <p>Cảm ơn quý khách đã tin tưởng và mua sắm tại UNILAP STORE.</p>
        <p>Mọi thắc mắc về đơn hàng, vui lòng liên hệ 1900 1234 để được hỗ trợ.</p>
    </div>
</div>

</body>
</html>

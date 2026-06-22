<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Bảo vệ trang: chỉ cho customer (roleId = 3) truy cập
    model.Users currentUser = (model.Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Warranty Center – UNILAP</title>
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: #f4f6f9;
                color: #1a1a2e;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* ── Navbar ── */
            .navbar {
                background: #fff;
                border-bottom: 1px solid #e5e7eb;
                padding: 0 48px;
                height: 56px;
                display: flex;
                align-items: center;
                gap: 40px;
            }
            .nav-logo {
                font-size: 18px;
                font-weight: 900;
                color: #1a1a2e;
                letter-spacing: -0.5px;
                text-decoration: none;
            }
            .nav-links {
                display: flex;
                gap: 28px;
                list-style: none;
            }
            .nav-links a {
                font-size: 14px;
                color: #374151;
                text-decoration: none;
                transition: color 0.15s;
            }
            .nav-links a:hover {
                color: #2563eb;
            }
            .nav-right {
                margin-left: auto;
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .nav-icon-btn {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 18px;
                color: #374151;
                display: flex;
                align-items: center;
                padding: 4px;
            }

            /* ── Alerts ── */
            .alert {
                max-width: 860px;
                margin: 16px auto 0;
                padding: 0 24px;
                width: 100%;
            }
            .alert-success, .alert-error {
                padding: 12px 16px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 500;
            }
            .alert-success {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .alert-error   {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fca5a5;
            }

            /* ── Page Hero ── */
            .page-hero {
                text-align: center;
                padding: 48px 24px 36px;
            }
            .page-hero h1 {
                font-size: 32px;
                font-weight: 800;
                color: #111827;
                letter-spacing: -0.5px;
            }
            .page-hero p {
                margin-top: 10px;
                font-size: 15px;
                color: #6b7280;
                max-width: 440px;
                margin-left: auto;
                margin-right: auto;
                line-height: 1.6;
            }

            /* ── Cards Grid ── */
            .cards-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                max-width: 860px;
                margin: 0 auto;
                padding: 0 24px;
            }
            .card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 14px;
                padding: 24px;
                transition: box-shadow 0.2s;
            }
            .card:hover {
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }
            .card-icon-wrap {
                width: 44px;
                height: 44px;
                border-radius: 12px;
                background: #eff6ff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                margin-bottom: 14px;
            }
            .card h3 {
                font-size: 17px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
            }
            .card p {
                font-size: 13px;
                color: #6b7280;
                line-height: 1.55;
                margin-bottom: 18px;
            }

            /* Form fields */
            .field-group {
                display: flex;
                flex-direction: column;
                gap: 4px;
                margin-bottom: 12px;
            }
            .field-group label {
                font-size: 11px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .input-row {
                display: flex;
                gap: 8px;
            }

            input[type="text"], select, textarea {
                width: 100%;
                border: 1.5px solid #e5e7eb;
                border-radius: 8px;
                padding: 9px 12px;
                font-size: 13.5px;
                color: #374151;
                background: #fff;
                outline: none;
                transition: border-color 0.15s;
                font-family: inherit;
            }
            input[type="text"]:focus, select:focus, textarea:focus {
                border-color: #2563eb;
            }
            input::placeholder, textarea::placeholder {
                color: #9ca3af;
            }
            select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='none' stroke='%236b7280' stroke-width='2' viewBox='0 0 24 24'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                padding-right: 32px;
            }
            textarea {
                resize: vertical;
                min-height: 88px;
            }

            .btn {
                border: none;
                cursor: pointer;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 600;
                padding: 9px 18px;
                transition: all 0.15s;
            }
            .btn-primary {
                background: #2563eb;
                color: #fff;
            }
            .btn-primary:hover {
                background: #1d4ed8;
            }
            .btn-outline-primary {
                background: #fff;
                border: 1.5px solid #2563eb;
                color: #2563eb;
                width: 100%;
                padding: 9px 0;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-outline-primary:hover {
                background: #eff6ff;
            }

            /* ── Submit Claim Card ── */
            .claim-card {
                grid-column: 1 / -1;
            }
            .claim-card-inner {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .claim-form-fields {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .two-col {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            /* Submit button row */
            .submit-row {
                max-width: 860px;
                margin: 16px auto 0;
                padding: 0 24px;
                display: flex;
                justify-content: flex-end;
            }
            .btn-submit-claim {
                background: #2563eb;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 11px 28px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                transition: background 0.15s;
            }
            .btn-submit-claim:hover {
                background: #1d4ed8;
            }

            /* ── Check Eligibility Result ── */
            .eligibility-result {
                margin-top: 12px;
                padding: 10px 14px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 500;
            }
            .eligibility-valid   {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .eligibility-invalid {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fca5a5;
            }

            /* ── Recent Activity ── */
            .recent-section {
                max-width: 860px;
                margin: 32px auto 0;
                padding: 0 24px;
            }
            .recent-section h3 {
                font-size: 17px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 14px;
            }

            .activity-table {
                width: 100%;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                overflow: hidden;
                border-collapse: collapse;
            }
            .activity-table th {
                text-align: left;
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                padding: 10px 20px;
                background: #fafafa;
                border-bottom: 1px solid #f0f2f5;
            }
            .activity-table td {
                padding: 13px 20px;
                font-size: 13.5px;
                border-bottom: 1px solid #f9fafb;
                vertical-align: middle;
            }
            .activity-table tr:last-child td {
                border-bottom: none;
            }
            .activity-table tr:hover td {
                background: #fafbff;
            }

            .claim-ref {
                font-size: 12.5px;
                font-weight: 600;
                color: #2563eb;
            }
            .claim-date {
                font-size: 11.5px;
                color: #9ca3af;
                margin-top: 1px;
            }

            /* Status badges */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 11.5px;
                font-weight: 600;
                white-space: nowrap;
            }
            .badge-PENDING    {
                background: #fef3c7;
                color: #92400e;
            }
            .badge-PROCESSING {
                background: #dbeafe;
                color: #1d4ed8;
            }
            .badge-APPROVED   {
                background: #d1fae5;
                color: #065f46;
            }
            .badge-REJECTED   {
                background: #fee2e2;
                color: #991b1b;
            }
            .badge-COMPLETED  {
                background: #f3f4f6;
                color: #374151;
            }
            .badge-CANCELLED  {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* Cancel form inline */
            .cancel-form {
                display: inline;
            }
            .btn-cancel-sm {
                background: none;
                border: 1px solid #ef4444;
                color: #ef4444;
                border-radius: 6px;
                padding: 4px 10px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.15s;
            }
            .btn-cancel-sm:hover {
                background: #fef2f2;
            }

            .btn-detail-sm {
                display: inline-block;
                padding: 4px 12px;
                background: #eff6ff;
                color: #2563eb;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
            }
            .btn-detail-sm:hover {
                background: #dbeafe;
            }

            .no-claims {
                text-align: center;
                color: #9ca3af;
                padding: 32px;
                font-size: 13.5px;
            }

            /* ── Footer ── */
            footer {
                margin-top: auto;
                padding: 36px 48px 28px;
                border-top: 1px solid #e5e7eb;
                background: #fff;
            }
            .footer-inner {
                max-width: 860px;
                margin: 0 auto;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .footer-logo {
                font-size: 16px;
                font-weight: 900;
                color: #1a1a2e;
                letter-spacing: -0.5px;
            }
            .footer-links {
                display: flex;
                gap: 20px;
                list-style: none;
            }
            .footer-links a {
                font-size: 13px;
                color: #6b7280;
                text-decoration: none;
                transition: color 0.15s;
            }
            .footer-links a:hover, .footer-links a.active {
                color: #2563eb;
            }
        </style>
    </head>
    <body>

        <!-- ════ NAVBAR ════ -->
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">UNILAP</a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/ProductListServlet">Laptops</a></li>
                <li><a href="#">Mice</a></li>
                <li><a href="#">Keyboards</a></li>
                <li><a href="#">Deals</a></li>
            </ul>
            <div class="nav-right">
                <button class="nav-icon-btn">🛒</button>
                <button class="nav-icon-btn" title="${sessionScope.user.userName}">👤</button>
                <a href="${pageContext.request.contextPath}/LogoutController"
                   style="font-size:13px;color:#6b7280;text-decoration:none;">Đăng xuất</a>
            </div>
        </nav>

        <!-- ════ FLASH MESSAGES ════ -->
    <c:if test="${not empty param.msg}">
        <div class="alert">
            <c:choose>
                <c:when test="${param.msg == 'submitted'}">
                    <div class="alert-success">✅ Yêu cầu bảo hành đã được gửi thành công!</div>
                </c:when>
                <c:when test="${param.msg == 'cancelled'}">
                    <div class="alert-success">🗑️ Yêu cầu bảo hành đã được huỷ.</div>
                </c:when>
                <c:when test="${param.msg == 'updated'}">
                    <div class="alert-success">🔄 Trạng thái yêu cầu bảo hành đã được cập nhật.</div>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert">
            <div class="alert-error">⚠️ <c:out value="${errorMessage}"/></div>
        </div>
    </c:if>

    <!-- ════ HERO ════ -->
    <section class="page-hero">
        <h1>Warranty Center</h1>
        <p>Check eligibility, submit claims, and track the status of your UNILAP precision hardware. Fast, transparent, and reliable support.</p>
    </section>

    <!-- ════ TOP CARDS: Check Eligibility + Track Status ════ -->
    <div class="cards-grid">

        <!-- Check Eligibility -->
        <div class="card">
            <div class="card-icon-wrap">📋</div>
            <h3>Check Eligibility</h3>
            <p>Enter your device serial number to instantly verify your current warranty status and coverage details.</p>
            <form method="get" action="${pageContext.request.contextPath}/warranty">
                <input type="hidden" name="action" value="checkEligibility">
                <div class="field-group">
                    <label>Serial Number</label>
                    <div class="input-row">
                        <input type="text" name="serialNumber"
                               value="${fn:trim(param.serialNumber)}"
                               placeholder="e.g., UNL-2024-XXXX">
                        <button class="btn btn-primary" type="submit">Verify Now</button>
                    </div>
                </div>
            </form>
            <%-- Eligibility result (set by controller action=checkEligibility) --%>
            <c:if test="${not empty eligibilityResult}">
                <div class="eligibility-result ${eligibilityResult == 'VALID' ? 'eligibility-valid' : 'eligibility-invalid'}">
                    <c:choose>
                        <c:when test="${eligibilityResult == 'VALID'}">
                            ✅ Sản phẩm còn trong thời hạn bảo hành.
                        </c:when>
                        <c:otherwise>
                            ❌ ${eligibilityMessage}
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- Track Status by Claim ID -->
        <div class="card">
            <div class="card-icon-wrap">🚚</div>
            <h3>Track Status</h3>
            <p>Follow the progress of your active claims or hardware returns.</p>
            <form method="get" action="${pageContext.request.contextPath}/warranty">
                <input type="hidden" name="action" value="detail">
                <div class="field-group">
                    <label>Claim ID</label>
                    <input type="text" name="id" placeholder="Enter Claim ID (e.g., 42)">
                </div>
                <button class="btn-outline-primary" type="submit">Track Claim</button>
            </form>
        </div>

        <!-- ════ Submit a Claim (full-width) ════ -->
        <div class="card claim-card">
            <div class="card-icon-wrap">🔧</div>
            <h3>Submit a Claim</h3>
            <p>Experiencing an issue? Provide your serial number and details to help our technicians diagnose the problem quickly.</p>

            <form method="post" action="${pageContext.request.contextPath}/warranty"
                  id="submitClaimForm">
                <input type="hidden" name="action" value="submit">

                <div class="claim-card-inner">
                    <!-- Form fields -->
                    <div class="claim-form-fields">
                        <div class="two-col">
                            <div class="field-group">
                                <label>Serial Number <span style="color:#ef4444">*</span></label>
                                <input type="text" name="serialNumber"
                                       value="<c:out value="${serialNumber}"/>"
                                       placeholder="e.g., UNL-2024-XXXX"
                                       required maxlength="100">
                            </div>
                            <div class="field-group">
                                <label>Issue Title <span style="color:#ef4444">*</span></label>
                                <input type="text" name="title"
                                       value="<c:out value="${title}"/>"
                                       placeholder="e.g., Screen flickering"
                                       required maxlength="200">
                            </div>
                        </div>

                        <div class="field-group">
                            <label>Detailed Description <span style="color:#ef4444">*</span></label>
                            <textarea name="description"
                                      placeholder="Please describe the issue in detail..."
                                      required maxlength="2000"><c:out value="${description}"/></textarea>
                        </div>
                    </div>

                    <!-- Info note (thay thế upload vì backend chưa hỗ trợ file) -->
                    <div style="display:flex;flex-direction:column;justify-content:center;
                         background:#f8faff;border:2px dashed #bfdbfe;border-radius:12px;
                         padding:28px 20px;text-align:center;gap:10px;color:#6b7280;">
                        <span style="font-size:28px;">💡</span>
                        <strong style="color:#1e40af;font-size:14px;">Tips khi gửi yêu cầu</strong>
                        <ul style="text-align:left;font-size:12.5px;line-height:1.8;list-style:disc;padding-left:18px;">
                            <li>Ghi rõ serial number trên nhãn máy</li>
                            <li>Mô tả thời điểm và tần suất xảy ra lỗi</li>
                            <li>Nêu các bước đã thử khắc phục</li>
                            <li>Bảo hành chỉ áp dụng cho lỗi phần cứng</li>
                        </ul>
                    </div>
                </div>

                <!-- Submit button -->
                <div style="display:flex;justify-content:flex-end;margin-top:16px;">
                    <button type="submit" class="btn-submit-claim">Submit Claim Request</button>
                </div>
            </form>
        </div>

    </div><!-- end cards-grid -->

    <!-- ════ RECENT WARRANTY ACTIVITY ════ -->
    <section class="recent-section">
        <h3>Recent Warranty Activity</h3>
        <table class="activity-table">
            <thead>
                <tr>
                    <th>Claim ID / Date</th>
                    <th>Product</th>
                    <th>Issue Title</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty claims}">
                    <tr>
                        <td colspan="5" class="no-claims">
                            Bạn chưa có yêu cầu bảo hành nào.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="claim" items="${claims}">
                        <tr>
                            <td>
                                <div class="claim-ref">#${claim.claimId}</div>
                                <div class="claim-date">
                                    <fmt:formatDate value="${claim.createdAt}" pattern="MMM dd, yyyy"/>
                                </div>
                            </td>
                            <td>
                                <div style="font-size:13px;font-weight:500;"><c:out value="${claim.productName}"/></div>
                                <div style="font-size:11.5px;color:#9ca3af;">SN: <c:out value="${claim.serialNumber}"/></div>
                            </td>
                            <td style="font-size:13px;"><c:out value="${claim.title}"/></td>
                            <td>
                                <span class="badge badge-${claim.status}">${claim.status}</span>
                            </td>
                            <td style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
                                <a class="btn-detail-sm"
                                   href="${pageContext.request.contextPath}/warranty?action=detail&id=${claim.claimId}">
                                    View
                                </a>
                                <%-- Cancel chỉ hiện khi PENDING --%>
                        <c:if test="${claim.status == 'PENDING'}">
                            <form class="cancel-form"
                                  action="${pageContext.request.contextPath}/warranty"
                                  method="post"
                                  onsubmit="return confirm('Huỷ yêu cầu #${claim.claimId}?')">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="id"     value="${claim.claimId}">
                                <button type="submit" class="btn-cancel-sm">Cancel</button>
                            </form>
                        </c:if>
                        </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </section>

    <!-- ════ FOOTER ════ -->
    <footer style="margin-top:40px;">
        <div class="footer-inner">
            <span class="footer-logo">UNILAP</span>
            <ul class="footer-links">
                <li><a href="#">Support</a></li>
                <li><a href="#" class="active">Warranty</a></li>
                <li><a href="#">Shipping</a></li>
                <li><a href="#">Privacy</a></li>
                <li><a href="#">Terms</a></li>
            </ul>
        </div>
    </footer>

</body>
</html>

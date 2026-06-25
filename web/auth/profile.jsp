<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Personal Profile - UNILAP</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(180deg, #e8ecf1 0%, #f5f7fa 50%, #e8ecf1 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                color: #1e293b;
                overflow-x: hidden;
            }

            /* Header */
            .header {
                background: linear-gradient(90deg, #dce3ed, #c8d3e3);
                border-bottom: 1px solid #cbd5e1;
                padding: 16px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .logo {
                font-size: 20px;
                font-weight: 700;
                color: #1a3b8a;
                text-decoration: none;
                letter-spacing: 1px;
            }

            .main {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 50px 20px;
                position: relative;
            }

            /* Clean Card styling */
            .card {
                background: #ffffff;
                border: 1px solid #cbd5e1;
                border-radius: 12px;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
                padding: 40px;
                width: 100%;
                max-width: 550px;
                transition: transform 0.2s ease;
            }

            .card-title {
                text-align: center;
                font-size: 26px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 8px;
            }

            .card-subtitle {
                text-align: center;
                font-size: 14px;
                color: #6b7280;
                margin-bottom: 30px;
            }

            /* Avatar Upload Section */
            .avatar-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-bottom: 30px;
            }

            .avatar-wrapper {
                position: relative;
                width: 130px;
                height: 130px;
                border-radius: 50%;
                overflow: hidden;
                border: 3px solid #cbd5e1;
                cursor: pointer;
                transition: all 0.25s ease;
            }

            .avatar-wrapper:hover {
                transform: scale(1.03);
                border-color: #1a3b8a;
            }

            .avatar-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .avatar-placeholder {
                width: 100%;
                height: 100%;
                background: #f1f5f9;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 48px;
                color: #94a3b8;
            }

            .avatar-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 40px;
                background: rgba(15, 23, 42, 0.75);
                display: flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                font-size: 13px;
                opacity: 0;
                transition: opacity 0.2s ease;
            }

            .avatar-wrapper:hover .avatar-overlay {
                opacity: 1;
            }

            .avatar-tip {
                font-size: 12px;
                color: #6b7280;
                margin-top: 10px;
            }

            /* Badges */
            .role-badge {
                display: inline-block;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                margin-top: 10px;
            }

            .badge-admin {
                background: #fef9c3;
                color: #854d0e;
                border: 1px solid #fef08a;
            }

            .badge-staff {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }

            .badge-customer {
                background: #dbeafe;
                color: #1e40af;
                border: 1px solid #bfdbfe;
            }

            /* Messages */
            .error-message {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .success-message {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Form Elements */
            .form-group {
                margin-bottom: 22px;
            }

            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input-wrapper {
                position: relative;
                display: flex;
                align-items: center;
            }

            .input-icon {
                position: absolute;
                left: 16px;
                color: #64748b;
                font-size: 16px;
            }

            .form-group input {
                width: 100%;
                padding: 12px 16px 12px 46px;
                background: #ffffff;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                font-size: 15px;
                color: #111827;
                transition: border-color 0.2s, box-shadow 0.2s;
                font-family: inherit;
            }

            .form-group input:focus {
                outline: none;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
            }

            .form-group input[readonly] {
                background: #f3f4f6;
                border-color: #e5e7eb;
                color: #6b7280;
                cursor: not-allowed;
            }

            .form-group input[readonly]:focus {
                box-shadow: none;
                border-color: #e5e7eb;
            }

            /* Buttons styling */
            .button-row {
                display: flex;
                gap: 15px;
                margin-top: 10px;
            }

            .btn {
                flex: 1;
                padding: 12px;
                border: none;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: all 0.2s;
                font-family: inherit;
                text-decoration: none;
            }

            .btn-primary {
                background: #1e40af;
                color: #ffffff;
            }

            .btn-primary:hover {
                background: #1a3b8a;
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: #ffffff;
                color: #374151;
                border: 1px solid #cbd5e1;
            }

            .btn-secondary:hover {
                background: #f9fafb;
                border-color: #9ca3af;
                transform: translateY(-1px);
            }

            .btn:active {
                transform: translateY(0);
            }

            /* Footer */
            .footer {
                background: #f9fafb;
                border-top: 1px solid #e5e7eb;
                padding: 24px 40px;
                text-align: center;
            }

            .footer p {
                font-size: 13px;
                color: #6b7280;
            }

            .btn-back-header {
                position: absolute;
                top: 40px;
                left: 40px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                background: #ffffff;
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                color: #374151;
                font-size: 13px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s ease;
                z-index: 10;
            }

            .btn-back-header:hover {
                background: #f9fafb;
                border-color: #9ca3af;
                color: #1a3b8a;
                transform: translateY(-1px);
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }

            .btn-back-header i {
                font-size: 11px;
            }

            @media (max-width: 900px) {
                .btn-back-header {
                    position: static;
                    margin-bottom: 20px;
                    align-self: flex-start;
                }
            }

            /* ===== Change Password Card ===== */
            .card-pw {
                background: #ffffff;
                border: 1px solid #cbd5e1;
                border-radius: 12px;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
                padding: 36px 40px;
                width: 100%;
                margin-top: 20px;
            }

            .card-pw-title {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 18px;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
            }

            .card-pw-title i {
                color: #1e40af;
                font-size: 16px;
            }

            .card-pw-subtitle {
                font-size: 13px;
                color: #6b7280;
                margin-bottom: 24px;
            }

            .pw-divider {
                height: 1px;
                background: #e5e7eb;
                margin-bottom: 24px;
            }

            .pw-rule-list {
                list-style: none;
                margin-bottom: 20px;
                padding: 12px 16px;
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                display: flex;
                flex-wrap: wrap;
                gap: 8px 20px;
            }

            .pw-rule-list li {
                font-size: 12px;
                color: #64748b;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .pw-rule-list li i {
                font-size: 11px;
                color: #cbd5e1;
                transition: color 0.2s;
            }

            .pw-rule-list li.valid i {
                color: #16a34a;
            }

            .pw-strength-bar {
                height: 4px;
                border-radius: 4px;
                background: #e5e7eb;
                margin-top: 6px;
                overflow: hidden;
            }

            .pw-strength-fill {
                height: 100%;
                border-radius: 4px;
                width: 0;
                transition: width 0.3s ease, background 0.3s ease;
            }

            .pw-input-wrapper {
                position: relative;
            }

            .pw-toggle {
                position: absolute;
                right: 14px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                color: #64748b;
                font-size: 15px;
                background: none;
                border: none;
                padding: 0;
                display: flex;
                align-items: center;
            }

            .pw-toggle:hover { color: #1e40af; }

            .form-group .pw-input {
                padding-right: 44px;
            }

            .pw-error-message {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .pw-success-message {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
        </style>
    </head>
    <body>

        <header class="header">
            <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UNILAP</a>
            <div style="font-size: 14px; color: #94a3b8;">
                <span style="color:black">Xin chào,</span>  <span style="color: #ffffff; font-weight: 600;">${profileUser.userName}</span>
            </div>
        </header>

        <main class="main">
            <c:choose>
                <c:when test="${profileUser.roleId == 1}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back-header">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </c:when>
                <c:when test="${profileUser.roleId == 2}">
                    <a href="${pageContext.request.contextPath}/staff/inventory" class="btn-back-header">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="btn-back-header">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </c:otherwise>
            </c:choose>

            <div style="width: 100%; max-width: 550px; display: flex; flex-direction: column; z-index: 5;">
                <div class="card" style="max-width: 100%;">
                    <h2 class="card-title">Hồ Sơ Cá Nhân</h2>
                <p class="card-subtitle">Xem và cập nhật thông tin cá nhân của bạn</p>

                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>${success}</span>
                    </div>
                </c:if>

                <form action="profile" method="post" enctype="multipart/form-data">
                    
                    <!-- Avatar Upload -->
                    <div class="avatar-container">
                        <div class="avatar-wrapper" onclick="document.getElementById('avatarInput').click();">
                            <c:choose>
                                <c:when test="${not empty profileUser.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}/images/${profileUser.avatarUrl}" 
                                         alt="Avatar" class="avatar-image" id="avatarPreview">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder" id="avatarPlaceholder">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <img src="" alt="Avatar" class="avatar-image" id="avatarPreview" style="display: none;">
                                </c:otherwise>
                            </c:choose>
                            <div class="avatar-overlay">
                                <i class="fas fa-camera"></i>&nbsp;Thay đổi
                            </div>
                        </div>
                        <input type="file" name="avatar" id="avatarInput" accept="image/*" style="display: none;">
                        <span class="avatar-tip">Click vào ảnh để thay đổi</span>

                        <!-- Role Badge mapping -->
                        <c:choose>
                            <c:when test="${profileUser.roleId == 1}">
                                <span class="role-badge badge-admin">Quản trị viên</span>
                            </c:when>
                            <c:when test="${profileUser.roleId == 2}">
                                <span class="role-badge badge-staff">Nhân viên</span>
                            </c:when>
                            <c:otherwise>
                                <span class="role-badge badge-customer">Khách hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullName">Họ và Tên</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user-edit input-icon"></i>
                            <input type="text" name="fullName" id="fullName" 
                                   value="${profileUser.userName}" required>
                        </div>
                    </div>

                    <!-- Email (Read-Only) -->
                    <div class="form-group">
                        <label for="email">Địa chỉ Email</label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" value="${profileUser.email}" readonly>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="form-group">
                        <label for="phone">Số Điện Thoại</label>
                        <div class="input-wrapper">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="text" name="phone" id="phone" 
                                   value="${profileUser.phone}">
                        </div>
                    </div>

                    <!-- Button Row -->
                    <div class="button-row">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu Thay Đổi
                        </button>
                    </div>

                </form>
            </div>

            <!-- ===== UC05 – Change Password Card ===== -->
            <div class="card-pw" id="changePwSection">
                <div class="card-pw-title">
                    <i class="fas fa-lock"></i>
                    Đổi Mật Khẩu
                </div>
                <p class="card-pw-subtitle">Cập nhật mật khẩu tài khoản của bạn</p>
                <div class="pw-divider"></div>

                <!-- UC05 password feedback messages -->
                <c:if test="${not empty pwError}">
                    <div class="pw-error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${pwError}</span>
                    </div>
                </c:if>
                <c:if test="${not empty pwSuccess}">
                    <div class="pw-success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>${pwSuccess}</span>
                    </div>
                </c:if>

                <!-- Validation rules indicator (VR-02, VR-03) -->
                <ul class="pw-rule-list" id="pwRules">
                    <li id="rule-length"><i class="fas fa-circle"></i> Ít nhất 6 ký tự</li>
                    <li id="rule-match"><i class="fas fa-circle"></i> Xác nhận khớp</li>
                </ul>

                <form action="${pageContext.request.contextPath}/profile" method="post" id="changePwForm">

                    <!-- Current Password -->
                    <div class="form-group">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <label for="currentPassword" style="margin-bottom: 0;">Mật Khẩu Hiện Tại</label>
                            <a href="${pageContext.request.contextPath}/forgot-password"
                               style="font-size: 12px; color: #2563eb; text-decoration: none; font-weight: 500;"
                               onmouseover="this.style.textDecoration='underline'"
                               onmouseout="this.style.textDecoration='none'">
                                <i class="fas fa-question-circle"></i> Quên mật khẩu?
                            </a>
                        </div>
                        <div class="input-wrapper pw-input-wrapper">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="currentPassword" id="currentPassword"
                                   class="pw-input" placeholder="Nhập mật khẩu hiện tại" autocomplete="current-password">
                            <button type="button" class="pw-toggle" onclick="togglePw('currentPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <!-- New Password with strength bar -->
                    <div class="form-group">
                        <label for="newPassword">Mật Khẩu Mới</label>
                        <div class="input-wrapper pw-input-wrapper">
                            <i class="fas fa-key input-icon"></i>
                            <input type="password" name="newPassword" id="newPassword"
                                   class="pw-input" placeholder="Nhập mật khẩu mới" autocomplete="new-password"
                                   oninput="checkPwStrength()">
                            <button type="button" class="pw-toggle" onclick="togglePw('newPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="pw-strength-bar">
                            <div class="pw-strength-fill" id="pwStrengthFill"></div>
                        </div>
                    </div>

                    <!-- Confirm New Password -->
                    <div class="form-group">
                        <label for="confirmPassword">Xác Nhận Mật Khẩu Mới</label>
                        <div class="input-wrapper pw-input-wrapper">
                            <i class="fas fa-check-double input-icon"></i>
                            <input type="password" name="confirmPassword" id="confirmPassword"
                                   class="pw-input" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password"
                                   oninput="checkPwStrength()">
                            <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div class="button-row">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-shield-alt"></i> Đổi Mật Khẩu
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </main>

        <footer class="footer">
            <p>© 2026 UNILAP Precision Engineering. All rights reserved.</p>
        </footer>

        <script>
            // Client-side image upload preview
            document.getElementById('avatarInput').addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (file) {
                    // Check file format
                    if (!file.type.startsWith('image/')) {
                        alert('Định dạng file không hợp lệ! Vui lòng chọn tệp hình ảnh.');
                        this.value = '';
                        return;
                    }
                    
                    var reader = new FileReader();
                    reader.onload = function(event) {
                        var preview = document.getElementById('avatarPreview');
                        var placeholder = document.getElementById('avatarPlaceholder');
                        
                        if (placeholder) {
                            placeholder.style.display = 'none';
                        }
                        
                        preview.src = event.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            });

            // Auto-scroll to change password section when server returns pw error/success
            <c:if test="${not empty pwError or not empty pwSuccess}">
            window.addEventListener('load', function() {
                var section = document.getElementById('changePwSection');
                if (section) {
                    setTimeout(function() {
                        section.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }, 100);
                }
            });
            </c:if>

            // ---------- UC05 Change Password helpers ----------

            // Toggle show/hide password field
            function togglePw(fieldId, btn) {
                var input = document.getElementById(fieldId);
                var icon  = btn.querySelector('i');
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.className = 'fas fa-eye-slash';
                } else {
                    input.type = 'password';
                    icon.className = 'fas fa-eye';
                }
            }

            // Real-time validation rules indicator + strength bar
            function checkPwStrength() {
                var pw      = (document.getElementById('newPassword').value)      || '';
                var confirm = (document.getElementById('confirmPassword').value)  || '';

                var ruleLength = pw.length >= 6;
                var ruleMatch  = pw.length > 0 && pw === confirm;

                setRule('rule-length', ruleLength);
                setRule('rule-match',  ruleMatch);

                // Strength score: 0=empty, 1=weak(<6), 2=ok(6-9), 3=good(10+)
                var fill = document.getElementById('pwStrengthFill');
                var score, color, width;
                if (pw.length === 0)      { score = 0; color = ''; width = '0%'; }
                else if (pw.length < 6)   { score = 1; color = '#ef4444'; width = '33%'; }
                else if (pw.length < 10)  { score = 2; color = '#eab308'; width = '66%'; }
                else                      { score = 3; color = '#22c55e'; width = '100%'; }
                fill.style.width      = width;
                fill.style.background = color;
            }

            function setRule(id, valid) {
                var el = document.getElementById(id);
                if (!el) return;
                if (valid) { el.classList.add('valid'); }
                else       { el.classList.remove('valid'); }
            }

            // Reset the change-password form and indicators
            function resetPwForm() {
                document.getElementById('changePwForm').reset();
                ['rule-length','rule-match']
                    .forEach(function(id){ setRule(id, false); });
                var fill = document.getElementById('pwStrengthFill');
                fill.style.width = '0';
                fill.style.background = '';
            }
        </script>
    </body>
</html>

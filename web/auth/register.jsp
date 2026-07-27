<%-- 
    Document   : register
    Created on : 30 May 2026
    Author     : LUCTVHE201874
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Ký - UNILAP</title>
        <link rel="stylesheet" href="css/auth.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    </head>
    <body>

        <header class="header">
            <span class="logo">UNILAP</span>
        </header>

        <main class="main">
            <div class="card">

                <div class="tabs">
                    <a href="login" class="tab">Đăng Nhập</a>
                    <a href="register" class="tab active">Đăng Ký</a>
                </div>

                <h2 class="card-title">Tạo Tài Khoản</h2>
                <p class="card-subtitle">Tham gia nền tảng công nghệ UniLap.</p>

                <div id="client-error" class="error-message" style="display: none;"></div>
                <%
                    String regError = (String) request.getAttribute("error");
                    if (regError != null && !regError.isEmpty()) {
                %>
                <div class="error-message"><%= regError %></div>
                <% } %>

                <form action="register" method="post" onsubmit="return validateRegisterForm()" novalidate>
                    <div class="form-group">
                        <label>Họ và Tên</label>
                        <input type="text" id="regFullname" name="fullname"
                               placeholder="Nguyễn Văn A"
                               value="${param.fullname}" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="regEmail" name="email"
                               placeholder="user@unilap.co"
                               value="${param.email}" required>
                    </div>
                    <div class="form-group">
                        <label>Số Điện Thoại</label>
                        <input type="text" id="regPhone" name="phone"
                               placeholder="0912345678"
                               pattern="^0[35789]\d{8}$"
                               maxlength="10"
                               value="${param.phone}" required>
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu</label>
                        <div style="position: relative;">
                            <input type="password" id="regPassword" name="password"
                                   placeholder="••••••••"
                                   maxlength="32"
                                   value="${param.password}" required
                                   style="padding-right: 42px;">
                            <span id="toggleRegPassword"
                                  style="position:absolute; right:12px; top:50%; transform:translateY(-50%); cursor:pointer; color:#9ca3af; font-size:16px; user-select:none;">
                                <i class="fas fa-eye-slash"></i>
                            </span>
                        </div>
                        <small style="color: #6b7280; font-size: 11px; margin-top: 4px; display: block;">
                            Mật khẩu ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt
                        </small>
                    </div>
                    <div class="form-group">
                        <label>Xác Nhận Mật Khẩu</label>
                        <div style="position: relative;">
                            <input type="password" id="regConfirmPassword" name="confirmPassword"
                                   placeholder="••••••••"
                                   maxlength="32"
                                   value="${param.confirmPassword}" required
                                   style="padding-right: 42px;">
                            <span id="toggleRegConfirm"
                                  style="position:absolute; right:12px; top:50%; transform:translateY(-50%); cursor:pointer; color:#9ca3af; font-size:16px; user-select:none;">
                                <i class="fas fa-eye-slash"></i>
                            </span>
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">
                        Đăng Ký →
                    </button>
                </form>

                <script>
                    // ── Icon mắt: Mật Khẩu ──
                    document.getElementById('toggleRegPassword').addEventListener('click', function () {
                        var pw   = document.getElementById('regPassword');
                        var icon = this.querySelector('i');
                        if (pw.type === 'password') {
                            pw.type = 'text';
                            icon.classList.replace('fa-eye-slash', 'fa-eye');
                            this.style.color = '#2563eb';
                        } else {
                            pw.type = 'password';
                            icon.classList.replace('fa-eye', 'fa-eye-slash');
                            this.style.color = '#9ca3af';
                        }
                    });

                    // ── Icon mắt: Xác Nhận Mật Khẩu ──
                    document.getElementById('toggleRegConfirm').addEventListener('click', function () {
                        var pw   = document.getElementById('regConfirmPassword');
                        var icon = this.querySelector('i');
                        if (pw.type === 'password') {
                            pw.type = 'text';
                            icon.classList.replace('fa-eye-slash', 'fa-eye');
                            this.style.color = '#2563eb';
                        } else {
                            pw.type = 'password';
                            icon.classList.replace('fa-eye', 'fa-eye-slash');
                            this.style.color = '#9ca3af';
                        }
                    });

                    // ── Việt hóa thông báo lỗi browser ──
                    var viMessages = {
                        'regFullname':        'Vui lòng nhập họ và tên!',
                        'regEmail':           'Vui lòng nhập địa chỉ email hợp lệ!',
                        'regPhone':           'Vui lòng nhập số điện thoại hợp lệ (10 số, bắt đầu 03/05/07/08/09)!',
                        'regPassword':        'Vui lòng nhập mật khẩu!',
                        'regConfirmPassword': 'Vui lòng nhập xác nhận mật khẩu!'
                    };
                    Object.keys(viMessages).forEach(function (id) {
                        var el = document.getElementById(id);
                        if (!el) return;
                        el.addEventListener('invalid', function (e) {
                            e.preventDefault();
                            this.setCustomValidity(viMessages[id]);
                        });
                        el.addEventListener('input', function () {
                            this.setCustomValidity('');
                        });
                    });

                    // ── Validate JS trước khi submit ──
                    function validateRegisterForm() {
                        var pw      = document.getElementById('regPassword').value;
                        var cfm     = document.getElementById('regConfirmPassword').value;
                        var errDiv  = document.getElementById('client-error');

                        var ruleLength  = pw.length >= 8 && pw.length <= 32;
                        var ruleUpper   = /[A-Z]/.test(pw);
                        var ruleLower   = /[a-z]/.test(pw);
                        var ruleDigit   = /[0-9]/.test(pw);
                        var ruleSpecial = /[^a-zA-Z0-9]/.test(pw);

                        if (!ruleLength) {
                            errDiv.innerText = 'Mật khẩu phải có ít nhất 8 ký tự!';
                            errDiv.style.display = 'block';
                            return false;
                        }
                        if (!ruleUpper || !ruleLower || !ruleDigit || !ruleSpecial) {
                            errDiv.innerText = 'Mật khẩu phải bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!';
                            errDiv.style.display = 'block';
                            return false;
                        }
                        if (pw !== cfm) {
                            errDiv.innerText = 'Xác nhận mật khẩu không trùng khớp!';
                            errDiv.style.display = 'block';
                            return false;
                        }

                        errDiv.style.display = 'none';
                        return true;
                    }
                </script>

                <p class="alt-link">Đã có tài khoản? <a href="login">Đăng Nhập</a></p>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-left">
                <span class="logo">UNILAP</span>
                <p>© 2024 UNILAP. Tất cả quyền được bảo lưu.</p>
            </div>
            <div class="footer-right">
                <a href="#">Hỗ Trợ</a>
                <a href="#">Bảo Hành</a>
                <a href="#">Vận Chuyển</a>
                <a href="#">Bảo Mật</a>
                <a href="#">Điều Khoản</a>
            </div>
        </footer>

    </body>
</html>
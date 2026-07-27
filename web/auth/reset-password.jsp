<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt Lại Mật Khẩu - UNILAP</title>
        <link rel="stylesheet" href="css/auth.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
        <style>
            .back-to-login {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #1565c0;
                text-decoration: none;
                font-size: 14px;
            }
            .back-to-login:hover {
                text-decoration: underline;
            }
            .client-error {
                color: #d32f2f;
                background-color: #ffebee;
                border: 1px solid #ffcdd2;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                font-size: 14px;
                display: none;
            }
        </style>
        <script>
            function validateForm() {
                var password = document.getElementById("password").value;
                var confirmPassword = document.getElementById("confirmPassword").value;
                var errorDiv = document.getElementById("client-error");

                var ruleLength  = password.length >= 8;
                var ruleUpper   = /[A-Z]/.test(password);
                var ruleLower   = /[a-z]/.test(password);
                var ruleDigit   = /[0-9]/.test(password);
                var ruleSpecial = /[^a-zA-Z0-9]/.test(password);

                if (!ruleLength || !ruleUpper || !ruleLower || !ruleDigit || !ruleSpecial) {
                    errorDiv.innerText = "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
                    errorDiv.style.display = "block";
                    return false;
                }

                if (password !== confirmPassword) {
                    errorDiv.innerText = "Xác nhận mật khẩu không trùng khớp!";
                    errorDiv.style.display = "block";
                    return false;
                }

                errorDiv.style.display = "none";
                return true;
            }
        </script>
    </head>
    <body>

        <header class="header">
            <span class="logo">UNILAP</span>
        </header>

        <main class="main">
            <div class="card">
                <div class="tabs">
                    <a href="#" class="tab active">Đặt Lại Mật Khẩu</a>
                </div>

                <h2 class="card-title">Tạo Mật Khẩu Mới</h2>
                <p class="card-subtitle">Thiết lập mật khẩu mới an toàn cho tài khoản của bạn.</p>

                <div id="client-error" class="client-error"></div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">${error}</div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message">${success}</div>
                <% } %>

                <%-- Only show form if there is a valid token attribute --%>
                <% if (request.getAttribute("token") != null) { %>
                    <form action="reset-password" method="post" onsubmit="return validateForm()" autocomplete="off">
                        <input type="hidden" name="token" value="${token}">
                        
                        <div class="form-group">
                            <label>Mật Khẩu Mới</label>
                            <div style="position: relative;">
                                <input type="password" id="password" name="password" 
                                       placeholder="••••••••" minlength="8" required 
                                       autocomplete="new-password" style="padding-right: 42px;">
                                <span id="togglePassword"
                                      style="position:absolute; right:12px; top:50%; transform:translateY(-50%); cursor:pointer; color:#9ca3af; font-size:16px; user-select:none;">
                                    <i class="fas fa-eye-slash"></i>
                                </span>
                            </div>
                            <small style="color: #6b7280; font-size: 12px; margin-top: 4px; display: block;">
                                Tối thiểu 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt
                            </small>
                        </div>

                        <div class="form-group">
                            <label>Xác Nhận Mật Khẩu</label>
                            <div style="position: relative;">
                                <input type="password" id="confirmPassword" name="confirmPassword" 
                                       placeholder="••••••••" minlength="8" required 
                                       autocomplete="new-password" style="padding-right: 42px;">
                                <span id="toggleConfirm"
                                      style="position:absolute; right:12px; top:50%; transform:translateY(-50%); cursor:pointer; color:#9ca3af; font-size:16px; user-select:none;">
                                    <i class="fas fa-eye-slash"></i>
                                </span>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-submit">
                            Lưu Mật Khẩu Mới →
                        </button>
                    </form>

                    <script>
                        // ── Icon mắt: Mật Khẩu Mới ──
                        var togglePw = document.getElementById('togglePassword');
                        if (togglePw) {
                            togglePw.addEventListener('click', function () {
                                var pw   = document.getElementById('password');
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
                        }

                        // ── Icon mắt: Xác Nhận Mật Khẩu ──
                        var toggleCfm = document.getElementById('toggleConfirm');
                        if (toggleCfm) {
                            toggleCfm.addEventListener('click', function () {
                                var pw   = document.getElementById('confirmPassword');
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
                        }
                    </script>
                <% } %>

                <a href="login" class="back-to-login">← Quay Lại Đăng Nhập</a>
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
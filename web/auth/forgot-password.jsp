<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quên Mật Khẩu - UNILAP</title>
        <link rel="stylesheet" href="css/auth.css"/>
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
        </style>
    </head>
    <body>

        <header class="header">
            <span class="logo">UNILAP</span>
        </header>

        <main class="main">
            <div class="card">
                <div class="tabs">
                    <a href="login" class="tab active">Quên Mật Khẩu</a>
                </div>

                <h2 class="card-title">Khôi Phục Mật Khẩu</h2>
                <p class="card-subtitle">Nhập địa chỉ email đã đăng ký để nhận liên kết đặt lại mật khẩu.</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">${error}</div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message">${success}</div>
                <% } %>

                <% if (request.getAttribute("emailSent") == null || !(Boolean)request.getAttribute("emailSent")) { %>
                    <form action="forgot-password" method="post">
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" 
                                   placeholder="user@unilap.co" 
                                   value="${param.email}" required>
                        </div>
                        
                        <button type="submit" class="btn-submit">
                            Gửi Liên Kết Đặt Lại →
                        </button>
                    </form>
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

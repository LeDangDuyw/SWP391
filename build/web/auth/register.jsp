<%-- 
    Document   : register
    Created on : 30 May 2026, 15:02:42
    Author     : LUCTVHE201874
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Ký - UNILAP</title>
        <link rel="stylesheet" href="css/auth.css"/>
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

                <div class="error-message">${error}</div>

                <form action="register" method="post">
                    <div class="form-group">
                        <label>Họ và Tên</label>
                        <input type="text" name="fullname" 
                               placeholder="Nguyễn Văn A" 
                               value="${param.fullname}" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" 
                               placeholder="user@unilap.co" 
                               value="${param.email}" required>
                    </div>
                    <div class="form-group">
                        <label>Số Điện Thoại</label>
                        <input type="text" name="phone" 
                               placeholder="0912345678" 
                               pattern="^0[35789]\d{8}$"
                               title="Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09"
                               maxlength="10"
                               value="${param.phone}" required>
                    </div>
                    <div class="form-group">
                        <label>Mật Khẩu</label>
                        <input type="password" name="password" 
                               placeholder="••••••••" 
                               minlength="6"
                               maxlength="32"
                               value="${param.password}" required>
                    </div>
                    <div class="form-group">
                        <label>Xác Nhận Mật Khẩu</label>
                        <input type="password" name="confirmPassword" 
                               placeholder="••••••••" 
                               minlength="6"
                               maxlength="32"
                               value="${param.confirmPassword}" required>
                    </div>
                    <button type="submit" class="btn-submit">
                        Đăng Ký →
                    </button>
                </form>

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
<%-- 
    Document   : login
    Created on : 30 May 2026, 15:02:32
    Author     : LUCTVHE201874
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/auth.css"/>
    </head>
    <body>


        <header class="header">
            <span class="logo">UNILAP</span>
        </header>


        <main class="main">
            <div class="card">

                <div class="tabs">
                    <a href="login" class="tab active">Login</a>
                    <a href="register" class="tab">Register</a>
                </div>

                <h2 class="card-title">Welcome Back</h2>
                <p class="card-subtitle">Access your precision engineering dashboard.</p>
                <% if ("1".equals(request.getParameter("success"))) { %>
                <div class="success-message">Đăng ký thành công! Hãy đăng nhập.</div>
                <% }%>
                <div class="error-message">${error}</div>
                <form action="login" method="post">
                    <div class="form-group">
                        <label>Corporate Email</label>
                        <input type="text" name="email" 
                               placeholder="user@unilap.co" 
                               value="${param.email}" required>
                    </div>
                    <div class="form-group">
                        <div class="label-row">
                            <label>Password</label>
                            <a href="#" class="forgot-link">Forgot password?</a>
                        </div>
                        <input type="password" name="password" 
                               placeholder="••••••••" required>
                    </div>
                    <button type="submit" class="btn-submit">
                        Authenticate →
                    </button>
                </form>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-left">
                <span class="logo">UNILAP</span>
                <p>© 2024 UNILAP Precision Engineering. All rights reserved.</p>
            </div>
            <div class="footer-right">
                <a href="#">Support</a>
                <a href="#">Warranty</a>
                <a href="#">Shipping</a>
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
            </div>
        </footer>



    </body>
</html>

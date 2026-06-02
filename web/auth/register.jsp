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
        <title>Register - UNILAP</title>
        <link rel="stylesheet" href="css/auth.css"/>
    </head>
    <body>


        <header class="header">
            <span class="logo">UNILAP</span>
        </header>


        <main class="main">
            <div class="card">

                <div class="tabs">
                    <a href="login" class="tab">Login</a>
                    <a href="register" class="tab active">Register</a>
                </div>

                <h2 class="card-title">Create Account</h2>
                <p class="card-subtitle">Join our precision engineering platform.</p>

                <div class="error-message">${error}</div>

                <form action="register" method="post">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullname" 
                               placeholder="John Doe" 
                               value="${param.fullname}" required>
                    </div>
                    <div class="form-group">
                        <label>Corporate Email</label>
                        <input type="text" name="email" 
                               placeholder="user@unilap.co" 
                               value="${param.email}" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" 
                               placeholder="0912345678" 
                               value="${param.phone}" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" 
                               placeholder="••••••••" 
                               value="${param.password}" required>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" 
                               placeholder="••••••••" 
                               value="${param.password}" required>
                    </div>
                    <button type="submit" class="btn-submit">
                        Register →
                    </button>
                </form>

                <p class="alt-link">Already have an account? <a href="login">Login</a></p>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password - UNILAP</title>
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
                    <a href="login" class="tab active">Forgot Password</a>
                </div>

                <h2 class="card-title">Reset Credentials</h2>
                <p class="card-subtitle">Enter your corporate email address to retrieve your reset link.</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">${error}</div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message">${success}</div>
                <% } %>

                <% if (request.getAttribute("emailSent") == null || !(Boolean)request.getAttribute("emailSent")) { %>
                    <form action="forgot-password" method="post">
                        <div class="form-group">
                            <label>Corporate Email</label>
                            <input type="email" name="email" 
                                   placeholder="user@unilap.co" 
                                   value="${param.email}" required>
                        </div>
                        
                        <button type="submit" class="btn-submit">
                            Request Reset Link →
                        </button>
                    </form>
                <% } %>

                <a href="login" class="back-to-login">← Back to Login</a>
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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reset Password - UNILAP</title>
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

                if (password.length < 6) {
                    errorDiv.innerText = "Mật khẩu phải có ít nhất 6 ký tự!";
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
                    <a href="#" class="tab active">Reset Password</a>
                </div>

                <h2 class="card-title">Setup New Password</h2>
                <p class="card-subtitle">Establish a secure password for your system account.</p>

                <div id="client-error" class="client-error"></div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">${error}</div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message">${success}</div>
                <% } %>

                <%-- Only show form if there is a valid token attribute --%>
                <% if (request.getAttribute("token") != null) { %>
                    <form action="reset-password" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="token" value="${token}">
                        
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" id="password" name="password" 
                                   placeholder="••••••••" required>
                        </div>

                        <div class="form-group">
                            <label>Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   placeholder="••••••••" required>
                        </div>
                        
                        <button type="submit" class="btn-submit">
                            Save New Password →
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

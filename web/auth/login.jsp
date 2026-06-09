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
                               value="${not empty param.email ? param.email : cookie.c_email.value}" required>
                    </div>
                    <div class="form-group">
                        <div class="label-row">
                            <label>Password</label>
                            <a href="#" class="forgot-link">Forgot password?</a>
                        </div>
                        <input type="password" name="password" 
                               placeholder="••••••••" 
                               value="${cookie.c_password.value}" required>
                    </div>
                    <div class="form-group-remember">
                        <label class="remember-label">
                            <input type="checkbox" name="remember" value="ON" ${not empty cookie.c_remember.value ? 'checked' : ''}>
                            <span>Remember password</span>
                        </label>
                    </div>
                    <button type="submit" class="btn-submit">
                        Authenticate →
                    </button>

                    <div class="divider">
                        <span>or</span>
                    </div>

                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/UniLap/login-google&response_type=code&client_id=560009557221-md9sba4a9jhc2o6uqmenduo1pbeansmo.apps.googleusercontent.com&approval_prompt=force" class="btn-google">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="18px" height="18px">
                            <path fill="#fbc02d" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12s5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24s8.955,20,20,20s20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"/>
                            <path fill="#e53935" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"/>
                            <path fill="#4caf50" d="M24,44c5.166,0,9.86-1.977,13.422-5.192l-6.239-5.192C29.22,35.15,26.712,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"/>
                            <path fill="#1565c0" d="M43.611,20.083L43.611,20.083H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571c0.001-0.001,0.002-0.001,0.003-0.002l6.239,5.192C40.948,35.53,44,30.344,44,24C44,22.659,43.862,21.35,43.611,20.083z"/>
                        </svg>
                        Continue with Google
                    </a>
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

<%-- 
    Document   : admin.jsp
    Created on : 31 May 2026, 10:56:34
    Author     : AI One
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - UNILAP</title>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f3f4f6;
                padding: 40px;
                color: #1f2937;
            }
            .container {
                max-width: 600px;
                margin: auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
            h1 {
                color: #1e3a8a;
            }
            a {
                display: inline-block;
                margin-top: 20px;
                color: #2563eb;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Hello admin, ${sessionScope.user.userName}</h1>
            <p>Welcome to the UNILAP Administration dashboard.</p>
            <a href="HomeServlet">← Back to Homepage</a>
        </div>
    </body>
</html>

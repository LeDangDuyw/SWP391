<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Promotion Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/promotion.css">
</head>
<body>
<div class="error-page">
    <h1>Không chạy được module Promotions</h1>
    <p><%= request.getAttribute("error") == null ? "Unknown error" : request.getAttribute("error") %></p>
    <a class="btn primary" href="<%=request.getContextPath()%>/admin/promotions">Quay lại</a>
</div>
</body>
</html>

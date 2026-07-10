<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Promotion Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>
<body>

<h1>Không chạy được module Promotions</h1>

<p>
    <b>Lỗi:</b>
    <%= request.getAttribute("error") == null ? "Không rõ lỗi" : request.getAttribute("error") %>
</p>

<p>
    <b>Chi tiết:</b>
    <%= request.getAttribute("detail") == null ? "" : request.getAttribute("detail") %>
</p>

<a href="<%= request.getContextPath() %>/admin/promotions">Quay lại</a>

</body>
</html>

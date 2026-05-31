<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>UNILAP Admin Dashboard</title>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Segoe UI,sans-serif;
        }

        body{
            background:#f5f6fa;
        }

        .container{
            display:flex;
            min-height:100vh;
        }

        /* Sidebar */

        .sidebar{
            width:250px;
            background:white;
            border-right:1px solid #ddd;
        }

        .logo{
            padding:25px;
        }

        .logo h2{
            color:#2563eb;
        }

        .logo p{
            color:#777;
            margin-top:5px;
        }

        .sidebar ul{
            list-style:none;
        }

        .sidebar li{
            padding:15px 25px;
        }

        .sidebar li.active{
            background:#dbeafe;
        }

        .sidebar a{
            text-decoration:none;
            color:#333;
        }

        /* Main */

        .main-content{
            flex:1;
        }

        .navbar{
            background:white;
            padding:20px;
            display:flex;
            justify-content:space-between;
            border-bottom:1px solid #ddd;
        }

        .search-box{
            width:300px;
            padding:10px;
        }

        .content{
            padding:25px;
        }

        .page-header{
            margin-bottom:25px;
        }

        /* Cards */

        .stats-container{
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:20px;
            margin-bottom:30px;
        }

        .stat-card{
            background:white;
            padding:25px;
            border-radius:10px;
            box-shadow:0 2px 10px rgba(0,0,0,.08);
        }

        .stat-card h3{
            color:#666;
            margin-bottom:10px;
        }

        .stat-card h2{
            color:#2563eb;
        }

        /* Table */

        .table-card{
            background:white;
            border-radius:10px;
            overflow:hidden;
            box-shadow:0 2px 10px rgba(0,0,0,.08);
        }

        .table-header{
            padding:20px;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        thead{
            background:#111827;
            color:white;
        }

        th{
            padding:15px;
            text-align:left;
        }

        td{
            padding:15px;
            border-bottom:1px solid #eee;
        }

        tr:hover{
            background:#f8fafc;
        }

    </style>

</head>

<body>

<div class="container">

    <!-- SIDEBAR -->

    <div class="sidebar">

        <div class="logo">

            <h2>UNILAP Admin</h2>

            <p>System Controller</p>

        </div>

        <ul>

            <li class="active">
                <a href="#">Dashboard</a>
            </li>

            <li>
                <a href="#">Orders</a>
            </li>

            <li>
                <a href="#">Inventory</a>
            </li>

            <li>
                <a href="#">Users</a>
            </li>

            <li>
                <a href="#">Policies</a>
            </li>

        </ul>

    </div>

    <!-- MAIN -->

    <div class="main-content">

        <div class="navbar">

            <input type="text"
                   class="search-box"
                   placeholder="Search...">

            <strong>Administrator</strong>

        </div>

        <div class="content">

            <div class="page-header">

                <h1>Overview Dashboard</h1>

                <p>System overview and statistics</p>

            </div>

            <!-- KPI -->

            <div class="stats-container">

                <div class="stat-card">

                    <h3>Total Users</h3>

                    <h2>${summary.totalUsers}</h2>

                </div>

                <div class="stat-card">

                    <h3>Total Orders</h3>

                    <h2>${summary.totalOrders}</h2>

                </div>

                <div class="stat-card">

                    <h3>Total Products</h3>

                    <h2>${summary.totalProducts}</h2>

                </div>

                <div class="stat-card">

                    <h3>Total Policies</h3>

                    <h2>${summary.totalPolicies}</h2>

                </div>

            </div>

            <!-- RECENT ORDERS -->

            <div class="table-card">

                <div class="table-header">

                    <h2>Recent Orders</h2>

                </div>

                <table>

                    <thead>

                    <tr>

                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Amount</th>
                        <th>Status</th>

                    </tr>

                    </thead>

                    <tbody>

                    <c:forEach items="${recentOrders}" var="o">

                        <tr>

                            <td>${o.orderId}</td>

                            <td>${o.customerName}</td>

                            <td>$${o.amount}</td>

                            <td>${o.status}</td>

                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

<script>

    document.addEventListener("DOMContentLoaded", function () {

        console.log("Dashboard Loaded");

    });

</script>

</body>
</html>
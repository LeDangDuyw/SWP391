<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UniLap AI Center - Trò chuyện toàn màn hình</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css?v=1">
    </head>
    <body class="chat-full-body">
        <!-- Header -->
        <header class="header">
            <div class="container header-container">
                <a href="${pageContext.request.contextPath}/HomeServlet" class="logo">UniLap</a>
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/HomeServlet">Trang chủ</a>
                    <c:forEach items="${categories}" var="cat">
                        <c:if test="${cat.categoryId == 1 || cat.categoryId == 3 || cat.categoryId == 4}">
                            <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                        </c:if>
                    </c:forEach>

                    <div class="nav-dropdown">
                        <span class="dropdown-btn">Phụ kiện <i class="fas fa-chevron-down" style="font-size: 11px;"></i></span>
                        <div class="dropdown-content">
                            <c:forEach items="${categories}" var="cat">
                                <c:if test="${cat.categoryId == 2 || cat.categoryId == 5 || cat.categoryId == 6 || cat.categoryId == 7}">
                                    <a href="ProductListServlet?category=${cat.categoryId}">${cat.categoryName}</a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <a href="#">Khuyến mãi</a>
                </nav>
                <div class="header-icons" style="display:flex; align-items:center; gap:15px;">                   
                    <form action="ProductListServlet" method="GET" class="search-form" style="display:flex; align-items:center; background:#f1f3f9; padding:6px 12px; border-radius:20px;">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." style="border:none; background:transparent; outline:none; font-size:14px; width:180px; font-family:'Inter', sans-serif;">
                        <button type="submit" style="border:none; background:transparent; cursor:pointer; color:#555;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="#"><i class="fas fa-shopping-cart"></i></a>
                    <a href="#"><i class="fas fa-bell"></i></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu-dropdown-container" style="position: relative; display: inline-block;">
                                <a href="#" class="user-menu-trigger" style="display: flex; align-items: center; gap: 5px; text-decoration: none; color: inherit;">
                                    <i class="fas fa-user"></i>
                                    <span style="font-size: 13px; font-weight: 500; max-width: 90px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${sessionScope.user.userName}</span>
                                </a>
                                <div class="user-menu-dropdown-content" style="display: none; position: absolute; right: 0; background-color: #ffffff; min-width: 150px; box-shadow: 0px 8px 16px rgba(0,0,0,0.15); z-index: 1000; border-radius: 8px; margin-top: 8px; border: 1px solid #e2e8f0; padding: 6px 0;">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Admin</a>
                                        </c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            <a href="${pageContext.request.contextPath}/staff/inventory" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Dashboard Staff</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" style="color: #1e293b; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px;">Trang cá nhân</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <div style="border-top: 1px solid #f1f5f9; margin: 6px 0;"></div>
                                    <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; padding: 8px 16px; text-decoration: none; display: block; font-size: 13px; font-weight: 500;">Đăng xuất</a>
                                </div>
                            </div>
                            <script>
                                (function () {
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var triggers = document.querySelectorAll('.user-menu-trigger');
                                        triggers.forEach(function (trigger) {
                                            trigger.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                e.stopPropagation();
                                                var dropdown = this.nextElementSibling;
                                                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                                            });
                                        });
                                        document.addEventListener('click', function () {
                                            document.querySelectorAll('.user-menu-dropdown-content').forEach(function (dropdown) {
                                                dropdown.style.display = 'none';
                                            });
                                        });
                                    });
                                })();
                            </script>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Main Workspace Chat Full -->
        <div class="chat-full-wrapper" id="chat-full-container">
            <!-- Sidebar Trái -->
            <div class="chat-full-sidebar">
                <div class="chat-full-sidebar-header">
                    <i class="fas fa-robot"></i>
                    <h2>UniLap AI Center</h2>
                </div>
                <div class="chat-full-sidebar-content">
                    <div class="chat-full-features">
                        <div class="chat-full-feature-item">
                            <i class="fas fa-bolt"></i>
                            <div>
                                <h4>Phản hồi tức thì</h4>
                                <p>Hệ thống AI trả lời nhanh chóng dựa trên dữ liệu sản phẩm của UniLap.</p>
                            </div>
                        </div>
                        <div class="chat-full-feature-item">
                            <i class="fas fa-laptop"></i>
                            <div>
                                <h4>Tư vấn cấu hình</h4>
                                <p>Nhập nhu cầu và ngân sách để AI gợi ý dòng laptop phù hợp nhất.</p>
                            </div>
                        </div>
                        <div class="chat-full-feature-item">
                            <i class="fas fa-shield-alt"></i>
                            <div>
                                <h4>Hỗ trợ dịch vụ</h4>
                                <p>Thông tin chi tiết về chính sách đổi trả hàng và chế độ bảo hành 12 tháng.</p>
                            </div>
                        </div>
                    </div>
                    
                    <button id="chat-full-clear" class="chat-full-btn-clear">
                        <i class="fas fa-trash-alt"></i> Xóa lịch sử chat
                    </button>
                </div>
            </div>

            <!-- Khung Chat Chính Bên Phải -->
            <div class="chat-full-main">
                <!-- Header của khung chat -->
                <div class="chat-full-main-header">
                    <div class="chat-full-main-header-info">
                        <h3>Trợ lý ảo UniLap AI</h3>
                        <span><i class="fas fa-circle" style="font-size: 8px; margin-right: 4px;"></i> Sẵn sàng hỗ trợ bạn</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="chat-full-btn-home">
                        <i class="fas fa-home"></i> Quay lại Trang chủ
                    </a>
                </div>

                <!-- Vùng hiển thị danh sách tin nhắn -->
                <div class="chat-full-messages-viewport" id="chat-full-messages-viewport">
                    <div class="chat-full-messages-list" id="chat-full-messages-list">
                        <!-- JS sẽ render tin nhắn tại đây -->
                    </div>
                </div>

                <!-- Thanh nhập tin nhắn -->
                <div class="chat-full-input-viewport">
                    <div class="chat-full-input-container">
                        <textarea id="chat-full-textarea" placeholder="Nhập câu hỏi của bạn tại đây... (Nhấn Enter để gửi)" rows="1"></textarea>
                        <button id="chat-full-send" class="unilap-chat-btn-send" title="Gửi tin nhắn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                    <span class="chat-full-disclaimer">UniLap AI luôn đồng hành cùng trải nghiệm mua sắm của bạn.</span>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <%
            if (request.getAttribute("footerPages") == null) {
                try {
                    dal.PageContentDAO pgDAO = new dal.PageContentDAO();
                    java.util.ArrayList<model.PageContent> footerPagesList = pgDAO.getAllActivePages();
                    request.setAttribute("footerPages", footerPagesList);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
        <footer class="footer">
            <div class="container footer-grid">
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/HomeServlet" class="logo footer-logo">UniLap</a>
                    <p class="footer-brand-desc">Nền tảng mua sắm công nghệ cao cấp hàng đầu. Chúng tôi cam kết đem lại trải nghiệm mua sắm tuyệt vời nhất với các sản phẩm laptop, bàn phím và chuột máy tính chính hãng chất lượng cao.</p>
                    <div class="footer-contact-info">
                        <p><i class="fas fa-map-marker-alt"></i> Mỹ Đình, Hà Nội</p>
                        <p><i class="fas fa-phone-alt"></i> Hotline: 1900 8888 (8:00 - 22:00)</p>
                        <p><i class="fas fa-envelope"></i> Email: support@unilap.vn</p>
                    </div>
                    <div class="social-icons">
                        <a href="#" class="social-icon-fb"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon-yt"><i class="fab fa-youtube"></i></a>
                        <a href="#" class="social-icon-ig"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon-tt"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
                
                <div class="footer-col">
                    <h3>Chính sách & Hỗ trợ</h3>
                    <ul>
                        <c:if test="${not empty footerPages}">
                            <c:forEach items="${footerPages}" var="pageItem">
                                <li><a href="${pageContext.request.contextPath}/page?key=${pageItem.pageKey}"><i class="fas fa-chevron-right"></i> ${pageItem.title}</a></li>
                            </c:forEach>
                        </c:if>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <div class="container footer-bottom-container">
                    <p>&copy; 2026 UniLap. Tất cả các quyền được bảo hộ.</p>
                    <p style="font-size: 12px; color: #94a3b8;">Thiết kế bởi <a href="#" style="color: var(--primary); font-weight: 500;">UniLap Team</a></p>
                </div>
            </div>
        </footer>

        <script>
            window.contextPath = "${pageContext.request.contextPath}";
            
            // Xử lý tự động tăng/giảm kích thước textarea khi nhập văn bản
            (function() {
                const textarea = document.getElementById("chat-full-textarea");
                if (textarea) {
                    textarea.addEventListener("input", function() {
                        this.style.height = "auto";
                        this.style.height = (this.scrollHeight - 16) + "px";
                    });
                }
            })();
        </script>
        <script src="${pageContext.request.contextPath}/js/chat.js?v=1"></script>
    </body>
</html>

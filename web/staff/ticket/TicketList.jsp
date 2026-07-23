<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>UNILAP Staff - Danh sách Phiếu Nhập Kho</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-tertiary-container": "#dde4ff",
                        "tertiary-fixed": "#dae2fd",
                        "on-secondary-fixed-variant": "#38485d",
                        "primary": "#003ec7",
                        "on-primary-container": "#dfe3ff",
                        "surface-container-highest": "#e0e3e5",
                        "error": "#ba1a1a",
                        "inverse-on-surface": "#eff1f3",
                        "secondary-container": "#d0e1fb",
                        "primary-fixed": "#dde1ff",
                        "on-tertiary-fixed-variant": "#3f465c",
                        "surface-container-high": "#e6e8ea",
                        "secondary-fixed": "#d3e4fe",
                        "on-primary": "#ffffff",
                        "tertiary-fixed-dim": "#bec6e0",
                        "outline-variant": "#c3c5d9",
                        "on-primary-fixed-variant": "#0038b6",
                        "on-background": "#191c1e",
                        "on-surface": "#191c1e",
                        "outline": "#737688",
                        "inverse-primary": "#b7c4ff",
                        "surface": "#f7f9fb",
                        "surface-dim": "#d8dadc",
                        "secondary": "#505f76",
                        "primary-fixed-dim": "#b7c4ff",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary": "#ffffff",
                        "background": "#f7f9fb",
                        "on-secondary": "#ffffff",
                        "on-surface-variant": "#434656",
                        "on-secondary-container": "#54647a",
                        "surface-container": "#eceef0",
                        "primary-container": "#0052ff",
                        "tertiary-container": "#5e667d",
                        "on-error": "#ffffff",
                        "surface-variant": "#e0e3e5",
                        "surface-tint": "#004ced",
                        "surface-container-low": "#f2f4f6",
                        "on-tertiary-fixed": "#131b2e",
                        "on-secondary-fixed": "#0b1c30",
                        "on-primary-fixed": "#001452",
                        "error-container": "#ffdad6",
                        "secondary-fixed-dim": "#b7c8e1",
                        "on-error-container": "#93000a",
                        "inverse-surface": "#2d3133",
                        "tertiary": "#464e64",
                        "surface-bright": "#f7f9fb"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "spacing": {
                        "margin-desktop": "64px",
                        "container-max": "1440px",
                        "gutter": "24px",
                        "margin-mobile": "20px",
                        "unit": "8px"
                    },
                    "fontFamily": {
                        "body-lg": ["Inter"],
                        "headline-lg": ["Space Grotesk"],
                        "headline-xl": ["Space Grotesk"],
                        "code-sm": ["monospace"],
                        "headline-xl-mobile": ["Space Grotesk"],
                        "body-sm": ["Inter"],
                        "label-md": ["Inter"],
                        "body-md": ["Inter"],
                        "headline-md": ["Space Grotesk"]
                    },
                    "fontSize": {
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "600"}],
                        "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "code-sm": ["13px", {"lineHeight": "18px", "fontWeight": "400"}],
                        "headline-xl-mobile": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .icon-fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/promotion.css">
</head>

<body class="bg-background text-on-surface font-body-md min-h-screen">
<div class="layout">
    <!-- Sidebar Navigation -->
    <jsp:include page="/staff/sidebar.jsp">
        <jsp:param name="activePage" value="ticket"/>
    </jsp:include>

    <div class="main">

        <!-- Top Header -->
        <header class="sticky top-0 z-30 bg-surface w-full border-b border-outline-variant/30 flex justify-between items-center px-gutter h-16">
            <div class="flex items-center gap-4 w-1/3"></div>
            <div class="flex items-center gap-4">
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <button class="p-2 text-on-surface-variant hover:bg-surface-container-low rounded-full transition-colors duration-200 ease-out">
                    <span class="material-symbols-outlined">help_outline</span>
                </button>
                <div class="h-8 w-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-label-md ml-2 border border-outline-variant/50">
                    <span class="material-symbols-outlined">person</span>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 p-gutter bg-surface-container-lowest">

            <!-- Page Header -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface mb-1">Phiếu nhập kho</h2>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">Quản lý danh sách các phiếu yêu cầu nhập kho.</p>
                </div>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/staff/ticket/create"
                       class="px-4 py-2.5 bg-primary text-on-primary rounded-lg hover:bg-primary/90 transition-colors font-label-md text-label-md flex items-center gap-2 shadow-sm">
                        <span class="material-symbols-outlined text-[20px]">add</span> Tạo phiếu nhập mới
                    </a>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty param.success}">
                <div class="mb-6 flex items-center gap-3 px-4 py-3 bg-[#E6F4EA] border border-[#CEEAD6] rounded-xl text-[#137333] font-label-md text-label-md">
                    <span class="material-symbols-outlined text-[20px]">check_circle</span>
                    Thao tác thành công!
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="mb-6 flex items-center gap-3 px-4 py-3 bg-error-container border border-error-container rounded-xl text-on-error-container font-label-md text-label-md">
                    <span class="material-symbols-outlined text-[20px]">error</span>
                    Đã xảy ra lỗi: ${param.error}
                </div>
            </c:if>

            <!-- Ticket Table -->
            <div class="bg-surface border border-outline-variant/50 rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-on-surface text-on-primary font-label-md text-label-md">
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-12">
                                    <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                </th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-20">ID</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20">Tiêu đề</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-48">Trạng thái</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 w-44">Ngày tạo</th>
                                <th class="py-3 px-4 border-b border-outline-variant/20 text-right w-40">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="font-body-sm text-body-sm">
                            <c:forEach var="t" items="${tickets}">
                                <tr class="border-b border-outline-variant/30 hover:bg-surface-container-lowest/50 transition-colors bg-surface-container-lowest">
                                    <td class="py-2 px-4">
                                        <input class="rounded border-outline-variant text-primary focus:ring-primary" type="checkbox">
                                    </td>
                                    <td class="py-2 px-4 font-bold text-on-surface">#${t.ticketId}</td>
                                    <td class="py-2 px-4">
                                        <div class="font-bold text-on-surface">${t.title}</div>
                                    </td>
                                    <td class="py-2 px-4">
                                        <c:choose>
                                            <c:when test="${t.status == 'COMPLETED'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-[#E6F4EA] text-[#137333] text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">check_circle</span>
                                                    Đã hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'CANCELLED'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-error-container text-on-error-container text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">cancel</span>
                                                    Đã hủy
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'PENDING_APPROVAL' || t.status == 'WAITING_FOR_ADMIN_REVIEW' || t.status == 'PENDING'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-[#FEF7E0] text-[#B06000] text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">schedule</span>
                                                    Chờ phê duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'APPROVED_EXECUTION' || t.status == 'APPROVED'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-[#E8F0FE] text-[#1A73E8] text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">thumb_up</span>
                                                    Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'CARGO_RECEIVED'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-[#E8F0FE] text-[#1A73E8] text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">inventory_2</span>
                                                    Đã nhận hàng
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'REJECTED'}">
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-[#FCE8E6] text-[#C5221F] text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">info</span>
                                                    Bị từ chối
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2.5 py-1 rounded-md bg-primary-fixed text-on-primary-fixed text-[12px] font-bold gap-1">
                                                    <span class="material-symbols-outlined text-[14px]">info</span>
                                                    ${t.status == 'APPROVED' ? 'Đã duyệt' : (t.status == 'REJECTED' ? 'Bị từ chối' : (t.status == 'CARGO_RECEIVED' ? 'Đã nhận hàng' : t.status))}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty t.reason}">
                                            <div class="text-on-surface-variant text-[12px] mt-1">Lý do: 
                                                <c:choose>
                                                    <c:when test="${t.reason == 'Stock received and all IMEIs registered'}">Đã nhận hàng và đăng ký toàn bộ số IMEI</c:when>
                                                    <c:when test="${t.reason == 'Stock received and all serials registered'}">Đã nhận hàng và đăng ký toàn bộ số Serial</c:when>
                                                    <c:otherwise>${t.reason}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td class="py-2 px-4 text-on-surface-variant">${t.createdAt}</td>
                                    <td class="py-2 px-4 text-right">
                                        <a class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-primary/10 text-primary rounded-md hover:bg-primary/20 transition-colors font-label-md text-[12px]"
                                           href="${pageContext.request.contextPath}/staff/ticket/workflow?id=${t.ticketId}">
                                            <span class="material-symbols-outlined text-[16px]">visibility</span>
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty tickets}">
                                <tr>
                                    <td class="py-8 px-4 text-center text-on-surface-variant font-body-sm text-body-sm" colspan="6">
                                        <div class="flex flex-col items-center gap-2">
                                            <span class="material-symbols-outlined text-[40px] text-outline-variant">inbox</span>
                                            Không tìm thấy phiếu nhập kho nào.
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>
</div>

</body>
</html>

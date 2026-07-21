package controller;

/**
 * Class: AdminDashboardServlet
 * Description: Controller xử lý điều hướng hiển thị và dữ liệu cho trang tổng quan (Dashboard).
 * 
 * Created: 2026-05-31
 * Updated: 2026-07-11
 * Version: v1.3
 *
 * @author DuyLD
 */

import dal.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

public class AdminDashboardServlet extends HttpServlet {

    private AdminDashboardDAO dashboardDAO;

    /**
     * Khởi tạo Servlet và đối tượng DAO truy vấn dữ liệu Dashboard.
     */
    @Override
    /**
     * Phuong thuc init
     */
    public void init() {
        dashboardDAO = new AdminDashboardDAO();
    }

    /**
     * Xử lý yêu cầu GET để lấy thông tin thống kê và tải trang Admin Dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
        try {
            // Bắt đầu phiên làm việc và kiểm tra quyền đăng nhập của người dùng
            HttpSession session = request.getSession(false);
            Users user = null;

            // Kiểm tra điều kiện
            if (session != null) {
                user = (Users) session.getAttribute("user");
            }

            // Nếu người dùng chưa đăng nhập, chuyển hướng về trang Login
            // Kiểm tra xác thực người dùng / phiên đăng nhập
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy tham số khoảng thời gian lọc dữ liệu từ request
            String from = request.getParameter("from");
            String to = request.getParameter("to");

            // Nếu người dùng chọn khoảng ngày tùy chỉnh
            // Kiểm tra điều kiện
            if (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty()) {
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try {
                    // Chuyển đổi định dạng chuỗi sang kiểu dữ liệu Date của SQL để truy vấn
                    java.sql.Date fromDate = java.sql.Date.valueOf(from.trim());
                    java.sql.Date toDate = java.sql.Date.valueOf(to.trim());

                    // Kiểm tra quy tắc ngày bắt đầu không được sau ngày kết thúc
                    // Kiểm tra điều kiện
                    if (fromDate.after(toDate)) {
                        request.setAttribute("dateError", "Ngày bắt đầu không được sau ngày kết thúc.");
                        from = null;
                        to = null;
                    }
                // Bắt và xử lý ngoại lệ xảy ra trong khối try
                } catch (Exception e) {
                    // Bắt lỗi định dạng ngày không hợp lệ, đặt lại giá trị rỗng
                    from = null;
                    to = null;
                }
            }
            request.setAttribute("todayDate", java.time.LocalDate.now().toString());

            // Lấy tham số nhóm dữ liệu (theo ngày, tuần, tháng...)
            String groupBy = request.getParameter("groupBy");
            // Kiểm tra điều kiện
            if (groupBy == null || groupBy.trim().isEmpty()) {
                groupBy = "month"; // Mặc định nhóm theo Tháng
            }

            boolean missingRange = (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty());
            boolean autoDefaultRange = "day".equals(groupBy) && missingRange;

            // Tự động thiết lập khoảng ngày mặc định nếu chọn xem theo Ngày mà không truyền khoảng ngày
            // Kiểm tra điều kiện
            if (autoDefaultRange) {
                java.time.LocalDate today = java.time.LocalDate.now();
                to = today.toString();
                from = today.minusDays(30).toString(); // Mặc định lấy dữ liệu 30 ngày gần nhất
            }

            request.setAttribute("groupBy", groupBy);
            request.setAttribute("autoDefaultRange", autoDefaultRange);
            request.setAttribute("from", from);
            request.setAttribute("to", to);

            // Lấy tham số lọc doanh thu theo năm
            String revenueYearParam = request.getParameter("revenueYear");
            Integer revenueYear = null;
            // Kiểm tra điều kiện
            if (revenueYearParam != null && !revenueYearParam.trim().isEmpty()) {
                // Thử thực thi khối lệnh (truy vấn DB hoặc xử lý logic)
                try {
                    revenueYear = Integer.parseInt(revenueYearParam.trim());
                // Bắt và xử lý ngoại lệ xảy ra trong khối try
                } catch (Exception ignored) {
                    // Bỏ qua lỗi chuyển đổi kiểu số, sử dụng giá trị mặc định sau
                }
            }
            // Kiểm tra điều kiện
            if (revenueYear == null) {
                revenueYear = 2026; // Năm mặc định của hệ thống
            }
            request.setAttribute("revenueYear", revenueYear);

            // TRUY VẤN SỐ LIỆU TỪ DATABASE VÀ ĐỔ VÀO VIEW
            request.setAttribute("totalUsers", dashboardDAO.getTotalUsers());
            request.setAttribute("totalProducts", dashboardDAO.getTotalProducts());
            request.setAttribute("totalCategories", dashboardDAO.getTotalCategories());
            request.setAttribute("totalWarrantyClaims", dashboardDAO.getTotalWarrantyClaims());

            request.setAttribute("productsByCategory", dashboardDAO.getProductsByCategory());
            request.setAttribute("lowStockProducts", dashboardDAO.getLowStockProducts());
            request.setAttribute("recentProducts", dashboardDAO.getRecentProducts());

            // LẤY DỮ LIỆU BÁO CÁO DOANH THU & HOẠT ĐỘNG
            request.setAttribute("todayRevenue", dashboardDAO.getTotalRevenue(null, null));
            request.setAttribute("todayOrders", dashboardDAO.getTotalOrderCount());
            request.setAttribute("newCustomersToday", dashboardDAO.getNewCustomers());
            request.setAttribute("pendingAlerts", dashboardDAO.getPendingAlerts());
            request.setAttribute("pendingClaimsList", dashboardDAO.getPendingClaimsList());
            request.setAttribute("allOrders", dashboardDAO.getAllOrdersForDashboard());
            request.setAttribute("pendingTicketsList", dashboardDAO.getPendingTicketsList());

            // Thiết lập các chỉ số doanh thu và tỷ lệ tăng trưởng so với kỳ trước
            java.util.Map<String, Object> revenueStats = dashboardDAO.getRevenueStats();
            for (java.util.Map.Entry<String, Object> entry : revenueStats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            request.setAttribute("monthlyRevenue", dashboardDAO.getRevenueChart(from, to, revenueYear, groupBy));
            request.setAttribute("ordersByStatus", dashboardDAO.getOrdersByStatus());

            // Rankings filters
            String topProductsCriteria = request.getParameter("topProductsCriteria");
            if (topProductsCriteria == null || topProductsCriteria.trim().isEmpty()) {
                topProductsCriteria = "quantity";
            }
            String topProductsTime = request.getParameter("topProductsTime");
            if (topProductsTime == null || topProductsTime.trim().isEmpty()) {
                topProductsTime = "all";
            }
            String topCustomersTime = request.getParameter("topCustomersTime");
            if (topCustomersTime == null || topCustomersTime.trim().isEmpty()) {
                topCustomersTime = "all";
            }

            request.setAttribute("topProductsCriteria", topProductsCriteria);
            request.setAttribute("topProductsTime", topProductsTime);
            request.setAttribute("topCustomersTime", topCustomersTime);

            String[] prodRange = getDateRangeFromTimeframe(topProductsTime);
            String[] custRange = getDateRangeFromTimeframe(topCustomersTime);

            request.setAttribute("topProducts", dashboardDAO.getTopProducts(prodRange[0], prodRange[1], topProductsCriteria));
            request.setAttribute("topCustomers", dashboardDAO.getTopCustomers(custRange[0], custRange[1]));
            request.setAttribute("recentActivities", dashboardDAO.getRecentActivities());

            // Chuyển hướng dữ liệu sang trang JSP AdminDashboard để hiển thị
            request.getRequestDispatcher("/admin/AdminDashboard.jsp")
                    .forward(request, response);

        // Bắt và xử lý ngoại lệ xảy ra trong khối try
        } catch (Exception e) {
            // Bắt lỗi chung của servlet và ném ra lỗi ServletException
            throw new ServletException("Lỗi tải trang Dashboard quản trị.", e);
        }
    }

    private String[] getDateRangeFromTimeframe(String timeframe) {
        if (timeframe == null) {
            return new String[]{null, null};
        }
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate fromDate = null;
        java.time.LocalDate toDate = today;
        switch (timeframe.toLowerCase()) {
            case "today":
                fromDate = today;
                break;
            case "week":
                fromDate = today.minusDays(today.getDayOfWeek().getValue() - 1);
                break;
            case "month":
                fromDate = today.withDayOfMonth(1);
                break;
            case "all":
            default:
                return new String[]{null, null};
        }
        return new String[]{fromDate.toString(), toDate.toString()};
    }
}

package controller;

/**
 * Class: AdminDashboardServlet
 * Description: Controller tiếp nhận yêu cầu, kiểm tra quyền truy cập và tổng hợp
 *              dữ liệu số liệu kinh doanh (KPIs, biểu đồ doanh thu, danh sách vận hành,
 *              top sản phẩm/khách hàng và nhật ký hoạt động) cho trang Dashboard Admin.
 * 
 * Created: 2026-05-31
 * Updated: 2026-07-22
 * Version: v1.5
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
     * Khởi tạo Servlet và khởi tạo đối tượng DAO phục vụ truy vấn dữ liệu Bảng điều khiển.
     */
    @Override
    public void init() {
        dashboardDAO = new AdminDashboardDAO();
    }

    /**
     * Xử lý yêu cầu HTTP GET để tổng hợp các chỉ số thống kê và render trang Admin Dashboard.
     *
     * @param request  đối tượng HttpServletRequest chứa các tham số bộ lọc (from, to, groupBy, revenueYear, topProductsTime, ...)
     * @param response đối tượng HttpServletResponse trả về giao diện HTML/JSP
     * @throws ServletException nếu có lỗi xảy ra trong quá trình xử lý Servlet
     * @throws IOException      nếu có lỗi IO khi chuyển hướng hoặc forward request
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Kiểm tra xác thực phiên đăng nhập của người dùng
            HttpSession session = request.getSession(false);
            Users user = null;

            if (session != null) {
                user = (Users) session.getAttribute("user");
            }

            // Chuyển hướng về trang đăng nhập nếu chưa xác thực
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // 2. Parse và validate khoảng thời gian lọc dữ liệu (from / to)
            String from = request.getParameter("from");
            String to = request.getParameter("to");

            if (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty()) {
                try {
                    java.sql.Date fromDate = java.sql.Date.valueOf(from.trim());
                    java.sql.Date toDate = java.sql.Date.valueOf(to.trim());

                    // BR-50.1.E1: Kiểm tra quy tắc ngày bắt đầu không được lớn hơn ngày kết thúc
                    if (fromDate.after(toDate)) {
                        request.setAttribute("dateError", "Ngày bắt đầu không được sau ngày kết thúc.");
                        from = null;
                        to = null;
                    }
                } catch (Exception e) {
                    // Nếu định dạng ngày không hợp lệ, reset tham số lọc về mặc định
                    from = null;
                    to = null;
                }
            }
            request.setAttribute("todayDate", java.time.LocalDate.now().toString());

            // 3. Xử lý tham số nhóm dữ liệu biểu đồ (ngày, tuần, tháng, quý, năm)
            String groupBy = request.getParameter("groupBy");
            if (groupBy == null || groupBy.trim().isEmpty()) {
                groupBy = "month"; // Mặc định nhóm theo Tháng
            }

            boolean missingRange = (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty());
            boolean autoDefaultRange = "day".equals(groupBy) && missingRange;

            // Tự động thiết lập 30 ngày gần nhất nếu người dùng chọn nhóm theo Ngày nhưng chưa chọn khoảng ngày
            if (autoDefaultRange) {
                java.time.LocalDate today = java.time.LocalDate.now();
                to = today.toString();
                from = today.minusDays(30).toString();
            }

            request.setAttribute("groupBy", groupBy);
            request.setAttribute("autoDefaultRange", autoDefaultRange);
            request.setAttribute("from", from);
            request.setAttribute("to", to);

            // 4. Parse năm lọc doanh thu
            String revenueYearParam = request.getParameter("revenueYear");
            Integer revenueYear = null;
            if (revenueYearParam != null && !revenueYearParam.trim().isEmpty()) {
                try {
                    revenueYear = Integer.parseInt(revenueYearParam.trim());
                } catch (Exception ignored) {
                    // Bỏ qua lỗi ép kiểu, sử dụng năm mặc định của hệ thống
                }
            }
            if (revenueYear == null) {
                revenueYear = 2026; // Năm hệ thống
            }
            request.setAttribute("revenueYear", revenueYear);

            // 5. Truy vấn các chỉ số tổng quan & danh sách báo cáo vận hành
            request.setAttribute("todayOrders", dashboardDAO.getTotalOrderCount());
            request.setAttribute("newCustomersToday", dashboardDAO.getNewCustomers());
            request.setAttribute("pendingAlerts", dashboardDAO.getPendingAlerts());
            request.setAttribute("pendingClaimsList", dashboardDAO.getPendingClaimsList());
            request.setAttribute("allOrders", dashboardDAO.getAllOrdersForDashboard());
            request.setAttribute("pendingTicketsList", dashboardDAO.getPendingTicketsList());

            // 6. Truy vấn chỉ số doanh thu & tỷ lệ tăng trưởng so với kỳ trước
            java.util.Map<String, Object> revenueStats = dashboardDAO.getRevenueStats();
            for (java.util.Map.Entry<String, Object> entry : revenueStats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            // 7. Truy vấn dữ liệu biểu đồ doanh thu & phân bổ đơn hàng theo trạng thái
            request.setAttribute("monthlyRevenue", dashboardDAO.getRevenueChart(from, to, revenueYear, groupBy));
            request.setAttribute("ordersByStatus", dashboardDAO.getOrdersByStatus());

            // 8. Xử lý các bộ lọc thời gian và tiêu chí cho bảng xếp hạng Top Sản phẩm / Khách hàng
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

            // 9. Chuyển hướng render dữ liệu sang giao diện JSP AdminDashboard
            request.getRequestDispatcher("/admin/AdminDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi tải trang Dashboard quản trị.", e);
        }
    }

    /**
     * Phương thức hỗ trợ chuyển đổi từ từ khóa mốc thời gian ("today", "week", "month", "all")
     * sang mảng chuỗi [fromDate, toDate] định dạng YYYY-MM-DD.
     *
     * @param timeframe từ khóa mốc thời gian
     * @return mảng 2 phần tử chứa chuỗi [ngày_bắt_đầu, ngày_kết_thúc]
     */
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

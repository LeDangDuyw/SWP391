package controller;

import dal.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

/**
 * Class: AdminDashboardServlet
 * Description: Servlet điều hướng hiển thị và xử lý dữ liệu cho trang tổng quan quản trị (Admin Dashboard).
 * Bao gồm thống kê doanh thu, đơn hàng, khách hàng mới, sản phẩm sắp hết hàng, biểu đồ và hoạt động gần đây.
 * 
 * Created: 2026-05-20
 * Updated: 2026-07-23
 * Version: v2.2
 *
 * @author DuyLD
 */
public class AdminDashboardServlet extends HttpServlet {


    private AdminDashboardDAO dashboardDAO;

    /**
     * Khởi tạo Servlet và tạo đối tượng AdminDashboardDAO để truy vấn dữ liệu.
     */
    @Override
    public void init() {
        dashboardDAO = new AdminDashboardDAO();
    }

    /**
     * Xử lý yêu cầu GET: Kiểm tra quyền Admin, xử lý bộ lọc khoảng thời gian, nhóm dữ liệu và nạp thống kê lên view.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Kiểm tra xác thực người dùng trong session
            HttpSession session = request.getSession(false);
            Users user = null;
            if (session != null) {
                user = (Users) session.getAttribute("user");
            }

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy khoảng thời gian lọc từ tham số request (from - to)
            String from = request.getParameter("from");
            String to = request.getParameter("to");

            if (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty()) {
                try {
                    java.sql.Date fromDate = java.sql.Date.valueOf(from.trim());
                    java.sql.Date toDate = java.sql.Date.valueOf(to.trim());

                    // Kiểm tra tính hợp lệ của khoảng ngày
                    if (fromDate.after(toDate)) {
                        request.setAttribute("dateError", "Ngày bắt đầu không được sau ngày kết thúc.");
                        from = null;
                        to = null;
                    }
                } catch (Exception e) {
                    // Reset tham số nếu định dạng ngày bị lỗi
                    from = null;
                    to = null;
                }
            }
            request.setAttribute("todayDate", java.time.LocalDate.now().toString());

            // Lấy tham số nhóm dữ liệu biểu đồ (day, week, month)
            String groupBy = request.getParameter("groupBy");
            if (groupBy == null || groupBy.trim().isEmpty()) {
                groupBy = "month"; // Mặc định nhóm theo Tháng
            }

            boolean missingRange = (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty());
            boolean autoDefaultRange = "day".equals(groupBy) && missingRange;

            // Mặc định lấy dữ liệu 30 ngày gần nhất nếu nhóm theo ngày và chưa chọn khoảng thời gian
            if (autoDefaultRange) {
                java.time.LocalDate today = java.time.LocalDate.now();
                to = today.toString();
                from = today.minusDays(30).toString();
            }

            request.setAttribute("groupBy", groupBy);
            request.setAttribute("autoDefaultRange", autoDefaultRange);
            request.setAttribute("from", from);
            request.setAttribute("to", to);

            // Lấy tham số lọc năm doanh thu
            String revenueYearParam = request.getParameter("revenueYear");
            Integer revenueYear = null;
            if (revenueYearParam != null && !revenueYearParam.trim().isEmpty()) {
                try {
                    revenueYear = Integer.parseInt(revenueYearParam.trim());
                } catch (Exception ignored) {
                    // Giữ null để dùng năm mặc định nếu lỗi chuyển đổi
                }
            }
            if (revenueYear == null) {
                revenueYear = 2026; // Năm mặc định của hệ thống
            }
            request.setAttribute("revenueYear", revenueYear);

            // Truy vấn chỉ số tổng quan & sản phẩm sắp hết hàng
            request.setAttribute("lowStockProducts", dashboardDAO.getLowStockProducts());
            request.setAttribute("todayRevenue", dashboardDAO.getTotalRevenue(null, null));
            request.setAttribute("todayOrders", dashboardDAO.getTotalOrderCount());
            request.setAttribute("newCustomersToday", dashboardDAO.getNewCustomers());
            request.setAttribute("pendingAlerts", dashboardDAO.getPendingAlerts());
            request.setAttribute("pendingClaimsList", dashboardDAO.getPendingClaimsList());
            request.setAttribute("allOrders", dashboardDAO.getAllOrdersForDashboard());
            request.setAttribute("pendingTicketsList", dashboardDAO.getPendingTicketsList());

            // Nạp chỉ số tăng trưởng doanh thu so với kỳ trước
            java.util.Map<String, Object> revenueStats = dashboardDAO.getRevenueStats();
            for (java.util.Map.Entry<String, Object> entry : revenueStats.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            // Dữ liệu biểu đồ doanh thu và phân bổ đơn hàng theo trạng thái
            request.setAttribute("monthlyRevenue", dashboardDAO.getRevenueChart(from, to, revenueYear, groupBy));
            request.setAttribute("ordersByStatus", dashboardDAO.getOrdersByStatus());

            // Lọc danh sách Xếp hạng (Top sản phẩm, Top khách hàng)
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

            // Chuyển hướng sang giao diện JSP AdminDashboard
            request.getRequestDispatcher("/admin/AdminDashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi tải trang Dashboard quản trị.", e);
        }
    }

    /**
     * Tính toán khoảng ngày (fromDate, toDate) tương ứng với mốc thời gian lọc (today, week, month, all).
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


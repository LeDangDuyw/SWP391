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
 * AdminDashboardServlet loads dashboard data.
 *
 * URL: /admin/dashboard
 *
 * Version 2.1
 *
 * Date: 18/06/2026
 *
 * Author: DuyLD
 */
public class AdminDashboardServlet extends HttpServlet {

    private AdminDashboardDAO dashboardDAO;


    @Override
    public void init() {
        dashboardDAO = new AdminDashboardDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession(false);

            Users user = null;

            if (session != null) {
                user = (Users) session.getAttribute("user");
            }

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String from = request.getParameter("from");
            String to = request.getParameter("to");

            if (from != null && !from.trim().isEmpty() && to != null && !to.trim().isEmpty()) {
                try {
                    java.sql.Date fromDate = java.sql.Date.valueOf(from.trim());
                    java.sql.Date toDate = java.sql.Date.valueOf(to.trim());
                    if (fromDate.after(toDate)) {
                        request.setAttribute("dateError", "From date cannot be after To date.");
                        from = null;
                        to = null;
                    }
                } catch (Exception e) {
                    from = null;
                    to = null;
                }
            }
            request.setAttribute("todayDate", java.time.LocalDate.now().toString());

            String groupBy = request.getParameter("groupBy");
            if (groupBy == null || groupBy.trim().isEmpty()) {
                groupBy = "month";
            }

            boolean missingRange = (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty());
            boolean autoDefaultRange = "day".equals(groupBy) && missingRange;

            if (autoDefaultRange) {
                java.time.LocalDate today = java.time.LocalDate.now();
                to = today.toString();
                from = today.minusDays(30).toString();
            }

            request.setAttribute("groupBy", groupBy);
            request.setAttribute("autoDefaultRange", autoDefaultRange);
            request.setAttribute("from", from);
            request.setAttribute("to", to);

            String revenueYearParam = request.getParameter("revenueYear");
            Integer revenueYear = null;
            if (revenueYearParam != null && !revenueYearParam.trim().isEmpty()) {
                try {
                    revenueYear = Integer.parseInt(revenueYearParam.trim());
                } catch (Exception ignored) {}
            }
            if (revenueYear == null) {
                revenueYear = 2026; // Default
            }
            request.setAttribute("revenueYear", revenueYear);

            // REAL DATA FROM DATABASE
            request.setAttribute("totalUsers", dashboardDAO.getTotalUsers());
            request.setAttribute("totalProducts", dashboardDAO.getTotalProducts());
            request.setAttribute("totalCategories", dashboardDAO.getTotalCategories());
            request.setAttribute("totalWarrantyClaims", dashboardDAO.getTotalWarrantyClaims());

            request.setAttribute("productsByCategory", dashboardDAO.getProductsByCategory());
            request.setAttribute("lowStockProducts", dashboardDAO.getLowStockProducts());
            request.setAttribute("recentProducts", dashboardDAO.getRecentProducts());

            // REAL ANALYTICS DATA FROM DATABASE
            request.setAttribute("todayRevenue", dashboardDAO.getTotalRevenue(null, null));
            request.setAttribute("todayOrders", dashboardDAO.getTotalOrderCount());
            request.setAttribute("newCustomersToday", dashboardDAO.getNewCustomers());
            request.setAttribute("pendingAlerts", dashboardDAO.getPendingAlerts());
            request.setAttribute("pendingClaimsList", dashboardDAO.getPendingClaimsList());

            request.setAttribute("monthlyRevenue", dashboardDAO.getRevenueChart(from, to, revenueYear, groupBy));
            request.setAttribute("ordersByStatus", dashboardDAO.getOrdersByStatus());
            request.setAttribute("topProducts", dashboardDAO.getTopProducts());
            request.setAttribute("topCustomers", dashboardDAO.getTopCustomers());
            request.setAttribute("recentActivities", dashboardDAO.getRecentActivities());

            request.getRequestDispatcher("/admin/AdminDashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Cannot load admin dashboard", e);
        }
    }
}

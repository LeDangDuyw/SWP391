package controller;

import dal.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;
import service.MockAnalyticsService;

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
    private MockAnalyticsService mockService;

    @Override
    public void init() {
        dashboardDAO = new AdminDashboardDAO();
        mockService = new MockAnalyticsService();
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

            // REAL DATA FROM DATABASE
            request.setAttribute("totalUsers", dashboardDAO.getTotalUsers());
            request.setAttribute("totalProducts", dashboardDAO.getTotalProducts());
            request.setAttribute("totalCategories", dashboardDAO.getTotalCategories());
            request.setAttribute("totalWarrantyClaims", dashboardDAO.getTotalWarrantyClaims());

            request.setAttribute("productsByCategory", dashboardDAO.getProductsByCategory());
            request.setAttribute("lowStockProducts", dashboardDAO.getLowStockProducts());
            request.setAttribute("recentProducts", dashboardDAO.getRecentProducts());

            // ===============================
            // MOCK ANALYTICS DATA
            // Replace later with Order DAO
            // ===============================
            request.setAttribute("todayRevenue", mockService.getTodayRevenue());
            request.setAttribute("todayOrders", mockService.getTodayOrders());
            request.setAttribute("newCustomersToday", mockService.getNewCustomersToday());
            request.setAttribute("pendingAlerts", mockService.getPendingAlerts());

            request.setAttribute("monthlyRevenue", mockService.getMonthlyRevenue());
            request.setAttribute("ordersByStatus", mockService.getOrdersByStatus());
            request.setAttribute("topProducts", mockService.getTopProducts());
            request.setAttribute("topCustomers", mockService.getTopCustomers());
            request.setAttribute("recentActivities", mockService.getRecentActivities());

            request.getRequestDispatcher("/admin/AdminDashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Cannot load admin dashboard", e);
        }
    }
}

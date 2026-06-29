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

            // REAL DATA FROM DATABASE
            request.setAttribute("totalUsers", dashboardDAO.getTotalUsers());
            request.setAttribute("totalProducts", dashboardDAO.getTotalProducts());
            request.setAttribute("totalCategories", dashboardDAO.getTotalCategories());
            request.setAttribute("totalWarrantyClaims", dashboardDAO.getTotalWarrantyClaims());

            request.setAttribute("productsByCategory", dashboardDAO.getProductsByCategory());
            request.setAttribute("lowStockProducts", dashboardDAO.getLowStockProducts());
            request.setAttribute("recentProducts", dashboardDAO.getRecentProducts());

            // REAL ANALYTICS DATA FROM DATABASE
            request.setAttribute("todayRevenue", dashboardDAO.getTotalRevenue());
            request.setAttribute("todayOrders", dashboardDAO.getTotalOrderCount());
            request.setAttribute("newCustomersToday", dashboardDAO.getNewCustomersToday());
            request.setAttribute("pendingAlerts", dashboardDAO.getPendingAlerts());

            request.setAttribute("monthlyRevenue", dashboardDAO.getMonthlyRevenue());
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

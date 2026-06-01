package controller;

import dao.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import model.DashboardSummary;

/**
 * AdminDashboardServlet loads and forwards KPI summary data to the admin dashboard view.
 *
 * Version 1.4
 *
 * Author DuyLD
 */
public class AdminDashboardServlet extends HttpServlet {

    private AdminDashboardDAO dao;

    /**
     * Initializes the AdminDashboardDAO instance used by this servlet.
     */
    @Override
    public void init() {
        dao = new AdminDashboardDAO();
    }

    /**
     * Handles GET requests by loading the dashboard summary and forwarding to the dashboard JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);

            String role = null;
            if (session != null) {
                role = (String) session.getAttribute("role");
            }

            DashboardSummary summary;

            if ("ADMIN".equalsIgnoreCase(role)) {
                summary = dao.getDashboardSummary();
            } else {
                // Default to admin summary for demo; in production restrict access
                summary = dao.getDashboardSummary();
            }

            request.setAttribute("summary", summary);

            request.getRequestDispatcher("/Admin/AdminDashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Cannot load dashboard", e);
        }
    }
}

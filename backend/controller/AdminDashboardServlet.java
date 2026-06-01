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
 * AdminDashboardServlet
 *
 * Purpose: Defines the AdminDashboardServlet component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to AdminDashboardServlet.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class AdminDashboardServlet extends HttpServlet {

    private AdminDashboardDAO dao;

    @Override
    public void init() {
        dao = new AdminDashboardDAO();
    }

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
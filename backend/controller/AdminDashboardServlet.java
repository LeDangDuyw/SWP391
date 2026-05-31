package controller;

import dao.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
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

            request.setAttribute(
                    "summary",
                    dao.getDashboardSummary()
            );

            request.getRequestDispatcher(
                    "/Admin/AdminDashboard.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            throw new ServletException(
                    "Cannot load dashboard", e
            );
        }
    }
}
package controller;

import dal.CategoryDAO;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chat-full")
public class ChatFullController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load categories to populate standard navigation header in chat-full.jsp
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            System.err.println("ChatFullController Exception loading categories: " + e.getMessage());
        }

        // Forward request to the full-screen chat page
        request.getRequestDispatcher("customer/chat-full.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

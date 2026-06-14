package controller;

import dal.CategoryDAO;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Controller xử lý điều hướng tới trang chat lớn toàn màn hình (/chat-full)
 * và chuẩn bị các thông tin cần thiết cho header (danh sách danh mục).
 * 
 * @author Antigravity AI
 * @version 1.0
 */
@WebServlet(name = "ChatFullController", urlPatterns = {"/chat-full"})
public class ChatFullController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load danh mục sản phẩm để hiển thị ở header menu
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            ArrayList<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            System.err.println("ChatFullController Error loading categories: " + e.getMessage());
        }

        // Chuyển tiếp tới trang chat-full.jsp
        request.getRequestDispatcher("customer/chat-full.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

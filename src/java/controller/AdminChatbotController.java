package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.ChatbotDAO;
import model.Users;
import model.ChatbotFeedbackDTO;
import model.ChatbotSecurityLogDTO;

@WebServlet(urlPatterns = {"/admin/chatbot-feedback", "/admin/chatbot-security", "/admin/chatbot-action"})
public class AdminChatbotController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (user.getRoleId() != 1) { // 1 = Admin
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("Access Denied: Bạn không có quyền truy cập trang này!");
            return;
        }

        String path = request.getServletPath();
        ChatbotDAO dao = new ChatbotDAO();

        if ("/admin/chatbot-feedback".equals(path)) {
            // Load danh sách feedback
            List<ChatbotFeedbackDTO> feedbacks = dao.getAllFeedbacks();
            request.setAttribute("feedbacks", feedbacks);
            request.getRequestDispatcher("/admin/chatbotFeedback.jsp").forward(request, response);
            
        } else if ("/admin/chatbot-security".equals(path)) {
            // Load danh sách nhật ký bảo mật
            List<ChatbotSecurityLogDTO> securityLogs = dao.getAllSecurityLogs();
            request.setAttribute("securityLogs", securityLogs);
            request.getRequestDispatcher("/admin/chatbotSecurity.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null || user.getRoleId() != 1) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Không có quyền thực hiện hành động này!\"}");
            return;
        }

        String path = request.getServletPath();
        
        if ("/admin/chatbot-action".equals(path)) {
            String action = request.getParameter("action");
            String userIdStr = request.getParameter("userId");
            String reason = request.getParameter("reason");

            if (userIdStr == null || userIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Thiếu User ID!\"}");
                return;
            }

            try {
                int userId = Integer.parseInt(userIdStr);
                ChatbotDAO dao = new ChatbotDAO();
                boolean success = false;

                if ("block".equalsIgnoreCase(action)) {
                    if (reason == null || reason.isEmpty()) {
                        reason = "Vi phạm an toàn thông tin hoặc spam chatbot";
                    }
                    success = dao.blockUser(userId, reason);
                } else if ("unblock".equalsIgnoreCase(action)) {
                    success = dao.unblockUser(userId);
                }

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (success) {
                    response.getWriter().write("{\"status\": \"success\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\": \"Không thể cập nhật trạng thái người dùng!\"}");
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"User ID không đúng định dạng!\"}");
            }
        }
    }
}

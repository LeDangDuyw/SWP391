package controller;

import dal.StudentVerificationDAO;
import model.StudentVerification;
import model.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;

@WebServlet("/staff/verifications")
public class StaffVerificationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login?error=" + 
                    URLEncoder.encode("Bạn không có quyền truy cập trang này!", "UTF-8"));
            return;
        }

        StudentVerificationDAO svDAO = new StudentVerificationDAO();
        ArrayList<StudentVerification> requestsList = svDAO.getAllRequests();
        
        request.setAttribute("requestsList", requestsList);
        
        // Pass success and error parameters from redirect
        String success = request.getParameter("success");
        if (success != null && !success.trim().isEmpty()) {
            request.setAttribute("successMessage", success);
        }
        String error = request.getParameter("error");
        if (error != null && !error.trim().isEmpty()) {
            request.setAttribute("errorMessage", error);
        }

        request.getRequestDispatcher("/staff/student-verifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login?error=" + 
                    URLEncoder.encode("Bạn không có quyền thực hiện hành động này!", "UTF-8"));
            return;
        }

        String action = request.getParameter("action");
        String verificationIdStr = request.getParameter("verificationId");
        String staffNote = request.getParameter("staffNote");

        if (action == null || verificationIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                    URLEncoder.encode("Yêu cầu không hợp lệ!", "UTF-8"));
            return;
        }

        int verificationId;
        try {
            verificationId = Integer.parseInt(verificationIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                    URLEncoder.encode("ID yêu cầu không hợp lệ!", "UTF-8"));
            return;
        }

        StudentVerificationDAO svDAO = new StudentVerificationDAO();
        boolean success = false;
        
        if ("approve".equalsIgnoreCase(action)) {
            success = svDAO.updateStatus(verificationId, "approved", staffNote);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/verifications?success=" + 
                        URLEncoder.encode("Duyệt yêu cầu xác minh sinh viên thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                        URLEncoder.encode("Duyệt yêu cầu thất bại. Vui lòng thử lại!", "UTF-8"));
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            if (staffNote == null || staffNote.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                        URLEncoder.encode("Vui lòng nhập lý do từ chối!", "UTF-8"));
                return;
            }
            success = svDAO.updateStatus(verificationId, "rejected", staffNote.trim());
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/verifications?success=" + 
                        URLEncoder.encode("Từ chối yêu cầu xác minh sinh viên thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                        URLEncoder.encode("Từ chối yêu cầu thất bại. Vui lòng thử lại!", "UTF-8"));
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/verifications?error=" + 
                    URLEncoder.encode("Hành động không hợp lệ!", "UTF-8"));
        }
    }
}

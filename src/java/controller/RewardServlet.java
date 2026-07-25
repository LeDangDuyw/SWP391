package controller;

import dal.CategoryDAO;
import dal.RewardDAO;
import dal.UserDAO;
import dal.VoucherDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RewardVoucher;
import model.UserVoucherDTO;
import model.Users;

/*
 * Name: RewardServlet.java
 * @Author: LUCTV
 * Date: [24/07/2026]
 * Version: 1.0
 * Description: Servlet xử lý hệ thống đổi điểm thưởng tích lũy lấy Voucher giảm giá.
 */
@WebServlet(name = "RewardServlet", urlPatterns = {"/rewards", "/RewardServlet"})
public class RewardServlet extends HttpServlet {

    /*
     * Name: doGet
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Hiển thị giao diện danh sách các Voucher có thể đổi và danh sách Voucher người dùng đang sở hữu.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users sessionUser = (Users) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        Users freshUser = userDAO.getUserById(sessionUser.getUserId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
            sessionUser = freshUser;
        }

        RewardDAO rewardDAO = new RewardDAO();
        List<RewardVoucher> rewardOptions = rewardDAO.getAvailableRewardVouchers();

        VoucherDAO voucherDAO = new VoucherDAO();
        List<UserVoucherDTO> myVouchers = voucherDAO.getUserVouchers(sessionUser.getUserId());

        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("rewardOptions", rewardOptions);
        request.setAttribute("myVouchers", myVouchers);
        request.setAttribute("userPoints", sessionUser.getRewardPoints());

        request.getRequestDispatcher("customer/rewards.jsp").forward(request, response);
    }

    /*
     * Name: doPost
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Tiếp nhận yêu cầu AJAX để đổi điểm tích lũy lấy Voucher (trừ điểm khách hàng, tạo mã voucher với hạn dùng 30 ngày).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        Users sessionUser = (Users) session.getAttribute("user");
        PrintWriter out = response.getWriter();

        if (sessionUser == null) {
            out.print("{\"status\":\"unauthorized\",\"message\":\"Vui lòng đăng nhập để thực hiện!\"}");
            return;
        }

        String action = request.getParameter("action");
        String rewardVoucherIdStr = request.getParameter("rewardVoucherId");

        if ("redeem".equals(action)) {
            try {
                int rewardVoucherId = Integer.parseInt(rewardVoucherIdStr);
                RewardDAO rewardDAO = new RewardDAO();
                boolean success = rewardDAO.redeemVoucher(sessionUser.getUserId(), rewardVoucherId);

                if (success) {
                    UserDAO userDAO = new UserDAO();
                    Users freshUser = userDAO.getUserById(sessionUser.getUserId());
                    if (freshUser != null) {
                        session.setAttribute("user", freshUser);
                    }
                    int newPoints = (freshUser != null) ? freshUser.getRewardPoints() : 0;
                    out.print("{\"status\":\"success\",\"newPoints\":" + newPoints + ",\"message\":\"Đổi Voucher thành công! Voucher đã được thêm vào Ví ưu đãi của bạn.\"}");
                } else {
                    out.print("{\"status\":\"error\",\"message\":\"Không đủ điểm thưởng hoặc gói ưu đãi không còn khả dụng!\"}");
                }
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"Thông tin gói đổi không hợp lệ!\"}");
            }
            return;
        }

        out.print("{\"status\":\"error\",\"message\":\"Hành động không hợp lệ!\"}");
    }
}

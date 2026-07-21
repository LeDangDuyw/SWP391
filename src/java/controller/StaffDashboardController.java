package controller;

/**
 * Class: StaffDashboardController
 * Description: Controller xử lý truy vấn dữ liệu tổng quan kho, bảo hành, đơn hàng và điều hướng cho Bảng điều khiển Nhân viên (Staff Dashboard).
 * 
 * Created: 2026-07-21
 * Updated: 2026-07-21
 * Version: v1.0
 *
 * @author DuyLD
 */

import dal.AdminDashboardDAO;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StaffDashboardController", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardController extends HttpServlet {

    private AdminDashboardDAO adminDashboardDAO;

    /**
     * Khởi tạo Servlet và đối tượng DAO truy vấn dữ liệu Dashboard.
     */
    @Override
    public void init() throws ServletException {
        adminDashboardDAO = new AdminDashboardDAO();
    }

    /**
     * Xử lý phương thức GET: Lấy các số liệu tổng quan công việc của Staff và chuyển tiếp sang StaffDashboard.jsp
     * 
     * @param request  yêu cầu HTTP chứa dữ liệu đầu vào
     * @param response phản hồi HTTP để trả dữ liệu ra giao diện
     * @throws ServletException nếu có lỗi servlet
     * @throws IOException      nếu có lỗi vào ra dữ liệu
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Thống kê số lượng yêu cầu bảo hành đang chờ xử lý
            List<String[]> pendingClaims = adminDashboardDAO.getPendingClaimsList();
            request.setAttribute("pendingClaimsCount", pendingClaims != null ? pendingClaims.size() : 0);

            // Thống kê số lượng Ticket nhập hàng đang chờ duyệt
            List<String[]> pendingTickets = adminDashboardDAO.getPendingTicketsList();
            request.setAttribute("pendingTicketsCount", pendingTickets != null ? pendingTickets.size() : 0);

            // Lấy danh sách sản phẩm/biến thể sắp hết hàng (Low Stock <= 10)
            List<model.Product> lowStockProducts = adminDashboardDAO.getLowStockProducts();
            request.setAttribute("lowStockProducts", lowStockProducts);

            // Lấy danh sách tất cả đơn hàng để phục vụ ma trận tính toán số lượng đơn theo mốc thời gian trên Client-side JS
            List<String[]> allOrders = adminDashboardDAO.getAllOrdersForDashboard();
            request.setAttribute("allOrders", allOrders);

            // Điều hướng người dùng tới trang View StaffDashboard.jsp
            request.getRequestDispatcher("/staff/StaffDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("StaffDashboardController error: " + e.getMessage());
            request.getRequestDispatcher("/staff/StaffDashboard.jsp").forward(request, response);
        }
    }
}

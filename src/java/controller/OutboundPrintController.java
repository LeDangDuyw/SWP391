/*
 * Name: OutboundPrintController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc xem và in phiếu xuất kho (Delivery Slip) cho đơn hàng.
 */
package controller;

import dal.OutboundDAO;
import model.InventoryItem;
import model.Order;
import model.OrderDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OutboundPrintController", urlPatterns = {"/staff/outbound/print"})
public class OutboundPrintController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Lấy thông tin chi tiết và hiển thị màn hình in phiếu xuất kho (Delivery Slip).
     * Chỉ những đơn hàng đã qua bước gán Serial và ở trạng thái Shipped, Delivered hoặc Completed mới được in phiếu.
     * Quá trình xử lý:
     * 1. Kiểm tra trạng thái đơn hàng.
     * 2. Lấy danh sách sản phẩm (OrderDetail) cùng với các mã Serial (InventoryItem) đã gán.
     * 3. Truyền dữ liệu sang giao diện JSP (DeliverySlip.jsp) để hỗ trợ in ấn.
     * 
     * @param request  đối tượng HttpServletRequest chứa orderId
     * @param response đối tượng HttpServletResponse điều hướng về trang in phiếu
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            OutboundDAO dao = new OutboundDAO();
            Order order = dao.getOrderById(orderId);
            
            if (order == null || (!"shipped".equals(order.getOrderStatus()) && !"delivered".equals(order.getOrderStatus()) && !"Completed".equals(order.getOrderStatus()))) {
                request.setAttribute("error", "Đơn hàng không tồn tại hoặc chưa được xuất kho.");
                request.getRequestDispatcher("/staff/outbound/list").forward(request, response);
                return;
            }

            List<OrderDetail> details = dao.getOrderDetails(orderId);
            for (OrderDetail detail : details) {
                List<InventoryItem> assignedItems = dao.getAssignedSerialsForOrderDetail(detail.getOrderDetailId());
                detail.setAssignedItems(assignedItems);
            }

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            
            request.getRequestDispatcher("/staff/outbound/DeliverySlip.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
        }
    }
}

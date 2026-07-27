/*
 * Name: StaffOrderDetailController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị thông tin chi tiết đơn hàng xuất kho dành cho nhân viên.
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
@WebServlet(name = "StaffOrderDetailController", urlPatterns = {"/staff/order/detail"})
public class StaffOrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/order/list");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OutboundDAO dao = new OutboundDAO();
            Order order = dao.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/staff/order/list");
                return;
            }

            List<OrderDetail> details = dao.getOrderDetails(orderId);
            boolean hasAssignedItems = false;
            if (details != null) {
                for (OrderDetail detail : details) {
                    List<InventoryItem> assignedItems = dao.getAssignedSerialsForOrderDetail(detail.getOrderDetailId());
                    detail.setAssignedItems(assignedItems);
                    if (assignedItems != null && !assignedItems.isEmpty()) {
                        hasAssignedItems = true;
                    }
                }
            }
            order.setDetails(details);

            List<model.OrderLog> logs = dao.getOrderLogs(orderId);
            request.setAttribute("order", order);
            request.setAttribute("logs", logs);
            request.setAttribute("hasAssignedItems", hasAssignedItems);
            request.getRequestDispatcher("/staff/order/OrderDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/order/list");
        }
    }
}

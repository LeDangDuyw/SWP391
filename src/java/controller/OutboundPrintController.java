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

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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OutboundFulfillController", urlPatterns = {"/staff/outbound/fulfill"})
public class OutboundFulfillController extends HttpServlet {

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
            if (order == null || (!"pending".equalsIgnoreCase(order.getOrderStatus()) && !"processing".equalsIgnoreCase(order.getOrderStatus()))) {
                request.setAttribute("error", "Đơn hàng không hợp lệ hoặc đã được xử lý.");
                request.getRequestDispatcher("/staff/outbound/list").forward(request, response);
                return;
            }

            List<OrderDetail> details = dao.getOrderDetails(orderId);
            
            // Lấy danh sách IMEI có sẵn cho từng Variant
            Map<Integer, List<InventoryItem>> availableImeisMap = new HashMap<>();
            for (OrderDetail detail : details) {
                if (!availableImeisMap.containsKey(detail.getVariantId())) {
                    availableImeisMap.put(detail.getVariantId(), dao.getAvailableImeisForVariant(detail.getVariantId()));
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("availableImeisMap", availableImeisMap);
            
            request.getRequestDispatcher("/staff/outbound/OrderFulfillment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("orderId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            OutboundDAO dao = new OutboundDAO();
            List<OrderDetail> details = dao.getOrderDetails(orderId);
            
            Map<Integer, List<Integer>> orderDetailToItemIds = new HashMap<>();
            
            for (OrderDetail detail : details) {
                String[] selectedItemIds = request.getParameterValues("detail_" + detail.getOrderDetailId());
                if (selectedItemIds == null || selectedItemIds.length != detail.getQuantity()) {
                    // Trở lại trang và báo lỗi
                    request.setAttribute("error", "Bạn chưa chọn đủ số lượng IMEI cho sản phẩm: " + detail.getVariantName());
                    doGet(request, response);
                    return;
                }
                
                List<Integer> itemIds = new ArrayList<>();
                for (String itemIdStr : selectedItemIds) {
                    itemIds.add(Integer.parseInt(itemIdStr));
                }
                orderDetailToItemIds.put(detail.getOrderDetailId(), itemIds);
            }
            
            // Execute Transaction
            try {
                boolean success = dao.executeOutboundTransaction(orderId, orderDetailToItemIds);
                if (success) {
                    // Redirect sang trang in phiếu
                    response.sendRedirect(request.getContextPath() + "/staff/outbound/print?orderId=" + orderId);
                } else {
                    request.setAttribute("error", "Lỗi trong quá trình xuất kho.");
                    doGet(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
        }
    }
}

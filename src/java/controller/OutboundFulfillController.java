/*
 * Name: OutboundFulfillController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc gán mã Serial và hoàn tất thủ tục xuất kho cho đơn hàng.
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OutboundFulfillController", urlPatterns = {"/staff/outbound/fulfill"})
public class OutboundFulfillController extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET: Hiển thị giao diện xuất kho (Fulfillment) cho một đơn hàng cụ thể.
     * Hàm này load chi tiết đơn hàng, danh sách các sản phẩm cần xuất và đồng thời truy xuất
     * danh sách các mã Serial (InventoryItem) đang có sẵn (in_stock) cho từng sản phẩm đó để nhân viên chọn.
     * 
     * @param request  đối tượng HttpServletRequest chứa orderId
     * @param response đối tượng HttpServletResponse điều hướng tới OrderFulfillment.jsp
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
            if (order == null || !"processing".equalsIgnoreCase(order.getOrderStatus())) {
                request.setAttribute("error", "Đơn hàng chưa được xác nhận hoặc không ở trạng thái sẵn sàng xuất kho.");
                request.getRequestDispatcher("/staff/outbound/list").forward(request, response);
                return;
            }

            boolean isStorePickup = "STORE_PICKUP".equalsIgnoreCase(order.getShippingMethod())
                    || (order.getShippingAddress() != null && order.getShippingAddress().contains("Nhận tại cửa hàng"));

            if (!isStorePickup && (order.getTrackingNumber() == null || order.getTrackingNumber().trim().isEmpty())) {
                request.getSession().setAttribute("error", "Đơn hàng giao tận nơi phải được Tạo mã vận đơn trước khi tiến hành Xuất kho!");
                response.sendRedirect(request.getContextPath() + "/staff/order/detail?orderId=" + orderId);
                return;
            }

            List<OrderDetail> details = dao.getOrderDetails(orderId);
            
            // Lấy danh sách Serial có sẵn cho từng Variant
            Map<Integer, List<InventoryItem>> availableSerialsMap = new HashMap<>();
            for (OrderDetail detail : details) {
                if (!availableSerialsMap.containsKey(detail.getVariantId())) {
                    availableSerialsMap.put(detail.getVariantId(), dao.getAvailableSerialsForVariant(detail.getVariantId()));
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("availableSerialsMap", availableSerialsMap);
            request.setAttribute("availableImeisMap", availableSerialsMap);
            
            request.getRequestDispatcher("/staff/outbound/OrderFulfillment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
        }
    }

    /**
     * Xử lý yêu cầu HTTP POST: Thực hiện gán mã Serial cho các sản phẩm trong đơn hàng và chốt xuất kho.
     * Các bước thực hiện:
     * 1. Lấy thông tin orderId và danh sách các mã Serial do nhân viên chọn cho từng dòng sản phẩm.
     * 2. Kiểm tra xem nhân viên đã chọn ĐỦ số lượng Serial yêu cầu cho mỗi sản phẩm chưa.
     * 3. Gọi OutboundDAO thực hiện transaction: Ghi nhận OrderItem (mapping Serial - Đơn hàng) và chuyển trạng thái Serial thành "sold".
     * 4. Cập nhật trạng thái đơn hàng thành "shipped" (đã xuất kho, chờ giao) hoặc hoàn tất.
     * 
     * @param request  đối tượng HttpServletRequest chứa form data chọn Serial
     * @param response đối tượng HttpServletResponse điều hướng sau khi xuất kho thành công
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ĐOẠN 1: Đọc orderId từ Form Xuất kho [/staff/outbound/fulfill]
        String idStr = request.getParameter("orderId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/outbound/list");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            // ĐOẠN 2: Truy vấn danh sách dòng đơn hàng từ DAO [dal/OutboundDAO.java: getOrderDetails()]
            OutboundDAO dao = new OutboundDAO();
            Order order = dao.getOrderById(orderId);

            if (order != null) {
                boolean isStorePickup = "STORE_PICKUP".equalsIgnoreCase(order.getShippingMethod())
                        || (order.getShippingAddress() != null && order.getShippingAddress().contains("Nhận tại cửa hàng"));

                if (!isStorePickup && (order.getTrackingNumber() == null || order.getTrackingNumber().trim().isEmpty())) {
                    request.setAttribute("error", "Đơn hàng giao tận nơi phải có Mã vận đơn mới được phép Xuất kho!");
                    doGet(request, response);
                    return;
                }
            }

            List<OrderDetail> details = dao.getOrderDetails(orderId);
            
            Map<Integer, List<Integer>> orderDetailToItemIds = new HashMap<>();
            
            // ĐOẠN 3: Bóc tách danh sách Checkbox itemId thủ kho tích chọn cho từng dòng đơn
            // Nhiệm vụ: Đọc parameter dạng detail_{orderDetailId} gửi từ giao diện [web/staff/outbound/OrderFulfillment.jsp]
            for (OrderDetail detail : details) {
                String[] selectedItemIds = request.getParameterValues("detail_" + detail.getOrderDetailId());
                
                // Bắt lỗi nếu số lượng máy tích chọn không bằng đúng số lượng khách mua (detail.getQuantity())
                if (selectedItemIds == null || selectedItemIds.length != detail.getQuantity()) {
                    request.setAttribute("error", "Bạn chưa chọn đủ số lượng Serial cho sản phẩm: " + detail.getVariantName());
                    doGet(request, response);
                    return;
                }
                
                List<Integer> itemIds = new ArrayList<>();
                for (String itemIdStr : selectedItemIds) {
                    itemIds.add(Integer.parseInt(itemIdStr));
                }
                orderDetailToItemIds.put(detail.getOrderDetailId(), itemIds);
            }
            
            // ĐOẠN 4: Thực thi Database Transaction Xuất Kho Atomic 4 Bước
            // Tham chiếu: Gọi executeOutboundTransaction() tại [dal/OutboundDAO.java] để đổi status máy thành 'sold', kích hoạt bảo hành, trừ kho khả dụng và đổi order status thành 'shipped'
            try {
                boolean success = dao.executeOutboundTransaction(orderId, orderDetailToItemIds);
                if (success) {
                    // Chuyển hướng sang Servlet in phiếu xuất kho [/staff/outbound/print] rendering [web/staff/outbound/DeliverySlip.jsp]
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

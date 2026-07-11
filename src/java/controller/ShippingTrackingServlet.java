package controller;

import dal.OutboundDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

@WebServlet(name = "ShippingTrackingServlet", urlPatterns = {"/api/shipping-tracking"})
public class ShippingTrackingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String trackingNumber = request.getParameter("trackingNumber");
        String status = request.getParameter("status"); 
        
        PrintWriter out = response.getWriter();
        
        if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
            out.print("[]");
            return;
        }
        
        StringBuilder json = new StringBuilder("[");
        
        json.append("{\"time\": \"10/07/2026 09:15\", \"location\": \"Hệ thống UNILAP\", \"status\": \"Đã tạo mã yêu cầu vận đơn Viettel Post thành công.\"},");
        json.append("{\"time\": \"10/07/2026 11:30\", \"location\": \"Bưu cục Viettel Post Hoài Đức\", \"status\": \"Nhân viên bưu tá Viettel Post đã lấy hàng thành công từ kho UNILAP.\"},");
        json.append("{\"time\": \"10/07/2026 16:45\", \"location\": \"Trung tâm trung chuyển Hà Nội\", \"status\": \"Hàng đã nhập kho chia chọn Hà Nội, đang tiến hành phân loại.\"}");
        
        if ("shipped".equalsIgnoreCase(status)) {
            json.append(",{\"time\": \"10/07/2026 21:00\", \"location\": \"Xe tải liên tỉnh Viettel Post\", \"status\": \"Đang vận chuyển liên tỉnh đến địa phương nhận.\"}");
        } else if ("delivered".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
            json.append(",{\"time\": \"10/07/2026 21:00\", \"location\": \"Xe tải liên tỉnh Viettel Post\", \"status\": \"Đang vận chuyển liên tỉnh đến địa phương nhận.\"},");
            json.append("{\"time\": \"11/07/2026 07:30\", \"location\": \"Bưu cục phát Viettel Post\", \"status\": \"Đã nhập bưu cục phát địa phương. Đang bàn giao cho bưu tá giao hàng.\"},");
            json.append("{\"time\": \"11/07/2026 08:45\", \"location\": \"Bưu tá phát\", \"status\": \"Bưu tá đang đi giao hàng đến người nhận.\"},");
            json.append("{\"time\": \"11/07/2026 10:30\", \"location\": \"Người nhận\", \"status\": \"Giao hàng thành công. Trạng thái: Đã ký nhận.\"}");
        } else if ("cancelled".equalsIgnoreCase(status) || "Cancelled".equalsIgnoreCase(status)) {
            json.append(",{\"time\": \"10/07/2026 21:00\", \"location\": \"Xe tải liên tỉnh Viettel Post\", \"status\": \"Đang vận chuyển liên tỉnh.\"},");
            json.append("{\"time\": \"11/07/2026 09:00\", \"location\": \"Bưu cục phát\", \"status\": \"Khách hàng từ chối nhận hàng hoặc bưu gửi hoàn trả. Đang tiến hành chuyển hoàn bưu gửi cho UNILAP.\"}");
        }
        
        json.append("]");
        out.print(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        String orderIdStr = request.getParameter("orderId");
        PrintWriter out = response.getWriter();
        
        if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                OutboundDAO dao = new OutboundDAO();
                Order order = dao.getOrderById(orderId);
                
                if (order != null) {
                    Random rnd = new Random();
                    long number = 100000000L + (long)(rnd.nextDouble() * 900000000L);
                    String trackingNumber = "VTP" + number;
                    
                    boolean success = dao.updateShippingDetails(orderId, "Viettel Post", trackingNumber);
                    if (success) {
                        out.print("{\"success\": true, \"partner\": \"Viettel Post\", \"trackingNumber\": \"" + trackingNumber + "\"}");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        out.print("{\"success\": false}");
    }
}

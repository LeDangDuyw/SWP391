/*
 * Name: ShippingAutoTracker
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Dịch vụ tự động theo dõi và cập nhật trạng thái đơn hàng/giao hàng (API simulation)
 */
package service;

import dal.OutboundDAO;
import model.Order;
import model.OrderDetail;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class ShippingAutoTracker implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        
        // Poll every 30 seconds to automatically track shipped orders and complete/deliver them
        scheduler.scheduleAtFixedRate(() -> {
            try {
                String realPath = sce.getServletContext().getRealPath("/invoices");
                if (realPath == null) {
                    realPath = new File(sce.getServletContext().getRealPath("/"), "invoices").getAbsolutePath();
                }
                final String finalRealPath = realPath;

                OutboundDAO dao = new OutboundDAO();
                List<Order> history = dao.getOutboundHistory();
                for (Order order : history) {
                    if ("shipped".equalsIgnoreCase(order.getOrderStatus()) && order.getTrackingNumber() != null) {
                        System.out.println("[AutoTracker] Tracking waybill: " + order.getTrackingNumber() + " for Order: " + order.getOrderCode());
                        
                        String oldStatus = order.getOrderStatus();
                        String newStatus = "delivered";
                        
                        boolean ok = dao.updateOrderStatus(order.getOrderId(), newStatus);
                        if (ok) {
                            Order updatedOrder = dao.getOrderById(order.getOrderId());
                            List<OrderDetail> details = dao.getOrderDetails(order.getOrderId());
                            updatedOrder.setDetails(details);
                            
                            dao.addOrderLog(order.getOrderId(), oldStatus, newStatus, "System (Viettel Post Auto-Tracker)", 
                                           "Đơn hàng giao thành công. Hành trình Viettel Post xác nhận đã ký nhận.");
                            
                            String fileName = PdfInvoiceService.generateInvoice(updatedOrder, finalRealPath);
                            String dbInvoicePath = "invoices/" + fileName;
                            
                            String customerEmail = dao.getCustomerEmailByUserId(updatedOrder.getUserId());
                            int emailSentStatus = 0; 
                            
                            if (customerEmail != null && !customerEmail.trim().isEmpty()) {
                                File pdfFile = new File(finalRealPath, fileName);
                                boolean emailSent = EmailService.sendInvoiceEmail(customerEmail, updatedOrder.getOrderCode(), pdfFile);
                                if (emailSent) {
                                    emailSentStatus = 1; 
                                    dao.addOrderLog(updatedOrder.getOrderId(), newStatus, newStatus, "System (Email Service)", 
                                                   "Đã gửi hóa đơn điện tử thành công đến email: " + customerEmail);
                                } else {
                                    emailSentStatus = 2; 
                                    dao.addOrderLog(updatedOrder.getOrderId(), newStatus, newStatus, "System (Email Service)", 
                                                   "Gửi email hóa đơn thất bại đến email: " + customerEmail + " (Lỗi xác thực SMTP/Kết nối)");
                                }
                            } else {
                                dao.addOrderLog(updatedOrder.getOrderId(), newStatus, newStatus, "System (Email Service)", 
                                               "Không tìm thấy email khách hàng để gửi hóa đơn.");
                            }
                            
                            dao.updateInvoiceDetails(updatedOrder.getOrderId(), dbInvoicePath, emailSentStatus);
                            System.out.println("[AutoTracker] Completed Order: " + updatedOrder.getOrderCode() + ". Invoice generated at: " + dbInvoicePath);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("[AutoTracker] Error: " + e.getMessage());
                e.printStackTrace();
            }
        }, 15, 30, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }
}

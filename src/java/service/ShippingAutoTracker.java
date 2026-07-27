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

// Disabled ShippingAutoTracker: Staff will manually confirm delivery in UI
public class ShippingAutoTracker implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Auto-tracker background service disabled per business requirements.
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}

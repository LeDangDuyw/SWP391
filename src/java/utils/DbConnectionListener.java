package utils;

import dal.DBContext;
import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.annotation.WebListener;

/*
 * Name: DbConnectionListener
 * @Author: LUCTV
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Listener tự động giải phóng kết nối cơ sở dữ liệu (ThreadLocal Connection) 
 * của request hiện tại sau khi servlet xử lý xong yêu cầu HTTP, tránh rò rỉ kết nối.
 */
@WebListener
public class DbConnectionListener implements ServletRequestListener {

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        // Không cần khởi tạo gì trước, connection sẽ được tạo lười (lazy) khi DAO gọi
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        // Tự động đóng kết nối ThreadLocal khi kết thúc luồng Request
        DBContext.closeThreadConnection();
    }
}

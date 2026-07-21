/*
 * Name: StaffOrderListController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller hiển thị danh sách các đơn hàng xuất kho dành cho nhân viên quản lý.
 */
package controller;

import dal.OutboundDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
@WebServlet(name = "StaffOrderListController", urlPatterns = {"/staff/order/list"})
public class StaffOrderListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        OutboundDAO dao = new OutboundDAO();
        List<Order> orders = dao.getAllOrders();
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/staff/order/ManageOrders.jsp").forward(request, response);
    }
}

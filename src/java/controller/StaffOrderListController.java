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

/*
 * Name: StaffOrderListController
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Servlet hiển thị danh sách đơn hàng để nhân viên quản lý (Staff Order Management)
 */
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

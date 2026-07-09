/*
 * Name: CreateTicketController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 2.0
 * Description: Controller xử lý việc tạo phiếu yêu cầu nhập kho (Import Ticket) từ nhân viên.
 *              Hỗ trợ chọn sản phẩm và nhập số lượng/giá cho từng biến thể.
 */
package controller;

import dal.ProductDAO;
import dal.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductVariant;
import model.Ticket;
import model.TicketDetail;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CreateTicketController", urlPatterns = {"/staff/ticket/create"})
public class CreateTicketController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorParam = request.getParameter("error");
        if (errorParam != null) {
            String errorMsg = "";
            switch (errorParam) {
                case "MissingRequiredFields":
                    errorMsg = "Vui lòng điền đầy đủ các trường thông tin bắt buộc.";
                    break;
                case "NoVariantsSelected":
                    errorMsg = "Vui lòng nhập số lượng (> 0) cho ít nhất một biến thể.";
                    break;
                default:
                    errorMsg = "Đã xảy ra lỗi không xác định.";
            }
            request.setAttribute("error", errorMsg);
        }
        ProductDAO productDao = new ProductDAO();
        List<Product> products = productDao.GetAllProducts();
        List<ProductVariant> variants = productDao.getAllVariants();
        request.setAttribute("products", products);
        request.setAttribute("variants", variants);
        request.getRequestDispatcher("/staff/ticket/CreateTicket.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String title = request.getParameter("title");
        String[] variantIds = request.getParameterValues("variantId");
        String[] quantities = request.getParameterValues("quantity");
        String[] expectedPrices = request.getParameterValues("expectedPrice");
        
        // Lấy user ID từ session
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        int createdBy = (user != null) ? user.getUserId() : 1;

        if (title == null || title.trim().isEmpty() || variantIds == null || variantIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/create?error=MissingRequiredFields");
            return;
        }

        List<TicketDetail> details = new ArrayList<>();
        for (int i = 0; i < variantIds.length; i++) {
            try {
                if (quantities == null || i >= quantities.length || quantities[i] == null || quantities[i].trim().isEmpty()) {
                    continue;
                }
                int variantId = Integer.parseInt(variantIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                
                // Bỏ qua các dòng variant có số lượng bằng 0 hoặc nhỏ hơn 0
                if (quantity <= 0) {
                    continue;
                }
                
                BigDecimal expectedPrice = BigDecimal.ZERO;
                if (expectedPrices != null && i < expectedPrices.length && expectedPrices[i] != null && !expectedPrices[i].trim().isEmpty()) {
                    expectedPrice = new BigDecimal(expectedPrices[i].trim());
                }

                TicketDetail detail = new TicketDetail();
                detail.setVariantId(variantId);
                detail.setQuantity(quantity);
                detail.setExpectedPrice(expectedPrice);
                details.add(detail);
            } catch (NumberFormatException e) {
                // bỏ qua dòng định dạng số không hợp lệ
            }
        }

        if (details.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/create?error=NoVariantsSelected");
            return;
        }

        Ticket ticket = new Ticket();
        ticket.setTitle(title);
        ticket.setStatus("WAITING_FOR_ADMIN_REVIEW");
        ticket.setReason("");
        ticket.setCreatedBy(createdBy);

        TicketDAO ticketDao = new TicketDAO();
        ticketDao.createTicket(ticket, details);

        response.sendRedirect(request.getContextPath() + "/staff/ticket/list?success=TicketCreated");
    }
}

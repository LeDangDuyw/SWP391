package controller;

import dal.ProductDAO;
import dal.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        ProductDAO productDao = new ProductDAO();
        List<ProductVariant> variants = productDao.getAllVariants();
        request.setAttribute("variants", variants);
        request.getRequestDispatcher("/staff/ticket/CreateTicket.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String[] variantIds = request.getParameterValues("variantId");
        String[] quantities = request.getParameterValues("quantity");
        String[] expectedPrices = request.getParameterValues("expectedPrice");
        
        // Default staff ID to 1 for now, replace with session user ID later
        int createdBy = 1;

        if (title == null || title.trim().isEmpty() || variantIds == null || variantIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/staff/ticket/create?error=MissingRequiredFields");
            return;
        }

        ProductDAO productDao = new ProductDAO();
        List<TicketDetail> details = new ArrayList<>();
        for (int i = 0; i < variantIds.length; i++) {
            int variantId = Integer.parseInt(variantIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            BigDecimal expectedPrice = (expectedPrices != null && i < expectedPrices.length && !expectedPrices[i].isEmpty()) 
                                        ? new BigDecimal(expectedPrices[i]) 
                                        : BigDecimal.ZERO;

            model.ProductVariant variant = productDao.getVariantById(variantId);
            if (variant != null && expectedPrice.compareTo(variant.getImportPrice()) > 0) {
                request.setAttribute("error", "Giá nhập dự kiến cho sản phẩm " + variant.getSku() + " - " + variant.getVariantName() + " ($" + expectedPrice + ") không được lớn hơn giá nhập cố định ($" + variant.getImportPrice() + ")!");
                request.setAttribute("variants", productDao.getAllVariants());
                request.setAttribute("title", title);
                request.setAttribute("selectedVariantId", variantId);
                request.setAttribute("quantity", quantity);
                request.setAttribute("expectedPrice", expectedPrice);
                request.getRequestDispatcher("/staff/ticket/CreateTicket.jsp").forward(request, response);
                return;
            }

            TicketDetail detail = new TicketDetail();
            detail.setVariantId(variantId);
            detail.setQuantity(quantity);
            detail.setExpectedPrice(expectedPrice);
            details.add(detail);
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

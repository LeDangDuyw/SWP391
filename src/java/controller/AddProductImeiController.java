package controller;

import dal.ImeiDAO;
import dal.ProductDAO;
import dal.TicketDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryItem;
import model.Product;
import model.ProductVariant;
import model.TicketDetail;

@WebServlet(name = "AddProductImeiController", urlPatterns = {"/staff/imei/add"})
public class AddProductImeiController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDao = new ProductDAO();
        List<Product> products = productDao.GetAllProducts();
        List<ProductVariant> variants = productDao.getAllVariants();
        
        request.setAttribute("products", products);
        request.setAttribute("variants", variants);
        
        String ticketIdStr = request.getParameter("ticketId");
        String variantIdStr = request.getParameter("variantId");
        if (ticketIdStr != null && !ticketIdStr.trim().isEmpty() && variantIdStr != null && !variantIdStr.trim().isEmpty()) {
            try {
                int ticketId = Integer.parseInt(ticketIdStr.trim());
                int variantId = Integer.parseInt(variantIdStr.trim());
                TicketDAO ticketDao = new TicketDAO();
                List<TicketDetail> details = ticketDao.getTicketDetails(ticketId);
                for (TicketDetail td : details) {
                    if (td.getVariantId() == variantId) {
                        request.setAttribute("expectedQuantity", td.getQuantity());
                        break;
                    }
                }
                
                for (ProductVariant v : variants) {
                    if (v.getVariantId() == variantId) {
                        request.setAttribute("selectedVariant", v);
                        for (Product p : products) {
                            if (p.getProductId() == v.getProductId()) {
                                request.setAttribute("selectedProduct", p);
                                break;
                            }
                        }
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("/staff/AddProductImei.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String variantIdStr = request.getParameter("variantId");
        String serialsStr = request.getParameter("serials");
        String serialNumbersStr = request.getParameter("serialNumbers");
        String barcodesStr = request.getParameter("barcodes");
        String warehouseLocation = request.getParameter("warehouseLocation");
        String receivedDate = request.getParameter("receivedDate");
        String initialStatus = request.getParameter("initialStatus");
        String ticketIdStr = request.getParameter("ticketId");
        
        if (variantIdStr == null || variantIdStr.trim().isEmpty() ||
            serialsStr == null || serialsStr.trim().isEmpty() ||
            serialNumbersStr == null || serialNumbersStr.trim().isEmpty() ||
            barcodesStr == null || barcodesStr.trim().isEmpty() ||
            ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields");
            return;
        }
        
        int variantId = Integer.parseInt(variantIdStr.trim());
        int ticketId = Integer.parseInt(ticketIdStr.trim());
        String[] imeis = serialsStr.split("\\r?\\n");
        String[] serialNumbers = serialNumbersStr.split("\\r?\\n");
        String[] barcodes = barcodesStr.split("\\r?\\n");
        
        TicketDAO ticketDao = new TicketDAO();
        List<model.TicketDetail> details = ticketDao.getTicketDetails(ticketId);
        int expectedQuantity = -1;
        for (model.TicketDetail td : details) {
            if (td.getVariantId() == variantId) {
                expectedQuantity = td.getQuantity();
                break;
            }
        }

        List<String> validImeis = new ArrayList<>();
        for (String s : imeis) if (!s.trim().isEmpty()) validImeis.add(s.trim());
        
        List<String> validSerials = new ArrayList<>();
        for (String s : serialNumbers) if (!s.trim().isEmpty()) validSerials.add(s.trim());
        
        List<String> validBarcodes = new ArrayList<>();
        for (String s : barcodes) if (!s.trim().isEmpty()) validBarcodes.add(s.trim());

        if (validImeis.size() != validSerials.size() || validImeis.size() != validBarcodes.size()) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId=" + variantId + "&error=MismatchLists");
            return;
        }

        if (expectedQuantity != -1 && validImeis.size() != expectedQuantity) {
            if (validImeis.size() > expectedQuantity) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId=" + variantId + "&error=TooManyImeis&expected=" + expectedQuantity + "&actual=" + validImeis.size());
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId=" + variantId + "&error=TooFewImeis&expected=" + expectedQuantity + "&actual=" + validImeis.size());
            }
            return;
        }

        LocalDate warrantyExpiredDate = null;
        if (receivedDate != null && !receivedDate.isEmpty()) {
            LocalDate importDate = LocalDate.parse(receivedDate);
            warrantyExpiredDate = importDate.plusWeeks(2);
        }
        
        List<InventoryItem> items = new ArrayList<>();
        for (int i = 0; i < validImeis.size(); i++) {
            InventoryItem item = new InventoryItem();
            item.setVariantId(variantId);
            item.setImei(validImeis.get(i));
            item.setSerialNumber(validSerials.get(i));
            item.setBarcode(validBarcodes.get(i));
            item.setStatus(initialStatus);
            item.setImportDate(receivedDate);
            item.setWarrantyExpiredDate(warrantyExpiredDate);
            item.setWarehouseLocation(warehouseLocation);
            item.setTicketId(ticketId);
            items.add(item);
        }
        
        ImeiDAO imeiDao = new ImeiDAO();
        imeiDao.insertInventoryItems(items);
        
        // Update ticket status to COMPLETED and sync import_price
        ticketDao.updateTicketStatus(ticketId, "COMPLETED", "Stock received and IMEIs registered");
        // ticketDao.updateImportPriceFromTicket(ticketId); // Không tự động cập nhật import_price nữa vì nó là giá cố định
        
        response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId + "&success=InboundCompleted");
    }
}

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
        String ticketIdStr = request.getParameter("ticketId");
        String variantIdStr = request.getParameter("variantId");
        
        ProductDAO productDao = new ProductDAO();
        TicketDAO ticketDao = new TicketDAO();
        
        if (ticketIdStr != null && !ticketIdStr.trim().isEmpty() &&
            variantIdStr != null && !variantIdStr.trim().isEmpty()) {
            
            try {
                int ticketId = Integer.parseInt(ticketIdStr.trim());
                int variantId = Integer.parseInt(variantIdStr.trim());
                
                List<model.TicketDetail> details = ticketDao.getTicketDetails(ticketId);
                int expectedQuantity = -1;
                for (model.TicketDetail td : details) {
                    if (td.getVariantId() == variantId) {
                        expectedQuantity = td.getQuantity();
                        break;
                    }
                }
                
                model.ProductVariant selectedVariant = productDao.getVariantById(variantId);
                model.Product selectedProduct = null;
                if (selectedVariant != null) {
                    selectedProduct = productDao.getProductByVariantId(variantId);
                }
                
                request.setAttribute("ticketId", ticketId);
                request.setAttribute("expectedQuantity", expectedQuantity);
                request.setAttribute("selectedVariant", selectedVariant);
                request.setAttribute("selectedProduct", selectedProduct);
                
            } catch (NumberFormatException e) {
                // Ignore parse errors, fall back to normal
            }
        }
        
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
        String[] imeis = request.getParameterValues("imeis");
        String[] serialNumbers = request.getParameterValues("serialNumbers");
        String[] barcodes = request.getParameterValues("barcodes");
        String warehouseLocation = request.getParameter("warehouseLocation");
        String receivedDate = request.getParameter("receivedDate");
        String initialStatus = request.getParameter("initialStatus");
        String ticketIdStr = request.getParameter("ticketId");
        
        if (variantIdStr == null || variantIdStr.trim().isEmpty() ||
            imeis == null || serialNumbers == null || barcodes == null) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" + 
                (ticketIdStr != null ? "&ticketId=" + ticketIdStr : "") + 
                (variantIdStr != null ? "&variantId=" + variantIdStr : ""));
            return;
        }
        
        int variantId = Integer.parseInt(variantIdStr.trim());
        Integer ticketId = null;
        if (ticketIdStr != null && !ticketIdStr.trim().isEmpty()) {
            try {
                ticketId = Integer.parseInt(ticketIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        List<String> validImeis = new ArrayList<>();
        List<String> validSerials = new ArrayList<>();
        List<String> validBarcodes = new ArrayList<>();
        
        for (int i = 0; i < imeis.length; i++) {
            String imei = imeis[i] != null ? imeis[i].trim() : "";
            String sn = (serialNumbers.length > i && serialNumbers[i] != null) ? serialNumbers[i].trim() : "";
            String bc = (barcodes.length > i && barcodes[i] != null) ? barcodes[i].trim() : "";
            
            if (imei.isEmpty() && sn.isEmpty() && bc.isEmpty()) {
                continue; // Skip completely empty rows
            }
            
            if (imei.isEmpty() || sn.isEmpty() || bc.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" + 
                    (ticketId != null ? "&ticketId=" + ticketId : "") + 
                    "&variantId=" + variantId);
                return;
            }
            
            validImeis.add(imei);
            validSerials.add(sn);
            validBarcodes.add(bc);
        }
        
        if (validImeis.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" + 
                (ticketId != null ? "&ticketId=" + ticketId : "") + 
                "&variantId=" + variantId);
            return;
        }
        
        TicketDAO ticketDao = new TicketDAO();
        int expectedQuantity = -1;
        if (ticketId != null) {
            List<model.TicketDetail> details = ticketDao.getTicketDetails(ticketId);
            for (model.TicketDetail td : details) {
                if (td.getVariantId() == variantId) {
                    expectedQuantity = td.getQuantity();
                    break;
                }
            }
        }

        if (expectedQuantity != -1 && validImeis.size() > expectedQuantity) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId=" + variantId + "&error=TooManyImeis&expected=" + expectedQuantity + "&actual=" + validImeis.size());
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
            item.setTicketId(ticketId != null ? ticketId : 0);
            items.add(item);
        }
        
        ImeiDAO imeiDao = new ImeiDAO();
        imeiDao.insertInventoryItems(items);
        
        if (ticketId != null) {
            // Update ticket status to COMPLETED and sync import_price
            ticketDao.updateTicketStatus(ticketId, "COMPLETED", "Stock received and IMEIs registered");
            response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId + "&success=InboundCompleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/imei?success=Added");
        }
    }
}

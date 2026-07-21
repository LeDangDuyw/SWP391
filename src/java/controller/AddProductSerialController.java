/*
 * Name: AddProductImeiController
 * @Author: HuyDQ
 * Date: [05/06/2026]
 * Version: 1.0
 * Description: Controller xử lý việc đăng ký số IMEI, Serial Number và mã vạch cho sản phẩm thực tế khi nhập kho.
 */
package controller;

import dal.SerialDAO;
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

@WebServlet(name = "AddProductSerialController", urlPatterns = { "/staff/imei/add" })
public class AddProductSerialController extends HttpServlet {

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

        request.getRequestDispatcher("/staff/AddProductImei.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String variantIdStr = request.getParameter("variantId");
        String[] serialNumbers = request.getParameterValues("serialNumbers");
        String receivedDate = request.getParameter("receivedDate");
        String ticketIdStr = request.getParameter("ticketId");

        if (variantIdStr == null || variantIdStr.trim().isEmpty() ||
                serialNumbers == null) {
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

        List<String> validSerials = new ArrayList<>();

        for (int i = 0; i < serialNumbers.length; i++) {
            String sn = (serialNumbers[i] != null) ? serialNumbers[i].trim() : "";

            if (sn.isEmpty()) {
                continue; // Skip empty rows
            }

            validSerials.add(sn);
        }

        if (validSerials.isEmpty()) {
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

        if (expectedQuantity != -1 && validSerials.size() != expectedQuantity) {
            response.sendRedirect(request.getContextPath() + "/staff/imei/add?ticketId=" + ticketId + "&variantId="
                    + variantId + "&error=MismatchImeisQuantity&expected=" + expectedQuantity + "&actual="
                    + validSerials.size());
            return;
        }

        LocalDate warrantyExpiredDate = null;
        if (receivedDate != null && !receivedDate.isEmpty()) {
            try {
                LocalDate importDate = LocalDate.parse(receivedDate);
                LocalDate today = LocalDate.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
                if (importDate.isAfter(today)) {
                    response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=InvalidImportDate" +
                            (ticketId != null ? "&ticketId=" + ticketId : "") +
                            "&variantId=" + variantId);
                    return;
                }
                warrantyExpiredDate = importDate.plusWeeks(2);
            } catch (java.time.format.DateTimeParseException e) {
                response.sendRedirect(request.getContextPath() + "/staff/imei/add?error=MissingRequiredFields" +
                        (ticketId != null ? "&ticketId=" + ticketId : "") +
                        "&variantId=" + variantId);
                return;
            }
        }

        List<InventoryItem> items = new ArrayList<>();
        for (int i = 0; i < validSerials.size(); i++) {
            InventoryItem item = new InventoryItem();
            item.setVariantId(variantId);
            item.setSerialNumber(validSerials.get(i));
            item.setStatus("in_stock");
            item.setImportDate(receivedDate);
            item.setWarrantyExpiredDate(warrantyExpiredDate);
            item.setTicketId(ticketId != null ? ticketId : 0);
            items.add(item);
        }

        SerialDAO imeiDao = new SerialDAO();
        imeiDao.insertInventoryItems(items);

        if (ticketId != null) {
            if (ticketDao.isTicketFullyImported(ticketId)) {
                ticketDao.updateTicketStatus(ticketId, "COMPLETED", "Stock received and all IMEIs registered");
                response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId
                        + "&success=InboundCompleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/ticket/workflow?id=" + ticketId
                        + "&success=VariantImported");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/imei?success=Added");
        }
    }
}

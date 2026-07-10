package service;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import model.Order;
import model.OrderDetail;
import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;

public class PdfInvoiceService {

    public static String generateInvoice(Order order, String realPathDir) {
        String fileName = "INV_" + order.getOrderCode() + ".pdf";
        File dir = new File(realPathDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File pdfFile = new File(dir, fileName);
        
        Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        try {
            PdfWriter.getInstance(document, new FileOutputStream(pdfFile));
            document.open();
            
            // Fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, Font.BOLD);
            Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Font.BOLD);
            Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD);
            
            // Header: Store Info
            Paragraph storeInfo = new Paragraph("UNILAP PRECISION ENGINEERING\n42/A10 Le Trong Tan, An Khanh, Hoai Duc, Ha Noi\nPhone: 02471210042\nEmail: contact@unilap.vn\n\n", bodyFont);
            storeInfo.setAlignment(Element.ALIGN_LEFT);
            document.add(storeInfo);
            
            // Title
            Paragraph title = new Paragraph("VAT SALE INVOICE", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // Metadata
            PdfPTable metaTable = new PdfPTable(2);
            metaTable.setWidthPercentage(100);
            metaTable.setWidths(new float[]{50, 50});
            
            PdfPCell cell1 = new PdfPCell(new Paragraph("Invoice No: INV-" + order.getOrderId(), bodyFont));
            cell1.setBorder(Rectangle.NO_BORDER);
            metaTable.addCell(cell1);
            
            String compDate = order.getCompletedAt() != null ? order.getCompletedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "N/A";
            PdfPCell cell2 = new PdfPCell(new Paragraph("Date Completed: " + compDate, bodyFont));
            cell2.setBorder(Rectangle.NO_BORDER);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            metaTable.addCell(cell2);
            
            PdfPCell cell3 = new PdfPCell(new Paragraph("Order Code: #" + order.getOrderCode(), bodyFont));
            cell3.setBorder(Rectangle.NO_BORDER);
            metaTable.addCell(cell3);
            
            PdfPCell cell4 = new PdfPCell(new Paragraph("Payment Method: COD / Bank Transfer", bodyFont));
            cell4.setBorder(Rectangle.NO_BORDER);
            cell4.setHorizontalAlignment(Element.ALIGN_RIGHT);
            metaTable.addCell(cell4);
            
            metaTable.setSpacingAfter(20);
            document.add(metaTable);
            
            // Customer Info
            document.add(new Paragraph("CUSTOMER INFORMATION", sectionFont));
            Paragraph custInfo = new Paragraph("Receiver Name: " + order.getShippingReceiver() + "\n" +
                                               "Phone Number: " + order.getShippingPhone() + "\n" +
                                               "Delivery Address: " + order.getShippingAddress() + "\n\n", bodyFont);
            document.add(custInfo);
            
            // Product List Table
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{15, 40, 15, 10, 20});
            
            // Table Header
            table.addCell(new PdfPCell(new Paragraph("SKU", boldFont)));
            table.addCell(new PdfPCell(new Paragraph("Product Name", boldFont)));
            table.addCell(new PdfPCell(new Paragraph("Unit Price", boldFont)));
            table.addCell(new PdfPCell(new Paragraph("Qty", boldFont)));
            table.addCell(new PdfPCell(new Paragraph("Total", boldFont)));
            
            BigDecimal subtotal = BigDecimal.ZERO;
            if (order.getDetails() != null) {
                for (OrderDetail item : order.getDetails()) {
                    BigDecimal itemTotal = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
                    subtotal = subtotal.add(itemTotal);
                    
                    table.addCell(new PdfPCell(new Paragraph(item.getSku() != null ? item.getSku() : "N/A", bodyFont)));
                    table.addCell(new PdfPCell(new Paragraph(item.getProductName() + " (" + item.getVariantName() + ")", bodyFont)));
                    table.addCell(new PdfPCell(new Paragraph(String.format("%,d", item.getUnitPrice().longValue()) + " d", bodyFont)));
                    table.addCell(new PdfPCell(new Paragraph(String.valueOf(item.getQuantity()), bodyFont)));
                    table.addCell(new PdfPCell(new Paragraph(String.format("%,d", itemTotal.longValue()) + " d", bodyFont)));
                }
            }
            document.add(table);
            document.add(new Paragraph("\n"));
            
            // Breakdown Costs
            PdfPTable costTable = new PdfPTable(2);
            costTable.setWidthPercentage(40);
            costTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
            costTable.setWidths(new float[]{60, 40});
            
            costTable.addCell(createNoBorderCell("Subtotal:", bodyFont, Element.ALIGN_RIGHT));
            costTable.addCell(createNoBorderCell(String.format("%,d", subtotal.longValue()) + " d", bodyFont, Element.ALIGN_RIGHT));
            
            costTable.addCell(createNoBorderCell("Shipping Fee:", bodyFont, Element.ALIGN_RIGHT));
            BigDecimal shipFee = order.getShippingFee() != null ? order.getShippingFee() : BigDecimal.ZERO;
            costTable.addCell(createNoBorderCell(String.format("%,d", shipFee.longValue()) + " d", bodyFont, Element.ALIGN_RIGHT));
            
            BigDecimal discount = subtotal.add(shipFee).subtract(order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO);
            if (discount.compareTo(BigDecimal.ZERO) < 0) {
                discount = BigDecimal.ZERO;
            }
            costTable.addCell(createNoBorderCell("Discount:", bodyFont, Element.ALIGN_RIGHT));
            costTable.addCell(createNoBorderCell("-" + String.format("%,d", discount.longValue()) + " d", bodyFont, Element.ALIGN_RIGHT));
            
            costTable.addCell(createNoBorderCell("Total Pay:", boldFont, Element.ALIGN_RIGHT));
            BigDecimal totAmt = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
            costTable.addCell(createNoBorderCell(String.format("%,d", totAmt.longValue()) + " d", boldFont, Element.ALIGN_RIGHT));
            
            document.add(costTable);
            
            // Footer notice
            Paragraph footerText = new Paragraph("\n\nThank you for choosing UniLap!\nIf you have any questions, please contact our support at support@unilap.vn.", bodyFont);
            footerText.setAlignment(Element.ALIGN_CENTER);
            document.add(footerText);
            
            document.close();
            return fileName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private static PdfPCell createNoBorderCell(String text, Font font, int alignment) {
        PdfPCell cell = new PdfPCell(new Paragraph(text, font));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setHorizontalAlignment(alignment);
        return cell;
    }
}

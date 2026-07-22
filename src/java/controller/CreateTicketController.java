/*
 * Name: CreateTicketController.java
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Controller xử lý việc tạo phiếu yêu cầu nhập kho (Import Ticket) từ nhân viên, chọn sản phẩm và các biến thể.
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

    /**
     * Xử lý yêu cầu HTTP GET: Hiển thị form tạo phiếu yêu cầu nhập kho (Ticket).
     * Hàm này load danh sách sản phẩm, các biến thể, danh mục và thương hiệu để hiển thị lên UI.
     * Đồng thời xử lý việc hiển thị thông báo lỗi (nếu có) khi người dùng submit sai thông tin.
     * 
     * @param request  đối tượng HttpServletRequest chứa thông tin request
     * @param response đối tượng HttpServletResponse để gửi phản hồi
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
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
                case "InvalidPrice":
                    errorMsg = "Đơn giá đề xuất nhập kho của sản phẩm phải lớn hơn 0.";
                    break;
                case "DuplicateVariant":
                    errorMsg = "Không được chọn trùng lặp biến thể trong cùng một phiếu.";
                    break;
                default:
                    errorMsg = "Đã xảy ra lỗi không xác định.";
            }
            request.setAttribute("error", errorMsg);
        }
        ProductDAO productDao = new ProductDAO();
        dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
        dal.BrandDao brandDAO = new dal.BrandDao();
        List<Product> products = productDao.GetAllProducts();
        List<ProductVariant> variants = productDao.getAllVariants();
        request.setAttribute("products", products);
        request.setAttribute("variants", variants);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("brands", brandDAO.getAllBrands());
        request.getRequestDispatcher("/staff/ticket/CreateTicket.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu HTTP POST: Nhận dữ liệu từ form và tạo phiếu nhập kho mới.
     * Các bước xử lý:
     * 1. Validate tiêu đề và danh sách các biến thể (variantIds).
     * 2. Duyệt qua từng biến thể, kiểm tra số lượng và đơn giá đề xuất. Bỏ qua nếu số lượng <= 0.
     * 3. Tránh chọn trùng lặp biến thể trong cùng một form.
     * 4. Gọi TicketDAO để lưu Ticket (phiếu) và TicketDetail (chi tiết phiếu).
     * 5. Điều hướng người dùng về trang danh sách phiếu nhập.
     * 
     * @param request  đối tượng HttpServletRequest chứa form data
     * @param response đối tượng HttpServletResponse để điều hướng sau khi xử lý
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
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
            forwardWithError(request, response, "Vui lòng điền tiêu đề và chọn ít nhất một biến thể sản phẩm.", title, variantIds, quantities, expectedPrices);
            return;
        }

        List<TicketDetail> details = new ArrayList<>();
        java.util.Set<Integer> processedVariantIds = new java.util.HashSet<>();
        
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

                // Validate expected price is positive
                if (expectedPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    forwardWithError(request, response, "Đơn giá đề xuất nhập kho của sản phẩm phải lớn hơn 0.", title, variantIds, quantities, expectedPrices);
                    return;
                }

                if (processedVariantIds.contains(variantId)) {
                    forwardWithError(request, response, "Không được chọn trùng lặp biến thể trong cùng một phiếu.", title, variantIds, quantities, expectedPrices);
                    return;
                }
                processedVariantIds.add(variantId);

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
            forwardWithError(request, response, "Vui lòng nhập số lượng (> 0) cho ít nhất một biến thể.", title, variantIds, quantities, expectedPrices);
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

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
            String errorMsg, String title, String[] variantIds, String[] quantities, String[] expectedPrices)
            throws ServletException, IOException {
        
        request.setAttribute("error", errorMsg);
        request.setAttribute("title", title);
        
        List<TicketDetail> savedDetails = new ArrayList<>();
        if (variantIds != null && variantIds.length > 0) {
            for (int i = 0; i < variantIds.length; i++) {
                try {
                    int vId = Integer.parseInt(variantIds[i]);
                    int q = (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].trim().isEmpty()) 
                            ? Integer.parseInt(quantities[i].trim()) : 0;
                    BigDecimal p = (expectedPrices != null && i < expectedPrices.length && expectedPrices[i] != null && !expectedPrices[i].trim().isEmpty())
                            ? new BigDecimal(expectedPrices[i].trim()) : BigDecimal.ZERO;
                    
                    TicketDetail d = new TicketDetail();
                    d.setVariantId(vId);
                    d.setQuantity(q);
                    d.setExpectedPrice(p);
                    savedDetails.add(d);
                } catch (Exception e) {
                    // ignore
                }
            }
        }
        request.setAttribute("savedDetails", savedDetails);

        ProductDAO productDao = new ProductDAO();
        dal.CategoryDAO categoryDAO = new dal.CategoryDAO();
        dal.BrandDao brandDAO = new dal.BrandDao();
        request.setAttribute("products", productDao.GetAllProducts());
        request.setAttribute("variants", productDao.getAllVariants());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("brands", brandDAO.getAllBrands());
        
        request.getRequestDispatcher("/staff/ticket/CreateTicket.jsp").forward(request, response);
    }
}

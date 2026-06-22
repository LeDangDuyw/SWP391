//MINHBQ 6/4/2026

package controller;

import dal.CampaignFormDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import model.Campaign;
import model.ProductSearchItem;

@WebServlet(name = "CampaignFormController", urlPatterns = {"/admin/campaign-form"})
public class CampaignFormController extends PromotionServlet {
    private CampaignFormDAO formDao;

    /**
     * Chức năng: Khởi tạo controller và thiết lập đối tượng CampaignFormDAO phục vụ truy vấn DB.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext từ servlet container.
     * Đẩy/Gửi dữ liệu đi: Thiết lập biến instance formDao.
     * Action/Luồng đi: Được container gọi một lần duy nhất khi nạp servlet vào bộ nhớ.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        formDao = new CampaignFormDAO(getServletContext());
    }

    /**
     * Chức năng: Xử lý yêu cầu HTTP GET, trả về dữ liệu danh sách sản phẩm dạng JSON, sinh mã ngẫu nhiên, hoặc chuyển tiếp tới trang form điền thông tin chiến dịch.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameter "action" ("products", "generate", hoặc null).
     * Đẩy/Gửi dữ liệu đi: Phản hồi dưới dạng JSON qua response stream, hoặc forward request đến trang JSP nhập form "/admin/campaignForm.jsp".
     * Action/Luồng đi:
     *   - Nếu action = "products": gọi productJson() để trả về dữ liệu sản phẩm dạng JSON.
     *   - Nếu action = "generate": gọi generateCode() để sinh mã khuyến mãi ngẫu nhiên dạng JSON.
     *   - Ngược lại: gọi showForm() để chuẩn bị thông tin và chuyển tiếp sang giao diện JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);
        String action = request.getParameter("action");

        try {
            if ("products".equals(action)) {
                productJson(request, response);
                return;
            }

            if ("check-name".equals(action)) {
                checkName(request, response);
                return;
            }

            if ("generate".equals(action)) {
                generateCode(response);
                return;
            }

            showForm(request, response);
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Xử lý yêu cầu HTTP POST khi người dùng nhấn nút lưu/gửi form chiến dịch.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: Các trường dữ liệu form gửi lên trong HTTP Request.
     * Đẩy/Gửi dữ liệu đi: Lưu thông tin chiến dịch vào CSDL thông qua formDao và chuyển hướng người dùng.
     * Action/Luồng đi: Gọi phương thức saveCampaign() để parse và lưu thông tin chiến dịch.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);

        try {
            saveCampaign(request, response);
        } catch (Exception e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Chuẩn bị thông tin của một chiến dịch đã có (nếu chỉnh sửa) hoặc tạo mới, đồng thời thực hiện tìm kiếm sản phẩm và chuyển sang JSP hiển thị form.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: HTTP Request Parameter "id" (để sửa) và "productKeyword" (từ khóa tìm kiếm sản phẩm).
     * Đẩy/Gửi dữ liệu đi: Đặt các đối tượng campaign, products, và từ khóa tìm kiếm vào Request Attributes, forward tới JSP "/admin/campaignForm.jsp".
     * Action/Luồng đi:
     *   - Đọc ID chiến dịch. Nếu ID > 0, tải thông tin từ DB. Nếu không tìm thấy, redirect về trang promotions kèm lỗi.
     *   - Tìm kiếm danh sách sản phẩm khớp với keyword và tình trạng chọn trong chiến dịch này.
     *   - Set các thuộc tính và forward sang trang JSP hiển thị.
     */
    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign campaign = null;

        if (id > 0) {
            campaign = formDao.getCampaignById(id);

            if (campaign == null) {
                redirectToPromotions(response, request, "?msg=" + enc("Không tìm thấy chiến dịch"));
                return;
            }
        }

        String productKeyword = request.getParameter("productKeyword");
        int campaignId = campaign == null ? 0 : campaign.getCampaignId();
        List<ProductSearchItem> products = formDao.searchProducts(productKeyword, campaignId);

        request.setAttribute("campaign", campaign);
        request.setAttribute("products", products);
        request.setAttribute("productKeyword", productKeyword == null ? "" : productKeyword);
        request.getRequestDispatcher("/admin/campaignForm.jsp").forward(request, response);
    }

    /**
     * Chức năng: Thu thập toàn bộ thông tin từ form gửi lên, kiểm tra giá trị đầu vào và thực hiện insert hoặc update chiến dịch kèm các liên kết sản phẩm trong DB.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Các HTTP Request Parameters: "id", "campaignName", "campaignDescription", "promoCode", "campaignType", "targetGroup", "discountValue", "minOrderValue", "usageLimit", "status", "startDate", "endDate", và "variantIds".
     * Đẩy/Gửi dữ liệu đi: Gọi insert hoặc update xuống CSDL thông qua formDao, sau đó redirect về trang chi tiết chiến dịch tương ứng kèm thông báo thành công.
     * Action/Luồng đi:
     *   - Khởi tạo đối tượng Campaign và gán toàn bộ giá trị đã parse từ request parameters.
     *   - Thu thập danh sách ID của các biến thể sản phẩm được chọn (`variantIds`).
     *   - Nếu ID chiến dịch > 0: Gọi formDao.updateCampaign để cập nhật.
     *   - Ngược lại: Gọi formDao.insertCampaign để chèn mới và lấy ID tự sinh.
     *   - Chuyển hướng trình duyệt về trang chi tiết chiến dịch.
     */
    private void saveCampaign(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        Campaign campaign = new Campaign();
        int id = parseInt(request.getParameter("id"), 0);

        campaign.setCampaignId(id);
        campaign.setCampaignName(req(request, "campaignName").trim());
        campaign.setCampaignDescription(req(request, "campaignDescription").trim());
        campaign.setPromoCode(req(request, "promoCode").toUpperCase(Locale.ROOT).replaceAll("\\s+", ""));
        campaign.setCampaignType(req(request, "campaignType"));
        campaign.setTargetGroup(req(request, "targetGroup"));
        campaign.setDiscountValue(parseMoney(request.getParameter("discountValue")));
        campaign.setMinOrderValue(parseMoney(request.getParameter("minOrderValue")));
        campaign.setUsageLimit(parseNullableInt(request.getParameter("usageLimit")));
        campaign.setStatus(req(request, "status").isBlank() ? "scheduled" : req(request, "status"));
        campaign.setStartDate(parseDateStart(request.getParameter("startDate")));
        campaign.setEndDate(parseDateEnd(request.getParameter("endDate")));

        int[] variantIds = parseIds(request.getParameterValues("variantIds"));
        int[] giftVariantIds = parseIds(request.getParameterValues("giftVariantIds"));

        // Backend Validations
        if (campaign.getCampaignName().isEmpty()) {
            throw new IllegalArgumentException("Tên chiến dịch không được để trống!");
        }
        if (formDao.isCampaignNameExists(campaign.getCampaignName(), campaign.getCampaignId())) {
            throw new IllegalArgumentException("Tên chiến dịch '" + campaign.getCampaignName() + "' đã được sử dụng!");
        }

        String type = campaign.getCampaignType();
        if ("percentage".equals(type) || "fixed".equals(type)) {
            if (campaign.getPromoCode().length() != 9) {
                throw new IllegalArgumentException("Mã khuyến mãi phải nhập đủ 9 ký tự!");
            }
        }

        // Check negative values
        if (campaign.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Giá trị giảm giá không được nhập số âm!");
        }
        if (campaign.getMinOrderValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Giá trị đơn hàng tối thiểu không được nhập số âm!");
        }
        if (campaign.getUsageLimit() != null && campaign.getUsageLimit() < 0) {
            throw new IllegalArgumentException("Giới hạn sử dụng không được nhập số âm!");
        }

        // Limit values
        if ("percentage".equals(type) || "flash".equals(type)) {
            if (campaign.getDiscountValue().compareTo(new BigDecimal("99")) > 0) {
                throw new IllegalArgumentException("Đối với phần trăm (%), giá trị giảm giá chỉ được nhập tối đa là 99%!");
            }
        } else if ("fixed".equals(type) || "bundle_discount".equals(type)) {
            if (campaign.getDiscountValue().compareTo(new BigDecimal("10000000")) > 0) {
                throw new IllegalArgumentException("Đối với tiền mặt (VND), giá trị giảm giá chỉ được nhập tối đa là 10,000,000 VND!");
            }
        }


        if (id > 0) {
            formDao.updateCampaign(campaign, variantIds, giftVariantIds);
            redirectToCampaignDetail(response, request, "?id=" + id + "&msg=" + enc("Đã lưu thay đổi"));
        } else {
            int newId = formDao.insertCampaign(campaign, variantIds , giftVariantIds);
            redirectToCampaignDetail(response, request, "?id=" + newId + "&msg=" + enc("Đã tạo chiến dịch mới"));
        }
    }

    /**
     * Chức năng: Tìm kiếm và trả về danh sách sản phẩm dạng JSON phục vụ cho tính năng tìm kiếm bất đồng bộ (AJAX) trên giao diện.
     * Tác nhân liên quan: Admin / Trình duyệt phía Client.
     * Nhận dữ liệu từ: HTTP Request Parameter "keyword" (từ khóa tìm kiếm).
     * Đẩy/Gửi dữ liệu đi: Ghi chuỗi định dạng JSON đại diện cho mảng sản phẩm trực tiếp vào HTTP Response với Content-Type "application/json".
     * Action/Luồng đi:
     *   - Gọi formDao.searchProducts để lấy kết quả tìm kiếm.
     *   - Duyệt qua danh sách, tạo chuỗi JSON thủ công và ghi ra response stream thông qua PrintWriter.
     */
    private void productJson(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String keyword = request.getParameter("keyword");
        String optionType = request.getParameter("optionType");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        int campaignId = parseInt(request.getParameter("campaignId"), 0);

        List<ProductSearchItem> products = formDao.searchProducts(keyword, campaignId, optionType, startDate, endDate);
        response.setContentType("application/json; charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print("[");

            for (int i = 0; i < products.size(); i++) {
                ProductSearchItem p = products.get(i);

                if (i > 0) {
                    out.print(",");
                }

                BigDecimal price = p.getPrice() == null ? BigDecimal.ZERO : p.getPrice();

                out.print("{\"variantId\":" + p.getVariantId()
                        + ",\"name\":\"" + json(p.getProductName()) + "\""
                        + ",\"variant\":\"" + json(p.getVariantName()) + "\""
                        + ",\"sku\":\"" + json(p.getSku()) + "\""
                        + ",\"category\":\"" + json(p.getCategoryName()) + "\""
                        + ",\"price\":" + price
                        + ",\"stock\":" + p.getStock()
                        + ",\"selected\":" + p.isSelected()
                        + ",\"soldQty\":" + p.getSoldQty()
                        + ",\"gift\":" + p.isGift() + "}");
            }

            out.print("]");
        }
    }

    /**
     * Chức năng: Sinh ngẫu nhiên mã khuyến mãi và phản hồi lại cho client dạng JSON (phục vụ AJAX nút "Tạo mã").
     * Tác nhân liên quan: Admin / Trình duyệt Client.
     * Nhận dữ liệu từ: Hàm sinh mã generateCampaignCode() ở lớp cha.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi JSON chứa thuộc tính "code" qua response writer.
     * Action/Luồng đi: Sinh mã bằng generateCampaignCode, tạo JSON và trả về.
     */
    private void generateCode(HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print("{\"code\":\"" + generateCampaignCode() + "\"}");
    }

    /**
     * Chức năng: Kiểm tra xem tên chiến dịch đã tồn tại trong CSDL chưa (trả về JSON phục vụ AJAX).
     */
    private void checkName(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String name = req(request, "name");
        int id = parseInt(request.getParameter("id"), 0);
        boolean exists = formDao.isCampaignNameExists(name, id);
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print("{\"exists\":" + exists + "}");
    }
}


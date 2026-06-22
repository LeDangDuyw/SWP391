// MINHBQ 
// campaignDetail for admin 

package controller;

import dal.CampaignDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import model.Campaign;
import model.CampaignProduct;
import model.CampaignSalesVolume;

@WebServlet(name = "CampaignDetailController", urlPatterns = {"/admin/campaign-detail"})
public class CampaignDetailController extends PromotionServlet {
    private CampaignDetailDAO detailDao;

    /**
     * Chức năng: Khởi tạo controller, khởi tạo đối tượng CampaignDetailDAO để truy vấn DB.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext từ servlet container.
     * Đẩy/Gửi dữ liệu đi: Thiết lập biến instance detailDao.
     * Action/Luồng đi: Được container gọi một lần khi load servlet.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        detailDao = new CampaignDetailDAO(getServletContext());
    }

    /**
     * Chức năng: Xử lý các yêu cầu HTTP GET, hiển thị trang chi tiết chiến dịch hoặc xuất báo cáo in ấn PDF.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameter "action" ("exportPdf" hoặc null) và "id" (mã chiến dịch).
     * Đẩy/Gửi dữ liệu đi: Chuyển tiếp (forward) tới trang hiển thị báo cáo hoặc gọi phương thức exportPrintReport để ghi trực tiếp ra HTML/PDF.
     * Action/Luồng đi:
     *   - Đọc tham số action.
     *   - Nếu action = "exportPdf": gọi exportPrintReport().
     *   - Ngược lại: gọi showDetail() để chuẩn bị dữ liệu hiển thị JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);
        String action = request.getParameter("action");

        try {
            if ("exportPdf".equals(action)) {
                exportPrintReport(request, response);
                return;
            }

            showDetail(request, response);
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Xử lý yêu cầu HTTP POST, cập nhật trạng thái hoạt động của chiến dịch khuyến mãi.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameter "id" (ID chiến dịch) và "action" (hành động kích hoạt/tạm dừng/dừng).
     * Đẩy/Gửi dữ liệu đi: Cập nhật CSDL thông qua detailDao.updateStatus, sau đó redirect về trang chi tiết kèm thông báo.
     * Action/Luồng đi:
     *   - Parse ID và ánh xạ action sang status bằng statusForAction.
     *   - Gọi detailDao.updateStatus nếu hợp lệ.
     *   - Redirect về trang chi tiết chiến dịch hoặc danh sách kèm thông báo kết quả.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);

        try {
            int id = parseInt(request.getParameter("id"), 0);
            String status = statusForAction(request.getParameter("action"));

            if (id > 0 && status != null) {
                detailDao.updateStatus(id, status);
                redirectToCampaignDetail(response, request,
                        "?id=" + id + "&msg=" + enc("Cập nhật trạng thái thành công"));
            } else {
                redirectToPromotions(response, request, "?msg=" + enc("Không xác định được hành động"));
            }
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Chuẩn bị toàn bộ dữ liệu thống kê, hiệu suất sản phẩm và doanh thu của chiến dịch khuyến mãi để hiển thị lên giao diện chi tiết.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: HTTP Request Parameter "id", dữ liệu từ DB thông qua các phương thức của detailDao.
     * Đẩy/Gửi dữ liệu đi: Gán các đối tượng thống kê vào Request Attributes và forward sang trang JSP "/admin/campaignDetail.jsp".
     * Action/Luồng đi:
     *   - Lấy thông tin Campaign từ DB. Nếu không có, redirect về trang promotions kèm lỗi.
     *   - Lấy danh sách sản phẩm khuyến mãi, doanh số theo thời gian, tăng trưởng khách hàng từ DB.
     *   - Tính toán các chỉ số tiến trình (phần trăm hoàn thành doanh thu tối thiểu, giới hạn sử dụng, tỉ lệ chuyển đổi).
     *   - Set các thuộc tính và forward tới JSP.
     */
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign campaign = detailDao.getCampaignById(id);

        if (campaign == null) {
            redirectToPromotions(response, request, "?msg=" + enc("Không tìm thấy chiến dịch"));
            return;
        }

        List<CampaignProduct> products = detailDao.getProductPerformance(id);
        List<CampaignSalesVolume> salesVolume = detailDao.getSalesVolumeOverTime(id, 30);
        int totalUnits = products.stream().mapToInt(CampaignProduct::getUnitsSold).sum();
        BigDecimal revenue = products.stream()
                .map(CampaignProduct::getRevenue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        int customerGrowth = detailDao.getCustomerGrowth(id, 30);
        int totalCustomers = detailDao.countCampaignCustomers(id);
        double conversion = campaign.getUsageLimit() == null || campaign.getUsageLimit() == 0
                ? 0.0
                : (campaign.getUsedCount() * 100.0 / campaign.getUsageLimit());
        int totalUnitsProgress = percent(totalUnits, campaign.getUsageLimit());
        int revenueProgress = moneyPercent(revenue, campaign.getMinOrderValue());
        int conversionProgress = clampPercent(conversion);
        int customerGrowthProgress = percent(Math.abs(customerGrowth), Math.max(1, totalCustomers));

        request.setAttribute("campaign", campaign);
        request.setAttribute("products", products);
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("revenue", revenue);
        request.setAttribute("conversion", conversion);
        request.setAttribute("customerGrowth", customerGrowth);
        request.setAttribute("totalUnitsProgress", totalUnitsProgress);
        request.setAttribute("revenueProgress", revenueProgress);
        request.setAttribute("conversionProgress", conversionProgress);
        request.setAttribute("customerGrowthProgress", customerGrowthProgress);
        request.setAttribute("salesVolume", salesVolume);
        request.setAttribute("salesAxisLabels", buildSalesAxisLabels(salesVolume));
        request.setAttribute("salesRangeLabel", salesVolume.isEmpty() ? "No Sales Data" : "Last 30 Sale Days");
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/admin/campaignDetail.jsp").forward(request, response);
    }

    /**
     * Chức năng: Tính phần trăm tỷ lệ đạt được giữa giá trị thực tế và chỉ tiêu số nguyên.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Giá trị thực tế value và giá trị chỉ tiêu target.
     * Đẩy/Gửi dữ liệu đi: Trả về phần trăm (từ 0 đến 100).
     * Action/Luồng đi: Kiểm tra target hợp lệ, tính tỷ lệ và gọi clampPercent để chuẩn hóa giá trị trong khoảng [0, 100].
     */
    private int percent(int value, Integer target) {
        if (target == null || target <= 0) {
            return value > 0 ? 100 : 0;
        }

        return clampPercent(value * 100.0 / target);
    }

    /**
     * Chức năng: Tính phần trăm tỷ lệ đạt được giữa giá trị doanh thu thực tế và doanh thu mục tiêu dưới dạng BigDecimal.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Số thực tế value và số chỉ tiêu target dạng BigDecimal.
     * Đẩy/Gửi dữ liệu đi: Trả về phần trăm (từ 0 đến 100).
     * Action/Luồng đi: Kiểm tra target hợp lệ, thực hiện phép chia giá trị thực tế và chỉ tiêu rồi chuẩn hóa bằng clampPercent.
     */
    private int moneyPercent(BigDecimal value, BigDecimal target) {
        if (target == null || target.compareTo(BigDecimal.ZERO) <= 0) {
            return value != null && value.compareTo(BigDecimal.ZERO) > 0 ? 100 : 0;
        }

        BigDecimal safeValue = value == null ? BigDecimal.ZERO : value;
        return clampPercent(safeValue.doubleValue() * 100.0 / target.doubleValue());
    }

    /**
     * Chức năng: Giới hạn giá trị phần trăm đầu ra luôn nằm trong khoảng từ 0 đến 100.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Giá trị phần trăm kiểu double.
     * Đẩy/Gửi dữ liệu đi: Trả về số nguyên int trong khoảng [0, 100].
     * Action/Luồng đi: So sánh giá trị với 0 và 100 để trả về kết quả đã cắt (clamp).
     */
    private int clampPercent(double value) {
        if (value <= 0) {
            return 0;
        }

        return Math.min(100, (int) Math.round(value));
    }

    /**
     * Chức năng: Tạo nhãn trục thời gian (Axis Labels) cho biểu đồ doanh số theo ngày.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Danh sách các mốc doanh số CampaignSalesVolume.
     * Đẩy/Gửi dữ liệu đi: Trả về danh sách chuỗi nhãn ngày dạng "MMM d" (ví dụ: "Jan 1").
     * Action/Luồng đi: Lấy điểm đầu, điểm giữa và điểm cuối của danh sách ngày bán hàng để tạo ra 3 nhãn phân bổ đều trên biểu đồ.
     */
    private List<String> buildSalesAxisLabels(List<CampaignSalesVolume> salesVolume) {
        List<String> labels = new ArrayList<>();

        if (salesVolume == null || salesVolume.isEmpty()) {
            return labels;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d", Locale.US);
        int lastIndex = salesVolume.size() - 1;
        int middleIndex = lastIndex / 2;

        labels.add(salesVolume.get(0).getSaleDate().format(formatter));

        if (middleIndex > 0 && middleIndex < lastIndex) {
            labels.add(salesVolume.get(middleIndex).getSaleDate().format(formatter));
        }

        if (lastIndex > 0) {
            labels.add(salesVolume.get(lastIndex).getSaleDate().format(formatter));
        }

        return labels;
    }

    /**
     * Chức năng: Xuất trang HTML báo cáo hiệu suất chiến dịch dạng thân thiện với máy in (để in ra giấy hoặc lưu dạng PDF).
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameter "id", thông tin chiến dịch và hiệu suất sản phẩm từ detailDao.
     * Đẩy/Gửi dữ liệu đi: Ghi trực tiếp mã nguồn HTML báo cáo ra response stream với Content-Type "text/html" và gọi lệnh in ấn trình duyệt `window.print()`.
     * Action/Luồng đi:
     *   - Đọc ID chiến dịch, tải thông tin chiến dịch và chi tiết sản phẩm.
     *   - Tạo trang HTML cơ bản chứa bảng dữ liệu thống kê sản phẩm, đơn giá, số lượng bán và doanh thu tương ứng.
     *   - Chèn thuộc tính script tự động gọi hộp thoại in ấn của trình duyệt khi load xong.
     */
    private void exportPrintReport(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign c = detailDao.getCampaignById(id);
        List<CampaignProduct> products = detailDao.getProductPerformance(id);
        NumberFormat money = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("vi-VN"));

        response.setContentType("text/html; charset=UTF-8");
        response.setHeader("Content-Disposition", "inline; filename=campaign-report.html");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html><html><head><meta charset='UTF-8'><title>Campaign Report</title>");
            out.println("<style>body{font-family:Arial;margin:32px;color:#111827}table{width:100%;border-collapse:collapse;margin-top:20px}th,td{border:1px solid #d1d5db;padding:10px;text-align:left}th{background:#111827;color:white}.right{text-align:right}</style>");
            out.println("</head><body onload='window.print()'>");

            if (c == null) {
                out.println("<h2>Không tìm thấy campaign</h2>");
            } else {
                out.println("<h1>Campaign Performance: " + html(c.getCampaignName()) + "</h1>");
                out.println("<p><b>Code:</b> " + html(c.getPromoCode())
                        + " | <b>Status:</b> " + html(c.getStatus()) + "</p>");
                out.println("<table><thead><tr><th>Product</th><th>SKU</th><th>Original</th><th>Sale</th><th>Units</th><th>Revenue</th><th>Status</th></tr></thead><tbody>");

                for (CampaignProduct p : products) {
                    out.println("<tr><td>" + html(p.getProductName())
                            + "</td><td>" + html(p.getSku())
                            + "</td><td class='right'>" + money.format(p.getOriginalPrice())
                            + "</td><td class='right'>" + money.format(p.getSalePrice())
                            + "</td><td class='right'>" + p.getUnitsSold()
                            + "</td><td class='right'>" + money.format(p.getRevenue())
                            + "</td><td>" + html(p.getStatus()) + "</td></tr>");
                }

                out.println("</tbody></table>");
            }

            out.println("</body></html>");
        }
    }
}

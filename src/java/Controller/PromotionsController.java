//minhbq 26/4

package controller;

import dal.PromotionsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import model.Campaign;
import model.CampaignStats;

@WebServlet(name = "PromotionsController", urlPatterns = {"/admin/promotions"})
public class PromotionsController extends PromotionServlet {
    private static final int PAGE_SIZE = 6;
    private PromotionsDAO promotionsDao;

    /**
     * Chức năng: Khởi tạo controller, tạo đối tượng PromotionsDAO kết nối CSDL.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext từ servlet container.
     * Đẩy/Gửi dữ liệu đi: Thiết lập biến instance promotionsDao.
     * Action/Luồng đi: Được container gọi một lần khi load servlet.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        promotionsDao = new PromotionsDAO(getServletContext());
    }

    /**
     * Chức năng: Xử lý các yêu cầu HTTP GET để xem danh sách chiến dịch, xuất báo cáo CSV, hoặc điều hướng (redirect) tới form tạo mới/chỉnh sửa/xem chi tiết chiến dịch.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameters: "action" ("export", "create", "edit", "show", "exportPdf", hoặc null) và "id" (nếu có).
     * Đẩy/Gửi dữ liệu đi: Redirect trình duyệt tới các controller liên quan hoặc gọi showList() để hiển thị trang danh sách, exportCsv() để trả về file CSV.
     * Action/Luồng đi:
     *   - Kiểm tra giá trị "action" để phân luồng:
     *     + "export": gọi exportCsv() để tải báo cáo CSV.
     *     + "create": redirect về trang form tạo mới.
     *     + "edit": redirect về trang form sửa với ID chiến dịch.
     *     + "show": redirect về trang chi tiết chiến dịch.
     *     + "exportPdf": redirect sang trang chi tiết kèm tham số action=exportPdf.
     *     + Ngược lại: gọi showList() để hiện danh sách chiến dịch.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);
        String action = request.getParameter("action");

        try {
            if ("export".equals(action)) {
                exportCsv(request, response);
                return;
            }

            if ("create".equals(action)) {
                redirectToCampaignForm(response, request, "");
                return;
            }

            if ("edit".equals(action)) {
                redirectToCampaignForm(response, request, "?id=" + parseInt(request.getParameter("id"), 0));
                return;
            }

            if ("show".equals(action)) {
                redirectToCampaignDetail(response, request, "?id=" + parseInt(request.getParameter("id"), 0));
                return;
            }

            if ("exportPdf".equals(action)) {
                redirectToCampaignDetail(response, request,
                        "?action=exportPdf&id=" + parseInt(request.getParameter("id"), 0));
                return;
            }

            showList(request, response);
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Xử lý yêu cầu HTTP POST để cập nhật trạng thái hoạt động của một chiến dịch cụ thể trực tiếp từ giao diện danh sách.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameters "id" (ID chiến dịch) và "action" (hành động cần thực hiện).
     * Đẩy/Gửi dữ liệu đi: Cập nhật trạng thái chiến dịch khuyến mãi trong DB thông qua promotionsDao.updateStatus và redirect về trang danh sách kèm thông báo.
     * Action/Luồng đi:
     *   - Đọc ID chiến dịch và chuyển hành động thành trạng thái bằng statusForAction.
     *   - Nếu ID và trạng thái hợp lệ, gọi updateStatus.
     *   - Redirect về trang danh sách kèm thông báo kết quả.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareEncoding(request, response);

        try {
            int id = parseInt(request.getParameter("id"), 0);
            String status = statusForAction(request.getParameter("action"));

            if (id > 0 && status != null) {
                promotionsDao.updateStatus(id, status);
                redirectToPromotions(response, request, "?msg=" + enc("Cập nhật trạng thái thành công"));
            } else {
                redirectToPromotions(response, request, "?msg=" + enc("Không xác định được hành động"));
            }
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    /**
     * Chức năng: Chuẩn bị thông tin danh sách chiến dịch khuyến mãi có phân trang, tìm kiếm và số liệu tổng quan trên Dashboard.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: HTTP Request Parameters: "keyword" (từ khóa tìm kiếm), "page" (trang hiện tại). Dữ liệu từ DB qua promotionsDao.
     * Đẩy/Gửi dữ liệu đi: Đặt các danh sách chiến dịch, stats, thông tin phân trang vào Request Attributes, forward tới JSP "/admin/promotions.jsp".
     * Action/Luồng đi:
     *   - Lấy từ khóa tìm kiếm và số trang hiện tại.
     *   - Gọi DB lấy danh sách chiến dịch có phân trang, tổng số lượng bản ghi và thông tin dashboard thống kê.
     *   - Đặt các thuộc tính vào request và forward tới trang JSP.
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        List<Campaign> campaigns = promotionsDao.listCampaigns(keyword, page, PAGE_SIZE);
        int total = promotionsDao.countCampaigns(keyword);
        CampaignStats stats = promotionsDao.getDashboardStats();

        request.setAttribute("campaigns", campaigns);
        request.setAttribute("stats", stats);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("total", total);
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/admin/promotions.jsp").forward(request, response);
    }

    /**
     * Chức năng: Xuất danh sách chiến dịch khuyến mãi ra định dạng file CSV tải về máy.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: HTTP Request Parameter "keyword" (để lọc danh sách cần xuất).
     * Đẩy/Gửi dữ liệu đi: Ghi nội dung CSV trực tiếp vào HTTP Response stream với Content-Type "text/csv" và header "Content-Disposition".
     * Action/Luồng đi:
     *   - Tải danh sách chiến dịch (tối đa 1000 bản ghi) dựa trên keyword.
     *   - Ghi ký tự UTF-8 BOM (`\uFEFF`) ở đầu để tránh lỗi hiển thị tiếng Việt trên Excel.
     *   - In dòng tiêu đề cột và duyệt danh sách chiến dịch, ghi từng dòng dữ liệu định dạng CSV đã được escape qua hàm csv().
     */
    private void exportCsv(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        List<Campaign> campaigns = promotionsDao.listCampaigns(request.getParameter("keyword"), 1, 1000);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=campaign-report.csv");

        try (PrintWriter out = response.getWriter()) {
            out.write('\uFEFF');
            out.println("Campaign,Code,Type,Status,Used,Usage limit,Start,End");

            for (Campaign c : campaigns) {
                out.printf("%s,%s,%s,%s,%d,%s,%s,%s%n",
                        csv(c.getCampaignName()),
                        csv(c.getPromoCode()),
                        csv(c.getCampaignType()),
                        csv(c.getStatus()),
                        c.getUsedCount(),
                        c.getUsageLimit() == null ? "" : c.getUsageLimit().toString(),
                        c.getStartDate(),
                        c.getEndDate());
            }
        }
    }
}

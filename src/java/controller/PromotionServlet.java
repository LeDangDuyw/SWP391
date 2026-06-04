//MINHBQ 6/4/2026
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Random;



public abstract class PromotionServlet extends HttpServlet {
    /**
     *  @Author: MINHBQHE200724
     * Chức năng: Thiết lập mã hóa ký tự (encoding) UTF-8 cho HTTP Request và Response.
     * Tác nhân liên quan: Hệ thống / Admin thông qua các Controller kế thừa.
     * Nhận dữ liệu từ: Đối tượng HttpServletRequest và HttpServletResponse.
     * Đẩy/Gửi dữ liệu đi: Thiết lập thuộc tính mã hóa trực tiếp trên request và response để tránh lỗi hiển thị tiếng Việt.
     * Action/Luồng đi: Được gọi ở đầu mỗi phương thức doGet/doPost trong các Controller.
     */
    protected void prepareEncoding(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
    }

    /**
     * Chức năng: Chuyển tiếp (forward) yêu cầu sang trang hiển thị lỗi khi có ngoại lệ (Exception) xảy ra.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Đối tượng HttpServletRequest, HttpServletResponse và Exception được ném ra từ quá trình xử lý.
     * Đẩy/Gửi dữ liệu đi: Forward request sang trang JSP hiển thị lỗi "/admin/error.jsp".
     * Action/Luồng đi: Ghi nhận vết lỗi (stack trace), đưa thông báo và thông tin chi tiết của lỗi vào request attributes, sau đó forward.
     */
    protected void forwardError(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("error", e.getMessage());
        request.setAttribute("detail", e.toString());
        request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
    }

    /**
     * Chức năng: Thực hiện chuyển hướng (redirect) client đến một đường dẫn tương đối trong ứng dụng.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Đường dẫn tương đối pathAndQuery và HttpServletRequest/Response.
     * Đẩy/Gửi dữ liệu đi: Gửi lệnh redirect (Status Code 302) về phía trình duyệt client với Context Path thích hợp.
     * Action/Luồng đi: Nối context path với đường dẫn mong muốn và gọi response.sendRedirect.
     */
    protected void redirect(HttpServletResponse response, HttpServletRequest request, String pathAndQuery)
            throws IOException {
        response.sendRedirect(request.getContextPath() + pathAndQuery);
    }

    /**
     * Chức năng: Chuyển hướng nhanh trình duyệt về trang danh sách chiến dịch khuyến mãi (promotions).
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: Phần đuôi (suffix) chứa query parameters (ví dụ "?msg=...") và HttpServletRequest/Response.
     * Đẩy/Gửi dữ liệu đi: Redirect trình duyệt về địa chỉ "/admin/promotions" kèm theo suffix.
     * Action/Luồng đi: Gọi phương thức redirect dùng chung với tham số tương ứng.
     */
    protected void redirectToPromotions(HttpServletResponse response, HttpServletRequest request, String suffix)
            throws IOException {
        redirect(response, request, "/admin/promotions" + suffix);
    }

    /**
     * Chức năng: Chuyển hướng nhanh trình duyệt về trang form điền thông tin chiến dịch khuyến mãi.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: Suffix chứa tham số (ví dụ "?id=...") và HttpServletRequest/Response.
     * Đẩy/Gửi dữ liệu đi: Redirect trình duyệt về địa chỉ "/admin/campaign-form" kèm theo suffix.
     * Action/Luồng đi: Gọi phương thức redirect dùng chung với tham số tương ứng.
     */
    protected void redirectToCampaignForm(HttpServletResponse response, HttpServletRequest request, String suffix)
            throws IOException {
        redirect(response, request, "/admin/campaign-form" + suffix);
    }

    /**
     * Chức năng: Chuyển hướng nhanh trình duyệt về trang chi tiết của một chiến dịch khuyến mãi cụ thể.
     * Tác nhân liên quan: Admin.
     * Nhận dữ liệu từ: Suffix chứa tham số (ví dụ "?id=1&msg=...") và HttpServletRequest/Response.
     * Đẩy/Gửi dữ liệu đi: Redirect trình duyệt về địa chỉ "/admin/campaign-detail" kèm theo suffix.
     * Action/Luồng đi: Gọi phương thức redirect dùng chung với tham số tương ứng.
     */
    protected void redirectToCampaignDetail(HttpServletResponse response, HttpServletRequest request, String suffix)
            throws IOException {
        redirect(response, request, "/admin/campaign-detail" + suffix);
    }

    /**
     * Chức năng: Bản đồ hóa (Mapping) hành động được chọn trên giao diện thành trạng thái tương ứng trong CSDL.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Chuỗi action đầu vào (ví dụ: "stop", "pause", "resume", "approve", "reject").
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi trạng thái tương ứng ("stopped", "paused", "active") hoặc null nếu không khớp.
     * Action/Luồng đi: Sử dụng cấu trúc switch-case để phân tích hành động được gửi từ Client và ánh xạ về trạng thái phù hợp.
     */
    protected String statusForAction(String action) {
        String actionName = action == null ? "" : action;

        switch (actionName) {
            case "stop":
                return "stopped";
            case "pause":
                return "paused";
            case "resume":
            case "approve":
                return "active";
            case "reject":
                return "stopped";
            default:
                return null;
        }
    }

    /**
     * Chức năng: Lấy giá trị của một request parameter và thực hiện cắt bỏ khoảng trắng đầu cuối (trim).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: HttpServletRequest và tên parameter cần lấy.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi đã trimmed, hoặc chuỗi rỗng "" nếu parameter không tồn tại (null).
     * Action/Luồng đi: Lấy giá trị qua request.getParameter, kiểm tra null và gọi trim().
     */
    protected String req(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    /**
     * Chức năng: Parse một chuỗi thành số nguyên int, nếu thất bại hoặc trống sẽ trả về giá trị mặc định.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi cần parse và giá trị mặc định defaultValue.
     * Đẩy/Gửi dữ liệu đi: Trả về giá trị int đã parse thành công hoặc defaultValue nếu lỗi định dạng.
     * Action/Luồng đi: Thử gọi Integer.parseInt, bắt ngoại lệ NumberFormatException để trả về giá trị mặc định.
     */
    protected int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Chức năng: Parse một chuỗi thành số nguyên đối tượng Integer cho phép null.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi cần parse.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng Integer hoặc null nếu chuỗi trống hoặc lỗi định dạng.
     * Action/Luồng đi: Thử gọi Integer.parseInt, trả về null nếu có lỗi định dạng hoặc chuỗi rỗng.
     */
    protected Integer parseNullableInt(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Chức năng: Parse mảng chuỗi ID thành mảng số nguyên int[], bỏ qua các ID không hợp lệ hoặc <= 0.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Mảng các chuỗi đại diện cho IDs.
     * Đẩy/Gửi dữ liệu đi: Trả về mảng int[] chứa các ID hợp lệ lớn hơn 0.
     * Action/Luồng đi: Sử dụng Stream API để chuyển đổi các phần tử chuỗi sang số nguyên, lọc lấy số > 0 và gom về mảng.
     */
    protected int[] parseIds(String[] values) {
        if (values == null) {
            return new int[0];
        }

        return java.util.Arrays.stream(values)
                .mapToInt(v -> parseInt(v, 0))
                .filter(v -> v > 0)
                .toArray();
    }

    /**
     * Chức năng: Parse chuỗi biểu diễn tiền tệ hoặc số thập phân thành đối tượng BigDecimal.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi số tiền (ví dụ có thể chứa dấu phẩy phân tách nghìn).
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng BigDecimal tương ứng, hoặc BigDecimal.ZERO nếu lỗi/trống.
     * Action/Luồng đi: Loại bỏ dấu phẩy phân tách nghìn, sau đó chuyển đổi bằng constructor của BigDecimal.
     */
    protected BigDecimal parseMoney(String value) {
        if (value == null || value.isBlank()) {
            return BigDecimal.ZERO;
        }

        try {
            return new BigDecimal(value.replace(",", "").trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    /**
     * Chức năng: Parse chuỗi ngày thành đối tượng LocalDateTime đánh dấu mốc thời gian bắt đầu trong ngày (00:00:00).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi ngày định dạng chuẩn (yyyy-MM-dd).
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng LocalDateTime tương ứng tại 00:00:00 của ngày đó, hoặc bắt đầu ngày hôm nay nếu trống.
     * Action/Luồng đi: Parse thành LocalDate rồi kết hợp với LocalTime.MIN.
     */
    protected LocalDateTime parseDateStart(String value) {
        if (value == null || value.isBlank()) {
            return LocalDateTime.now().with(LocalTime.MIN);
        }

        return LocalDate.parse(value).atStartOfDay();
    }

    /**
     * Chức năng: Parse chuỗi ngày thành đối tượng LocalDateTime đánh dấu mốc thời gian kết thúc trong ngày (23:59:59).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi ngày định dạng chuẩn (yyyy-MM-dd).
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng LocalDateTime tương ứng tại 23:59:59 của ngày đó, hoặc ngày này tháng sau tại 23:59:59 nếu trống.
     * Action/Luồng đi: Parse thành LocalDate rồi kết hợp với LocalTime(23, 59, 59).
     */
    protected LocalDateTime parseDateEnd(String value) {
        if (value == null || value.isBlank()) {
            return LocalDateTime.now().plusMonths(1).with(LocalTime.MAX);
        }

        return LocalDate.parse(value).atTime(23, 59, 59);
    }

    /**
     * Chức năng: Định dạng và escape chuỗi ký tự theo chuẩn CSV để tránh lỗi cấu trúc cột khi ghi file CSV.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi text cần ghi vào CSV.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi text được bọc trong cặp dấu nháy kép, dấu nháy kép bên trong được double lên.
     * Action/Luồng đi: Thay thế `"` bằng `""` và bọc toàn bộ bằng `"`.
     */
    protected String csv(String value) {
        if (value == null) {
            return "";
        }

        return "\"" + value.replace("\"", "\"\"") + "\"";
    }

    /**
     * Chức năng: Mã hóa URL (URL Encoding) chuỗi ký tự theo bảng mã UTF-8.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi ký tự cần mã hóa URL.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi đã được mã hóa URL (URL-safe string).
     * Action/Luồng đi: Gọi URLEncoder.encode với StandardCharsets.UTF_8.
     */
    protected String enc(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    /**
     * Chức năng: Escape các ký tự đặc biệt trong HTML để ngăn chặn lỗ hổng bảo mật XSS (Cross-Site Scripting).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi text chưa an toàn.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi text an toàn đã được escape các ký tự `<, >, &, "`.
     * Action/Luồng đi: Thực hiện chuỗi phương thức replace lần lượt cho các ký tự nhạy cảm.
     */
    protected String html(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    /**
     * Chức năng: Escape chuỗi để đưa an toàn vào trong định dạng JSON, thay thế dấu nháy kép và dấu gạch chéo ngược.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi text cần chèn vào JSON.
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi đã escape an toàn để parse JSON trên Client.
     * Action/Luồng đi: Thay thế `\` bằng `\\`, `"` bằng `\"`, các ký tự xuống dòng bằng khoảng trắng.
     */
    protected String json(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
    }

    /**
     * Chức năng: Sinh ngẫu nhiên mã chiến dịch khuyến mãi (Promo Code) có độ dài 9 ký tự bắt đầu bằng "UNI".
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Tập hợp các ký tự alphabet viết hoa và chữ số (không bao gồm I, O, 0, 1 để tránh nhầm lẫn).
     * Đẩy/Gửi dữ liệu đi: Trả về chuỗi mã khuyến mãi độc nhất được sinh ngẫu nhiên.
     * Action/Luồng đi: Sử dụng java.util.Random để chọn ngẫu nhiên 6 ký tự ghép vào sau tiếp đầu ngữ "UNI".
     */
    protected String generateCampaignCode() {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        Random random = new Random();
        StringBuilder code = new StringBuilder("UNI");

        for (int i = 0; i < 6; i++) {
            code.append(chars.charAt(random.nextInt(chars.length())));
        }

        return code.toString();
    }
}

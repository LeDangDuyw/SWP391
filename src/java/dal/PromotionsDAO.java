package dal;
//minhbq//26/4
import jakarta.servlet.ServletContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Campaign;
import model.CampaignStats;

public class PromotionsDAO extends CampaignDAO {
    /**
     * Chức năng: Khởi tạo lớp PromotionsDAO kết nối CSDL, kế thừa CampaignDAO.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext.
     * Đẩy/Gửi dữ liệu đi: Gọi Constructor lớp cha.
     * Action/Luồng đi: Chuyển tiếp context lên lớp cha.
     */
    public PromotionsDAO(ServletContext context) {
        super(context);
    }

    /**
     * Chức năng: Truy vấn danh sách các chiến dịch khuyến mãi có hỗ trợ tìm kiếm theo từ khóa và phân trang dữ liệu trong CSDL.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Từ khóa tìm kiếm keyword, trang hiện tại page, kích thước trang pageSize, và các bảng: [Campaign], [CampaignProduct] trong DB.
     * Đẩy/Gửi dữ liệu đi: Trả về danh sách `List<Campaign>` chứa các chiến dịch trong trang yêu cầu.
     * Action/Luồng đi:
     *   - Tính toán chỉ số dòng bắt đầu (`startRow`) và dòng kết thúc (`endRow`) dựa trên số trang và kích thước trang.
     *   - Tạo câu lệnh SQL lồng có phân trang sử dụng `ROW_NUMBER() OVER (ORDER BY campaign_id DESC)`.
     *   - Thực hiện tìm kiếm tương đối (LIKE) theo tên chiến dịch, mã khuyến mãi, hoặc trạng thái.
     *   - Thực thi, duyệt qua ResultSet và gọi `mapCampaign` để đóng gói dữ liệu trả về.
     */
    public List<Campaign> listCampaigns(String keyword, int page, int pageSize) throws SQLException {
        List<Campaign> list = new ArrayList<>();

        String key = keyword == null ? "" : keyword.trim();
        int safePage = Math.max(1, page);
        int safePageSize = Math.max(1, pageSize);
        int startRow = (safePage - 1) * safePageSize + 1;
        int endRow = startRow + safePageSize - 1;

        String sql =
                "SELECT * FROM ( " +
                "    SELECT c.*, ISNULL(x.product_count, 0) AS product_count, " +
                "           ROW_NUMBER() OVER (ORDER BY c.campaign_id DESC) AS rn " +
                "    FROM [Campaign] c " +
                "    LEFT JOIN ( " +
                "        SELECT campaign_id, COUNT(*) AS product_count " +
                "        FROM [CampaignProduct] " +
                "        GROUP BY campaign_id " +
                "    ) x ON x.campaign_id = c.campaign_id " +
                "    WHERE (? = '' OR c.campaign_name LIKE ? OR c.promo_code LIKE ? OR c.status LIKE ?) " +
                ") q " +
                "WHERE q.rn BETWEEN ? AND ? " +
                "ORDER BY q.rn";

        try (PreparedStatement ps = prepare(sql)) {
            String like = "%" + key + "%";

            ps.setString(1, key);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setInt(5, startRow);
            ps.setInt(6, endRow);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCampaign(rs));
                }
            }
        }

        return list;
    }

    /**
     * Chức năng: Đếm tổng số lượng chiến dịch khuyến mãi khớp với từ khóa tìm kiếm trong CSDL (phục vụ tính toán tổng số trang phân trang).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Từ khóa tìm kiếm keyword.
     * Đẩy/Gửi dữ liệu đi: Trả về tổng số dòng tìm được (int).
     * Action/Luồng đi: Thực thi câu lệnh SQL SELECT COUNT(*) lọc theo tên chiến dịch, mã khuyến mãi, hoặc trạng thái.
     */
    public int countCampaigns(String keyword) throws SQLException {
        String key = keyword == null ? "" : keyword.trim();

        String sql =
                "SELECT COUNT(*) " +
                "FROM [Campaign] " +
                "WHERE (? = '' OR campaign_name LIKE ? OR promo_code LIKE ? OR status LIKE ?)";

        try (PreparedStatement ps = prepare(sql)) {
            String like = "%" + key + "%";

            ps.setString(1, key);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Chức năng: Thống kê số liệu tổng quan trên giao diện Dashboard quản lý Admin (gồm: số chiến dịch đang hoạt động, số chiến dịch chờ phê duyệt, tổng lượt sử dụng khuyến mãi, tổng số lượng chiến dịch).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Bảng [Campaign] trong DB.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng CampaignStats chứa các số liệu thống kê tổng quan.
     * Action/Luồng đi:
     *   - Tạo câu lệnh SQL sử dụng hàm SUM(CASE WHEN...) để đếm số lượng chiến dịch có status tương ứng và sum số lượt used_count.
     *   - Gán kết quả vào đối tượng CampaignStats và trả về.
     */
    public CampaignStats getDashboardStats() throws SQLException {
        CampaignStats stats = new CampaignStats();

        String sql =
                "SELECT " +
                "    ISNULL(SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END), 0) AS active_count, " +
                "    ISNULL(SUM(CASE WHEN status = 'pending_approval' THEN 1 ELSE 0 END), 0) AS pending_count, " +
                "    ISNULL(SUM(ISNULL(used_count, 0)), 0) AS redemption_count, " +
                "    COUNT(*) AS total_campaigns " +
                "FROM [Campaign]";

        try (PreparedStatement ps = prepare(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.setActiveCampaigns(rs.getInt("active_count"));
                stats.setPendingApprovals(rs.getInt("pending_count"));
                stats.setTotalRedemptions(rs.getInt("redemption_count"));
                stats.setTotalCampaigns(rs.getInt("total_campaigns"));
            }
        }

        return stats;
    }
}

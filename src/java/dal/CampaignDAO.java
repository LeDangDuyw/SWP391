
//minhbq 26/4
package dal;

import jakarta.servlet.ServletContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import model.Campaign;

public class CampaignDAO extends DBContext {
    protected Connection con;
    private final ServletContext context;

    /**
     * 
     * Chức năng: Khởi tạo lớp DAO cho Chiến dịch (Campaign), kế thừa DBContext và lấy đối tượng Connection.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext.
     * Đẩy/Gửi dữ liệu đi: Gán đối tượng connection cho thuộc tính `con` dùng chung trong lớp.
     * Action/Luồng đi: Gọi constructor của lớp cha DBContext để kết nối CSDL, sau đó gán kết nối.
     */
    public CampaignDAO(ServletContext context) {
        super(context);
        this.context = context;
        this.con = super.connection;
    }

    /**
     * Chức năng: Kiểm tra trạng thái kết nối CSDL hiện tại. Nếu chưa có hoặc đã đóng, tiến hành kết nối lại.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Biến instance `con` và `context`.
     * Đẩy/Gửi dữ liệu đi: Thiết lập lại kết nối mới vào biến `con` nếu kết nối cũ không hoạt động, ném ra SQLException nếu thất bại.
     * Action/Luồng đi: Gọi `isClosed()` để kiểm tra kết nối, nếu cần kết nối lại thì khởi tạo đối tượng DBContext mới.
     */
    protected void checkConnection() throws SQLException {
        if (con == null || con.isClosed()) {
            DBContext db = new DBContext(context);
            this.connection = db.connection;
            this.con = this.connection;
        }

        if (con == null || con.isClosed()) {
            throw new SQLException("Không kết nối được database. Lỗi thật: " + DBContext.lastError);
        }
    }

    /**
     * Chức năng: Tạo đối tượng PreparedStatement để thực hiện các truy vấn SQL có tham số an toàn.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Chuỗi truy vấn SQL đầu vào.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng PreparedStatement tương ứng.
     * Action/Luồng đi: Gọi checkConnection() để đảm bảo kết nối DB còn sống trước khi con.prepareStatement().
     */
    protected PreparedStatement prepare(String sql) throws SQLException {
        checkConnection();
        return con.prepareStatement(sql);
    }

    /**
     * Chức năng: Truy vấn thông tin chi tiết của một chiến dịch khuyến mãi theo ID từ CSDL (kèm theo số lượng sản phẩm liên kết).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch (kiểu int) đầu vào.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng Campaign chứa thông tin đầy đủ, hoặc null nếu không tồn tại.
     * Action/Luồng đi:
     *   - Tạo câu lệnh SELECT liên kết giữa bảng [Campaign] và bảng [CampaignProduct] để đếm số sản phẩm.
     *   - Set tham số ID, thực thi câu lệnh SQL và gọi mapCampaign() để đóng gói dữ liệu kết quả thành đối tượng Campaign.
     */
    public Campaign getCampaignById(int id) throws SQLException {
        String sql =
                "SELECT c.*, ISNULL(x.product_count, 0) AS product_count " +
                "FROM [Campaign] c " +
                "LEFT JOIN ( " +
                "    SELECT campaign_id, COUNT(*) AS product_count " +
                "    FROM [CampaignProduct] " +
                "    GROUP BY campaign_id " +
                ") x ON x.campaign_id = c.campaign_id " +
                "WHERE c.campaign_id = ?";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCampaign(rs);
                }
            }
        }

        return null;
    }

    /**
     * Chức năng: Cập nhật trạng thái (status) hoạt động của chiến dịch khuyến mãi theo ID trong CSDL.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch và chuỗi trạng thái status mới.
     * Đẩy/Gửi dữ liệu đi: Cập nhật trực tiếp xuống bảng [Campaign] trong DB.
     * Action/Luồng đi: Thực thi câu lệnh UPDATE đặt cột status và updated_at = GETDATE() cho ID tương ứng.
     */
    public void updateStatus(int campaignId, String status) throws SQLException {
        String sql =
                "UPDATE [Campaign] " +
                "SET status = ?, updated_at = GETDATE() " +
                "WHERE campaign_id = ?";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setString(1, status);
            ps.setInt(2, campaignId);
            ps.executeUpdate();
        }
    }

    /**
     * Chức năng: Chuyển đổi dữ liệu của dòng bản ghi hiện tại trong ResultSet thành đối tượng Java Campaign.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Đối tượng ResultSet đang duyệt.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng Campaign đã được gán đầy đủ thuộc tính từ các cột DB.
     * Action/Luồng đi: Gọi các phương thức get tương ứng của ResultSet để gán cho các thuộc tính của Campaign, xử lý an toàn các trường NULL.
     */
    protected Campaign mapCampaign(ResultSet rs) throws SQLException {
        Campaign c = new Campaign();

        c.setCampaignId(rs.getInt("campaign_id"));
        c.setCampaignName(rs.getString("campaign_name"));
        c.setCampaignDescription(rs.getString("campaign_description"));
        c.setPromoCode(rs.getString("promo_code"));
        c.setCampaignType(rs.getString("campaign_type"));
        c.setDiscountValue(nvl(rs.getBigDecimal("discount_value")));
        c.setMinOrderValue(nvl(rs.getBigDecimal("min_order_value")));

        int usageLimit = rs.getInt("usage_limit");
        if (rs.wasNull()) {
            c.setUsageLimit(null);
        } else {
            c.setUsageLimit(usageLimit);
        }

        c.setUsedCount(rs.getInt("used_count"));
        c.setTargetGroup(rs.getString("target_group"));
        c.setStartDate(toLocalDateTime(rs.getTimestamp("start_date")));
        c.setEndDate(toLocalDateTime(rs.getTimestamp("end_date")));
        c.setStatus(rs.getString("status"));

        try {
            c.setProductCount(rs.getInt("product_count"));
        } catch (SQLException e) {
            c.setProductCount(0);
        }

        return c;
    }

    /**
     * Chức năng: Gán giá trị thời gian kiểu LocalDateTime vào tham số tương ứng trong PreparedStatement (hỗ trợ lưu NULL).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: PreparedStatement, vị trí index của tham số và giá trị LocalDateTime.
     * Đẩy/Gửi dữ liệu đi: Gán giá trị Timestamp vào PreparedStatement.
     * Action/Luồng đi: Kiểm tra null. Nếu null, gọi setNull với kiểu TIMESTAMP, ngược lại đổi sang java.sql.Timestamp và gọi setTimestamp.
     */
    protected void setTimestamp(PreparedStatement ps, int index, LocalDateTime value) throws SQLException {
        if (value == null) {
            ps.setNull(index, Types.TIMESTAMP);
        } else {
            ps.setTimestamp(index, Timestamp.valueOf(value));
        }
    }

    /**
     * Chức năng: Chuyển đổi an toàn đối tượng java.sql.Timestamp từ cơ sở dữ liệu sang java.time.LocalDateTime.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Đối tượng java.sql.Timestamp.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng LocalDateTime tương ứng hoặc null nếu đầu vào null.
     * Action/Luồng đi: Gọi timestamp.toLocalDateTime() nếu timestamp khác null.
     */
    protected LocalDateTime toLocalDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }

        return timestamp.toLocalDateTime();
    }

    /**
     * Chức năng: Tránh lỗi NullPointerException khi thao tác với giá trị BigDecimal.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Đối tượng BigDecimal.
     * Đẩy/Gửi dữ liệu đi: Trả về BigDecimal.ZERO nếu đối tượng đầu vào null, ngược lại trả về chính nó.
     * Action/Luồng đi: Kiểm tra so sánh null đơn giản.
     */
    protected BigDecimal nvl(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }

        return value;
    }
}

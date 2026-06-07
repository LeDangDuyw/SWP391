//minhbq/26/4
package dal;

import jakarta.servlet.ServletContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import model.Campaign;
import model.ProductSearchItem;

public class CampaignFormDAO extends CampaignDAO {
    /**
     * Chức năng: Khởi tạo lớp DAO form chiến dịch, kế thừa CampaignDAO.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext.
     * Đẩy/Gửi dữ liệu đi: Gọi Constructor lớp cha.
     * Action/Luồng đi: Truyền context lên lớp cha.
     */
    public CampaignFormDAO(ServletContext context) {
        super(context);
    }

    /**
     * Chức năng: Tìm kiếm danh sách các sản phẩm (tối đa 120 dòng) để hiển thị trong form chọn sản phẩm khuyến mãi, đồng thời đánh dấu xem sản phẩm nào đã được chọn trong chiến dịch trước đó.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Từ khóa tìm kiếm keyword, ID chiến dịch hiện tại selectedCampaignId, và các bảng: [ProductVariant], [Product], [Category], [Inventory] trong DB.
     * Đẩy/Gửi dữ liệu đi: Trả về danh sách `List<ProductSearchItem>` chứa thông tin sản phẩm và trạng thái chọn (setSelected).
     * Action/Luồng đi:
     *   - Nếu selectedCampaignId > 0: gọi `getSelectedVariantIds` để lấy tập hợp ID sản phẩm đã chọn của chiến dịch này.
     *   - Tạo câu lệnh SQL SELECT TOP 120 tìm kiếm theo tên sản phẩm, tên biến thể, mã SKU hoặc tên danh mục, chỉ lấy các biến thể có trạng thái "active".
     *   - Thực thi câu lệnh, gán các thuộc tính vào đối tượng ProductSearchItem và đánh dấu `setSelected(true/false)`.
     */
    public List<ProductSearchItem> searchProducts(String keyword, int selectedCampaignId) throws SQLException {
        return searchProducts(keyword, selectedCampaignId, null, null, null);
    }

    public List<ProductSearchItem> searchProducts(String keyword, int selectedCampaignId, String optionType, String startDateStr, String endDateStr) throws SQLException {
        List<ProductSearchItem> list = new ArrayList<>();
        String key = keyword == null ? "" : keyword.trim();

        Set<Integer> selectedIds = new HashSet<>();
        Set<Integer> giftIds = new HashSet<>();
        if (selectedCampaignId > 0) {
            selectedIds = getSelectedVariantIds(selectedCampaignId);
            giftIds = getGiftVariantIds(selectedCampaignId);
        }

        boolean hasDateFilter = (startDateStr != null && !startDateStr.trim().isEmpty() && endDateStr != null && !endDateStr.trim().isEmpty());

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP 120 ")
           .append("    pv.variant_id, ")
           .append("    p.product_name, ")
           .append("    pv.variant_name, ")
           .append("    pv.sku, ")
           .append("    ca.category_name, ")
           .append("    pv.selling_price, ")
           .append("    ISNULL(SUM(i.available_quantity), 0) AS stock, ")
           .append("    ISNULL(sales.sold_qty, 0) AS sold_qty ")
           .append("FROM [ProductVariant] pv ")
           .append("JOIN [Product] p ON p.product_id = pv.product_id ")
           .append("LEFT JOIN [Category] ca ON ca.category_id = p.category_id ")
           .append("LEFT JOIN [Inventory] i ON i.variant_id = pv.variant_id ")
           .append("LEFT JOIN ( ")
           .append("    SELECT od.variant_id, COUNT(ois.order_item_serial_id) AS sold_qty ")
           .append("    FROM [OrderDetail] od ")
           .append("    JOIN [Order] o ON o.order_id = od.order_id ")
           .append("    JOIN [OrderItemSerial] ois ON ois.order_detail_id = od.order_detail_id ")
           .append("    WHERE o.order_status IN (N'delivered', N'shipped', N'processing', N'completed') ");
        
        if (hasDateFilter) {
            sql.append("      AND CAST(ois.assigned_at AS date) BETWEEN ? AND ? ");
        }
        
        sql.append("    GROUP BY od.variant_id ")
           .append(") sales ON sales.variant_id = pv.variant_id ")
           .append("WHERE ISNULL(pv.status, N'active') = N'active' ")
           .append("  AND (? = '' OR p.product_name LIKE ? OR pv.variant_name LIKE ? OR pv.sku LIKE ? OR ca.category_name LIKE ?) ")
           .append("GROUP BY pv.variant_id, p.product_name, pv.variant_name, pv.sku, ca.category_name, pv.selling_price, sales.sold_qty ");

        if ("best_seller".equals(optionType)) {
            sql.append("ORDER BY sold_qty DESC, p.product_name, pv.variant_name");
        } else if ("least_bought".equals(optionType)) {
            sql.append("ORDER BY sold_qty ASC, p.product_name, pv.variant_name");
        } else {
            sql.append("ORDER BY p.product_name, pv.variant_name");
        }

        try (PreparedStatement ps = prepare(sql.toString())) {
            int paramIndex = 1;
            if (hasDateFilter) {
                try {
                    ps.setDate(paramIndex++, java.sql.Date.valueOf(startDateStr));
                    ps.setDate(paramIndex++, java.sql.Date.valueOf(endDateStr));
                } catch (IllegalArgumentException e) {
                    // Fail-safe: if date parsing fails, revert dynamic parameters to null, though handled by JS
                    ps.setDate(paramIndex++, null);
                    ps.setDate(paramIndex++, null);
                }
            }
            String like = "%" + key + "%";
            ps.setString(paramIndex++, key);
            ps.setString(paramIndex++, like);
            ps.setString(paramIndex++, like);
            ps.setString(paramIndex++, like);
            ps.setString(paramIndex++, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSearchItem item = new ProductSearchItem();

                    item.setVariantId(rs.getInt("variant_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setVariantName(rs.getString("variant_name"));
                    item.setSku(rs.getString("sku"));
                    item.setCategoryName(rs.getString("category_name"));
                    item.setPrice(nvl(rs.getBigDecimal("selling_price")));
                    item.setStock(rs.getInt("stock"));
                    item.setSelected(selectedIds.contains(item.getVariantId()));
                    item.setSoldQty(rs.getInt("sold_qty"));
                    item.setGift(giftIds.contains(item.getVariantId()));

                    list.add(item);
                }
            }
        }

        return list;
    }

    /**
     * Chức năng: Lấy danh sách ID biến thể sản phẩm đã được thêm vào một chiến dịch cụ thể trong CSDL.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId.
     * Đẩy/Gửi dữ liệu đi: Trả về một tập hợp `Set<Integer>` chứa các ID biến thể sản phẩm.
     * Action/Luồng đi: Truy vấn cột `variant_id` từ bảng [CampaignProduct] theo `campaign_id` truyền vào.
     */
    public Set<Integer> getSelectedVariantIds(int campaignId) throws SQLException {
        Set<Integer> set = new HashSet<>();

        String sql =
                "SELECT variant_id " +
                "FROM [CampaignProduct] " +
                "WHERE campaign_id = ?";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    set.add(rs.getInt("variant_id"));
                }
            }
        }

        return set;
    }

    /**
     * Chức năng: Lấy danh sách ID quà tặng (sale_price = 0) thuộc một chiến dịch cụ thể trong CSDL.
     */
    public Set<Integer> getGiftVariantIds(int campaignId) throws SQLException {
        Set<Integer> set = new HashSet<>();

        String sql =
                "SELECT variant_id " +
                "FROM [CampaignProduct] " +
                "WHERE campaign_id = ? AND sale_price = 0";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    set.add(rs.getInt("variant_id"));
                }
            }
        }

        return set;
    }

    /**
     * Chức năng: Thêm mới một chiến dịch khuyến mãi vào CSDL, đồng thời tự động đồng bộ sang bảng Voucher (nếu cần) và lưu danh sách sản phẩm liên kết dưới dạng một Giao dịch (Transaction) an toàn.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Đối tượng Campaign chứa thông tin chiến dịch mới và mảng ID sản phẩm liên kết `variantIds`.
     * Đẩy/Gửi dữ liệu đi: Insert bản ghi vào bảng [Campaign] và [CampaignProduct] trong DB, trả về ID chiến dịch vừa tạo (int).
     * Action/Luồng đi:
     *   - Tắt chế độ tự động commit (`setAutoCommit(false)`).
     *   - Gọi `upsertVoucherIfNeeded` để tạo/cập nhật Voucher tương ứng nếu là loại giảm giá áp dụng Voucher.
     *   - Chèn thông tin chiến dịch vào bảng [Campaign], lấy ID tự sinh thông qua `Statement.RETURN_GENERATED_KEYS`.
     *   - Gọi `replaceCampaignProducts` để lưu liên kết sản phẩm khuyến mãi.
     *   - Thực hiện commit giao dịch. Nếu có lỗi xảy ra, thực hiện rollback để đảm bảo tính toàn vẹn dữ liệu.
     */
    public int insertCampaign(Campaign campaign, int[] variantIds , int[] giftVariantIds) throws SQLException {
        checkConnection();
        con.setAutoCommit(false);

        try {
            Integer voucherId = upsertVoucherIfNeeded(campaign);

            String sql =
                    "INSERT INTO [Campaign] " +
                    "(campaign_name, campaign_description, promo_code, campaign_type, discount_value, " +
                    " min_order_value, usage_limit, used_count, target_group, start_date, end_date, status, " +
                    " created_at, updated_at, voucher_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";

            int newId;

            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                bindCampaignForInsert(ps, campaign, voucherId);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        newId = keys.getInt(1);
                    } else {
                        throw new SQLException("Không lấy được campaign_id sau khi insert Campaign.");
                    }
                }
            }

            replaceCampaignProducts(newId, variantIds , giftVariantIds);

            con.commit();
            return newId;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }

    /**
     * Chức năng: Cập nhật thông tin chi tiết của một chiến dịch khuyến mãi hiện tại trong CSDL, đồng bộ sang Voucher (nếu cần) và cập nhật lại danh sách sản phẩm liên kết dưới dạng một Giao dịch (Transaction) an toàn.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Đối tượng Campaign chứa thông tin thay đổi và mảng ID sản phẩm liên kết `variantIds`.
     * Đẩy/Gửi dữ liệu đi: Cập nhật thông tin trong bảng [Campaign] và làm mới danh sách [CampaignProduct] tương ứng trong DB.
     * Action/Luồng đi:
     *   - Tắt tự động commit kết nối.
     *   - Đồng bộ hoặc cập nhật thông tin Voucher liên quan qua `upsertVoucherIfNeeded`.
     *   - Chạy lệnh UPDATE cập nhật các cột thông tin chung của chiến dịch.
     *   - Làm mới liên kết sản phẩm bằng cách xóa liên kết cũ và chèn lại qua `replaceCampaignProducts`.
     *   - Commit giao dịch, thực hiện rollback nếu gặp ngoại lệ SQL.
     */
    public void updateCampaign(Campaign campaign, int[] variantIds , int[] giftVariantIds) throws SQLException {
        checkConnection();
        con.setAutoCommit(false);

        try {
            Integer voucherId = upsertVoucherIfNeeded(campaign);

            String sql =
                    "UPDATE [Campaign] SET " +
                    "    campaign_name = ?, " +
                    "    campaign_description = ?, " +
                    "    promo_code = ?, " +
                    "    campaign_type = ?, " +
                    "    discount_value = ?, " +
                    "    min_order_value = ?, " +
                    "    usage_limit = ?, " +
                    "    target_group = ?, " +
                    "    start_date = ?, " +
                    "    end_date = ?, " +
                    "    status = ?, " +
                    "    updated_at = GETDATE(), " +
                    "    voucher_id = ? " +
                    "WHERE campaign_id = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                bindCampaignForUpdate(ps, campaign, voucherId);
                ps.executeUpdate();
            }

            replaceCampaignProducts(campaign.getCampaignId(), variantIds, giftVariantIds);

            con.commit();
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }

    /**
     * Chức năng: Binding dữ liệu từ đối tượng Campaign vào PreparedStatement phục vụ cho hành động INSERT.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: PreparedStatement, đối tượng Campaign c, và khóa ngoại voucherId.
     * Đẩy/Gửi dữ liệu đi: Gán các giá trị tham số tương ứng vào PreparedStatement.
     * Action/Luồng đi: Lần lượt gán các trường thông tin chung, sử dụng hàm setTimestamp phụ trợ để xử lý trường LocalDateTime.
     */
    private void bindCampaignForInsert(PreparedStatement ps, Campaign c, Integer voucherId) throws SQLException {
        ps.setString(1, c.getCampaignName());
        ps.setString(2, c.getCampaignDescription());
        ps.setString(3, c.getPromoCode());
        ps.setString(4, c.getCampaignType());
        ps.setBigDecimal(5, nvl(c.getDiscountValue()));
        ps.setBigDecimal(6, nvl(c.getMinOrderValue()));

        if (c.getUsageLimit() == null) {
            ps.setNull(7, Types.INTEGER);
        } else {
            ps.setInt(7, c.getUsageLimit());
        }

        ps.setInt(8, c.getUsedCount());
        ps.setString(9, c.getTargetGroup());
        setTimestamp(ps, 10, c.getStartDate());
        setTimestamp(ps, 11, c.getEndDate());
        ps.setString(12, c.getStatus());

        if (voucherId == null) {
            ps.setNull(13, Types.INTEGER);
        } else {
            ps.setInt(13, voucherId);
        }
    }

    /**
     * Chức năng: Binding dữ liệu từ đối tượng Campaign vào PreparedStatement phục vụ cho hành động UPDATE.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: PreparedStatement, đối tượng Campaign c, và khóa ngoại voucherId.
     * Đẩy/Gửi dữ liệu đi: Gán các giá trị tham số tương ứng vào PreparedStatement.
     * Action/Luồng đi: Thiết lập các tham số cho câu lệnh UPDATE, gán khóa chính campaign_id ở tham số cuối cùng (vị trí 13).
     */
    private void bindCampaignForUpdate(PreparedStatement ps, Campaign c, Integer voucherId) throws SQLException {
        ps.setString(1, c.getCampaignName());
        ps.setString(2, c.getCampaignDescription());
        ps.setString(3, c.getPromoCode());
        ps.setString(4, c.getCampaignType());
        ps.setBigDecimal(5, nvl(c.getDiscountValue()));
        ps.setBigDecimal(6, nvl(c.getMinOrderValue()));

        if (c.getUsageLimit() == null) {
            ps.setNull(7, Types.INTEGER);
        } else {
            ps.setInt(7, c.getUsageLimit());
        }

        ps.setString(8, c.getTargetGroup());
        setTimestamp(ps, 9, c.getStartDate());
        setTimestamp(ps, 10, c.getEndDate());
        ps.setString(11, c.getStatus());

        if (voucherId == null) {
            ps.setNull(12, Types.INTEGER);
        } else {
            ps.setInt(12, voucherId);
        }

        ps.setInt(13, c.getCampaignId());
    }

    /**
     * Chức năng: Đồng bộ hóa tự động thông tin khuyến mãi sang bảng [Voucher]. Nếu Voucher đã tồn tại theo mã code, thực hiện cập nhật; ngược lại thực hiện thêm mới và trả về khóa ngoại voucher_id.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: Đối tượng Campaign c.
     * Đẩy/Gửi dữ liệu đi: Trả về ID của Voucher (Integer) hoặc null nếu loại chiến dịch không áp dụng Voucher (ví dụ: flash sale, quà tặng kèm).
     * Action/Luồng đi:
     *   - Bỏ qua nếu loại chiến dịch là "flash" hoặc "gift_with_purchase".
     *   - Kiểm tra mã voucher_code trong bảng [Voucher].
     *   - Nếu đã có: Thực thi UPDATE cập nhật giá trị giảm giá, giá trị đơn hàng tối thiểu và ngày hết hạn. Trả về voucher_id.
     *   - Nếu chưa có: Thực thi INSERT bản ghi Voucher mới và lấy ID tự sinh trả về.
     */
    private Integer upsertVoucherIfNeeded(Campaign c) throws SQLException {
        String type = c.getCampaignType() == null ? "" : c.getCampaignType();

        if ("flash".equalsIgnoreCase(type) || "gift_with_purchase".equalsIgnoreCase(type)) {
            return null;
        }

        String code = c.getPromoCode();

        if (code == null || code.trim().isEmpty()) {
            return null;
        }

        String checkSql =
                "SELECT voucher_id " +
                "FROM [Voucher] " +
                "WHERE voucher_code = ?";

        try (PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setString(1, code);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int voucherId = rs.getInt("voucher_id");

                    String updateSql =
                            "UPDATE [Voucher] SET " +
                            "    discount_value = ?, " +
                            "    min_order_value = ?, " +
                            "    expiry_date = ? " +
                            "WHERE voucher_id = ?";

                    try (PreparedStatement update = con.prepareStatement(updateSql)) {
                        update.setBigDecimal(1, nvl(c.getDiscountValue()));
                        update.setBigDecimal(2, nvl(c.getMinOrderValue()));
                        setTimestamp(update, 3, c.getEndDate());
                        update.setInt(4, voucherId);
                        update.executeUpdate();
                    }

                    return voucherId;
                }
            }
        }

        String insertSql =
                "INSERT INTO [Voucher] " +
                "(voucher_code, discount_value, min_order_value, expiry_date) " +
                "VALUES (?, ?, ?, ?)";

        try (PreparedStatement insert = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            insert.setString(1, code);
            insert.setBigDecimal(2, nvl(c.getDiscountValue()));
            insert.setBigDecimal(3, nvl(c.getMinOrderValue()));
            setTimestamp(insert, 4, c.getEndDate());

            insert.executeUpdate();

            try (ResultSet keys = insert.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        return null;
    }

    /**
     * Chức năng: Làm mới toàn bộ danh sách sản phẩm thuộc phạm vi áp dụng của chiến dịch bằng cách xóa liên kết cũ và chèn loạt liên kết mới (Batch Insert).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId và mảng số nguyên chứa ID các biến thể sản phẩm `variantIds`.
     * Đẩy/Gửi dữ liệu đi: Thực hiện xóa và chèn các dòng dữ liệu vào bảng [CampaignProduct] trong DB.
     * Action/Luồng đi:
     *   - Chạy lệnh DELETE để xóa tất cả sản phẩm của chiến dịch hiện tại trong bảng [CampaignProduct].
     *   - Loại bỏ trùng lặp và giá trị ID không hợp lệ trong mảng variantIds.
     *   - Tạo câu lệnh INSERT và đưa vào lô xử lý (addBatch) cho từng ID biến thể.
     *   - Thực thi chèn hàng loạt bằng lệnh `executeBatch()`.
     */
    private void replaceCampaignProducts(int campaignId, int[] variantIds, int[] giftVariantIds) throws SQLException {
        String deleteSql =
                "DELETE FROM [CampaignProduct] " +
                "WHERE campaign_id = ?";

        try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
            ps.setInt(1, campaignId);
            ps.executeUpdate();
        }

        if (variantIds == null || variantIds.length == 0) {
            return;
        }
        
        Set<Integer> giftIds = new HashSet<>();
        if(giftVariantIds != null){
        for( int gid : giftVariantIds){
         giftIds.add(gid);
        }
        }

        String insertSql =
                "INSERT INTO [CampaignProduct] " +
                "(campaign_id, variant_id, sale_price, quantity_limit, sold_quantity, purchase_limit_per_user) " +
                "VALUES (?, ?, ?, NULL, 0, 1)";

        try (PreparedStatement ps = con.prepareStatement(insertSql)) {
            Set<Integer> uniqueIds = new LinkedHashSet<>();

            for (int id : variantIds) {
                if (id > 0) {
                    uniqueIds.add(id);
                }
            }

            for (Integer variantId : uniqueIds) {
                ps.setInt(1, campaignId);
                ps.setInt(2, variantId);
               if(giftIds.contains(variantId)){
               ps.setBigDecimal(3, BigDecimal.ZERO);
               }else{
               ps.setNull(3, java.sql.Types.DECIMAL);
               }
               ps.addBatch();
            }

            ps.executeBatch();
        }
    }
}

package dal;
import java.sql.Connection;
import dal.DBContext;
import model.Campaign;
import model.CampaignProduct;
import model.CampaignStats;
import model.ProductSearchItem;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

public class CampaignDAO extends DBContext {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
// check  connect and conect
    public CampaignDAO() {
        connect();
    }

    private void connect() {
        con = super.connection;

        if (con != null) {
            System.out.println("CampaignDAO connect success");
        } else {
            System.out.println("CampaignDAO connect fail");
        }
    }

private void checkConnection() throws SQLException {
    if (con == null || con.isClosed()) {
        DBContext db = new DBContext();
        this.connection = db.connection;
        this.con = this.connection;
    }

    if (con == null || con.isClosed()) {
        throw new SQLException("Không kết nối được database. Lỗi thật: " + DBContext.lastError);
    }
}

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

       
                checkConnection();
              ps = con.prepareStatement(sql); 

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
        

        return list;
    }

    public int countCampaigns(String keyword) throws SQLException {
        String key = keyword == null ? "" : keyword.trim();

        String sql =
                "SELECT COUNT(*) " +
                "FROM [Campaign] " +
                "WHERE (? = '' OR campaign_name LIKE ? OR promo_code LIKE ? OR status LIKE ?)";

                        checkConnection();
              ps = con.prepareStatement(sql); 

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
        

        return 0;
    }

    public CampaignStats getDashboardStats() throws SQLException {
        CampaignStats stats = new CampaignStats();

        String sql =
                "SELECT " +
                "    ISNULL(SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END), 0) AS active_count, " +
                "    ISNULL(SUM(CASE WHEN status = 'pending_approval' THEN 1 ELSE 0 END), 0) AS pending_count, " +
                "    ISNULL(SUM(ISNULL(used_count, 0)), 0) AS redemption_count, " +
                "    COUNT(*) AS total_campaigns " +
                "FROM [Campaign]";

                checkConnection();
              ps = con.prepareStatement(sql); 
             rs = ps.executeQuery();

            if (rs.next()) {
                stats.setActiveCampaigns(rs.getInt("active_count"));
                stats.setPendingApprovals(rs.getInt("pending_count"));
                stats.setTotalRedemptions(rs.getInt("redemption_count"));
                stats.setTotalCampaigns(rs.getInt("total_campaigns"));
            }
        

        return stats;
    }

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

               checkConnection();
              ps = con.prepareStatement(sql); 

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCampaign(rs);
                }
            }
        

        return null;
    }

    public List<ProductSearchItem> searchProducts(String keyword, int selectedCampaignId) throws SQLException {
        List<ProductSearchItem> list = new ArrayList<>();
        String key = keyword == null ? "" : keyword.trim();

        Set<Integer> selectedIds = new HashSet<>();
        if (selectedCampaignId > 0) {
            selectedIds = getSelectedVariantIds(selectedCampaignId);
        }

        String sql =
                "SELECT TOP 120 " +
                "    pv.variant_id, " +
                "    p.product_name, " +
                "    pv.variant_name, " +
                "    pv.sku, " +
                "    ca.category_name, " +
                "    pv.selling_price, " +
                "    ISNULL(SUM(i.available_quantity), 0) AS stock " +
                "FROM [ProductVariant] pv " +
                "JOIN [Product] p ON p.product_id = pv.product_id " +
                "LEFT JOIN [Category] ca ON ca.category_id = p.category_id " +
                "LEFT JOIN [Inventory] i ON i.variant_id = pv.variant_id " +
                "WHERE ISNULL(pv.status, N'active') = N'active' " +
                "  AND (? = '' OR p.product_name LIKE ? OR pv.variant_name LIKE ? OR pv.sku LIKE ? OR ca.category_name LIKE ?) " +
                "GROUP BY pv.variant_id, p.product_name, pv.variant_name, pv.sku, ca.category_name, pv.selling_price " +
                "ORDER BY p.product_name, pv.variant_name";

                checkConnection();
              ps = con.prepareStatement(sql); 

            String like = "%" + key + "%";

            ps.setString(1, key);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);

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

                    list.add(item);
                }
            }
        

        return list;
    }

    public Set<Integer> getSelectedVariantIds(int campaignId) throws SQLException {
        Set<Integer> set = new HashSet<>();

        String sql =
                "SELECT variant_id " +
                "FROM [CampaignProduct] " +
                "WHERE campaign_id = ?";

               checkConnection();
              ps = con.prepareStatement(sql); 

            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    set.add(rs.getInt("variant_id"));
                }
            }
        

        return set;
    }

    public int insertCampaign(Campaign campaign, int[] variantIds) throws SQLException {
                checkConnection();

            con.setAutoCommit(false);

            try {
                Integer voucherId = upsertVoucherIfNeeded(con, campaign);

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

                replaceCampaignProducts(con, newId, variantIds);

                con.commit();
                return newId;

            } catch (SQLException e) {
                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }
        
    }

    public void updateCampaign(Campaign campaign, int[] variantIds) throws SQLException {
                checkConnection();
              
            con.setAutoCommit(false);

            try {
                Integer voucherId = upsertVoucherIfNeeded(con, campaign);

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
        
              ps = con.prepareStatement(sql); 
                    bindCampaignForUpdate(ps, campaign, voucherId);
                    ps.executeUpdate();
                

                replaceCampaignProducts(con, campaign.getCampaignId(), variantIds);

                con.commit();

            } catch (SQLException e) {
                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }
        
    }

    public void updateStatus(int campaignId, String status) throws SQLException {
        String sql =
                "UPDATE [Campaign] " +
                "SET status = ?, updated_at = GETDATE() " +
                "WHERE campaign_id = ?";

                checkConnection();
              ps = con.prepareStatement(sql); 

            ps.setString(1, status);
            ps.setInt(2, campaignId);
            ps.executeUpdate();
        
    }

    public List<CampaignProduct> getProductPerformance(int campaignId) throws SQLException {
        List<CampaignProduct> list = new ArrayList<>();

        Campaign campaign = getCampaignById(campaignId);
        if (campaign == null) {
            return list;
        }

        String sql =
                "SELECT " +
                "    pv.variant_id, " +
                "    p.product_name, " +
                "    pv.sku, " +
                "    ca.category_name, " +
                "    pv.selling_price AS original_price, " +
                "    cp.sale_price AS manual_sale_price, " +
                "    ISNULL(SUM(CASE " +
                "        WHEN o.order_status IN (N'delivered', N'shipped', N'processing', N'completed') " +
                "        THEN od.quantity ELSE 0 END), 0) AS units_sold, " +
                "    ISNULL(stock.stock_quantity, 0) AS stock_quantity " +
                "FROM [CampaignProduct] cp " +
                "JOIN [ProductVariant] pv ON pv.variant_id = cp.variant_id " +
                "JOIN [Product] p ON p.product_id = pv.product_id " +
                "LEFT JOIN [Category] ca ON ca.category_id = p.category_id " +
                "LEFT JOIN [OrderDetail] od ON od.variant_id = pv.variant_id " +
                "LEFT JOIN [Order] o ON o.order_id = od.order_id " +
                "LEFT JOIN ( " +
                "    SELECT variant_id, SUM(available_quantity) AS stock_quantity " +
                "    FROM [Inventory] " +
                "    GROUP BY variant_id " +
                ") stock ON stock.variant_id = pv.variant_id " +
                "WHERE cp.campaign_id = ? " +
                "GROUP BY pv.variant_id, p.product_name, pv.sku, ca.category_name, " +
                "         pv.selling_price, cp.sale_price, stock.stock_quantity " +
                "ORDER BY units_sold DESC, p.product_name";

                checkConnection();
              ps = con.prepareStatement(sql); 

            ps.setInt(1, campaignId);

             rs = ps.executeQuery();
                while (rs.next()) {
                    CampaignProduct item = new CampaignProduct();

                    BigDecimal originalPrice = nvl(rs.getBigDecimal("original_price"));
                    BigDecimal manualSalePrice = rs.getBigDecimal("manual_sale_price");
                    BigDecimal salePrice = calculateSalePrice(campaign, originalPrice, manualSalePrice);

                    int unitsSold = rs.getInt("units_sold");
                    int stock = rs.getInt("stock_quantity");

                    item.setVariantId(rs.getInt("variant_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setSku(rs.getString("sku"));
                    item.setCategoryName(rs.getString("category_name"));
                    item.setOriginalPrice(originalPrice);
                    item.setSalePrice(salePrice);
                    item.setUnitsSold(unitsSold);
                    item.setRevenue(salePrice.multiply(BigDecimal.valueOf(unitsSold)).setScale(2, RoundingMode.HALF_UP));
                    item.setStock(stock);

                    if (stock <= 0) {
                        item.setStatus("Out of Stock");
                    } else if (stock <= 5) {
                        item.setStatus("Low Stock");
                    } else {
                        item.setStatus("In Stock");
                    }

                    list.add(item);
                }
            
        

        return list;
    }

    public BigDecimal getCampaignRevenue(int campaignId) throws SQLException {
        BigDecimal total = BigDecimal.ZERO;
        List<CampaignProduct> products = getProductPerformance(campaignId);

        for (CampaignProduct item : products) {
            total = total.add(nvl(item.getRevenue()));
        }

        return total.setScale(2, RoundingMode.HALF_UP);
    }

    private Campaign mapCampaign(ResultSet rs) throws SQLException {
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

    private Integer upsertVoucherIfNeeded(Connection con, Campaign c) throws SQLException {
        String type = c.getCampaignType() == null ? "" : c.getCampaignType();

        if ("flash".equalsIgnoreCase(type)) {
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

                checkConnection();
             
            ps.setString(1, code);

            rs = ps.executeQuery();
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

    private void replaceCampaignProducts(Connection con, int campaignId, int[] variantIds) throws SQLException {
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

        String insertSql =
                "INSERT INTO [CampaignProduct] " +
                "(campaign_id, variant_id, sale_price, quantity_limit, sold_quantity, purchase_limit_per_user) " +
                "VALUES (?, ?, NULL, NULL, 0, 1)";

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
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }

    private BigDecimal calculateSalePrice(Campaign campaign, BigDecimal originalPrice, BigDecimal manualSalePrice) {
        if (manualSalePrice != null && manualSalePrice.compareTo(BigDecimal.ZERO) > 0) {
            return manualSalePrice.setScale(2, RoundingMode.HALF_UP);
        }

        BigDecimal original = nvl(originalPrice);
        BigDecimal discount = nvl(campaign.getDiscountValue());

        String type = campaign.getCampaignType() == null
                ? ""
                : campaign.getCampaignType().toLowerCase(Locale.ROOT);

        BigDecimal salePrice;

        if (type.contains("percentage")) {
            salePrice = original
                    .multiply(BigDecimal.valueOf(100).subtract(discount))
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        } else if (type.contains("fixed")) {
            salePrice = original.subtract(discount);
        } else {
            salePrice = original;
        }

        if (salePrice.compareTo(BigDecimal.ZERO) < 0) {
            salePrice = BigDecimal.ZERO;
        }

        return salePrice.setScale(2, RoundingMode.HALF_UP);
    }

    private void setTimestamp(PreparedStatement ps, int index, LocalDateTime value) throws SQLException {
        if (value == null) {
            ps.setNull(index, Types.TIMESTAMP);
        } else {
            ps.setTimestamp(index, Timestamp.valueOf(value));
        }
    }

    private LocalDateTime toLocalDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }

        return timestamp.toLocalDateTime();
    }

    private BigDecimal nvl(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }

        return value;
    }
}
//minhbq//26/4

package dal;

import jakarta.servlet.ServletContext;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import model.Campaign;
import model.CampaignProduct;
import model.CampaignSalesVolume;

public class CampaignDetailDAO extends CampaignDAO {
    /**
     * Chức năng: Khởi tạo lớp DAO chi tiết chiến dịch, kế thừa CampaignDAO.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ServletContext.
     * Đẩy/Gửi dữ liệu đi: Gọi Constructor lớp cha.
     * Action/Luồng đi: Truyền context lên lớp cha.
     */
    public CampaignDetailDAO(ServletContext context) {
        super(context);
    }

    /**
     * Chức năng: Truy vấn hiệu suất bán hàng của từng sản phẩm thuộc một chiến dịch cụ thể (gồm: số lượng bán, doanh thu, tồn kho, và tính toán giá khuyến mãi thực tế).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId, và các bảng dữ liệu: [CampaignProduct], [ProductVariant], [Product], [Category], [OrderDetail], [Order], [Inventory].
     * Đẩy/Gửi dữ liệu đi: Trả về danh sách `List<CampaignProduct>` chứa thông tin thống kê của từng sản phẩm khuyến mãi.
     * Action/Luồng đi:
     *   - Tải thông tin chung của Campaign.
     *   - Tạo câu lệnh SQL JOIN phức tạp để tổng hợp số lượng đã bán (chỉ tính các đơn hàng có trạng thái thành công/đang xử lý), doanh thu và số lượng tồn kho khả dụng của từng variant.
     *   - Thực thi, duyệt ResultSet và tính toán giá bán cuối cùng bằng `calculateSalePrice` dựa trên loại chiến dịch.
     *   - Thiết lập trạng thái tồn kho (Out of Stock, Low Stock, In Stock) cho sản phẩm và add vào danh sách trả về.
     */
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
                "    ISNULL(SUM(CASE " +
                "        WHEN o.order_status IN (N'delivered', N'shipped', N'processing', N'completed') " +
                "        THEN od.quantity * od.unit_price ELSE 0 END), 0) AS revenue, " +
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

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
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
                    item.setRevenue(nvl(rs.getBigDecimal("revenue")).setScale(2, RoundingMode.HALF_UP));
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
            }
        }

        return list;
    }

    /**
     * Chức năng: Tính tổng doanh thu thu về từ tất cả các sản phẩm thuộc chiến dịch.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId và danh sách hiệu suất sản phẩm qua getProductPerformance().
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng BigDecimal đại diện cho tổng doanh thu của chiến dịch.
     * Action/Luồng đi: Gọi `getProductPerformance`, cộng dồn doanh thu của từng sản phẩm và làm tròn 2 chữ số thập phân.
     */
    public BigDecimal getCampaignRevenue(int campaignId) throws SQLException {
        BigDecimal total = BigDecimal.ZERO;
        List<CampaignProduct> products = getProductPerformance(campaignId);

        for (CampaignProduct item : products) {
            total = total.add(nvl(item.getRevenue()));
        }

        return total.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Chức năng: Đếm số lượng khách hàng duy nhất (distinct user_id) đã mua hàng thành công có áp dụng sản phẩm khuyến mãi của chiến dịch.
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId và các bảng [CampaignProduct], [OrderDetail], [Order] trong DB.
     * Đẩy/Gửi dữ liệu đi: Trả về số lượng khách hàng duy nhất dạng int.
     * Action/Luồng đi: Thực thi SQL đếm DISTINCT `user_id` với điều kiện đơn hàng hợp lệ (delivered, shipped, processing, completed).
     */
    public int countCampaignCustomers(int campaignId) throws SQLException {
        String sql =
                "SELECT COUNT(DISTINCT o.user_id) AS customer_count " +
                "FROM [CampaignProduct] cp " +
                "JOIN [OrderDetail] od ON od.variant_id = cp.variant_id " +
                "JOIN [Order] o ON o.order_id = od.order_id " +
                "WHERE cp.campaign_id = ? " +
                "  AND o.user_id IS NOT NULL " +
                "  AND o.order_status IN (N'delivered', N'shipped', N'processing', N'completed')";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customer_count");
                }
            }
        }

        return 0;
    }

    /**
     * Chức năng: Tính tăng trưởng khách hàng duy nhất giữa hai chu kỳ thời gian liên tiếp (chu kỳ hiện tại vs chu kỳ trước đó).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId và số ngày của chu kỳ phân tích (days).
     * Đẩy/Gửi dữ liệu đi: Trả về giá trị số chênh lệch khách hàng tăng trưởng (hiện tại - trước đó).
     * Action/Luồng đi:
     *   - Tìm ngày bán hàng mới nhất của chiến dịch thông qua `getLatestSaleDate`.
     *   - Xác định khoảng thời gian chu kỳ hiện tại [currentStart, currentEnd] và chu kỳ trước đó [previousStart, previousEnd].
     *   - Gọi `countDistinctCustomersBetween` cho từng chu kỳ và tính hiệu số.
     */
    public int getCustomerGrowth(int campaignId, int days) throws SQLException {
        int safeDays = Math.max(1, days);
        LocalDate currentEnd = getLatestSaleDate(campaignId);

        if (currentEnd == null) {
            return 0;
        }

        LocalDate currentStart = currentEnd.minusDays(safeDays - 1L);
        LocalDate previousEnd = currentStart.minusDays(1);
        LocalDate previousStart = previousEnd.minusDays(safeDays - 1L);

        int currentCustomers = countDistinctCustomersBetween(campaignId, currentStart, currentEnd);
        int previousCustomers = countDistinctCustomersBetween(campaignId, previousStart, previousEnd);

        return currentCustomers - previousCustomers;
    }

    /**
     * Chức năng: Đếm số lượng khách hàng duy nhất mua sản phẩm khuyến mãi trong một khoảng thời gian xác định.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId, ngày bắt đầu startDate và ngày kết thúc endDate.
     * Đẩy/Gửi dữ liệu đi: Trả về số lượng khách hàng kiểu int.
     * Action/Luồng đi: Truy vấn SQL đếm DISTINCT `user_id` liên kết bảng Serial `OrderItemSerial` có trường ngày phân phối `assigned_at` nằm giữa 2 mốc truyền vào.
     */
    private int countDistinctCustomersBetween(int campaignId, LocalDate startDate, LocalDate endDate)
            throws SQLException {
        String sql =
                "SELECT COUNT(DISTINCT o.user_id) AS customer_count " +
                "FROM [CampaignProduct] cp " +
                "JOIN [OrderDetail] od ON od.variant_id = cp.variant_id " +
                "JOIN [Order] o ON o.order_id = od.order_id " +
                "JOIN [OrderItemSerial] ois ON ois.order_detail_id = od.order_detail_id " +
                "WHERE cp.campaign_id = ? " +
                "  AND o.user_id IS NOT NULL " +
                "  AND o.order_status IN (N'delivered', N'shipped', N'processing', N'completed') " +
                "  AND CAST(ois.assigned_at AS date) BETWEEN ? AND ?";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customer_count");
                }
            }
        }

        return 0;
    }

    /**
     * Chức năng: Lấy chuỗi dữ liệu doanh số theo thời gian để vẽ biểu đồ cột (chứa số sản phẩm đã bán và chiều cao tương đối của cột biểu diễn %).
     * Tác nhân liên quan: Admin / Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId và số lượng ngày (days) cần lấy biểu đồ.
     * Đẩy/Gửi dữ liệu đi: Trả về danh sách `List<CampaignSalesVolume>` chứa từng ngày và doanh số tương ứng, kèm chiều cao %.
     * Action/Luồng đi:
     *   - Tìm ngày bán gần nhất. Nếu không có dữ liệu bán, trả về danh sách rỗng.
     *   - Tải bản đồ số lượng bán của từng ngày từ DB bằng `loadSalesUnitsByDate`.
     *   - Duyệt qua từng ngày trong chu kỳ, tạo điểm dữ liệu, ghi nhận doanh số và tìm doanh số lớn nhất (maxUnits).
     *   - Duyệt lại danh sách điểm dữ liệu để tính tỷ lệ chiều cao phần trăm biểu diễn cột (chiều cao tối thiểu là 8% nếu có bán để cột không bị biến mất).
     */
    public List<CampaignSalesVolume> getSalesVolumeOverTime(int campaignId, int days) throws SQLException {
        int safeDays = Math.max(1, days);
        LocalDate endDate = getLatestSaleDate(campaignId);

        if (endDate == null) {
            return new ArrayList<>();
        }

        LocalDate startDate = endDate.minusDays(safeDays - 1L);
        Map<LocalDate, Integer> unitsByDate = loadSalesUnitsByDate(campaignId, startDate, endDate);
        List<CampaignSalesVolume> chart = new ArrayList<>();
        int maxUnits = 0;

        for (int i = 0; i < safeDays; i++) {
            LocalDate date = startDate.plusDays(i);
            int units = unitsByDate.getOrDefault(date, 0);
            maxUnits = Math.max(maxUnits, units);

            CampaignSalesVolume point = new CampaignSalesVolume();
            point.setSaleDate(date);
            point.setUnitsSold(units);
            chart.add(point);
        }

        for (CampaignSalesVolume point : chart) {
            int height = 0;

            if (maxUnits > 0 && point.getUnitsSold() > 0) {
                height = Math.max(8, (int) Math.round(point.getUnitsSold() * 100.0 / maxUnits));
            }

            point.setHeightPercent(height);
        }

        return chart;
    }

    /**
     * Chức năng: Tìm mốc ngày phát sinh giao dịch bán hàng gần nhất của chiến dịch trong hệ thống.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng LocalDate hoặc null nếu chiến dịch chưa bán được sản phẩm nào.
     * Action/Luồng đi: Thực thi câu lệnh SQL SELECT MAX trên trường `assigned_at` của bảng serial sản phẩm bán ra thuộc chiến dịch.
     */
    private LocalDate getLatestSaleDate(int campaignId) throws SQLException {
        String sql =
                "SELECT MAX(CAST(ois.assigned_at AS date)) AS latest_sale_date " +
                "FROM [CampaignProduct] cp " +
                "JOIN [OrderDetail] od ON od.variant_id = cp.variant_id " +
                "JOIN [Order] o ON o.order_id = od.order_id " +
                "JOIN [OrderItemSerial] ois ON ois.order_detail_id = od.order_detail_id " +
                "WHERE cp.campaign_id = ? " +
                "  AND o.order_status IN (N'delivered', N'shipped', N'processing', N'completed')";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Date latest = rs.getDate("latest_sale_date");

                    if (latest != null) {
                        return latest.toLocalDate();
                    }
                }
            }
        }

        return null;
    }

    /**
     * Chức năng: Tải số lượng sản phẩm bán ra của chiến dịch phân bổ theo từng ngày cụ thể nằm trong một khoảng thời gian.
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: ID chiến dịch campaignId, ngày bắt đầu startDate và ngày kết thúc endDate.
     * Đẩy/Gửi dữ liệu đi: Trả về Map ánh xạ từ mỗi LocalDate sang số lượng sản phẩm bán được trong ngày đó (int).
     * Action/Luồng đi: Thực hiện truy vấn GROUP BY ngày bán (`assigned_at`) và COUNT số lượng serial được gán, đưa kết quả vào cấu trúc Map.
     */
    private Map<LocalDate, Integer> loadSalesUnitsByDate(int campaignId, LocalDate startDate, LocalDate endDate)
            throws SQLException {
        Map<LocalDate, Integer> unitsByDate = new HashMap<>();

        String sql =
                "SELECT CAST(ois.assigned_at AS date) AS sale_date, " +
                "       COUNT(ois.order_item_serial_id) AS units_sold " +
                "FROM [CampaignProduct] cp " +
                "JOIN [OrderDetail] od ON od.variant_id = cp.variant_id " +
                "JOIN [Order] o ON o.order_id = od.order_id " +
                "JOIN [OrderItemSerial] ois ON ois.order_detail_id = od.order_detail_id " +
                "WHERE cp.campaign_id = ? " +
                "  AND o.order_status IN (N'delivered', N'shipped', N'processing', N'completed') " +
                "  AND CAST(ois.assigned_at AS date) BETWEEN ? AND ? " +
                "GROUP BY CAST(ois.assigned_at AS date) " +
                "ORDER BY sale_date";

        try (PreparedStatement ps = prepare(sql)) {
            ps.setInt(1, campaignId);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    unitsByDate.put(rs.getDate("sale_date").toLocalDate(), rs.getInt("units_sold"));
                }
            }
        }

        return unitsByDate;
    }

    /**
     * Chức năng: Tính toán đơn giá khuyến mãi cuối cùng của một sản phẩm dựa trên cấu hình giảm giá của chiến dịch (giảm theo % hoặc số tiền cố định).
     * Tác nhân liên quan: Hệ thống.
     * Nhận dữ liệu từ: Đối tượng chiến dịch Campaign, giá gốc của sản phẩm originalPrice và giá bán tùy chỉnh (manualSalePrice) nếu được chỉ định riêng lẻ.
     * Đẩy/Gửi dữ liệu đi: Trả về đối tượng BigDecimal chứa giá trị đơn giá khuyến mãi cuối cùng sau khi áp dụng các luật giảm giá.
     * Action/Luồng đi:
     *   - Nếu có giá khuyến mãi tùy chỉnh thủ công lớn hơn 0, ưu tiên lấy giá này.
     *   - Xác định loại chiến dịch (campaignType):
     *     + "percentage" hoặc "bundle_discount": Giá bán = Giá gốc * (100 - tỷ lệ giảm) / 100.
     *     + "fixed": Giá bán = Giá gốc - số tiền giảm cố định.
     *     + Ngược lại: Giá bán = Giá gốc.
     *   - Đảm bảo giá bán không bao giờ âm (nhỏ nhất là 0) và làm tròn 2 chữ số thập phân.
     */
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

        if (type.contains("percentage") || type.contains("bundle_discount") || type.contains("flash")) {
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
}

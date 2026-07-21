package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class VoucherDAO extends DBContext {

    public VoucherDAO() {
        super();
        ensureColumnsExist();
    }

    private void ensureColumnsExist() {
        if (connection == null) return;
        try (java.sql.Statement s = connection.createStatement()) {
            // 1. Kiểm tra và thêm cột user_id
            s.execute("IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'user_id') " +
                      "BEGIN ALTER TABLE [dbo].[Campaign] ADD [user_id] INT NULL FOREIGN KEY REFERENCES [User]([user_id]) ON DELETE SET NULL; END");
            
            // 2. Kiểm tra và thêm cột is_new_user_only
            s.execute("IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'is_new_user_only') " +
                      "BEGIN ALTER TABLE [dbo].[Campaign] ADD [is_new_user_only] BIT NOT NULL DEFAULT 0; END");

            // 3. Kiểm tra và thêm cột user_usage_limit
            s.execute("IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Campaign]') AND name = 'user_usage_limit') " +
                      "BEGIN ALTER TABLE [dbo].[Campaign] ADD [user_usage_limit] INT NULL; END");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static class VoucherInfo {
        public String code;
        public String type; // "percentage" or "fixed"
        public BigDecimal discountValue;
        public BigDecimal minOrderValue;
        public boolean isValid;
        public String message;
        public int id;
        public boolean isCampaign;
    }

    public VoucherInfo getVoucher(String code, BigDecimal orderTotal) {
        VoucherInfo info = new VoucherInfo();
        info.code = code;
        info.isValid = false;
        info.message = "Mã giảm giá không tồn tại.";
        info.isCampaign = false;

        if (code == null || code.trim().isEmpty()) {
            info.message = "Mã giảm giá không được để trống.";
            return info;
        }

        String cleanCode = code.trim();

        // 1. Check in Campaign table first (since it is the main promotion table)
        String campaignSql = "SELECT * FROM [Campaign] WHERE UPPER(promo_code) = UPPER(?)";
        try (PreparedStatement ps = connection.prepareStatement(campaignSql)) {
            ps.setString(1, cleanCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    Timestamp start = rs.getTimestamp("start_date");
                    Timestamp end = rs.getTimestamp("end_date");
                    int used = rs.getInt("used_count");

                    int limit = 0;
                    boolean hasLimit = false;
                    Object limitObj = rs.getObject("usage_limit");
                    if (limitObj != null) {
                        limit = ((Number) limitObj).intValue();
                        hasLimit = true;
                    }

                    BigDecimal minVal = rs.getBigDecimal("min_order_value");
                    BigDecimal discVal = rs.getBigDecimal("discount_value");
                    String campaignType = rs.getString("campaign_type");
                    int id = rs.getInt("campaign_id");

                    Timestamp now = new Timestamp(System.currentTimeMillis());

                    if (!"active".equalsIgnoreCase(status)) {
                        info.message = "Mã giảm giá này hiện không hoạt động.";
                        return info;
                    }
                    if (start != null && now.before(start)) {
                        info.message = "Mã giảm giá chưa đến thời gian sử dụng.";
                        return info;
                    }
                    if (end != null && now.after(end)) {
                        info.message = "Mã giảm giá đã hết hạn.";
                        return info;
                    }
                    Object userLimitObj = rs.getObject("user_usage_limit");
                    if (userLimitObj != null) {
                        info.message = "Vui lòng đăng nhập để sử dụng mã giảm giá giới hạn lượt dùng cá nhân này.";
                        return info;
                    }

                    if (hasLimit && used >= limit) {
                        info.message = "Mã giảm giá đã đạt giới hạn số lần sử dụng.";
                        return info;
                    }
                    if (minVal != null && orderTotal.compareTo(minVal) < 0) {
                        info.message = "Đơn hàng tối thiểu để áp dụng mã này là " + String.format("%,.0f", minVal)
                                + "₫.";
                        return info;
                    }

                    info.isValid = true;
                    if ("percentage".equalsIgnoreCase(campaignType) || 
                        (discVal.compareTo(new BigDecimal("100")) <= 0 && !"fixed".equalsIgnoreCase(campaignType))) {
                        info.type = "percentage";
                    } else {
                        info.type = "fixed";
                    }
                    info.discountValue = discVal;
                    info.minOrderValue = minVal;
                    info.message = "Áp dụng mã giảm giá thành công!";
                    info.id = id;
                    info.isCampaign = true;
                    return info;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            info.message = "Lỗi hệ thống khi kiểm tra mã giảm giá: " + e.getMessage();
            return info;
        }

        // 2. Fallback to Voucher table
        String voucherSql = "SELECT * FROM [Voucher] WHERE UPPER(voucher_code) = UPPER(?)";
        try (PreparedStatement ps = connection.prepareStatement(voucherSql)) {
            ps.setString(1, cleanCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp expiry = rs.getTimestamp("expiry_date");
                    BigDecimal minVal = rs.getBigDecimal("min_order_value");
                    BigDecimal discVal = rs.getBigDecimal("discount_value");
                    int id = rs.getInt("voucher_id");

                    Timestamp now = new Timestamp(System.currentTimeMillis());

                    if (expiry != null && now.after(expiry)) {
                        info.message = "Mã giảm giá đã hết hạn.";
                        return info;
                    }
                    if (minVal != null && orderTotal.compareTo(minVal) < 0) {
                        info.message = "Đơn hàng tối thiểu để áp dụng mã này là " + String.format("%,.0f", minVal)
                                + "₫.";
                        return info;
                    }

                    info.isValid = true;
                    // Heuristic: if discount value <= 100, assume percentage (e.g. 10.00 is 10%)
                    if (discVal.compareTo(new BigDecimal("100")) <= 0) {
                        info.type = "percentage";
                    } else {
                        info.type = "fixed";
                    }
                    info.discountValue = discVal;
                    info.minOrderValue = minVal;
                    info.message = "Áp dụng mã giảm giá thành công!";
                    info.id = id;
                    info.isCampaign = false;
                    return info;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            info.message = "Lỗi hệ thống khi kiểm tra mã giảm giá: " + e.getMessage();
            return info;
        }

        return info;
    }

    // Nạp chồng hàm getVoucher để kiểm tra quyền sở hữu và trạng thái sử dụng của từng User cụ thể qua bảng Campaign và Order
    public VoucherInfo getVoucher(String code, BigDecimal orderTotal, int userId) {
        VoucherInfo info = new VoucherInfo();
        info.code = code;
        info.isValid = false;
        info.message = "Mã giảm giá không tồn tại.";
        info.isCampaign = true; // Hợp nhất Voucher vào Campaign nên tất cả đều là Campaign

        if (code == null || code.trim().isEmpty()) {
            info.message = "Mã giảm giá không được để trống.";
            return info;
        }

        String cleanCode = code.trim();

        // Kiểm tra trực tiếp trong bảng Campaign (Bảng khuyến mãi duy nhất của hệ thống)
        String campaignSql = "SELECT * FROM [Campaign] WHERE UPPER(promo_code) = UPPER(?)";
        try (PreparedStatement ps = connection.prepareStatement(campaignSql)) {
            ps.setString(1, cleanCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    Timestamp start = rs.getTimestamp("start_date");
                    Timestamp end = rs.getTimestamp("end_date");
                    int used = rs.getInt("used_count");
                    int campaignId = rs.getInt("campaign_id");
                    Object ownerIdObj = rs.getObject("user_id");
                    boolean isNewUserOnly = rs.getBoolean("is_new_user_only");
                    
                    int limit = 0;
                    boolean hasLimit = false;
                    Object limitObj = rs.getObject("usage_limit");
                    if (limitObj != null) {
                        limit = ((Number) limitObj).intValue();
                        hasLimit = true;
                    }
                    
                    BigDecimal minVal = rs.getBigDecimal("min_order_value");
                    BigDecimal discVal = rs.getBigDecimal("discount_value");
                    if (discVal == null) discVal = BigDecimal.ZERO;
                    String campaignType = rs.getString("campaign_type");

                    Timestamp now = new Timestamp(System.currentTimeMillis());

                    // 1. Kiểm tra trạng thái hoạt động
                    if (!"active".equalsIgnoreCase(status)) {
                        info.message = "Mã giảm giá này hiện không hoạt động.";
                        return info;
                    }
                    // 2. Kiểm tra thời gian
                    if (start != null && now.before(start)) {
                        info.message = "Mã giảm giá chưa đến thời gian sử dụng.";
                        return info;
                    }
                    if (end != null && now.after(end)) {
                        info.message = "Mã giảm giá đã hết hạn.";
                        return info;
                    }

                    // 3. Kiểm tra quyền sở hữu đối với mã cá nhân hóa
                    if (ownerIdObj != null) {
                        int ownerId = ((Number) ownerIdObj).intValue();
                        if (ownerId != userId) {
                            info.message = "Bạn không sở hữu mã giảm giá này.";
                            return info;
                        }
                    }

                    // 4. Kiểm tra điều kiện "Khách hàng mới" (New User)
                    if (isNewUserOnly && userId > 0) {
                        String checkNewUserSql = "SELECT COUNT(*) FROM [Order] WHERE user_id = ? AND order_status <> 'cancelled'";
                        try (PreparedStatement checkNewUserPs = connection.prepareStatement(checkNewUserSql)) {
                            checkNewUserPs.setInt(1, userId);
                            try (ResultSet checkNewUserRs = checkNewUserPs.executeQuery()) {
                                if (checkNewUserRs.next() && checkNewUserRs.getInt(1) > 0) {
                                    info.message = "Mã giảm giá này chỉ áp dụng cho tài khoản mới mua hàng lần đầu.";
                                    return info;
                                }
                            }
                        }
                    }

                    // 5. Kiểm tra giới hạn số lần sử dụng của mỗi User (user_usage_limit)
                    Object userLimitObj = rs.getObject("user_usage_limit");
                    int userLimit = (userLimitObj != null) ? ((Number) userLimitObj).intValue() : 1;
                    
                    String checkUsedSql = "SELECT COUNT(*) FROM [Order] WHERE user_id = ? AND voucher_id = ? AND order_status <> 'cancelled'";
                    try (PreparedStatement checkPs = connection.prepareStatement(checkUsedSql)) {
                        checkPs.setInt(1, userId);
                        checkPs.setInt(2, campaignId);
                        try (ResultSet checkRs = checkPs.executeQuery()) {
                            if (checkRs.next()) {
                                int userUsedCount = checkRs.getInt(1);
                                if (userUsedCount >= userLimit) {
                                    info.message = "Bạn đã sử dụng hết lượt cho mã giảm giá này (Tối đa " + userLimit + " lần/người dùng).";
                                    return info;
                                }
                            }
                        }
                    }

                    // 6. Kiểm tra giới hạn số lần sử dụng của cả hệ thống (nếu có giới hạn lớn hơn 1)
                    if (hasLimit && limit > 1 && used >= limit) {
                        info.message = "Mã giảm giá đã đạt giới hạn số lần sử dụng.";
                        return info;
                    }

                    // 7. Kiểm tra đơn hàng tối thiểu
                    if (minVal != null && orderTotal.compareTo(minVal) < 0) {
                        info.message = "Đơn hàng tối thiểu để áp dụng mã này là " + String.format("%,.0f", minVal) + "₫.";
                        return info;
                    }

                    info.isValid = true;
                    if ("percentage".equalsIgnoreCase(campaignType) || 
                        (discVal.compareTo(new BigDecimal("100")) <= 0 && !"fixed".equalsIgnoreCase(campaignType))) {
                        info.type = "percentage";
                    } else {
                        info.type = "fixed";
                    }
                    info.discountValue = discVal;
                    info.minOrderValue = minVal;
                    info.message = "Áp dụng mã giảm giá thành công!";
                    info.id = campaignId;
                    return info;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            info.message = "Lỗi hệ thống khi kiểm tra mã giảm giá: " + e.getMessage();
            return info;
        }

        return info;
    }

    // Lấy toàn bộ mã giảm giá còn hạn của User (dành riêng hoặc dùng chung) trực tiếp từ bảng Campaign
    public java.util.List<model.UserVoucherDTO> getUserVouchers(int userId) {
        java.util.List<model.UserVoucherDTO> list = new java.util.ArrayList<>();
        
        // Query: Lấy các campaign dành riêng cho user hoặc dùng chung (user_id IS NULL)
        // Đồng thời đếm số lần sử dụng của chính user này đối với campaign đó trong bảng Order
        // Nếu campaign chỉ áp dụng cho người dùng mới (is_new_user_only = 1), ta loại trừ nếu user đã có lịch sử đặt hàng
        String sql = "SELECT c.campaign_id AS voucher_id, c.promo_code AS voucher_code, c.discount_value, c.min_order_value, c.end_date AS expiry_date, c.user_usage_limit, c.campaign_description, " +
                     "  (SELECT COUNT(*) FROM [Order] o " +
                     "   WHERE o.user_id = ? AND o.voucher_id = c.campaign_id AND o.order_status <> 'cancelled') as used_count " +
                     "FROM [Campaign] c " +
                     "WHERE (c.user_id = ? OR (c.user_id IS NULL AND c.is_new_user_only = 0)) " +
                     "  AND UPPER(c.status) = 'ACTIVE' " +
                     "  AND (c.start_date IS NULL OR c.start_date <= CURRENT_TIMESTAMP) " +
                     "  AND (c.end_date IS NULL OR c.end_date >= CURRENT_TIMESTAMP) " +
                     "  AND (c.is_new_user_only = 0 OR NOT EXISTS ( " +
                     "      SELECT 1 FROM [Order] o2 WHERE o2.user_id = ? AND o2.order_status <> 'cancelled' " +
                     "  )) " +
                     "ORDER BY c.discount_value DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.UserVoucherDTO dto = new model.UserVoucherDTO();
                    dto.setVoucherId(rs.getInt("voucher_id"));
                    dto.setVoucherCode(rs.getString("voucher_code"));
                    dto.setDiscountValue(rs.getBigDecimal("discount_value"));
                    dto.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    dto.setExpiryDate(rs.getTimestamp("expiry_date"));
                    dto.setDescription(rs.getString("campaign_description"));
                    
                    int usedCount = rs.getInt("used_count");
                    Object userLimitObj = rs.getObject("user_usage_limit");
                    int userLimit = (userLimitObj != null) ? ((Number) userLimitObj).intValue() : 1;
                    dto.setUsed(usedCount >= userLimit);
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tính tiền giảm giá thực tế dựa trên danh sách các sản phẩm hợp lệ trong giỏ hàng (chọn mặt hàng đắt nhất để trừ)
    public BigDecimal calculateActualDiscount(int campaignId, String type, BigDecimal discountValue, java.util.List<model.CartItem> cart) {
        if (cart == null || cart.isEmpty()) return BigDecimal.ZERO;
        
        // 1. Lấy danh sách variant_id được phép áp dụng cho Campaign này từ bảng CampaignProduct
        java.util.Set<Integer> eligibleVariants = new java.util.HashSet<>();
        String sql = "SELECT variant_id FROM [CampaignProduct] WHERE campaign_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    eligibleVariants.add(rs.getInt("variant_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 2. Tìm mặt hàng thỏa mãn điều kiện Voucher có đơn giá (UnitPrice) lớn nhất trong giỏ hàng
        model.CartItem targetItem = null;
        BigDecimal maxPrice = BigDecimal.ZERO;
        for (model.CartItem it : cart) {
            if (eligibleVariants.isEmpty() || eligibleVariants.contains(it.getVariantId())) {
                BigDecimal unitPrice = it.getUnitPrice();
                if (unitPrice.compareTo(maxPrice) > 0) {
                    maxPrice = unitPrice;
                    targetItem = it;
                }
            }
        }

        // 3. Nếu không tìm thấy bất kỳ mặt hàng nào thỏa mãn điều kiện Voucher
        if (targetItem == null) {
            return BigDecimal.ZERO;
        }

        // 4. Tính toán tiền giảm giá dựa trên mặt hàng đắt nhất được chọn
        BigDecimal eligibleTotal = targetItem.getSubtotal();
        BigDecimal discount = BigDecimal.ZERO;
        if ("percentage".equalsIgnoreCase(type)) {
            discount = eligibleTotal.multiply(discountValue).divide(new BigDecimal("100"));
        } else {
            discount = discountValue;
        }

        // 5. Mức giảm giá không được phép vượt quá giá trị thành tiền của mặt hàng đó
        if (discount.compareTo(eligibleTotal) > 0) {
            discount = eligibleTotal;
        }
        return discount;
    }

    // Tự động tìm kiếm voucher có lợi nhất cho User trên tổng giá trị đơn hàng (hỗ trợ tính toán sản phẩm cụ thể)
    public model.UserVoucherDTO getBestVoucherForOrder(int userId, BigDecimal orderTotal, java.util.List<model.CartItem> cart) {
        java.util.List<model.UserVoucherDTO> myVouchers = getUserVouchers(userId);
        model.UserVoucherDTO bestVoucher = null;
        BigDecimal maxDiscount = BigDecimal.ZERO;

        for (model.UserVoucherDTO v : myVouchers) {
            if (v.isUsed()) continue; // Bỏ qua các voucher đã được sử dụng từ trước

            BigDecimal minVal = v.getMinOrderValue();
            if (minVal == null) minVal = BigDecimal.ZERO;

            if (orderTotal.compareTo(minVal) >= 0) {
                // Xác định loại giảm giá của Voucher
                String vType = "fixed";
                if (v.getDiscountValue().compareTo(new BigDecimal("100")) <= 0) {
                    vType = "percentage";
                }

                // Tính tiền giảm giá thực tế dựa trên danh sách các sản phẩm hợp lệ trong giỏ hàng
                BigDecimal actualDiscount = calculateActualDiscount(v.getVoucherId(), vType, v.getDiscountValue(), cart);

                if (actualDiscount.compareTo(maxDiscount) > 0) {
                    maxDiscount = actualDiscount;
                    bestVoucher = v;
                    bestVoucher.setAvailable(true);
                    bestVoucher.setDiscountAmountActual(actualDiscount);
                    bestVoucher.setMissingAmount(BigDecimal.ZERO);
                }
            }
        }
        return bestVoucher;
    }

    // Nạp chồng phương thức cũ để đảm bảo khả năng tương thích ngược
    public model.UserVoucherDTO getBestVoucherForOrder(int userId, BigDecimal orderTotal) {
        return getBestVoucherForOrder(userId, orderTotal, new java.util.ArrayList<>());
    }

    // Giữ lại khai báo phương thức cũ để tránh lỗi compile nếu có file khác gọi
    public boolean useUserVoucher(int userId, int voucherId) {
        return true; 
    }

    public boolean releaseUserVoucher(int userId, int voucherId) {
        return true; 
    }

    public void incrementUsedCount(Integer voucherOrCampaignId, boolean isCampaign) {
        if (voucherOrCampaignId == null)
            return;
        if (isCampaign) {
            String sql = "UPDATE [Campaign] SET used_count = used_count + 1 WHERE campaign_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, voucherOrCampaignId);
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println("incrementUsedCount Error: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}

package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class VoucherDAO extends DBContext {

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
                    if (hasLimit && used >= limit) {
                        info.message = "Mã giảm giá đã đạt giới hạn số lần sử dụng.";
                        return info;
                    }
                    if (minVal != null && orderTotal.compareTo(minVal) < 0) {
                        info.message = "Đơn hàng tối thiểu để áp dụng mã này là " + String.format("%,.0f", minVal) + "₫.";
                        return info;
                    }

                    info.isValid = true;
                    info.type = campaignType;
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
                        info.message = "Đơn hàng tối thiểu để áp dụng mã này là " + String.format("%,.0f", minVal) + "₫.";
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

    public void incrementUsedCount(Integer voucherOrCampaignId, boolean isCampaign) {
        if (voucherOrCampaignId == null) return;
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

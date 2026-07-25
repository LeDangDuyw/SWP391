package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RewardVoucher;

/*
 * Name: RewardDAO.java
 * @Author: LUCTV
 * Date: [24/07/2026]
 * Version: 1.0
 * Description: Data Access Object xử lý các giao dịch đổi điểm thưởng tích lũy lấy Voucher.
 */
public class RewardDAO extends DBContext {
    private Connection cnn;

    public RewardDAO() {
        this.cnn = super.connection;
    }

    private void checkConnection() throws SQLException {
        if (cnn == null || cnn.isClosed()) {
            this.cnn = getConnection();
        }
    }

    /*
     * Name: getAvailableRewardVouchers
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Lấy danh sách tất cả các Voucher thưởng đang kích hoạt hệ thống.
     */
    public List<RewardVoucher> getAvailableRewardVouchers() {
        List<RewardVoucher> list = new ArrayList<>();
        String sql = "SELECT * FROM RewardVoucher WHERE status = 'active' ORDER BY points_required ASC";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RewardVoucher rv = new RewardVoucher();
                    rv.setRewardVoucherId(rs.getInt("reward_voucher_id"));
                    rv.setTitle(rs.getString("title"));
                    rv.setVoucherCodePrefix(rs.getString("voucher_code_prefix"));
                    rv.setDiscountValue(rs.getBigDecimal("discount_value"));
                    rv.setPointsRequired(rs.getInt("points_required"));
                    rv.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    rv.setDescription(rs.getString("description"));
                    rv.setStatus(rs.getString("status"));
                    list.add(rv);
                }
            }
        } catch (SQLException e) {
            System.err.println("RewardDAO.getAvailableRewardVouchers Error: " + e.getMessage());
        }
        return list;
    }

    /*
     * Name: getRewardVoucherById
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Lấy thông tin chi tiết một Voucher thưởng theo ID.
     */
    public RewardVoucher getRewardVoucherById(int rewardVoucherId) {
        String sql = "SELECT * FROM RewardVoucher WHERE reward_voucher_id = ? AND status = 'active'";
        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setInt(1, rewardVoucherId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        RewardVoucher rv = new RewardVoucher();
                        rv.setRewardVoucherId(rs.getInt("reward_voucher_id"));
                        rv.setTitle(rs.getString("title"));
                        rv.setVoucherCodePrefix(rs.getString("voucher_code_prefix"));
                        rv.setDiscountValue(rs.getBigDecimal("discount_value"));
                        rv.setPointsRequired(rs.getInt("points_required"));
                        rv.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                        rv.setDescription(rs.getString("description"));
                        rv.setStatus(rs.getString("status"));
                        return rv;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("RewardDAO.getRewardVoucherById Error: " + e.getMessage());
        }
        return null;
    }

    /*
     * Name: redeemVoucher
     * @Author: LUCTV
     * Date: [24/07/2026]
     * Version: 1.0
     * Description: Thực hiện giao dịch đổi điểm thưởng lấy Voucher. Nếu trừ điểm thành công nhưng tạo voucher thất bại thì rollback lại điểm.
     */
    public boolean redeemVoucher(int userId, int rewardVoucherId) {
        RewardVoucher rv = getRewardVoucherById(rewardVoucherId);
        if (rv == null) return false;

        UserDAO userDAO = new UserDAO();
        // Step 1: Deduct points
        boolean pointsDeducted = userDAO.deductRewardPoints(userId, rv.getPointsRequired());
        if (!pointsDeducted) {
            return false;
        }

        // Step 2: Generate unique personal voucher in Campaign table
        String promoCode = rv.getVoucherCodePrefix() + "_" + userId + "_" + (System.currentTimeMillis() % 10000);
        String sql = "INSERT INTO [Campaign] ([campaign_name], [promo_code], [discount_value], [min_order_value], [start_date], [end_date], [status], [campaign_type], [created_at], [updated_at], [user_id], [user_usage_limit]) "
                   + "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, DATEADD(DAY, 30, CURRENT_TIMESTAMP), 'active', 'fixed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, 1)";

        try {
            checkConnection();
            try (PreparedStatement ps = cnn.prepareStatement(sql)) {
                ps.setString(1, rv.getTitle() + " (Thưởng Tích Điểm)");
                ps.setString(2, promoCode);
                ps.setBigDecimal(3, rv.getDiscountValue());
                ps.setBigDecimal(4, rv.getMinOrderValue());
                ps.setInt(5, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("RewardDAO.redeemVoucher Insert Campaign Error: " + e.getMessage());
            // Rollback points if voucher generation failed
            userDAO.addRewardPoints(userId, rv.getPointsRequired());
            return false;
        }
    }
}

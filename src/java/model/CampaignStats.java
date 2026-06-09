package model;
//minhbq//26/4
import java.math.BigDecimal;

/**
 * Class CampaignStats đại diện cho số liệu thống kê tổng quan của các chiến dịch trên Dashboard.
 * Bao gồm các thông số đếm số lượng chiến dịch theo trạng thái và tổng số lượt sử dụng voucher.
 * Tác nhân liên quan: Admin xem số liệu tổng quan.
 */
public class CampaignStats {
    private int activeCampaigns;
    private int pendingApprovals;
    private int totalRedemptions;
    private int totalCampaigns;
    private BigDecimal totalRevenue = BigDecimal.ZERO;

    public int getActiveCampaigns() { return activeCampaigns; }
    public void setActiveCampaigns(int activeCampaigns) { this.activeCampaigns = activeCampaigns; }
    public int getPendingApprovals() { return pendingApprovals; }
    public void setPendingApprovals(int pendingApprovals) { this.pendingApprovals = pendingApprovals; }
    public int getTotalRedemptions() { return totalRedemptions; }
    public void setTotalRedemptions(int totalRedemptions) { this.totalRedemptions = totalRedemptions; }
    public int getTotalCampaigns() { return totalCampaigns; }
    public void setTotalCampaigns(int totalCampaigns) { this.totalCampaigns = totalCampaigns; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
}

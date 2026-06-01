package Model;

import java.math.BigDecimal;

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

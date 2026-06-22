package model;

public class CampaignBanner {
    private int bannerId;
    private String imageUrl;
    private boolean status;

    public CampaignBanner() {
    }

    public CampaignBanner(int bannerId, String imageUrl, boolean status) {
        this.bannerId = bannerId;
        this.imageUrl = imageUrl;
        this.status = status;
    }

    public int getBannerId() {
        return bannerId;
    }

    public void setBannerId(int bannerId) {
        this.bannerId = bannerId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
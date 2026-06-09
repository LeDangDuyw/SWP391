package model;
//minhbq//26/4
import java.time.LocalDate;

/**
 * Class CampaignSalesVolume đại diện cho doanh số bán hàng (số lượng sản phẩm bán ra) theo từng ngày cụ thể.
 * Dùng để chuẩn bị dữ liệu hiển thị biểu đồ hiệu suất chiến dịch.
 * Tác nhân liên quan: Admin xem biểu đồ, Hệ thống thống kê dữ liệu.
 */
public class CampaignSalesVolume {
    private LocalDate saleDate;
    private int unitsSold;
    private int heightPercent;

    public LocalDate getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(LocalDate saleDate) {
        this.saleDate = saleDate;
    }

    public int getUnitsSold() {
        return unitsSold;
    }

    public void setUnitsSold(int unitsSold) {
        this.unitsSold = unitsSold;
    }

    public int getHeightPercent() {
        return heightPercent;
    }

    public void setHeightPercent(int heightPercent) {
        this.heightPercent = heightPercent;
    }
}

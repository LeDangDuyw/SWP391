/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import dal.DBContext;
import model.Brand;
import model.CampaignBanner;

/**
 *
 * @author ASUS
 */
public class CampaignBannerDAO extends DBContext {

    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public CampaignBannerDAO() {
        connect();
    }

    private void connect() {

        cnn = super.connection;

        if (cnn != null) {
            System.out.println("Connect success");
        } else {
            System.out.println("Connect fail");
        }
    }

    public List<CampaignBanner> getHomeBanners() {
        List<CampaignBanner> list = new ArrayList<>();

        String sql = """
                 SELECT banner_id, image_url, status
                 FROM CampaignBanner
                 WHERE status = 1
                 ORDER BY banner_id
                 """;

        try {
            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                CampaignBanner banner = new CampaignBanner();

                banner.setBannerId(rs.getInt("banner_id"));
                banner.setImageUrl(rs.getString("image_url"));
                banner.setStatus(rs.getBoolean("status"));

                list.add(banner);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

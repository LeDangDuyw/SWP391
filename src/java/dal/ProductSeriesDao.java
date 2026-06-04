/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.Category;
import dal.DBContext;
import model.ProductSeries;

/**
 *
 * @author Cao Tuấn Minh
 */
public class ProductSeriesDAO extends DBContext {

    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public ProductSeriesDAO() {
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
    // lấy danh sách series loptop
   public ArrayList<ProductSeries> getSeriesByBrand(int brandId) {
    ArrayList<ProductSeries> data = new ArrayList<>();
    try {
        String sql = """
            SELECT
                series_id,
                series_name,
                brand_id
            FROM ProductSeries
            WHERE brand_id = ?
            ORDER BY series_name
        """;
        ps = cnn.prepareStatement(sql);
        ps.setInt(1, brandId);
        rs = ps.executeQuery();
        while (rs.next()) {
            ProductSeries s = new ProductSeries();
            s.setSeriesId(rs.getInt("series_id"));
            s.setSeriesName(rs.getString("series_name"));
            s.setBrandId(rs.getInt("brand_id"));
            data.add(s);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return data;
}
}

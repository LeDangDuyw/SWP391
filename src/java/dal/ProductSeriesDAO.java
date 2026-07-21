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

/*
 * Name: ProductSeriesDAO
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý dữ liệu dòng sản phẩm (Product Series)
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

    // lấy tất cả danh sách series
    public ArrayList<ProductSeries> getAllSeries() {
        ArrayList<ProductSeries> data = new ArrayList<>();
        try {
            String sql = """
                SELECT
                    series_id,
                    series_name,
                    brand_id
                FROM ProductSeries
                ORDER BY series_name
            """;
            ps = cnn.prepareStatement(sql);
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

    public boolean isSeriesExist(String name, int brandId) {
        try {
            String sql = "SELECT 1 FROM ProductSeries WHERE LOWER(series_name) = ? AND brand_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, name.trim().toLowerCase());
            ps.setInt(2, brandId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int insertSeries(String seriesName, int brandId) {
        try {
            String sql = "INSERT INTO ProductSeries (series_name, brand_id) VALUES (?, ?)";
            ps = cnn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, seriesName.trim());
            ps.setInt(2, brandId);
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}

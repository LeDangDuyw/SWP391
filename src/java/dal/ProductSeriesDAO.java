package dal;

import java.sql.*;
import java.util.*;
import model.ProductSeries;

/*
 * Name: ProductSeriesDAO
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý dữ liệu dòng sản phẩm (Product Series) thuộc danh mục sản phẩm (Product Catalog).
 */
public class ProductSeriesDAO extends DBContext {

    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Khởi tạo đối tượng ProductSeriesDAO và kết nối CSDL.
     */
    public ProductSeriesDAO() {
        connect();
    }

    /**
     * Thực hiện kết nối tới cơ sở dữ liệu.
     */
    private void connect() {
        cnn = super.connection;
        if (cnn != null) {
            System.out.println("Connect success");
        } else {
            System.out.println("Connect fail");
        }
    }

    /**
     * Lấy danh sách các dòng sản phẩm thuộc một thương hiệu chỉ định.
     * 
     * @param brandId Mã ID của thương hiệu
     * @return Danh sách các đối tượng ProductSeries tương ứng
     */
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

    /**
     * Lấy toàn bộ danh sách tất cả các dòng sản phẩm hiện có trong CSDL.
     * 
     * @return Danh sách tất cả các đối tượng ProductSeries
     */
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

    /**
     * Kiểm tra xem tên dòng sản phẩm đã tồn tại thuộc thương hiệu đó hay chưa.
     * 
     * @param name Tên dòng sản phẩm cần kiểm tra
     * @param brandId Mã ID thương hiệu
     * @return true nếu đã tồn tại, ngược lại false
     */
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

    /**
     * Thêm một dòng sản phẩm mới gắn liền với thương hiệu tương ứng và trả về ID vừa sinh.
     * 
     * @param seriesName Tên dòng sản phẩm mới
     * @param brandId Mã ID thương hiệu gắn liền
     * @return Mã ID dòng sản phẩm vừa tạo nếu thành công, ngược lại -1
     */
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

    /**
     * Cập nhật tên dòng sản phẩm theo ID.
     * 
     * @param seriesId Mã ID dòng sản phẩm
     * @param newSeriesName Tên dòng sản phẩm mới
     * @return true nếu thành công, ngược lại false
     */
    public boolean updateSeries(int seriesId, String newSeriesName) {
        if (newSeriesName == null || newSeriesName.trim().isEmpty()) {
            return false;
        }
        try {
            String sql = "UPDATE ProductSeries SET series_name = ? WHERE series_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, newSeriesName.trim());
            ps.setInt(2, seriesId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateSeries Error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đếm số lượng sản phẩm thuộc dòng sản phẩm chỉ định.
     * 
     * @param seriesId Mã ID dòng sản phẩm
     * @return Số lượng sản phẩm liên kết
     */
    public int getProductCountBySeries(int seriesId) {
        try {
            String sql = "SELECT COUNT(*) FROM Product WHERE series_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, seriesId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getProductCountBySeries Error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Xóa một dòng sản phẩm khỏi CSDL theo ID.
     * 
     * @param seriesId Mã ID dòng sản phẩm cần xóa
     * @return true nếu xóa thành công, ngược lại false
     */
    public boolean deleteSeries(int seriesId) {
        try {
            String sql = "DELETE FROM ProductSeries WHERE series_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, seriesId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("deleteSeries Error: " + e.getMessage());
        }
        return false;
    }
}


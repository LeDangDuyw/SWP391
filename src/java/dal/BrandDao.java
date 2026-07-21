package dal;

import java.sql.*;
import java.util.*;
import model.Brand;

/*
 * Name: BrandDao
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý dữ liệu thương hiệu (Brand) phục vụ danh mục sản phẩm (Product Catalog).
 */
public class BrandDao extends DBContext {
    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Khởi tạo đối tượng BrandDao và kết nối CSDL.
     */
    public BrandDao() {
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
     * Lấy tất cả các thương hiệu có sản phẩm thuộc danh mục chỉ định.
     * 
     * @param categoryId Mã ID danh mục sản phẩm
     * @return Danh sách các thương hiệu thuộc danh mục
     */
    public ArrayList<Brand> getBrandsByCategory(int categoryId) {
        ArrayList<Brand> data = new ArrayList<>();
        try {
            String sql = """
                SELECT DISTINCT
                    b.brand_id,
                    b.brand_name
                FROM Product p
                JOIN Brand b
                    ON p.brand_id = b.brand_id
                WHERE p.category_id = ?
                ORDER BY b.brand_name
            """;
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setBrandName(rs.getString("brand_name"));
                data.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    /**
     * Lấy toàn bộ danh sách thương hiệu hiện có trong hệ thống.
     * 
     * @return Danh sách các đối tượng Brand
     */
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Brand";
            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Brand b = new Brand(rs.getInt("brand_id"), rs.getString("brand_name"));
                brands.add(b);
            }
        } catch (Exception e) {
            System.out.println("getAllBrands Error: " + e.getMessage());
        }
        return brands;
    }

    /**
     * Kiểm tra tên thương hiệu đã tồn tại trong CSDL hay chưa (không phân biệt hoa/thường).
     * 
     * @param brandName Tên thương hiệu cần kiểm tra
     * @return true nếu đã tồn tại, ngược lại false
     */
    public boolean isBrandExist(String brandName) {
        if (brandName == null || brandName.trim().isEmpty()) {
            return false;
        }
        try {
            String sql = "SELECT COUNT(*) FROM Brand WHERE LOWER(brand_name) = LOWER(?)";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, brandName.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("isBrandExist Error: " + e.getMessage());
        }
        return false;
    }

    /**
     * Thêm một thương hiệu mới vào CSDL và trả về mã ID tự tăng vừa được tạo.
     * 
     * @param brandName Tên thương hiệu mới
     * @return Mã ID thương hiệu vừa tạo nếu thành công, ngược lại -1
     */
    public int insertBrand(String brandName) {
        if (brandName == null || brandName.trim().isEmpty()) {
            return -1;
        }
        try {
            String sql = "INSERT INTO Brand (brand_name) VALUES (?)";
            ps = cnn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, brandName.trim());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("insertBrand Error: " + e.getMessage());
        }
        return -1;
    }
}

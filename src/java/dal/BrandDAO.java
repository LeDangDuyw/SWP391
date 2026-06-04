package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Brand;

public class BrandDAO extends DBContext {
    PreparedStatement stm;
    ResultSet rs;

    /*
     * Name: getAllBrands
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Truy xuất danh sách tất cả các thương hiệu (Brand) từ cơ sở dữ liệu.
     */
    public List<Brand> getAllBrands() {
        // Lấy danh sách tất cả các thương hiệu từ bảng Brand
        List<Brand> brands = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Brand";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Brand b = new Brand(rs.getInt("brand_id"), rs.getString("brand_name"));
                brands.add(b);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return brands;
    }
}

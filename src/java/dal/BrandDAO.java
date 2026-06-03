package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Brand;

public class BrandDAO extends DBContext {
    PreparedStatement stm;
    ResultSet rs;

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

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {
    PreparedStatement stm;
    ResultSet rs;

    public List<Category> getAllCategories() {
        // Lấy danh sách tất cả các danh mục từ bảng Category
        List<Category> categories = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Category";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
                categories.add(c);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return categories;
    }
}

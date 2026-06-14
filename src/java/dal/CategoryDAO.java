package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {
    PreparedStatement stm;
    ResultSet rs;

    /*
     * Name: getAllCategories
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Truy xuất danh sách tất cả các danh mục (Category) từ cơ sở dữ liệu.
     */
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
    public int getTotalCategoryCount(String search) {
        try {
            String sql = "SELECT COUNT(*) FROM Category";
            if (search != null && !search.trim().isEmpty()) {
                sql += " WHERE category_name LIKE ?";
            }
            stm = connection.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(1, "%" + search + "%");
            }
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }

    public List<Category> getCategoriesPaginated(String search, int offset, int pageSize) {
        List<Category> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Category";
            if (search != null && !search.trim().isEmpty()) {
                sql += " WHERE category_name LIKE ?";
            }
            sql += " ORDER BY category_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(idx++, "%" + search + "%");
            }
            stm.setInt(idx++, offset);
            stm.setInt(idx++, pageSize);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Category(rs.getInt("category_id"), rs.getString("category_name")));
            }
        } catch (Exception e) {}
        return list;
    }

    public void insertCategory(String categoryName) {
        try {
            String sql = "INSERT INTO Category (category_name) VALUES (?)";
            stm = connection.prepareStatement(sql);
            stm.setString(1, categoryName);
            stm.executeUpdate();
        } catch (Exception e) {}
    }

    public void updateCategory(int categoryId, String categoryName) {
        try {
            String sql = "UPDATE Category SET category_name = ? WHERE category_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, categoryName);
            stm.setInt(2, categoryId);
            stm.executeUpdate();
        } catch (Exception e) {}
    }

    public void deleteCategory(int categoryId) {
        try {
            String sql = "DELETE FROM Category WHERE category_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            stm.executeUpdate();
        } catch (Exception e) {}
    }

    public Integer getCategoryIdByName(String name) {
        try {
            String sql = "SELECT category_id FROM Category WHERE LOWER(category_name) = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, name.toLowerCase());
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch(Exception e) {}
        return null;
    }
}

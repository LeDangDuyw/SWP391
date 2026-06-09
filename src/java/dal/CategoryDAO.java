/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Cao Tuấn Minh
 */
import java.sql.*;
import java.util.*;
import model.Category;
import dal.DBContext;

public class CategoryDAO extends DBContext{
Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public CategoryDAO() {
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

    public ArrayList<Category> getAllCategories() {
    ArrayList<Category> data = new ArrayList<>();
    try {
        String sql = "SELECT category_id,category_name FROM Category";
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Category c = new Category();
            c.setCategoryId(rs.getInt(1));
            c.setCategoryName(rs.getString(2));
            data.add(c);
        }
    } catch (Exception e) {
        System.out.println("getAllCategories: " + e.getMessage());
    }
    return data;
}
    
    // tìm kiếm sản phẩm theo danh mục 
    public Integer getCategoryIdByName(String keyword) {

    String sql = """
        SELECT category_id
        FROM Category
        WHERE LOWER(category_name) LIKE ?
        """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + keyword.toLowerCase() + "%");

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt("category_id");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

    // --- MỚI THÊM: Quản lý Category ---

    /*
     * Name: insertCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới một danh mục (Category) vào cơ sở dữ liệu.
     */
    public void insertCategory(String categoryName) {
        try {
            String sql = "INSERT INTO Category (category_name) VALUES (?)";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, categoryName);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("insertCategory: " + e.getMessage());
        }
    }

    /*
     * Name: updateCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Cập nhật tên của một danh mục (Category) dựa trên ID.
     */
    public void updateCategory(int categoryId, String categoryName) {
        try {
            String sql = "UPDATE Category SET category_name = ? WHERE category_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, categoryName);
            ps.setInt(2, categoryId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateCategory: " + e.getMessage());
        }
    }

    /*
     * Name: deleteCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xóa cứng một danh mục (Category) khỏi cơ sở dữ liệu dựa trên ID.
     */
    public void deleteCategory(int categoryId) {
        try {
            String sql = "DELETE FROM Category WHERE category_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("deleteCategory: " + e.getMessage());
        }
    }

    /*
     * Name: getCategoriesPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách danh mục (Category) có phân trang và hỗ trợ tìm kiếm theo tên.
     */
    public List<Category> getCategoriesPaginated(String search, int offset, int fetchSize) {
        List<Category> categories = new ArrayList<>();
        try {
            String sql = "SELECT category_id, category_name FROM Category ";
            if (search != null && !search.trim().isEmpty()) {
                sql += "WHERE category_name LIKE ? ";
            }
            sql += "ORDER BY category_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            ps = cnn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, fetchSize);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
                categories.add(c);
            }
        } catch (Exception e) {
            System.out.println("getCategoriesPaginated: " + e.getMessage());
        }
        return categories;
    }

    /*
     * Name: getTotalCategoryCount
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Đếm tổng số lượng danh mục (Category), có hỗ trợ lọc theo từ khóa tìm kiếm.
     */
    public int getTotalCategoryCount(String search) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Category ";
            if (search != null && !search.trim().isEmpty()) {
                sql += "WHERE category_name LIKE ? ";
            }
            ps = cnn.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search + "%");
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalCategoryCount: " + e.getMessage());
        }
        return count;
    }
}

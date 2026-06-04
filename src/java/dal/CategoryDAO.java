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
}

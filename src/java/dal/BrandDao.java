/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.*;
import java.util.*;
import model.Category;
import dal.DBContext;
import model.Brand;

/**
 *
 * @author Cao Tuấn Minh
 */
public class BrandDao extends DBContext{
    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public BrandDao() {
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
    
   // Lấy tất cả các thương hiệu của danh mục 
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
        while(rs.next()){
            Brand b = new Brand();
            b.setBrandId(
                rs.getInt("brand_id")
            );
            b.setBrandName(
                rs.getString("brand_name")
            );
            data.add(b);
        }
    } catch(Exception e){
        e.printStackTrace();
    }
    return data;
}
}

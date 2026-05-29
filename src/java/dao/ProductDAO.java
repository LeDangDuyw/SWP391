/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Product;
/**
 *
 * @author huy
 */
public class ProductDAO extends DBContext{
    PreparedStatement stm;
    ResultSet rs;
    
    public List<Product> GetAllProducts() {
        List<Product> products = new ArrayList<Product>();
        try{
            String sql = "select * from Product";
        stm = connection.prepareStatement(sql);
        rs = stm.executeQuery();
        while(rs.next()) {
            Product p = new Product(rs.getInt("product_id"),rs.getString("product_name"), rs.getString("description"),rs.getInt("warranty_period"),
                                    rs.getString("thumbnail"), rs.getInt("category_id"), rs.getInt("brand_id"));
            products.add(p);
        }
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return products;
    }
}

package Dao;
import Dao.DBContext;
import java.sql.Connection;
import Model.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {
    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public ProductDAO() {
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
    public ArrayList<Product> getAllProducts() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = "SELECT p.product_id,p.product_name,p.thumbnail,b.brand_name,MIN(v.selling_price) "
                + "AS min_price FROM Product p JOIN Brand b ON p.brand_id=b.brand_id "
                + "JOIN ProductVariant v ON p.product_id=v.product_id WHERE v.status='active' "
                + "GROUP BY p.product_id,p.product_name,p.thumbnail,b.brand_name";
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getDouble(5));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
    
}

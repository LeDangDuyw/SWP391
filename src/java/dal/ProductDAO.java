package dal;
import dal.DBContext;
import java.sql.Connection;
import model.Product;
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
    //Bán Chạy 
   // Lấy top 10 laptop bán chạy nhất 
    public ArrayList<Product> getTopLapTop() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                     SELECT TOP 10
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name,
                         SUM(od.quantity) AS sold_quantity,
                         MIN(v.selling_price) AS min_price
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN OrderDetail od ON v.variant_id = od.variant_id
                     WHERE v.status = 'active'
                     AND p.category_id = 1
                     GROUP BY
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name
                     ORDER BY SUM(ISNULL(od.quantity,0)) DESC;
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(6));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
// Lấy top 10 Chuột bán chạy nhất 
 public ArrayList<Product> getTopMouse() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                     SELECT TOP 10
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name,
                         SUM(od.quantity) AS sold_quantity,
                         MIN(v.selling_price) AS min_price
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN OrderDetail od ON v.variant_id = od.variant_id
                     WHERE v.status = 'active'
                     AND p.category_id = 4
                     GROUP BY
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name
                     ORDER BY SUM(ISNULL(od.quantity,0)) DESC;
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(6));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
 
// Lấy top 10 bàn phím bán chạy nhất 
 public ArrayList<Product> getTopKeyboard() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                     SELECT TOP 10
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name,
                         SUM(od.quantity) AS sold_quantity,
                         MIN(v.selling_price) AS min_price
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN OrderDetail od ON v.variant_id = od.variant_id
                     WHERE v.status = 'active'
                     AND p.category_id = 3
                     GROUP BY
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name
                     ORDER BY SUM(ISNULL(od.quantity,0)) DESC;
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(6));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
 
 //Sản phẩm mới 
 //sql lấy  10 Laptop mới 
 public ArrayList<Product> getNewLaptop() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                    SELECT TOP 10
                        p.product_id,
                        p.product_name,
                        p.thumbnail,
                        b.brand_name,
                        MIN(v.selling_price) AS min_price
                    FROM Product p
                    JOIN Brand b ON p.brand_id = b.brand_id
                    JOIN ProductVariant v ON p.product_id = v.product_id
                    WHERE v.status = 'active'
                    AND p.category_id = 1
                    GROUP BY
                        p.product_id,
                        p.product_name,
                        p.thumbnail,
                        b.brand_name
                    ORDER BY p.product_id DESC;
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(5));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
 
// 10 sp chuột mới 
 public ArrayList<Product> getNewMouse() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                                         SELECT TOP 10
                                             p.product_id,
                                             p.product_name,
                                             p.thumbnail,
                                             b.brand_name,
                                             MIN(v.selling_price) AS min_price
                                         FROM Product p
                                         JOIN Brand b ON p.brand_id = b.brand_id
                                         JOIN ProductVariant v ON p.product_id = v.product_id
                                         WHERE v.status = 'active'
                                         AND p.category_id = 4
                                         GROUP BY
                                             p.product_id,
                                             p.product_name,
                                             p.thumbnail,
                                             b.brand_name
                                         ORDER BY p.product_id DESC; 
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(5));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}
 // 10 sp bàn phím mới
 public ArrayList<Product> getNewKeyborad() {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
                                        SELECT TOP 10
                                            p.product_id,
                                            p.product_name,
                                            p.thumbnail,
                                            b.brand_name,
                                            MIN(v.selling_price) AS min_price
                                        FROM Product p
                                        JOIN Brand b ON p.brand_id = b.brand_id
                                        JOIN ProductVariant v ON p.product_id = v.product_id
                                        WHERE v.status = 'active'
                                        AND p.category_id = 3
                                        GROUP BY
                                            p.product_id,
                                            p.product_name,
                                            p.thumbnail,
                                            b.brand_name
                                        ORDER BY p.product_id DESC;                                   
                     """;
                                                                             
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt(1));
            p.setProductName(rs.getString(2));
            p.setThumbnail(rs.getString(3));
            p.setBrandName(rs.getString(4));
            p.setMinPrice(rs.getLong(5));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("getAllProducts: " + e.getMessage());
    }
    return data;
}

 // Tìm category_id từ tên sản phẩm khi search
 public Integer getCategoryIdByProductSearch(String search) {
    try {
        String sql = """
            SELECT TOP 1 p.category_id
            FROM Product p
            WHERE p.product_name LIKE ?
            """;
        ps = cnn.prepareStatement(sql);
        ps.setString(1, "%" + search + "%");
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        System.out.println("getCategoryIdByProductSearch: " + e.getMessage());
    }
    return null;
}

 // Tìm sản phẩm theo keyword trên tất cả danh mục (dùng cho Home search)
 public ArrayList<Product> searchAllProducts(String keyword, int page, int pageSize) {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
            SELECT
                p.product_id, p.product_name, p.thumbnail,
                b.brand_name, c.category_name, p.category_id,
                MIN(v.selling_price) AS min_price
            FROM Product p
            JOIN Brand b ON p.brand_id = b.brand_id
            JOIN Category c ON p.category_id = c.category_id
            JOIN ProductVariant v ON p.product_id = v.product_id
            WHERE v.status = 'active'
            AND (p.product_name LIKE ? OR b.brand_name LIKE ?)
            GROUP BY
                p.product_id, p.product_name, p.thumbnail,
                b.brand_name, c.category_name, p.category_id
            ORDER BY p.product_id DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;
        ps = cnn.prepareStatement(sql);
        ps.setString(1, "%" + keyword.trim() + "%");
        ps.setString(2, "%" + keyword.trim() + "%");
        ps.setInt(3, (page - 1) * pageSize);
        ps.setInt(4, pageSize);
        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setThumbnail(rs.getString("thumbnail"));
            p.setBrandName(rs.getString("brand_name"));
            p.setCategoryName(rs.getString("category_name"));
            p.setMinPrice(rs.getLong("min_price"));
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("searchAllProducts: " + e.getMessage());
    }
    return data;
}

 // Đếm tổng sản phẩm tìm được theo keyword
 public int countSearchAllProducts(String keyword) {
    try {
        String sql = """
            SELECT COUNT(DISTINCT p.product_id)
            FROM Product p
            JOIN Brand b ON p.brand_id = b.brand_id
            JOIN ProductVariant v ON p.product_id = v.product_id
            WHERE v.status = 'active'
            AND (p.product_name LIKE ? OR b.brand_name LIKE ?)
            """;
        ps = cnn.prepareStatement(sql);
        ps.setString(1, "%" + keyword.trim() + "%");
        ps.setString(2, "%" + keyword.trim() + "%");
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        System.out.println("countSearchAllProducts: " + e.getMessage());
    }
    return 0;
}

 // Phương thức lọc tổng hợp - gọi từ ProductListServlet
 public java.util.List<?> filterLaptop(int categoryId, Integer brandId, Integer seriesId,
         String purpose, String cpu, String ram, String ssd, String gpu, String screen,
         String price, String sort, int page, int pageSize, String search,
         String connectivity, String switchType, String dpi) {
    ProductListFilterDAO dao = new ProductListFilterDAO();
    switch (categoryId) {
        case 4:
            return dao.filterMouse(brandId, purpose, connectivity, dpi, price, sort, page, pageSize, search);
        case 3:
            return dao.filterKeyboard(brandId, purpose, connectivity, switchType, price, sort, page, pageSize, search);
        default:
            return dao.filterLaptop(brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, sort, page, pageSize, search);
    }
}

 // Phương thức đếm tổng hợp - gọi từ ProductListServlet
 public int countFilteredLaptop(int categoryId, Integer brandId, Integer seriesId,
         String purpose, String cpu, String ram, String ssd, String gpu, String screen,
         String price, String search, String connectivity, String switchType, String dpi) {
    ProductListFilterDAO dao = new ProductListFilterDAO();
    switch (categoryId) {
        case 4:
            return dao.countFilteredMouse(brandId, purpose, connectivity, dpi, price, search);
        case 3:
            return dao.countFilteredKeyboard(brandId, purpose, connectivity, switchType, price, search);
        default:
            return dao.countFilteredLaptop(brandId, seriesId, purpose, cpu, ram, ssd, gpu, screen, price, search);
    }
}
}

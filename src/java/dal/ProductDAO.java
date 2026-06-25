package dal;
import dal.DBContext;
import java.sql.Connection;
import model.Product;
import model.ProductVariant;
import model.ProductCompareDTO;
import model.CartItem;
import viewmodel.ProductInventory;
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
                         MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                         MIN(v.selling_price) AS original_price,
                         CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN (
                         SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                         FROM FlashSaleItem fsi
                         JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                         WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                         GROUP BY fsi.variant_id
                     ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(7));
            p.setDiscountPercent(rs.getInt(8));
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
                         MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                         MIN(v.selling_price) AS original_price,
                         CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN (
                         SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                         FROM FlashSaleItem fsi
                         JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                         WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                         GROUP BY fsi.variant_id
                     ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(7));
            p.setDiscountPercent(rs.getInt(8));
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
                         MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                         MIN(v.selling_price) AS original_price,
                         CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                     FROM Product p
                     JOIN Brand b ON p.brand_id = b.brand_id
                     JOIN ProductVariant v ON p.product_id = v.product_id
                     LEFT JOIN (
                         SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                         FROM FlashSaleItem fsi
                         JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                         WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                         GROUP BY fsi.variant_id
                     ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(7));
            p.setDiscountPercent(rs.getInt(8));
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
                        MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                        MIN(v.selling_price) AS original_price,
                        CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                    FROM Product p
                    JOIN Brand b ON p.brand_id = b.brand_id
                    JOIN ProductVariant v ON p.product_id = v.product_id
                    LEFT JOIN (
                        SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                        FROM FlashSaleItem fsi
                        JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                        WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                        GROUP BY fsi.variant_id
                    ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(6));
            p.setDiscountPercent(rs.getInt(7));
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
                                             MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                                             MIN(v.selling_price) AS original_price,
                                             CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                                         FROM Product p
                                         JOIN Brand b ON p.brand_id = b.brand_id
                                         JOIN ProductVariant v ON p.product_id = v.product_id
                                         LEFT JOIN (
                                             SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                                             FROM FlashSaleItem fsi
                                             JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                                             WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                                             GROUP BY fsi.variant_id
                                         ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(6));
            p.setDiscountPercent(rs.getInt(7));
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
                                            MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                                            MIN(v.selling_price) AS original_price,
                                            CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
                                        FROM Product p
                                        JOIN Brand b ON p.brand_id = b.brand_id
                                        JOIN ProductVariant v ON p.product_id = v.product_id
                                        LEFT JOIN (
                                            SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                                            FROM FlashSaleItem fsi
                                            JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                                            WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                                            GROUP BY fsi.variant_id
                                        ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong(6));
            p.setDiscountPercent(rs.getInt(7));
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
                MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price,
                MIN(v.selling_price) AS original_price,
                CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent
            FROM Product p
            JOIN Brand b ON p.brand_id = b.brand_id
            JOIN Category c ON p.category_id = c.category_id
            JOIN ProductVariant v ON p.product_id = v.product_id
            LEFT JOIN (
                SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price
                FROM FlashSaleItem fsi
                JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id
                WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                GROUP BY fsi.variant_id
            ) fs_active ON v.variant_id = fs_active.variant_id
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
            p.setOriginalPrice(rs.getLong("original_price"));
            p.setDiscountPercent(rs.getInt("discount_percent"));
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

 // Lấy thông tin chi tiết 1 sản phẩm theo product_id (cho trang chi tiết)
public Product getProductById(int productId) {
    try {
        String sql = "select p.product_id, p.product_name, p.description, p.warranty_period, "
                   + "p.thumbnail, p.category_id, p.brand_id, c.category_name, b.brand_name "
                   + "from Product p "
                   + "join Category c on p.category_id = c.category_id "
                   + "join Brand b on p.brand_id = b.brand_id "
                   + "where p.product_id = ?";
        ps = cnn.prepareStatement(sql);
        ps.setInt(1, productId);
        rs = ps.executeQuery();
        if (rs.next()) {
            Product p = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getInt("warranty_period"),
                    rs.getString("thumbnail"),
                    rs.getInt("category_id"),
                    rs.getInt("brand_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setBrandName(rs.getString("brand_name"));
            return p;
        }
    } catch (Exception e) {
        System.out.println("getProductById: " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}

    public List<Product> getSimilarProducts(int categoryId, int productId, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT TOP (" + limit + ") " +
                         "p.product_id, " +
                         "p.product_name, " +
                         "p.thumbnail, " +
                         "b.brand_name, " +
                         "MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price, " +
                         "MIN(v.selling_price) AS original_price, " +
                         "CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent " +
                         "FROM Product p " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant v ON p.product_id = v.product_id " +
                         "LEFT JOIN ( " +
                         "    SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price " +
                         "    FROM FlashSaleItem fsi " +
                         "    JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id " +
                         "    WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time " +
                         "    GROUP BY fsi.variant_id " +
                         ") fs_active ON v.variant_id = fs_active.variant_id " +
                         "WHERE v.status = 'active' " +
                         "AND p.category_id = ? " +
                         "AND p.product_id != ? " +
                         "GROUP BY " +
                         "    p.product_id, " +
                         "    p.product_name, " +
                         "    p.thumbnail, " +
                         "    b.brand_name " +
                         "ORDER BY p.product_id DESC";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, productId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt(1));
                p.setProductName(rs.getString(2));
                p.setThumbnail(rs.getString(3));
                p.setBrandName(rs.getString(4));
                p.setMinPrice(rs.getLong(5));
                p.setOriginalPrice(rs.getLong(6));
                p.setDiscountPercent(rs.getInt(7));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("getSimilarProducts Error: " + e.getMessage());
        }
        return list;
    }

    // === WAREHOUSE / INVENTORY MANAGEMENT METHODS ===

public List<Product> GetAllProducts() {
        // Lấy danh sách tất cả các sản phẩm (cơ bản) từ cơ sở dữ liệu
        List<Product> products = new ArrayList<Product>();
        try{
            String sql = "select * from Product";
            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()) {
            Product p = new Product(rs.getInt("variant_id"),rs.getString("product_name"), rs.getString("description"),rs.getInt("warranty_period"),
                                    rs.getString("thumbnail"), rs.getInt("category_id"), rs.getInt("brand_id"));
            products.add(p);
        }
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return products;
    }

    public Product getProductByVariantId(int variantId) {
        try {
            String sql = "select p.product_id, p.product_name, p.description, p.warranty_period, p.thumbnail, " +
                         "p.category_id, p.brand_id, c.category_name, b.brand_name " +
                         "from Product p " +
                         "join ProductVariant pv on p.product_id = pv.product_id " +
                         "join Category c on p.category_id = c.category_id " +
                         "join Brand b on p.brand_id = b.brand_id " +
                         "where pv.variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("description"),
                        rs.getInt("warranty_period"),
                        rs.getString("thumbnail"),
                        rs.getInt("category_id"),
                        rs.getInt("brand_id"));
                p.setCategoryName(rs.getString("category_name"));
                p.setBrandName(rs.getString("brand_name"));
                return p;
            }
        } catch (Exception e) {
            System.out.println("getProductByVariantId: " + e.getMessage());
        }
        return null;
    }

    /*
     * Name: getAllVariants
     * Description: Lấy danh sách tất cả các biến thể của sản phẩm.
     */
    public List<model.ProductVariant> getAllVariants() {
        List<model.ProductVariant> variants = new ArrayList<>();
        try {
            String sql = "SELECT * FROM ProductVariant";
            ps = cnn.prepareStatement(sql);
            rs  = ps.executeQuery();
            while (rs.next()) {
                model.ProductVariant pv = new model.ProductVariant(
                        rs.getInt("variant_id"),
                        rs.getInt("product_id"),
                        rs.getString("sku"),
                        rs.getString("variant_name"),
                        rs.getBigDecimal("import_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getBoolean("is_serialized"),
                        rs.getString("status")
                );
                variants.add(pv);
            }
        } catch (Exception e) {
            System.out.println("getAllVariants Error: " + e.getMessage());
        }
        return variants;
    }

    public List<ProductVariant> getProductVariantsByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        try {
            String sql = "select pv.variant_id, pv.product_id, pv.sku, pv.variant_name, pv.import_price, " +
                         "pv.selling_price, pv.is_serialized, pv.status, isnull(i.available_quantity, 0) as available_quantity " +
                         "from ProductVariant pv " +
                         "left join Inventory i on pv.variant_id = i.variant_id " +
                         "where pv.product_id = ? and pv.status = 'active' " +
                         "order by pv.variant_id";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, productId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant variant = new ProductVariant(
                        rs.getInt("variant_id"),
                        rs.getInt("product_id"),
                        rs.getString("sku"),
                        rs.getString("variant_name"),
                        rs.getBigDecimal("import_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getBoolean("is_serialized"),
                        rs.getString("status"),
                        rs.getInt("available_quantity")
                );
                variants.add(variant);
            }
        } catch (Exception e) {
            System.out.println("getProductVariantsByProductId Error: " + e.getMessage());
        }
        return variants;
    }

    /*
     * Name: getVariantById
     * Description: Lấy thông tin chi tiết của biến thể theo ID.
     */
    public model.ProductVariant getVariantById(int variantId) {
        try {
            String sql = "SELECT * FROM ProductVariant WHERE variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new model.ProductVariant(
                        rs.getInt("variant_id"),
                        rs.getInt("product_id"),
                        rs.getString("sku"),
                        rs.getString("variant_name"),
                        rs.getBigDecimal("import_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getBoolean("is_serialized"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            System.out.println("getVariantById Error: " + e.getMessage());
        }
        return null;
    }

    public CartItem getCartItemByVariantId(int variantId) {
        try {
            String sql = "SELECT pv.variant_id, pv.product_id, p.product_name, pv.variant_name, p.thumbnail, pv.selling_price, isnull(inv.available_quantity, 0) AS available_quantity " +
                         "FROM ProductVariant pv " +
                         "JOIN Product p ON pv.product_id = p.product_id " +
                         "LEFT JOIN Inventory inv ON pv.variant_id = inv.variant_id " +
                         "WHERE pv.variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new CartItem(
                        rs.getInt("variant_id"),
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("variant_name"),
                        rs.getString("thumbnail"),
                        rs.getBigDecimal("selling_price"),
                        1,
                        rs.getInt("available_quantity")
                );
            }
        } catch (Exception e) {
            System.out.println("getCartItemByVariantId Error: " + e.getMessage());
        }
        return null;
    }

    
    /*
     * Name: GetAllProductInventory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách chi tiết các sản phẩm bao gồm thông tin kho hàng, danh mục, thương hiệu.
     */
    public List<ProductInventory> GetAllProductInventory() {
        // Lấy danh sách sản phẩm cùng với thông tin kho hàng, danh mục, thương hiệu
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
            // Join nhiều bảng để lấy đầy đủ thông tin: Tên sản phẩm, biến thể, giá bán, số lượng kho...
            String sql = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, \n" +
                        "case \n" +
                        "	when i.available_quantity > 0 then N'In Stock'\n" +
                        "	else N'Sold Out'\n" +
                        "end as status, p.thumbnail\n" +
                        "from Product p join Category c on p.category_id = c.category_id\n" +
                        "	join Brand b on p.brand_id = b.brand_id\n" +
                        "	join ProductVariant pv on p.product_id = pv.product_id\n" +
                        "	join Inventory i on pv.variant_id = i.variant_id\n"
                    + "where pv.status = 'active'";
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while(rs.next()) {
            ProductInventory p = new ProductInventory(rs.getInt("variant_id"),
                                                        rs.getString("product_name"), 
                                                        rs.getString("sku"),
                                                        rs.getString("variant_name"),
                                                                        rs.getString("brand_name"),
                                                        rs.getString("category_name"),
                                                        rs.getBigDecimal("selling_price"),
                                                        rs.getInt("available_quantity"),
                                                        rs.getString("status"),
                                                        rs.getString("thumbnail"));
            products.add(p);
        }
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return products;
    }
    
    /*
     * Name: GetProductsByNameAndSort
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Tìm kiếm sản phẩm theo tên, danh mục, SKU và sắp xếp theo giá.
     */
    public List<ProductInventory> GetProductsByNameAndSort(String search, String sortBy){
        // Hàm tìm kiếm sản phẩm theo tên, danh mục, sku và sắp xếp giá
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
            // Xác định chiều sắp xếp: ASC (thấp đến cao) hoặc DESC (cao đến thấp)
            String order = (sortBy.equals("lowToHigh")) ? "ASC" : "DESC"; 
            String strSQL = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, \n" +
                        "case \n" +
                        "	when i.available_quantity > 0 then N'In Stock'\n" +
                        "	else N'Sold Out'\n" +
                        "end as status, p.thumbnail\n" +
                        "from Product p join Category c on p.category_id = c.category_id\n" +
                        "	join Brand b on p.brand_id = b.brand_id\n" +
                        "	join ProductVariant pv on p.product_id = pv.product_id\n" +
                        "	join Inventory i on pv.variant_id = i.variant_id\n" +
                        // Lọc theo từ khóa tìm kiếm (so khớp tương đối bằng LIKE)
                        "where (p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%')\n" +
                    "and pv.status = 'active'\n" +
                        "order by pv.selling_price " + order;
            ps = cnn.prepareStatement(strSQL);
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            rs = ps.executeQuery();
            
                while(rs.next()) {
                    ProductInventory p = new ProductInventory(rs.getInt("variant_id"),
                                                        rs.getString("product_name"), 
                                                        rs.getString("sku"),
                                                        rs.getString("variant_name"),
                                                                        rs.getString("brand_name"),
                                                        rs.getString("category_name"),
                                                        rs.getBigDecimal("selling_price"),
                                                        rs.getInt("available_quantity"),
                                                        rs.getString("status"),
                                                        rs.getString("thumbnail"));
                        products.add(p);
                }
            
        }catch(Exception e ){
            System.out.println(e.getMessage());
        }
        return products;
    }
    
    /*
     * Name: DeleteProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xóa cứng một biến thể sản phẩm khỏi cơ sở dữ liệu dựa trên mã biến thể (variant_id).
     */
    public boolean DeleteProduct(int productVariantId){
        try{
            String sql = "delete from ProductVariant where variant_id = ?";
        ps = cnn.prepareStatement(sql);
        int affectedRows = ps.executeUpdate();
        if(affectedRows > 0) return true;
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    /*
     * Name: getTotalInventoryCount
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Đếm tổng số lượng biến thể sản phẩm đang hoạt động, có hỗ trợ lọc theo từ khóa tìm kiếm.
     */
    public int getTotalInventoryCount(String search, String category, String stockStatus, String itemStatus) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "JOIN Inventory i ON pv.variant_id = i.variant_id " +
                         "WHERE 1=1";

            if (itemStatus != null && itemStatus.equals("hidden")) {
                sql += " AND pv.status = 'inactive'";
            } else if (itemStatus != null && itemStatus.equals("all")) {
                // do nothing, show all
            } else {
                sql += " AND pv.status = 'active'";
            }

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                sql += " AND c.category_name = ?";
            }

            if (stockStatus != null && !stockStatus.trim().isEmpty() && !stockStatus.equals("all")) {
                if (stockStatus.equals("inStock")) {
                    sql += " AND i.available_quantity > 5";
                } else if (stockStatus.equals("lowStock")) {
                    sql += " AND i.available_quantity > 0 AND i.available_quantity <= 5";
                } else if (stockStatus.equals("outOfStock")) {
                    sql += " AND i.available_quantity = 0";
                }
            }

            if (search != null && !search.trim().isEmpty()) {
                sql += " and (p.product_name like ? or c.category_name like ? or pv.sku like ?)";
            }

            ps = cnn.prepareStatement(sql);
            int idx = 1;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                ps.setString(idx++, category);
            }

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalInventoryCount Error: " + e.getMessage());
        }
        return count;
    }

    public int getTotalInventoryCount(String search) {
        return getTotalInventoryCount(search, null, null, null);
    }

    /*
     * Name: GetProductInventoryPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách sản phẩm chi tiết có phân trang, hỗ trợ lọc theo từ khóa và sắp xếp theo giá.
     */
    public List<ProductInventory> GetProductInventoryPaginated(
            String search, String category, String sortBy, String stockStatus, String itemStatus,
            int offset, int fetchSize) {

        List<ProductInventory> products = new ArrayList<>();
        try {
            String order = (sortBy != null && sortBy.equals("lowToHigh")) ? "ASC" : "DESC";

            String sql = "SELECT pv.variant_id, p.product_name, pv.sku, pv.variant_name, " +
                         "b.brand_name, c.category_name, pv.selling_price, i.available_quantity, " +
                         "CASE " +
                         "  WHEN i.available_quantity > 5  THEN N'In Stock' " +
                         "  WHEN i.available_quantity > 0  THEN N'Low Stock' " +
                         "  ELSE N'Sold Out' " +
                         "END AS status, p.thumbnail, pv.status as variant_status " +
                         "FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "JOIN Inventory i ON pv.variant_id = i.variant_id " +
                         "WHERE 1=1";

            if (itemStatus != null && itemStatus.equals("hidden")) {
                sql += " AND pv.status = 'inactive'";
            } else if (itemStatus != null && itemStatus.equals("all")) {
                // do nothing, show all
            } else {
                sql += " AND pv.status = 'active'";
            }

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                sql += " AND c.category_name = ?";
            }

            if (stockStatus != null && !stockStatus.trim().isEmpty() && !stockStatus.equals("all")) {
                if (stockStatus.equals("inStock")) {
                    sql += " AND i.available_quantity > 5";
                } else if (stockStatus.equals("lowStock")) {
                    sql += " AND i.available_quantity > 0 AND i.available_quantity <= 5";
                } else if (stockStatus.equals("outOfStock")) {
                    sql += " AND i.available_quantity = 0";
                }
            }

            if (search != null && !search.trim().isEmpty()) {
                sql += " and (p.product_name like ? or c.category_name like ? or pv.sku like ?)";
            }

            sql += " ORDER BY pv.selling_price " + order + " " +
                   "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            ps = cnn.prepareStatement(sql);
            int idx = 1;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                ps.setString(idx++, category);
            }

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }

            ps.setInt(idx++, offset);
            ps.setInt(idx++, fetchSize);

            rs = ps.executeQuery();
            while (rs.next()) {
                ProductInventory p = new ProductInventory(
                        rs.getInt("variant_id"),
                        rs.getString("product_name"),
                        rs.getString("sku"),
                        rs.getString("variant_name"),
                        rs.getString("brand_name"),
                        rs.getString("category_name"),
                        rs.getBigDecimal("selling_price"),
                        rs.getInt("available_quantity"),
                        rs.getString("status"),
                        rs.getString("thumbnail"));
                p.setVariantStatus(rs.getString("variant_status"));
                products.add(p);
            }
        } catch (Exception e) {
            System.out.println("GetProductInventoryPaginated Error: " + e.getMessage());
        }
        return products;
    }

    public List<ProductInventory> GetProductInventoryPaginated(String search, String sortBy, int offset, int fetchSize) {
        return GetProductInventoryPaginated(search, null, sortBy, null, null, offset, fetchSize);
    }

    /*
     * Name: insertProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới một sản phẩm (Product) vào cơ sở dữ liệu và trả về ID tự tăng của sản phẩm vừa thêm.
     */
    public int insertProduct(Product p) {
        int productId = -1;
        try {
            String sql = "INSERT INTO Product (product_name, description, warranty_period, thumbnail, category_id, brand_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getWarrantyPeriod());
            ps.setString(4, p.getThumbnail());
            ps.setInt(5, p.getCategoryId());
            ps.setInt(6, p.getBrandId());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                productId = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Insert Product Error: " + e.getMessage());
        }
        return productId;
    }

    /*
     * Name: insertProductVariant
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới một biến thể của sản phẩm (ProductVariant) và khởi tạo bản ghi tồn kho (Inventory) tương ứng.
     */
    public void insertProductVariant(int productId, String sku, String variantName,
                                     java.math.BigDecimal importPrice, java.math.BigDecimal sellingPrice, int stock) {
        try {
            String sql = "INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, is_serialized, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setString(2, sku);
            ps.setString(3, variantName);
            ps.setBigDecimal(4, importPrice);
            ps.setBigDecimal(5, sellingPrice);
            ps.setBoolean(6, false);
            ps.setString(7, "active");
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) {
                variantId = rs.getInt(1);
            }
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, reserved_quantity, available_quantity) VALUES (?, ?, ?)";
                PreparedStatement psInv = cnn.prepareStatement(sqlInv);
                psInv.setInt(1, variantId);
                psInv.setInt(2, 0);
                psInv.setInt(3, stock);
                psInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Insert ProductVariant Error: " + e.getMessage());
        }
    }

    public void insertProductVariant(int productId, String sku, String variantName, java.math.BigDecimal price, int stock) {
        insertProductVariant(productId, sku, variantName, price, price, stock);
    }
    
    /*
     * Name: updateProductVariant
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Cập nhật thông tin của một ProductVariant và tồn kho của nó dựa trên giao diện.
     */
    public void updateProductVariant(int variantId, String sku, String variantName, java.math.BigDecimal price, int stock) {
        try {
            // Update ProductVariant table
            String sql = "UPDATE ProductVariant SET sku = ?, variant_name = ?, selling_price = ? WHERE variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, sku);
            ps.setString(2, variantName);
            ps.setBigDecimal(3, price);
            ps.setInt(4, variantId);
            ps.executeUpdate();
            
            // Update Inventory table
            String sqlInv = "UPDATE Inventory SET available_quantity = ? WHERE variant_id = ?";
            PreparedStatement psInv = cnn.prepareStatement(sqlInv);
            psInv.setInt(1, stock);
            psInv.setInt(2, variantId);
            psInv.executeUpdate();
        } catch (Exception e) {
            System.out.println("Update ProductVariant Error: " + e.getMessage());
        }
    }
    
    /*
     * Name: hideProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Ẩn (xóa mềm) một biến thể sản phẩm bằng cách cập nhật trạng thái thành 'inactive'.
     */
    public void hideProduct(int variant_id) {
        try{
            String strSQL = "update ProductVariant\n" +
                            "set status = 'inactive'\n" +
                            "where variant_id = ? ";
            ps = cnn.prepareStatement(strSQL);
            ps.setInt(1, variant_id);
            ps.executeUpdate();
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }

    /*
     * Name: unhideProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khôi phục một biến thể sản phẩm đã bị ẩn bằng cách cập nhật trạng thái thành 'active'.
     */
    public void unhideProduct(int variant_id) {
        try{
            String strSQL = "update ProductVariant\n" +
                            "set status = 'active'\n" +
                            "where variant_id = ? ";
            ps = cnn.prepareStatement(strSQL);
            ps.setInt(1, variant_id);
            ps.executeUpdate();
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public ProductCompareDTO getProductCompareDetail(int productId) {
        ProductCompareDTO p = null;
        try {
            String sql = """
                         SELECT v.product_id, v.product_name, v.thumbnail, v.brand_name, v.category_name, v.category_id,
                                v.original_price, v.discount_percent, v.min_price, v.warranty_period, v.description,
                                v.cpu, v.ram, v.ssd, v.gpu, v.screen, v.connectivity, v.switch_type, v.dpi,
                                (SELECT ISNULL(SUM(inv.available_quantity), 0)
                                 FROM ProductVariant pv
                                 LEFT JOIN Inventory inv ON pv.variant_id = inv.variant_id
                                 WHERE pv.product_id = v.product_id AND pv.status = 'active') AS total_stock
                         FROM vw_ProductSpec v
                         WHERE v.product_id = ?
                         """;
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, productId);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new ProductCompareDTO();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setThumbnail(rs.getString("thumbnail"));
                p.setBrandName(rs.getString("brand_name"));
                p.setCategoryName(rs.getString("category_name"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setOriginalPrice(rs.getLong("original_price"));
                p.setDiscountPercent(rs.getInt("discount_percent"));
                p.setMinPrice(rs.getLong("min_price"));
                p.setWarrantyPeriod(rs.getInt("warranty_period"));
                p.setDescription(rs.getString("description"));
                p.setTotalStock(rs.getInt("total_stock"));
                
                // specs
                p.setCpu(rs.getString("cpu"));
                p.setRam(rs.getString("ram"));
                p.setSsd(rs.getString("ssd"));
                p.setGpu(rs.getString("gpu"));
                p.setScreen(rs.getString("screen"));
                p.setConnectivity(rs.getString("connectivity"));
                p.setSwitchType(rs.getString("switch_type"));
                p.setDpi(rs.getString("dpi"));
            }
        } catch (Exception e) {
            System.out.println("getProductCompareDetail: " + e.getMessage());
        }
        return p;
    }
}

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
    //B├ín Chß║íy 
   // Lß║Ñy top 10 laptop b├ín chß║íy nhß║Ñt 
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
// Lß║Ñy top 10 Chuß╗Öt b├ín chß║íy nhß║Ñt 
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
 
// Lß║Ñy top 10 b├án ph├¡m b├ín chß║íy nhß║Ñt 
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
 
 //Sß║ún phß║⌐m mß╗¢i 
 //sql lß║Ñy  10 Laptop mß╗¢i 
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
 
// 10 sp chuß╗Öt mß╗¢i 
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
 // 10 sp b├án ph├¡m mß╗¢i
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

 // T├¼m category_id tß╗½ t├¬n sß║ún phß║⌐m khi search
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

 // T├¼m sß║ún phß║⌐m theo keyword tr├¬n tß║Ñt cß║ú danh mß╗Ñc (d├╣ng cho Home search)
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

 // ─Éß║┐m tß╗òng sß║ún phß║⌐m t├¼m ─æ╞░ß╗úc theo keyword
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

    public ArrayList<Product> searchAllProducts(String keyword, String category, String sortBy, String itemStatus, int page, int pageSize) {
        ArrayList<Product> data = new ArrayList<>();
        try {
            String order = (sortBy != null && sortBy.equals("lowToHigh")) ? "ASC" : "DESC";
            String orderClause = "ORDER BY p.product_id DESC";
            if (sortBy != null && (sortBy.equals("highToLow") || sortBy.equals("lowToHigh"))) {
                orderClause = "ORDER BY min_price " + order;
            }

            String statusFilter = "";
            if ("hidden".equalsIgnoreCase(itemStatus)) {
                statusFilter = "v.status = 'inactive' AND NOT EXISTS (SELECT 1 FROM ProductVariant pv2 WHERE pv2.product_id = p.product_id AND pv2.status = 'active')";
            } else if ("all".equalsIgnoreCase(itemStatus)) {
                statusFilter = "(v.status = 'active' OR (v.status = 'inactive' AND NOT EXISTS (SELECT 1 FROM ProductVariant pv2 WHERE pv2.product_id = p.product_id AND pv2.status = 'active')))";
            } else {
                statusFilter = "v.status = 'active'";
            }

            String sql = "SELECT " +
                         "    p.product_id, p.product_name, p.thumbnail, " +
                         "    b.brand_name, c.category_name, p.category_id, " +
                         "    MIN(ISNULL(fs_active.sale_price, v.selling_price)) AS min_price, " +
                         "    MIN(v.selling_price) AS original_price, " +
                         "    CASE WHEN MIN(v.selling_price) > 0 THEN CAST(ROUND((MIN(v.selling_price) - MIN(ISNULL(fs_active.sale_price, v.selling_price))) * 100.0 / MIN(v.selling_price), 0) AS INT) ELSE 0 END AS discount_percent, " +
                         "    CASE WHEN SUM(CASE WHEN v.status = 'active' THEN 1 ELSE 0 END) > 0 THEN 0 ELSE 1 END AS is_hidden " +
                         "FROM Product p " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN ProductVariant v ON p.product_id = v.product_id " +
                         "LEFT JOIN ( " +
                         "    SELECT fsi.variant_id, MIN(fsi.sale_price) AS sale_price " +
                         "    FROM FlashSaleItem fsi " +
                         "    JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id " +
                         "    WHERE GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time " +
                         "    GROUP BY fsi.variant_id " +
                         ") fs_active ON v.variant_id = fs_active.variant_id " +
                         "WHERE " + statusFilter;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                sql += " AND c.category_name = ?";
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE ? OR b.brand_name LIKE ?)";
            }

            sql += " GROUP BY p.product_id, p.product_name, p.thumbnail, b.brand_name, c.category_name, p.category_id " +
                   orderClause + " " +
                   "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            ps = cnn.prepareStatement(sql);
            int idx = 1;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                ps.setString(idx++, category);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx++, pageSize);

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
                p.setHidden(rs.getInt("is_hidden") == 1);
                data.add(p);
            }
        } catch (Exception e) {
            System.out.println("searchAllProducts Error: " + e.getMessage());
        }
        return data;
    }

    public int countSearchAllProducts(String keyword, String category, String itemStatus) {
        try {
            String statusFilter = "";
            if ("hidden".equalsIgnoreCase(itemStatus)) {
                statusFilter = "v.status = 'inactive' AND NOT EXISTS (SELECT 1 FROM ProductVariant pv2 WHERE pv2.product_id = p.product_id AND pv2.status = 'active')";
            } else if ("all".equalsIgnoreCase(itemStatus)) {
                statusFilter = "(v.status = 'active' OR (v.status = 'inactive' AND NOT EXISTS (SELECT 1 FROM ProductVariant pv2 WHERE pv2.product_id = p.product_id AND pv2.status = 'active')))";
            } else {
                statusFilter = "v.status = 'active'";
            }

            String sql = "SELECT COUNT(DISTINCT p.product_id) " +
                         "FROM Product p " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN ProductVariant v ON p.product_id = v.product_id " +
                         "WHERE " + statusFilter;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                sql += " AND c.category_name = ?";
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE ? OR b.brand_name LIKE ?)";
            }

            ps = cnn.prepareStatement(sql);
            int idx = 1;

            if (category != null && !category.trim().isEmpty() && !category.equals("all")) {
                ps.setString(idx++, category);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countSearchAllProducts Error: " + e.getMessage());
        }
        return 0;
    }


 // Ph╞░╞íng thß╗⌐c lß╗ìc tß╗òng hß╗úp - gß╗ìi tß╗½ ProductListServlet
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

 // Ph╞░╞íng thß╗⌐c ─æß║┐m tß╗òng hß╗úp - gß╗ìi tß╗½ ProductListServlet
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

 // Lß║Ñy th├┤ng tin chi tiß║┐t 1 sß║ún phß║⌐m theo product_id (cho trang chi tiß║┐t)
public Product getProductById(int productId) {
    try {
        String sql = "SELECT p.product_id, p.product_name, p.description, p.warranty_period, p.purpose, "
                   + "p.thumbnail, p.category_id, p.brand_id, c.category_name, b.brand_name, "
                   + "spec.cpu, spec.ram, spec.ssd, spec.gpu, spec.screen, spec.connectivity, spec.switch_type, spec.dpi "
                   + "FROM Product p "
                   + "JOIN Category c ON p.category_id = c.category_id "
                   + "JOIN Brand b ON p.brand_id = b.brand_id "
                   + "LEFT JOIN ( "
                   + "    SELECT pv.product_id, "
                   + "           MAX(CASE WHEN vs.specification_id = 1  THEN vs.value END) AS cpu, "
                   + "           MAX(CASE WHEN vs.specification_id = 2  THEN vs.value END) AS ram, "
                   + "           MAX(CASE WHEN vs.specification_id = 5  THEN vs.value END) AS ssd, "
                   + "           MAX(CASE WHEN vs.specification_id = 4  THEN vs.value END) AS gpu, "
                   + "           MAX(CASE WHEN vs.specification_id = 3  THEN vs.value END) AS screen, "
                   + "           MAX(CASE WHEN vs.specification_id = 18 THEN vs.value END) AS connectivity, "
                   + "           MAX(CASE WHEN vs.specification_id = 10 THEN vs.value END) AS switch_type, "
                   + "           MAX(CASE WHEN vs.specification_id = 13 THEN vs.value END) AS dpi "
                   + "    FROM VariantSpecification vs "
                   + "    JOIN ProductVariant pv ON vs.variant_id = pv.variant_id "
                   + "    GROUP BY pv.product_id "
                   + ") spec ON p.product_id = spec.product_id "
                   + "WHERE p.product_id = ?";
        ps = cnn.prepareStatement(sql);
        ps.setInt(1, productId);
        rs = ps.executeQuery();
        if (rs.next()) {
            int catId = rs.getInt("category_id");
            Product p;
            if (catId == 1) {
                Product.Laptop laptop = new Product.Laptop();
                laptop.setCpu(rs.getString("cpu"));
                laptop.setRam(rs.getString("ram"));
                laptop.setSsd(rs.getString("ssd"));
                laptop.setGpu(rs.getString("gpu"));
                laptop.setScreen(rs.getString("screen"));
                p = laptop;
            } else if (catId == 3) {
                Product.Keyboard keyboard = new Product.Keyboard();
                keyboard.setConnectivity(rs.getString("connectivity"));
                keyboard.setSwitchType(rs.getString("switch_type"));
                p = keyboard;
            } else if (catId == 4) {
                Product.Mouse mouse = new Product.Mouse();
                mouse.setConnectivity(rs.getString("connectivity"));
                mouse.setDpi(rs.getString("dpi"));
                p = mouse;
            } else {
                p = new Product();
            }
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setDescription(rs.getString("description"));
            p.setWarrantyPeriod(rs.getInt("warranty_period"));
            p.setPurpose(rs.getString("purpose"));
            p.setThumbnail(rs.getString("thumbnail"));
            p.setCategoryId(catId);
            p.setBrandId(rs.getInt("brand_id"));
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

public String getProductBadge(int productId, int categoryId) {
    String topSellingSql = "SELECT COUNT(*) FROM ("
            + "    SELECT TOP 10 p.product_id"
            + "    FROM Product p"
            + "    JOIN ProductVariant v ON p.product_id = v.product_id"
            + "    LEFT JOIN OrderDetail od ON v.variant_id = od.variant_id"
            + "    WHERE v.status = 'active' AND p.category_id = ?"
            + "    GROUP BY p.product_id"
            + "    ORDER BY SUM(ISNULL(od.quantity, 0)) DESC"
            + ") t WHERE t.product_id = ?";
            
    String topNewSql = "SELECT COUNT(*) FROM ("
            + "    SELECT TOP 10 p.product_id"
            + "    FROM Product p"
            + "    JOIN ProductVariant v ON p.product_id = v.product_id"
            + "    WHERE v.status = 'active' AND p.category_id = ?"
            + "    GROUP BY p.product_id"
            + "    ORDER BY p.product_id DESC"
            + ") t WHERE t.product_id = ?";
            
    try {
        java.sql.PreparedStatement ps1 = cnn.prepareStatement(topSellingSql);
        ps1.setInt(1, categoryId);
        ps1.setInt(2, productId);
        java.sql.ResultSet rs1 = ps1.executeQuery();
        if (rs1.next() && rs1.getInt(1) > 0) {
            rs1.close();
            ps1.close();
            return "B├ín chß║íy";
        }
        rs1.close();
        ps1.close();
        
        java.sql.PreparedStatement ps2 = cnn.prepareStatement(topNewSql);
        ps2.setInt(1, categoryId);
        ps2.setInt(2, productId);
        java.sql.ResultSet rs2 = ps2.executeQuery();
        if (rs2.next() && rs2.getInt(1) > 0) {
            rs2.close();
            ps2.close();
            return "Mß╗¢i";
        }
        rs2.close();
        ps2.close();
    } catch (Exception e) {
        System.out.println("getProductBadge error: " + e.getMessage());
    }
    return "Mß╗¢i";
}

    public List<Product> getSimilarProducts(String purpose, int categoryId, int productId, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            boolean usePurpose = (purpose != null && !purpose.trim().isEmpty());
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
                         (usePurpose ? "AND p.purpose = ? " : "") +
                         "AND p.product_id != ? " +
                         "GROUP BY " +
                         "    p.product_id, " +
                         "    p.product_name, " +
                         "    p.thumbnail, " +
                         "    b.brand_name " +
                         "ORDER BY p.product_id DESC";
            ps = cnn.prepareStatement(sql);
            int paramIndex = 1;
            ps.setInt(paramIndex++, categoryId);
            if (usePurpose) {
                ps.setString(paramIndex++, purpose);
            }
            ps.setInt(paramIndex++, productId);
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
            e.printStackTrace();
        }
        return list;
    }

    // === WAREHOUSE / INVENTORY MANAGEMENT METHODS ===

public List<Product> GetAllProducts() {
        // Lß║Ñy danh s├ích tß║Ñt cß║ú c├íc sß║ún phß║⌐m (c╞í bß║ún) tß╗½ c╞í sß╗ƒ dß╗» liß╗çu
        List<Product> products = new ArrayList<Product>();
        try{
            String sql = "select * from Product";
            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()) {
            Product p = new Product(rs.getInt("product_id"), rs.getString("product_name"), rs.getString("description"), rs.getInt("warranty_period"),
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
     * Description: Lß║Ñy danh s├ích tß║Ñt cß║ú c├íc biß║┐n thß╗â cß╗ºa sß║ún phß║⌐m.
     */
    public List<model.ProductVariant> getAllVariants() {
        List<model.ProductVariant> variants = new ArrayList<>();
        try {
            String sql = "SELECT * FROM ProductVariant WHERE status = 'active'";
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
                pv.setThumbnail(rs.getString("thumbnail"));
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
     * Description: Lß║Ñy th├┤ng tin chi tiß║┐t cß╗ºa biß║┐n thß╗â theo ID.
     */
    public model.ProductVariant getVariantById(int variantId) {
        try {
            String sql = "SELECT * FROM ProductVariant WHERE variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
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
                pv.setThumbnail(rs.getString("thumbnail"));
                return pv;
            }
        } catch (Exception e) {
            System.out.println("getVariantById Error: " + e.getMessage());
        }
        return null;
    }

    public CartItem getCartItemByVariantId(int variantId) {
        try {
            String sql = "SELECT pv.variant_id, pv.product_id, p.product_name, pv.variant_name, p.thumbnail, pv.selling_price, p.warranty_period, isnull(inv.available_quantity, 0) AS available_quantity " +
                         "FROM ProductVariant pv " +
                         "JOIN Product p ON pv.product_id = p.product_id " +
                         "LEFT JOIN Inventory inv ON pv.variant_id = inv.variant_id " +
                         "WHERE pv.variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                CartItem item = new CartItem(
                        rs.getInt("variant_id"),
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("variant_name"),
                        rs.getString("thumbnail"),
                        rs.getBigDecimal("selling_price"),
                        1,
                        rs.getInt("available_quantity")
                );
                item.setWarrantyPeriod(rs.getInt("warranty_period"));
                return item;
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
     * Description: Lß║Ñy danh s├ích chi tiß║┐t c├íc sß║ún phß║⌐m bao gß╗ôm th├┤ng tin kho h├áng, danh mß╗Ñc, th╞░╞íng hiß╗çu.
     */
    public List<ProductInventory> GetAllProductInventory() {
        // Lß║Ñy danh s├ích sß║ún phß║⌐m c├╣ng vß╗¢i th├┤ng tin kho h├áng, danh mß╗Ñc, th╞░╞íng hiß╗çu
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
            // Join nhiß╗üu bß║úng ─æß╗â lß║Ñy ─æß║ºy ─æß╗º th├┤ng tin: T├¬n sß║ún phß║⌐m, biß║┐n thß╗â, gi├í b├ín, sß╗æ l╞░ß╗úng kho...
            String sql = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, \n" +
                        "case \n" +
                        "	when i.available_quantity > 0 then N'In Stock'\n" +
                        "	else N'Sold Out'\n" +
                        "end as status, p.thumbnail\n" +
                        "from Product p join Category c on p.category_id = c.category_id\n" +
                        "	join Brand b on p.brand_id = b.brand_id\n" +
                        "	join ProductVariant pv on p.product_id = pv.product_id\n" +
                        "	left join Inventory i on pv.variant_id = i.variant_id\n"
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
     * Description: T├¼m kiß║┐m sß║ún phß║⌐m theo t├¬n, danh mß╗Ñc, SKU v├á sß║»p xß║┐p theo gi├í.
     */
    public List<ProductInventory> GetProductsByNameAndSort(String search, String sortBy){
        // H├ám t├¼m kiß║┐m sß║ún phß║⌐m theo t├¬n, danh mß╗Ñc, sku v├á sß║»p xß║┐p gi├í
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
            // X├íc ─æß╗ïnh chiß╗üu sß║»p xß║┐p: ASC (thß║Ñp ─æß║┐n cao) hoß║╖c DESC (cao ─æß║┐n thß║Ñp)
            String order = (sortBy.equals("lowToHigh")) ? "ASC" : "DESC"; 
            String strSQL = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, \n" +
                        "case \n" +
                        "	when i.available_quantity > 0 then N'In Stock'\n" +
                        "	else N'Sold Out'\n" +
                        "end as status, p.thumbnail\n" +
                        "from Product p join Category c on p.category_id = c.category_id\n" +
                        "	join Brand b on p.brand_id = b.brand_id\n" +
                        "	join ProductVariant pv on p.product_id = pv.product_id\n" +
                        "	left join Inventory i on pv.variant_id = i.variant_id\n" +
                        // Lß╗ìc theo tß╗½ kh├│a t├¼m kiß║┐m (so khß╗¢p t╞░╞íng ─æß╗æi bß║▒ng LIKE)
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
     * Description: X├│a cß╗⌐ng mß╗Öt biß║┐n thß╗â sß║ún phß║⌐m khß╗Åi c╞í sß╗ƒ dß╗» liß╗çu dß╗▒a tr├¬n m├ú biß║┐n thß╗â (variant_id).
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
     * Description: ─Éß║┐m tß╗òng sß╗æ l╞░ß╗úng biß║┐n thß╗â sß║ún phß║⌐m ─æang hoß║ít ─æß╗Öng, c├│ hß╗ù trß╗ú lß╗ìc theo tß╗½ kh├│a t├¼m kiß║┐m.
     */
    public int getTotalInventoryCount(String search, String category, String stockStatus, String itemStatus) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id " +
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
     * Description: Lß║Ñy danh s├ích sß║ún phß║⌐m chi tiß║┐t c├│ ph├ón trang, hß╗ù trß╗ú lß╗ìc theo tß╗½ kh├│a v├á sß║»p xß║┐p theo gi├í.
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
                         "LEFT JOIN Inventory i ON pv.variant_id = i.variant_id " +
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
     * Description: Th├¬m mß╗¢i mß╗Öt sß║ún phß║⌐m (Product) v├áo c╞í sß╗ƒ dß╗» liß╗çu v├á trß║ú vß╗ü ID tß╗▒ t─âng cß╗ºa sß║ún phß║⌐m vß╗½a th├¬m.
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
     * Description: Th├¬m mß╗¢i mß╗Öt biß║┐n thß╗â cß╗ºa sß║ún phß║⌐m (ProductVariant) v├á khß╗ƒi tß║ío bß║ún ghi tß╗ôn kho (Inventory) t╞░╞íng ß╗⌐ng.
     */
    public void insertProductVariant(int productId, String sku, String variantName,
                                     java.math.BigDecimal importPrice, java.math.BigDecimal sellingPrice, int stock) {
        try {
            String sql = "INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, is_serialized, status, thumbnail) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setString(2, sku);
            ps.setString(3, variantName);
            ps.setBigDecimal(4, importPrice);
            ps.setBigDecimal(5, sellingPrice);
            ps.setBoolean(6, false);
            ps.setString(7, "active");
            ps.setString(8, null);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) {
                variantId = rs.getInt(1);
            }
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, available_quantity) VALUES (?, ?)";
                PreparedStatement psInv = cnn.prepareStatement(sqlInv);
                psInv.setInt(1, variantId);
                psInv.setInt(2, stock);
                psInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Insert ProductVariant Error: " + e.getMessage());
        }
    }

    public void insertProductVariant(int productId, String sku, String variantName, java.math.BigDecimal price, int stock) {
        insertProductVariant(productId, sku, variantName, price, price, stock);
    }

    /**
     * Thêm biến thể kèm thumbnail riêng.
     */
    public void insertProductVariant(int productId, String sku, String variantName,
                                     java.math.BigDecimal importPrice, java.math.BigDecimal sellingPrice, int stock, String thumbnail) {
        try {
            String sql = "INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, is_serialized, status, thumbnail) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setString(2, sku);
            ps.setString(3, variantName);
            ps.setBigDecimal(4, importPrice);
            ps.setBigDecimal(5, sellingPrice);
            ps.setBoolean(6, false);
            ps.setString(7, "active");
            ps.setString(8, thumbnail);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) {
                variantId = rs.getInt(1);
            }
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, available_quantity) VALUES (?, ?)";
                PreparedStatement psInv = cnn.prepareStatement(sqlInv);
                psInv.setInt(1, variantId);
                psInv.setInt(2, stock);
                psInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Insert ProductVariant with thumbnail Error: " + e.getMessage());
        }
    }
    
    /*
     * Name: updateProductVariant
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Cß║¡p nhß║¡t th├┤ng tin cß╗ºa mß╗Öt ProductVariant v├á tß╗ôn kho cß╗ºa n├│ dß╗▒a tr├¬n giao diß╗çn.
     */
    public void updateProductVariant(int variantId, String sku, String variantName, java.math.BigDecimal price) {
        try {
            // Update ProductVariant table
            String sql = "UPDATE ProductVariant SET sku = ?, variant_name = ?, selling_price = ? WHERE variant_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, sku);
            ps.setString(2, variantName);
            ps.setBigDecimal(3, price);
            ps.setInt(4, variantId);
            ps.executeUpdate();
            
            // Removed direct update to Inventory.available_quantity to enforce Inbound flow.
        } catch (Exception e) {
            System.out.println("Update ProductVariant Error: " + e.getMessage());
        }
    }
    
    /*
     * Name: hideProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: ß║¿n (x├│a mß╗üm) mß╗Öt biß║┐n thß╗â sß║ún phß║⌐m bß║▒ng c├ích cß║¡p nhß║¡t trß║íng th├íi th├ánh 'inactive'.
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
     * Description: Kh├┤i phß╗Ñc mß╗Öt biß║┐n thß╗â sß║ún phß║⌐m ─æ├ú bß╗ï ß║⌐n bß║▒ng c├ích cß║¡p nhß║¡t trß║íng th├íi th├ánh 'active'.
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

    public void hideProductGroup(int product_id) {
        try {
            String strSQL = "UPDATE ProductVariant SET status = 'inactive' WHERE product_id = ?";
            ps = cnn.prepareStatement(strSQL);
            ps.setInt(1, product_id);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("hideProductGroup Error: " + e.getMessage());
        }
    }

    public void unhideProductGroup(int product_id) {
        try {
            String strSQL = "UPDATE ProductVariant SET status = 'active' WHERE product_id = ?";
            ps = cnn.prepareStatement(strSQL);
            ps.setInt(1, product_id);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("unhideProductGroup Error: " + e.getMessage());
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

    public boolean isSkuExist(String sku) {
        try {
            String sql = "SELECT COUNT(*) FROM ProductVariant WHERE sku = ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, sku.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("isSkuExist: " + e.getMessage());
        }
        return false;
    }

    public boolean isSkuExist(String sku, int excludeVariantId) {
        try {
            String sql = "SELECT COUNT(*) FROM ProductVariant WHERE sku = ? AND variant_id != ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, sku.trim());
            ps.setInt(2, excludeVariantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("isSkuExist with excludeVariantId: " + e.getMessage());
        }
        return false;
    }
}

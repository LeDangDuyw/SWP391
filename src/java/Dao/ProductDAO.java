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
                         b.brand_name,
                         p.created_at 
                     ORDER BY p.created_at DESC;
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
                     AND p.category_id = 2
                     GROUP BY
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         b.brand_name,
                         p.created_at 
                     ORDER BY p.created_at DESC;
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
                         b.brand_name,
                         p.created_at 
                     ORDER BY p.created_at DESC;
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
 // Lọc Laptop
 public ArrayList<Product> filterLaptop(int categoryId,Integer brandId,Integer seriesId,String purpose,String cpu,String ram,String ssd,String gpu,String screen,String price, String sort, int page, int pageSize, String search, String connectivity, String switchType, String dpi) {
    ArrayList<Product> data = new ArrayList<>();
    try {
        String sql = """
            SELECT
                p.product_id,
                p.product_name,
                p.thumbnail,
                b.brand_id,
                b.brand_name,
                c.category_name,
                ps.series_id,
                ps.series_name,
                p.sold_quantity,
                MIN(pv.selling_price) AS min_price,
                --Thêm subquery lấy cpu, ram, gpu để hiển thị tag trên UI
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 1) AS cpu,
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 2) AS ram,
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 4) AS gpu,
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 5) AS connectivity,
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 6) AS switch_type,
                (SELECT TOP 1 value FROM VariantSpecification WHERE variant_id = (SELECT TOP 1 variant_id FROM ProductVariant WHERE product_id = p.product_id ORDER BY selling_price ASC) AND specification_id = 7) AS dpi
            FROM Product p
            JOIN Brand b
                ON p.brand_id = b.brand_id
            JOIN Category c
                ON p.category_id = c.category_id
            LEFT JOIN ProductSeries ps
                ON p.series_id = ps.series_id
            JOIN ProductVariant pv
                ON p.product_id = pv.product_id
            WHERE p.category_id = ?
        """;
        if (brandId != null) {
            sql += " AND p.brand_id = ?";
        }
        if (seriesId != null) {
            sql += " AND p.series_id = ?";
        }
        if (purpose != null && !purpose.isEmpty()) {
            sql += " AND p.description LIKE ?";
        }
        // CPU
        if (cpu != null && !cpu.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1
                    FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id
                    AND vs.specification_id = 1
                    AND vs.value = ?
                )
            """;
        }
        // RAM
        if (ram != null && !ram.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1
                    FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id
                    AND vs.specification_id = 2
                    AND vs.value = ?
                )
            """;
        }
        // SSD
        if (ssd != null && !ssd.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1
                    FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id
                    AND vs.specification_id = 3
                    AND vs.value = ?
                )
            """;
        }
        // GPU
        if (gpu != null && !gpu.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1
                    FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id
                    AND vs.specification_id = 4
                    AND vs.value = ?
                )
            """;
        }
        // Màn hình
        if (screen != null && !screen.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1
                    FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id
                    AND vs.specification_id = 8
                    AND vs.value LIKE ?
                )
            """;
        }
        
        //filter cho Chuột, Bàn phím
        if (connectivity != null && !connectivity.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1 FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 5 AND vs.value = ?
                )
""";
        }
        if (switchType != null && !switchType.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1 FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 6 AND vs.value = ?
                )
""";
        }
        if (dpi != null && !dpi.isEmpty()) {
            sql += """
                AND EXISTS (
                    SELECT 1 FROM VariantSpecification vs
                    WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 7 AND vs.value = ?
                )
""";
        }
        // Giá
        if (price != null) {

            switch (price) {

                case "under15":
                    sql += " AND pv.selling_price < 15000000";
                    break;

                case "15to20":
                    sql += " AND pv.selling_price BETWEEN 15000000 AND 20000000";
                    break;

                case "20to30":
                    sql += " AND pv.selling_price BETWEEN 20000000 AND 30000000";
                    break;

                case "30to40":
                    sql += " AND pv.selling_price BETWEEN 30000000 AND 40000000";
                    break;

                case "over40":
                    sql += " AND pv.selling_price > 40000000";
                    break;
                    
                //Mức giá cho Phụ kiện, Chuột, Bàn phím
                case "under500k":
                    sql += " AND pv.selling_price < 500000";
                    break;
                case "500kto1m":
                    sql += " AND pv.selling_price BETWEEN 500000 AND 1000000";
                    break;
                case "1mto2m":
                    sql += " AND pv.selling_price BETWEEN 1000000 AND 2000000";
                    break;
                case "2mto3m":
                    sql += " AND pv.selling_price BETWEEN 2000000 AND 3000000";
                    break;
                case "over3m":
                    sql += " AND pv.selling_price > 3000000";
                    break;
            }
        }
        //Thêm lọc theo từ khoá tìm kiếm
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND p.product_name LIKE ?";
        }
        sql += """
            GROUP BY
                p.product_id,
                p.product_name,
                p.thumbnail,
                b.brand_id,
                b.brand_name,
                c.category_name,
                ps.series_id,
                ps.series_name,
                p.sold_quantity
        """;

        //Thêm ORDER BY và phân trang (OFFSET FETCH)
        if ("price_asc".equals(sort)) {
            sql += " ORDER BY min_price ASC";
        } else if ("price_desc".equals(sort)) {
            sql += " ORDER BY min_price DESC";
        } else if ("new".equals(sort)) {
            sql += " ORDER BY p.product_id DESC";
        } else {
            sql += " ORDER BY p.sold_quantity DESC";
        }
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        ps = cnn.prepareStatement(sql);
        int index = 1;
        ps.setInt(index++, categoryId);
        if (brandId != null) {
            ps.setInt(index++, brandId);
        }
        if (seriesId != null) {
            ps.setInt(index++, seriesId);
        }
        if (purpose != null && !purpose.isEmpty()) {
            ps.setString(index++, "%" + purpose + "%");
        }
        if (cpu != null && !cpu.isEmpty()) {
            ps.setString(index++, cpu);
        }
        if (ram != null && !ram.isEmpty()) {
            ps.setString(index++, ram);
        }
        if (ssd != null && !ssd.isEmpty()) {
            ps.setString(index++, ssd);
        }
        if (gpu != null && !gpu.isEmpty()) {
            ps.setString(index++, gpu);
        }
        if (screen != null && !screen.isEmpty()) {
            ps.setString(index++, "%" + screen + "%");
        }
        
        // set param cho phu kien
        if (connectivity != null && !connectivity.isEmpty()) ps.setString(index++, connectivity);
        if (switchType != null && !switchType.isEmpty()) ps.setString(index++, switchType);
        if (dpi != null && !dpi.isEmpty()) ps.setString(index++, dpi);

        //set giá trị cho tham số tìm kiếm
        if (search != null && !search.trim().isEmpty()) {
            ps.setString(index++, "%" + search.trim() + "%");
        }
        
        ps.setInt(index++, (page - 1) * pageSize);
        ps.setInt(index++, pageSize);

        rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setThumbnail(rs.getString("thumbnail"));
            p.setBrandId(rs.getInt("brand_id"));
            p.setBrandName(rs.getString("brand_name"));
            p.setCategoryName(rs.getString("category_name"));
            p.setSeriesId(rs.getInt("series_id"));
            p.setSeriesName(rs.getString("series_name"));
            p.setMinPrice(rs.getLong("min_price"));
            //set giá trị cpu, ram, gpu vào model
            p.setCpu(rs.getString("cpu"));
            p.setRam(rs.getString("ram"));
            p.setGpu(rs.getString("gpu"));
            
            // map them cac spec moi
            p.setConnectivity(rs.getString("connectivity"));
            p.setSwitchType(rs.getString("switch_type"));
            p.setDpi(rs.getString("dpi"));
            
            data.add(p);
        }
    } catch (Exception e) {
        System.out.println("filterLaptop: " + e.getMessage());
    }
    return data;
}

public int countFilteredLaptop(int categoryId,Integer brandId,Integer seriesId,String purpose,String cpu,String ram,String ssd,String gpu,String screen,String price, String search, String connectivity, String switchType, String dpi) {
    try {
        String sql = """
            SELECT COUNT(DISTINCT p.product_id)
            FROM Product p
            JOIN ProductVariant pv ON p.product_id = pv.product_id
            WHERE p.category_id = ?
        """;
        if (brandId != null) sql += " AND p.brand_id = ?";
        if (seriesId != null) sql += " AND p.series_id = ?";
        if (purpose != null && !purpose.isEmpty()) sql += " AND p.description LIKE ?";
        if (cpu != null && !cpu.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 1 AND vs.value = ?)";
        if (ram != null && !ram.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 2 AND vs.value = ?)";
        if (ssd != null && !ssd.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 3 AND vs.value = ?)";
        if (gpu != null && !gpu.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 4 AND vs.value = ?)";
        if (screen != null && !screen.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 8 AND vs.value LIKE ?)";
        if (connectivity != null && !connectivity.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 5 AND vs.value = ?)";
        if (switchType != null && !switchType.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 6 AND vs.value = ?)";
        if (dpi != null && !dpi.isEmpty()) sql += " AND EXISTS (SELECT 1 FROM VariantSpecification vs WHERE vs.variant_id = pv.variant_id AND vs.specification_id = 7 AND vs.value = ?)";
        if (price != null) {
            switch (price) {
                case "under15": sql += " AND pv.selling_price < 15000000"; break;
                case "15to20": sql += " AND pv.selling_price BETWEEN 15000000 AND 20000000"; break;
                case "20to30": sql += " AND pv.selling_price BETWEEN 20000000 AND 30000000"; break;
                case "30to40": sql += " AND pv.selling_price BETWEEN 30000000 AND 40000000"; break;
                case "over40": sql += " AND pv.selling_price > 40000000"; break;
                
                //Mức giá cho Phụ kiện, Chuột, Bàn phím
                case "under500k": sql += " AND pv.selling_price < 500000"; break;
                case "500kto1m": sql += " AND pv.selling_price BETWEEN 500000 AND 1000000"; break;
                case "1mto2m": sql += " AND pv.selling_price BETWEEN 1000000 AND 2000000"; break;
                case "2mto3m": sql += " AND pv.selling_price BETWEEN 2000000 AND 3000000"; break;
                case "over3m": sql += " AND pv.selling_price > 3000000"; break;
            }
        }
        //Thêm điều kiện tìm kiếm đếm số lượng
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND p.product_name LIKE ?";
        }

        ps = cnn.prepareStatement(sql);
        int index = 1;
        ps.setInt(index++, categoryId);
        if (brandId != null) ps.setInt(index++, brandId);
        if (seriesId != null) ps.setInt(index++, seriesId);
        if (purpose != null && !purpose.isEmpty()) ps.setString(index++, "%" + purpose + "%");
        if (cpu != null && !cpu.isEmpty()) ps.setString(index++, cpu);
        if (ram != null && !ram.isEmpty()) ps.setString(index++, ram);
        if (ssd != null && !ssd.isEmpty()) ps.setString(index++, ssd);
        if (gpu != null && !gpu.isEmpty()) ps.setString(index++, gpu);
        if (screen != null && !screen.isEmpty()) ps.setString(index++, "%" + screen + "%");
        
        if (connectivity != null && !connectivity.isEmpty()) ps.setString(index++, connectivity);
        if (switchType != null && !switchType.isEmpty()) ps.setString(index++, switchType);
        if (dpi != null && !dpi.isEmpty()) ps.setString(index++, dpi);
        
        if (search != null && !search.trim().isEmpty()) ps.setString(index++, "%" + search.trim() + "%");

        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        System.out.println("countFilteredLaptop: " + e.getMessage());
    }
    return 0;
}
 
 
}

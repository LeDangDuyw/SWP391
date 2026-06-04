package dal;
import dal.DBContext;
import java.sql.Connection;
import model.Product;
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
    public int getTotalInventoryCount(String search) {
        // Đếm tổng số lượng sản phẩm (phục vụ cho việc phân trang)
        int count = 0;
        try {
            String sql = "select count(*) from Product p " +
                         "join Category c on p.category_id = c.category_id " +
                         "join Brand b on p.brand_id = b.brand_id " +
                         "join ProductVariant pv on p.product_id = pv.product_id " +
                         "join Inventory i on pv.variant_id = i.variant_id " +
                    "where pv.status = 'active'";
            // Nếu có tham số tìm kiếm, nối thêm điều kiện WHERE vào câu query
            if (search != null && !search.trim().isEmpty()) {
                sql += " and (p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%')";
            }
            ps = cnn.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, search);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return count;
    }

    /*
     * Name: GetProductInventoryPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách sản phẩm chi tiết có phân trang, hỗ trợ lọc theo từ khóa và sắp xếp theo giá.
     */
    public List<ProductInventory> GetProductInventoryPaginated(String search, String sortBy, int offset, int fetchSize){
        // Lấy danh sách sản phẩm có phân trang (dùng OFFSET và FETCH NEXT của SQL Server)
        List<ProductInventory> products = new ArrayList<>();
        try {
            // Sắp xếp: Mặc định là DESC, nếu truyền lowToHigh thì là ASC
            String order = (sortBy != null && !sortBy.equals("all") && sortBy.equals("lowToHigh")) ? "ASC" : "DESC"; 
            String strSQL = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, " +
                        "case " +
                        "	when i.available_quantity > 0 then N'In Stock' " +
                        "	else N'Sold Out' " +
                        "end as status, p.thumbnail " +
                        "from Product p join Category c on p.category_id = c.category_id " +
                        "	join Brand b on p.brand_id = b.brand_id " +
                        "	join ProductVariant pv on p.product_id = pv.product_id " +
                        "	join Inventory i on pv.variant_id = i.variant_id " +
                        "where pv.status = 'active'";
                        
            if (search != null && !search.trim().isEmpty()) {
                strSQL += " and (p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%') ";
            }
            strSQL += "order by pv.selling_price " + order + " " +
                      "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            ps = cnn.prepareStatement(strSQL);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, fetchSize);
            
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
        } catch(Exception e ){
            System.out.println(e.getMessage());
        }
        return products;
    }
    /*
     * Name: insertProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới một sản phẩm (Product) vào cơ sở dữ liệu và trả về ID tự tăng của sản phẩm vừa thêm.
     */
    public int insertProduct(Product p) {
        // Thêm mới một sản phẩm vào bảng Product và trả về ID vừa được sinh ra
        int productId = -1;
        try {
            String sql = "INSERT INTO Product (product_name, description, warranty_period, thumbnail, category_id, brand_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            // Dùng Statement.RETURN_GENERATED_KEYS để lấy ID tự tăng
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
    public void insertProductVariant(int productId, String sku, String variantName, java.math.BigDecimal price, int stock) {
        // Thêm biến thể của sản phẩm vào bảng ProductVariant và cập nhật kho Inventory
        try {
            String sql = "INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, is_serialized, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = cnn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setString(2, sku);
            ps.setString(3, variantName);
            ps.setBigDecimal(4, price);
            ps.setBigDecimal(5, price);
            ps.setBoolean(6, false);
            ps.setString(7, "active"); // Mặc định trạng thái là active
            ps.executeUpdate();
            
            rs = ps.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) {
                variantId = rs.getInt(1); // Lấy variant_id vừa được tạo
            }
            
            // Nếu lưu biến thể thành công, tiếp tục tạo bản ghi tồn kho
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, reserved_quantity, available_quantity) VALUES (?, ?, ?)";
                PreparedStatement psInv = cnn.prepareStatement(sqlInv);
                psInv.setInt(1, variantId);
                psInv.setInt(2, 0); // reserved_quantity mặc định là 0
                psInv.setInt(3, stock);
                psInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Insert ProductVariant Error: " + e.getMessage());
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
}

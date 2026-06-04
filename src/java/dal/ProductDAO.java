/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import viewmodel.ProductInventory;
/**
 *
 * @author huy
 */
public class ProductDAO extends DBContext{
    PreparedStatement stm;
    ResultSet rs;
    /*
     * Name: GetAllProducts
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách tất cả các sản phẩm cơ bản từ cơ sở dữ liệu.
     */
    public List<Product> GetAllProducts() {
        // Lấy danh sách tất cả các sản phẩm (cơ bản) từ cơ sở dữ liệu
        List<Product> products = new ArrayList<Product>();
        try{
            String sql = "select * from Product";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
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
        stm = connection.prepareStatement(sql);
        rs = stm.executeQuery();
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
            stm = connection.prepareStatement(strSQL);
            stm.setString(1, search);
            stm.setString(2, search);
            stm.setString(3, search);
            rs = stm.executeQuery();
            
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
        stm = connection.prepareStatement(sql);
        int affectedRows = stm.executeUpdate();
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
            stm = connection.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(1, search);
                stm.setString(2, search);
                stm.setString(3, search);
            }
            rs = stm.executeQuery();
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
            
            stm = connection.prepareStatement(strSQL);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(paramIndex++, search);
                stm.setString(paramIndex++, search);
                stm.setString(paramIndex++, search);
            }
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, fetchSize);
            
            rs = stm.executeQuery();
            
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
            stm = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stm.setString(1, p.getProductName());
            stm.setString(2, p.getDescription());
            stm.setInt(3, p.getWarrantyPeriod());
            stm.setString(4, p.getThumbnail());
            stm.setInt(5, p.getCategoryId());
            stm.setInt(6, p.getBrandId());
            stm.executeUpdate();
            rs = stm.getGeneratedKeys();
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
            stm = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stm.setInt(1, productId);
            stm.setString(2, sku);
            stm.setString(3, variantName);
            stm.setBigDecimal(4, price);
            stm.setBigDecimal(5, price);
            stm.setBoolean(6, false);
            stm.setString(7, "active"); // Mặc định trạng thái là active
            stm.executeUpdate();
            
            rs = stm.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) {
                variantId = rs.getInt(1); // Lấy variant_id vừa được tạo
            }
            
            // Nếu lưu biến thể thành công, tiếp tục tạo bản ghi tồn kho
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, reserved_quantity, available_quantity) VALUES (?, ?, ?)";
                PreparedStatement stmInv = connection.prepareStatement(sqlInv);
                stmInv.setInt(1, variantId);
                stmInv.setInt(2, 0); // reserved_quantity mặc định là 0
                stmInv.setInt(3, stock);
                stmInv.executeUpdate();
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
            stm = connection.prepareStatement(strSQL);
            stm.setInt(1, variant_id);
            stm.executeUpdate();
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
            stm = connection.prepareStatement(strSQL);
            stm.setInt(1, variant_id);
            stm.executeUpdate();
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    
}

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
public class ProductDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    // ══════════════════════════════════════════════════════════════════════════
    // HELPER: build WHERE clause và set params dùng chung cho Products tab
    // ══════════════════════════════════════════════════════════════════════════

    /*
     * Name: GetAllProducts
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách tất cả sản phẩm (không phân trang).
     */
    public List<Product> GetAllProducts() {
        List<Product> products = new ArrayList<>();
        try {
            String sql = "SELECT p.product_id, p.product_name, p.description, p.warranty_period, " +
                         "p.thumbnail, p.category_id, p.brand_id, c.category_name, b.brand_name " +
                         "FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id";
            stm = connection.prepareStatement(sql);
            rs  = stm.executeQuery();
            while (rs.next()) {
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
                products.add(p);
            }
        } catch (Exception e) {
            System.out.println("GetAllProducts Error: " + e.getMessage());
        }
        return products;
    }

    // ══════════════════════════════════════════════════════════════════════════
    // TAB PRODUCTS — đếm và phân trang
    // ══════════════════════════════════════════════════════════════════════════

    /*
     * Name: getTotalProductCount
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Đếm tổng số sản phẩm (Product), hỗ trợ lọc theo tên và danh mục.
     */
    public int getTotalProductCount(String search, String category) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "WHERE 1=1";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE '%' + ? + '%' OR c.category_name LIKE '%' + ? + '%')";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND c.category_name = ?";
            }

            stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(idx++, search);
                stm.setString(idx++, search);
            }
            if (category != null && !category.trim().isEmpty()) {
                stm.setString(idx++, category);
            }

            rs = stm.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            System.out.println("getTotalProductCount Error: " + e.getMessage());
        }
        return count;
    }

    /*
     * Name: GetProductsPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Lấy danh sách sản phẩm (Product) có phân trang, lọc theo tên/danh mục và sắp xếp.
     */
    public List<Product> GetProductsPaginated(String search, String category, String sortBy, int offset, int fetchSize) {
        List<Product> products = new ArrayList<>();
        try {
            String order = (sortBy != null && sortBy.equals("lowToHigh")) ? "ASC" : "DESC";

            String sql = "SELECT p.product_id, p.product_name, p.description, p.warranty_period, " +
                         "p.thumbnail, p.category_id, p.brand_id, c.category_name, b.brand_name " +
                         "FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "WHERE 1=1";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE '%' + ? + '%' OR c.category_name LIKE '%' + ? + '%')";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND c.category_name = ?";
            }

            sql += " ORDER BY p.product_name " + order +
                   " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(idx++, search);
                stm.setString(idx++, search);
            }
            if (category != null && !category.trim().isEmpty()) {
                stm.setString(idx++, category);
            }
            stm.setInt(idx++, offset);
            stm.setInt(idx++, fetchSize);

            rs = stm.executeQuery();
            while (rs.next()) {
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
                products.add(p);
            }
        } catch (Exception e) {
            System.out.println("GetProductsPaginated Error: " + e.getMessage());
        }
        return products;
    }

    // ══════════════════════════════════════════════════════════════════════════
    // TAB VARIANTS — đếm và phân trang
    // ══════════════════════════════════════════════════════════════════════════

    /*
     * Name: getTotalInventoryCount
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Đếm tổng số biến thể sản phẩm đang active, hỗ trợ lọc theo
     *              từ khóa tìm kiếm, danh mục và trạng thái tồn kho.
     */
    public int getTotalInventoryCount(String search, String category, String stockStatus) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "JOIN Inventory i ON pv.variant_id = i.variant_id " +
                         "WHERE pv.status = 'active'";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE '%' + ? + '%'" +
                       " OR c.category_name LIKE '%' + ? + '%'" +
                       " OR pv.sku LIKE '%' + ? + '%')";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND c.category_name = ?";
            }
            if (stockStatus != null && !stockStatus.trim().isEmpty()) {
                if (stockStatus.equals("inStock")) {
                    sql += " AND i.available_quantity > 0";
                } else if (stockStatus.equals("outOfStock")) {
                    sql += " AND i.available_quantity = 0";
                } else if (stockStatus.equals("lowStock")) {
                    sql += " AND i.available_quantity > 0 AND i.available_quantity <= 5";
                }
            }

            stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(idx++, search);
                stm.setString(idx++, search);
                stm.setString(idx++, search);
            }
            if (category != null && !category.trim().isEmpty()) {
                stm.setString(idx++, category);
            }

            rs = stm.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            System.out.println("getTotalInventoryCount Error: " + e.getMessage());
        }
        return count;
    }

    /*
     * Name: GetProductInventoryPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Lấy danh sách biến thể sản phẩm có phân trang, hỗ trợ lọc theo
     *              từ khóa, danh mục, stock status và sắp xếp theo giá.
     */
    public List<ProductInventory> GetProductInventoryPaginated(
            String search, String category, String sortBy, String stockStatus,
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
                         "END AS status, p.thumbnail " +
                         "FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "JOIN Inventory i ON pv.variant_id = i.variant_id " +
                         "WHERE pv.status = 'active'";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (p.product_name LIKE '%' + ? + '%'" +
                       " OR c.category_name LIKE '%' + ? + '%'" +
                       " OR pv.sku LIKE '%' + ? + '%')";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND c.category_name = ?";
            }
            if (stockStatus != null && !stockStatus.trim().isEmpty()) {
                if (stockStatus.equals("inStock")) {
                    sql += " AND i.available_quantity > 5";
                } else if (stockStatus.equals("outOfStock")) {
                    sql += " AND i.available_quantity = 0";
                } else if (stockStatus.equals("lowStock")) {
                    sql += " AND i.available_quantity > 0 AND i.available_quantity <= 5";
                }
            }

            sql += " ORDER BY pv.selling_price " + order +
                   " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(idx++, search);
                stm.setString(idx++, search);
                stm.setString(idx++, search);
            }
            if (category != null && !category.trim().isEmpty()) {
                stm.setString(idx++, category);
            }
            stm.setInt(idx++, offset);
            stm.setInt(idx++, fetchSize);

            rs = stm.executeQuery();
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
                products.add(p);
            }
        } catch (Exception e) {
            System.out.println("GetProductInventoryPaginated Error: " + e.getMessage());
        }
        return products;
    }

    // ══════════════════════════════════════════════════════════════════════════
    // CRUD
    // ══════════════════════════════════════════════════════════════════════════

    /*
     * Name: insertProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới Product, trả về product_id tự tăng.
     */
    public int insertProduct(Product p) {
        int productId = -1;
        try {
            String sql = "INSERT INTO Product (product_name, description, warranty_period, thumbnail, category_id, brand_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            stm = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stm.setString(1, p.getProductName());
            stm.setString(2, p.getDescription());
            stm.setInt(3, p.getWarrantyPeriod());
            stm.setString(4, p.getThumbnail());
            stm.setInt(5, p.getCategoryId());
            stm.setInt(6, p.getBrandId());
            stm.executeUpdate();
            rs = stm.getGeneratedKeys();
            if (rs.next()) productId = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("insertProduct Error: " + e.getMessage());
        }
        return productId;
    }

    /*
     * Name: insertProductVariant
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới ProductVariant và khởi tạo bản ghi Inventory tương ứng.
     */
    public void insertProductVariant(int productId, String sku, String variantName,
                                     java.math.BigDecimal price, int stock) {
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
            stm.setString(7, "active");
            stm.executeUpdate();

            rs = stm.getGeneratedKeys();
            int variantId = -1;
            if (rs.next()) variantId = rs.getInt(1);

            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, reserved_quantity, available_quantity) VALUES (?, ?, ?)";
                PreparedStatement stmInv = connection.prepareStatement(sqlInv);
                stmInv.setInt(1, variantId);
                stmInv.setInt(2, 0);
                stmInv.setInt(3, stock);
                stmInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("insertProductVariant Error: " + e.getMessage());
        }
    }

    /*
     * Name: hideProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Ẩn (xóa mềm) biến thể bằng cách set status = 'inactive'.
     */
    public void hideProduct(int variant_id) {
        try {
            String sql = "UPDATE ProductVariant SET status = 'inactive' WHERE variant_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, variant_id);
            stm.executeUpdate();
        } catch (Exception e) {
            System.out.println("hideProduct Error: " + e.getMessage());
        }
    }

    /*
     * Name: unhideProduct
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Khôi phục biến thể đã ẩn bằng cách set status = 'active'.
     */
    public void unhideProduct(int variant_id) {
        try {
            String sql = "UPDATE ProductVariant SET status = 'active' WHERE variant_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, variant_id);
            stm.executeUpdate();
        } catch (Exception e) {
            System.out.println("unhideProduct Error: " + e.getMessage());
        }
    }

    /*
     * Name: DeleteProduct (hard delete — dùng cẩn thận)
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 3.0
     * Description: Xóa cứng biến thể khỏi DB. Ưu tiên dùng hideProduct() thay thế.
     *              FIX: bản gốc thiếu stm.setInt() nên không bao giờ xóa đúng bản ghi.
     */
    public boolean DeleteProduct(int productVariantId) {
        try {
            String sql = "DELETE FROM ProductVariant WHERE variant_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, productVariantId); // FIX: bản gốc thiếu dòng này
            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) return true;
        } catch (Exception e) {
            System.out.println("DeleteProduct Error: " + e.getMessage());
        }
        return false;
    }

    /*
     * Name: GetAllProductInventory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy toàn bộ danh sách ProductInventory (không phân trang) — dùng cho export.
     */
    public List<ProductInventory> GetAllProductInventory() {
        List<ProductInventory> products = new ArrayList<>();
        try {
            String sql = "SELECT pv.variant_id, p.product_name, pv.sku, pv.variant_name, " +
                         "b.brand_name, c.category_name, pv.selling_price, i.available_quantity, " +
                         "CASE " +
                         "  WHEN i.available_quantity > 5  THEN N'In Stock' " +
                         "  WHEN i.available_quantity > 0  THEN N'Low Stock' " +
                         "  ELSE N'Sold Out' " +
                         "END AS status, p.thumbnail " +
                         "FROM Product p " +
                         "JOIN Category c ON p.category_id = c.category_id " +
                         "JOIN Brand b ON p.brand_id = b.brand_id " +
                         "JOIN ProductVariant pv ON p.product_id = pv.product_id " +
                         "JOIN Inventory i ON pv.variant_id = i.variant_id " +
                         "WHERE pv.status = 'active'";
            stm = connection.prepareStatement(sql);
            rs  = stm.executeQuery();
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
                products.add(p);
            }
        } catch (Exception e) {
            System.out.println("GetAllProductInventory Error: " + e.getMessage());
        }
        return products;
    }
}
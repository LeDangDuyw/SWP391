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
import viewmodel.ProductInventory;
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
            Product p = new Product(rs.getInt("variant_id"),rs.getString("product_name"), rs.getString("description"),rs.getInt("warranty_period"),
                                    rs.getString("thumbnail"), rs.getInt("category_id"), rs.getInt("brand_id"));
            products.add(p);
        }
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return products;
    }
    
    public List<ProductInventory> GetAllProductInventory() {
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
            String sql = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, \n" +
                        "case \n" +
                        "	when i.available_quantity > 0 then N'In Stock'\n" +
                        "	else N'Sold Out'\n" +
                        "end as status, p.thumbnail\n" +
                        "from Product p join Category c on p.category_id = c.category_id\n" +
                        "	join Brand b on p.brand_id = b.brand_id\n" +
                        "	join ProductVariant pv on p.product_id = pv.product_id\n" +
                        "	join Inventory i on pv.variant_id = i.variant_id";
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
    
    public List<ProductInventory> GetProductsByNameAndSort(String search, String sortBy){
        List<ProductInventory> products = new ArrayList<ProductInventory>();
        try{
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
                        "where p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%'\n" +
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
    public int getTotalInventoryCount(String search) {
        int count = 0;
        try {
            String sql = "select count(*) from Product p " +
                         "join Category c on p.category_id = c.category_id " +
                         "join Brand b on p.brand_id = b.brand_id " +
                         "join ProductVariant pv on p.product_id = pv.product_id " +
                         "join Inventory i on pv.variant_id = i.variant_id";
            if (search != null && !search.trim().isEmpty()) {
                sql += " where p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%'";
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

    public List<ProductInventory> GetProductInventoryPaginated(String search, String sortBy, int offset, int fetchSize){
        List<ProductInventory> products = new ArrayList<>();
        try {
            String order = (sortBy != null && sortBy.equals("lowToHigh")) ? "ASC" : "DESC"; 
            String strSQL = "select pv.variant_id, p.product_name, pv.sku,pv.variant_name, b.brand_name, c.category_name,pv.selling_price, i.available_quantity, " +
                        "case " +
                        "	when i.available_quantity > 0 then N'In Stock' " +
                        "	else N'Sold Out' " +
                        "end as status, p.thumbnail " +
                        "from Product p join Category c on p.category_id = c.category_id " +
                        "	join Brand b on p.brand_id = b.brand_id " +
                        "	join ProductVariant pv on p.product_id = pv.product_id " +
                        "	join Inventory i on pv.variant_id = i.variant_id ";
                        
            if (search != null && !search.trim().isEmpty()) {
                strSQL += "where p.product_name like '%' + ? + '%' or c.category_name like '%' + ? + '%' or pv.sku like '%' + ? + '%' ";
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
            if (rs.next()) {
                productId = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Insert Product Error: " + e.getMessage());
        }
        return productId;
    }

    public void insertProductVariant(int productId, String sku, String variantName, java.math.BigDecimal price, int stock) {
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
            if (rs.next()) {
                variantId = rs.getInt(1);
            }
            
            if (variantId != -1) {
                String sqlInv = "INSERT INTO Inventory (variant_id, reserved_quantity, available_quantity) VALUES (?, ?, ?)";
                PreparedStatement stmInv = connection.prepareStatement(sqlInv);
                stmInv.setInt(1, variantId);
                stmInv.setInt(2, 0);
                stmInv.setInt(3, stock);
                stmInv.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Insert ProductVariant Error: " + e.getMessage());
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.ProductCompareDTO;
import java.util.*;


/**
 *
 * @author minhbq
 */
public class ProductCompareDAO extends DBContext {
    private Connection con ; 
    private PreparedStatement ps ;   
    private ResultSet rs;

    public ProductCompareDAO() {
        this.con = super.connection;
    }
    public ProductCompareDTO getProductCompareDatail(int productId){
    ProductCompareDTO p = null ; 
     try{
      String sql = """
                             SELECT 
                                                          v.product_id, v.product_name, v.thumbnail, v.brand_name, v.category_name, v.category_id,
                                                          v.warranty_period, v.description,
                                                          v.cpu, v.ram, v.ssd, v.gpu, v.screen, v.connectivity, v.switch_type, v.dpi,
                                                          v.layout, v.backlight, v.buttons, v.refresh_rate, v.resolution, v.response_time, v.power, v.pin, v.weight, v.color, v.os,
                                                          -- 1. Tính tổng tồn kho khả dụng từ bảng Inventory
                                                          ISNULL(SUM(inv.available_quantity), 0) AS total_stock,
                                                          -- 2. Lấy giá gốc nhỏ nhất trong các biến thể của sản phẩm
                                                          MIN(pv.selling_price) AS original_price,
                                                          -- 3. Lấy giá bán khuyến mãi nhỏ nhất (Ưu tiên Flash Sale -> Campaign -> Giá gốc)
                                                          MIN(ISNULL(fsi.sale_price, ISNULL(
                                                              CASE 
                                                                  WHEN cp.sale_price IS NOT NULL AND cp.sale_price > 0 THEN cp.sale_price
                                                                  WHEN c.campaign_type = 'percentage' THEN pv.selling_price * (100.0 - c.discount_value) / 100.0
                                                                  WHEN c.campaign_type = 'fixed' THEN pv.selling_price - c.discount_value
                                                                  ELSE pv.selling_price
                                                              END, pv.selling_price
                                                          ))) AS min_price
                                                      FROM vw_ProductSpec v
                                                      JOIN ProductVariant pv ON v.product_id = pv.product_id AND pv.status = 'active'
                                                      LEFT JOIN Inventory inv ON pv.variant_id = inv.variant_id
                                                      -- Liên kết Flash Sale đang diễn ra
                                                      LEFT JOIN FlashSaleItem fsi ON pv.variant_id = fsi.variant_id
                                                      LEFT JOIN FlashSale fs ON fsi.flashsale_id = fs.flashsale_id 
                                                          AND GETDATE() >= fs.start_time AND GETDATE() <= fs.end_time
                                                      -- Liên kết Campaign khuyến mãi đang diễn ra
                                                      LEFT JOIN CampaignProduct cp ON pv.variant_id = cp.variant_id
                                                      LEFT JOIN Campaign c ON cp.campaign_id = c.campaign_id 
                                                          AND c.status = 'active' 
                                                          AND GETDATE() >= c.start_date AND GETDATE() <= c.end_date
                                                      WHERE v.product_id = ?
                                                      GROUP BY 
                                                          v.product_id, v.product_name, v.thumbnail, v.brand_name, v.category_name, v.category_id,
                                                          v.warranty_period, v.description,
                                                          v.cpu, v.ram, v.ssd, v.gpu, v.screen, v.connectivity, v.switch_type, v.dpi,
                                                          v.layout, v.backlight, v.buttons, v.refresh_rate, v.resolution, v.response_time, v.power, v.pin, v.weight, v.color, v.os
                         """;
      
      ps = con.prepareStatement(sql);
      ps.setInt(1, productId);
      rs = ps.executeQuery();
      
      if(rs.next()){
        p = new ProductCompareDTO();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setThumbnail(rs.getString("thumbnail"));
                p.setBrandName(rs.getString("brand_name"));
                p.setCategoryName(rs.getString("category_name"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setWarrantyPeriod(rs.getInt("warranty_period"));
                p.setDescription(rs.getString("description"));
                p.setTotalStock(rs.getInt("total_stock"));
                
                // Gán các thông số kỹ thuật cấu hình
                p.setCpu(rs.getString("cpu"));
                p.setRam(rs.getString("ram"));
                p.setSsd(rs.getString("ssd"));
                p.setGpu(rs.getString("gpu"));
                p.setScreen(rs.getString("screen"));
                p.setConnectivity(rs.getString("connectivity"));
                p.setSwitchType(rs.getString("switch_type"));
                p.setDpi(rs.getString("dpi"));
                
                p.setLayout(rs.getString("layout"));
                   p.setBacklight(rs.getString("backlight"));
                p.setButtons(rs.getString("buttons"));
                p.setRefreshRate(rs.getString("refresh_rate"));
                p.setResolution(rs.getString("resolution"));
                p.setResponseTime(rs.getString("response_time"));
                p.setPower(rs.getString("power"));
                p.setPin(rs.getString("pin"));
                p.setWeight(rs.getString("weight"));
                p.setColor(rs.getString("color"));
                p.setOs(rs.getString("os"));
                
                long originalPrice = rs.getLong("original_price");
                long minPrice = rs.getLong("min_price");
                int discountPercent = 0 ; 
                if(originalPrice >0){
                discountPercent =(int) Math.round((originalPrice - minPrice) *100 /originalPrice);
                }
                  p.setOriginalPrice(originalPrice);
                p.setMinPrice(minPrice);
                p.setDiscountPercent(discountPercent);
      }
     }catch(Exception e){
         System.out.println("getProductCompareDetail: "+ e.getMessage());
     }
     return p ; 
    }
    
    public List<ProductCompareDTO> getSuggestProductforCompare(List<Integer> compareList , int limit){
     List<ProductCompareDTO> suggestList = new ArrayList<>();
     if(compareList == null || compareList.isEmpty()){
     return suggestList ; 
     
     }
     
     int baseProductId = compareList.get(0);
     
     if(limit <=0){
     limit = 6 ;
     }
     if(limit >10){
     limit = 10 ; 
     }
     StringBuilder notInPlaceholders = new StringBuilder();
     
     for(int i = 0  ; i< compareList.size() ; i++){
     if(i > 0 ){
     notInPlaceholders.append(", ");
     }
     notInPlaceholders.append("?");
     
     }
     
     int sqlLimit = limit + compareList.size() +5;
 String sql = """
 WITH TargetProduct AS (
 SELECT 
product_id,
 category_id,
 min_price
 FROM vw_ProductSpec
 WHERE product_id = ?
 )
 SELECT TOP (?)
 v.product_id,
 v.product_name,
 v.thumbnail,
 v.brand_name,
 v.category_name,
 v.category_id,
 v.min_price,

 ISNULL(
 (
 SELECT MIN(pv2.selling_price)
 FROM ProductVariant pv2
 WHERE pv2.product_id = v.product_id
 AND pv2.status = 'active'
 ),
 v.min_price
 ) AS original_price,

 (
 SELECT ISNULL(SUM(inv.available_quantity), 0)
 FROM ProductVariant pv3
 LEFT JOIN Inventory inv 
ON pv3.variant_id = inv.variant_id
 WHERE pv3.product_id = v.product_id
 AND pv3.status = 'active'
 ) AS total_stock,

 v.cpu,
 v.ram,
 v.ssd,
 v.gpu,
 v.screen,
 v.connectivity,
 v.switch_type,
 v.dpi,

 0 AS warranty_period,
 v.purpose AS description

 FROM vw_ProductSpec v
 JOIN TargetProduct t
 ON v.category_id = t.category_id

 WHERE v.product_id <> t.product_id
 AND v.min_price IS NOT NULL
 AND t.min_price IS NOT NULL
 AND v.min_price BETWEEN t.min_price * 0.85 AND t.min_price * 1.15

 ORDER BY 
ABS(v.min_price - t.min_price) ASC,
 v.sold_quantity DESC
 """ ;
 try {
 PreparedStatement ps = con.prepareStatement(sql);
 
 ps.setInt(1, baseProductId);
 ps.setInt(2, sqlLimit);
 ResultSet rs = ps.executeQuery();
 
 while(rs.next()){
 int productID = rs.getInt("product_id");
 if(compareList.contains(productID)){
 continue;
 }
 ProductCompareDTO p = new ProductCompareDTO();
 p.setProductId(productID);
 p.setProductName(rs.getString("product_name"));
 p.setThumbnail(rs.getString("thumbnail"));
 p.setBrandName(rs.getString("brand_name"));
 p.setCategoryName(rs.getString("category_name"));
 p.setCategoryId(rs.getInt("category_id"));

 long originalPrice = rs.getLong("original_price");
 long minPrice = rs.getLong("min_price");

 int discountPercent = 0;
 if (originalPrice > 0 && minPrice > 0 && minPrice < originalPrice) {
 discountPercent = (int) Math.round((originalPrice - minPrice) * 100.0 / originalPrice);
 }

 p.setOriginalPrice(originalPrice);
 p.setMinPrice(minPrice);
 p.setDiscountPercent(discountPercent);

 p.setTotalStock(rs.getInt("total_stock"));
 p.setWarrantyPeriod(rs.getInt("warranty_period"));
 p.setDescription(rs.getString("description"));

 p.setCpu(rs.getString("cpu"));
 p.setRam(rs.getString("ram"));
 p.setSsd(rs.getString("ssd"));
 p.setGpu(rs.getString("gpu"));
 p.setScreen(rs.getString("screen"));
 p.setConnectivity(rs.getString("connectivity"));
 p.setSwitchType(rs.getString("switch_type"));
 p.setDpi(rs.getString("dpi"));

 suggestList.add(p);

 if (suggestList.size() >= limit) {
 break;
 }
 }

 } catch (Exception e) {
 System.out.println("getSuggestedProductsForCompare: " + e.getMessage());
 }

 return suggestList;
}
}
 
 

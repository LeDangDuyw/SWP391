/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import Dao.DBContext;
import java.sql.Connection;
import Model.FlashSaleProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
/**
 *
 * @author Cao Tuấn Minh
 */
public class FlashSaleProductDao extends DBContext {

    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public FlashSaleProductDao() {
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
    // Lấy các sp FlashSale

    public ArrayList<FlashSaleProduct> getAllFlashSaleProduct() {
        ArrayList<FlashSaleProduct> data = new ArrayList<>();
        try {
            String sql = """
                     SELECT
                         p.product_id,
                         p.product_name,
                         p.thumbnail,
                         pv.selling_price,
                         fsi.sale_price,
                         fsi.quantity_limit,
                         fsi.sold_quantity,
                         fs.end_time,
                         CAST(
                             ROUND(
                                 (pv.selling_price - fsi.sale_price)
                                 * 100.0 / pv.selling_price,
                                 0
                             ) AS INT
                         ) AS discount_percent
                     FROM FlashSaleItem fsi
                     JOIN FlashSale fs
                         ON fsi.flashsale_id = fs.flashsale_id
                     JOIN ProductVariant pv
                         ON fsi.variant_id = pv.variant_id
                     JOIN Product p
                         ON pv.product_id = p.product_id
                     WHERE GETDATE() >= fs.start_time
                     AND GETDATE() <= fs.end_time
                     ORDER BY fs.end_time ASC;
                     """;

            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                FlashSaleProduct fl = new FlashSaleProduct();
                fl.setProductId(rs.getInt(1));
                fl.setProductName(rs.getString(2));
                fl.setThumbnail(rs.getString(3));
                fl.setOriginalPrice(rs.getLong(4));
                fl.setSalePrice(rs.getLong(5));
                fl.setQuantityLimit(rs.getInt(6));
                fl.setSoldQuantity(rs.getInt(7));
                fl.setEndTime(rs.getTimestamp(8));
                fl.setDiscountPercent(rs.getInt(9));
                
                data.add(fl);
            }
        } catch (Exception e) {
            System.out.println("getAllProducts: " + e.getMessage());
        }
        return data;
    }
}

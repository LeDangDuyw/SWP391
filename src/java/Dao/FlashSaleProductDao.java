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

/**
 *
 * @author ASUS
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
                     	CAST(
                         ROUND(
                             (pv.selling_price - fsi.sale_price)
                             * 100.0 / pv.selling_price,
                             0
                         ) AS INT
                     ) AS discount_percent
                     
                     FROM FlashSaleItem fsi
                     JOIN ProductVariant pv
                         ON fsi.variant_id = pv.variant_id
                     JOIN Product p
                         ON pv.product_id = p.product_id
                     """;

            ps = cnn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                while (rs.next()) {

                    FlashSaleProduct fl = new FlashSaleProduct();
                    fl.setProductId(rs.getInt(1));
                    fl.setProductName(rs.getString(2));
                    fl.setThumbnail(rs.getString(3));
                    fl.setOriginalPrice(rs.getDouble(4));
                    fl.setSalePrice(rs.getDouble(5));
                    fl.setQuantityLimit(rs.getInt(6));
                    fl.setSoldQuantity(rs.getInt(7));
                    fl.setDiscountPercent(rs.getInt(8));
                    data.add(fl);
                }
            }
        } catch (Exception e) {
            System.out.println("getAllProducts: " + e.getMessage());
        }
        return data;
    }
}

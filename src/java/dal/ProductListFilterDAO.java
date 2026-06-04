package dal;

import java.sql.*;
import java.util.ArrayList;
import model.Product;

public class ProductListFilterDAO extends DBContext {

    Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public ProductListFilterDAO() {
        cnn = super.connection;
    }

    // lọc giá laptop 
    private String getLaptopPriceCondition(String price) {
        if (price == null) {
            return "";
        }
        return switch (price) {
            case "under15" ->
                " AND min_price < 15000000";
            case "15to20" ->
                " AND min_price BETWEEN 15000000 AND 20000000";
            case "20to30" ->
                " AND min_price BETWEEN 20000000 AND 30000000";
            case "30to40" ->
                " AND min_price BETWEEN 30000000 AND 40000000";
            case "over40" ->
                " AND min_price > 40000000";
            default ->
                "";
        };
    }

    // lọc giá chuột & bàn phím 
    private String getAccessoryPriceCondition(String price) {
        if (price == null) {
            return "";
        }
        return switch (price) {
            case "under500k" ->
                " AND min_price < 500000";
            case "500kto1m" ->
                " AND min_price BETWEEN 500000 AND 1000000";
            case "1mto2m" ->
                " AND min_price BETWEEN 1000000 AND 2000000";
            case "2mto3m" ->
                " AND min_price BETWEEN 2000000 AND 3000000";
            case "over3m" ->
                " AND min_price > 3000000";
            default ->
                "";
        };
    }

    // Hàm sắp xếp sản phẩm 
    private String getSortClause(String sort) {
        if (sort == null) {
            return " ORDER BY product_id DESC";
        }
        return switch (sort) {
            case "price_asc" ->
                " ORDER BY min_price ASC";
            case "price_desc" ->
                " ORDER BY min_price DESC";
            case "popular" ->
                " ORDER BY sold_quantity DESC";
            case "new" ->
                " ORDER BY product_id DESC";
            default ->
                " ORDER BY product_id DESC";
        };
    }

    // ─── HELPER: map ResultSet → Product ─────────────────────────────────────
    private void mapBase(Product p, ResultSet rs) throws SQLException {
        p.setProductId(rs.getInt("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setThumbnail(rs.getString("thumbnail"));
        p.setBrandId(rs.getInt("brand_id"));
        p.setBrandName(rs.getString("brand_name"));
        p.setCategoryName(rs.getString("category_name"));
        p.setPurpose(rs.getString("purpose"));
        p.setMinPrice(rs.getLong("min_price"));
    }
// 

    public ArrayList<Product.Laptop> filterLaptop(
            Integer brandId, Integer seriesId, String purpose,
            String cpu, String ram, String ssd, String gpu, String screen,
            String price, String sort, int page, int pageSize, String search) {

        ArrayList<Product.Laptop> data = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM vw_ProductSpec WHERE category_id = 1"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (seriesId != null) {
                sql.append(" AND series_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (cpu != null && !cpu.isEmpty()) {
                sql.append(" AND cpu LIKE ?");
            }
            if (ram != null && !ram.isEmpty()) {
                sql.append(" AND ram LIKE ?");
            }
            if (ssd != null && !ssd.isEmpty()) {
                sql.append(" AND ssd LIKE ?");
            }
            if (gpu != null && !gpu.isEmpty()) {
                sql.append(" AND gpu LIKE ?");
            }
            if (screen != null && !screen.isEmpty()) {
                sql.append(" AND screen LIKE ?");
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getLaptopPriceCondition(price));
            sql.append(getSortClause(sort));
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (seriesId != null) {
                ps.setInt(i++, seriesId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (cpu != null && !cpu.isEmpty()) {
                ps.setString(i++, "%" + cpu + "%");
            }
            if (ram != null && !ram.isEmpty()) {
                ps.setString(i++, "%" + ram + "%");
            }
            if (ssd != null && !ssd.isEmpty()) {
                ps.setString(i++, "%" + ssd + "%");
            }
            if (gpu != null && !gpu.isEmpty()) {
                ps.setString(i++, "%" + gpu + "%");
            }
            if (screen != null && !screen.isEmpty()) {
                ps.setString(i++, "%" + screen + "%");
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }
            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i++, pageSize);

            rs = ps.executeQuery();
            while (rs.next()) {
                Product.Laptop l = new Product.Laptop();
                mapBase(l, rs);
                l.setSeriesId(rs.getInt("series_id"));
                l.setSeriesName(rs.getString("series_name"));
                l.setCpu(rs.getString("cpu"));
                l.setRam(rs.getString("ram"));
                l.setSsd(rs.getString("ssd"));
                l.setGpu(rs.getString("gpu"));
                l.setScreen(rs.getString("screen"));
                data.add(l);
            }
        } catch (Exception e) {
            System.out.println("filterLaptop: " + e.getMessage());
        }
        return data;
    }

    public int countFilteredLaptop(
            Integer brandId, Integer seriesId, String purpose,
            String cpu, String ram, String ssd, String gpu, String screen,
            String price, String search) {
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT COUNT(*) FROM vw_ProductSpec WHERE category_id = 1"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (seriesId != null) {
                sql.append(" AND series_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (cpu != null && !cpu.isEmpty()) {
                sql.append(" AND cpu LIKE ?");
            }
            if (ram != null && !ram.isEmpty()) {
                sql.append(" AND ram LIKE ?");
            }
            if (ssd != null && !ssd.isEmpty()) {
                sql.append(" AND ssd LIKE ?");
            }
            if (gpu != null && !gpu.isEmpty()) {
                sql.append(" AND gpu LIKE ?");
            }
            if (screen != null && !screen.isEmpty()) {
                sql.append(" AND screen LIKE ?");
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getLaptopPriceCondition(price));

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (seriesId != null) {
                ps.setInt(i++, seriesId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (cpu != null && !cpu.isEmpty()) {
                ps.setString(i++, "%" + cpu + "%");
            }
            if (ram != null && !ram.isEmpty()) {
                ps.setString(i++, "%" + ram + "%");
            }
            if (ssd != null && !ssd.isEmpty()) {
                ps.setString(i++, "%" + ssd + "%");
            }
            if (gpu != null && !gpu.isEmpty()) {
                ps.setString(i++, "%" + gpu + "%");
            }
            if (screen != null && !screen.isEmpty()) {
                ps.setString(i++, "%" + screen + "%");
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countFilteredLaptop: " + e.getMessage());
        }
        return 0;
    }
    // chuột 
    
    public ArrayList<Product.Mouse> filterMouse(
            Integer brandId, String purpose, String connectivity, String dpi,
            String price, String sort, int page, int pageSize, String search) {

        ArrayList<Product.Mouse> data = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM vw_ProductSpec WHERE category_id = 4"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (connectivity.equalsIgnoreCase("wired")) {
                    sql.append(" AND (connectivity LIKE '%Có dây%' OR connectivity LIKE '%USB-A%' OR connectivity LIKE '%USB-C%' OR connectivity LIKE '%USB%')");
                } else if (connectivity.equalsIgnoreCase("wireless")) {
                    sql.append(" AND (connectivity LIKE '%Wireless%' OR connectivity LIKE '%Bluetooth%' OR connectivity LIKE '%2.4GHz%' OR connectivity LIKE '%Lightspeed%' OR connectivity LIKE '%Bolt%' OR connectivity LIKE '%HyperSpeed%' OR connectivity LIKE '%SLIPSTREAM%')");
                } else {
                    sql.append(" AND connectivity LIKE ?");
                }
            }
            if (dpi != null && !dpi.isEmpty()) {
                if (dpi.equalsIgnoreCase("under10k")) {
                    sql.append(" AND (dpi LIKE '%8,000%' OR dpi LIKE '%8,200%')");
                } else if (dpi.equalsIgnoreCase("10kto20k")) {
                    sql.append(" AND (dpi LIKE '%12,000%' OR dpi LIKE '%18,000%')");
                } else if (dpi.equalsIgnoreCase("over20k")) {
                    sql.append(" AND (dpi LIKE '%25,600%' OR dpi LIKE '%26,000%' OR dpi LIKE '%30,000%' OR dpi LIKE '%32,000%' OR dpi LIKE '%35,000%')");
                } else {
                    sql.append(" AND dpi LIKE ?");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));
            sql.append(getSortClause(sort));
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (!connectivity.equalsIgnoreCase("wired") && !connectivity.equalsIgnoreCase("wireless")) {
                    ps.setString(i++, "%" + connectivity + "%");
                }
            }
            if (dpi != null && !dpi.isEmpty()) {
                if (!dpi.equalsIgnoreCase("under10k") && !dpi.equalsIgnoreCase("10kto20k") && !dpi.equalsIgnoreCase("over20k")) {
                    ps.setString(i++, "%" + dpi + "%");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }
            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i++, pageSize);

            rs = ps.executeQuery();
            while (rs.next()) {
                Product.Mouse m = new Product.Mouse();
                mapBase(m, rs);
                m.setConnectivity(rs.getString("connectivity"));
                m.setDpi(rs.getString("dpi"));
                data.add(m);
            }
        } catch (Exception e) {
            System.out.println("filterMouse: " + e.getMessage());
        }
        return data;
    }

    public int countFilteredMouse(
            Integer brandId, String purpose, String connectivity, String dpi,
            String price, String search) {
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT COUNT(*) FROM vw_ProductSpec WHERE category_id = 4"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (connectivity.equalsIgnoreCase("wired")) {
                    sql.append(" AND (connectivity LIKE '%Có dây%' OR connectivity LIKE '%USB-A%' OR connectivity LIKE '%USB-C%' OR connectivity LIKE '%USB%')");
                } else if (connectivity.equalsIgnoreCase("wireless")) {
                    sql.append(" AND (connectivity LIKE '%Wireless%' OR connectivity LIKE '%Bluetooth%' OR connectivity LIKE '%2.4GHz%' OR connectivity LIKE '%Lightspeed%' OR connectivity LIKE '%Bolt%' OR connectivity LIKE '%HyperSpeed%' OR connectivity LIKE '%SLIPSTREAM%')");
                } else {
                    sql.append(" AND connectivity LIKE ?");
                }
            }
            if (dpi != null && !dpi.isEmpty()) {
                if (dpi.equalsIgnoreCase("under10k")) {
                    sql.append(" AND (dpi LIKE '%8,000%' OR dpi LIKE '%8,200%')");
                } else if (dpi.equalsIgnoreCase("10kto20k")) {
                    sql.append(" AND (dpi LIKE '%12,000%' OR dpi LIKE '%18,000%')");
                } else if (dpi.equalsIgnoreCase("over20k")) {
                    sql.append(" AND (dpi LIKE '%25,600%' OR dpi LIKE '%26,000%' OR dpi LIKE '%30,000%' OR dpi LIKE '%32,000%' OR dpi LIKE '%35,000%')");
                } else {
                    sql.append(" AND dpi LIKE ?");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (!connectivity.equalsIgnoreCase("wired") && !connectivity.equalsIgnoreCase("wireless")) {
                    ps.setString(i++, "%" + connectivity + "%");
                }
            }
            if (dpi != null && !dpi.isEmpty()) {
                if (!dpi.equalsIgnoreCase("under10k") && !dpi.equalsIgnoreCase("10kto20k") && !dpi.equalsIgnoreCase("over20k")) {
                    ps.setString(i++, "%" + dpi + "%");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countFilteredMouse: " + e.getMessage());
        }
        return 0;
    }
    
    // Bàn phím 
    public ArrayList<Product.Keyboard> filterKeyboard(
            Integer brandId, String purpose, String connectivity, String switchType,
            String price, String sort, int page, int pageSize, String search) {

        ArrayList<Product.Keyboard> data = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM vw_ProductSpec WHERE category_id = 3"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (connectivity.equalsIgnoreCase("wired")) {
                    sql.append(" AND (connectivity LIKE '%Có dây%' OR connectivity LIKE '%USB-A%' OR connectivity LIKE '%USB-C%' OR connectivity LIKE '%USB%')");
                } else if (connectivity.equalsIgnoreCase("wireless")) {
                    sql.append(" AND (connectivity LIKE '%Wireless%' OR connectivity LIKE '%Bluetooth%' OR connectivity LIKE '%2.4GHz%' OR connectivity LIKE '%Lightspeed%' OR connectivity LIKE '%Bolt%' OR connectivity LIKE '%HyperSpeed%' OR connectivity LIKE '%SLIPSTREAM%')");
                } else {
                    sql.append(" AND connectivity LIKE ?");
                }
            }
            if (switchType != null && !switchType.isEmpty()) {
                if (switchType.equalsIgnoreCase("clicky")) {
                    sql.append(" AND (switch_type LIKE '%Clicky%' OR switch_type LIKE '%Blue%')");
                } else if (switchType.equalsIgnoreCase("tactile")) {
                    sql.append(" AND (switch_type LIKE '%Tactile%' OR switch_type LIKE '%Brown%' OR switch_type LIKE '%Pink%')");
                } else if (switchType.equalsIgnoreCase("linear")) {
                    sql.append(" AND (switch_type LIKE '%Linear%' OR switch_type LIKE '%Red%' OR switch_type LIKE '%Yellow%')");
                } else {
                    sql.append(" AND switch_type LIKE ?");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));
            sql.append(getSortClause(sort));
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (!connectivity.equalsIgnoreCase("wired") && !connectivity.equalsIgnoreCase("wireless")) {
                    ps.setString(i++, "%" + connectivity + "%");
                }
            }
            if (switchType != null && !switchType.isEmpty()) {
                if (!switchType.equalsIgnoreCase("clicky") && !switchType.equalsIgnoreCase("tactile") && !switchType.equalsIgnoreCase("linear")) {
                    ps.setString(i++, "%" + switchType + "%");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }
            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i++, pageSize);

            rs = ps.executeQuery();
            while (rs.next()) {
                Product.Keyboard k = new Product.Keyboard();
                mapBase(k, rs);
                k.setConnectivity(rs.getString("connectivity"));
                k.setSwitchType(rs.getString("switch_type"));
                data.add(k);
            }
        } catch (Exception e) {
            System.out.println("filterKeyboard: " + e.getMessage());
        }
        return data;
    }

    public int countFilteredKeyboard(
            Integer brandId, String purpose, String connectivity, String switchType,
            String price, String search) {
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT COUNT(*) FROM vw_ProductSpec WHERE category_id = 3"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (purpose != null && !purpose.isEmpty()) {
                sql.append(" AND purpose = ?");
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (connectivity.equalsIgnoreCase("wired")) {
                    sql.append(" AND (connectivity LIKE '%Có dây%' OR connectivity LIKE '%USB-A%' OR connectivity LIKE '%USB-C%' OR connectivity LIKE '%USB%')");
                } else if (connectivity.equalsIgnoreCase("wireless")) {
                    sql.append(" AND (connectivity LIKE '%Wireless%' OR connectivity LIKE '%Bluetooth%' OR connectivity LIKE '%2.4GHz%' OR connectivity LIKE '%Lightspeed%' OR connectivity LIKE '%Bolt%' OR connectivity LIKE '%HyperSpeed%' OR connectivity LIKE '%SLIPSTREAM%')");
                } else {
                    sql.append(" AND connectivity LIKE ?");
                }
            }
            if (switchType != null && !switchType.isEmpty()) {
                if (switchType.equalsIgnoreCase("clicky")) {
                    sql.append(" AND (switch_type LIKE '%Clicky%' OR switch_type LIKE '%Blue%')");
                } else if (switchType.equalsIgnoreCase("tactile")) {
                    sql.append(" AND (switch_type LIKE '%Tactile%' OR switch_type LIKE '%Brown%' OR switch_type LIKE '%Pink%')");
                } else if (switchType.equalsIgnoreCase("linear")) {
                    sql.append(" AND (switch_type LIKE '%Linear%' OR switch_type LIKE '%Red%' OR switch_type LIKE '%Yellow%')");
                } else {
                    sql.append(" AND switch_type LIKE ?");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (purpose != null && !purpose.isEmpty()) {
                ps.setString(i++, purpose);
            }
            if (connectivity != null && !connectivity.isEmpty()) {
                if (!connectivity.equalsIgnoreCase("wired") && !connectivity.equalsIgnoreCase("wireless")) {
                    ps.setString(i++, "%" + connectivity + "%");
                }
            }
            if (switchType != null && !switchType.isEmpty()) {
                if (!switchType.equalsIgnoreCase("clicky") && !switchType.equalsIgnoreCase("tactile") && !switchType.equalsIgnoreCase("linear")) {
                    ps.setString(i++, "%" + switchType + "%");
                }
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countFilteredKeyboard: " + e.getMessage());
        }
        return 0;
    }

    // Lọc sản phẩm cho danh mục phụ kiện chung (Category 2, 5, 6, 7)
    public ArrayList<Product> filterGeneral(int categoryId, Integer brandId,
            String price, String sort, int page, int pageSize, String search) {
        ArrayList<Product> data = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT * FROM vw_ProductSpec WHERE category_id = ?"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));
            sql.append(getSortClause(sort));
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            ps.setInt(i++, categoryId);
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }
            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i++, pageSize);

            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                mapBase(p, rs);
                data.add(p);
            }
        } catch (Exception e) {
            System.out.println("filterGeneral: " + e.getMessage());
        }
        return data;
    }

    // Đếm sản phẩm cho danh mục phụ kiện chung
    public int countFilteredGeneral(int categoryId, Integer brandId, String price, String search) {
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT COUNT(*) FROM vw_ProductSpec WHERE category_id = ?"
            );

            if (brandId != null) {
                sql.append(" AND brand_id = ?");
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND product_name LIKE ?");
            }
            sql.append(getAccessoryPriceCondition(price));

            ps = cnn.prepareStatement(sql.toString());
            int i = 1;
            ps.setInt(i++, categoryId);
            if (brandId != null) {
                ps.setInt(i++, brandId);
            }
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search.trim() + "%");
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countFilteredGeneral: " + e.getMessage());
        }
        return 0;
    }

    // Lấy danh sách thông số kỹ thuật duy nhất từ DB
    public ArrayList<String> getDistinctSpecs(int categoryId, String columnName) {
        ArrayList<String> list = new ArrayList<>();
        if (cnn == null) {
            return list;
        }
        // Kiểm tra an toàn cho tên cột để tránh SQL Injection
        if (!columnName.equals("cpu") && !columnName.equals("ram") && !columnName.equals("ssd") 
            && !columnName.equals("gpu") && !columnName.equals("screen") && !columnName.equals("connectivity") 
            && !columnName.equals("switch_type") && !columnName.equals("dpi")) {
            return list;
        }
        
        String sql = "SELECT DISTINCT " + columnName + " FROM vw_ProductSpec WHERE category_id = ? AND " + columnName + " IS NOT NULL AND " + columnName + " <> ''";
        try (PreparedStatement localPs = cnn.prepareStatement(sql)) {
            localPs.setInt(1, categoryId);
            try (ResultSet localRs = localPs.executeQuery()) {
                while (localRs.next()) {
                    list.add(localRs.getString(1));
                }
            }
        } catch (Exception e) {
            System.out.println("getDistinctSpecs (" + columnName + "): " + e.getMessage());
        }
        return list;
    }
}



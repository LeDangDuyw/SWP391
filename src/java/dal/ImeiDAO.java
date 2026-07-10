package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.InventoryItem;

public class ImeiDAO extends DBContext {
    
    public List<InventoryItem> getInventoryItems(String search, String statusFilter, int offset, int fetchSize) {
        List<InventoryItem> items = new ArrayList<>();
        try {
            String sql = "SELECT ii.*, pv.sku, pv.variant_name, p.product_name " +
                         "FROM InventoryItem ii " +
                         "JOIN ProductVariant pv ON ii.variant_id = pv.variant_id " +
                         "JOIN Product p ON pv.product_id = p.product_id " +
                         "WHERE 1=1 ";
            
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (ii.serial_number LIKE ? OR ii.imei LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                sql += " AND ii.status = ? ";
            }
            
            sql += " ORDER BY ii.import_date DESC ";
            sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            PreparedStatement stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search + "%";
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                stm.setString(idx++, statusFilter);
            }
            stm.setInt(idx++, offset);
            stm.setInt(idx++, fetchSize);
            
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InventoryItem item = new InventoryItem();
                item.setItemId(rs.getInt("item_id"));
                item.setSerialNumber(rs.getString("serial_number"));
                item.setImei(rs.getString("imei"));
                item.setBarcode(rs.getString("barcode"));
                item.setStatus(rs.getString("status"));
                item.setImportDate(rs.getString("import_date"));
                
                java.sql.Date soldDateSql = rs.getDate("sold_date");
                if(soldDateSql != null) item.setSoldDate(soldDateSql.toLocalDate());
                
                java.sql.Date warrantyExpiredDateSql = rs.getDate("warranty_expired_date");
                if(warrantyExpiredDateSql != null) item.setWarrantyExpiredDate(warrantyExpiredDateSql.toLocalDate());
                
                item.setNote(rs.getString("note"));
                
                java.sql.Date createdAtSql = rs.getDate("created_at");
                if(createdAtSql != null) item.setCreatedAt(createdAtSql.toLocalDate());
                
                java.sql.Date updatedAtSql = rs.getDate("updated_at");
                if(updatedAtSql != null) item.setUpdatedAt(updatedAtSql.toLocalDate());
                
                item.setSku(rs.getString("sku"));
                item.setVariantName(rs.getString("variant_name"));
                item.setProductName(rs.getString("product_name"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("getInventoryItems Error: " + e.getMessage());
        }
        return items;
    }
    
    public int getTotalInventoryItemsCount(String search, String statusFilter) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) " +
                         "FROM InventoryItem ii " +
                         "JOIN ProductVariant pv ON ii.variant_id = pv.variant_id " +
                         "JOIN Product p ON pv.product_id = p.product_id " +
                         "WHERE 1=1 ";
            
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (ii.serial_number LIKE ? OR ii.imei LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                sql += " AND ii.status = ? ";
            }
            
            PreparedStatement stm = connection.prepareStatement(sql);
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search + "%";
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
                stm.setString(idx++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                stm.setString(idx++, statusFilter);
            }
            
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getTotalInventoryItemsCount Error: " + e.getMessage());
        }
        return count;
    }
    
    public int getCountByStatus(String status) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM InventoryItem WHERE 1=1 ";
            if (status != null && !status.isEmpty()) {
                sql += " AND status = ? ";
            }
            PreparedStatement stm = connection.prepareStatement(sql);
            if (status != null && !status.isEmpty()) {
                stm.setString(1, status);
            }
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getCountByStatus Error: " + e.getMessage());
        }
        return count;
    }
    
    public void insertInventoryItems(List<InventoryItem> items) {
        if (items == null || items.isEmpty()) return;
        try {
            connection.setAutoCommit(false);
            String sql = "INSERT INTO InventoryItem (variant_id, serial_number, imei, barcode, status, import_date, warranty_expired_date, note, ticket_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            for (InventoryItem item : items) {
                stm.setInt(1, item.getVariantId());
                stm.setString(2, item.getSerialNumber());
                stm.setString(3, item.getImei());
                stm.setString(4, item.getBarcode());
                stm.setString(5, item.getStatus());
                
                if (item.getImportDate() != null && !item.getImportDate().isEmpty()) {
                    stm.setString(6, item.getImportDate());
                } else {
                    stm.setNull(6, java.sql.Types.VARCHAR);
                }
                
                if (item.getWarrantyExpiredDate() != null) {
                    stm.setDate(7, java.sql.Date.valueOf(item.getWarrantyExpiredDate()));
                } else {
                    stm.setNull(7, java.sql.Types.DATE);
                }
                
                stm.setString(8, item.getNote());
                
                if (item.getTicketId() > 0) {
                    stm.setInt(9, item.getTicketId());
                } else {
                    stm.setNull(9, java.sql.Types.INTEGER);
                }
                
                stm.addBatch();
            }
            stm.executeBatch();
            connection.commit();
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            System.out.println("insertInventoryItems Error: " + e.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Rollback Error: " + ex.getMessage());
            }
        }
    }
}

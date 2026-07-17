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
                sql += " AND (ii.serial_number LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
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
                sql += " AND (ii.serial_number LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
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
            // Check for duplicates first
            String checkSql = "SELECT COUNT(*) FROM InventoryItem WHERE serial_number = ?";
            PreparedStatement checkStm = connection.prepareStatement(checkSql);
            for (InventoryItem item : items) {
                checkStm.setString(1, item.getSerialNumber());
                ResultSet rs = checkStm.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new RuntimeException("Duplicate Serial Number found: " + item.getSerialNumber());
                }
            }

            connection.setAutoCommit(false);
            
            // 1. Insert individual serialized items
            String sql = "INSERT INTO InventoryItem (variant_id, serial_number, status, import_date, warranty_expired_date, note, ticket_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            for (InventoryItem item : items) {
                stm.setInt(1, item.getVariantId());
                stm.setString(2, item.getSerialNumber());
                stm.setString(3, item.getStatus());
                
                if (item.getImportDate() != null && !item.getImportDate().isEmpty()) {
                    stm.setString(4, item.getImportDate());
                } else {
                    stm.setNull(4, java.sql.Types.VARCHAR);
                }
                
                if (item.getWarrantyExpiredDate() != null) {
                    stm.setDate(5, java.sql.Date.valueOf(item.getWarrantyExpiredDate()));
                } else {
                    stm.setNull(5, java.sql.Types.DATE);
                }
                
                stm.setString(6, item.getNote());
                
                if (item.getTicketId() > 0) {
                    stm.setInt(7, item.getTicketId());
                } else {
                    stm.setNull(7, java.sql.Types.INTEGER);
                }
                
                stm.addBatch();
            }
            stm.executeBatch();
            
            // 2. Update available_quantity in Inventory table
            java.util.Map<Integer, Integer> countMap = new java.util.HashMap<>();
            for (InventoryItem item : items) {
                countMap.put(item.getVariantId(), countMap.getOrDefault(item.getVariantId(), 0) + 1);
            }
            String updateInvSql = "UPDATE [Inventory] SET available_quantity = available_quantity + ? WHERE variant_id = ?";
            try (PreparedStatement psInv = connection.prepareStatement(updateInvSql)) {
                for (java.util.Map.Entry<Integer, Integer> entry : countMap.entrySet()) {
                    psInv.setInt(1, entry.getValue());
                    psInv.setInt(2, entry.getKey());
                    psInv.addBatch();
                }
                psInv.executeBatch();
            }
            
            connection.commit();
        } catch (SQLException e) {
            System.out.println("insertInventoryItems Error: " + e.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Rollback Error: " + ex.getMessage());
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("SetAutoCommit Error: " + ex.getMessage());
            }
        }
    }
}

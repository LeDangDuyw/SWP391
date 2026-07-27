package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.InventoryItem;

/*
 * Name: SerialDAO
 * @Author: HuyDQHE204239
 * Date: [22/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý danh sách mã Serial / IMEI của từng sản phẩm trong kho (luồng Inbound & Product Catalog).
 */
public class SerialDAO extends DBContext {

    /**
     * Truy vấn danh sách sản phẩm theo mã Serial/IMEI kèm phân trang, tìm kiếm và lọc theo trạng thái.
     * 
     * @param search Từ khóa tìm kiếm (theo mã serial, tên sản phẩm hoặc mã SKU)
     * @param statusFilter Bộ lọc trạng thái (ví dụ: Available, Sold, Warranty...)
     * @param offset Vị trí bắt đầu truy vấn
     * @param fetchSize Số lượng bản ghi cần lấy
     * @return Danh sách các đối tượng InventoryItem
     */
    /**
     * Truy vấn danh sách sản phẩm theo mã Serial/IMEI kèm phân trang, tìm kiếm và lọc theo trạng thái.
     * 
     * @param search Từ khóa tìm kiếm (theo mã serial, tên sản phẩm hoặc mã SKU)
     * @param statusFilter Bộ lọc trạng thái (ví dụ: Available, Sold, Warranty...)
     * @param offset Vị trí bắt đầu truy vấn
     * @param fetchSize Số lượng bản ghi cần lấy
     * @return Danh sách các đối tượng InventoryItem
     */
    public List<InventoryItem> getInventoryItems(String search, String statusFilter, int offset, int fetchSize) {
        return getInventoryItems(search, statusFilter, null, null, offset, fetchSize);
    }

    /**
     * Truy vấn danh sách sản phẩm theo mã Serial/IMEI hỗ trợ lọc nâng cao (Danh mục & Hãng).
     * 
     * @param search Từ khóa tìm kiếm
     * @param statusFilter Bộ lọc trạng thái
     * @param categoryId ID Danh mục sản phẩm (nếu có)
     * @param brandId ID Thương hiệu sản phẩm (nếu có)
     * @param offset Vị trí bắt đầu truy vấn
     * @param fetchSize Số lượng bản ghi cần lấy
     * @return Danh sách các đối tượng InventoryItem
     */
    public List<InventoryItem> getInventoryItems(String search, String statusFilter, Integer categoryId, Integer brandId, int offset, int fetchSize) {
        List<InventoryItem> items = new ArrayList<>();
        try {
            String sql = "SELECT ii.*, pv.sku, pv.variant_name, p.product_name " +
                    "FROM InventoryItem ii " +
                    "LEFT JOIN ProductVariant pv ON ii.variant_id = pv.variant_id " +
                    "LEFT JOIN Product p ON pv.product_id = p.product_id " +
                    "WHERE 1=1 ";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (ii.serial_number LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                sql += " AND (ii.status = ? OR LOWER(ii.status) = LOWER(?)) ";
            }
            if (categoryId != null && categoryId > 0) {
                sql += " AND p.category_id = ? ";
            }
            if (brandId != null && brandId > 0) {
                sql += " AND p.brand_id = ? ";
            }

            sql += " ORDER BY ii.import_date DESC ";
            sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                int idx = 1;
                if (search != null && !search.trim().isEmpty()) {
                    String likeSearch = "%" + search.trim() + "%";
                    stm.setString(idx++, likeSearch);
                    stm.setString(idx++, likeSearch);
                    stm.setString(idx++, likeSearch);
                }
                if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                    stm.setString(idx++, statusFilter.trim());
                    stm.setString(idx++, statusFilter.trim());
                }
                if (categoryId != null && categoryId > 0) {
                    stm.setInt(idx++, categoryId);
                }
                if (brandId != null && brandId > 0) {
                    stm.setInt(idx++, brandId);
                }
                stm.setInt(idx++, Math.max(0, offset));
                stm.setInt(idx++, Math.max(1, fetchSize));

                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        InventoryItem item = new InventoryItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setSerialNumber(rs.getString("serial_number"));
                        item.setStatus(rs.getString("status"));
                        String rawDate = rs.getString("import_date");
                        if (rawDate != null && rawDate.length() >= 10) {
                            item.setImportDate(rawDate.substring(0, 10));
                        } else {
                            item.setImportDate(rawDate);
                        }

                        java.sql.Date soldDateSql = rs.getDate("sold_date");
                        if (soldDateSql != null)
                            item.setSoldDate(soldDateSql.toLocalDate());

                        java.sql.Date warrantyExpiredDateSql = rs.getDate("warranty_expired_date");
                        if (warrantyExpiredDateSql != null)
                            item.setWarrantyExpiredDate(warrantyExpiredDateSql.toLocalDate());

                        item.setNote(rs.getString("note"));

                        java.sql.Date createdAtSql = rs.getDate("created_at");
                        if (createdAtSql != null)
                            item.setCreatedAt(createdAtSql.toLocalDate());

                        java.sql.Date updatedAtSql = rs.getDate("updated_at");
                        if (updatedAtSql != null)
                            item.setUpdatedAt(updatedAtSql.toLocalDate());

                        item.setSku(rs.getString("sku"));
                        item.setVariantName(rs.getString("variant_name"));
                        item.setProductName(rs.getString("product_name"));

                        items.add(item);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("getInventoryItems Error: " + e.getMessage());
        }
        return items;
    }

    /**
     * Tính tổng số lượng bản ghi Serial/IMEI thỏa mãn điều kiện tìm kiếm và lọc để phục vụ phân trang.
     * 
     * @param search Từ khóa tìm kiếm
     * @param statusFilter Bộ lọc trạng thái
     * @return Tổng số lượng sản phẩm Serial thỏa mãn
     */
    public int getTotalInventoryItemsCount(String search, String statusFilter) {
        return getTotalInventoryItemsCount(search, statusFilter, null, null);
    }

    /**
     * Tính tổng số lượng bản ghi Serial/IMEI thỏa mãn điều kiện lọc danh mục & hãng.
     * 
     * @param search Từ khóa tìm kiếm
     * @param statusFilter Bộ lọc trạng thái
     * @param categoryId ID Danh mục sản phẩm
     * @param brandId ID Thương hiệu sản phẩm
     * @return Tổng số lượng bản ghi thỏa mãn
     */
    public int getTotalInventoryItemsCount(String search, String statusFilter, Integer categoryId, Integer brandId) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) " +
                    "FROM InventoryItem ii " +
                    "LEFT JOIN ProductVariant pv ON ii.variant_id = pv.variant_id " +
                    "LEFT JOIN Product p ON pv.product_id = p.product_id " +
                    "WHERE 1=1 ";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (ii.serial_number LIKE ? OR p.product_name LIKE ? OR pv.sku LIKE ?) ";
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                sql += " AND (ii.status = ? OR LOWER(ii.status) = LOWER(?)) ";
            }
            if (categoryId != null && categoryId > 0) {
                sql += " AND p.category_id = ? ";
            }
            if (brandId != null && brandId > 0) {
                sql += " AND p.brand_id = ? ";
            }

            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                int idx = 1;
                if (search != null && !search.trim().isEmpty()) {
                    String likeSearch = "%" + search.trim() + "%";
                    stm.setString(idx++, likeSearch);
                    stm.setString(idx++, likeSearch);
                    stm.setString(idx++, likeSearch);
                }
                if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                    stm.setString(idx++, statusFilter.trim());
                    stm.setString(idx++, statusFilter.trim());
                }
                if (categoryId != null && categoryId > 0) {
                    stm.setInt(idx++, categoryId);
                }
                if (brandId != null && brandId > 0) {
                    stm.setInt(idx++, brandId);
                }

                try (ResultSet rs = stm.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("getTotalInventoryItemsCount Error: " + e.getMessage());
        }
        return count;
    }

    /**
     * Đếm số lượng sản phẩm kho theo trạng thái cụ thể (ví dụ: Available, Sold...).
     * 
     * @param status Trạng thái cần đếm
     * @return Số lượng tương ứng
     */
    public int getCountByStatus(String status) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM InventoryItem WHERE 1=1 ";
            if (status != null && !status.trim().isEmpty()) {
                sql += " AND (status = ? OR LOWER(status) = LOWER(?)) ";
            }
            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                if (status != null && !status.trim().isEmpty()) {
                    stm.setString(1, status.trim());
                    stm.setString(2, status.trim());
                }
                try (ResultSet rs = stm.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("getCountByStatus Error: " + e.getMessage());
        }
        return count;
    }

    /**
     * Thêm hàng loạt danh sách mã Serial/IMEI vào CSDL khi nhập kho (Inbound),
     * đồng thời cập nhật tăng số lượng tồn kho khả dụng (available_quantity) tương ứng trong bảng Inventory.
     * 
     * @param items Danh sách các đối tượng InventoryItem cần chèn
     */
    public void insertInventoryItems(List<InventoryItem> items) {
        if (items == null || items.isEmpty())
            return;
        try {
            // ĐOẠN 1: Kiểm tra chống trùng lặp mã Serial/IMEI trong CSDL
            // Nhiệm vụ: Đảm bảo mỗi chiếc máy mang 1 mã Serial duy nhất toàn cầu. Nếu trùng -> Ném ngoại lệ ngắt ngay
            String checkSql = "SELECT COUNT(*) FROM InventoryItem WHERE serial_number = ?";
            try (PreparedStatement checkStm = connection.prepareStatement(checkSql)) {
                for (InventoryItem item : items) {
                    checkStm.setString(1, item.getSerialNumber());
                    try (ResultSet rs = checkStm.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            throw new RuntimeException("Duplicate Serial Number found: " + item.getSerialNumber());
                        }
                    }
                }
            }

            // ĐOẠN 2: Mở Database Transaction
            // Nhiệm vụ: Đảm bảo chèn bảng InventoryItem và cập nhật bảng Inventory diễn ra đồng thời
            connection.setAutoCommit(false);

            // ĐOẠN 3: Chèn danh sách máy mới vào bảng InventoryItem với status = 'in_stock'
            // Nhiệm vụ: Tạo thông tin quản lý vị trí, ngày nhập và trạng thái sẵn sàng bán của từng chiếc máy
            String sql = "INSERT INTO InventoryItem (variant_id, serial_number, status, import_date, warranty_expired_date, note, ticket_id) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                for (InventoryItem item : items) {
                    stm.setInt(1, item.getVariantId());
                    stm.setString(2, item.getSerialNumber());
                    stm.setString(3, item.getStatus()); // 'in_stock'

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
            }

            // ĐOẠN 4: Gom số lượng theo variant_id và CẬP NHẬT TĂNG available_quantity trong bảng Inventory
            // Nhiệm vụ: Tự động cộng số lượng máy có sẵn bán trên Website ngay khi nhập Serial vào kho thành công
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

            // ĐOẠN 5: Commit Transaction ghi nhận hoàn tất nhập kho
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

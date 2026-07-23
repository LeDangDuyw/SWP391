/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/*
 * Name: CategoryDAO
 * @Author: MinhCTHE200700
 * Date: [7/7/2026]
 * Version: 1.0
 * Description: Data Access Object quản lý dữ liệu danh mục sản phẩm (Category)
 */
import java.sql.*;
import java.util.*;
import model.Category;
import dal.DBContext;

public class CategoryDAO extends DBContext{
Connection cnn;
    PreparedStatement ps;
    ResultSet rs;

    public CategoryDAO() {
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

    public ArrayList<Category> getAllCategories() {
    ArrayList<Category> data = new ArrayList<>();
    try {
        String sql = "SELECT category_id,category_name FROM Category";
        ps = cnn.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            Category c = new Category();
            c.setCategoryId(rs.getInt(1));
            c.setCategoryName(rs.getString(2));
            data.add(c);
        }
    } catch (Exception e) {
        System.out.println("getAllCategories: " + e.getMessage());
    }
    return data;
}
    
    // tìm kiếm sản phẩm theo danh mục 
    public Integer getCategoryIdByName(String keyword) {

    String sql = """
        SELECT category_id
        FROM Category
        WHERE LOWER(category_name) LIKE ?
        """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + keyword.toLowerCase() + "%");

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt("category_id");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}

    // --- MỚI THÊM: Quản lý Category ---

    /*
     * Name: insertCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Thêm mới một danh mục (Category) vào cơ sở dữ liệu.
     */
    public void insertCategory(String categoryName) throws Exception {
        String sql = "INSERT INTO Category (category_name) VALUES (?)";
        ps = cnn.prepareStatement(sql);
        ps.setString(1, categoryName);
        ps.executeUpdate();
    }

    /*
     * Name: updateCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Cập nhật tên của một danh mục (Category) dựa trên ID.
     */
    public void updateCategory(int categoryId, String categoryName) throws Exception {
        String sql = "UPDATE Category SET category_name = ? WHERE category_id = ?";
        ps = cnn.prepareStatement(sql);
        ps.setString(1, categoryName);
        ps.setInt(2, categoryId);
        ps.executeUpdate();
    }

    /*
     * Name: deleteCategory
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Xóa cứng một danh mục (Category) khỏi cơ sở dữ liệu dựa trên ID.
     */
    public void deleteCategory(int categoryId) throws Exception {
        String sql = "DELETE FROM Category WHERE category_id = ?";
        ps = cnn.prepareStatement(sql);
        ps.setInt(1, categoryId);
        ps.executeUpdate();
    }

    public int countProductsByCategory(int categoryId) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Product WHERE category_id = ?";
            ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countProductsByCategory: " + e.getMessage());
        }
        return count;
    }

    public boolean isCategoryExist(String categoryName, int excludeId) {
        try {
            String sql = "SELECT COUNT(*) FROM Category WHERE LOWER(category_name) = LOWER(?) AND category_id != ?";
            ps = cnn.prepareStatement(sql);
            ps.setString(1, categoryName.trim());
            ps.setInt(2, excludeId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("isCategoryExist: " + e.getMessage());
        }
        return false;
    }

    /*
     * Name: getCategoriesPaginated
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Lấy danh sách danh mục (Category) có phân trang và hỗ trợ tìm kiếm theo tên.
     */
    public List<Category> getCategoriesPaginated(String search, int offset, int fetchSize) {
        List<Category> categories = new ArrayList<>();
        try {
            String sql = "SELECT category_id, category_name FROM Category ";
            if (search != null && !search.trim().isEmpty()) {
                sql += "WHERE category_name LIKE ? ";
            }
            sql += "ORDER BY category_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            ps = cnn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, fetchSize);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
                categories.add(c);
            }
        } catch (Exception e) {
            System.out.println("getCategoriesPaginated: " + e.getMessage());
        }
        return categories;
    }

    /*
     * Name: getTotalCategoryCount
     * @Author: HUYDQHE204239
     * Date: [04/06/2026]
     * Version: 2.0
     * Description: Đếm tổng số lượng danh mục (Category), có hỗ trợ lọc theo từ khóa tìm kiếm.
     */
    public int getTotalCategoryCount(String search) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Category ";
            if (search != null && !search.trim().isEmpty()) {
                sql += "WHERE category_name LIKE ? ";
            }
            ps = cnn.prepareStatement(sql);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search + "%");
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalCategoryCount: " + e.getMessage());
        }
        return count;
    }

    // =========================================================================
    // SPECIFICATION MANAGEMENT FOR CATEGORIES
    // =========================================================================

    public List<model.CategorySpecification> getSpecificationsByCategoryId(int categoryId) {
        List<model.CategorySpecification> list = new ArrayList<>();
        try {
            // Check if CategorySpecification table exists and has records
            String checkTableSql = "SELECT COUNT(*) FROM sys.tables WHERE name = 'CategorySpecification'";
            PreparedStatement checkPs = cnn.prepareStatement(checkTableSql);
            ResultSet checkRs = checkPs.executeQuery();
            boolean hasTable = checkRs.next() && checkRs.getInt(1) > 0;
            checkRs.close();
            checkPs.close();

            if (hasTable) {
                String sql = "SELECT cs.category_id, cs.specification_id, s.specification_name, cs.display_order " +
                             "FROM CategorySpecification cs " +
                             "JOIN Specification s ON cs.specification_id = s.specification_id " +
                             "WHERE cs.category_id = ? ORDER BY cs.display_order ASC, s.specification_name ASC";
                PreparedStatement psSpec = cnn.prepareStatement(sql);
                psSpec.setInt(1, categoryId);
                ResultSet rsSpec = psSpec.executeQuery();
                while (rsSpec.next()) {
                    list.add(new model.CategorySpecification(
                        rsSpec.getInt("category_id"),
                        rsSpec.getInt("specification_id"),
                        rsSpec.getString("specification_name"),
                        rsSpec.getInt("display_order")
                    ));
                }
                rsSpec.close();
                psSpec.close();
            }

            // Fallback if list is empty or table does not exist yet
            if (list.isEmpty()) {
                list = getDefaultSpecificationsForCategory(categoryId);
            }
        } catch (Exception e) {
            System.out.println("getSpecificationsByCategoryId: " + e.getMessage());
            list = getDefaultSpecificationsForCategory(categoryId);
        }
        return list;
    }

    private List<model.CategorySpecification> getDefaultSpecificationsForCategory(int categoryId) {
        List<model.CategorySpecification> fallback = new ArrayList<>();
        try {
            // Fallback mapping based on Category ID or Name
            List<String> defaultSpecNames = new ArrayList<>();
            if (categoryId == 1) { // Laptop
                defaultSpecNames = Arrays.asList("CPU", "RAM", "Màn hình", "Card đồ họa", "Ổ cứng", "Hệ điều hành", "Pin", "Trọng lượng");
            } else if (categoryId == 2) { // Màn hình
                defaultSpecNames = Arrays.asList("Màn hình", "Tần số quét", "Độ phân giải", "Thời gian phản hồi", "Kiểu kết nối");
            } else if (categoryId == 3) { // Bàn phím
                defaultSpecNames = Arrays.asList("Switch", "Layout", "Backlight", "Kiểu kết nối");
            } else if (categoryId == 4) { // Chuột
                defaultSpecNames = Arrays.asList("DPI", "Số nút", "Tần số quét", "Kiểu kết nối");
            } else {
                defaultSpecNames = Arrays.asList("CPU", "RAM", "Ổ cứng", "Kiểu kết nối", "Trọng lượng");
            }

            int order = 1;
            for (String specName : defaultSpecNames) {
                String sql = "SELECT specification_id, specification_name FROM Specification WHERE specification_name = ?";
                PreparedStatement ps = cnn.prepareStatement(sql);
                ps.setString(1, specName);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    fallback.add(new model.CategorySpecification(categoryId, rs.getInt("specification_id"), rs.getString("specification_name"), order++));
                }
                rs.close();
                ps.close();
            }
        } catch (Exception e) {
            System.out.println("getDefaultSpecificationsForCategory: " + e.getMessage());
        }
        return fallback;
    }

    public List<model.Specification> getAllMasterSpecifications() {
        List<model.Specification> list = new ArrayList<>();
        try {
            String sql = "SELECT specification_id, specification_name FROM Specification ORDER BY specification_name ASC";
            PreparedStatement ps = cnn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new model.Specification(rs.getInt(1), rs.getString(2)));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println("getAllMasterSpecifications: " + e.getMessage());
        }
        return list;
    }

    public int addMasterSpecification(String specName) {
        try {
            String checkSql = "SELECT specification_id FROM Specification WHERE specification_name = ?";
            PreparedStatement psCheck = cnn.prepareStatement(checkSql);
            psCheck.setString(1, specName.trim());
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next()) {
                int id = rsCheck.getInt(1);
                rsCheck.close();
                psCheck.close();
                return id;
            }
            rsCheck.close();
            psCheck.close();

            String insertSql = "INSERT INTO Specification (specification_name) VALUES (?)";
            PreparedStatement psIns = cnn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            psIns.setString(1, specName.trim());
            psIns.executeUpdate();
            ResultSet rsKeys = psIns.getGeneratedKeys();
            if (rsKeys.next()) {
                int newId = rsKeys.getInt(1);
                rsKeys.close();
                psIns.close();
                return newId;
            }
            rsKeys.close();
            psIns.close();
        } catch (Exception e) {
            System.out.println("addMasterSpecification: " + e.getMessage());
        }
        return -1;
    }

    public boolean addSpecificationToCategory(int categoryId, int specificationId) {
        try {
            // Ensure CategorySpecification table exists
            String createTableSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CategorySpecification') " +
                                    "CREATE TABLE CategorySpecification (category_id INT NOT NULL, specification_id INT NOT NULL, display_order INT DEFAULT 0 PRIMARY KEY(category_id, specification_id))";
            PreparedStatement psCreate = cnn.prepareStatement(createTableSql);
            psCreate.executeUpdate();
            psCreate.close();

            String sql = "IF NOT EXISTS (SELECT 1 FROM CategorySpecification WHERE category_id = ? AND specification_id = ?) " +
                         "INSERT INTO CategorySpecification (category_id, specification_id, display_order) VALUES (?, ?, 0)";
            PreparedStatement ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, specificationId);
            ps.setInt(3, categoryId);
            ps.setInt(4, specificationId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("addSpecificationToCategory: " + e.getMessage());
        }
        return false;
    }

    public boolean removeSpecificationFromCategory(int categoryId, int specificationId) {
        try {
            String sql = "DELETE FROM CategorySpecification WHERE category_id = ? AND specification_id = ?";
            PreparedStatement ps = cnn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, specificationId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("removeSpecificationFromCategory: " + e.getMessage());
        }
        return false;
    }
}

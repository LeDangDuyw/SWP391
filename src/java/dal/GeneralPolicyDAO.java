package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.GeneralPolicy;

/**
 * Class: GeneralPolicyDAO
 * Description: Data Access Object (DAO) chuyên trách quản lý các chính sách chung (General Policy - Privacy, Terms, Shopping Guide, About) và các bài viết Tin tức / Khuyến mãi (News & Articles).
 * 
 * Created: 2026-06-01
 * Updated: 2026-07-23
 * Version: v1.8
 *
 * @author DuyLD
 */
public class GeneralPolicyDAO extends DBContext {

    
    /**
     * Lấy thông tin bài viết chính sách chung đang hoạt động theo loại (PRIVACY, TERMS, SHOPPING_GUIDE, ABOUT...).
     *
     * @param type Loại chính sách cần lấy
     * @return Đối tượng GeneralPolicy hoặc null nếu không tìm thấy
     */
    public GeneralPolicy getPolicyByType(String type) {
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order "
                   + "FROM Policy WHERE policy_type = ? AND status = 1";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    GeneralPolicy p = new GeneralPolicy();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setTitle(rs.getString("title"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    p.setShowInFooter(rs.getBoolean("show_in_footer"));
                    p.setFooterOrder(rs.getInt("footer_order"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách toàn bộ các bài viết chính sách footer.
     */
    public List<GeneralPolicy> getFooterDocPolicies() {
        return getFooterDocPolicies(null);
    }

    /**
     * Lấy danh sách các bài viết chính sách footer có hỗ trợ lọc theo từ khóa tìm kiếm.
     *
     * @param keyword Từ khóa tìm kiếm theo tiêu đề (có thể null)
     * @return Danh sách các bài viết chính sách footer
     */
    public List<GeneralPolicy> getFooterDocPolicies(String keyword) {
        List<GeneralPolicy> list = new ArrayList<>();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order "
                   + "FROM Policy WHERE policy_type NOT IN ('PROMOTION', 'PROMO', 'NEW_PRODUCT', 'NEWPROD', 'NEWS') "
                   + (hasKeyword ? "AND title LIKE ? " : "")
                   + "ORDER BY footer_order ASC, policy_id ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasKeyword) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GeneralPolicy p = new GeneralPolicy();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setTitle(rs.getString("title"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    p.setShowInFooter(rs.getBoolean("show_in_footer"));
                    p.setFooterOrder(rs.getInt("footer_order"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy toàn bộ danh sách các bài viết Tin tức / Khuyến mãi.
     */
    public List<GeneralPolicy> getNewsArticles() {
        return getNewsArticles(null);
    }

    /**
     * Lấy danh sách các bài viết Tin tức / Khuyến mãi có hỗ trợ lọc theo từ khóa tiêu đề.
     *
     * @param keyword Từ khóa tìm kiếm (có thể null)
     * @return Danh sách bài viết tin tức
     */
    public List<GeneralPolicy> getNewsArticles(String keyword) {
        List<GeneralPolicy> list = new ArrayList<>();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order "
                   + "FROM Policy WHERE policy_type IN ('PROMOTION', 'PROMO', 'NEW_PRODUCT', 'NEWPROD', 'NEWS') "
                   + (hasKeyword ? "AND title LIKE ? " : "")
                   + "ORDER BY created_at DESC, policy_id DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasKeyword) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GeneralPolicy p = new GeneralPolicy();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setTitle(rs.getString("title"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    p.setShowInFooter(rs.getBoolean("show_in_footer"));
                    p.setFooterOrder(rs.getInt("footer_order"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Truy xuất thông tin một bài viết chính sách chung theo ID.
     *
     * @param id Mã ID của chính sách
     * @return Đối tượng GeneralPolicy
     */
    public GeneralPolicy getPolicyById(int id) {
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order "
                   + "FROM Policy WHERE policy_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    GeneralPolicy p = new GeneralPolicy();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setTitle(rs.getString("title"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    p.setShowInFooter(rs.getBoolean("show_in_footer"));
                    p.setFooterOrder(rs.getInt("footer_order"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách các liên kết chính sách hiển thị ở Footer của trang web.
     */
    public List<GeneralPolicy> getFooterPolicies() {
        List<GeneralPolicy> list = new ArrayList<>();
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order "
                   + "FROM Policy WHERE show_in_footer = 1 AND status = 1 ORDER BY footer_order ASC, title ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                GeneralPolicy p = new GeneralPolicy();
                p.setPolicyId(rs.getInt("policy_id"));
                p.setTitle(rs.getString("title"));
                p.setPolicyType(rs.getString("policy_type"));
                p.setContent(rs.getString("content"));
                p.setStatus(rs.getBoolean("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                p.setShowInFooter(rs.getBoolean("show_in_footer"));
                p.setFooterOrder(rs.getInt("footer_order"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật tiêu đề và nội dung HTML của một bài viết chính sách.
     */
    public boolean updateContent(int id, String title, String content) {
        String sql = "UPDATE Policy SET title = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE policy_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật tùy chọn hiển thị và thứ tự sắp xếp trên Footer.
     */
    public boolean updateFooterSettings(int id, boolean showInFooter, int footerOrder) {
        String sql = "UPDATE Policy SET show_in_footer = ?, footer_order = ? WHERE policy_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, showInFooter);
            ps.setInt(2, footerOrder);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm mới bài viết chính sách chung / tin tức vào DB và trả về ID tự tăng vừa tạo.
     */
    public int insertPolicy(String title, String policyType, String content, boolean showInFooter) {
        String sql = "INSERT INTO Policy (title, policy_type, content, status, show_in_footer, footer_order, created_at, updated_at) "
                   + "VALUES (?, ?, ?, 1, ?, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, policyType);
            ps.setString(3, content);
            ps.setBoolean(4, showInFooter);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Xóa một bài viết chính sách / tin tức theo ID.
     */
    public boolean deletePolicy(int id) {
        String sql = "DELETE FROM Policy WHERE policy_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách các bài viết thuộc nhiều loại khác nhau (VD: PROMOTION, NEW_PRODUCT, NEWS...).
     */
    public List<GeneralPolicy> getPoliciesByTypes(List<String> types) {
        List<GeneralPolicy> list = new ArrayList<>();
        if (types == null || types.isEmpty()) {
            return list;
        }
        StringBuilder sql = new StringBuilder("SELECT policy_id, title, policy_type, content, status, created_at, updated_at, show_in_footer, footer_order FROM Policy WHERE status = 1 AND policy_type IN (");
        for (int i = 0; i < types.size(); i++) {
            sql.append(i == 0 ? "?" : ", ?");
        }
        sql.append(") ORDER BY created_at DESC");
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < types.size(); i++) {
                ps.setString(i + 1, types.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GeneralPolicy p = new GeneralPolicy();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setTitle(rs.getString("title"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setContent(rs.getString("content"));
                    p.setStatus(rs.getBoolean("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    p.setShowInFooter(rs.getBoolean("show_in_footer"));
                    p.setFooterOrder(rs.getInt("footer_order"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}


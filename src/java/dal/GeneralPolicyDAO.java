package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.GeneralPolicy;

public class GeneralPolicyDAO extends DBContext {
    
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

    public List<GeneralPolicy> getFooterDocPolicies() {
        return getFooterDocPolicies(null);
    }

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

    public List<GeneralPolicy> getNewsArticles() {
        return getNewsArticles(null);
    }

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

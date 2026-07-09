package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.GeneralPolicy;

public class GeneralPolicyDAO extends DBContext {
    
    public GeneralPolicy getPolicyByType(String type) {
        String sql = "SELECT policy_id, title, policy_type, content, status, created_at, updated_at "
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
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

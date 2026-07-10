package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.WarrantyPolicy;

public class WarrantyPolicyDAO extends DBContext {

    public List<WarrantyPolicy> getActivePolicies() {
        List<WarrantyPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM WarrantyPolicies WHERE Status = 'LIVE' ORDER BY PolicyID ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                WarrantyPolicy p = new WarrantyPolicy();
                p.setPolicyId(rs.getInt("PolicyID"));
                p.setPolicyName(rs.getString("PolicyName"));
                p.setDescription(rs.getString("Description"));
                p.setPolicyContent(rs.getString("PolicyContent"));
                p.setApplicableRegions(rs.getString("ApplicableRegions"));
                p.setWarrantyMonths(rs.getInt("WarrantyMonths"));
                p.setStatus(rs.getString("Status"));
                p.setVersion(rs.getString("Version"));
                p.setEffectiveDate(rs.getDate("EffectiveDate"));
                p.setCreatedAt(rs.getTimestamp("CreatedAt"));
                p.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

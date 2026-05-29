/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.WarrantyPolicy;
import java.sql.*;

/**
 *
 * @author Lenovo
 */
public class PolicyDAO extends DBContext{
    public List<WarrantyPolicy> getAllPolicies() throws SQLException {
            
            List<WarrantyPolicy> list = new ArrayList<>();
    
    String sql = """
                 """;
    
    try (Connection cn = getConnection()) {
    PreparedStatement ps = cn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    while(rs.next()) {
        WarrantyPolicy wp = new WarrantyPolicy();
        wp.setPolicyId(rs.getInt("PolicyID"));
        wp.setPolicyName(rs.getString("PolicyName"));
        wp.setDescription(rs.getString("Description"));
        wp.setWarrantyMonths(rs.getInt("WarrantyMonths"));
    
        list.add(wp);
    }
    
} 
        return list;
    }
}

package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.WarrantyPolicy;

public class PolicyDAO extends DBContext{

    public List<WarrantyPolicy> getAllPolicies()
            throws Exception {

        List<WarrantyPolicy> list =
                new ArrayList<>();

        String sql =
                "SELECT * FROM WarrantyPolicies";

        try (Connection con = getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql);

             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                WarrantyPolicy p =
                        new WarrantyPolicy();

                p.setPolicyId(
                        rs.getInt("PolicyID"));

                p.setPolicyName(
                        rs.getString("PolicyName"));

                p.setDescription(
                        rs.getString("Description"));

                p.setWarrantyMonths(
                        rs.getInt("WarrantyMonths"));

                p.setStatus(
                        rs.getString("Status"));

                list.add(p);
            }
        }

        return list;
    }

    public WarrantyPolicy getPolicyById(int id)
            throws Exception {

        String sql =
                "SELECT * FROM WarrantyPolicies WHERE PolicyID=?";

        try (Connection con = getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                WarrantyPolicy p =
                        new WarrantyPolicy();

                p.setPolicyId(
                        rs.getInt("PolicyID"));

                p.setPolicyName(
                        rs.getString("PolicyName"));

                p.setDescription(
                        rs.getString("Description"));

                p.setWarrantyMonths(
                        rs.getInt("WarrantyMonths"));

                p.setStatus(
                        rs.getString("Status"));

                return p;
            }
        }

        return null;
    }

    public void insertPolicy(WarrantyPolicy p)
            throws Exception {

        String sql =
                """
                INSERT INTO WarrantyPolicies
                (
                    PolicyName,
                    Description,
                    WarrantyMonths,
                    Status
                )
                VALUES (?,?,?,?)
                """;

        try (Connection con = getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, p.getPolicyName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getWarrantyMonths());
            ps.setString(4, p.getStatus());

            ps.executeUpdate();
        }
    }

    public void updatePolicy(WarrantyPolicy p)
            throws Exception {

        String sql =
                """
                UPDATE WarrantyPolicies
                SET
                    PolicyName=?,
                    Description=?,
                    WarrantyMonths=?,
                    Status=?
                WHERE PolicyID=?
                """;

        try (Connection con = getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, p.getPolicyName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getWarrantyMonths());
            ps.setString(4, p.getStatus());
            ps.setInt(5, p.getPolicyId());

            ps.executeUpdate();
        }
    }
}
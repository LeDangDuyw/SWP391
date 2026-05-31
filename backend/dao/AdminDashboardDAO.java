package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.DashboardSummary;

public class AdminDashboardDAO extends DBContext{

    public DashboardSummary getDashboardSummary() throws Exception {

        DashboardSummary summary = new DashboardSummary();

        try (Connection con = getConnection()) {

            PreparedStatement ps1 =
                    con.prepareStatement("SELECT COUNT(*) FROM Users");

            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                summary.setTotalUsers(rs1.getInt(1));
            }

            PreparedStatement ps2 =
                    con.prepareStatement("SELECT COUNT(*) FROM Orders");

            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {
                summary.setTotalOrders(rs2.getInt(1));
            }

            PreparedStatement ps3 =
                    con.prepareStatement("SELECT COUNT(*) FROM Products");

            ResultSet rs3 = ps3.executeQuery();

            if (rs3.next()) {
                summary.setTotalProducts(rs3.getInt(1));
            }

            PreparedStatement ps4 =
                    con.prepareStatement(
                            "SELECT COUNT(*) FROM WarrantyPolicies");

            ResultSet rs4 = ps4.executeQuery();

            if (rs4.next()) {
                summary.setTotalPolicies(rs4.getInt(1));
            }
        }

        return summary;
    }
}
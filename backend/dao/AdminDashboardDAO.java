package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.DashboardSummary;

/**
 * AdminDashboardDAO
 *
 * Purpose: Defines the AdminDashboardDAO component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to AdminDashboardDAO.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class AdminDashboardDAO extends DBContext {

    public DashboardSummary getDashboardSummary() throws Exception {

        DashboardSummary summary = new DashboardSummary();

        try (Connection con = getConnection()) {

            // Total Users
            PreparedStatement ps1 =
                    con.prepareStatement("SELECT COUNT(*) FROM [User]");

            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                summary.setTotalUsers(rs1.getInt(1));
            }

            // Total Orders
            PreparedStatement ps2 =
                    con.prepareStatement("SELECT COUNT(*) FROM [Order]");

            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {
                summary.setTotalOrders(rs2.getInt(1));
            }

            // Total Products
            PreparedStatement ps3 =
                    con.prepareStatement("SELECT COUNT(*) FROM Product");

            ResultSet rs3 = ps3.executeQuery();

            if (rs3.next()) {
                summary.setTotalProducts(rs3.getInt(1));
            }

            // Total Warranty Policies
            PreparedStatement ps4 =
                    con.prepareStatement("SELECT COUNT(*) FROM WarrantyPolicies");

            ResultSet rs4 = ps4.executeQuery();

            if (rs4.next()) {
                summary.setTotalPolicies(rs4.getInt(1));
            }
        }

        return summary;
    }

    public DashboardSummary getStaffDashboard() throws Exception {

        DashboardSummary summary = new DashboardSummary();

        try (Connection con = getConnection()) {

            PreparedStatement ps1 =
                    con.prepareStatement("SELECT COUNT(*) FROM [Order]");

            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                summary.setTotalOrders(rs1.getInt(1));
            }

            PreparedStatement ps2 =
                    con.prepareStatement("SELECT COUNT(*) FROM Product");

            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {
                summary.setTotalProducts(rs2.getInt(1));
            }

            summary.setSystemStatus("ONLINE");
        }

        return summary;
    }
}
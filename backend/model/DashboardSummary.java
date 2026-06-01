package model;

/**
 * DashboardSummary
 *
 * Purpose: Defines the DashboardSummary component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to DashboardSummary.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class DashboardSummary {

    private int totalUsers;
    private int totalOrders;
    private int totalProducts;
    private int totalPolicies;
    private double totalRevenue;
    private String systemStatus;

    public DashboardSummary() {
    }

    public DashboardSummary(int totalUsers, int totalOrders, int totalProducts, int totalPolicies, double totalRevenue, String systemStatus) {
        this.totalUsers = totalUsers;
        this.totalOrders = totalOrders;
        this.totalProducts = totalProducts;
        this.totalPolicies = totalPolicies;
        this.totalRevenue = totalRevenue;
        this.systemStatus = systemStatus;
    }
    
    
    
    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public int getTotalPolicies() {
        return totalPolicies;
    }

    public void setTotalPolicies(int totalPolicies) {
        this.totalPolicies = totalPolicies;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public String getSystemStatus() {
        return systemStatus;
    }

    public void setSystemStatus(String systemStatus) {
        this.systemStatus = systemStatus;
    }
}
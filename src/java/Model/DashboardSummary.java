package model;

import java.util.List;
import java.util.Map;

/**
 * DashboardSummary represents aggregated KPI data displayed on admin dashboard.
 *
 * Version 2.0
 *
 * Date: 18/06/2026
 * 
 * Author DuyLD
 */
public class DashboardSummary {


    // KPI Cards
    private double todayRevenue;
    private int todayOrders;
    private int newCustomersToday;
    private int pendingAlerts;


    // Revenue Chart
    private Map<String, Double> monthlyRevenue;


    // Orders Chart
    private Map<String, Integer> ordersByStatus;


    // Product Category Chart
    private Map<String, Integer> productsByCategory;


    // Low Stock Table
    private List<Product> lowStockProducts;


    // Top Products Chart
    private Map<String, Integer> topProducts;


    // Top Customers Chart
    private Map<String, Double> topCustomers;


    // Recent Activities
    private List<String[]> recentActivities;



    public DashboardSummary() {
    }



    public double getTodayRevenue() {
        return todayRevenue;
    }

    public void setTodayRevenue(double todayRevenue) {
        this.todayRevenue = todayRevenue;
    }



    public int getTodayOrders() {
        return todayOrders;
    }

    public void setTodayOrders(int todayOrders) {
        this.todayOrders = todayOrders;
    }



    public int getNewCustomersToday() {
        return newCustomersToday;
    }

    public void setNewCustomersToday(int newCustomersToday) {
        this.newCustomersToday = newCustomersToday;
    }



    public int getPendingAlerts() {
        return pendingAlerts;
    }

    public void setPendingAlerts(int pendingAlerts) {
        this.pendingAlerts = pendingAlerts;
    }



    public Map<String, Double> getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(Map<String, Double> monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }



    public Map<String, Integer> getOrdersByStatus() {
        return ordersByStatus;
    }

    public void setOrdersByStatus(Map<String, Integer> ordersByStatus) {
        this.ordersByStatus = ordersByStatus;
    }



    public Map<String, Integer> getProductsByCategory() {
        return productsByCategory;
    }

    public void setProductsByCategory(Map<String, Integer> productsByCategory) {
        this.productsByCategory = productsByCategory;
    }



    public List<Product> getLowStockProducts() {
        return lowStockProducts;
    }

    public void setLowStockProducts(List<Product> lowStockProducts) {
        this.lowStockProducts = lowStockProducts;
    }



    public Map<String, Integer> getTopProducts() {
        return topProducts;
    }

    public void setTopProducts(Map<String, Integer> topProducts) {
        this.topProducts = topProducts;
    }



    public Map<String, Double> getTopCustomers() {
        return topCustomers;
    }

    public void setTopCustomers(Map<String, Double> topCustomers) {
        this.topCustomers = topCustomers;
    }



    public List<String[]> getRecentActivities() {
        return recentActivities;
    }

    public void setRecentActivities(List<String[]> recentActivities) {
        this.recentActivities = recentActivities;
    }

}
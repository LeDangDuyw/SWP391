package model;

/**
 * Class: DashboardSummary
 * Description: Model đại diện cho số liệu thống kê tổng quan hiển thị trên Dashboard.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-06-18 20:32:25 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */


/**
 * Class: DashboardSummary
 * Description: Model đại diện cho số liệu thống kê tổng quan hiển thị trên Dashboard.
 * 
 * Created: 2026-05-31 23:29:28 +0700
 * Updated: 2026-06-18 20:32:25 +0700
 * Version: v1.0
 *
 * @author DuyLD
 */

import java.util.List;
import java.util.Map;


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



    /**
     * Phuong thuc DashboardSummary
     */
    public DashboardSummary() {
    }



    /**
     * Phuong thuc getTodayRevenue
     */
    public double getTodayRevenue() {
        return todayRevenue;
    }

    /**
     * Phuong thuc setTodayRevenue
     */
    public void setTodayRevenue(double todayRevenue) {
        this.todayRevenue = todayRevenue;
    }



    /**
     * Phuong thuc getTodayOrders
     */
    public int getTodayOrders() {
        return todayOrders;
    }

    /**
     * Phuong thuc setTodayOrders
     */
    public void setTodayOrders(int todayOrders) {
        this.todayOrders = todayOrders;
    }



    /**
     * Phuong thuc getNewCustomersToday
     */
    public int getNewCustomersToday() {
        return newCustomersToday;
    }

    /**
     * Phuong thuc setNewCustomersToday
     */
    public void setNewCustomersToday(int newCustomersToday) {
        this.newCustomersToday = newCustomersToday;
    }



    /**
     * Phuong thuc getPendingAlerts
     */
    public int getPendingAlerts() {
        return pendingAlerts;
    }

    /**
     * Phuong thuc setPendingAlerts
     */
    public void setPendingAlerts(int pendingAlerts) {
        this.pendingAlerts = pendingAlerts;
    }



    /**
     * Phuong thuc getMonthlyRevenue
     */
    public Map<String, Double> getMonthlyRevenue() {
        return monthlyRevenue;
    }

    /**
     * Phuong thuc setMonthlyRevenue
     */
    public void setMonthlyRevenue(Map<String, Double> monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }



    /**
     * Phuong thuc getOrdersByStatus
     */
    public Map<String, Integer> getOrdersByStatus() {
        return ordersByStatus;
    }

    /**
     * Phuong thuc setOrdersByStatus
     */
    public void setOrdersByStatus(Map<String, Integer> ordersByStatus) {
        this.ordersByStatus = ordersByStatus;
    }



    /**
     * Phuong thuc getProductsByCategory
     */
    public Map<String, Integer> getProductsByCategory() {
        return productsByCategory;
    }

    /**
     * Phuong thuc setProductsByCategory
     */
    public void setProductsByCategory(Map<String, Integer> productsByCategory) {
        this.productsByCategory = productsByCategory;
    }



    /**
     * Phuong thuc getLowStockProducts
     */
    public List<Product> getLowStockProducts() {
        return lowStockProducts;
    }

    /**
     * Phuong thuc setLowStockProducts
     */
    public void setLowStockProducts(List<Product> lowStockProducts) {
        this.lowStockProducts = lowStockProducts;
    }



    /**
     * Phuong thuc getTopProducts
     */
    public Map<String, Integer> getTopProducts() {
        return topProducts;
    }

    /**
     * Phuong thuc setTopProducts
     */
    public void setTopProducts(Map<String, Integer> topProducts) {
        this.topProducts = topProducts;
    }



    /**
     * Phuong thuc getTopCustomers
     */
    public Map<String, Double> getTopCustomers() {
        return topCustomers;
    }

    /**
     * Phuong thuc setTopCustomers
     */
    public void setTopCustomers(Map<String, Double> topCustomers) {
        this.topCustomers = topCustomers;
    }



    /**
     * Phuong thuc getRecentActivities
     */
    public List<String[]> getRecentActivities() {
        return recentActivities;
    }

    /**
     * Phuong thuc setRecentActivities
     */
    public void setRecentActivities(List<String[]> recentActivities) {
        this.recentActivities = recentActivities;
    }

}
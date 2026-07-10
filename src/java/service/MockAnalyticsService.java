package service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * MockAnalyticsService provides realistic mock analytics data.
 *
 * !! MOCK DATA !! — Replace with real Order/Revenue module when implemented.
 *
 * Version 1.0
 * Author: Dashboard Redesign
 */
public class MockAnalyticsService {

    // ─────────────────────────────────────────
    // MOCK DATA — Replace when Order module is implemented
    // ─────────────────────────────────────────

    /** Today's revenue in VND (mock). */
    public long getTodayRevenue() {
        // MOCK DATA — Replace when Order module is implemented
        return 45_500_000L;
    }

    /** Today's order count (mock). */
    public int getTodayOrders() {
        // MOCK DATA — Replace when Order module is implemented
        return 28;
    }

    /** New customers registered today (mock). */
    public int getNewCustomersToday() {
        // MOCK DATA — Replace when Order module is implemented
        return 7;
    }

    /** Number of pending alerts (mock). */
    public int getPendingAlerts() {
        // MOCK DATA — Replace when Order module is implemented
        return 3;
    }

    /**
     * Monthly revenue data for bar chart (mock).
     * Returns map: month label -> revenue in millions VND.
     */
    public Map<String, Long> getMonthlyRevenue() {
        // MOCK DATA — Replace when Order module is implemented
        Map<String, Long> data = new LinkedHashMap<>();
        data.put("Jan", 35_000_000L);
        data.put("Feb", 42_000_000L);
        data.put("Mar", 38_000_000L);
        data.put("Apr", 51_000_000L);
        data.put("May", 47_000_000L);
        data.put("Jun", 63_000_000L);
        return data;
    }

    /**
     * Orders grouped by status for doughnut chart (mock).
     * Returns map: status label -> count.
     */
    public Map<String, Integer> getOrdersByStatus() {
        // MOCK DATA — Replace when Order module is implemented
        Map<String, Integer> data = new LinkedHashMap<>();
        data.put("Pending", 15);
        data.put("Processing", 22);
        data.put("Shipping", 34);
        data.put("Completed", 128);
        data.put("Cancelled", 8);
        return data;
    }

    /**
     * Top selling products for horizontal bar chart (mock).
     * Returns map: product name -> units sold.
     */
    public Map<String, Integer> getTopProducts() {
        // MOCK DATA — Replace when Order module is implemented
        Map<String, Integer> data = new LinkedHashMap<>();
        data.put("RTX 5070", 142);
        data.put("Dell XPS 15", 118);
        data.put("iPhone 16 Pro", 95);
        data.put("Samsung S25", 87);
        data.put("MacBook Air M4", 76);
        return data;
    }

    /**
     * Top customers by spend (mock).
     * Returns map: customer name -> total spend in VND.
     */
    public Map<String, Long> getTopCustomers() {
        // MOCK DATA — Replace when Order module is implemented
        Map<String, Long> data = new LinkedHashMap<>();
        data.put("Nguyen Van A", 12_500_000L);
        data.put("Tran Thi B",   9_800_000L);
        data.put("Le Van C",     8_200_000L);
        data.put("Pham Van D",   7_150_000L);
        data.put("Hoang Thi E",  6_900_000L);
        return data;
    }

    /**
     * Recent activity feed — mix of real-style events (mock).
     */
    public List<String[]> getRecentActivities() {
        // MOCK DATA — Replace with real audit log when implemented
        List<String[]> acts = new ArrayList<>();
        // Format: [icon, text, time]
        acts.add(new String[]{"📦", "Product <b>RTX 5070</b> added to inventory", "2 min ago"});
        acts.add(new String[]{"✅", "Warranty claim <b>WR-102</b> approved", "15 min ago"});
        acts.add(new String[]{"👤", "New customer <b>Nguyen Van A</b> registered", "32 min ago"});
        acts.add(new String[]{"🔄", "Stock updated for <b>MacBook Air M4</b>", "1 hr ago"});
        acts.add(new String[]{"📜", "Warranty policy <b>POL-07</b> updated", "2 hrs ago"});
        acts.add(new String[]{"🛒", "Order <b>#ORD-2048</b> marked as shipped", "3 hrs ago"});
        acts.add(new String[]{"⚠️", "Low stock alert: <b>Dell XPS 15</b> (3 left)", "4 hrs ago"});
        return acts;
    }
}
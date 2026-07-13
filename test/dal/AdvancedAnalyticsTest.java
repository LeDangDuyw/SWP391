package dal;

import java.util.List;
import java.util.Map;
import model.AnalyticsFilter;

/**
 * AdvancedAnalyticsTest is a standalone test runner for AdvancedAnalyticsDAO.
 * It executes all 12 analytical database queries and prints summaries.
 * 
 * Version 1.0
 * Date: 09/07/2026
 * Author: DuyLD
 */
public class AdvancedAnalyticsTest {

    public static void main(String[] args) {
        System.out.println("=========================================");
        System.out.println("  Advanced Analytics DAO Test Runner     ");
        System.out.println("=========================================");

        try {
            AdvancedAnalyticsDAO dao = new AdvancedAnalyticsDAO();
            
            // 1. Verify connection
            if (dao.getConnection() == null) {
                System.out.println("[ERROR] Database connection is NULL! Check DBContext or ConnectDB.properties.");
                return;
            }
            System.out.println("[SUCCESS] Database connected.");

            // 2. Status check
            List<String> validStatuses = dao.getValidRawStatuses();
            System.out.println("\n[INFO] Valid Raw Statuses mapped by normalizeStatus(): " + validStatuses);

            // Initialize Filter (broad enough to capture seed data spanning 2025/2026)
            AnalyticsFilter filter = new AnalyticsFilter();
            filter.setFromDate("2025-01-01");
            filter.setToDate("2026-12-31");
            
            System.out.println("\n--- RUNNING 12 ANALYTICAL QUERIES (Filter: " + filter + ") ---");

            // Query 1: getRevenueTrend
            Map<String, Long> revTrend = dao.getRevenueTrend(filter, "month");
            System.out.println("1. getRevenueTrend (month) -> Size: " + revTrend.size() + " buckets. Data: " + revTrend);

            // Query 2: getRevenueByCategory
            Map<String, Long> revCat = dao.getRevenueByCategory(filter);
            System.out.println("2. getRevenueByCategory -> Size: " + revCat.size() + " categories. Data: " + revCat);

            // Query 3: getRevenueByBrand
            Map<String, Long> revBrand = dao.getRevenueByBrand(filter);
            System.out.println("3. getRevenueByBrand -> Size: " + revBrand.size() + " brands. Data: " + revBrand);

            // Query 4: getOrdersTrend
            Map<String, Integer> ordersTrend = dao.getOrdersTrend(filter, "month");
            System.out.println("4. getOrdersTrend (month) -> Size: " + ordersTrend.size() + " buckets. Data: " + ordersTrend);

            // Query 5: getAverageOrderValue
            double aov = dao.getAverageOrderValue(filter);
            System.out.println("5. getAverageOrderValue -> " + String.format("%,.2f VND", aov));

            // Query 6: getSalesByPaymentMethod
            Map<String, Integer> payMethod = dao.getSalesByPaymentMethod(filter);
            System.out.println("6. getSalesByPaymentMethod -> Size: " + payMethod.size() + " methods. Data: " + payMethod);

            // Query 7: getNewVsReturningCustomers
            Map<String, Long[]> customerCohort = dao.getNewVsReturningCustomers(filter);
            System.out.println("7. getNewVsReturningCustomers -> Cohorts:");
            for (Map.Entry<String, Long[]> entry : customerCohort.entrySet()) {
                Long[] vals = entry.getValue();
                System.out.println("   * " + entry.getKey() + ": Customers=" + vals[0] + ", Orders=" + vals[1] + ", Spend=" + vals[2] + " VND");
            }

            // Query 8: getCustomerGrowth
            Map<String, Integer> growth = dao.getCustomerGrowth(filter, "month");
            System.out.println("8. getCustomerGrowth (month) -> Size: " + growth.size() + " buckets. Data: " + growth);

            // Query 9: getTopSpendingCustomers
            List<String[]> topCustomers = dao.getTopSpendingCustomers(filter, 5);
            System.out.println("9. getTopSpendingCustomers (Top 5) -> Count: " + topCustomers.size());
            for (String[] cust : topCustomers) {
                System.out.println("   * Name: " + cust[0] + " | Email: " + cust[1] + " | Spent: " + cust[2] + " VND | Orders: " + cust[3]);
            }

            // Query 10: getBestSellingProducts
            List<String[]> bestProducts = dao.getProductSalesRanking(filter, 5, "quantity", true);
            System.out.println("10. getBestSellingProducts (Top 5 by Quantity) -> Count: " + bestProducts.size());
            for (String[] prod : bestProducts) {
                System.out.println("   * Product: " + prod[0] + " (" + prod[1] + ") | Sold: " + prod[2] + " units | Revenue: " + prod[3] + " VND");
            }

            // Query 11: getWorstSellingProducts
            List<String[]> worstProducts = dao.getProductSalesRanking(filter, 5, "quantity", false);
            System.out.println("11. getWorstSellingProducts (Bottom 5 by Quantity) -> Count: " + worstProducts.size());
            for (String[] prod : worstProducts) {
                System.out.println("   * Product: " + prod[0] + " (" + prod[1] + ") | Sold: " + prod[2] + " units | Revenue: " + prod[3] + " VND");
            }

            // Query 12: getInventoryTurnover
            double[] turnoverData = dao.getInventoryTurnover(filter);
            System.out.println("12. getInventoryTurnover ->");
            System.out.println("   * COGS: " + String.format("%,.2f VND", turnoverData[0]));
            System.out.println("   * Avg Inventory Valuation: " + String.format("%,.2f VND", turnoverData[1]));
            System.out.println("   * Turnover Ratio: " + String.format("%.4f", turnoverData[2]));

            System.out.println("\n=========================================");
            System.out.println("       Tests Finished Successfully       ");
            System.out.println("=========================================");

        } catch (Exception e) {
            System.out.println("[FATAL] An unexpected error occurred: ");
            e.printStackTrace();
        }
    }
}

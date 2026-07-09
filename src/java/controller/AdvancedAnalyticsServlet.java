package controller;

import dal.AdvancedAnalyticsDAO;
import dal.BrandDao;
import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.AnalyticsFilter;
import model.Brand;
import model.Category;
import model.Users;

/**
 * AdvancedAnalyticsServlet loads report and charting data for the admin analytics panel.
 * Filters are isolated per dashboard section (Revenue, Sales, Customer, Product) to avoid empty states.
 *
 * URL: /admin/analytics
 * 
 * Version 1.0
 * Date: 09/07/2026
 * Author: Antigravity
 */
@WebServlet("/admin/analytics")
public class AdvancedAnalyticsServlet extends HttpServlet {

    private AdvancedAnalyticsDAO analyticsDAO;
    private CategoryDAO categoryDAO;
    private BrandDao brandDao;

    @Override
    public void init() {
        analyticsDAO = new AdvancedAnalyticsDAO();
        categoryDAO = new CategoryDAO();
        brandDao = new BrandDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = null;

        if (session != null) {
            user = (Users) session.getAttribute("user");
        }

        // Defensive auth fallback (AuthorizationFilter should already handle this)
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Load Category and Brand dropdown lists (shared across all section filters)
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDao.getAllBrands();
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);

            // Get active section anchor so the JSP can auto-focus the active tab
            String activeSection = request.getParameter("section");
            if (activeSection == null || activeSection.isEmpty()) {
                activeSection = "revenue";
            }
            request.setAttribute("activeSection", activeSection);

            // Default date boundaries (covers the seeded data late 2025 to 2026)
            String defaultFromDate = "2025-01-01";
            String defaultToDate = "2026-12-31";

            // 1. REVENUE SECTION FILTERS & DATA
            String revFrom = request.getParameter("revenueFrom");
            String revTo = request.getParameter("revenueTo");
            if (revFrom == null || revFrom.trim().isEmpty()) revFrom = defaultFromDate;
            if (revTo == null || revTo.trim().isEmpty()) revTo = defaultToDate;
            
            AnalyticsFilter revFilter = new AnalyticsFilter(
                revFrom, revTo,
                getIntegerParam(request.getParameter("revenueCategoryId")),
                getIntegerParam(request.getParameter("revenueBrandId")),
                request.getParameter("revenueCustomerType"),
                request.getParameter("revenuePaymentMethod")
            );
            String revenueGroupBy = request.getParameter("revenueGroupBy");
            if (revenueGroupBy == null || revenueGroupBy.trim().isEmpty()) {
                revenueGroupBy = "month";
            }
            request.setAttribute("revFilter", revFilter);
            request.setAttribute("revenueGroupBy", revenueGroupBy);
            request.setAttribute("revenueTrend", analyticsDAO.getRevenueTrend(revFilter, revenueGroupBy));
            request.setAttribute("revenueByCategory", analyticsDAO.getRevenueByCategory(revFilter));
            request.setAttribute("revenueByBrand", analyticsDAO.getRevenueByBrand(revFilter));

            // 2. SALES SECTION FILTERS & DATA
            String salesFrom = request.getParameter("salesFrom");
            String salesTo = request.getParameter("salesTo");
            if (salesFrom == null || salesFrom.trim().isEmpty()) salesFrom = defaultFromDate;
            if (salesTo == null || salesTo.trim().isEmpty()) salesTo = defaultToDate;

            AnalyticsFilter salesFilter = new AnalyticsFilter(
                salesFrom, salesTo,
                getIntegerParam(request.getParameter("salesCategoryId")),
                getIntegerParam(request.getParameter("salesBrandId")),
                request.getParameter("salesCustomerType"),
                request.getParameter("salesPaymentMethod")
            );
            String salesGroupBy = request.getParameter("salesGroupBy");
            if (salesGroupBy == null || salesGroupBy.trim().isEmpty()) {
                salesGroupBy = "month";
            }
            request.setAttribute("salesFilter", salesFilter);
            request.setAttribute("salesGroupBy", salesGroupBy);
            request.setAttribute("ordersTrend", analyticsDAO.getOrdersTrend(salesFilter, salesGroupBy));
            request.setAttribute("avgOrderValue", analyticsDAO.getAverageOrderValue(salesFilter));
            request.setAttribute("salesByPaymentMethod", analyticsDAO.getSalesByPaymentMethod(salesFilter));

            // 3. CUSTOMER SECTION FILTERS & DATA
            String custFrom = request.getParameter("customerFrom");
            String custTo = request.getParameter("customerTo");
            if (custFrom == null || custFrom.trim().isEmpty()) custFrom = defaultFromDate;
            if (custTo == null || custTo.trim().isEmpty()) custTo = defaultToDate;

            AnalyticsFilter custFilter = new AnalyticsFilter(
                custFrom, custTo,
                getIntegerParam(request.getParameter("customerCategoryId")),
                getIntegerParam(request.getParameter("customerBrandId")),
                null, // Customer type filtering not applicable for outer new vs returning cohort split
                request.getParameter("customerPaymentMethod")
            );
            String customerGroupBy = request.getParameter("customerGroupBy");
            if (customerGroupBy == null || customerGroupBy.trim().isEmpty()) {
                customerGroupBy = "month";
            }
            String custTopNParam = request.getParameter("customerTopN");
            int customerTopN = 10;
            if (custTopNParam != null && !custTopNParam.isEmpty()) {
                try { customerTopN = Integer.parseInt(custTopNParam); } catch (Exception ignored) {}
            }
            request.setAttribute("custFilter", custFilter);
            request.setAttribute("customerGroupBy", customerGroupBy);
            request.setAttribute("customerTopN", customerTopN);
            request.setAttribute("newVsReturningCustomers", analyticsDAO.getNewVsReturningCustomers(custFilter));
            request.setAttribute("customerGrowth", analyticsDAO.getCustomerGrowth(custFilter, customerGroupBy));
            request.setAttribute("topSpendingCustomers", analyticsDAO.getTopSpendingCustomers(custFilter, customerTopN));

            // 4. PRODUCT SECTION FILTERS & DATA
            String prodFrom = request.getParameter("productFrom");
            String prodTo = request.getParameter("productTo");
            if (prodFrom == null || prodFrom.trim().isEmpty()) prodFrom = defaultFromDate;
            if (prodTo == null || prodTo.trim().isEmpty()) prodTo = defaultToDate;

            AnalyticsFilter prodFilter = new AnalyticsFilter(
                prodFrom, prodTo,
                getIntegerParam(request.getParameter("productCategoryId")),
                getIntegerParam(request.getParameter("productBrandId")),
                request.getParameter("productCustomerType"),
                request.getParameter("productPaymentMethod")
            );
            String prodTopNParam = request.getParameter("productTopN");
            int productTopN = 10;
            if (prodTopNParam != null && !prodTopNParam.isEmpty()) {
                try { productTopN = Integer.parseInt(prodTopNParam); } catch (Exception ignored) {}
            }
            String productSortBy = request.getParameter("productSortBy");
            if (productSortBy == null || productSortBy.isEmpty()) {
                productSortBy = "quantity";
            }
            request.setAttribute("prodFilter", prodFilter);
            request.setAttribute("productTopN", productTopN);
            request.setAttribute("productSortBy", productSortBy);
            
            // Reuses the same query flipping descending/ascending parameter
            request.setAttribute("bestSellingProducts", analyticsDAO.getProductSalesRanking(prodFilter, productTopN, productSortBy, true));
            request.setAttribute("worstSellingProducts", analyticsDAO.getProductSalesRanking(prodFilter, productTopN, productSortBy, false));
            request.setAttribute("inventoryTurnover", analyticsDAO.getInventoryTurnover(prodFilter));

            request.getRequestDispatcher("/admin/advanced_analytics.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Cannot load advanced analytics panel", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private Integer getIntegerParam(String value) {
        if (value == null || value.trim().isEmpty() || "all".equalsIgnoreCase(value.trim())) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

package controller;

/**
 * Class: AdvancedAnalyticsServlet
 * Description: Controller xử lý trang báo cáo phân tích kinh doanh chuyên sâu (Advanced Analytics).
 *              Hỗ trợ lọc đa chiều (ngày bắt đầu/kết thúc, danh mục, thương hiệu, loại khách hàng,
 *              phương thức thanh toán) và tính toán xu hướng doanh thu, cơ cấu sản phẩm,
 *              chỉ số AOV, hệ số vòng quay hàng tồn kho (Inventory Turnover).
 * 
 * Created: 2026-07-09
 * Updated: 2026-07-22
 * Version: v1.4
 *
 * @author DuyLD
 */

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

@WebServlet("/admin/analytics")
public class AdvancedAnalyticsServlet extends HttpServlet {

    private AdvancedAnalyticsDAO analyticsDAO;
    private CategoryDAO categoryDAO;
    private BrandDao brandDao;

    /**
     * Khởi tạo Servlet và các lớp DAO phục vụ báo cáo phân tích.
     */
    @Override
    public void init() {
        analyticsDAO = new AdvancedAnalyticsDAO();
        categoryDAO = new CategoryDAO();
        brandDao = new BrandDao();
    }

    /**
     * Xử lý yêu cầu HTTP GET để tổng hợp báo cáo phân tích đa chiều và render giao diện.
     *
     * @param request  đối tượng HttpServletRequest chứa các tham số lọc đa chiều
     * @param response đối tượng HttpServletResponse trả về trang JSP
     * @throws ServletException nếu xảy ra lỗi Servlet
     * @throws IOException      nếu xảy ra lỗi IO
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra quyền đăng nhập của người dùng
        HttpSession session = request.getSession(false);
        Users user = null;

        if (session != null) {
            user = (Users) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Tiếp nhận tham số section và các tham số lọc từ bộ lọc giao diện
            String section = request.getParameter("section");
            if (section == null || section.trim().isEmpty()) {
                section = "revenue";
            }

            String fromDate = request.getParameter("fromDate");
            if (fromDate == null || fromDate.trim().isEmpty()) fromDate = request.getParameter(section + "From");

            String toDate = request.getParameter("toDate");
            if (toDate == null || toDate.trim().isEmpty()) toDate = request.getParameter(section + "To");

            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) categoryIdParam = request.getParameter(section + "CategoryId");

            String brandIdParam = request.getParameter("brandId");
            if (brandIdParam == null || brandIdParam.trim().isEmpty()) brandIdParam = request.getParameter(section + "BrandId");

            String customerType = request.getParameter("customerType");
            if (customerType == null || customerType.trim().isEmpty()) customerType = request.getParameter(section + "CustomerType");

            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) paymentMethod = request.getParameter(section + "PaymentMethod");

            String groupBy = request.getParameter("groupBy");
            if (groupBy == null || groupBy.trim().isEmpty()) groupBy = request.getParameter(section + "GroupBy");

            // Mặc định kiểu nhóm thời gian là theo Tháng nếu chưa được truyền
            if (groupBy == null || groupBy.trim().isEmpty()) {
                groupBy = "month";
            }

            // Đặt mốc thời gian mặc định bao phủ dữ liệu năm 2025-2026 nếu không chọn khoảng ngày
            String defaultFromDate = "2025-01-01";
            String defaultToDate = java.time.LocalDate.now().toString();

            if (fromDate == null || fromDate.trim().isEmpty()) {
                fromDate = defaultFromDate;
            }
            if (toDate == null || toDate.trim().isEmpty()) {
                toDate = defaultToDate;
            }

            // 3. Khởi tạo đối tượng DTO AnalyticsFilter đóng gói tiêu chí lọc
            AnalyticsFilter filter = new AnalyticsFilter();
            filter.setFromDate(fromDate);
            filter.setToDate(toDate);

            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty() && !"all".equalsIgnoreCase(categoryIdParam)) {
                try {
                    filter.setCategoryId(Integer.parseInt(categoryIdParam.trim()));
                } catch (NumberFormatException ignored) {
                }
            }

            if (brandIdParam != null && !brandIdParam.trim().isEmpty() && !"all".equalsIgnoreCase(brandIdParam)) {
                try {
                    filter.setBrandId(Integer.parseInt(brandIdParam.trim()));
                } catch (NumberFormatException ignored) {
                }
            }

            if (customerType != null && !customerType.trim().isEmpty() && !"all".equalsIgnoreCase(customerType)) {
                filter.setCustomerType(customerType.trim());
            }

            if (paymentMethod != null && !paymentMethod.trim().isEmpty() && !"all".equalsIgnoreCase(paymentMethod)) {
                filter.setPaymentMethod(paymentMethod.trim());
            }

            // 4. Truy vấn các báo cáo phân tích chuyên sâu từ AdvancedAnalyticsDAO
            Map<String, Long> revenueTrend = analyticsDAO.getRevenueTrend(filter, groupBy);
            Map<String, Long> revenueByCategory = analyticsDAO.getRevenueByCategory(filter);
            Map<String, Long> revenueByBrand = analyticsDAO.getRevenueByBrand(filter);

            Map<String, Integer> ordersTrend = analyticsDAO.getOrdersTrend(filter, groupBy);
            double avgOrderValue = analyticsDAO.getAverageOrderValue(filter);

            Map<String, Integer> paymentMethods = analyticsDAO.getSalesByPaymentMethod(filter);

            Map<String, Long[]> customerBreakdown = analyticsDAO.getNewVsReturningCustomers(filter);
            Map<String, Integer> customerGrowth = analyticsDAO.getCustomerGrowth(filter, groupBy);
            List<String[]> topSpendingCustomers = analyticsDAO.getTopSpendingCustomers(filter, 10);

            // Bảng xếp hạng sản phẩm bán chạy & bán chậm
            String prodSortBy = request.getParameter("productSortBy");
            if (prodSortBy == null || prodSortBy.trim().isEmpty()) {
                prodSortBy = request.getParameter("prodSortBy");
            }
            if (prodSortBy == null || prodSortBy.trim().isEmpty()) {
                prodSortBy = "quantity";
            }

            String productTopNStr = request.getParameter("productTopN");
            int productTopN = 10;
            if (productTopNStr != null && !productTopNStr.trim().isEmpty()) {
                try {
                    productTopN = Integer.parseInt(productTopNStr.trim());
                } catch (Exception ignored) {
                }
            }

            List<String[]> bestSellingProducts = analyticsDAO.getProductSalesRanking(filter, productTopN, prodSortBy, true);
            List<String[]> slowSellingProducts = analyticsDAO.getProductSalesRanking(filter, productTopN, prodSortBy, false);

            // Chỉ số hiệu quả quản lý kho: Hệ số vòng quay tồn kho (Inventory Turnover Ratio)
            double[] turnover = analyticsDAO.getInventoryTurnover(filter);

            // Lấy danh mục & thương hiệu cho dropdown bộ lọc
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDao.getAllBrands();

            // 5. Đẩy dữ liệu ra thuộc tính của request để render trên JSP
            request.setAttribute("activeSection", section);
            request.setAttribute("filter", filter);
            request.setAttribute("revFilter", filter);
            request.setAttribute("salesFilter", filter);
            request.setAttribute("customerFilter", filter);
            request.setAttribute("prodFilter", filter);
            request.setAttribute("groupBy", groupBy);
            request.setAttribute("revenueGroupBy", groupBy);

            request.setAttribute("revenueTrend", revenueTrend);
            request.setAttribute("revenueByCategory", revenueByCategory);
            request.setAttribute("revenueByBrand", revenueByBrand);

            request.setAttribute("ordersTrend", ordersTrend);
            request.setAttribute("avgOrderValue", avgOrderValue);

            request.setAttribute("paymentMethods", paymentMethods);

            request.setAttribute("customerBreakdown", customerBreakdown);
            request.setAttribute("customerGrowth", customerGrowth);
            request.setAttribute("topSpendingCustomers", topSpendingCustomers);

            request.setAttribute("bestSellingProducts", bestSellingProducts);
            request.setAttribute("slowSellingProducts", slowSellingProducts);
            request.setAttribute("worstSellingProducts", slowSellingProducts);
            request.setAttribute("productRanking", bestSellingProducts);
            request.setAttribute("productTopN", productTopN);
            request.setAttribute("productSortBy", prodSortBy);
            request.setAttribute("prodSortBy", prodSortBy);

            request.setAttribute("inventoryTurnover", turnover);
            request.setAttribute("costOfGoodsSold", turnover[0]);
            request.setAttribute("avgInventoryValue", turnover[1]);
            request.setAttribute("turnoverRatio", turnover[2]);

            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);

            // 6. Forward sang giao diện JSP advanced_analytics
            request.getRequestDispatcher("/admin/advanced_analytics.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi tải báo cáo phân tích nâng cao.", e);
        }
    }
}

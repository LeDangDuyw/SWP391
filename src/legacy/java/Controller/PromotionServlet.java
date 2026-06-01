package Controller;

import dal.CampaignDAO;
import Model.Campaign;
import Model.CampaignProduct;
import Model.CampaignStats;
import Model.ProductSearchItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Locale;
import java.util.Random;

@WebServlet(name = "PromotionServlet", urlPatterns = {"/admin/promotions"})
public class PromotionServlet extends HttpServlet {
    private final CampaignDAO dao = new CampaignDAO();
    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
            case "create":
                showForm(request, response, null);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "show":
                showDetail(request, response);
                break;

            case "export":
                exportCsv(request, response);
                break;

            case "exportPdf":
                exportPrintReport(request, response);
                break;

            case "products":
                productJson(request, response);
                break;

            case "generate":
                generateCode(response);
                break;

            default:
                showList(request, response);
                break;
        }

            
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            if ("save".equals(action)) {
                saveCampaign(request, response);
                return;
            }
int id = parseInt(request.getParameter("id"), 0);

String status = null;
String actionName = action == null ? "" : action;

switch (actionName) {
    case "stop":
        status = "stopped";
        break;
    case "pause":
        status = "paused";
        break;
    case "resume":
        status = "active";
        break;
    case "approve":
        status = "active";
        break;
    case "reject":
        status = "stopped";
        break;
    default:
        status = null;
        break;
}
            

            if (id > 0 && status != null) {
                dao.updateStatus(id, status);
                redirect(response, request, "?msg=" + enc("Cập nhật trạng thái thành công"));
            } else {
                redirect(response, request, "?msg=" + enc("Không xác định được hành động"));
            }
        } catch (SQLException e) {
            forwardError(request, response, e);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        List<Campaign> campaigns = dao.listCampaigns(keyword, page, PAGE_SIZE);
        int total = dao.countCampaigns(keyword);
        CampaignStats stats = dao.getDashboardStats();

        request.setAttribute("campaigns", campaigns);
        request.setAttribute("stats", stats);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("total", total);
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/WEB-INF/views/admin/promotions.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign campaign = dao.getCampaignById(id);
        if (campaign == null) {
            redirect(response, request, "?msg=" + enc("Không tìm thấy chiến dịch"));
            return;
        }
        showForm(request, response, campaign);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Campaign campaign) throws SQLException, ServletException, IOException {
        String productKeyword = request.getParameter("productKeyword");
        int campaignId = campaign == null ? 0 : campaign.getCampaignId();
        List<ProductSearchItem> products = dao.searchProducts(productKeyword, campaignId);
        request.setAttribute("campaign", campaign);
        request.setAttribute("products", products);
        request.setAttribute("productKeyword", productKeyword == null ? "" : productKeyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/campaignForm.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign campaign = dao.getCampaignById(id);
        if (campaign == null) {
            redirect(response, request, "?msg=" + enc("Không tìm thấy chiến dịch"));
            return;
        }
        List<CampaignProduct> products = dao.getProductPerformance(id);
        int totalUnits = products.stream().mapToInt(CampaignProduct::getUnitsSold).sum();
        BigDecimal revenue = products.stream().map(CampaignProduct::getRevenue).reduce(BigDecimal.ZERO, BigDecimal::add);
        int customerGrowth = Math.max(0, campaign.getUsedCount() + products.size() * 12);
        double conversion = campaign.getUsageLimit() == null || campaign.getUsageLimit() == 0
                ? 0.0
                : (campaign.getUsedCount() * 100.0 / campaign.getUsageLimit());

        request.setAttribute("campaign", campaign);
        request.setAttribute("products", products);
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("revenue", revenue);
        request.setAttribute("conversion", conversion);
        request.setAttribute("customerGrowth", customerGrowth);
        request.getRequestDispatcher("/WEB-INF/views/admin/campaignDetail.jsp").forward(request, response);
    }

    private void saveCampaign(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Campaign campaign = new Campaign();
        int id = parseInt(request.getParameter("id"), 0);
        campaign.setCampaignId(id);
        campaign.setCampaignName(req(request, "campaignName"));
        campaign.setCampaignDescription(req(request, "campaignDescription"));
        campaign.setPromoCode(req(request, "promoCode").toUpperCase(Locale.ROOT).replaceAll("\\s+", ""));
        campaign.setCampaignType(req(request, "campaignType"));
        campaign.setTargetGroup(req(request, "targetGroup"));
        campaign.setDiscountValue(parseMoney(request.getParameter("discountValue")));
        campaign.setMinOrderValue(parseMoney(request.getParameter("minOrderValue")));
        campaign.setUsageLimit(parseNullableInt(request.getParameter("usageLimit")));
        campaign.setStatus(req(request, "status").isBlank() ? "scheduled" : req(request, "status"));
        campaign.setStartDate(parseDateStart(request.getParameter("startDate")));
        campaign.setEndDate(parseDateEnd(request.getParameter("endDate")));
        int[] variantIds = parseIds(request.getParameterValues("variantIds"));

        if (id > 0) {
            dao.updateCampaign(campaign, variantIds);
            redirect(response, request, "?action=show&id=" + id + "&msg=" + enc("Đã lưu thay đổi"));
        } else {
            int newId = dao.insertCampaign(campaign, variantIds);
            redirect(response, request, "?action=show&id=" + newId + "&msg=" + enc("Đã tạo chiến dịch mới"));
        }
    }

    private void exportCsv(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        List<Campaign> campaigns = dao.listCampaigns(request.getParameter("keyword"), 1, 1000);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=campaign-report.csv");
        try (PrintWriter out = response.getWriter()) {
            out.write('\uFEFF');
            out.println("Campaign,Code,Type,Status,Used,Usage limit,Start,End");
            for (Campaign c : campaigns) {
                out.printf("%s,%s,%s,%s,%d,%s,%s,%s%n",
                        csv(c.getCampaignName()), csv(c.getPromoCode()), csv(c.getCampaignType()), csv(c.getStatus()),
                        c.getUsedCount(), c.getUsageLimit() == null ? "" : c.getUsageLimit().toString(),
                        c.getStartDate(), c.getEndDate());
            }
        }
    }

    private void exportPrintReport(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = parseInt(request.getParameter("id"), 0);
        Campaign c = dao.getCampaignById(id);
        List<CampaignProduct> products = dao.getProductPerformance(id);
        NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        response.setContentType("text/html; charset=UTF-8");
        response.setHeader("Content-Disposition", "inline; filename=campaign-report.html");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html><html><head><meta charset='UTF-8'><title>Campaign Report</title>");
            out.println("<style>body{font-family:Arial;margin:32px;color:#111827}table{width:100%;border-collapse:collapse;margin-top:20px}th,td{border:1px solid #d1d5db;padding:10px;text-align:left}th{background:#111827;color:white}.right{text-align:right}</style>");
            out.println("</head><body onload='window.print()'>");
            if (c == null) {
                out.println("<h2>Không tìm thấy campaign</h2>");
            } else {
                out.println("<h1>Campaign Performance: " + html(c.getCampaignName()) + "</h1>");
                out.println("<p><b>Code:</b> " + html(c.getPromoCode()) + " | <b>Status:</b> " + html(c.getStatus()) + "</p>");
                out.println("<table><thead><tr><th>Product</th><th>SKU</th><th>Original</th><th>Sale</th><th>Units</th><th>Revenue</th><th>Status</th></tr></thead><tbody>");
                for (CampaignProduct p : products) {
                    out.println("<tr><td>" + html(p.getProductName()) + "</td><td>" + html(p.getSku()) + "</td><td class='right'>" + money.format(p.getOriginalPrice()) + "</td><td class='right'>" + money.format(p.getSalePrice()) + "</td><td class='right'>" + p.getUnitsSold() + "</td><td class='right'>" + money.format(p.getRevenue()) + "</td><td>" + html(p.getStatus()) + "</td></tr>");
                }
                out.println("</tbody></table>");
            }
            out.println("</body></html>");
        }
    }

    private void productJson(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        List<ProductSearchItem> products = dao.searchProducts(request.getParameter("keyword"), 0);
        response.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print("[");
            for (int i = 0; i < products.size(); i++) {
                ProductSearchItem p = products.get(i);
                if (i > 0) out.print(",");
                out.print("{\"variantId\":" + p.getVariantId()
                        + ",\"name\":\"" + json(p.getProductName()) + "\""
                        + ",\"variant\":\"" + json(p.getVariantName()) + "\""
                        + ",\"sku\":\"" + json(p.getSku()) + "\""
                        + ",\"category\":\"" + json(p.getCategoryName()) + "\""
                        + ",\"price\":" + p.getPrice()
                        + ",\"stock\":" + p.getStock() + "}");
            }
            out.print("]");
        }
    }

    private void generateCode(HttpServletResponse response) throws IOException {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        Random random = new Random();
        StringBuilder code = new StringBuilder("UNI");
        for (int i = 0; i < 6; i++) code.append(chars.charAt(random.nextInt(chars.length())));
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print("{\"code\":\"" + code + "\"}");
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, Exception e) throws ServletException, IOException {
        request.setAttribute("error", e.getMessage());
        request.getRequestDispatcher("/WEB-INF/views/admin/error.jsp").forward(request, response);
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String suffix) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/promotions" + suffix);
    }

    private String req(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try { return value == null || value.isBlank() ? defaultValue : Integer.parseInt(value); }
        catch (NumberFormatException e) { return defaultValue; }
    }

    private Integer parseNullableInt(String value) {
        try { return value == null || value.isBlank() ? null : Integer.parseInt(value); }
        catch (NumberFormatException e) { return null; }
    }

    private int[] parseIds(String[] values) {
        if (values == null) return new int[0];
        return java.util.Arrays.stream(values).mapToInt(v -> parseInt(v, 0)).filter(v -> v > 0).toArray();
    }

    private BigDecimal parseMoney(String value) {
        if (value == null || value.isBlank()) return BigDecimal.ZERO;
        try { return new BigDecimal(value.replace(",", "").trim()); }
        catch (NumberFormatException e) { return BigDecimal.ZERO; }
    }

    private LocalDateTime parseDateStart(String value) {
        if (value == null || value.isBlank()) return LocalDateTime.now().with(LocalTime.MIN);
        return LocalDate.parse(value).atStartOfDay();
    }

    private LocalDateTime parseDateEnd(String value) {
        if (value == null || value.isBlank()) return LocalDateTime.now().plusMonths(1).with(LocalTime.MAX);
        return LocalDate.parse(value).atTime(23, 59, 59);
    }

    private String csv(String value) {
        if (value == null) return "";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }

    private String enc(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private String html(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }

    private String json(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}

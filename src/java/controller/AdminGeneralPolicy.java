package controller;

import dal.GeneralPolicyDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GeneralPolicy;

@WebServlet(name = "AdminGeneralPolicy", urlPatterns = {"/admin/general-policy"})
public class AdminGeneralPolicy extends HttpServlet {

    private GeneralPolicyDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new GeneralPolicyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String tab = request.getParameter("tab");
            boolean isNewsTab = "news".equalsIgnoreCase(tab);

            // Đọc keyword từ search box (UC36.1 Alternative Flow 36.1.1)
            String keyword = request.getParameter("keyword");
            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

            List<GeneralPolicy> generalPolicies;
            if (isNewsTab) {
                generalPolicies = hasKeyword ? dao.getNewsArticles(keyword) : dao.getNewsArticles();
                request.setAttribute("activeTab", "NEWS");
            } else {
                generalPolicies = hasKeyword ? dao.getFooterDocPolicies(keyword) : dao.getFooterDocPolicies();
                request.setAttribute("activeTab", "FOOTER");
            }
            request.setAttribute("generalPolicies", generalPolicies);
            request.setAttribute("isFooterTab", true);

            // Trả keyword về JSP để giữ giá trị trong search box sau khi submit
            if (hasKeyword) {
                request.setAttribute("keyword", keyword.trim());
            }

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    GeneralPolicy selected = dao.getPolicyById(id);
                    request.setAttribute("selectedGeneralPolicy", selected);
                } catch (NumberFormatException ignored) {
                }
            } else if (generalPolicies != null && !generalPolicies.isEmpty()) {
                request.setAttribute("selectedGeneralPolicy", generalPolicies.get(0));
            }

            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi tải danh sách chính sách footer.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idParam = request.getParameter("policyId");

        String tab = request.getParameter("tab");
        String tabQuery = "news".equalsIgnoreCase(tab) ? "&tab=news" : "";
        String tabQueryClean = "news".equalsIgnoreCase(tab) ? "?tab=news" : "";

        if (idParam == null || idParam.trim().isEmpty()) {
            if ("create".equals(action)) {
                try {
                    String title = request.getParameter("title");
                    String policyType = request.getParameter("policyType");
                    String content = request.getParameter("content");

                    if (title == null || title.trim().isEmpty()) {
                        request.setAttribute("error", "Tiêu đề không được để trống!");
                        doGet(request, response);
                        return;
                    }

                    String showInFooterParam = request.getParameter("showInFooter");
                    boolean showInFooter = "true".equals(showInFooterParam);

                    int newId = dao.insertPolicy(title.trim(), policyType.trim(), content != null ? content.trim() : "", showInFooter);
                    if (newId > 0) {
                        response.sendRedirect(request.getContextPath() + "/admin/general-policy?id=" + newId + tabQuery);
                    } else {
                        request.setAttribute("error", "Tạo chính sách thất bại!");
                        doGet(request, response);
                    }
                } catch (Exception e) {
                    throw new ServletException("Lỗi tạo chính sách footer.", e);
                }
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/general-policy" + tabQueryClean);
            return;
        }

        try {
            int id = Integer.parseInt(idParam.trim());

            if ("updateContent".equals(action)) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");

                if (title == null || title.trim().isEmpty()) {
                    request.setAttribute("error", "Tiêu đề không được để trống!");
                    doGet(request, response);
                    return;
                }

                boolean success = dao.updateContent(id, title.trim(), content != null ? content.trim() : "");
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/general-policy?id=" + id + tabQuery);
                } else {
                    request.setAttribute("error", "Cập nhật nội dung thất bại!");
                    doGet(request, response);
                }

            } else if ("updateFooterSettings".equals(action)) {
                String showInFooterParam = request.getParameter("showInFooter");
                boolean showInFooter = showInFooterParam != null && (showInFooterParam.equals("true") || showInFooterParam.equals("on") || showInFooterParam.equals("1"));
                
                String orderParam = request.getParameter("footerOrder");
                int footerOrder = 0;
                if (orderParam != null && !orderParam.trim().isEmpty()) {
                    try {
                        footerOrder = Integer.parseInt(orderParam.trim());
                    } catch (NumberFormatException ignored) {
                    }
                }

                boolean success = dao.updateFooterSettings(id, showInFooter, footerOrder);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/general-policy?id=" + id + tabQuery);
                } else {
                    request.setAttribute("error", "Cập nhật cài đặt footer thất bại!");
                    doGet(request, response);
                }
            } else if ("delete".equals(action)) {
                boolean success = dao.deletePolicy(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/general-policy" + tabQueryClean);
                } else {
                    request.setAttribute("error", "Xóa chính sách thất bại!");
                    doGet(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/general-policy");
            }

        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý thao tác chính sách footer.", e);
        }
    }
}

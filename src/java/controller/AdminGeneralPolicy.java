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
            List<GeneralPolicy> generalPolicies = dao.getAllPolicies();
            request.setAttribute("generalPolicies", generalPolicies);
            request.setAttribute("isFooterTab", true);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    GeneralPolicy selected = dao.getPolicyById(id);
                    request.setAttribute("selectedGeneralPolicy", selected);
                } catch (NumberFormatException ignored) {
                }
            }

            request.getRequestDispatcher("/admin/PolicyManagement.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error loading general policies", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idParam = request.getParameter("policyId");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/general-policy");
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
                    response.sendRedirect(request.getContextPath() + "/admin/general-policy?id=" + id);
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
                    response.sendRedirect(request.getContextPath() + "/admin/general-policy?id=" + id);
                } else {
                    request.setAttribute("error", "Cập nhật cài đặt footer thất bại!");
                    doGet(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/general-policy");
            }

        } catch (Exception e) {
            throw new ServletException("Error executing action", e);
        }
    }
}

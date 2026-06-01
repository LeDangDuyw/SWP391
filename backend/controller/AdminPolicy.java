package controller;

import dao.PolicyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Region;
import model.WarrantyPolicy;

/**
 * AdminPolicy
 *
 * Purpose: Defines the AdminPolicy component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to AdminPolicy.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.3
 */
public class AdminPolicy extends HttpServlet {

    private PolicyDAO dao;

    @Override
    public void init() {
        dao = new PolicyDAO();
    }

    /* 
    GET – list / detail
    */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            //  Load all active regions for the multi-select dropdowns 
            List<Region> allRegions = dao.getAllActiveRegions();
            req.setAttribute("allRegions", allRegions);

            //  Search / filter
            String keyword      = req.getParameter("keyword");
            String statusFilter = req.getParameter("statusFilter");

            List<WarrantyPolicy> policies =
                    dao.searchPolicies(keyword, statusFilter);
            req.setAttribute("policies",     policies);
            req.setAttribute("keyword",      keyword     != null ? keyword      : "");
            req.setAttribute("statusFilter", statusFilter!= null ? statusFilter : "");

            // Optional: load a selected policy for the detail pane
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    WarrantyPolicy selected = dao.getPolicyById(id);
                    req.setAttribute("selectedPolicy", selected);
                } catch (NumberFormatException ignored) {
                    // bad id → no selection
                }
            }

            req.getRequestDispatcher("/Admin/PolicyManagement.jsp")
               .forward(req, res);

        } catch (Exception e) {
            throw new ServletException("Error loading policies", e);
        }
    }

    /*
        POST – create / update / delete / status changes 
    */
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action      = req.getParameter("action");
        String contextPath = req.getContextPath();

        try {
            switch (action == null ? "" : action) {

                // CREATE 
                case "create": {
                    String name = trimOrNull(req.getParameter("policyName"));

                    // Validate
                    String err = validateCreate(name, req);
                    if (err != null) {
                        sendJsonError(res, err);
                        return;
                    }

                    WarrantyPolicy p = buildFromRequest(req);
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    p.setStatus("DRAFT");
                    p.setCreatedAt(now);
                    p.setUpdatedAt(now);

                    List<Integer> regionIds = parseRegionIds(req);
                    dao.insertPolicy(p, regionIds);

                    sendJsonSuccess(res, "Policy created successfully.");
                    break;
                }

                // UPDATE 
                case "update": {
                    int id = parseId(req.getParameter("policyId"));
                    if (id <= 0) {
                        sendJsonError(res, "Invalid policy ID.");
                        return;
                    }

                    WarrantyPolicy existing = dao.getPolicyById(id);
                    if (existing == null) {
                        sendJsonError(res, "Policy not found.");
                        return;
                    }

                    String name = trimOrNull(req.getParameter("policyName"));
                    String err  = validateUpdate(name, id, req);
                    if (err != null) {
                        sendJsonError(res, err);
                        return;
                    }

                    applyFormToPolicy(existing, req);
                    List<Integer> regionIds = parseRegionIds(req);
                    dao.updatePolicy(existing, regionIds);

                    sendJsonSuccess(res, "Policy updated successfully.");
                    break;
                }

                //  DELETE 
                case "delete": {
                    int id = parseId(req.getParameter("policyId"));
                    if (id > 0) dao.deletePolicy(id);
                    res.sendRedirect(contextPath + "/admin/policy");
                    break;
                }

                // STATUS TRANSITIONS 
                case "publish": {
                    int id = parseId(req.getParameter("policyId"));
                    dao.publishPolicy(id);
                    res.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }
                case "saveDraft": {
                    int id = parseId(req.getParameter("policyId"));
                    dao.saveDraft(id);
                    res.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }
                case "disable": {
                    int id = parseId(req.getParameter("policyId"));
                    dao.disablePolicy(id);
                    res.sendRedirect(contextPath + "/admin/policy?id=" + id);
                    break;
                }

                default:
                    res.sendRedirect(contextPath + "/admin/policy");
            }

        } catch (NumberFormatException e) {
            throw new ServletException("Invalid numeric parameter", e);
        } catch (Exception e) {
            throw new ServletException("Error processing action: " + action, e);
        }
    }

    /**
     * Executes buildFromRequest.
     */
    private WarrantyPolicy buildFromRequest(HttpServletRequest req) {
        WarrantyPolicy p = new WarrantyPolicy();
        applyFormToPolicy(p, req);
        return p;
    }

    /**
     * Executes applyFormToPolicy.
     */
    private void applyFormToPolicy(WarrantyPolicy p, HttpServletRequest req) {
        p.setPolicyName   (trimOrEmpty(req.getParameter("policyName")));
        p.setDescription  (trimOrEmpty(req.getParameter("description")));
        p.setPolicyContent(req.getParameter("policyContent")); // raw HTML from CKEditor

        String wm = req.getParameter("warrantyMonths");
        p.setWarrantyMonths(wm != null && !wm.trim().isEmpty()
                ? Integer.parseInt(wm.trim()) : 0);

        String ver = trimOrNull(req.getParameter("version"));
        p.setVersion(ver != null ? ver : "v1.0");

        String effDate = req.getParameter("effectiveDate");
        p.setEffectiveDate(
            (effDate != null && !effDate.trim().isEmpty())
                ? Date.valueOf(effDate.trim())
                : new Date(System.currentTimeMillis())
        );

        String status = trimOrNull(req.getParameter("status"));
        if (status != null && !status.isEmpty()) {
            p.setStatus(status);
        }
    }

    /**
     * Executes parseRegionIds.
     */
    private List<Integer> parseRegionIds(HttpServletRequest req) {
        String[] vals = req.getParameterValues("regionIds");
        List<Integer> ids = new ArrayList<>();
        if (vals != null) {
            for (String v : vals) {
                try { ids.add(Integer.parseInt(v.trim())); }
                catch (NumberFormatException ignored) {}
            }
        }
        return ids;
    }

    
    // Validation
    
    /*
        Validate exist policy name when create new
    */
    private String validateCreate(String name, HttpServletRequest req) throws Exception {
        if (name == null || name.isEmpty())
            return "Policy Name is required.";
        String wmStr = req.getParameter("warrantyMonths");
        if (wmStr == null || wmStr.trim().isEmpty() || Integer.parseInt(wmStr.trim()) < 1)
            return "Warranty Months must be at least 1.";
        if (dao.isPolicyNameTakenForCreate(name))
            return "A policy named \"" + name + "\" already exists. Please use a different name.";
        return null; // valid
    }
    
    /*
        Validate exist policy name when edit
    */
    private String validateUpdate(String name, int ownerId,
                                  HttpServletRequest req) throws Exception {
        if (name == null || name.isEmpty())
            return "Policy Name is required.";
        String wmStr = req.getParameter("warrantyMonths");
        if (wmStr != null && !wmStr.trim().isEmpty()) {
            int wm = Integer.parseInt(wmStr.trim());
            if (wm < 1) return "Warranty Months must be at least 1.";
        }
        if (dao.isPolicyNameTakenByOther(name, ownerId))
            return "Another policy already uses the name \"" + name + "\". Please use a different name.";
        return null; // valid
    }

    // JSON response helpers 

    /**
     * Executes sendJsonError.
     */
    private void sendJsonError(HttpServletResponse res, String message)
            throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = res.getWriter()) {
            out.print("{\"success\":false,\"message\":\""
                    + escapeJson(message) + "\"}");
        }
    }

    /**
     * Executes sendJsonSuccess.
     */
    private void sendJsonSuccess(HttpServletResponse res, String message)
            throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = res.getWriter()) {
            out.print("{\"success\":true,\"message\":\""
                    + escapeJson(message) + "\"}");
        }
    }

    /*
        String utilities 
    */
    private String trimOrNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    private String trimOrEmpty(String s) {
        return (s == null) ? "" : s.trim();
    }

    private int parseId(String s) {
        try { return Integer.parseInt(s.trim()); }
        catch (Exception e) { return 0; }
    }

    /**
     * Executes escapeJson.
     */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    @Override
    public String getServletInfo() {
        return "AdminPolicyServlet – Warranty Policy CRUD (MVC v2)";
    }
}
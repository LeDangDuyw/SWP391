/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CampaignBannerDAO;
import dal.CategoryDAO;
import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import dal.FlashSaleProductDAO;
import dal.PageContentDAO;
import java.util.List;
import model.CampaignBanner;
import model.PageContent;

/**
 *
 * @author ASUS
 */
public class HomeServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HomeSeverlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeSeverlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO p = new ProductDAO();
        CategoryDAO c = new CategoryDAO();
        FlashSaleProductDAO fl = new FlashSaleProductDAO();
       CampaignBannerDAO bannerDAO = new CampaignBannerDAO();         
        PageContentDAO pg = new PageContentDAO();
        // hiển thị banner
        List<CampaignBanner> banners = bannerDAO.getHomeBanners();
        request.setAttribute("banners", banners);
        // hiển thị chính sách ở footer
        ArrayList<PageContent> footerPages = pg.getAllActivePages();
        request.setAttribute("footerPages", footerPages);
        // Sản phẩm bán chạy
        String bsTab = request.getParameter("bsTab");
        if (bsTab == null) {
            bsTab = "laptop";
        }
        request.setAttribute("bsTab", bsTab);

        switch (bsTab) {
            //Laptop
            case "laptop":
                request.setAttribute("products", p.getTopLapTop());
                break;
            //Chuột 
            case "chuot":
                request.setAttribute("products", p.getTopMouse());
                break;
            //Bàn Phím 
            default:
                request.setAttribute("products", p.getTopKeyboard());
        }

        //Sản phẩm mới 
        String newTab = request.getParameter("newTab");
        if (newTab == null) {
            newTab = "laptop";
        }
        request.setAttribute("newTab", newTab);

        switch (newTab) {
            //Laptop
            case "laptop":
                request.setAttribute("new_products", p.getNewLaptop());
                break;
            //Chuột 
            case "chuot":
                request.setAttribute("new_products", p.getNewMouse());
                break;
            //Bàn Phím 
            default:
                request.setAttribute("new_products", p.getNewKeyborad());
        }

        // Danh Mục Sản Phẩm 
        request.setAttribute("categories", c.getAllCategories());

        //FlashSale
        request.setAttribute("flashsale", fl.getAllFlashSaleProduct());

        request.getRequestDispatcher("customer/home.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

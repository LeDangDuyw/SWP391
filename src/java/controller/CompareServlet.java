/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import dal.ProductCompareDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import model.ProductCompareDTO;

/**
 *
 * @author MINHBQ
 */
@WebServlet("/compare")
public class CompareServlet extends HttpServlet {

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
            out.println("<title>Servlet CompareServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CompareServlet at " + request.getContextPath() + "</h1>");
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
       String action = request.getParameter("action");
       if(action == null){
         action = "view";
       }
       
       ProductCompareDAO compareDAO = new ProductCompareDAO();
         HttpSession session = request.getSession();
         
         
         List<Integer> compareList = (List<Integer>) session.getAttribute("compareList");
         if(compareList == null){
         compareList = new ArrayList<>();
         session.setAttribute("compareList", compareList);
         }
         
         String errorMess = null; 
         
         // xu ly cac hanh dong (add/remove/clear)
          if (action.equalsIgnoreCase("add")){
            errorMess = addProduct(request , compareList , compareDAO);
          }else if(action.equalsIgnoreCase("remove")){
            removeProduct(request, compareList);
          }
          else if(action.equalsIgnoreCase("clear")){
            clearList(compareList);
          }
          
          //fetch js 
          if(sendFetch(request , response , errorMess)){
          return ;
          }
          
          
          List<ProductCompareDTO> compareProductList  = new ArrayList<>();
          for(int id : compareList){
          ProductCompareDTO p = compareDAO.getProductCompareDatail(id);
           if(p != null){
           compareProductList.add(p);
           }
          }
          
          CategoryDAO categoryDAO = new CategoryDAO();
          request.setAttribute("categories", categoryDAO.getAllCategories());
          request.setAttribute("compareProducts", compareProductList);
          
          List<ProductCompareDTO> suggestProductList = compareDAO.getSuggestProductforCompare(compareList, 4);
          request.setAttribute("suggestProducts", suggestProductList);

          if(errorMess != null){

          
          request.setAttribute("error", errorMess);
          }
          
          
          
          request.getRequestDispatcher("customer/compareProducts.jsp").forward(request, response);
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
    
    
    private String addProduct(HttpServletRequest request, List<Integer> compareList, ProductCompareDAO compareDAO){
     try{
              int productID = Integer.parseInt(request.getParameter("id"));
              ProductCompareDTO newProduct = compareDAO.getProductCompareDatail(productID);
              
              if(newProduct == null){
               return "san pham khong ton tai ";
             
              }else if (compareList.contains(productID)){
                return null ; 
              }else if(compareList.size() >4 ){
                 return "chi co the toi da 4 san pham so sanh cung luc ";
                  
              }else{
              boolean isSameCategory = true ; 
              if(!compareList.isEmpty()){
              ProductCompareDTO firstProduct = compareDAO.getProductCompareDatail(compareList.get(0));
              if(firstProduct !=null && firstProduct.getCategoryId() != newProduct.getCategoryId()){
                 isSameCategory =false ; 
              }
              }
              if(!isSameCategory){
              return  "chi duoc so sanh cac san pham cung loai ";
              }
              else{
              compareList.add(productID);
             return null;
              }
              }
          
          } catch(NumberFormatException e){
           return "ma san pham khong hop le";
          }
          }
    
    
    private void removeProduct(HttpServletRequest request, List<Integer> compareList){
    try{
        int prodID = Integer.parseInt(request.getParameter("id"));
        compareList.remove(Integer.valueOf(prodID));
        
    }
    catch(NumberFormatException ignored){}
    }
    private void clearList(List<Integer> compareList){
    compareList.clear();
    }
    private  boolean sendFetch (HttpServletRequest request, HttpServletResponse response, String errorMess) throws IOException{
    String isFetch = request.getParameter("isFetch");
    if("true".equalsIgnoreCase(isFetch)){
    response.setContentType("text/plain;charset=UTF-8");
     try(java.io.PrintWriter out = response.getWriter()){
     if(errorMess != null){
     out.print(errorMess);
     }else{
     out.print("success");
     }
     out.flush();
     }
     return true;
    }
    return false;
    }
    }



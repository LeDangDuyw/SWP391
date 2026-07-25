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
 * Controller CompareServlet (/compare) - Quản Lý Tính Năng So Sánh Sản Phẩm
 * 
 * CHỨC NĂNG:
 * - Cho phép khách hàng chọn tối đa 4 sản phẩm cùng danh mục để so sánh thông số kỹ thuật (RAM, CPU, VGA, Màn hình, Giá...).
 * - Xử lý thêm sản phẩm vào danh sách so sánh trong Session (Action: add).
 * - Xử lý xóa sản phẩm khỏi danh sách so sánh (Action: remove).
 * - Xử lý làm sạch danh sách so sánh (Action: clear).
 * - Trả về kết quả thông báo lỗi/thành công qua AJAX fetch hoặc chuyển hướng trang.
 * - Lấy danh sách sản phẩm gợi ý tương tự để khách hàng có thể so sánh thêm.
 * 
 * LIÊN KẾT:
 * - DAO Layer: dal.ProductCompareDAO (Các hàm getProductCompareDatail, getSuggestProductforCompare), dal.CategoryDAO.
 * - View JSP: web/customer/compareProducts.jsp (Render bảng so sánh thông số kỹ thuật).
 * - Session Attribute: "compareList" (Lưu List<Integer> danh sách ID các sản phẩm đang được chọn so sánh).
 * - Data Model: model.ProductCompareDTO.
 */
@WebServlet("/compare")
public class CompareServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

    /**
     * Phương thức doGet: Xử lý hiển thị trang so sánh và các thao tác AJAX thêm/bớt sản phẩm so sánh.
     * 
     * CHỨC NĂNG:
     * 1. Đọc tham số action ("add", "remove", "clear", hoặc "view").
     * 2. Đọc danh sách compareList từ Session.
     * 3. Thực hiện thêm/xóa/làm sạch theo action yêu cầu.
     * 4. Nếu request gửi tham số isFetch=true -> Gọi sendFetch() để trả kết quả chuỗi Text cho AJAX JS.
     * 5. Duyệt danh sách ID -> Gọi ProductCompareDAO.getProductCompareDatail(id) lấy chi tiết thông số.
     * 6. Gọi ProductCompareDAO.getSuggestProductforCompare() lấy danh sách sản phẩm gợi ý.
     * 7. Forward dữ liệu sang JSP customer/compareProducts.jsp.
     * 
     * LIÊN KẾT:
     * - Web Endpoint: GET /compare
     * - View Frontend: web/customer/compareProducts.jsp
     * - DAO Methods: ProductCompareDAO.getProductCompareDatail(), getSuggestProductforCompare()
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       String action = request.getParameter("action");
       if (action == null) {
          action = "view";
       }
       
       ProductCompareDAO compareDAO = new ProductCompareDAO();
       HttpSession session = request.getSession();
       
       List<Integer> compareList = (List<Integer>) session.getAttribute("compareList");
       if (compareList == null) {
          compareList = new ArrayList<>();
          session.setAttribute("compareList", compareList);
       }
       
       String errorMess = null; 
       
       if (action.equalsIgnoreCase("add")) {
          errorMess = addProduct(request, compareList, compareDAO);
       } else if (action.equalsIgnoreCase("remove")) {
          removeProduct(request, compareList);
       } else if (action.equalsIgnoreCase("clear")) {
          clearList(compareList);
       }
       
       if (sendFetch(request, response, errorMess)) {
          return;
       }
       
       List<ProductCompareDTO> compareProductList = new ArrayList<>();
       for (int id : compareList) {
          ProductCompareDTO p = compareDAO.getProductCompareDatail(id);
          if (p != null) {
             compareProductList.add(p);
          }
       }
       
       CategoryDAO categoryDAO = new CategoryDAO();
       request.setAttribute("categories", categoryDAO.getAllCategories());
       request.setAttribute("compareProducts", compareProductList);
       
       List<ProductCompareDTO> suggestProductList = compareDAO.getSuggestProductforCompare(compareList, 4);
       request.setAttribute("suggestProducts", suggestProductList);

       if (errorMess != null) {
          request.setAttribute("error", errorMess);
       }
       
       request.getRequestDispatcher("customer/compareProducts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "CompareServlet Controller";
    }
    
    /**
     * CHỨC NĂNG: Thêm ID một sản phẩm mới vào danh sách so sánh trong Session.
     * KIỂM TRA RÀNG BUỘC:
     * - Sản phẩm phải tồn tại trong DB.
     * - Tối đa chỉ được chọn 4 sản phẩm so sánh cùng lúc.
     * - Tất cả sản phẩm trong bảng so sánh bắt buộc phải CÙNG DANH MỤC (Category ID).
     * 
     * LIÊN KẾT:
     * - Session: Attribute "compareList"
     * - DAO: ProductCompareDAO.getProductCompareDatail()
     * 
     * @param request Yêu cầu HTTP chứa tham số "id" của sản phẩm
     * @param compareList Danh sách ID sản phẩm hiện có
     * @param compareDAO Đối tượng DAO truy vấn
     * @return Thông báo lỗi dạng String nếu vi phạm điều kiện, hoặc null nếu thêm thành công
     */
    private String addProduct(HttpServletRequest request, List<Integer> compareList, ProductCompareDAO compareDAO) {
        try {
            int productID = Integer.parseInt(request.getParameter("id"));
            ProductCompareDTO newProduct = compareDAO.getProductCompareDatail(productID);
            
            if (newProduct == null) {
                return "Sản phẩm không tồn tại!";
            } else if (compareList.contains(productID)) {
                return null;
            } else if (compareList.size() >= 4) {
                return "Chỉ có thể so sánh tối đa 4 sản phẩm cùng lúc!";
            } else {
                boolean isSameCategory = true;
                if (!compareList.isEmpty()) {
                    ProductCompareDTO firstProduct = compareDAO.getProductCompareDatail(compareList.get(0));
                    if (firstProduct != null && firstProduct.getCategoryId() != newProduct.getCategoryId()) {
                        isSameCategory = false;
                    }
                }
                if (!isSameCategory) {
                    return "Chỉ được so sánh các sản phẩm cùng danh mục!";
                } else {
                    compareList.add(productID);
                    return null;
                }
            }
        } catch (NumberFormatException e) {
            return "Mã sản phẩm không hợp lệ!";
        }
    }
    
    /**
     * CHỨC NĂNG: Xóa một sản phẩm cụ thể khỏi danh sách so sánh trong Session.
     * LIÊN KẾT: Session Attribute "compareList"
     * 
     * @param request Yêu cầu HTTP chứa tham số "id" của sản phẩm cần loại bỏ
     * @param compareList Danh sách ID sản phẩm
     */
    private void removeProduct(HttpServletRequest request, List<Integer> compareList) {
        try {
            int prodID = Integer.parseInt(request.getParameter("id"));
            compareList.remove(Integer.valueOf(prodID));
        } catch (NumberFormatException ignored) {}
    }

    /**
     * CHỨC NĂNG: Xóa sạch tất cả sản phẩm khỏi danh sách so sánh trong Session.
     * LIÊN KẾT: Session Attribute "compareList"
     * 
     * @param compareList Danh sách ID sản phẩm cần làm trống
     */
    private void clearList(List<Integer> compareList) {
        compareList.clear();
    }

    /**
     * CHỨC NĂNG: Trả về kết quả thông báo dạng Plain-Text cho các yêu cầu gọi bằng AJAX Fetch từ Frontend JS.
     * LIÊN KẾT: Frontend JavaScript nút bấm So sánh sản phẩm tại trang danh sách/chi tiết sản phẩm.
     * 
     * @param request Yêu cầu HTTP (Kiểm tra tham số isFetch=true)
     * @param response Phản hồi HTTP
     * @param errorMess Thông báo lỗi (nếu có)
     * @return true nếu là request AJAX fetch và đã phản hồi xong
     */
    private boolean sendFetch(HttpServletRequest request, HttpServletResponse response, String errorMess) throws IOException {
        String isFetch = request.getParameter("isFetch");
        if ("true".equalsIgnoreCase(isFetch)) {
            response.setContentType("text/plain;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                if (errorMess != null) {
                    out.print(errorMess);
                } else {
                    out.print("success");
                }
                out.flush();
            }
            return true;
        }
        return false;
    }
}



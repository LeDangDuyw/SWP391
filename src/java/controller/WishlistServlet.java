package controller;

import dal.WishlistDAO;
import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.Wishlist;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist", "/WishlistServlet"})
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WishlistDAO wishlistDAO = new WishlistDAO();
        List<Wishlist> wishlistItems = wishlistDAO.getWishlistByUserId(user.getUserId());

        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("wishlistItems", wishlistItems);
        request.setAttribute("wishlistCount", wishlistItems.size());

        request.getRequestDispatcher("customer/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"status\":\"unauthorized\",\"message\":\"Vui lòng đăng nhập để lưu sản phẩm yêu thích!\"}");
            return;
        }

        WishlistDAO wishlistDAO = new WishlistDAO();

        if ("toggle".equals(action)) {
            try {
                int productId = Integer.parseInt(productIdStr);
                boolean isWishlisted = wishlistDAO.isWishlisted(user.getUserId(), productId);
                boolean success;
                String resultAction;

                if (isWishlisted) {
                    success = wishlistDAO.removeFromWishlist(user.getUserId(), productId);
                    resultAction = "removed";
                } else {
                    success = wishlistDAO.addToWishlist(user.getUserId(), productId);
                    resultAction = "added";
                }

                int newCount = wishlistDAO.getWishlistCount(user.getUserId());

                if (success) {
                    out.print("{\"status\":\"success\",\"action\":\"" + resultAction + "\",\"count\":" + newCount + "}");
                } else {
                    out.print("{\"status\":\"error\",\"message\":\"Không thể cập nhật danh sách yêu thích!\"}");
                }
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"Mã sản phẩm không hợp lệ!\"}");
            }
            return;
        }

        if ("remove".equals(action)) {
            try {
                int productId = Integer.parseInt(productIdStr);
                boolean success = wishlistDAO.removeFromWishlist(user.getUserId(), productId);
                int newCount = wishlistDAO.getWishlistCount(user.getUserId());

                if (success) {
                    out.print("{\"status\":\"success\",\"action\":\"removed\",\"count\":" + newCount + "}");
                } else {
                    out.print("{\"status\":\"error\",\"message\":\"Không thể xóa sản phẩm khỏi danh sách yêu thích!\"}");
                }
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"Mã sản phẩm không hợp lệ!\"}");
            }
            return;
        }

        if ("checkStatus".equals(action)) {
            try {
                int productId = Integer.parseInt(productIdStr);
                boolean isWishlisted = wishlistDAO.isWishlisted(user.getUserId(), productId);
                out.print("{\"status\":\"success\",\"isWishlisted\":" + isWishlisted + "}");
            } catch (Exception e) {
                out.print("{\"status\":\"error\",\"message\":\"Mã sản phẩm không hợp lệ!\"}");
            }
            return;
        }

        if ("getWishlistIds".equals(action)) {
            List<Wishlist> userWishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < userWishlist.size(); i++) {
                json.append(userWishlist.get(i).getProductId());
                if (i < userWishlist.size() - 1) json.append(",");
            }
            json.append("]");
            out.print("{\"status\":\"success\",\"ids\":" + json.toString() + "}");
            return;
        }

        out.print("{\"status\":\"error\",\"message\":\"Hành động không hợp lệ!\"}");
    }
}

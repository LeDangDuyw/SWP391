package dal;

import dal.DBContext;
import model.Users;
import utils.hashPasswordUtil;
import java.sql.*;

public class UserDAO extends DBContext {

    /*
     * Name: login
     * 
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Hàm này truy vấn vào cơ sở dữ liệu đẻ tìm người dùng theo email,
     * so sánh mật khẩu
     * với mật khẩu đã dc mã hóa(hash) trong database và trả về Users nếu khớp và
     * null nếu sai
     */
    public Users login(String email, String password) {
        String sql = "SELECT * FROM [User] WHERE email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                if (hashPasswordUtil.checkPassword(password, hashedPassword)) {
                    return new Users(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            hashedPassword,
                            rs.getString("status"),
                            rs.getInt("role_id"));
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    /*
     * Name: isEmailExist
     * 
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: check trùng email
     */
    public boolean isEmailExist(String email) {
        String sql = "SELECT * FROM [User] WHERE email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: isPhoneExist
     * 
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: check trùng số điện thoại
     */
    public boolean isPhoneExist(String phone) {
        String sql = "SELECT * FROM [User] WHERE phone = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: register
     * 
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Hàm này nhận thông tin người dùng , mã hóa mật khảu và thêm bản
     * ghi mới vào cơ sở dữ liệu
     */
    public boolean register(String userName, String email, String phone, String password) {
        String sql = "INSERT INTO [User] (full_name, email, phone, password, status, role_id) VALUES (?, ?, ?, ?, 'active', 3)";
        try {

            String hashedPassword = hashPasswordUtil.hashPassword(password);
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, hashedPassword);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: getUserByEmail
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này truy vấn cơ sở dữ liệu để tìm kiếm thông tin người dùng 
     * theo địa chỉ email và trả về đối tượng Users nếu tìm thấy.
     */
    public Users getUserByEmail(String email) {
        String sql = "SELECT * FROM [User] WHERE email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("status"),
                        rs.getInt("role_id"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    /*
     * Name: registerGoogleUser
     * @Author: LUCTVHE201874
     * Date: [04/06/2026]
     * Version: 1.0
     * Description: Hàm này đăng ký nhanh tài khoản người dùng đăng nhập bằng Google, 
     * gán vai trò mặc định là Khách hàng (role_id = 3) và trạng thái 'active'.
     */
    public boolean registerGoogleUser(String userName, String email) {
        String sql = "INSERT INTO [User] (full_name, email, phone, password, status, role_id) VALUES (?, ?, '', '', 'active', 3)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userName);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }
}

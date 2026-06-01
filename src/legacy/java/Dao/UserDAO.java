package Dao;

import Model.Users;
import util.hashPasswordUtil;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DBContext {

    /*
     * Name: login
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Hàm này truy cập CSDL để tìm tài khoản theo email, so khớp mật khẩu 
     * đã băm bằng BCrypt và trả về đối tượng Users nếu khớp, ngược lại trả về null.
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
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Kiểm tra email đã tồn tại trong hệ thống hay chưa.
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
     * Name: register
     * @Author: LUCTVHE201874
     * Date: [01/06/2026]
     * Version: 1.0
     * Description: Nhập thông tin người dùng, băm mật khẩu bằng BCrypt và lưu vào CSDL.
     * Mặc định đặt trạng thái là 'active' và vai trò là 3 (Customer).
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
}

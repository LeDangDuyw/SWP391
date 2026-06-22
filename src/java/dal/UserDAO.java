package dal;

import dal.DBContext;
import model.Users;
import utils.hashPasswordUtil;
import java.sql.*;
import java.util.ArrayList;

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
                            rs.getInt("role_id"),
                            rs.getString("avatar_url"));
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
                        rs.getInt("role_id"),
                        rs.getString("avatar_url"));
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

    /*
     * Name: updateProfile
     * @Author: LUCTVHE201874
     * Date: [21/06/2026]
     * Version: 1.0
     * Description: Cập nhật họ tên, số điện thoại và ảnh đại diện của người dùng.
     */
    public boolean updateProfile(int userId, String fullName, String phone, String avatarUrl) {
        String sql = "UPDATE [User] SET full_name = ?, phone = ?, avatar_url = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, avatarUrl);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: getUserById
     * @Author: LUCTVHE201874
     * Date: [21/06/2026]
     * Version: 1.0
     * Description: Tìm kiếm thông tin người dùng theo user_id.
     */
    public Users getUserById(int userId) {
        String sql = "SELECT * FROM [User] WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users u = new Users(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("status"),
                        rs.getInt("role_id"),
                        rs.getString("avatar_url"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    /*
     * Name: changePassword
     * @Author: LUCTVHE201874
     * Date: [21/06/2026]
     * Version: 1.0
     * Description: Cập nhật mật khẩu của người dùng sau khi đã xác minh mật khẩu cũ.
     *              Mật khẩu mới được mã hóa BCrypt trước khi lưu vào database.
     */
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE user_id = ?";
        try {
            String hashedNewPassword = hashPasswordUtil.hashPassword(newPassword);
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hashedNewPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: getTotalUsers
     * Description: Trả về tổng số lượng người dùng khớp với từ khóa tìm kiếm (họ tên hoặc email).
     */
    public int getTotalUsers(String search) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE (full_name LIKE ? OR email LIKE ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String keyword = "%" + (search == null ? "" : search.trim()) + "%";
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    /*
     * Name: getUsers
     * Description: Trả về danh sách người dùng được phân trang và lọc theo từ khóa tìm kiếm.
     */
    public ArrayList<Users> getUsers(String search, int offset, int limit) {
        ArrayList<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM [User] WHERE (full_name LIKE ? OR email LIKE ?) "
                   + "ORDER BY user_id ASC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String keyword = "%" + (search == null ? "" : search.trim()) + "%";
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("status"),
                        rs.getInt("role_id"),
                        rs.getString("avatar_url"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    /*
     * Name: updateRole
     * Description: Cập nhật vai trò (phân quyền) của người dùng.
     */
    public boolean updateRole(int userId, int roleId) {
        String sql = "UPDATE [User] SET role_id = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    /*
     * Name: updateStatus
     * Description: Khóa/Mở khóa tài khoản bằng cách cập nhật trạng thái (active/inactive).
     */
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE [User] SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }
}

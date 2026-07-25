package utils;

import org.mindrot.jbcrypt.BCrypt;

public class hashPasswordUtil {

    /*
 * Name: hashPassword
 * @Author: LUCTV
 * Date: [01/06/2026]
 * Version: 1.0
 * Description: Hàm này sử dụng thuật toán mã hóa BCrypt 
    để băm (hash) mật khẩu văn bản thô kèm theo chuỗi muối (salt) độ phức tạp 12 nhằm bảo mật thông tin trước khi lưu vào database.
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /*
 * Name: checkPassword
 * @Author: LUCTV
 * Date: [01/06/2026]
 * Version: 1.0
 * Description: Hàm này sử dụng BCrypt để so sánh mật khẩu người dùng vừa nhập (chưa mã hóa) 
    với mật khẩu đã được băm (hash) trong cơ sở dữ liệu xem có khớp nhau hay không.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        // Convert $2b$ and $2y$ prefixes to $2a$ for compatibility with classic Java jBCrypt
        if (hashedPassword.startsWith("$2b$")) {
            hashedPassword = "$2a$" + hashedPassword.substring(4);
        } else if (hashedPassword.startsWith("$2y$")) {
            hashedPassword = "$2a$" + hashedPassword.substring(4);
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Throwable e) {
            System.out.println("[hashPasswordUtil] BCrypt check error: " + e.getMessage());
            return false;
        }
    }

    /*
     * Name: isValidPassword
     * @Author: LUCTV
     * Date: [25/07/2026]
     * Version: 1.0
     * Description: Kiểm tra mật khẩu mạnh (tối thiểu 8 ký tự, có đủ chữ hoa, chữ thường, số và ký tự đặc biệt).
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        boolean hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
        for (char c : password.toCharArray()) {
            if (Character.isLowerCase(c)) hasLower = true;
            else if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isDigit(c)) hasDigit = true;
            else hasSpecial = true;
        }
        return hasLower && hasUpper && hasDigit && hasSpecial;
    }
}

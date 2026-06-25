package dal;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    protected Connection connection;
    public static String lastError = "";

    public DBContext() {
        try {
            Properties properties = new Properties();
            InputStream inputStream = getClass().getClassLoader()
                    .getResourceAsStream("ConnectDB.properties");

            if (inputStream == null) {
                throw new RuntimeException("Không tìm thấy file ConnectDB.properties");
            }

            properties.load(inputStream);

            String user = properties.getProperty("userID");
            String pass = properties.getProperty("password");
            String url = properties.getProperty("url");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);

        } catch (ClassNotFoundException | SQLException | IOException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            lastError = ex.getMessage();
        }
    }

    public DBContext(jakarta.servlet.ServletContext context) {
        this();
    }

    public Connection getConnection() {
        try {
            Properties properties = new Properties();
            InputStream inputStream = getClass().getClassLoader()
                    .getResourceAsStream("ConnectDB.properties");

            if (inputStream == null) {
                throw new RuntimeException("Không tìm thấy file ConnectDB.properties");
            }

            properties.load(inputStream);

            String user = properties.getProperty("userID");
            String pass = properties.getProperty("password");
            String url = properties.getProperty("url");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, user, pass);

        } catch (Exception ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    public static String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(input.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("MD5 error", e);
        }
    }
}
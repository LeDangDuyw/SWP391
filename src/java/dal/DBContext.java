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

/**
 * DBContext provides database connection and utility functions for all DAO
 * classes.
 *
 * Reads connection parameters from WEB-INF/ConnectDB.properties so credentials
 * are not hard-coded in source files. Falls back to hard-coded defaults only
 * when the properties file cannot be located (e.g. unit-test context).
 *
 * Version 1.5
 *
 * Author DuyLD / Project Team
 */
public class DBContext {


    private static final String FALLBACK_URL
            = "jdbc:sqlserver://localhost:1433;databaseName=UniLapWarrantyDB"
            + ";encrypt=true;trustServerCertificate=true;";
    private static final String FALLBACK_USER = "sa";
    private static final String FALLBACK_PASS = "1234";

    /**
     * Returns a new JDBC connection. Connection parameters are read from
     * WEB-INF/ConnectDB.properties; hard-coded fallback values are used when
     * the file cannot be found.
     */
    public Connection getConnection() {
        String url = FALLBACK_URL;
        String user = FALLBACK_USER;
        String pass = FALLBACK_PASS;

        try {
            InputStream is = getClass().getClassLoader()
                    .getResourceAsStream("../ConnectDB.properties");
            if (is != null) {
                Properties p = new Properties();
                p.load(is);
                url = p.getProperty("url", FALLBACK_URL);
                user = p.getProperty("userID", FALLBACK_USER);
                pass = p.getProperty("password", FALLBACK_PASS);
            }
        } catch (IOException ex) {
            Logger.getLogger(DBContext.class.getName())
                    .log(Level.WARNING, "ConnectDB.properties not found, using fallback", ex);
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            throw new RuntimeException("Cannot connect to database: " + ex.getMessage(), ex);
        }
    }

    /**
     * Returns the MD5 hash of the given input string as a hexadecimal string.
     */
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

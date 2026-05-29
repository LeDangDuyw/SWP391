package dao;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    // =========================
    // Database Configuration
    // =========================
    private static final String SERVER   = "localhost";
    private static final String PORT     = "1433";
    private static final String DATABASE = "UniLap";
    private static final String USER_DB  = "sa";
    private static final String PASSWORD = "1234";

    private static final String URL =
            "jdbc:sqlserver://" + SERVER + ":" + PORT
            + ";databaseName=" + DATABASE
            + ";encrypt=true"
            + ";trustServerCertificate=true;";

    // =========================
    // Get Connection
    // =========================
    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER_DB, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // MD5 Hash Function
    // =========================
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
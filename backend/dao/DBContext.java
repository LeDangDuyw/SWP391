package dao;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 * DBContext
 *
 * Purpose: Defines the DBContext component of the system.
 * Responsibilities:
 * - Encapsulates the behavior and data related to DBContext.
 * - Supports the application business logic according to Java coding conventions.
 *
 * Author: Project Team
 * Version: 1.0
 */
public class DBContext {

    // =========================
    // Database Configuration
    // =========================
    private static final String SERVER   = "localhost";
    private static final String PORT     = "1433";
    private static final String DATABASE = "UniLapWarrantyDB";
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
            // Propagate so callers (DAO try-with-resources) get a real error
            // instead of a NullPointerException that hides the root cause.
            throw new RuntimeException("Cannot connect to database: " + e.getMessage(), e);
        }
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
package dal;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

public class DBContext {
    private static final ThreadLocal<Connection> threadConnection = new ThreadLocal<>();
    protected Connection connection;
    public static String lastError = "";

    public DBContext() {
        try {
            Connection conn = threadConnection.get();
            if (conn == null || conn.isClosed()) {
                conn = createConnection();
                threadConnection.set(conn);
            }
            this.connection = conn;
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            lastError = ex.getMessage();
        }
    }

    public DBContext(jakarta.servlet.ServletContext context) {
        this();
    }

    private static Connection createConnection() {
        try {
            Properties properties = new Properties();
            InputStream inputStream = DBContext.class.getClassLoader().getResourceAsStream("ConnectDB.properties");
            if (inputStream == null) {
                inputStream = DBContext.class.getClassLoader().getResourceAsStream("../ConnectDB.properties");
            }
            if (inputStream != null) {
                properties.load(inputStream);
            }
            String user = properties.getProperty("userID");
            String pass = properties.getProperty("password");
            String url = properties.getProperty("url");
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            lastError = ex.getMessage();
            return null;
        }
    }

<<<<<<< Updated upstream
    
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author AI One
 */
public class DBContext {

    protected Connection connection;

    public DBContext() {

=======
    public Connection getConnection() {
        try {
            Connection conn = threadConnection.get();
            if (conn == null || conn.isClosed()) {
                conn = createConnection();
                threadConnection.set(conn);
            }
            return conn;
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            return createConnection();
        }
    }

    public static void closeThreadConnection() {
        Connection conn = threadConnection.get();
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                threadConnection.remove();
            }
        }
    }

    public static String md5(String input) {
>>>>>>> Stashed changes
        try {
            
            String url = "jdbc:sqlserver://localhost:1433;databaseName=UniLap;encrypt=false;trustServerCertificate=true";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("❌ LOI KET NOI DATABASE: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
  
}

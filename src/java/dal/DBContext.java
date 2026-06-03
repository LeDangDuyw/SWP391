/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.servlet.ServletContext;

public class DBContext {

    protected Connection connection;
    public static String lastError = "";

    public DBContext(ServletContext context) {
        try {
            Properties properties = new Properties();

            InputStream inputStream = context.getResourceAsStream("/WEB-INF/ConnectDB.properties");

            if (inputStream == null) {
                throw new IOException("Không tìm thấy ConnectDB.properties trong WEB-INF.");
            }

            properties.load(inputStream);

            String user = properties.getProperty("userID");
            String pass = properties.getProperty("password");
            String url = properties.getProperty("url");

            System.out.println("DB URL = " + url);
            System.out.println("DB USER = " + user);

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            connection = DriverManager.getConnection(url, user, pass);

            System.out.println("Connect database success");

        } catch (ClassNotFoundException | SQLException | IOException ex) {
            connection = null;
            lastError = ex.getMessage();

            System.out.println("Connect database fail:");
            ex.printStackTrace();
        }
    }
}
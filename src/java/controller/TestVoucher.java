package controller;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

class TestDB extends DBContext {
    public Connection getConnection() {
        return this.connection;
    }
}

public class TestVoucher {
    public static void main(String[] args) {
        try {
            TestDB db = new TestDB();
            Connection conn = db.getConnection();
            if (conn == null) {
                System.out.println("Connection is null!");
                return;
            }

            String sql = "SELECT * FROM [Campaign] WHERE campaign_id = 10";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.sql.ResultSetMetaData meta = rs.getMetaData();
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        System.out.println(meta.getColumnName(i) + ": " + rs.getObject(i));
                    }
                } else {
                    System.out.println("Campaign ID 10 not found!");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

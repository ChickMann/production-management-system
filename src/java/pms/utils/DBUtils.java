package pms.utils;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils implements Serializable {

    private static final String DB_NAME = "FactoryERD";
    private static final String DB_USER_NAME = "SA";
    private static final String DB_PASSWORD = "12345";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=" + DB_NAME;
        return DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
    }
    
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        System.out.println(DBUtils.getConnection());
    }
}

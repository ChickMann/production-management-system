package pms.utils;

import java.io.Serializable;
import java.security.Security;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils implements Serializable {

    private static final String DB_NAME = "FactoryERD";
    private static final String DB_USER_NAME = "SA";
    private static final String DB_PASSWORD = "12345";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        allowLegacySqlServerTls();

        // SQL Server local hiện đang ép SSL/TLS cũ.
        // Vẫn giữ encrypt=false, nhưng cần mở lại TLSv1/TLSv1.1 ở JVM để driver cũ có thể bắt tay.
        String url = "jdbc:sqlserver://localhost:1433;"
                + "databaseName=" + DB_NAME + ";"
                + "encrypt=false;"
                + "trustServerCertificate=true;";

        return DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
    }

    private static void allowLegacySqlServerTls() {
        System.setProperty("jdk.tls.client.protocols", "TLSv1,TLSv1.1,TLSv1.2");
        System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");

        String disabledAlgorithms = Security.getProperty("jdk.tls.disabledAlgorithms");
        if (disabledAlgorithms != null) {
            String updatedAlgorithms = disabledAlgorithms
                    .replace("TLSv1, ", "")
                    .replace(", TLSv1", "")
                    .replace("TLSv1", "")
                    .replace("TLSv1.1, ", "")
                    .replace(", TLSv1.1", "")
                    .replace("TLSv1.1", "")
                    .replace(", ,", ",")
                    .trim();

            if (updatedAlgorithms.endsWith(",")) {
                updatedAlgorithms = updatedAlgorithms.substring(0, updatedAlgorithms.length() - 1).trim();
            }

            Security.setProperty("jdk.tls.disabledAlgorithms", updatedAlgorithms);
        }
    }
}

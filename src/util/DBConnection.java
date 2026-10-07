package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Reusable JDBC connection class for Oracle.
 * Change URL / USER / PASSWORD below if your setup is different.
 */
public class DBConnection {

    private static final String DRIVER = "oracle.jdbc.OracleDriver";

    // Oracle XE 11g (SID = XE) -> use this line on this machine:
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    // Oracle XE 18c / 21c (service name XEPDB1) -> comment the line above and use:
    // private static final String URL = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";

    private static final String USER = "student_mgmt";
    private static final String PASSWORD = "student123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC driver not found. Put ojdbc jar in WebContent/WEB-INF/lib", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

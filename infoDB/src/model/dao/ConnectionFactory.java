package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 
 * @author Fábio Fernandes
 * @version 1.0
 */
public class ConnectionFactory {

    /**
     * 
     */
    private static Connection connection;

    /**
     * Abre uma connection.
     * 
     * @param url
     * @param username
     * @param password
     * @param driver 
     */
    public static void openConnection(String url, String username, String password, String driver) {
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * Fecha uma connection.
     */
    public static void closeConnection() {
        try {
            connection.close();
        } catch (SQLException e) {            
            throw new RuntimeException(e);
        }
    }

    /**
     * Recupera uma connection.
     * 
     * @return connection
     */
    public static Connection getConnection() {
        return connection;
    }
    
}
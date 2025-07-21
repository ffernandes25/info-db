package controller;

import model.dao.ConnectionFactory;
import model.service.error.ErrorMessage;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateConnectionController {

    /**
     * Estabelece uma conexão com a base de dados.
     *
     * @param database
     * @param host
     * @param port
     * @param schema
     * @param username
     * @param password
     */
    public void generate(String database, String host, String port, String schema, String username, String password) {
        try {
            String driver = "";
            String url = "";
            switch (database) {
                case "MySQL":
                    driver = "com.mysql.cj.jdbc.Driver";
                    url = "jdbc:mysql://".concat(host).concat(":").concat(port).concat("/").concat(schema);
                    break;
                case "Oracle":
                    driver = "oracle.jdbc.driver.OracleDriver";
                    url = "jdbc:oracle:thin:@".concat(host).concat(":").concat(port).concat("/").concat(schema);
                    break;
            }
            ConnectionFactory.openConnection(url, username, password, driver);
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_CONNECT.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }
    
    /**
     * Fecha a conexão com a base de dados.
     */
    public void closeConnection() {
        ConnectionFactory.closeConnection();
    }

}
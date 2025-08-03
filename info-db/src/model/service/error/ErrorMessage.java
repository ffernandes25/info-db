package model.service.error;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class ErrorMessage {
    
    /**
     * Error message: exceção gerada.
     */
    public static final String ERROR_EXCEPTION = "Error: ";
    
    /**
     * Error message: impossibilidade de conexão com a base de dados.
     */
    public static final String ERROR_CONNECT = "Could not connect!\n";
    
    /**
     * Error message: impossibilidade de carga de tableMetadata.
     */
    public static final String ERROR_TABLE_METADATA = "Could not load table metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de columnMetadata.
     */
    public static final String ERROR_COLUMN_METADATA = "Could not load column metadata!\n";
    
    /**
     * Error message: impossibilidade de geração de arquivo (bean).
     */
    public static final String ERROR_GENERATE_FILE = "Could not to generate file!\n";
    
}
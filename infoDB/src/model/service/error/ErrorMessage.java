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
    public static String ERROR_EXCEPTION = "Error: ";
    
    /**
     * Error message: impossibilidade de conexão com a base de dados.
     */
    public static String ERROR_CONNECT = "Could not connect!\n";
    
    /**
     * Error message: impossibilidade de carga de tableMetadata.
     */
    public static String ERROR_TABLE_METADATA = "Could not load table metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de columnMetadata.
     */
    public static String ERROR_COLUMN_METADATA = "Could not load column metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de storedProcedureMetadata.
     */
    public static String ERROR_STORED_PROCEDURE_METADATA = "Could not load stored procedure metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de storedProcedureParameterMetadata.
     */
    public static String ERROR_STORED_PROCEDURE_PARAMETER_METADATA = "Could not load stored procedure parameter metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de functionMetadata.
     */
    public static String ERROR_FUNCTION_METADATA = "Could not load function metadata!\n";
    
    /**
     * Error message: impossibilidade de carga de functionParameterMetadata.
     */
    public static String ERROR_FUNCTION_PARAMETER_METADATA = "Could not load function parameter metadata!\n";
    
    /**
     * Error message: impossibilidade de geração de arquivo (bean).
     */
    public static String ERROR_GENERATE_FILE = "Could not to generate file!\n";
    
}
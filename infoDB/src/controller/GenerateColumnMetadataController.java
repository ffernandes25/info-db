package controller;

import java.util.List;
import model.entity.ColumnMetadata;
import model.service.ColumnMetadataService;
import model.service.error.ErrorMessage;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateColumnMetadataController {

    /**
     * Recupera uma lista de columnMetadata.
     * 
     * @param tableName nome da tabela.
     * @param database nome do banco de dados.
     * @return cmList lista de colunas vinculadas à tabela.
     */
    public List<ColumnMetadata> generate(String tableName, String database) {
        try {
            ColumnMetadataService cmService = new ColumnMetadataService();
            List<ColumnMetadata> cmList = cmService.getColumnMetadata(tableName, database);
            return cmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_COLUMN_METADATA.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
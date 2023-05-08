package br.com.controller;

import br.com.model.entity.ColumnMetadata;
import br.com.model.service.ColumnMetadataService;
import br.com.model.service.error.ErrorMessage;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateColumnMetadataController {

    /**
     * Recupera uma lista de columnMetadata.
     * 
     * @param tableName
     * @param database
     * @return cmList
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
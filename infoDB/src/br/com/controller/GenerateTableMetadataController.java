package br.com.controller;

import br.com.model.entity.TableMetadata;
import br.com.model.service.TableMetadataService;
import br.com.model.service.error.ErrorMessage;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateTableMetadataController {

    /**
     * Recupera uma lista de TableMetadata.
     * 
     * @return tmList
     */
    public List<TableMetadata> generate() {
        try {
            TableMetadataService tmService = new TableMetadataService();
            List<TableMetadata> tmList = tmService.getTableMetadata();
            return tmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_TABLE_METADATA.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
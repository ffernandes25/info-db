package controller;

import java.util.List;
import model.entity.TableMetadata;
import model.service.TableMetadataService;
import model.service.error.ErrorMessage;

/**
 * <p>A representação em UML desta classe pode ser vista no <strong>Diagrama de Classes</strong> abaixo:</p>
 * <p style="text-align: center"><img src="doc-files/GenerateTableMetadataController.png" alt="Diagrama de classe da GenerateTableMetadataController"></p>
 * 
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateTableMetadataController {

    /**
     * Recupera uma lista de TableMetadata.
     * 
     * @return tmList lista de tabelas.
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
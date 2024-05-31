package controller;

import model.entity.StoredProcedureMetadata;
import model.service.StoredProcedureMetadataService;
import model.service.error.ErrorMessage;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateStoredProcedureMetadataController {

    /**
     * Recupera uma lista de StoredProcedureMetadata.
     *
     * @return spmList
     */
    public List<StoredProcedureMetadata> generate() {
        try {
            StoredProcedureMetadataService spmService = new StoredProcedureMetadataService();
            List<StoredProcedureMetadata> spmList = spmService.getStoredProcedureMetadata();
            return spmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_STORED_PROCEDURE_METADATA.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
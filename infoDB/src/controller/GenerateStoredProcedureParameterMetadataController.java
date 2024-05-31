package controller;

import model.entity.StoredProcedureParameterMetadata;
import model.service.StoredProcedureParameterMetadataService;
import model.service.error.ErrorMessage;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateStoredProcedureParameterMetadataController {

    /**
     * Recupera uma lista de StoredProcedureParameterMetadata.
     *
     * @param storedProcedureName
     * @return sppmList
     */
    public List<StoredProcedureParameterMetadata> generate(String storedProcedureName) {
        try {
            StoredProcedureParameterMetadataService sppmService = new StoredProcedureParameterMetadataService();
            List<StoredProcedureParameterMetadata> sppmList = sppmService.getStoredProcedureParameterMetadata(storedProcedureName);
            return sppmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_STORED_PROCEDURE_PARAMETER_METADATA.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
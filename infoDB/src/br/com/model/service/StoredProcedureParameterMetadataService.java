package br.com.model.service;

import br.com.model.dao.StoredProcedureParameterMetadataDao;
import br.com.model.entity.StoredProcedureParameterMetadata;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class StoredProcedureParameterMetadataService {

    /**
     * Recupera uma lista de StoredProcedureParameterMetadata.
     *
     * @param storedProcedureName
     * @return sppmList
     */
    public List<StoredProcedureParameterMetadata> getStoredProcedureParameterMetadata(String storedProcedureName) {
        try {
            StoredProcedureParameterMetadataDao sppmDao = new StoredProcedureParameterMetadataDao();
            List<StoredProcedureParameterMetadata> sppmList = sppmDao.getStoredProcedureParameterMetadata(storedProcedureName);
            return sppmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

}
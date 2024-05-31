package model.service;

import model.dao.StoredProcedureMetadataDao;
import model.entity.StoredProcedureMetadata;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class StoredProcedureMetadataService {

    /**
     * Recupera uma lista de StoredProcedureMetadata.
     *
     * @return spmList
     */
    public List<StoredProcedureMetadata> getStoredProcedureMetadata() {
        try {
            StoredProcedureMetadataDao spmDao = new StoredProcedureMetadataDao();
            List<StoredProcedureMetadata> spmList = spmDao.getStoredProcedureMetadata();            
            spmList.sort(Comparator.comparing(StoredProcedureMetadata::getName));            
            return spmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

}
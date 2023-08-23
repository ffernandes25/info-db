package br.com.model.service;

import br.com.model.dao.FunctionMetadataDao;
import br.com.model.entity.FunctionMetadata;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class FunctionMetadataService {
    
    /**
     * Recupera uma lista de FunctionMetadata.
     *
     * @return fmList
     */
    public List<FunctionMetadata> getFunctionMetadata() {
        try {
            FunctionMetadataDao fmDao = new FunctionMetadataDao();
            List<FunctionMetadata> fmList = fmDao.getFunctionMetadata();            
            fmList.sort(Comparator.comparing(FunctionMetadata::getName));            
            return fmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }
    
}
package br.com.model.service;

import br.com.model.dao.FunctionParameterMetadataDao;
import br.com.model.entity.FunctionParameterMetadata;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class FunctionParameterMetadataService {

    /**
     * Recupera uma lista de FunctionParameterMetadata.
     *
     * @param functionName
     * @return fpmList
     */
    public List<FunctionParameterMetadata> getFunctionParameterMetadata(String functionName) {
        try {
            FunctionParameterMetadataDao fpmDao = new FunctionParameterMetadataDao();
            List<FunctionParameterMetadata> fpmList = fpmDao.getFunctionParameterMetadata(functionName);
            return fpmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

}
package model.service;

import model.dao.ColumnMetadataDao;
import model.entity.ColumnMetadata;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class ColumnMetadataService {

    /**
     * Recupera uma lista de ColumnMetadata.
     * 
     * @param tableName
     * @param database
     * @return cmList
     */
    public List<ColumnMetadata> getColumnMetadata(String tableName, String database) {
        try {
            ColumnMetadataDao cmDao = new ColumnMetadataDao();
            List<ColumnMetadata> cmList = cmDao.getColumnMetadata(tableName, database);
            return cmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

}
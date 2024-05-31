package model.service;

import model.dao.TableMetadataDao;
import model.entity.TableMetadata;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class TableMetadataService {

    /**
     * Recupera uma lista de TableMetadata.
     *
     * @return tmList
     */
    public List<TableMetadata> getTableMetadata() {
        try {
            TableMetadataDao tmDao = new TableMetadataDao();
            List<TableMetadata> tmList = tmDao.getTableMetadata();
            tmList.sort(Comparator.comparing(TableMetadata::getName));
            return tmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

}
package controller;

import model.entity.ColumnMetadata;
import model.service.BeanService;
import model.service.error.ErrorMessage;
import java.util.List;

/**
 * 
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateBeanController {

    /**
     * Gera um Bean.
     * 
     * @param tableName
     * @param cmList
     * @return generatedFilePath
     */
    public String generate(String tableName, List<ColumnMetadata> cmList) {
        try {
            BeanService bService = new BeanService();
            String generatedFilePath = bService.generateBean(tableName, cmList);
            return generatedFilePath;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_GENERATE_FILE.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
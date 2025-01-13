package controller;

import java.util.List;
import model.entity.ColumnMetadata;
import model.service.BeanService;
import model.service.error.ErrorMessage;

/**
 * Classe responsável por receber requisições da VIEW e repassar para a
 * camada MODEL.SERVICE: as requisições recebidas referem-se à geração de
 * arquivos JavaBeans, a partir de tabelas selecionadas na GUI.
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateBeanController {

    /**
     * Gera um JavaBean.
     *
     * @param tableName nome da tabela.
     * @param cmList lista de colunas vinculadas à tabela.
     * @return fileName - nome do arquivo gerado.
     */
    public String generate(String tableName, List<ColumnMetadata> cmList) {
        try {
            BeanService bService = new BeanService();
            String fileName = bService.generateBean(tableName, cmList);
            return fileName;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_GENERATE_FILE.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
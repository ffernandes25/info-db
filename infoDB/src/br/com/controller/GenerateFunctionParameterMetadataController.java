package br.com.controller;

import br.com.model.entity.FunctionParameterMetadata;
import br.com.model.service.FunctionParameterMetadataService;
import br.com.model.service.error.ErrorMessage;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateFunctionParameterMetadataController {

    /**
     * Recupera uma lista de FunctionParameterMetadata.
     *
     * @param functionName
     * @return fpmList
     */
    public List<FunctionParameterMetadata> generate(String functionName) {
        try {
            FunctionParameterMetadataService fpmService = new FunctionParameterMetadataService();
            List<FunctionParameterMetadata> fpmList = fpmService.getFunctionParameterMetadata(functionName);
            return fpmList;
        } catch (RuntimeException e) {
            throw new RuntimeException(ErrorMessage.ERROR_FUNCTION_PARAMETER_METADATA.concat(ErrorMessage.ERROR_EXCEPTION).concat(e.getMessage()));
        }
    }

}
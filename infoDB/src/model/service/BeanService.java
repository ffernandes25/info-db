package model.service;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import model.entity.ColumnMetadata;

/**
 * Classe responsável por gerar um JavaBean* a partir de tabelas de banco de
 * dados relacionais, tais como Oracle, MySQl, entre outros.
 *
 * JavaBean ou Bean é uma classe Java que segue a convenção: Ter um construtor
 * padrão público, explícito e sem arqumentos; Ter atributos privados, e ter
 * métodos acessores (setters e getters) para cada um destes; Ser uma classe
 * serializável.
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class BeanService {

    /**
     * Gera um Bean.
     *
     * @param tableName
     * @param columnMetadata
     * @return fileName
     */
    public String generateBean(String tableName, List<ColumnMetadata> columnMetadata) {
        List<String> attributeNames = generateAttributeNames(columnMetadata);
        List<String> attributeTypes = generateAttributeTypes(columnMetadata);
        List<String> importNames = generateImportNames(attributeTypes);
        String className = generateClassName(tableName);
        String classContent = generateClassContent(className, importNames, attributeNames, attributeTypes);
        String fileName = generateFile(className, classContent);
        return fileName;
    }

    /**
     * Gera (e recupera) uma lista de attributeNames a partir de uma lista de
     * columnMetadata informada.
     *
     * @param columnMetadata
     * @return attributeNames
     */
    public List<String> generateAttributeNames(List<ColumnMetadata> columnMetadata) {
        List<List<String>> separateNameAll = new ArrayList<>();
        for (int i = 0; i < columnMetadata.size(); i++) {
            List<String> separateName = new ArrayList<>(Arrays.asList(columnMetadata.get(i).getName().toLowerCase().split("_")));
            separateNameAll.add(separateName);
        }
        List<String> attributeNames = new ArrayList<>();
        String name = "";
        String nameInCamelCaseFormat = "";
        for (int i = 0; i < separateNameAll.size(); i++) {
            for (int j = 0; j < separateNameAll.get(i).size(); j++) {
                if (j > 0) {
                    String firstCharacter = separateNameAll.get(i).get(j).substring(0, 1).toUpperCase();
                    String lastCharacters = separateNameAll.get(i).get(j).substring(1);
                    name = name.concat(firstCharacter).concat(lastCharacters);
                }
                nameInCamelCaseFormat = separateNameAll.get(i).get(0).concat(name);
            }
            attributeNames.add(nameInCamelCaseFormat);
            name = "";
        }
        return attributeNames;
    }

    /**
     * Gera (e recupera) uma lista de attributeTypes a partir de uma lista de
     * columnMetadata informada.
     *
     * @param columnMetadata
     * @return attributeTypes
     */
    public List<String> generateAttributeTypes(List<ColumnMetadata> columnMetadata) {
        List<String> attributeTypes = new ArrayList<>();
        for (int i = 0; i < columnMetadata.size(); i++) {
            switch (columnMetadata.get(i).getDatatype()) {
                case "CHAR":
                case "VARCHAR2":
                case "NCHAR":
                case "NVARCHAR2":
                    attributeTypes.add("String");
                    break;
                case "NUMBER":
                    attributeTypes.add("Long");
                    break;
                case "FLOAT":
                    attributeTypes.add("Double");
                    break;
                case "DATE":
                    attributeTypes.add("LocalDate");
                    break;
            }
        }
        return attributeTypes;
    }

    /**
     * Gera (e recupera) uma lista de importNames a partir de uma lista de
     * attributeTypes informada.
     *
     * @param attributeTypes
     * @return importNames
     */
    public List<String> generateImportNames(List<String> attributeTypes) {
        List<String> importNames = new ArrayList<>();
        int countLocalDateImport = 0;
        for (int i = 0; i < attributeTypes.size(); i++) {
            switch (attributeTypes.get(i)) {
                case "LocalDate":
                    if (countLocalDateImport == 0) {
                        importNames.add("java.time.LocalDate");
                        countLocalDateImport++;
                    }
                    break;
            }
        }
        return importNames;
    }

    /**
     * Gera (e recupera) um className a partir de um tableName informado.
     *
     * @param tableName
     * @return className
     */
    public String generateClassName(String tableName) {
        List<String> separateTableName = Arrays.asList(tableName.toLowerCase().split("_"));
        String className = "";
        for (int i = 0; i < separateTableName.size(); i++) {
            String firstCharacter = separateTableName.get(i).substring(0, 1).toUpperCase();
            String lastCharacters = separateTableName.get(i).substring(1);
            className = className.concat(firstCharacter).concat(lastCharacters);
        }
        return className;
    }

    /**
     * Gera (e recupera) um classContent a partir de um className, além de
     * listas de importNames, attributeNames e attributeTypes informadas.
     *
     * @param className
     * @param importNames
     * @param attributeNames
     * @param attributeTypes
     * @return classContent
     */
    public String generateClassContent(String className, List<String> importNames, List<String> attributeNames, List<String> attributeTypes) {
        String classContent = "";
        classContent = classContent.concat("package model;\n\n");
        importNames.add("java.io.Serializable");
        Collections.sort(importNames);
        for (int i = 0; i < importNames.size(); i++) {
            classContent = classContent.concat("import ").concat(importNames.get(i)).concat(";\n");
        }
        classContent = classContent.concat("\npublic class ").concat(className).concat(" implements Serializable {\n\n");
        for (int i = 0; i < attributeNames.size(); i++) {
            classContent = classContent.concat("\tprivate ").concat(attributeTypes.get(i)).concat(" ").concat(attributeNames.get(i)).concat(";\n");
        }
        classContent = classContent.concat("\n\tpublic ").concat(className).concat("() {\n")
                .concat("\t}\n\n");
        for (int i = 0; i < attributeNames.size(); i++) {
            String firstCharacter = attributeNames.get(i).substring(0, 1).toUpperCase();
            String lastCharacters = attributeNames.get(i).substring(1);
            classContent = classContent.concat("\tpublic ").concat(attributeTypes.get(i)).concat(" get").concat(firstCharacter).concat(lastCharacters).concat("() {\n")
                    .concat("\t\treturn ").concat(attributeNames.get(i)).concat(";\n")
                    .concat("\t}\n\n");
            classContent = classContent.concat("\tpublic void set").concat(firstCharacter).concat(lastCharacters).concat("(").concat(attributeTypes.get(i)).concat(" ").concat(attributeNames.get(i)).concat(") {\n")
                    .concat("\t\tthis.").concat(attributeNames.get(i)).concat(" = ").concat(attributeNames.get(i)).concat(";\n")
                    .concat("\t}\n\n");
        }
        classContent = classContent.concat("}");
        return classContent;
    }

    /**
     * Gera um arquivo .java a partir de um className e classContent informados, ao fim, o caminho
     * do arquivo é recuperado.
     *
     * @param className
     * @param classContent
     * @return fileName
     */
    public String generateFile(String className, String classContent) {
        String fileName = className.concat(".java");
        FileWriter file;
        try {
            file = new FileWriter(new File(fileName));
            file.write(classContent);
            file.close();
            return fileName;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}
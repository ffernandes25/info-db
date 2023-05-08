package br.com.model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class ColumnMetadata implements Serializable {

    /**
     * Nome da coluna.
     */
    private String name;

    /**
     * Datatype da coluna.
     */
    private String datatype;

    /**
     * Tamanho da coluna.
     */
    private int size;

    /**
     * Coluna pode ser nula ? Yes | No.
     */
    private String nullable;

    /**
     * Coluna é auto-incrementada ? Yes | No.
     */
    private String autoIncrement;
    
    /**
     * Comentário da coluna.
     */
    private String comment;

    /**
     *
     */
    public ColumnMetadata() {
    }

    /**
     * Recupera o nome da coluna.
     * 
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome da coluna.
     * 
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o datatype da coluna.
     * 
     * @return datatype
     */
    public String getDatatype() {
        return datatype;
    }

    /**
     * Define o datatype da coluna.
     * 
     * @param datatype
     */
    public void setDatatype(String datatype) {
        this.datatype = datatype;
    }

    /**
     * Recupera o tamanho da coluna.
     * 
     * @return size
     */
    public int getSize() {
        return size;
    }

    /**
     * Define o tamanho da coluna.
     * 
     * @param size
     */
    public void setSize(int size) {
        this.size = size;
    }

    /**
     * Recupera o estado anulável da coluna.
     * 
     * @return nullable
     */
    public String IsNullable() {
        return nullable;
    }

    /**
     * Define o estado anulável da coluna.
     * 
     * @param nullable
     */
    public void setIsNullable(String nullable) {
        this.nullable = nullable;
    }

    /**
     * Recupera o estado auto-incrementável da coluna.
     * 
     * @return autoIncrement
     */
    public String isAutoIncrement() {
        return autoIncrement;
    }

    /**
     * Define o estado auto-incrementável da coluna.
     * 
     * @param autoIncrement
     */
    public void setIsAutoIncrement(String autoIncrement) {
        this.autoIncrement = autoIncrement;
    }
    
    /**
     * Recupera o comentário da coluna.
     * 
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário da coluna.
     * 
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

}
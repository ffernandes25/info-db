package br.com.model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class TableMetadata implements Serializable {

    /**
     * Nome da tabela.
     */
    private String name;

    /**
     * Comentário da tabela.
     */
    private String comment;

    /**
     * 
     */
    public TableMetadata() {
    }

    /**
     * Recupera o nome da tabela.
     * 
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome da tabela.
     * 
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o comentário da tabela.
     * 
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário da tabela.
     * 
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

}
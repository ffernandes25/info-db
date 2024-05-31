package model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class StoredProcedureMetadata implements Serializable {

    /**
     * Nome da stored procedure.
     */
    private String name;

    /**
     * Tipo da stored procedure: retorno desconhecido,
     * com retorno de valor, com retorno de valor.
     */
    private String type;

    /**
     * Comentário da stored procedure.
     */
    private String comment;

    /**
     *
     */
    public StoredProcedureMetadata() {
    }

    /**
     * Recupera o nome da stored procedure.
     *
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome da stored procedure.
     *
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o tipo da stored procedure.
     *
     * @return type
     */
    public String getType() {
        return type;
    }

    /**
     * Define o tipo da stored procedure.
     *
     * @param type
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * Recupera o comentário da stored procedure.
     *
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário da stored procedure.
     *
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

}
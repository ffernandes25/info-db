package model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class FunctionMetadata implements Serializable {

    /**
     * Nome da function.
     */
    private String name;
    
    /**
     * Tipo da function.
     */
    private String type;
    
    /**
     * Comentário da function.
     */
    private String comment;

    /**
     * 
     */
    public FunctionMetadata() {
    }

    /**
     * Recupera o nome da function.
     * 
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome da function.
     * 
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o tipo da function.
     * 
     * @return type
     */
    public String getType() {
        return type;
    }

    /**
     * Define o tipo da function.
     * 
     * @param type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * Recupera o comentário da function.
     * 
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário da function.
     * 
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }
    
}
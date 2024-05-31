package model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class FunctionParameterMetadata implements Serializable {

    /**
     * Nome do parâmetro da function.
     */
    private String name;

    /**
     * Modo do parâmetro da function: Not Identified, IN, IN OUT, OUT,
     * Not applicable.
     */
    private String mode;

    /**
     * Datatype do parâmetro da function.
     */
    private String datatype;

    /**
     * Precisão do parâmetro da function.
     */
    private int precision;

    /**
     * Comprimento do parâmetro da function.
     */
    private int length;

    /**
     * Parâmetro da function pode ser nulo? YES, NO, Not Identified.
     */
    private String nullable;

    /**
     * Comentário do parâmetro da function.
     */
    private String comment;

    /**
     *
     */
    public FunctionParameterMetadata() {
    }

    /**
     * Recupera o nome do parâmetro da function.
     *
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome do parâmetro da function.
     *
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o modo do parâmetro da function.
     *
     * @return type
     */
    public String getMode() {
        return mode;
    }

    /**
     * Define o modo do parâmetro da function.
     *
     * @param mode
     */
    public void setMode(String mode) {
        this.mode = mode;
    }

    /**
     * Recupera o datatype do parâmetro da function.
     *
     * @return datatype
     */
    public String getDatatype() {
        return datatype;
    }

    /**
     * Define o datatype do parâmetro da function.
     *
     * @param datatype
     */
    public void setDatatype(String datatype) {
        this.datatype = datatype;
    }

    /**
     * Recupera a precisão do parâmetro da function.
     *
     * @return precision
     */
    public int getPrecision() {
        return precision;
    }

    /**
     * Define a precisão do parâmetro da function.
     *
     * @param precision
     */
    public void setPrecision(int precision) {
        this.precision = precision;
    }

    /**
     * Recupera o comprimento do parâmetro da function.
     *
     * @return length
     */
    public int getLength() {
        return length;
    }

    /**
     * Define o comprimento do parâmetro da function.
     *
     * @param length
     */
    public void setLength(int length) {
        this.length = length;
    }

    /**
     * Recupera o estado anulável do parâmetro da function.
     *
     * @return nullable
     */
    public String isNullable() {
        return nullable;
    }

    /**
     * Define o estado anulável do parâmetro da function.
     *
     * @param nullable
     */
    public void setIsNullable(String nullable) {
        this.nullable = nullable;
    }

    /**
     * Recupera o comentário do parâmetro da function.
     *
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário do parâmetro da function.
     *
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

}
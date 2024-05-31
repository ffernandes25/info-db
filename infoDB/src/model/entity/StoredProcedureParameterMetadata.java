package model.entity;

import java.io.Serializable;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class StoredProcedureParameterMetadata implements Serializable {

    /**
     * Nome do parâmetro da stored procedure.
     */
    private String name;

    /**
     * Modo do parâmetro da stored procedure: Not Identified, IN, IN OUT, OUT,
     * Not applicable.
     */
    private String mode;

    /**
     * Datatype do parâmetro da stored procedure.
     */
    private String datatype;

    /**
     * Precisão do parâmetro da stored procedure.
     */
    private int precision;

    /**
     * Comprimento do parâmetro da stored procedure.
     */
    private int length;

    /**
     * Parâmetro da stored procedure pode ser nulo? YES, NO, Not Identified.
     */
    private String nullable;

    /**
     * Comentário do parâmetro da stored procedure.
     */
    private String comment;

    /**
     *
     */
    public StoredProcedureParameterMetadata() {
    }

    /**
     * Recupera o nome do parâmetro da stored procedure.
     *
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Define o nome do parâmetro da stored procedure.
     *
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Recupera o modo do parâmetro da stored procedure.
     *
     * @return type
     */
    public String getMode() {
        return mode;
    }

    /**
     * Define o modo do parâmetro da stored procedure.
     *
     * @param mode
     */
    public void setMode(String mode) {
        this.mode = mode;
    }

    /**
     * Recupera o datatype do parâmetro da stored procedure.
     *
     * @return datatype
     */
    public String getDatatype() {
        return datatype;
    }

    /**
     * Define o datatype do parâmetro da stored procedure.
     *
     * @param datatype
     */
    public void setDatatype(String datatype) {
        this.datatype = datatype;
    }

    /**
     * Recupera a precisão do parâmetro da stored procedure.
     *
     * @return precision
     */
    public int getPrecision() {
        return precision;
    }

    /**
     * Define a precisão do parâmetro da stored procedure.
     *
     * @param precision
     */
    public void setPrecision(int precision) {
        this.precision = precision;
    }

    /**
     * Recupera o comprimento do parâmetro da stored procedure.
     *
     * @return length
     */
    public int getLength() {
        return length;
    }

    /**
     * Define o comprimento do parâmetro da stored procedure.
     *
     * @param length
     */
    public void setLength(int length) {
        this.length = length;
    }

    /**
     * Recupera o estado anulável do parâmetro da stored procedure.
     *
     * @return nullable
     */
    public String isNullable() {
        return nullable;
    }

    /**
     * Define o estado anulável do parâmetro da stored procedure.
     *
     * @param nullable
     */
    public void setIsNullable(String nullable) {
        this.nullable = nullable;
    }

    /**
     * Recupera o comentário do parâmetro da stored procedure.
     *
     * @return comment
     */
    public String getComment() {
        return comment;
    }

    /**
     * Define o comentário do parâmetro da stored procedure.
     *
     * @param comment
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

}
package br.com.model.dao;

import br.com.model.entity.StoredProcedureParameterMetadata;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class StoredProcedureParameterMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de StoredProcedureParameterMetadata.
     *
     * @param storedProcedureName
     * @return sppmList
     */
    public List<StoredProcedureParameterMetadata> getStoredProcedureParameterMetadata(String storedProcedureName) {
        try {
            List<StoredProcedureParameterMetadata> sppmList = new ArrayList<>();
            String type = "";
            String isNullable = "";
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getProcedureColumns(null, null, storedProcedureName, null);
            while (rs.next()) {
                StoredProcedureParameterMetadata sppm = new StoredProcedureParameterMetadata();
                sppm.setName(rs.getString("COLUMN_NAME"));
                switch (rs.getShort("COLUMN_TYPE")) {
                    case 0:
                        type = "Not Identified";
                        break;
                    case 1:
                        type = "IN";
                        break;
                    case 2:
                        type = "IN OUT";
                        break;
                    case 3:
                        type = "OUT";
                        break;
                    case 4:
                    case 5:
                        type = "Not applicable";
                        break;
                }
                sppm.setMode(type);
                sppm.setDatatype(rs.getString("TYPE_NAME"));
                sppm.setPrecision(rs.getInt("PRECISION"));
                sppm.setLength(rs.getInt("LENGTH"));
                switch (rs.getShort("NULLABLE")) {
                    case 0:
                        isNullable = "YES";
                        break;
                    case 1:
                        isNullable = "NO";
                        break;
                    case 2:
                        isNullable = "Not Identified";
                        break;
                }
                sppm.setIsNullable(isNullable);
                sppm.setComment(rs.getString("REMARKS") == null ? "Uninformed" : rs.getString("REMARKS"));
                sppmList.add(sppm);
            }
            return sppmList;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                rs.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

}
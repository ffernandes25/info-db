package model.dao;

import model.entity.FunctionParameterMetadata;
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
public class FunctionParameterMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de FunctionParameterMetadata.
     *
     * @param functionName
     * @return fpmList
     */
    public List<FunctionParameterMetadata> getFunctionParameterMetadata(String functionName) {
        try {
            List<FunctionParameterMetadata> fpmList = new ArrayList<>();
            String type = "";
            String isNullable = "";
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getFunctionColumns(null, null, functionName, null);
            while (rs.next()) {
                FunctionParameterMetadata fpm = new FunctionParameterMetadata();
                fpm.setName(rs.getString("COLUMN_NAME"));
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
                fpm.setMode(type);
                fpm.setDatatype(rs.getString("TYPE_NAME"));
                fpm.setPrecision(rs.getInt("PRECISION"));
                fpm.setLength(rs.getInt("LENGTH"));
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
                fpm.setIsNullable(isNullable);
                fpm.setComment(rs.getString("REMARKS") == null ? "Uninformed" : rs.getString("REMARKS"));
                fpmList.add(fpm);
            }
            return fpmList;
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
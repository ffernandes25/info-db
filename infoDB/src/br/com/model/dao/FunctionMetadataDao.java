package br.com.model.dao;

import br.com.model.entity.FunctionMetadata;
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
public class FunctionMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de FunctionMetadata.
     *
     * @return fmList
     */
    public List<FunctionMetadata> getFunctionMetadata() {
        try {
            List<FunctionMetadata> fmList = new ArrayList<>();
            String type = "";
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getFunctions(null, null, null);
            while (rs.next()) {
                FunctionMetadata fm = new FunctionMetadata();
                fm.setName(rs.getString("FUNCTION_NAME")); 
                switch (rs.getShort("FUNCTION_TYPE")) {
                    case 0:
                        type = "Cannot determine if a return value or table will be returned";
                        break;
                    case 1:
                        type = "Does not return a table";
                        break;
                    case 2:
                        type = "Returns a table";
                        break;
                }
                fm.setType(type);
                fm.setComment(rs.getString("REMARKS") == null ? "Uninformed" : rs.getString("REMARKS"));
                fmList.add(fm);
            }
            return fmList;
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
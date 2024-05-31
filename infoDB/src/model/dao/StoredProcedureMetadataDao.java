package model.dao;

import model.entity.StoredProcedureMetadata;
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
public class StoredProcedureMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de storedProcedureMetadata.
     *
     * @return spmList
     */
    public List<StoredProcedureMetadata> getStoredProcedureMetadata() {
        try {
            List<StoredProcedureMetadata> spmList = new ArrayList<>();
            String type = "";
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getProcedures(null, null, null);
            while (rs.next()) {
                StoredProcedureMetadata spm = new StoredProcedureMetadata();
                spm.setName(rs.getString("PROCEDURE_NAME"));
                switch (rs.getShort("PROCEDURE_TYPE")) {
                    case 0:
                        type = "Unable to determine whether there is a return value";
                        break;
                    case 1:
                        type = "No value return";
                        break;
                    case 2:
                        type = "With value return";
                        break;
                }
                spm.setType(type);
                spm.setComment(rs.getString("REMARKS"));
                spmList.add(spm);
            }
            return spmList;
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
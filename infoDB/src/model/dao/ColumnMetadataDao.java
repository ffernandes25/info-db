package model.dao;

import model.entity.ColumnMetadata;
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
public class ColumnMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de ColumnMetadata.
     *
     * @param tableName
     * @param database
     * @return cmList
     */
    public List<ColumnMetadata> getColumnMetadata(String tableName, String database) {
        try {
            List<ColumnMetadata> cmList = new ArrayList<>();
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getColumns(null, null, tableName, null);
            while (rs.next()) {
                ColumnMetadata cm = new ColumnMetadata();
                cm.setName(rs.getString("COLUMN_NAME"));
                cm.setDatatype(rs.getString("TYPE_NAME"));
                cm.setSize(rs.getInt("COLUMN_SIZE"));                
                cm.setIsNullable(rs.getString("IS_NULLABLE"));
                if (!database.equals("Oracle")) {
                    cm.setIsAutoIncrement(rs.getString("IS_AUTOINCREMENT"));
                }
                cm.setComment(rs.getString("REMARKS") == null ? "Uninformed" : rs.getString("REMARKS"));
                cmList.add(cm);
            }
            return cmList;
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
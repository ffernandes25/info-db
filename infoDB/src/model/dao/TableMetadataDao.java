package model.dao;

import model.entity.TableMetadata;
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
public class TableMetadataDao {

    /**
     *
     */
    private static DatabaseMetaData ds;

    /**
     *
     */
    private static ResultSet rs;

    /**
     * Recupera uma lista de TableMetadata.
     *
     * @return tmList
     */
    public List<TableMetadata> getTableMetadata() {
        try {
            List<TableMetadata> tmList = new ArrayList<>();
            ds = ConnectionFactory.getConnection().getMetaData();
            rs = ds.getTables(null, null, null, new String[]{"TABLE"});
            while (rs.next()) {
                TableMetadata tm = new TableMetadata();
                tm.setName(rs.getString("TABLE_NAME"));
                tm.setComment(rs.getString("REMARKS") == null ? "Uninformed" : rs.getString("REMARKS"));
                tmList.add(tm);
            }
            return tmList;
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
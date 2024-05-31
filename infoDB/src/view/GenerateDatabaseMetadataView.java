package view;

import controller.GenerateBeanController;
import controller.GenerateColumnMetadataController;
import controller.GenerateConnectionController;
import controller.GenerateFunctionMetadataController;
import controller.GenerateFunctionParameterMetadataController;
import controller.GenerateStoredProcedureMetadataController;
import controller.GenerateStoredProcedureParameterMetadataController;
import controller.GenerateTableMetadataController;
import model.entity.ColumnMetadata;
import model.entity.FunctionMetadata;
import model.entity.FunctionParameterMetadata;
import model.entity.StoredProcedureMetadata;
import model.entity.StoredProcedureParameterMetadata;
import model.entity.TableMetadata;
import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import java.awt.Font;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.util.List;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateDatabaseMetadataView extends JFrame {

    /**
     *
     */
    public GenerateDatabaseMetadataView() {
        initComponents();
    }

    /**
     *
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        scrollDatabaseMetadata = new javax.swing.JScrollPane();
        panelDatabaseMetadata = new javax.swing.JPanel();
        lblColumnMetadata = new javax.swing.JLabel();
        separatorColumnMetadata = new javax.swing.JSeparator();
        lblStoredProcedureParameterMetadata = new javax.swing.JLabel();
        separatorTableMetadata = new javax.swing.JSeparator();
        scrollTableMetadata = new javax.swing.JScrollPane();
        scrollColumnMetadata = new javax.swing.JScrollPane();
        btnLoadStoredProcedureParameterMetadata = new javax.swing.JButton();
        btnGenerateBean = new javax.swing.JButton();
        lblTableMetadata = new javax.swing.JLabel();
        lblFunctionParameterMetadata = new javax.swing.JLabel();
        separatorStoredProcedureMetadata = new javax.swing.JSeparator();
        separatorStoredProcedureParameterMetadata = new javax.swing.JSeparator();
        scrollStoredProcedureMetadata = new javax.swing.JScrollPane();
        scrollStoredProcedureParameterMetadata = new javax.swing.JScrollPane();
        btnLoadColumnMetadata = new javax.swing.JButton();
        btnLoadFunctionParameterMetadata = new javax.swing.JButton();
        btnLoadTableMetadata = new javax.swing.JButton();
        lblTableMetadataCount = new javax.swing.JLabel();
        lblColumnMetadataCount = new javax.swing.JLabel();
        lblFunctionParameterMetadataCount = new javax.swing.JLabel();
        lblStoredProcedureMetadata = new javax.swing.JLabel();
        lblFunctionMetadata = new javax.swing.JLabel();
        separatorFunctionMetadata = new javax.swing.JSeparator();
        separatorFunctionParameterMetadata = new javax.swing.JSeparator();
        scrollFunctionMetadata = new javax.swing.JScrollPane();
        scrollFunctionParameterMetadata = new javax.swing.JScrollPane();
        lblStoredProcedureMetadataCount = new javax.swing.JLabel();
        lblStoredProcedureParameterMetadataCount = new javax.swing.JLabel();
        lblFunctionMetadataCount = new javax.swing.JLabel();
        btnLoadStoredProcedureMetadata1 = new javax.swing.JButton();
        btnLoadFunctionMetadata = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DO_NOTHING_ON_CLOSE);
        setTitle("infoDB");
        setName("frame"); // NOI18N
        setPreferredSize(new java.awt.Dimension(1205, 638));
        setResizable(false);
        setSize(new java.awt.Dimension(1205, 638));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });
        getContentPane().setLayout(null);

        scrollDatabaseMetadata.setBorder(null);
        scrollDatabaseMetadata.setViewportBorder(null);
        scrollDatabaseMetadata.setAlignmentX(0.0F);
        scrollDatabaseMetadata.setAlignmentY(0.0F);
        scrollDatabaseMetadata.setPreferredSize(new java.awt.Dimension(1190, 610));

        panelDatabaseMetadata.setAlignmentX(0.0F);
        panelDatabaseMetadata.setAlignmentY(0.0F);
        panelDatabaseMetadata.setMaximumSize(new java.awt.Dimension(0, 0));
        panelDatabaseMetadata.setPreferredSize(new java.awt.Dimension(1195, 900));
        panelDatabaseMetadata.setLayout(null);

        lblColumnMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblColumnMetadata.setText("Columns");
        lblColumnMetadata.setAlignmentY(0.0F);
        lblColumnMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblColumnMetadata);
        lblColumnMetadata.setBounds(600, 20, 560, 20);

        separatorColumnMetadata.setAlignmentX(0.0F);
        separatorColumnMetadata.setAlignmentY(0.0F);
        separatorColumnMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorColumnMetadata);
        separatorColumnMetadata.setBounds(600, 45, 560, 2);

        lblStoredProcedureParameterMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblStoredProcedureParameterMetadata.setText("Parameters");
        lblStoredProcedureParameterMetadata.setAlignmentY(0.0F);
        lblStoredProcedureParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblStoredProcedureParameterMetadata);
        lblStoredProcedureParameterMetadata.setBounds(600, 307, 560, 20);

        separatorTableMetadata.setAlignmentX(0.0F);
        separatorTableMetadata.setAlignmentY(0.0F);
        separatorTableMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorTableMetadata);
        separatorTableMetadata.setBounds(20, 45, 560, 2);

        scrollTableMetadata.setAlignmentX(0.0F);
        scrollTableMetadata.setAlignmentY(0.0F);
        scrollTableMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollTableMetadata);
        scrollTableMetadata.setBounds(20, 62, 560, 195);

        scrollColumnMetadata.setAlignmentX(0.0F);
        scrollColumnMetadata.setAlignmentY(0.0F);
        scrollColumnMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollColumnMetadata);
        scrollColumnMetadata.setBounds(600, 62, 560, 195);

        btnLoadStoredProcedureParameterMetadata.setText("Load");
        btnLoadStoredProcedureParameterMetadata.setAlignmentY(0.0F);
        btnLoadStoredProcedureParameterMetadata.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnLoadStoredProcedureParameterMetadata.setEnabled(false);
        btnLoadStoredProcedureParameterMetadata.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadStoredProcedureParameterMetadata.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadStoredProcedureParameterMetadataActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadStoredProcedureParameterMetadata);
        btnLoadStoredProcedureParameterMetadata.setBounds(1081, 554, 79, 28);

        btnGenerateBean.setText("Generate Bean");
        btnGenerateBean.setAlignmentY(0.0F);
        btnGenerateBean.setEnabled(false);
        btnGenerateBean.setPreferredSize(new java.awt.Dimension(120, 28));
        btnGenerateBean.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGenerateBeanActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnGenerateBean);
        btnGenerateBean.setBounds(371, 267, 120, 28);

        lblTableMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblTableMetadata.setText("Tables");
        lblTableMetadata.setAlignmentY(0.0F);
        lblTableMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblTableMetadata);
        lblTableMetadata.setBounds(20, 20, 560, 20);

        lblFunctionParameterMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblFunctionParameterMetadata.setText("Parameters");
        lblFunctionParameterMetadata.setAlignmentY(0.0F);
        lblFunctionParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblFunctionParameterMetadata);
        lblFunctionParameterMetadata.setBounds(600, 594, 560, 20);

        separatorStoredProcedureMetadata.setAlignmentX(0.0F);
        separatorStoredProcedureMetadata.setAlignmentY(0.0F);
        separatorStoredProcedureMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorStoredProcedureMetadata);
        separatorStoredProcedureMetadata.setBounds(20, 332, 560, 2);

        separatorStoredProcedureParameterMetadata.setAlignmentX(0.0F);
        separatorStoredProcedureParameterMetadata.setAlignmentY(0.0F);
        separatorStoredProcedureParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorStoredProcedureParameterMetadata);
        separatorStoredProcedureParameterMetadata.setBounds(600, 332, 560, 2);

        scrollStoredProcedureMetadata.setAlignmentX(0.0F);
        scrollStoredProcedureMetadata.setAlignmentY(0.0F);
        scrollStoredProcedureMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollStoredProcedureMetadata);
        scrollStoredProcedureMetadata.setBounds(20, 349, 560, 195);

        scrollStoredProcedureParameterMetadata.setAlignmentX(0.0F);
        scrollStoredProcedureParameterMetadata.setAlignmentY(0.0F);
        scrollStoredProcedureParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollStoredProcedureParameterMetadata);
        scrollStoredProcedureParameterMetadata.setBounds(600, 349, 560, 195);

        btnLoadColumnMetadata.setText("Load");
        btnLoadColumnMetadata.setAlignmentY(0.0F);
        btnLoadColumnMetadata.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btnLoadColumnMetadata.setEnabled(false);
        btnLoadColumnMetadata.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadColumnMetadata.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadColumnMetadataActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadColumnMetadata);
        btnLoadColumnMetadata.setBounds(1081, 267, 79, 28);

        btnLoadFunctionParameterMetadata.setText("Load");
        btnLoadFunctionParameterMetadata.setAlignmentY(0.0F);
        btnLoadFunctionParameterMetadata.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnLoadFunctionParameterMetadata.setEnabled(false);
        btnLoadFunctionParameterMetadata.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadFunctionParameterMetadata.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadFunctionParameterMetadataActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadFunctionParameterMetadata);
        btnLoadFunctionParameterMetadata.setBounds(1081, 841, 79, 28);

        btnLoadTableMetadata.setText("Load");
        btnLoadTableMetadata.setAlignmentY(0.0F);
        btnLoadTableMetadata.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnLoadTableMetadata.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadTableMetadata.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadTableMetadataActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadTableMetadata);
        btnLoadTableMetadata.setBounds(501, 267, 79, 28);

        lblTableMetadataCount.setAlignmentY(0.0F);
        lblTableMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblTableMetadataCount);
        lblTableMetadataCount.setBounds(20, 273, 75, 16);

        lblColumnMetadataCount.setAlignmentY(0.0F);
        lblColumnMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblColumnMetadataCount);
        lblColumnMetadataCount.setBounds(600, 273, 75, 16);

        lblFunctionParameterMetadataCount.setAlignmentY(0.0F);
        lblFunctionParameterMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblFunctionParameterMetadataCount);
        lblFunctionParameterMetadataCount.setBounds(600, 847, 75, 16);

        lblStoredProcedureMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblStoredProcedureMetadata.setText("Stored Procedures");
        lblStoredProcedureMetadata.setAlignmentY(0.0F);
        lblStoredProcedureMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblStoredProcedureMetadata);
        lblStoredProcedureMetadata.setBounds(20, 307, 560, 20);

        lblFunctionMetadata.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblFunctionMetadata.setText("Functions");
        lblFunctionMetadata.setAlignmentY(0.0F);
        lblFunctionMetadata.setPreferredSize(new java.awt.Dimension(560, 20));
        panelDatabaseMetadata.add(lblFunctionMetadata);
        lblFunctionMetadata.setBounds(20, 594, 560, 20);

        separatorFunctionMetadata.setAlignmentX(0.0F);
        separatorFunctionMetadata.setAlignmentY(0.0F);
        separatorFunctionMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorFunctionMetadata);
        separatorFunctionMetadata.setBounds(20, 619, 560, 2);

        separatorFunctionParameterMetadata.setAlignmentX(0.0F);
        separatorFunctionParameterMetadata.setAlignmentY(0.0F);
        separatorFunctionParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 2));
        panelDatabaseMetadata.add(separatorFunctionParameterMetadata);
        separatorFunctionParameterMetadata.setBounds(600, 619, 560, 2);

        scrollFunctionMetadata.setAlignmentX(0.0F);
        scrollFunctionMetadata.setAlignmentY(0.0F);
        scrollFunctionMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollFunctionMetadata);
        scrollFunctionMetadata.setBounds(20, 636, 560, 195);

        scrollFunctionParameterMetadata.setAlignmentX(0.0F);
        scrollFunctionParameterMetadata.setAlignmentY(0.0F);
        scrollFunctionParameterMetadata.setPreferredSize(new java.awt.Dimension(560, 195));
        panelDatabaseMetadata.add(scrollFunctionParameterMetadata);
        scrollFunctionParameterMetadata.setBounds(600, 636, 560, 195);

        lblStoredProcedureMetadataCount.setAlignmentY(0.0F);
        lblStoredProcedureMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblStoredProcedureMetadataCount);
        lblStoredProcedureMetadataCount.setBounds(20, 560, 75, 16);

        lblStoredProcedureParameterMetadataCount.setAlignmentY(0.0F);
        lblStoredProcedureParameterMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblStoredProcedureParameterMetadataCount);
        lblStoredProcedureParameterMetadataCount.setBounds(600, 560, 75, 16);

        lblFunctionMetadataCount.setAlignmentY(0.0F);
        lblFunctionMetadataCount.setPreferredSize(new java.awt.Dimension(75, 16));
        panelDatabaseMetadata.add(lblFunctionMetadataCount);
        lblFunctionMetadataCount.setBounds(20, 847, 75, 16);

        btnLoadStoredProcedureMetadata1.setText("Load");
        btnLoadStoredProcedureMetadata1.setAlignmentY(0.0F);
        btnLoadStoredProcedureMetadata1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnLoadStoredProcedureMetadata1.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadStoredProcedureMetadata1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadStoredProcedureMetadata1ActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadStoredProcedureMetadata1);
        btnLoadStoredProcedureMetadata1.setBounds(501, 554, 79, 28);

        btnLoadFunctionMetadata.setText("Load");
        btnLoadFunctionMetadata.setAlignmentY(0.0F);
        btnLoadFunctionMetadata.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnLoadFunctionMetadata.setPreferredSize(new java.awt.Dimension(79, 28));
        btnLoadFunctionMetadata.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLoadFunctionMetadataActionPerformed(evt);
            }
        });
        panelDatabaseMetadata.add(btnLoadFunctionMetadata);
        btnLoadFunctionMetadata.setBounds(501, 841, 79, 28);

        scrollDatabaseMetadata.setViewportView(panelDatabaseMetadata);

        getContentPane().add(scrollDatabaseMetadata);
        scrollDatabaseMetadata.setBounds(0, 0, 1190, 610);

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    /**
     * 
     * @param columnsTitle
     * @param metadata
     * @return 
     */
    private JTable getPopulatedTable(String columnsTitle[], List<?> metadata) {
        // Cria um modelo para a tabela
        DefaultTableModel dtModel = new DefaultTableModel();
        // Adiciona colunas ao modelo
        for (String columnTitle : columnsTitle) {
            dtModel.addColumn(columnTitle);
        }
        // Obtêm o nome da classe inferida da lista genérica
        String metadataClassName = metadata.get(0).getClass().getSimpleName();
        switch (metadataClassName) {
            // Preenche as linhas do modelo com os metadados conforme o seu respectivo tipo
            case "TableMetadata":
                for (TableMetadata tm : (List<TableMetadata>) metadata) {
                    dtModel.addRow(new Object[]{
                        tm.getName(), tm.getComment()
                    });
                }
                break;
            case "ColumnMetadata":
                for (ColumnMetadata cm : (List<ColumnMetadata>) metadata) {
                    if (!database.equals("Oracle")) {
                        dtModel.addRow(new Object[]{
                            cm.getName(), cm.getDatatype(), cm.getSize(), cm.IsNullable(), cm.isAutoIncrement(), cm.getComment()
                        });
                    } else {
                        dtModel.addRow(new Object[]{
                            cm.getName(), cm.getDatatype(), cm.getSize(), cm.IsNullable(), cm.getComment()
                        });
                    }
                }
                break;
            case "StoredProcedureMetadata":
                for (StoredProcedureMetadata spm : (List<StoredProcedureMetadata>) metadata) {
                    dtModel.addRow(new Object[]{
                        spm.getName(), spm.getType(), spm.getComment()
                    });
                }
                break;
            case "StoredProcedureParameterMetadata":
                for (StoredProcedureParameterMetadata sppm : (List<StoredProcedureParameterMetadata>) metadata) {
                    dtModel.addRow(new Object[]{
                        sppm.getName(), sppm.getMode(), sppm.getDatatype(), sppm.getPrecision(), sppm.getLength(), sppm.isNullable(), sppm.getComment()
                    });
                }
                break;
            case "FunctionMetadata":
                for (FunctionMetadata fm : (List<FunctionMetadata>) metadata) {
                    dtModel.addRow(new Object[]{
                        fm.getName(), fm.getType(), fm.getComment()
                    });
                }
                break;                
            case "FunctionParameterMetadata":
                for (FunctionParameterMetadata fpm : (List<FunctionParameterMetadata>) metadata) {
                    dtModel.addRow(new Object[]{
                        fpm.getName(), fpm.getMode(), fpm.getDatatype(), fpm.getPrecision(), fpm.getLength(), fpm.isNullable(), fpm.getComment()
                    });
                }
                break;
        }
        // Cria a tabela a partir do modelo (com a edição de células bloqueada)
        JTable tbl = new JTable(dtModel) {
            @Override
            public boolean isCellEditable(int rowIndex, int vColIndex) {
                return false;
            }
        };
        // Centraliza o conteúdo das células da tabela
        DefaultTableCellRenderer dtCellRender = new DefaultTableCellRenderer();
        dtCellRender.setHorizontalAlignment(SwingConstants.CENTER);
        for (int i = 0; i < columnsTitle.length; i++) {
            tbl.getColumnModel().getColumn(i).setCellRenderer(dtCellRender);
        }
        // Bloqueia a troca de posição entre as colunas da tabela
        tbl.getTableHeader().setReorderingAllowed(false);
        // Define negrito para as colunas de cabeçalho
        tbl.getTableHeader().setFont(dtCellRender.getFont().deriveFont(Font.BOLD));
        // Adiciona um ouvinte de eventos (do tipo Focus) à tabela
        tbl.addFocusListener(new FocusListener() {
            @Override
            public void focusGained(FocusEvent evt) {
                switch (metadataClassName) {
                    case "TableMetadata":
                        tableMetadataFocusGained(evt);
                        break;
                    case "StoredProcedureMetadata":
                        storedProcedureMetadataFocusGained(evt);
                        break;
                    case "FunctionMetadata":
                        functionMetadataFocusGained(evt);
                        break;
                }
            }
            @Override
            public void focusLost(FocusEvent e) {
            }
        });
        return tbl;
    }

    /**
     * 
     * @param evt 
     */
    private void tableMetadataFocusGained(FocusEvent evt) {
        // Habilita o botão de geração de Bean
        btnGenerateBean.setEnabled(true);
        // Habilita o botão de carga de Columns
        btnLoadColumnMetadata.setEnabled(true);
    }

    /**
     * 
     * @param evt 
     */
    private void storedProcedureMetadataFocusGained(FocusEvent evt) {
        // Habilita o botão de carga de StoredProcedureParameter
        btnLoadStoredProcedureParameterMetadata.setEnabled(true);
    }
    
    /**
     * 
     * @param evt 
     */
    private void functionMetadataFocusGained(FocusEvent evt) {
        // Habilita o botão de carga de FunctionParameter
        btnLoadFunctionParameterMetadata.setEnabled(true);
    }

    /**
     * 
     * @param evt 
     */
    private void btnLoadStoredProcedureParameterMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadStoredProcedureParameterMetadataActionPerformed
        try {
            // Obtêm o nome da stored procedure selecionada
            String storedProcedureNameSelected = tblStoredProcedureMetadata.getValueAt(tblStoredProcedureMetadata.getSelectedRow(), 0).toString();
            // Gera os metadados dos parâmetros das procedures
            GenerateStoredProcedureParameterMetadataController gsppmc = new GenerateStoredProcedureParameterMetadataController();
            List<StoredProcedureParameterMetadata> sppmList = gsppmc.generate(storedProcedureNameSelected);
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Mode", "Datatype", "Precision", "Length", "Is Nullable?", "Comment"};
            // Popula a tabela
            tblStoredProcedureParameterMetadata = getPopulatedTable(columnsTitle, sppmList);
            // Adiciona ao viewport a tabela populada
            scrollStoredProcedureParameterMetadata.setViewportView(tblStoredProcedureParameterMetadata);
            // Modifica o título, incluindo o nome da stored procedure
            lblStoredProcedureParameterMetadata.setText("Parameters: ".concat(storedProcedureNameSelected));
            // Seta a quantidade de registros
            lblStoredProcedureParameterMetadataCount.setText("Count: ".concat(String.valueOf(sppmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Stored procedure parameter metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadStoredProcedureParameterMetadataActionPerformed

    /**
     * 
     * @param evt 
     */
    private void btnGenerateBeanActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGenerateBeanActionPerformed
        try {
            // Obtêm o nome da tabela selecionada
            String tableNameSelected = tblTableMetadata.getValueAt(tblTableMetadata.getSelectedRow(), 0).toString();
            // Gera os metadados das colunas
            GenerateColumnMetadataController gcmc = new GenerateColumnMetadataController();
            List<ColumnMetadata> columnMetadata = gcmc.generate(tableNameSelected, database);
            // Gera o Bean
            GenerateBeanController gbc = new GenerateBeanController();
            String fileName = gbc.generate(tableNameSelected, columnMetadata);
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Generated file: ".concat(fileName), "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnGenerateBeanActionPerformed

    /**
     * 
     * @param evt 
     */
    private void btnLoadColumnMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadColumnMetadataActionPerformed
        try {
            // Obtêm o nome da tabela selecionada
            String tableNameSelected = tblTableMetadata.getValueAt(tblTableMetadata.getSelectedRow(), 0).toString();
            // Gera os metadados das colunas
            GenerateColumnMetadataController gcmc = new GenerateColumnMetadataController();
            List<ColumnMetadata> cmList = gcmc.generate(tableNameSelected, database);
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Datatype", "Size", "Is Nullable?", "Comment"};
            if (!database.equals("Oracle")) {
                columnsTitle[4] = "Is Auto Increment?";
                columnsTitle[5] = "Comment";
            }
            // Popula a tabela
            tblColumnMetadata = getPopulatedTable(columnsTitle, cmList);
            // Adiciona ao viewport a tabela populada
            scrollColumnMetadata.setViewportView(tblColumnMetadata);
            // Modifica o título, incluindo o nome da tabela
            lblColumnMetadata.setText("Columns: ".concat(tableNameSelected));
            // Seta a quantidade de registros
            lblColumnMetadataCount.setText("Count: ".concat(String.valueOf(cmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Column metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadColumnMetadataActionPerformed

    /**
     * 
     * @param evt 
     */
    private void btnLoadFunctionParameterMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadFunctionParameterMetadataActionPerformed
        try {
            // Obtêm o nome da function selecionada
            String functionNameSelected = tblFunctionMetadata.getValueAt(tblFunctionMetadata.getSelectedRow(), 0).toString();
            // Gera os metadados dos parâmetros das functions
            GenerateFunctionParameterMetadataController gfpmc = new GenerateFunctionParameterMetadataController();
            List<FunctionParameterMetadata> fpmList = gfpmc.generate(functionNameSelected);
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Mode", "Datatype", "Precision", "Length", "Is Nullable?", "Comment"};
            // Popula a tabela
            tblFunctionParameterMetadata = getPopulatedTable(columnsTitle, fpmList);
            // Adiciona ao viewport a tabela populada
            scrollFunctionParameterMetadata.setViewportView(tblFunctionParameterMetadata);
            // Modifica o título, incluindo o nome da function
            lblFunctionParameterMetadata.setText("Parameters: ".concat(functionNameSelected));
            // Seta a quantidade de registros
            lblFunctionParameterMetadataCount.setText("Count: ".concat(String.valueOf(fpmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Function parameter metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadFunctionParameterMetadataActionPerformed

    /**
     * 
     * @param evt 
     */
    private void btnLoadTableMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadTableMetadataActionPerformed
        try {
            // Gera os metadados das tabelas
            GenerateTableMetadataController gtmc = new GenerateTableMetadataController();
            List<TableMetadata> tmList = gtmc.generate();
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Comment"};
            // Popula a tabela
            tblTableMetadata = getPopulatedTable(columnsTitle, tmList);
            // Adiciona ao viewport a tabela populada
            scrollTableMetadata.setViewportView(tblTableMetadata);
            // Seta a quantidade de registros
            lblTableMetadataCount.setText("Count: ".concat(String.valueOf(tmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Table metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadTableMetadataActionPerformed

    /**
     * 
     * @param evt 
     */
    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        int i = JOptionPane.showConfirmDialog(null, "Do you really want to disconnect?", "", JOptionPane.YES_NO_OPTION);
        if (i == JOptionPane.YES_OPTION) {
            // Fecha a conexão com a base de dados
            gcc.closeConnection();
            // Encerra a aplicação
            System.exit(0);
        }
    }//GEN-LAST:event_formWindowClosing

    private void btnLoadStoredProcedureMetadata1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadStoredProcedureMetadata1ActionPerformed
        try {
            // Gera os metadados das stored procedures
            GenerateStoredProcedureMetadataController gtmc = new GenerateStoredProcedureMetadataController();
            List<StoredProcedureMetadata> spmList = gtmc.generate();
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Type", "Comment"};
            // Popula a tabela
            tblStoredProcedureMetadata = getPopulatedTable(columnsTitle, spmList);
            // Adiciona ao viewport a tabela populada
            scrollStoredProcedureMetadata.setViewportView(tblStoredProcedureMetadata);
            // Seta a quantidade de registros
            lblStoredProcedureMetadataCount.setText("Count: ".concat(String.valueOf(spmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Stored procedure metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadStoredProcedureMetadata1ActionPerformed

    private void btnLoadFunctionMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLoadFunctionMetadataActionPerformed
        try {
            // Gera os metadados das functions
            GenerateFunctionMetadataController gfmc = new GenerateFunctionMetadataController();
            List<FunctionMetadata> fmList = gfmc.generate();
            // Define o nome das colunas
            String columnsTitle[] = {"Name", "Type", "Comment"};
            // Popula a tabela            
            tblFunctionMetadata = getPopulatedTable(columnsTitle, fmList);
            // Adiciona ao viewport a tabela populada
            scrollFunctionMetadata.setViewportView(tblFunctionMetadata);
            // Seta a quantidade de registros
            lblFunctionMetadataCount.setText("Count: ".concat(String.valueOf(fmList.size())));
            // Emite um alerta de sucesso
            JOptionPane.showMessageDialog(null, "Function metadata has been loaded!", "", JOptionPane.INFORMATION_MESSAGE);
        } catch (RuntimeException e) {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_btnLoadFunctionMetadataActionPerformed

    /**
     * 
     * @param dbName
     * @param gcController 
     */
    public static void main(String dbName, GenerateConnectionController gcController) {
        try {
            database = dbName;
            gcc = gcController;
            // Define o Look and Feel (https://www.formdev.com/flatlaf/)
            UIManager.setLookAndFeel(new FlatMacDarkLaf());
            // Define texto padrão para os botões
            UIManager.put("OptionPane.yesButtonText", "Yes");
            UIManager.put("OptionPane.noButtonText", "No");
            java.awt.EventQueue.invokeLater(() -> {
                // Instancia uma janela, tornando-a visível
                new GenerateDatabaseMetadataView().setVisible(true);
            });
        } catch (UnsupportedLookAndFeelException e) {
            throw new RuntimeException(e);
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnGenerateBean;
    private javax.swing.JButton btnLoadColumnMetadata;
    private javax.swing.JButton btnLoadFunctionMetadata;
    private javax.swing.JButton btnLoadFunctionParameterMetadata;
    private javax.swing.JButton btnLoadStoredProcedureMetadata1;
    private javax.swing.JButton btnLoadStoredProcedureParameterMetadata;
    private javax.swing.JButton btnLoadTableMetadata;
    private javax.swing.JLabel lblColumnMetadata;
    private javax.swing.JLabel lblColumnMetadataCount;
    private javax.swing.JLabel lblFunctionMetadata;
    private javax.swing.JLabel lblFunctionMetadataCount;
    private javax.swing.JLabel lblFunctionParameterMetadata;
    private javax.swing.JLabel lblFunctionParameterMetadataCount;
    private javax.swing.JLabel lblStoredProcedureMetadata;
    private javax.swing.JLabel lblStoredProcedureMetadataCount;
    private javax.swing.JLabel lblStoredProcedureParameterMetadata;
    private javax.swing.JLabel lblStoredProcedureParameterMetadataCount;
    private javax.swing.JLabel lblTableMetadata;
    private javax.swing.JLabel lblTableMetadataCount;
    private javax.swing.JPanel panelDatabaseMetadata;
    private javax.swing.JScrollPane scrollColumnMetadata;
    private javax.swing.JScrollPane scrollDatabaseMetadata;
    private javax.swing.JScrollPane scrollFunctionMetadata;
    private javax.swing.JScrollPane scrollFunctionParameterMetadata;
    private javax.swing.JScrollPane scrollStoredProcedureMetadata;
    private javax.swing.JScrollPane scrollStoredProcedureParameterMetadata;
    private javax.swing.JScrollPane scrollTableMetadata;
    private javax.swing.JSeparator separatorColumnMetadata;
    private javax.swing.JSeparator separatorFunctionMetadata;
    private javax.swing.JSeparator separatorFunctionParameterMetadata;
    private javax.swing.JSeparator separatorStoredProcedureMetadata;
    private javax.swing.JSeparator separatorStoredProcedureParameterMetadata;
    private javax.swing.JSeparator separatorTableMetadata;
    // End of variables declaration//GEN-END:variables
    private JTable tblTableMetadata;
    private JTable tblColumnMetadata;
    private JTable tblStoredProcedureMetadata;
    private JTable tblStoredProcedureParameterMetadata;
    private JTable tblFunctionMetadata;
    private JTable tblFunctionParameterMetadata;
    private static String database;
    private static GenerateConnectionController gcc;

}
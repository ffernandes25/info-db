package view;

import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import controller.GenerateBeanController;
import controller.GenerateColumnMetadataController;
import controller.GenerateConnectionController;
import controller.GenerateTableMetadataController;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.List;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.WindowConstants;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import model.entity.ColumnMetadata;
import model.entity.TableMetadata;

/**
 * Classe responsável por exibir uma interface gráfica que exibe os metadados de
 * tabelas e colunas de um banco de dados, permitindo ao usuário carregar essas
 * informações e gerar classes Java (Beans) a partir delas.
 * <p>A interface é composta por dois painéis principais: um para metadados de
 * tabelas e outro para colunas. Cada painel oferece opções para carregar os
 * dados e gerar arquivos.</p>
 * <p>A representação em UML desta classe pode ser vista no <strong>Diagrama de Classes</strong> abaixo:</p>
 * <p style="text-align: center"><img src="doc-files/GenerateDatabaseMetadataViewClassDiagram.png" alt="Diagrama de classe da GenerateDatabaseMetadataView"></p>
 * <p>Já a representação visual, na <strong>GUI</strong>:</p>
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateDatabaseMetadataView extends JFrame {

    private Cursor cursor;
    private JButton btnGenerateBean;
    private JButton btnLoadColumnMetadata;
    private JButton btnLoadTableMetadata;
    private JLabel lblColumnMetadata;
    private JLabel lblColumnMetadataCount;
    private JLabel lblTableMetadata;
    private JLabel lblTableMetadataCount;
    private JPanel panelDatabaseMetadata;
    private JScrollPane scrollColumnMetadata;
    private JScrollPane scrollTableMetadata;
    private JSeparator separatorColumnMetadata;
    private JSeparator separatorTableMetadata;
    private JTable tblTableMetadata;
    private JTable tblColumnMetadata;
    private static String database;
    private static GenerateConnectionController gcc;

    /**
     * Construtor padrão da classe. Inicializa os componentes da interface
     * gráfica.
     */
    public GenerateDatabaseMetadataView() {
        initComponents();
    }

    /**
     * Inicializa e configura todos os componentes gráficos da interface,
     * incluindo rótulos, botões, painéis, entre outros.
     * <p>
     * Define posicionamentos, estilos, modelos e eventos de ação associados.
     * </p>
     */
    private void initComponents() {
        cursor = new Cursor(Cursor.HAND_CURSOR);
        // JLabel: 'Tables'
        lblTableMetadata = new JLabel();
        lblTableMetadata.setFont(new Font("sansserif", Font.BOLD, 14));
        lblTableMetadata.setText("Tables");
        lblTableMetadata.setBounds(20, 20, 560, 20);
        // JSeparator
        separatorTableMetadata = new JSeparator();
        separatorTableMetadata.setBounds(20, 45, 560, 2);
        // JScrollPane
        scrollTableMetadata = new JScrollPane();
        scrollTableMetadata.setBounds(20, 62, 560, 195);
        // JLabel: 'Tables Count'
        lblTableMetadataCount = new JLabel();
        lblTableMetadataCount.setBounds(20, 273, 75, 16);
        // JButton: 'Generate Bean'
        btnGenerateBean = new JButton();
        btnGenerateBean.setText("Generate Bean");
        btnGenerateBean.setEnabled(false);
        btnGenerateBean.setBounds(371, 267, 120, 28);
        btnGenerateBean.addActionListener(evt -> btnGenerateBeanActionPerformed());
        // JButton: 'Load Tables'
        btnLoadTableMetadata = new JButton();
        btnLoadTableMetadata.setText("Load");
        btnLoadTableMetadata.setCursor(cursor);
        btnLoadTableMetadata.setBounds(501, 267, 79, 28);
        btnLoadTableMetadata.addActionListener(evt -> btnLoadTableMetadataActionPerformed());
        // JLabel: 'Columns'
        lblColumnMetadata = new JLabel();
        lblColumnMetadata.setFont(new Font("sansserif", Font.BOLD, 14));
        lblColumnMetadata.setText("Columns");
        lblColumnMetadata.setBounds(600, 20, 560, 20);
        // JSeparator
        separatorColumnMetadata = new JSeparator();
        separatorColumnMetadata.setBounds(600, 45, 560, 2);
        // JScrollPane
        scrollColumnMetadata = new JScrollPane();
        scrollColumnMetadata.setBounds(600, 62, 560, 195);
        // JLabel: 'Columns Count'
        lblColumnMetadataCount = new JLabel();
        lblColumnMetadataCount.setBounds(600, 273, 75, 16);
        // JButton: 'Load Columns'
        btnLoadColumnMetadata = new JButton();
        btnLoadColumnMetadata.setText("Load");
        btnLoadColumnMetadata.setCursor(cursor);
        btnLoadColumnMetadata.setEnabled(false);
        btnLoadColumnMetadata.setBounds(1081, 267, 79, 28);
        btnLoadColumnMetadata.addActionListener(evt -> btnLoadColumnMetadataActionPerformed());
        // JPanel
        panelDatabaseMetadata = new JPanel();
        panelDatabaseMetadata.setLayout(null);
        panelDatabaseMetadata.add(lblTableMetadata);
        panelDatabaseMetadata.add(separatorTableMetadata);
        panelDatabaseMetadata.add(scrollTableMetadata);
        panelDatabaseMetadata.add(lblTableMetadataCount);
        panelDatabaseMetadata.add(btnGenerateBean);
        panelDatabaseMetadata.add(btnLoadTableMetadata);
        panelDatabaseMetadata.add(lblColumnMetadata);
        panelDatabaseMetadata.add(separatorColumnMetadata);
        panelDatabaseMetadata.add(scrollColumnMetadata);
        panelDatabaseMetadata.add(lblColumnMetadataCount);
        panelDatabaseMetadata.add(btnLoadColumnMetadata);
        panelDatabaseMetadata.setBounds(0, 0, 1190, 610);
        // JFrame
        setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        setTitle("infoDB");
        setPreferredSize(new Dimension(1205, 638));
        setResizable(false);
        getContentPane().setLayout(null);
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent evt) {
                formWindowClosing();
            }
        });
        getContentPane().add(panelDatabaseMetadata);
        pack();
        setLocationRelativeTo(null);
    }

    /**
     * Cria e popula uma JTable com os metadados informados.
     *
     * @param columnsTitle vetor com os títulos das colunas da tabela
     * @param metadata lista contendo objetos de metadados (tabelas ou colunas)
     * @return JTable populada e configurada
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
                tableMetadataFocusGained();
            }
            @Override
            public void focusLost(FocusEvent evt) {
            }
        });
        return tbl;
    }

    /**
     * Evento disparado quando a tabela de metadados recebe foco. Habilita os
     * botões "Generate Bean" e "Load Column Metadata".
     */
    private void tableMetadataFocusGained() {
        // Habilita o botão de geração de Bean
        btnGenerateBean.setEnabled(true);
        // Habilita o botão de carga de Columns
        btnLoadColumnMetadata.setEnabled(true);
    }

    /**
     * Evento de clique no botão "Generate Bean". Gera a classe Java (Bean) com
     * base nos metadados da tabela selecionada.
     */
    private void btnGenerateBeanActionPerformed() {
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
    }

    /**
     * Evento de clique no botão "Load Column Metadata". Carrega os metadados
     * das colunas da tabela selecionada e atualiza a interface.
     */
    private void btnLoadColumnMetadataActionPerformed() {
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
    }

    /**
     * Evento de clique no botão "Load Table Metadata". Carrega os metadados das
     * tabelas e atualiza a interface.
     */
    private void btnLoadTableMetadataActionPerformed() {
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
    }

    /**
     * Evento executado ao fechar a janela. Pergunta ao usuário se deseja
     * desconectar e, em caso positivo, fecha a conexão com o banco e encerra a
     * aplicação.
     */
    private void formWindowClosing() {
        int i = JOptionPane.showConfirmDialog(null, "Do you really want to disconnect?", "", JOptionPane.YES_NO_OPTION);
        if (i == JOptionPane.YES_OPTION) {
            // Fecha a conexão com a base de dados
            gcc.closeConnection();
            // Encerra a aplicação
            System.exit(0);
        }
    }

    /**
     * Método principal para abrir a interface de visualização de metadados.
     *
     * @param dbName nome do banco de dados selecionado
     * @param gcController instância do controlador de conexão
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
            EventQueue.invokeLater(() -> {
                // Instancia uma janela, tornando-a visível
                new GenerateDatabaseMetadataView().setVisible(true);
            });
        } catch (UnsupportedLookAndFeelException e) {
            throw new RuntimeException(e);
        }
    }

}
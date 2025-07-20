package view;

import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import controller.GenerateConnectionController;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JSeparator;
import javax.swing.JTextField;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.swing.WindowConstants;

/**
 * Classe responsável por exibir uma interface gráfica para configuração e
 * geração de conexões com bancos de dados relacionais (MySQL ou Oracle).
 * <p>A interface permite ao usuário fornecer dados como host, porta, schema, nome
 * de usuário e senha, além de selecionar o tipo do banco de dados. Após o
 * preenchimento, é possível estabelecer uma conexão e prosseguir para
 * visualização dos metadados do banco.</p>
 * <p>A representação em UML desta classe pode ser vista no <strong>Diagrama de Classes</strong> abaixo:</p>
 * <p style="text-align: center"><img src="doc-files/GenerateConnectionViewClassDiagram.png" alt="Diagrama de classe da GenerateConnectionView"></p>
 * <p>Já a representação visual, na <strong>GUI</strong>:</p>
 * <p style="text-align: center"><img src="doc-files/GenerateConnectionViewGUI.png" alt="GUI da GenerateConnectionView"></p>
 * 
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateConnectionView extends JFrame {

    private Cursor cursor;
    private JButton btnConnect;
    private JComboBox<String> cboxDatabase;
    private JLabel lblConnectionData;
    private JLabel lblDatabase;
    private JLabel lblHost;
    private JLabel lblPassword;
    private JLabel lblPort;
    private JLabel lblSchema;
    private JLabel lblUsername;
    private JPanel panelConnectionData;
    private JPasswordField txtPassword;
    private JSeparator separatorConnectionData;
    private JTextField txtHost;
    private JTextField txtPort;
    private JTextField txtSchema;
    private JTextField txtUsername;

    /**
     * Construtor padrão da classe. Inicializa os componentes da interface
     * gráfica.
     */
    public GenerateConnectionView() {
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
        // JLabel: 'Connection data'
        lblConnectionData = new JLabel();
        lblConnectionData.setFont(new Font("sansserif", Font.BOLD, 14));
        lblConnectionData.setText("Connection data");
        lblConnectionData.setBounds(20, 20, 115, 20);
        // JSeparator
        separatorConnectionData = new JSeparator();
        separatorConnectionData.setBounds(20, 45, 345, 2);
        // JLabel: 'Database'
        lblDatabase = new JLabel();
        lblDatabase.setText("Database:");
        lblDatabase.setBounds(20, 67, 57, 16);
        // JLabel: 'Host'
        lblHost = new JLabel();
        lblHost.setText("Host:");
        lblHost.setBounds(20, 103, 29, 16);
        // JLabel: 'Port'
        lblPort = new JLabel();
        lblPort.setText("Port:");
        lblPort.setBounds(20, 139, 25, 16);
        // JLabel: 'Schema'
        lblSchema = new JLabel();
        lblSchema.setText("Schema:");
        lblSchema.setBounds(20, 175, 49, 16);
        // JLabel: 'Username'
        lblUsername = new JLabel();
        lblUsername.setText("Username:");
        lblUsername.setBounds(20, 211, 62, 16);
        // JLabel: 'Password'
        lblPassword = new JLabel();
        lblPassword.setText("Password:");
        lblPassword.setBounds(20, 247, 59, 16);
        // JComboBox<>
        cboxDatabase = new JComboBox<>();
        cboxDatabase.setModel(new DefaultComboBoxModel<>(new String[]{"MySQL", "Oracle"}));
        cboxDatabase.setCursor(cursor);
        cboxDatabase.setBounds(115, 62, 79, 26);
        // JTextField: 'Host'
        txtHost = new JTextField();
        txtHost.setBounds(115, 97, 250, 28);
        // JTextField: 'Port'
        txtPort = new JTextField();
        txtPort.setBounds(115, 133, 250, 28);
        // JTextField: 'Schema'
        txtSchema = new JTextField();
        txtSchema.setBounds(115, 169, 250, 28);
        // JTextField: 'Username'
        txtUsername = new JTextField();
        txtUsername.setBounds(115, 205, 250, 28);
        // JPasswordField
        txtPassword = new JPasswordField();
        txtPassword.setBounds(115, 241, 250, 28);
        // JButton
        btnConnect = new JButton();
        btnConnect.setText("Connect");
        btnConnect.setCursor(cursor);
        btnConnect.setBounds(291, 277, 79, 28);
        btnConnect.addActionListener(evt -> btnConnectActionPerformed());
        // JPanel
        panelConnectionData = new JPanel();
        panelConnectionData.setLayout(null);
        panelConnectionData.add(lblConnectionData);
        panelConnectionData.add(separatorConnectionData);
        panelConnectionData.add(lblDatabase);
        panelConnectionData.add(cboxDatabase);
        panelConnectionData.add(lblHost);
        panelConnectionData.add(txtHost);
        panelConnectionData.add(lblPort);
        panelConnectionData.add(lblSchema);
        panelConnectionData.add(lblUsername);
        panelConnectionData.add(lblPassword);
        panelConnectionData.add(txtPort);
        panelConnectionData.add(txtSchema);
        panelConnectionData.add(txtUsername);
        panelConnectionData.add(txtPassword);
        panelConnectionData.add(btnConnect);
        panelConnectionData.setBounds(0, 0, 400, 330);
        // JFrame
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setTitle("infoDB");
        setPreferredSize(new Dimension(400, 365));
        setResizable(false);
        getContentPane().setLayout(null);
        getContentPane().add(panelConnectionData);
        pack();
        setLocationRelativeTo(null);
    }

    /**
     * Ação executada quando o botão "Connect" é clicado.
     * <p>
     * Obtém os dados informados na interface e tenta estabelecer uma conexão
     * com o banco de dados. Caso a conexão seja bem-sucedida, exibe uma
     * mensagem de sucesso, fecha a janela atual e abre a interface de
     * visualização de metadados. Caso contrário, exibe uma mensagem de erro.
     * </p>
     */
    private void btnConnectActionPerformed() {
        String database = cboxDatabase.getSelectedItem().toString();
        String host = txtHost.getText();
        String port = txtPort.getText();
        String schema = txtSchema.getText();
        String username = txtUsername.getText();
        String password = new String(txtPassword.getPassword());
        if (!host.isEmpty() && !port.isEmpty() && !schema.isEmpty() && !username.isEmpty() && !password.isEmpty()) {
            try {
                GenerateConnectionController gcc = new GenerateConnectionController();
                gcc.generate(database, host, port, schema, username, password);
                JOptionPane.showMessageDialog(null, "Connection established!", "", JOptionPane.INFORMATION_MESSAGE);
                dispose();
                GenerateDatabaseMetadataView.main(database, gcc);
            } catch (RuntimeException e) {
                JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
            }
        } else {
            JOptionPane.showMessageDialog(null, "Fill in all fields!", "", JOptionPane.INFORMATION_MESSAGE);
        }
    }

    /**
     * Método principal responsável por iniciar a aplicação.
     * <p>
     * Define o tema da interface utilizando FlatLaf, ativa a opção de
     * mostrar/ocultar senha e torna a janela de conexão visível.
     * </p>
     *
     * @param args argumentos de linha de comando (não utilizados)
     */
    public static void main(String args[]) {
        try {
            UIManager.setLookAndFeel(new FlatMacDarkLaf());
            UIManager.put("PasswordField.showRevealButton", true);
            EventQueue.invokeLater(() -> {
                new GenerateConnectionView().setVisible(true);
            });
        } catch (UnsupportedLookAndFeelException e) {
            throw new RuntimeException(e);
        }
    }

}
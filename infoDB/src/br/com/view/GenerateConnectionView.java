package br.com.view;

import br.com.controller.GenerateConnectionController;
import com.formdev.flatlaf.themes.FlatMacDarkLaf;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

/**
 *
 * @author Fábio Fernandes
 * @version 1.0
 */
public class GenerateConnectionView extends JFrame {

    /**
     *
     */
    public GenerateConnectionView() {
        initComponents();
    }

    /**
     *
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        panelConnectionData = new javax.swing.JPanel();
        lblConnectionData = new javax.swing.JLabel();
        separatorConnectionData = new javax.swing.JSeparator();
        lblDatabase = new javax.swing.JLabel();
        cboxDatabase = new javax.swing.JComboBox<>();
        lblHost = new javax.swing.JLabel();
        txtHost = new javax.swing.JTextField();
        lblPort = new javax.swing.JLabel();
        lblSchema = new javax.swing.JLabel();
        lblUsername = new javax.swing.JLabel();
        lblPassword = new javax.swing.JLabel();
        txtPort = new javax.swing.JTextField();
        txtSchema = new javax.swing.JTextField();
        txtUsername = new javax.swing.JTextField();
        txtPassword = new javax.swing.JPasswordField();
        btnConnect = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("infoDB");
        setMinimumSize(new java.awt.Dimension(400, 365));
        setName("frame"); // NOI18N
        setPreferredSize(new java.awt.Dimension(400, 365));
        setResizable(false);
        setSize(new java.awt.Dimension(400, 365));
        getContentPane().setLayout(null);

        panelConnectionData.setBorder(null);
        panelConnectionData.setAlignmentX(0.0F);
        panelConnectionData.setAlignmentY(0.0F);
        panelConnectionData.setMaximumSize(new java.awt.Dimension(400, 330));
        panelConnectionData.setMinimumSize(new java.awt.Dimension(400, 330));
        panelConnectionData.setPreferredSize(new java.awt.Dimension(400, 330));
        panelConnectionData.setLayout(null);

        lblConnectionData.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        lblConnectionData.setText("Connection data");
        lblConnectionData.setAlignmentY(0.0F);
        lblConnectionData.setPreferredSize(new java.awt.Dimension(115, 20));
        panelConnectionData.add(lblConnectionData);
        lblConnectionData.setBounds(20, 20, 115, 20);

        separatorConnectionData.setAlignmentX(0.0F);
        separatorConnectionData.setAlignmentY(0.0F);
        separatorConnectionData.setPreferredSize(new java.awt.Dimension(345, 2));
        panelConnectionData.add(separatorConnectionData);
        separatorConnectionData.setBounds(20, 45, 345, 2);

        lblDatabase.setText("Database:");
        lblDatabase.setAlignmentY(0.0F);
        panelConnectionData.add(lblDatabase);
        lblDatabase.setBounds(20, 67, 57, 16);

        cboxDatabase.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "MySQL", "Oracle" }));
        cboxDatabase.setAlignmentX(0.0F);
        cboxDatabase.setAlignmentY(0.0F);
        cboxDatabase.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        cboxDatabase.setMinimumSize(new java.awt.Dimension(79, 26));
        cboxDatabase.setPreferredSize(new java.awt.Dimension(79, 26));
        panelConnectionData.add(cboxDatabase);
        cboxDatabase.setBounds(115, 62, 79, 26);

        lblHost.setText("Host:");
        lblHost.setAlignmentY(0.0F);
        panelConnectionData.add(lblHost);
        lblHost.setBounds(20, 103, 29, 16);

        txtHost.setPreferredSize(new java.awt.Dimension(250, 28));
        panelConnectionData.add(txtHost);
        txtHost.setBounds(115, 97, 250, 28);

        lblPort.setText("Port:");
        lblPort.setAlignmentY(0.0F);
        panelConnectionData.add(lblPort);
        lblPort.setBounds(20, 139, 25, 16);

        lblSchema.setText("Schema:");
        lblSchema.setAlignmentY(0.0F);
        panelConnectionData.add(lblSchema);
        lblSchema.setBounds(20, 175, 49, 16);

        lblUsername.setText("Username:");
        lblUsername.setAlignmentY(0.0F);
        panelConnectionData.add(lblUsername);
        lblUsername.setBounds(20, 211, 62, 16);

        lblPassword.setText("Password:");
        lblPassword.setAlignmentY(0.0F);
        panelConnectionData.add(lblPassword);
        lblPassword.setBounds(20, 247, 59, 16);

        txtPort.setAlignmentX(0.0F);
        txtPort.setAlignmentY(0.0F);
        txtPort.setPreferredSize(new java.awt.Dimension(250, 28));
        panelConnectionData.add(txtPort);
        txtPort.setBounds(115, 133, 250, 28);

        txtSchema.setAlignmentX(0.0F);
        txtSchema.setAlignmentY(0.0F);
        txtSchema.setPreferredSize(new java.awt.Dimension(250, 28));
        panelConnectionData.add(txtSchema);
        txtSchema.setBounds(115, 169, 250, 28);

        txtUsername.setAlignmentX(0.0F);
        txtUsername.setAlignmentY(0.0F);
        txtUsername.setPreferredSize(new java.awt.Dimension(250, 28));
        panelConnectionData.add(txtUsername);
        txtUsername.setBounds(115, 205, 250, 28);

        txtPassword.setAlignmentX(0.0F);
        txtPassword.setAlignmentY(0.0F);
        txtPassword.setPreferredSize(new java.awt.Dimension(250, 28));
        panelConnectionData.add(txtPassword);
        txtPassword.setBounds(115, 241, 250, 28);

        btnConnect.setText("Connect");
        btnConnect.setAlignmentY(0.0F);
        btnConnect.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnConnect.setMaximumSize(new java.awt.Dimension(79, 28));
        btnConnect.setMinimumSize(new java.awt.Dimension(79, 28));
        btnConnect.setPreferredSize(new java.awt.Dimension(79, 28));
        btnConnect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnConnectActionPerformed(evt);
            }
        });
        panelConnectionData.add(btnConnect);
        btnConnect.setBounds(291, 277, 79, 28);

        getContentPane().add(panelConnectionData);
        panelConnectionData.setBounds(0, 0, 400, 330);

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    /**
     *
     * @param evt
     */
    private void btnConnectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnConnectActionPerformed
        // Obtêm os dados da GUI
        String database = cboxDatabase.getSelectedItem().toString();
        String host = txtHost.getText();
        String port = txtPort.getText();
        String schema = txtSchema.getText();
        String username = txtUsername.getText();
        String password = new String(txtPassword.getPassword());
        // Verifica se os dados não são vazios
        if (!host.isEmpty() && !port.isEmpty() && !schema.isEmpty() && !username.isEmpty() && !password.isEmpty()) {
            try {
                // Gera conexão com a base de dados
                GenerateConnectionController gcc = new GenerateConnectionController();
                gcc.generate(database, host, port, schema, username, password);
                // Emite um alerta de sucesso
                JOptionPane.showMessageDialog(null, "Connection established!", "", JOptionPane.INFORMATION_MESSAGE);
                // Fecha a janela de conexão
                dispose();
                // Abre a janela de metadados: tables, columns, procedures, entre outros
                GenerateDatabaseMetadataView.main(database, gcc);                
            } catch (RuntimeException e) {
                // Emite um alerta de erro
                JOptionPane.showMessageDialog(null, e.getMessage(), "", JOptionPane.ERROR_MESSAGE);
            }
        } else {
            // Emite um alerta de erro
            JOptionPane.showMessageDialog(null, "Fill in all fields!", "", JOptionPane.INFORMATION_MESSAGE);
        }
    }//GEN-LAST:event_btnConnectActionPerformed

    /**
     *
     * @param args
     */
    public static void main(String args[]) {
        try {
            // Define o Look and Feel (https://www.formdev.com/flatlaf/)
            UIManager.setLookAndFeel(new FlatMacDarkLaf());
            // Adiciona o widget de exibir/ocultar a senha
            UIManager.put("PasswordField.showRevealButton", true);
            java.awt.EventQueue.invokeLater(() -> {
                // Instancia uma janela, tornando-a visível
                new GenerateConnectionView().setVisible(true);                
            });
        } catch (UnsupportedLookAndFeelException e) {
            throw new RuntimeException(e);
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnConnect;
    private javax.swing.JComboBox<String> cboxDatabase;
    private javax.swing.JLabel lblConnectionData;
    private javax.swing.JLabel lblDatabase;
    private javax.swing.JLabel lblHost;
    private javax.swing.JLabel lblPassword;
    private javax.swing.JLabel lblPort;
    private javax.swing.JLabel lblSchema;
    private javax.swing.JLabel lblUsername;
    private javax.swing.JPanel panelConnectionData;
    private javax.swing.JSeparator separatorConnectionData;
    private javax.swing.JTextField txtHost;
    private javax.swing.JPasswordField txtPassword;
    private javax.swing.JTextField txtPort;
    private javax.swing.JTextField txtSchema;
    private javax.swing.JTextField txtUsername;
    // End of variables declaration//GEN-END:variables
}
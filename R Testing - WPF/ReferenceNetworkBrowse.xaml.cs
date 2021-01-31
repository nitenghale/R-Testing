using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data;

namespace R_Testing___WPF
{
    /// <summary>
    /// Interaction logic for ReferenceNetworkBrowse.xaml
    /// </summary>
    public partial class ReferenceNetworkBrowse : UserControl
    {
        public ReferenceNetworkBrowse()
        {
            InitializeComponent();

            DatabaseConnection dbConnection = new DatabaseConnection()
            {
                connectionString = Properties.Settings.Default.connectionString
                ,sqlString = "exec Reference.BrowseNetworks"
            };

            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                tbStatusBar.Text = "Error connecting to database...";
                MessageBox.Show(dbConnection.errorMessage, "Error connecting to database");
                return;
            }

            dbConnection.SqlAdapter();

            if (dbConnection.returnCode != 0)
            {
                tbStatusBar.Text = "Error populating data...";
                MessageBox.Show(dbConnection.errorMessage, "Error populating data");
                return;
            }

            dgReferenceNetworkBrowse.ItemsSource = dbConnection.sqlDataSet.Tables[0].DefaultView;

            dbConnection.CloseConnection();
        }

        private void ReferenceNetworkBrowse_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            DataGrid grid = (DataGrid)sender;
            DataRowView row = (DataRowView)grid.SelectedItem;
            string networkName = row["NetworkName"].ToString();

            Window parentWindow = Window.GetWindow(this);
            ContentPresenter contentPresenter = VisualTreeHelper.GetParent(ucReferenceNetworkBrowse) as ContentPresenter;
            ContentControl contentControl = VisualTreeHelper.GetParent(contentPresenter) as ContentControl;
            parentWindow.Title = "Network Maintenance: " + networkName;
            contentControl.Content = new ReferenceNetworkMaintenance(networkName);
        }
    }
}

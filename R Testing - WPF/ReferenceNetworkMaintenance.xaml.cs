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

namespace R_Testing___WPF
{
    /// <summary>
    /// Interaction logic for ReferenceNetworkMaintenance.xaml
    /// </summary>
    public partial class ReferenceNetworkMaintenance : UserControl
    {
        public ReferenceNetworkMaintenance(string networkName)
        {
            InitializeComponent();

            ReferenceNetwork network = new ReferenceNetwork();
            network.networkName = networkName;
            network.connectionString = Properties.Settings.Default.connectionString;

            PopulateScreen(network);
        }

        private void PopulateScreen(ReferenceNetwork network)
        {
            ClearErrrorFormat();

            network.GetNetworkDetails();

            if (network.returnCode != 0)
            {
                tbMessage.Text = network.errorMessage;
                tbStatusBar.Text = network.errorMessage;
                MessageBox.Show(network.errorMessage, "Error retrieving network");
                SetErrorFormat();
                return;
            }

            txtNetworkId.Text = network.networkId.ToString();
            txtNetworkAbbreviation.Text = network.networkAbbreviation;
            txtNetworkName.Text = network.networkName;
            txtChannelNumber.Text = network.channelNumber.ToString();
            dpLastMaintenanceDateTime.SelectedDate = network.lastMaintenanceDateTime;
            txtLastMaintenanceUser.Text = network.lastMaintenanceUser;

            if (dgNetworkMediaBrowse.Items.Count > 0)
                btnDelete.IsEnabled = true;
            else
            {
                btnDelete.ToolTip = "Network has media tied to it; delete all media before deleting network";
            }
        }

        private void Update_Click(object sender, RoutedEventArgs e)
        {
            tbStatusBar.Text = "";
            tbMessage.Text = "";
            ClearErrrorFormat();

            ReferenceNetwork network = new ReferenceNetwork {
                connectionString = Properties.Settings.Default.connectionString,
                networkId = Convert.ToInt16(txtNetworkId.Text)
            };

            network.txtNetworkName = txtNetworkName.Text;
            network.ValidateNetworkName(); // moves validated network name into networkName

            if (network.returnCode != 0)
            {
                tbStatusBar.Text = network.errorMessage;
                tbMessage.Text = network.errorMessage;
                txtNetworkName.Focus();
                SetErrorFormat();
                return;
            }

            network.txtChannelNumber = txtChannelNumber.Text;
            network.ValidateChannelNumber(); // moves validated channel number into channelNumber

            if (network.returnCode != 0)
            {
                tbStatusBar.Text = network.errorMessage;
                tbMessage.Text = network.errorMessage;
                txtChannelNumber.Focus();
                SetErrorFormat();
                return;
            }

            if (txtNetworkAbbreviation.Text != "") network.networkAbbreviation = txtNetworkAbbreviation.Text;

            ReferenceNetwork currentNetwork = new ReferenceNetwork
            {
                connectionString = Properties.Settings.Default.connectionString,
                networkId = Convert.ToInt16(txtNetworkId.Text)
            };
            currentNetwork.GetNetworkDetails();

            if (network.networkName == currentNetwork.networkName && 
                network.networkAbbreviation == currentNetwork.networkAbbreviation &&
                network.channelNumber == currentNetwork.channelNumber)
            {
                tbStatusBar.Text = "No changes found";
                tbMessage.Text = tbStatusBar.Text;
                return;
            }

            network.UpdateNetwork();

            if (network.returnCode == 0)
            {
                tbStatusBar.Text = "Network updated";
                tbMessage.Text = tbStatusBar.Text;
                PopulateScreen(network);
            }
            else
            {
                tbMessage.Text = network.errorMessage;
                tbStatusBar.Text = network.errorMessage;
                SetErrorFormat();
                return;
            }
        }

        private void SetErrorFormat()
        {
            tbStatusBar.Foreground = Brushes.Red;
            tbMessage.Foreground = Brushes.Red;
        }

        private void ClearErrrorFormat()
        {
            tbStatusBar.Foreground = Brushes.Black;
            tbMessage.Foreground = Brushes.Black;
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {
        }
    }
}

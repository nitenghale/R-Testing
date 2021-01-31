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
    /// Interaction logic for ReferenceNetworkAdd.xaml
    /// </summary>
    public partial class ReferenceNetworkAdd : UserControl
    {
        public ReferenceNetworkAdd()
        {
            InitializeComponent();

            txtNetworkAbbreviation.Focus();
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            tbStatusBar.Text = "";
            tbMessage.Text = "";

            ReferenceNetwork network = new ReferenceNetwork { connectionString = Properties.Settings.Default.connectionString };

            network.txtNetworkName = txtNetworkName.Text;
            network.ValidateNetworkName(); // moves validated network name into networkName

            if (network.returnCode != 0)
            {
                tbStatusBar.Text = network.errorMessage;
                tbMessage.Text = network.errorMessage;
                txtNetworkName.Focus();
                return;
            }

            network.txtChannelNumber = txtChannelNumber.Text;
            network.ValidateChannelNumber(); // moves validated channel number into channelNumber

            if (network.returnCode != 0)
            {
                tbStatusBar.Text = network.errorMessage;
                tbMessage.Text = network.errorMessage;
                txtChannelNumber.Focus();
                return;
            }

            if (txtNetworkAbbreviation.Text != "") network.networkAbbreviation = txtNetworkAbbreviation.Text;

            network.AddNetwork();

            if (network.returnCode == 0)
            {
                tbStatusBar.Text = "Network : " + network.networkName + " Added!";
                tbMessage.Text = tbStatusBar.Text;
                txtNetworkAbbreviation.Text = "";
                txtNetworkName.Text = "";
                txtChannelNumber.Text = "";
                txtNetworkAbbreviation.Focus();
            }
            else
            {
                tbStatusBar.Text = network.errorMessage;
                tbMessage.Text = network.errorMessage;
                MessageBox.Show(network.errorMessage);
                return;
            }
        }
    }
}

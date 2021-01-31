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
    /// Interaction logic for MediaMovieAdd.xaml
    /// </summary>
    public partial class MediaMovieAdd : UserControl
    {
        public MediaMovieAdd()
        {
            InitializeComponent();

            PopulateNetworks();

            txtMovieTitle.Focus();
        }

        private void PopulateNetworks ()
        {
            cbNetwork.Items.Clear();
            cbNetwork.Items.Add("");

            DatabaseConnection dbConnection = new DatabaseConnection { connectionString = Properties.Settings.Default.connectionString };

            dbConnection.OpenConnection();

            if (dbConnection.returnCode != 0)
            {
                tbStatusBar.Text = dbConnection.errorMessage;
                tbMessage.Text = dbConnection.errorMessage;
                return;
            }

            ReferenceNetwork network = new ReferenceNetwork { connectionString = Properties.Settings.Default.connectionString };
            network.GetReferenceNetworkList(dbConnection);

            if (network.returnCode != 0)
            {
                tbStatusBar.Text = dbConnection.errorMessage;
                tbMessage.Text = dbConnection.errorMessage;
                return;
            }

            while (dbConnection.sqlReader.Read())
            {
                cbNetwork.Items.Add(dbConnection.sqlReader["NetworkName"].ToString());
            }

            dbConnection.CloseReader();
            dbConnection.CloseConnection();
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            tbStatusBar.Text = "";
            tbMessage.Text = "";

            MediaMovie movie = new MediaMovie { connectionString = Properties.Settings.Default.connectionString };

            movie.txtMovieTitle = txtMovieTitle.Text;
            movie.ValidateMovieTitle();

            if (movie.returnCode != 0)
            {
                tbStatusBar.Text = movie.errorMessage;
                tbMessage.Text = movie.errorMessage;
                txtMovieTitle.Focus();
                return;
            }

            movie.dpReleaseDate = dpReleaseDate.Text;
            movie.ValidateReleaseDate();

            if (movie.returnCode != 0)
            {
                tbStatusBar.Text = movie.errorMessage;
                tbMessage.Text = movie.errorMessage;
                dpReleaseDate.Focus();
                return;
            }

            if (cbNetwork.Text != "") movie.networkName = cbNetwork.Text;
            if (txtSynopsis.Text != "") movie.synopsis = txtSynopsis.Text;

            movie.AddMovie();

            if (movie.returnCode == 0)
            {
                tbStatusBar.Text = "Movie : " + movie.movieTitle + " Added!";
                tbMessage.Text = tbStatusBar.Text;
                txtMovieTitle.Text = "";
                dpReleaseDate.SelectedDate = null;
                PopulateNetworks();
                txtSynopsis.Text = "";
                txtMovieTitle.Focus();
            }
            else
            {
                tbStatusBar.Text = movie.errorMessage;
                tbMessage.Text = movie.errorMessage;
                return;
            }
        }
    }
}

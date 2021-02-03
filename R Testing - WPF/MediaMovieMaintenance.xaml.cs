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
    /// Interaction logic for MediaMovieMaintenance.xaml
    /// </summary>
    public partial class MediaMovieMaintenance : UserControl
    {
        public MediaMovieMaintenance(string movieTitle)
        {
            InitializeComponent();

            PopulateNetworks();

            MediaMovie movie = new MediaMovie();
            movie.movieTitle = movieTitle;
            movie.connectionString = Properties.Settings.Default.connectionString;

            PopulateScreen(movie);

            txtMovieTitle.Focus();
        }
        private void PopulateNetworks()
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

        private void PopulateScreen(MediaMovie movie)
        {
            ClearErrorFormat();

            movie.GetMovieDetails();

            if (movie.returnCode != 0)
            {
                tbMessage.Text = movie.errorMessage;
                tbStatusBar.Text = movie.errorMessage;
                SetErrorFormat();
                return;
            }

            txtMovieUid.Text = movie.movieUid.ToString();
            txtMovieTitle.Text = movie.movieTitle;
            dpReleaseDate.SelectedDate = movie.releaseDate;
            cbNetwork.Text = movie.networkName;
            txtSynopsis.Text = movie.synopsis;
            dpLastMaintenanceDateTime.SelectedDate = movie.lastMaintenanceDateTime;
            txtLastMaintenanceUser.Text = movie.lastMaintenanceUser;
        }

        private void Update_Click(object sender, RoutedEventArgs e)
        {
            tbStatusBar.Text = "";
            tbMessage.Text = "";
            ClearErrorFormat();

            MediaMovie movie = new MediaMovie
            {
                connectionString = Properties.Settings.Default.connectionString,
                movieUid = new Guid(txtMovieUid.Text)
            };

            movie.txtMovieTitle = txtMovieTitle.Text;
            movie.ValidateMovieTitle();

            if (movie.returnCode != 0)
            {
                tbStatusBar.Text = movie.errorMessage;
                tbMessage.Text = movie.errorMessage;
                txtMovieTitle.Focus();
                SetErrorFormat();
                return;
            }

            movie.dpReleaseDate = dpReleaseDate.SelectedDate.ToString();
            movie.ValidateReleaseDate();

            if (cbNetwork.Text != "") movie.networkName = cbNetwork.Text;
            if (txtSynopsis.Text.Trim() != "") movie.synopsis = txtSynopsis.Text.Trim();

            MediaMovie currentMovie = new MediaMovie
            {
                connectionString = Properties.Settings.Default.connectionString,
                movieUid = new Guid(txtMovieUid.Text)
            };
            currentMovie.GetMovieDetails();

            if (movie.movieTitle == currentMovie.movieTitle &&
                movie.releaseDate == currentMovie.releaseDate &&
                movie.networkName == currentMovie.networkName &&
                movie.synopsis == currentMovie.synopsis)
            {
                tbStatusBar.Text = "No changes found";
                tbMessage.Text = tbStatusBar.Text;
                return;
            }

            movie.UpdateMovie();

            if (movie.returnCode == 0)
            {
                tbStatusBar.Text = "Movie updated";
                tbMessage.Text = tbStatusBar.Text;
                PopulateScreen(movie);
            }
            else
            {
                tbMessage.Text = movie.errorMessage;
                tbStatusBar.Text = movie.errorMessage;
                SetErrorFormat();
                return;
            }
        }

        private void Delete_Click(object sender, RoutedEventArgs e)
        {

        }

        private void SetErrorFormat()
        {
            tbStatusBar.Foreground = Brushes.Red;
            tbMessage.Foreground = Brushes.Red;
        }

        private void ClearErrorFormat()
        {
            tbStatusBar.Foreground = Brushes.Black;
            tbMessage.Foreground = Brushes.Black;
        }
    }
}

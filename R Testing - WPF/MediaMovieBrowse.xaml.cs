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
    /// Interaction logic for MediaMovieBrowse.xaml
    /// </summary>
    public partial class MediaMovieBrowse : UserControl
    {
        public MediaMovieBrowse()
        {
            InitializeComponent();

            DatabaseConnection dbConnection = new DatabaseConnection()
            {
                connectionString = Properties.Settings.Default.connectionString,
                sqlString = "exec Media.BrowseMovies"
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

            dgMediaMovieBrowse.ItemsSource = dbConnection.sqlDataSet.Tables[0].DefaultView;

            dbConnection.CloseConnection();
        }

        private void MediaMovieBrowse_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            DataGrid grid = (DataGrid)sender;
            DataRowView row = (DataRowView)grid.SelectedItem;
            string movieTitle = row["MovieTitle"].ToString();
            DateTime releaseDate = Convert.ToDateTime(row["ReleaseDate"]);
            string releaseYear = releaseDate.Year.ToString();
            movieTitle += " (" + releaseYear + ")";

            Window parentWindow = Window.GetWindow(this);
            ContentPresenter contentPresenter = VisualTreeHelper.GetParent(ucMediaMovieBrowse) as ContentPresenter;
            ContentControl contentControl = VisualTreeHelper.GetParent(contentPresenter) as ContentControl;
            parentWindow.Title = "Movie Maintenance: " + movieTitle;
            //contentControl.Content = new ReferenceNetworkMaintenance(networkName);
        }
    }
}

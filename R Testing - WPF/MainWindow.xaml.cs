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
using System.Windows.Controls.Ribbon;

namespace R_Testing___WPF
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : RibbonWindow
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void LibraryMoviesAdd_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Add Movie";
            ccMainWindow.Content = new MediaMovieAdd();
        }

        private void LibraryMoviesBrowse_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Browse Movies";
            ccMainWindow.Content = new MediaMovieBrowse();
        }

        private void LibraryTvShowsAdd_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Add TV Show";
        }

        private void LibraryTvShowsBrowse_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Browse TV Shows";
        }

        private void LibraryPlaylistAdd_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Add Playlist";
        }

        private void LibraryPlaylistBrowse_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Browse Playlists";
        }

        private void ReferenceNetworkAdd_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Add Network";
            ccMainWindow.Content = new ReferenceNetworkAdd();
        }

        private void ReferenceNetworkBrowse_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Browse Networks";
            ccMainWindow.Content = new ReferenceNetworkBrowse();
        }

        private void ReferenceMediaTypeAdd_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Add Media Type";
        }

        private void ReferenceMediaTypeBrowse_Click(object sender, RoutedEventArgs e)
        {
            mainWindow.Title = "Browse Media Types";
        }
    }
}

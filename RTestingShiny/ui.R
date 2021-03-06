#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(
  dashboardPage(
    dashboardHeader(title = "R Testing - Shiny App"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Home", tabName = "homeMenu"),
        menuItem("Reference", tabName = "referenceMenu",
          menuSubItem("Network", tabName = "referenceNetworkMenu"),
          menuSubItem("Status", tabName = "referenceStatusMenu")),
        menuItem("Media", tabName = "mediaMenu",
          menuSubItem("Movie", tabName = "mediaMovieMenu"),
          menuSubItem("Series", tabName = "mediaSeriesMenu"),
          menuSubItem("Episode", tabName = "mediaEpisodeMenu"),
          menuSubItem("Playlist", tabName = "mediaPlaylistMenu"),
          menuSubItem("Recordings", tabName = "mediaRecordingsMenu"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "homeMenu",
          h1("Home")),
        tabItem(tabName = "referenceNetworkMenu",
          referenceNetworkModuleUI("referenceNetworkModule", "Network Module")),
        tabItem(tabName = "referenceStatusMenu",
          referenceStatusCodeModuleUI("referenceStatusCodeModule", "Status Code Module")),
        tabItem(tabName = "mediaMovieMenu",
          mediaMovieModuleUI("mediaMovieModule", "Movie Module")),
        tabItem(tabName = "mediaSeriesMenu",
          mediaSeriesModuleUI("mediaSeriesModule", "Series Module")),
        tabItem(tabName = "mediaEpisodeMenu",
                mediaEpisodeModuleUI("mediaEpisodeModule", "Episode Module"))
        ##tabItem(tabName = "mediaPlaylistMenu",
          ##playlistModuleUI("playlistModule", "Playlist Module")),
        ##tabItem(tabName = "mediaRecordingsMenu",
          ##recordingModuleUI("recordingModule", "Recording Module"))
      )
    )
  )
)

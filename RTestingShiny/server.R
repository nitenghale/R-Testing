#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  referenceNetworkModule <-
    referenceNetworkModuleServer("referenceNetworkModule", stringsAsFactors = FALSE)

  referenceStatusCodeModule <-
    referenceStatusCodeModuleServer("referenceStatusCodeModule", stringsAsFactors = FALSE)

  mediaMovieModule <-
    mediaMovieModuleServer("mediaMovieModule", stringsAsFactors = FALSE)

  mediaSeriesModule <-
    mediaSeriesModuleServer("mediaSeriesModule", stringsAsFactors = FALSE)

  mediaEpisodeModule <-
    mediaEpisodeModuleServer("mediaEpisodeModule", stringsAsFactors = FALSE)

  ##playlistModule <-
    ##playlistModuleServer("playlistModule", stringsAsFactors = FALSE)

  ##recordingModule <-
    ##recordingModuleServer("recordingModule", stringsAsFactors = FALSE)
})

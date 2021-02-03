#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
source("NetworkModule.R")

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        dashboardHeader(title = "R Testing - Shiny App"),
        dashboardSidebar(
            sidebarMenu(
                menuItem("Reference", tabName = "referenceMenu",
                    menuSubItem("Network", tabName = "referenceNetworkMenu"),
                    menuSubItem("Status", tabName = "referenceStatusMenu")),
                menuItem("Media", tabName = "mediaMenu",
                    menuSubItem("Movie", tabName = "mediaMovieMenu"),
                    menuSubItem("Series", tabName = "mediaSeriesMenu"),
                    menuSubItem("Playlist", tabName = "mediaPlaylistMenu"),
                    menuSubItem("Recordings", tabName = "mediaRecordingsMenu"))
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "referenceNetworkMenu", networkModuleUI("networkModule", "Network Module")),
                tabItem(tabName = "referenceStatusMenu", 
                    fluidPage(
                        h1("Status"),
                        fluidRow(
                            column(2, textInput("referenceStatusId", "ID")),
                            column(2, textInput("referenceStatusCode", "Code")),
                            column(4, textInput("referenceStatusDescription", "Desc"))
                        )
                    )
                ),
                tabItem(tabName = "mediaMovieMenu", h1("Movies")),
                tabItem(tabName = "mediaSeriesMenu", h1("Series")),
                tabItem(tabName = "mediaPlaylistMenu", h1("Playlist")),
                tabItem(tabName = "mediaRecordingsMenu", h1("Recordings"))
            )
        )
    )
)

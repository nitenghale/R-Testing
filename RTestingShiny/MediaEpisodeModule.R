# Module UI function
mediaEpisodeModuleUI <- function(id, label = "Episode Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  library(DT)

  tagList(
    fluidRow(
      column(2, uiOutput(ns("outMediaEpisodeSeries"))),
      column(1, uiOutput(ns("outMediaEpisodeSeasonNumber"))),
      column(1, uiOutput(ns("outMediaEpisodeEpisodeNumber"))),
      column(3, uiOutput(ns("outMediaEpisodeTitle"))),
      column(2, uiOutput(ns("outMediaEpisodeAirDate"))),
      column(3, uiOutput(ns("outMediaEpisodeSynopsis")))
    ),
    fluidRow(
      column(2, actionButton(ns("mediaEpisodeAdd"), "Add"))
    ),
    fluidRow(
      column(12, textOutput(ns("outMediaEpisodeMessage")))
    ),
    br(),
    DT::dataTableOutput(ns("outMediaEpisodeBrowse")),
    br(),
    fluidRow(
      column(12, actionButton(ns("mediaEpisodeRefresh"), "Refresh"))
    )
  )
}

# Module server function
mediaEpisodeModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,

    function(input, output, session) {

      ns <- session$ns

      minYear <- 1888
      currentYear <- as.numeric(format(Sys.Date(), "%Y"))
      maxYear <- currentYear + 5
      minDate <- as.Date(paste(minYear, "-01-01", sep = ""))
      maxDate <- as.Date(paste(maxYear, "-01-01", sep = ""))

      output$outMediaEpisodeSeries <-
        renderUI(CreateMediaEpisodeSeriesDropDown(ns))

      output$outMediaEpisodeSeasonNumber <-
        renderUI(CreateMediaEpisodeSeasonNumberTextbox(ns))

      output$outMediaEpisodeEpisodeNumber <-
        renderUI(CreateMediaEpisodeEpisodeNumberTextbox(ns))

      output$outMediaEpisodeTitle <-
        renderUI(CreateMediaEpisodeTitleTextbox(ns))

      output$outMediaEpisodeAirDate <-
        renderUI(CreateMediaEpisodeAirDatePicker(
          ns, minDate, maxDate))

      output$outMediaEpisodeSynopsis <-
        renderUI(CreateMediaEpisodeSynopsisTextbox(ns))

      output$outMediaEpisodeBrowse <-
        DT::renderDataTable(GetEpisodes(input$mediaEpisodeSeries))

      observeEvent(input$mediaEpisodeAdd, {

        message <- AddEpisode(input$mediaEpisodeSeries,
                            input$mediaEpisodeSeasonNumber,
                            input$mediaEpisodeEpisodeNumber,
                            input$mediaEpisodeTitle,
                            input$mediaEpisodeAirDate,
                            input$mediaEpisodeSynopsis)

        output$outMediaEpisodeMessage <- renderText(message)

        if (substring(message, 1, 14) == "Episode Added:")
        {
          output$outMediaEpisodeSeries <-
            renderUI(CreateMediaEpisodeSeriesDropDown(ns, input$mediaEpisodeSeries))

          output$outMediaEpisodeSeasonNumber <-
            renderUI(CreateMediaEpisodeSeasonNumberTextbox(ns))

          output$outMediaEpisodeEpisodeNumber <-
            renderUI(CreateMediaEpisodeEpisodeNumberTextbox(ns))

          output$outMediaEpisodeTitle <-
            renderUI(CreateMediaEpisodeTitleTextbox(ns))

          output$outMediaEpisodeAirDate <-
            renderUI(CreateMediaEpisodeAirDatePicker(
              ns, minDate, maxDate))

          output$outMediaEpisodeSynopsis <-
            renderUI(CreateMediaEpisodeSynopsisTextbox(ns))

          output$outMediaEpisodeBrowse <-
            DT::renderDataTable(GetEpisodes(input$mediaEpisodeSeries))
        }
      })

      observeEvent(input$mediaEpisodeRefresh, {
        output$outMediaEpisodeSeries <-
          renderUI(CreateMediaEpisodeSeriesDropDown(ns))

        output$outMediaEpisodeSeasonNumber <-
          renderUI(CreateMediaEpisodeSeasonNumberTextbox(ns))

        output$outMediaEpisodeEpisodeNumber <-
          renderUI(CreateMediaEpisodeEpisodeNumberTextbox(ns))

        output$outMediaEpisodeTitle <-
          renderUI(CreateMediaEpisodeTitleTextbox(ns))

        output$outMediaEpisodeAirDate <-
          renderUI(CreateMediaEpisodeAirDatePicker(
            ns, minDate, maxDate))

        output$outMediaEpisodeSynopsis <-
          renderUI(CreateMediaEpisodeSynopsisTextbox(ns))

        output$outMediaEpisodeBrowse <-
          DT::renderDataTable(GetEpisodes(input$mediaEpisodeSeries))
      })
    }
  )
}

CreateMediaEpisodeSeriesDropDown <- function(ns, currentlySelectedSeries)
{
  if (missing(currentlySelectedSeries) || length(currentlySelectedSeries) < 1)
    currentlySelectedSeries <- ""

  ## try connecting to database; if the connection fails, return a
  ## DT::datatable with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    ## function accepts a character string and returns a DT::datatable
    return(p(paste("Error connecting to database:", con$message)))

  query <- "exec Media.ListSeries"

  ## try executing command in query, with connection in con
  ## if the query fails, return a DT::datatable with the error message
  rs <- tryCatch(dbSendQuery(con, query),
                 error = function(err) { return(err) })
  ## above is what assigns the error to rs, in message
  if (typeof(rs) == "list")
  {
    dbDisconnect(con)
    ## function accepts a character string and returns a DT::datatable
    return(p(paste("Error executing command:", rs$message)))
  }

  dfData <- dbFetch(rs)
  dbClearResult(rs)
  dbDisconnect(con)

  choices <- list("")
  selectedIndex <- 1

  if (length(dfData$SeriesTitle) > 0) {
    for (i in 1:length(dfData$SeriesTitle)) {
      choices <- c(choices, list(dfData$SeriesTitle[i]))
      if (dfData$SeriesTitle[i] == currentlySelectedSeries)
        selectedIndex <- i + 1
    }
  }

  selectedItem <- choices[selectedIndex]

  return(
    selectInput(
      ns("mediaEpisodeSeries"),
      "Series",
      choices = choices,
      selected = selectedItem
    )
  )
}

CreateMediaEpisodeSeasonNumberTextbox <- function(ns)
{
  return (
    numericInput(ns("mediaEpisodeSeasonNumber"),
                 "Season",
                 min = 0, max = 255, value = 1, step = 1)
  )
}

CreateMediaEpisodeEpisodeNumberTextbox <- function(ns)
{
  return (
    numericInput(ns("mediaEpisodeEpisodeNumber"),
                 "Episode",
                 min = 0, max = 500, value = 1, step = 1)
  )
}

CreateMediaEpisodeTitleTextbox <- function(ns)
{
  return (
    textInput(ns("mediaEpisodeTitle"), "Title")
  )
}

CreateMediaEpisodeAirDatePicker <- function(ns, minDate, maxDate)
{
  return (
    dateInput(ns("mediaEpisodeAirDate"), "Air Date", min = minDate, max = maxDate)
  )
}

CreateMediaEpisodeSynopsisTextbox <- function(ns)
{
  return (
    textInput(ns("mediaEpisodeSynopsis"), "Synopsis")
  )
}

GetEpisodes <- function(series)
{
  if (missing(series) || length(series) < 1 || trimws(series) == "")
    return(ReturnErrorDataTable("No Episodes found"))

  seriesTitle <- substr(series, 1, nchar(series) - 7)
  seriesYear <- substr(series, nchar(series) - 4, nchar(series) - 1)

  ## try connecting to database; if the connection fails, return a
  ## DT::datatable with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    ## function accepts a character string and returns a DT::datatable
    return(ReturnErrorDataTable(paste("Error connecting to database:",
                                      con$message)))

  query <- paste("exec Media.BrowseEpisodes @seriesTitle = '", seriesTitle,
                 "', @seriesYear = ", seriesYear, sep = "")

  ## try executing command in query, with connection in con
  ## if the query fails, return a DT::datatable with the error message
  rs <- tryCatch(dbSendQuery(con, query),
                 error = function(err) { return(err) })
  ## above is what assigns the error to rs, in message
  if (typeof(rs) == "list")
  {
    dbDisconnect(con)
    ## function accepts a character string and returns a DT::datatable
    return(ReturnErrorDataTable(paste("Error executing command:",
                                      rs$message)))
  }

  dfData <- dbFetch(rs)
  dbClearResult(rs)
  dbDisconnect(con)

  return(
    DT::datatable(dfData,
                  colnames = c("S#", "E#", "Title", "Air Date", "Synopsis"),
                  rownames = FALSE,
                  selection = "single",
                  options = list(searching = TRUE))
  )
}

AddEpisode <- function(series, season, episode, title, airDate, synopsis)
{
  if (length(series) < 1 || trimws(series) == "")
    return("Series required")

  if (!is.numeric(season) || season < 0 || season > 255)
    return("Invalid Season number")

  if (!is.numeric(episode) || episode < 0 || episode > 255)
    return("Invalid Season number")

  if (length(title) < 1 || trimws(title) == "")
    return("Episode Title required")

  if (nchar(title) > 100)
    return("Episode Title too long; limit to 100")

  if (!is.Date(airDate))
    return("Invalid Air Date")

  seriesTitle <- substr(series, 1, nchar(series) - 7)
  seriesYear <- substr(series, nchar(series) - 4, nchar(series) - 1)

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.AddEpisode @seriesTitle = '", seriesTitle,
                 "', @seriesYear = ", seriesYear,
                 ", @seasonNumber = ", season,
                 ", @episodeNumber = ", episode,
                 ", @episodeTitle = '", title, "'", sep = "")

  if (length(airDate) == 1)
    query <- paste(query, ", @originalAirDate = '", airDate, "'", sep = "")

  if (trimws(synopsis) != "")
    query <- paste(query, ", @synopsis = '", synopsis, "'", sep = "")

  ## try executing command in query, with connection in con
  ## if the query fails, return text with the error message
  rs <- tryCatch(dbSendQuery(con, query),
                 error = function(err) { return(err) })
  ## above is what assigns the error to rs, in message
  if (typeof(rs) == "list")
  {
    dbDisconnect(con)
    return(paste("Error executing command:", rs$message))
  }

  dbClearResult(rs)
  dbDisconnect(con)

  return(paste("Episode Added:", title))
}

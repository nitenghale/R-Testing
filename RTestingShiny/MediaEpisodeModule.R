# Module UI function
mediaEpisodeModuleUI <- function(id, label = "Episode Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  library(DT)

  tagList(
    fluidPage(
      fluidRow(
        column(2, uiOutput(ns("outMediaEpisodeSeries"))),
        column(1, uiOutput(ns("outMediaEpisodeSeasonNumber"))),
        column(1, uiOutput(ns("outMediaEpisodeEpisodeNumber"))),
        column(3, uiOutput(ns("outMediaEpisodeTitle"))),
        column(2, uiOutput(ns("outMediaEpisodeAirDate"))),
        column(3, uiOutput(ns("outMediaEpisodeSynopsis")))
      ),
      fluidRow(
        column(2, uiOutput(ns("outMediaEpisodeActionButton")))
      ),
      fluidRow(
        column(12, textOutput(ns("outMediaEpisodeMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outMediaEpisodeBrowse")),
      br(),
      fluidRow(
        column(12, actionButton(ns("mediaEpisodeResetButton"), "Reset"))
      )
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

      output$outMediaEpisodeActionButton <-
        renderUI(CreateMediaEpisodeActionButton(ns, "Add"))

      values <- reactiveValues(episodeData = NULL)

      #values$episodeData <- GetEpisodeData(input$mediaEpisodeSeries)

      output$outMediaEpisodeBrowse <-
        DT::renderDataTable(ReturnErrorDataTable("No Records to display"))

      ## Series changed
      observeEvent(input$mediaEpisodeSeries, {
        values$episodeData <- GetEpisodeData(input$mediaEpisodeSeries)

        output$outMediaEpisodeBrowse <-
          DT::renderDataTable(GetEpisodes(values$episodeData))
      })

      ## Add button clicked
      observeEvent(input$mediaEpisodeAdd, {

        message <- AddEpisode(input$mediaEpisodeSeries,
                            input$mediaEpisodeSeasonNumber,
                            input$mediaEpisodeEpisodeNumber,
                            input$mediaEpisodeTitle,
                            input$mediaEpisodeAirDate,
                            input$mediaEpisodeSynopsis,
                            minDate,
                            maxDate)

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

          values$episodeData <- GetEpisodeData(input$mediaEpisodeSeries)

          output$outMediaEpisodeBrowse <-
            DT::renderDataTable(GetEpisodes(values$episodeData))
        }
      })

      ## Episode row selected
      observeEvent(input$outMediaEpisodeBrowse_rows_selected, {
        ## Season #
        output$outMediaEpisodeSeasonNumber <-
          renderUI(CreateMediaEpisodeSeasonNumberTextbox(
            ns,
            input$outMediaEpisodeBrowse_rows_selected,
            values$episodeData))

        ## Episode #
        output$outMediaEpisodeEpisodeNumber <-
          renderUI(CreateMediaEpisodeEpisodeNumberTextbox(
            ns,
            input$outMediaEpisodeBrowse_rows_selected,
            values$episodeData))

        ## Episode Title
        output$outMediaEpisodeTitle <-
          renderUI(CreateMediaEpisodeTitleTextbox(
            ns,
            input$outMediaEpisodeBrowse_rows_selected,
            values$episodeData))

        ## Air Date
        output$outMediaEpisodeAirDate <-
          renderUI(CreateMediaEpisodeAirDatePicker(
            ns, minDate, maxDate,
            input$outMediaEpisodeBrowse_rows_selected,
            values$episodeData))

        ## Synopsis
        output$outMediaEpisodeSynopsis <-
          renderUI(CreateMediaEpisodeSynopsisTextbox(
            ns,
            input$outMediaEpisodeBrowse_rows_selected,
            values$episodeData))

        output$outMediaEpisodeMessage <- renderText("")

        output$outMediaEpisodeActionButton <-
          renderUI(CreateMediaEpisodeActionButton(ns, "Update"))
      })

      ## Series Update button clicked
      observeEvent(input$mediaEpisodeUpdate, {

        episodeUid <- values$episodeData$EpisodeUid[input$outMediaEpisodeBrowse_rows_selected]
        seriesUid <- values$episodeData$SeriesUid[input$outMediaEpisodeBrowse_rows_selected]

        message <- UpdateEpisode(episodeUid,
                                 seriesUid,
                                 input$mediaEpisodeSeasonNumber,
                                 input$mediaEpisodeEpisodeNumber,
                                 input$mediaEpisodeTitle,
                                 input$mediaEpisodeAirDate,
                                 input$mediaEpisodeSynopsis,
                                 minDate,
                                 maxDate)

        output$outMediaEpisodeMessage <- renderText(message)

        if (substring(message, 1, 16) == "Episode Updated:")
        {
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

          output$outMediaEpisodeActionButton <-
            renderUI(CreateMediaEpisodeActionButton(ns, "Add"))

          #####
          values$episodeData <- GetEpisodeData(input$mediaEpisodeSeries)

          output$outMediaEpisodeBrowse <-
            DT::renderDataTable(GetEpisodes(values$episodeData))
        }
      })

      ## Reset button clicked
      observeEvent(input$mediaEpisodeResetButton, {
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

        output$outMediaEpisodeActionButton <-
          renderUI(CreateMediaEpisodeActionButton(ns, "Add"))
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

CreateMediaEpisodeSeasonNumberTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- 1
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- 1
  else
    inputValue <- dfData$SeasonNumber[rowIndex]

  return (
    numericInput(ns("mediaEpisodeSeasonNumber"),
                 "Season",
                 min = 0, max = 255, value = inputValue, step = 1)
  )
}

CreateMediaEpisodeEpisodeNumberTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- 1
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- 1
  else
    inputValue <- dfData$EpisodeNumber[rowIndex]

  return (
    numericInput(ns("mediaEpisodeEpisodeNumber"),
                 "Episode",
                 min = 0, max = 500, value = inputValue, step = 1)
  )
}

CreateMediaEpisodeTitleTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$EpisodeTitle[rowIndex]

  return (
    textInput(ns("mediaEpisodeTitle"), "Title", inputValue)
  )
}

CreateMediaEpisodeAirDatePicker <- function(ns, minDate, maxDate, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- Sys.Date()
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- Sys.Date()
  else
    inputValue <- dfData$OriginalAirDate[rowIndex]

  return (
    dateInput(ns("mediaEpisodeAirDate"), "Air Date", min = minDate, max = maxDate, value = inputValue)
  )
}

CreateMediaEpisodeSynopsisTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$Synopsis[rowIndex]

  return (
    textInput(ns("mediaEpisodeSynopsis"), "Synopsis", inputValue)
  )
}

GetEpisodeData <- function(series)
{
  if (missing(series) || length(series) < 1 || trimws(series) == "")
    return(ReturnErrorDataFrame("No Episodes found"))

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

  return(dfData)
}

GetEpisodes <- function(episodeData)
{
  if (nrow(episodeData) < 1)
    return(ReturnErrorDataTable("No records to display"))

  if (nrow(episodeData) == 1 && episodeData[1] == "No Episodes found")
    return(ReturnErrorDataTable("No episodes found"))

  dfData <- episodeData[3:7]

  return(
    DT::datatable(dfData,
                  colnames = c("S#", "E#", "Title", "Air Date", "Synopsis"),
                  rownames = FALSE,
                  selection = "single",
                  options = list(searching = TRUE))
  )
}

AddEpisode <- function(series, season, episode, title, airDate, synopsis, minDate, maxDate)
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

  if ( length(airDate) == 1 && !is.na(airDate))
    if (airDate < minDate || airDate > maxDate)
      return(paste("Air Date must be between", minDate, "and", maxDate, sep = " "))

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

UpdateEpisode <- function(episodeUid, seriesUid, season, episode, title, airDate, synopsis, minDate, maxDate)
{
  if (nchar(episodeUid) < 36)
    return("Invalid Episode UID")

  if (nchar(seriesUid) < 36)
    return("Invalid Series UID")

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

  if ( length(airDate) == 1 && !is.na(airDate))
    if (airDate < minDate || airDate > maxDate)
      return(paste("Air Date must be between", minDate, "and", maxDate, sep = " "))

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.UpdateEpisode @episodeUid = '", episodeUid,
                 "', @seriesUid = '", seriesUid,
                 "', @seasonNumber = '", season,
                 "', @episodeNumber = '", episode,
                 "', @episodeTitle = '", title, "'", sep = "")

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

  return(paste("Episode Updated:", title))
}

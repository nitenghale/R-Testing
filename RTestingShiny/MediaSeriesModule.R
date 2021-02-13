# Module UI function
mediaSeriesModuleUI <- function(id, label = "Series Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  library(DT)
  library(lubridate)
  library(stringr)

  tagList(
    tabsetPanel(
      tabPanel("Series",
        fluidPage(
          fluidRow(
            column(3, uiOutput(ns("outMediaSeriesTitle"))),
            column(2, uiOutput(ns("outMediaSeriesYear"))),
            column(2, uiOutput(ns("outMediaSeriesNetwork"))),
            column(4, uiOutput(ns("outMediaSeriesDescription")))
          ),
          fluidRow(
            column(2, uiOutput(ns("outMediaSeriesActionButton")))
          ),
          fluidRow(
            column(12, textOutput(ns("outMediaSeriesMessage")))
          ),
          br(),
          DT::dataTableOutput(ns("outMediaSeriesBrowse")),
          br(),
          fluidRow(
            column(12, actionButton(ns("mediaSeriesResetButton"), "Reset"))
          )
        )
      ),
      tabPanel("Episodes",
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
    )
  )
}

# Module server function
mediaSeriesModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,

    function(input, output, session) {

      ns <- session$ns

      minYear <- 1888
      currentYear <- as.numeric(format(Sys.Date(), "%Y"))
      maxYear <- currentYear + 5
      minDate <- as.Date(paste(minYear, "-01-01", sep = ""))
      maxDate <- as.Date(paste(maxYear, "-01-01", sep = ""))

      output$outMediaSeriesTitle <-
        renderUI(CreateMediaSeriesTitleTextbox(ns))

      output$outMediaSeriesYear <-
        renderUI(CreateMediaSeriesYearTextbox(ns, minYear, currentYear, maxYear))

      output$outMediaSeriesNetwork <-
        renderUI(CreateMediaSeriesNetworkDropDown(ns))

      output$outMediaSeriesDescription <-
        renderUI(CreateMediaSeriesDescriptionTextbox(ns))

      output$outMediaSeriesActionButton <-
        renderUI(CreateMediaSeriesActionButton(ns, "Add"))

      #####
      values <- reactiveValues(seriesData = NULL, episodeData = NULL)

      values$seriesData <- GetSeriesData()

      output$outMediaSeriesBrowse <-
        DT::renderDataTable(GetSeries(values$seriesData))

      ## Series Add button clicked
      observeEvent(input$mediaSeriesAdd, {

        message <- AddSeries(input$mediaSeriesTitle,
                             input$mediaSeriesYear,
                             input$mediaSeriesNetwork,
                             input$mediaSeriesDescription,
                             minYear,
                             currentYear,
                             maxYear)

        output$outMediaSeriesMessage <- renderText(message)

        if (substring(message, 1, 13) == "Series Added:")
        {
          output$outMediaSeriesTitle <-
            renderUI(CreateMediaSeriesTitleTextbox(ns))

          output$outMediaSeriesYear <-
            renderUI(CreateMediaSeriesYearTextbox(ns, minYear, currentYear, maxYear))

          output$outMediaSeriesNetwork <-
            renderUI(CreateMediaSeriesNetworkDropDown(ns))

          output$outMediaSeriesDescription <-
            renderUI(CreateMediaSeriesDescriptionTextbox(ns))

          values$seriesData <- GetSeriesData()

          output$outMediaSeriesBrowse <-
            DT::renderDataTable(GetSeries(values$seriesData))
        }
      })

      ## Series row selected
      observeEvent(input$outMediaSeriesBrowse_rows_selected, {
        output$outMediaSeriesTitle <-
          renderUI(CreateMediaSeriesTitleTextbox(
            ns,
            input$outMediaSeriesBrowse_rows_selected,
            values$seriesData))

        output$outMediaSeriesYear <-
          renderUI(CreateMediaSeriesYearTextbox(
            ns, minYear, currentYear, maxYear,
            input$outMediaSeriesBrowse_rows_selected,
            values$seriesData))

        output$outMediaSeriesNetwork <-
          renderUI(CreateMediaSeriesNetworkDropDown(
            ns,
            input$outMediaSeriesBrowse_rows_selected,
            values$seriesData))

        output$outMediaSeriesDescription <-
          renderUI(CreateMediaSeriesDescriptionTextbox(
            ns,
            input$outMediaSeriesBrowse_rows_selected,
            values$seriesData))

        output$outMediaSeriesMessage <- renderText("")

        output$outMediaSeriesActionButton <-
          renderUI(CreateMediaSeriesActionButton(ns, "Update"))
      })

      ## Series Update button clicked
      observeEvent(input$mediaSeriesUpdate, {

        seriesUid <- values$seriesData$SeriesUid[input$outMediaSeriesBrowse_rows_selected]

        message <- UpdateSeries(seriesUid,
                                input$mediaSeriesTitle,
                                input$mediaSeriesYear,
                                input$mediaSeriesNetwork,
                                input$mediaSeriesDescription,
                                minYear,
                                currentYear,
                                maxYear)

        output$outMediaSeriesMessage <- renderText(message)

        if (substring(message, 1, 15) == "Series Updated:")
        {
          output$outMediaSeriesTitle <-
            renderUI(CreateMediaSeriesTitleTextbox(ns))

          output$outMediaSeriesYear <-
            renderUI(CreateMediaSeriesYearTextbox(ns, minYear, currentYear, maxYear))

          output$outMediaSeriesNetwork <-
            renderUI(CreateMediaSeriesNetworkDropDown(ns))

          output$outMediaSeriesDescription <-
            renderUI(CreateMediaSeriesDescriptionTextbox(ns))

          output$outMediaSeriesActionButton <-
            renderUI(CreateMediaSeriesActionButton(ns, "Add"))

          #####
          values$seriesData <- GetSeriesData()

          output$outMediaSeriesBrowse <-
            DT::renderDataTable(GetSeries(values$seriesData))
        }
      })

      ## Refresh button clicked
      observeEvent(input$mediaSeriesResetButton, {
        output$outMediaSeriesTitle <-
          renderUI(CreateMediaSeriesTitleTextbox(ns))

        output$outMediaSeriesYear <-
          renderUI(CreateMediaSeriesYearTextbox(ns, minYear, currentYear, maxYear))

        output$outMediaSeriesNetwork <-
          renderUI(CreateMediaSeriesNetworkDropDown(ns))

        output$outMediaSeriesDescription <-
          renderUI(CreateMediaSeriesDescriptionTextbox(ns))

        output$outMediaSeriesMessage <- renderText("")

        output$outMediaSeriesActionButton <-
          renderUI(CreateMediaSeriesActionButton(ns, "Add"))

        #####
        values$seriesData <- GetSeriesData()

        output$outMediaSeriesBrowse <-
          DT::renderDataTable(GetSeries(values$seriesData))
      })

################################################################################################
################################################################################################
########## Episode "Module"

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

      ## Episode Add button clicked
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

      ## Episode Refresh button clicked
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

CreateMediaSeriesTitleTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$SeriesTitle[rowIndex]

  return (
    textInput(ns("mediaSeriesTitle"), "Title", inputValue)
  )
}

CreateMediaSeriesYearTextbox <- function(ns, minYear, currentYear, maxYear, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- format(Sys.Date(), "%Y")
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- format(Sys.Date(), "%Y")
  else
    inputValue <- dfData$SeriesYear[rowIndex]

  return (
    numericInput(ns("mediaSeriesYear"),
                 "Year",
                 min = minYear, max = maxYear, value = inputValue, step = 1)
  )
}

CreateMediaSeriesNetworkDropDown <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$NetworkName[rowIndex]

  ## try connecting to database; if the connection fails, return a
  ## DT::datatable with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    ## function accepts a character string and returns a DT::datatable
    return(p(paste("Error connecting to database:", con$message)))

  query <- "exec Reference.ListNetworks"

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

  if (length(dfData$NetworkName) > 0) {
    for (i in 1:length(dfData$NetworkName)) {
      choices <- c(choices, list(dfData$NetworkName[i]))
      if (dfData$NetworkName[i] == inputValue)
        selectedIndex <- i + 1
    }
  }

  selectedItem <- choices[selectedIndex]

  return(
    selectInput(
      ns("mediaSeriesNetwork"),
      "Network",
      choices = choices,
      selected = selectedItem
    )
  )
}

CreateMediaSeriesDescriptionTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$SeriesDescription[rowIndex]

  return (
    textInput(ns("mediaSeriesDescription"), "Desc", inputValue)
  )
}

CreateMediaSeriesActionButton <- function(ns, action)
{
  if (action == "Add")
    return(actionButton(ns("mediaSeriesAdd"), "Add"))
  else if (action == "Update")
    return(actionButton(ns("mediaSeriesUpdate"), "Update"))
  else if (action == "Delete")
    return(actionButton(ns("mediaSeriesDelete"), "Delete"))
}

GetSeriesData <- function()
{
  ## try connecting to database; if the connection fails, return a
  ## DT::datatable with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    ## function accepts a character string and returns a DT::datatable
    return(ReturnErrorDataTable(paste("Error connecting to database:",
                                      con$message)))

  query <- "exec Media.BrowseSeries"

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

GetSeries <- function(seriesData)
{
  dfData <- seriesData[2:5]

  if (nrow(dfData) < 1)
    return(ReturnErrorDataTable("No data found"))

  return(
    DT::datatable(dfData,
                  colnames = c("Title", "Year", "Network", "Description"),
                  rownames = FALSE,
                  selection = "single",
                  options = list(searching = TRUE))
  )
}

AddSeries <- function(title, year, networkName, description, minYear, currentYear, maxYear)
{
  if (trimws(title) == "")
    return("Series Title required")

  if (nchar(title) > 100)
    return("Movie Title too long; limit to 100")

  if (length(year) < 1)
    return("Year required")

  if (!is.numeric(year))
    return("Invalid Year")

  if (year < minYear || year > maxYear)
    return("Invalid Year")

  if (length(networkName) < 1)
    return("Network required")

  if (trimws(networkName) == "")
    return("Network required")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.AddSeries @seriesTitle = '", title,
                 "', @seriesYear = '", year,
                 "', @networkName = '", networkName, "'", sep = "")

  if (trimws(description) != "")
    query <- paste(query, ", @seriesDescription = '", description, "'", sep = "")

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

  return(paste("Series Added:", title))
}

UpdateSeries <- function(seriesUid, title, year, networkName, description, minYear, currentYear, maxYear)
{
  if (nchar(seriesUid) < 36)
    return("MovieUID required")

  if (trimws(title) == "")
    return("Series Title required")

  if (nchar(title) > 100)
    return("Movie Title too long; limit to 100")

  if (length(year) < 1)
    return("Year required")

  if (!is.numeric(year))
    return("Invalid Year")

  if (year < minYear || year > maxYear)
    return("Invalid Year")

  if (length(networkName) < 1)
    return("Network required")

  if (trimws(networkName) == "")
    return("Network required")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.UpdateSeries @seriesUid = '", seriesUid,
                 "', @seriesTitle = '", title,
                 "', @seriesYear = '", year,
                 "', @networkName = '", networkName, "'", sep = "")

  if (trimws(description) != "")
    query <- paste(query, ", @seriesDescription = '", description, "'", sep = "")

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

  return(paste("Series Updated:", title))
}

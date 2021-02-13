# Module UI function
mediaMovieModuleUI <- function(id, label = "Movie Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  library(DT)
  library(lubridate)
  library(stringr)

  tagList(
    fluidPage(
      h1("Movies"),
      fluidRow(
        column(3, uiOutput(ns("outMediaMovieTitle"))),
        column(2, uiOutput(ns("outMediaMovieReleaseDate"))),
        column(2, uiOutput(ns("outMediaMovieNetwork"))),
        column(4, uiOutput(ns("outMediaMovieSynopsis")))
      ),
      fluidRow(
        column(2, uiOutput(ns("outMediaMovieActionButton")))
      ),
      fluidRow(
        column(12, textOutput(ns("outMediaMovieMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outMediaMovieBrowse")),
      fluidRow(
        column(2, actionButton(ns("mediaMovieResetButton"), "Reset"))
      )
    )
  )
}

# Module server function
mediaMovieModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {

      ns <- session$ns

      output$outMediaMovieTitle <-
        renderUI(CreateMediaMovieTitleTextbox(ns))

      output$outMediaMovieReleaseDate <-
        renderUI(CreateMediaMovieReleaseDatePicker(ns))

      output$outMediaMovieNetwork <-
        renderUI(CreateMediaMovieNetworkDropDown(ns))

      output$outMediaMovieSynopsis <-
        renderUI(CreateMediaMovieSynopsisTextbox(ns))

      output$outMediaMovieActionButton <-
        renderUI(CreateMediaMovieActionButton(ns, "Add"))

      ########
      values <- reactiveValues(movieData = NULL)

      updateData <- function() {
        values$movieData <- GetMovieData()
      }
      updateData()  # also call updateData() whenever you want to reload the data

      output$outMediaMovieBrowse <-
        DT::renderDataTable(GetMovies(values$movieData))

      ## Add button clicked
      observeEvent(input$mediaMovieAdd, {

        message <- AddMovie(input$mediaMovieTitle,
                            input$mediaMovieReleaseDate,
                            input$mediaMovieNetwork,
                            input$mediaMovieSynopsis)

        output$outMediaMovieMessage <- renderText(message)

        if (substring(message, 1, 12) == "Movie Added:")
        {
          output$outMediaMovieTitle <-
            renderUI(CreateMediaMovieTitleTextbox(ns))

          output$outMediaMovieReleaseDate <-
            renderUI(CreateMediaMovieReleaseDatePicker(ns))

          output$outMediaMovieNetwork <-
            renderUI(CreateMediaMovieNetworkDropDown(ns))

          output$outMediaMovieSynopsis <-
            renderUI(CreateMediaMovieSynopsisTextbox(ns))

          #####
          updateData()

          output$outMediaMovieBrowse <-
            DT::renderDataTable(GetMovies(values$movieData))
        }
      })

      ## row selected
      observeEvent(input$outMediaMovieBrowse_rows_selected, {
        output$outMediaMovieTitle <-
          renderUI(CreateMediaMovieTitleTextbox(
            ns,
            input$outMediaMovieBrowse_rows_selected,
            values$movieData))

        output$outMediaMovieReleaseDate <-
          renderUI(CreateMediaMovieReleaseDatePicker(
            ns,
            input$outMediaMovieBrowse_rows_selected,
            values$movieData))

        output$outMediaMovieNetwork <-
          renderUI(CreateMediaMovieNetworkDropDown(
            ns,
            input$outMediaMovieBrowse_rows_selected,
            values$movieData))

        output$outMediaMovieSynopsis <-
          renderUI(CreateMediaMovieSynopsisTextbox(
            ns,
            input$outMediaMovieBrowse_rows_selected,
            values$movieData))

        output$outMediaMovieMessage <- renderText("")

        output$outMediaMovieActionButton <-
          renderUI(CreateMediaMovieActionButton(ns, "Update"))
      })

      ## Update button clicked
      observeEvent(input$mediaMovieUpdate, {

        movieUid <- values$movieData$MovieUid[input$outMediaMovieBrowse_rows_selected]

        message <- UpdateMovie(movieUid,
                               input$mediaMovieTitle,
                               input$mediaMovieReleaseDate,
                               input$mediaMovieNetwork,
                               input$mediaMovieSynopsis)

        output$outMediaMovieMessage <- renderText(message)

        if (substring(message, 1, 14) == "Movie Updated:")
        {
          output$outMediaMovieTitle <-
            renderUI(CreateMediaMovieTitleTextbox(ns))

          output$outMediaMovieReleaseDate <-
            renderUI(CreateMediaMovieReleaseDatePicker(ns))

          output$outMediaMovieNetwork <-
            renderUI(CreateMediaMovieNetworkDropDown(ns))

          output$outMediaMovieSynopsis <-
            renderUI(CreateMediaMovieSynopsisTextbox(ns))

          output$outMediaMovieActionButton <-
            renderUI(CreateMediaMovieActionButton(ns, "Add"))

          #####
          updateData()

          output$outMediaMovieBrowse <-
            DT::renderDataTable(GetMovies(values$movieData))
        }
      })

      ## Refresh button clicked
      observeEvent(input$mediaMovieResetButton, {
        output$outMediaMovieTitle <-
          renderUI(CreateMediaMovieTitleTextbox(ns))

        output$outMediaMovieReleaseDate <-
          renderUI(CreateMediaMovieReleaseDatePicker(ns))

        output$outMediaMovieNetwork <-
          renderUI(CreateMediaMovieNetworkDropDown(ns))

        output$outMediaMovieSynopsis <-
          renderUI(CreateMediaMovieSynopsisTextbox(ns))

        output$outMediaMovieMessage <- renderText("")

        output$outMediaMovieActionButton <-
          renderUI(CreateMediaMovieActionButton(ns, "Add"))

        #####
        updateData()

        output$outMediaMovieBrowse <-
          DT::renderDataTable(GetMovies(values$movieData))
      })
    }
  )
}

CreateMediaMovieTitleTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$MovieTitle[rowIndex]

  return (
    textInput(ns("mediaMovieTitle"), "Title", inputValue)
  )
}

CreateMediaMovieReleaseDatePicker <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- Sys.Date()
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
           missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- Sys.Date()
  else
    inputValue <- dfData$ReleaseDate[rowIndex]

  return (
    dateInput(ns("mediaMovieReleaseDate"), "Release Date", min = "1888-01-01", value = inputValue)
  )
}

CreateMediaMovieNetworkDropDown <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
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
      ns("mediaMovieNetwork"),
      "Network",
      choices = choices,
      selected = selectedItem
    )
  )
}

CreateMediaMovieSynopsisTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
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
    textInput(ns("mediaMovieSynopsis"), "Synopsis", inputValue)
  )
}

CreateMediaMovieActionButton <- function(ns, action)
{
  if (action == "Add")
    return(actionButton(ns("mediaMovieAdd"), "Add"))
  else if (action == "Update")
    return(actionButton(ns("mediaMovieUpdate"), "Update"))
  else if (action == "Delete")
    return(actionButton(ns("mediaMovieDelete"), "Delete"))
}

GetMovieData <- function()
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

  query <- "exec Media.BrowseMovies"

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

GetMovies <- function(movieData)
{
  dfData <- movieData[2:5]

  if (nrow(dfData) < 1)
    return(ReturnErrorDataTable("No data found"))

  return(
    DT::datatable(dfData,
                  colnames = c("Title", "Date", "Network", "Synopsis"),
                  rownames = FALSE,
                  selection = "single",
                  options = list(searching = TRUE))
  )
}

AddMovie <- function(title, releaseDate, networkName, synopsis)
{
  if (trimws(title) == "")
    return("Movie Title required")

  if (length(releaseDate) < 1)
    return("Release Date required")

  if (!is.Date(releaseDate))
    return("Invalid Release Date")

  if (length(networkName) < 1)
    return("Network required")

  if (trimws(networkName) == "")
    return("Network required")

  if (nchar(title) > 100)
    return("Movie Title too long; limit to 100")

  title <- str_replace_all(title, "'", "''")
  networkName <- str_replace_all(networkName, "'", "''")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.AddMovie @movieTitle = '", title,
                 "', @releaseDate = '", releaseDate,
                 "', @networkName = '", networkName, "'", sep = "")

  if (trimws(synopsis) != "")
  {
    synopsis <- str_replace_all(synopsis, "'", "''")
    query <- paste(query, ", @synopsis = '", synopsis, "'", sep = "")
  }

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

  return(paste("Movie Added:", title))
}

UpdateMovie <- function(movieUid, title, releaseDate, networkName, synopsis)
{
  if (nchar(movieUid) < 36)
    return("MovieUID required")

  if (trimws(title) == "")
    return("Movie Title required")

  if (nchar(title) > 100)
    return("Movie Title too long; limit to 100")

  if (length(releaseDate) < 1)
    return("Release Date required")

  if (!is.Date(releaseDate))
    return("Invalid Release Date")

  if (length(networkName) < 1)
    return("Network required")

  if (trimws(networkName) == "")
    return("Network required")

  title <- str_replace_all(title, "'", "''")
  networkName <- str_replace_all(networkName, "'", "''")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Media.UpdateMovie @movieUid = '", movieUid,
                 "', @movieTitle = '", title,
                 "', @releaseDate = '", releaseDate,
                 "', @networkName = '", networkName, "'", sep = "")

  if (trimws(synopsis) != "")
  {
    synopsis <- str_replace_all(synopsis, "'", "''")
    query <- paste(query, ", @synopsis = '", synopsis, "'", sep = "")
  }

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

  return(paste("Movie Updated:", title))
}

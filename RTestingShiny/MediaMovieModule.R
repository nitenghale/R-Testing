# Module UI function
mediaMovieModuleUI <- function(id, label = "Movie Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  library(DT)
  library(lubridate)
  
  tagList(
    fluidPage(
      h1("Movies"),
      fluidRow(
        column(3, textInput(ns("mediaMovieTitle"), "Title")),
        column(2, dateInput(ns("mediaMovieReleaseDate"), "Release Date")),
        column(2, uiOutput(ns("outMediaMovieNetwork"))),
        column(4, textInput(ns("mediaMovieSynopsis"), "Synopsis"))
      ),
      fluidRow(
        column(2, actionButton(ns("mediaMovieAdd"), "Add"))
      ),
      fluidRow(
        column(12, textOutput(ns("outMediaMovieMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outMediaMovieBrowse"))
    )
  )
}

# Module server function
mediaMovieModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {
      observeEvent(input$mediaMovieAdd, {
        
        message <- AddMovie(input$mediaMovieTitle, 
                            input$mediaMovieReleaseDate,
                            input$mediaMovieNetwork,
                            input$mediaMovieSynopsis)
        
        output$outMediaMovieMessage <- renderText(message)
        
        output$outMediaMovieBrowse <-
          DT::renderDataTable(GetMovies())
        
        #output$outMediaMovieNetwork <-
          #renderUI(CreateMediaMovieNetworkDropDown())
      })
      
      output$outMediaMovieBrowse <-
        DT::renderDataTable(GetMovies())
      
      output$outMediaMovieNetwork <-
        renderUI(CreateMediaMovieNetworkDropDown())
    }
  )    
}

GetMovies <- function()
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
  
  return(
    DT::datatable(dfData,
                  colnames = c("Title", "Date", "Network", "Synopsis"),
                  rownames = FALSE,
                  options = list(searching = TRUE))
  )
}

CreateMediaMovieNetworkDropDown <- function()
{
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

  if (length(dfData$NetworkName) > 0) {
    for (i in 1:length(dfData$NetworkName)) {
      choices <- c(choices, list(dfData$NetworkName[i]))
    }
  }

  return(
    selectInput(
      "mediaMovieNetwork",
      "Network",
      choices = choices
    )
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
    return("Network required - length error")
  
  if (trimws(networkName) == "")
    return("Network required")
  
  return(networkName)
  
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
  
  return(paste("Move Added:", title))
}

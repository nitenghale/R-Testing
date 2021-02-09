# Module UI function
mediaSeriesModuleUI <- function(id, label = "Series Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)

  library(DT)

  tagList(
    tabsetPanel(
      tabPanel("Series",
        fluidRow(
          column(3, uiOutput(ns("outMediaSeriesTitle"))),
          column(2, uiOutput(ns("outMediaSeriesYear"))),
          column(2, uiOutput(ns("outMediaSeriesNetwork"))),
          column(4, uiOutput(ns("outMediaSeriesDescription")))
        ),
        fluidRow(
          column(2, actionButton(ns("mediaSeriesAdd"), "Add"))
        ),
        fluidRow(
          column(12, textOutput(ns("outMediaSeriesMessage")))
        ),
        br(),
        DT::dataTableOutput(ns("outMediaSeriesBrowse"))
      ),
      tabPanel("Episodes",
         mediaEpisodeModuleUI("mediaEpisodeModule", "Episode Module")
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

      output$outMediaSeriesTitle <-
        renderUI(CreateMediaSeriesTitleTextbox(ns))

      output$outMediaSeriesYear <-
        renderUI(CreateMediaSeriesYearTextbox(ns, minYear, currentYear, maxYear))

      output$outMediaSeriesNetwork <-
        renderUI(CreateMediaSeriesNetworkDropDown(ns))

      output$outMediaSeriesDescription <-
        renderUI(CreateMediaSeriesDescriptionTextbox(ns))

      output$outMediaSeriesBrowse <-
        DT::renderDataTable(GetSeries())

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

          output$outMediaSeriesBrowse <-
            DT::renderDataTable(GetSeries())
        }

        #mediaEpisodeModule <-
          #mediaEpisodeModuleServer("mediaEpisodeModule", stringsAsFactors = FALSE)
      })
    }
  )
}

CreateMediaSeriesTitleTextbox <- function(ns)
{
  return (
    textInput(ns("mediaSeriesTitle"), "Title")
  )
}

CreateMediaSeriesYearTextbox <- function(ns, minYear, currentYear, maxYear)
{
  return (
    numericInput(ns("mediaSeriesYear"),
                 "Year",
                 min = minYear, max = maxYear, value = currentYear, step = 1)
  )
}

CreateMediaSeriesNetworkDropDown <- function(ns)
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
      ns("mediaSeriesNetwork"),
      "Network",
      choices = choices
    )
  )
}

CreateMediaSeriesDescriptionTextbox <- function(ns)
{
  return (
    textInput(ns("mediaSeriesDescription"), "Desc")
  )
}

GetSeries <- function()
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
    query <- paste(query, ", @description = '", description, "'", sep = "")

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

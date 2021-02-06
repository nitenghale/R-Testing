# Module UI function
referenceNetworkModuleUI <- function(id, label = "Network Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  library(DT)
  
  tagList(
    fluidPage(
      h1("Networks"),
      fluidRow(
        column(4, textInput(ns("referenceNetworkName"), "Name")),
        column(2, textInput(ns("referenceNetworkAbbreviation"), "Abbr")),
        column(2, numericInput(ns("referenceNetworkChannel"), "Channel", 
          min = 0, max = 99999.99, value = 0, step = .1))
      ),
      fluidRow(
        column(2, actionButton(ns("referenceNetworkAdd"), "Add"))
      ),
      fluidRow(
        column(12, textOutput(ns("outReferenceNetworkMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outReferenceNetworkBrowse"))
    )
  )
}

# Module server function
referenceNetworkModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    
    function(input, output, session) {
      observeEvent(input$referenceNetworkAdd, {
        
        message <- AddNetwork(input$referenceNetworkName, 
                              input$referenceNetworkAbbreviation,
                              input$referenceNetworkChannel)

        output$outReferenceNetworkMessage <- renderText(message)
          
        output$outReferenceNetworkBrowse <-
          renderDataTable(GetNetworks())
      })
      
      output$outReferenceNetworkBrowse <-
        DT::renderDataTable(GetNetworks())
    }
  )    
}

GetNetworks <- function()
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

  query <- "exec Reference.BrowseNetworks"
  
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
              colnames = c("Abbr", "Name", "Channel", "Maint", "User"),
              rownames = FALSE,
              options = list(searching = FALSE))
  )
}

AddNetwork <- function(networkName, networkAbbreviation, channelNumber)
{
  if (trimws(networkName) == "")
    return("Network Name required")
  
  if (!is.numeric(channelNumber))
    return("Channel Number must be numeric")
  
  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
                  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))
  
  query <- paste("exec Reference.AddNetwork @networkName = '", networkName,
                 "', @channelNumber = ", channelNumber, sep = "")
  
  if (trimws(networkAbbreviation) != "")
    query <- paste(query, 
                   ", @networkAbbreviation = '", 
                   networkAbbreviation, "'", sep = "")
  
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
  
  return(paste("Network Added:", networkName))
}

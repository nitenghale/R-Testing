# Module UI function
referenceStatusCodeModuleUI <- function(id, label = "Status Code Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  library(DT)
  
  tagList(
    fluidPage(
      h1("Status Codes"),
      fluidRow(
        column(2, uiOutput(ns("outReferenceStatusCode"))),
        column(4, uiOutput(ns("outReferenceStatusDescription")))
      ),
      fluidRow(
        column(2, actionButton(ns("referenceStatusCodeAdd"), "Add"))
      ),
      fluidRow(
        column(12, textOutput(ns("outReferenceStatusCodeMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outReferenceStatusCodeBrowse"))
    )
  )
}

# Module server function
referenceStatusCodeModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {
      
      ns <- session$ns
      
      output$outReferenceStatusCode <- 
        renderUI(CreateReferenceStatusCodeTextbox(ns))
      
      output$outReferenceStatusDescription <-
        renderUI(CreateReferenceStatusDescriptionTextbox(ns))
      
      output$outReferenceStatusCodeBrowse <-
        DT::renderDataTable(GetStatusCodes())
      
      observeEvent(input$referenceStatusCodeAdd, {
        
        message <- AddStatusCode(input$referenceStatusCode, 
                              input$referenceStatusDescription)
        
        output$outReferenceStatusCodeMessage <- renderText(message)
        
        if (substring(message, 1, 18) == "Status Code Added:")
        {
          output$outReferenceStatusCode <- 
            renderUI(CreateReferenceStatusCodeTextbox(ns))
        
          output$outReferenceStatusDescription <-
            renderUI(CreateReferenceStatusDescriptionTextbox(ns))
          
          output$outReferenceStatusCodeBrowse <-
            DT::renderDataTable(GetStatusCodes())
        }
      })
    }
  )    
}

CreateReferenceStatusCodeTextbox <- function(ns)
{
  return (
    textInput(ns("referenceStatusCode"), "Code")
  )
}

CreateReferenceStatusDescriptionTextbox <- function(ns)
{
  return (
    textInput(ns("referenceStatusDescription"), "Desc")
  )
}

GetStatusCodes <- function()
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
  
  query <- "exec Reference.BrowseStatusCodes"
  
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
                  colnames = c("Code", "Desc"),
                  rownames = FALSE,
                  options = list(searching = FALSE))
  )
}

AddStatusCode <- function(statusCode, statusDescription)
{
  if (trimws(statusCode) == "")
    return("Status Code required")
  
  if (nchar(statusCode) > 20)
    return("Status Code too long; limit to 20")
  
  if (nchar(StatusDescription) > 100)
    return("Status Description too long; limit to 100")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))
  
  query <- paste("exec Reference.AddStatusCode @statusCode = '", 
                 statusCode, "'", sep = "")
  
  if (trimws(statusDescription) != "")
    query <- paste(query, 
                   ", @statusDescription = '", 
                   statusDescription, "'", sep = "")
  
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
  
  return(paste("Status Code Added:", statusCode))
}

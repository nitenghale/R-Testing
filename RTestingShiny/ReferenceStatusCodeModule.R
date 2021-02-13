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
        column(2, uiOutput(ns("outReferenceStatusCodeActionButton")))
      ),
      fluidRow(
        column(12, textOutput(ns("outReferenceStatusCodeMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outReferenceStatusCodeBrowse")),
      fluidRow(
        column(2, actionButton(ns("referenceStatusCodeResetButton"), "Reset"))
      )
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

      output$outReferenceStatusCodeActionButton <-
        renderUI(CreateReferenceStatusCodeActionButton(ns, "Add"))

      ########
      values <- reactiveValues(statusData = NULL)

      updateData <- function() {
        values$statusData <- GetStatusData()
      }
      updateData()  # also call updateData() whenever you want to reload the data

      output$outReferenceStatusCodeBrowse <-
        DT::renderDataTable(GetStatusCodes(values$statusData))

      ## Add button clicked
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

          ########
          updateData()

          output$outReferenceStatusCodeBrowse <-
            DT::renderDataTable(GetStatusCodes(values$statusData))
        }
      })

      ## Row selected
      observeEvent(input$outReferenceStatusCodeBrowse_rows_selected, {
        output$outReferenceStatusCode <-
          renderUI(CreateReferenceStatusCodeTextbox(
            ns,
            input$outReferenceStatusCodeBrowse_rows_selected,
            values$statusData))

        output$outReferenceStatusDescription <-
          renderUI(CreateReferenceStatusDescriptionTextbox(
            ns,
            input$outReferenceStatusCodeBrowse_rows_selected,
            values$statusData))

        output$outReferenceStatusMessage <- renderText("")

        output$outReferenceStatusCodeActionButton <-
          renderUI(CreateReferenceStatusCodeActionButton(ns, "Update"))
      })

      ## Update button clicked
      observeEvent(input$referenceStatusCodeUpdate, {

        statusCodeId <- values$statusData$StatusCodeId[input$outReferenceStatusCodeBrowse_rows_selected]

        message <- UpdateStatusCode(statusCodeId,
                                 input$referenceStatusCode,
                                 input$referenceStatusDescription)

        output$outReferenceStatusCodeMessage <- renderText(message)

        if (substring(message, 1, 20) == "Status Code Updated:")
        {
          output$outReferenceStatusCode <-
            renderUI(CreateReferenceStatusCodeTextbox(
              ns = ns))#,
          #passedValue = input$referenceStatusCode))

          output$outReferenceStatusDescription <-
            renderUI(CreateReferenceStatusDescriptionTextbox(
              ns = ns))#,
          #passedValue = input$referenceStatusDescription))

          output$outReferenceStatusCodeActionButton <-
            renderUI(CreateReferenceStatusCodeActionButton(ns, "Add"))

          ########
          updateData()

          output$outReferenceStatusCodeBrowse <-
            DT::renderDataTable(GetStatusCodes(values$statusData))
        }
      })

      ## Refresh button clicked
      observeEvent(input$referenceStatusCodeResetButton, {
        output$outReferenceStatusCode <-
          renderUI(CreateReferenceStatusCodeTextbox(ns))

        output$outReferenceStatusDescription <-
          renderUI(CreateReferenceStatusDescriptionTextbox(ns))

        ########
        updateData()

        output$outReferenceStatusCodeBrowse <-
          DT::renderDataTable(GetStatusCodes(values$statusData))

        output$outReferenceStatusCodeActionButton <-
          renderUI(CreateReferenceStatusCodeActionButton(ns, "Add"))

        output$outReferenceStatusMessage <- renderText("")

        ########
        updateData()

        output$outReferenceStatusCodeBrowse <-
          DT::renderDataTable(GetStatusCodes(values$statusData))
      })
    }
  )
}

CreateReferenceStatusCodeTextbox <- function(ns, rowIndex = NA, dfData = NA)
{
  inputValue <- ""
  if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
      missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$StatusCode[rowIndex]

  return (
    textInput(ns("referenceStatusCode"), "Code", inputValue)
  )
}

CreateReferenceStatusDescriptionTextbox <- function(ns, rowIndex = NA, dfData = NA)
{
  inputValue <- ""
  if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
      missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$StatusDescription[rowIndex]

  return (
    textInput(ns("referenceStatusDescription"), "Desc", inputValue)
  )
}

CreateReferenceStatusCodeActionButton <- function(ns, action)
{
  if (action == "Add")
    return(actionButton(ns("referenceStatusCodeAdd"), "Add"))
  else if (action == "Update")
    return(actionButton(ns("referenceStatusCodeUpdate"), "Update"))
  else if (action == "Delete")
    return(actionButton(ns("referenceStatusCodeDelete"), "Delete"))
}

GetStatusData <- function()
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

  return(dfData)
}

GetStatusCodes <- function(statusData)
{
  dfData <- statusData[2:3]

  if (nrow(dfData) < 1)
    return(ReturnErrorDataTable("No data found"))

  return(
    DT::datatable(dfData,
                  colnames = c("Code", "Desc"),
                  rownames = FALSE,
                  selection = "single",
                  options = list(searching = FALSE))
  )
}

AddStatusCode <- function(statusCode, statusDescription)
{
  if (trimws(statusCode) == "")
    return("Status Code required")

  if (nchar(statusCode) > 20)
    return("Status Code too long; limit to 20")

  if (nchar(statusDescription) > 100)
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

UpdateStatusCode <- function(statusCodeId, statusCode, statusDescription)
{
  if (statusCodeId < 1)
    return("StatusID required")

  if (trimws(statusCode) == "")
    return("Status Code required")

  if (nchar(statusCode) > 20)
    return("Status Code too long; limit to 20")

  if (nchar(statusDescription) > 100)
    return("Status Description too long; limit to 100")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Reference.UpdateStatusCode @statusCodeId = ", statusCodeId,
                 ", @statusCode = '", statusCode, "'", sep = "")

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

  return(paste("Status Code Updated:", statusCode))
}

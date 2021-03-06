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
        column(4, uiOutput(ns("outReferenceNetworkName"))),
        column(2, uiOutput(ns("outReferenceNetworkAbbreviation"))),
        column(2, uiOutput(ns("outReferenceNetworkChannelNumber")))
      ),
      fluidRow(
        column(2, uiOutput(ns("outReferenceNetworkActionButton")))
      ),
      fluidRow(
        column(12, textOutput(ns("outReferenceNetworkMessage")))
      ),
      br(),
      DT::dataTableOutput(ns("outReferenceNetworkBrowse")),
      fluidRow(
        column(2, actionButton(ns("referenceNetworkResetButton"), "Reset"))
      )
    )
  )
}

# Module server function
referenceNetworkModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,

    function(input, output, session) {

      ns <- session$ns

      output$outReferenceNetworkName <-
        renderUI(CreateReferenceNetworkNameTextbox(ns))

      output$outReferenceNetworkAbbreviation <-
        renderUI(CreateReferenceNetworkAbbreviationTextbox(ns))

      output$outReferenceNetworkChannelNumber <-
        renderUI(CreateReferenceNetworkChannelNumberTextbox(ns))

      output$outReferenceNetworkActionButton <-
        renderUI(CreateReferenceNetworkActionButton(ns, "Add"))

      ########
      values <- reactiveValues(networkData = NULL)

      updateData <- function() {
        values$networkData <- GetNetworkData()
      }
      updateData()  # also call updateData() whenever you want to reload the data

      output$outReferenceNetworkBrowse <-
        DT::renderDataTable(GetNetworks(values$networkData))

      ## Add button clicked
      observeEvent(input$referenceNetworkAdd, {

        message <- AddNetwork(input$referenceNetworkName,
                              input$referenceNetworkAbbreviation,
                              input$referenceNetworkChannelNumber)

        output$outReferenceNetworkMessage <- renderText(message)

        if (substring(message, 1, 14) == "Network Added:")
        {
          output$outReferenceNetworkName <-
            renderUI(CreateReferenceNetworkNameTextbox(ns))

          output$outReferenceNetworkAbbreviation <-
            renderUI(CreateReferenceNetworkAbbreviationTextbox(ns))

          output$outReferenceNetworkChannelNumber <-
            renderUI(CreateReferenceNetworkChannelNumberTextbox(ns))

          ########
          updateData()

          output$outReferenceNetworkBrowse <-
            DT::renderDataTable(GetNetworks(values$networkData))
        }
      })

      ## row selected
      observeEvent(input$outReferenceNetworkBrowse_rows_selected, {
        output$outReferenceNetworkName <-
          renderUI(CreateReferenceNetworkNameTextbox(
            ns,
            input$outReferenceNetworkBrowse_rows_selected,
            values$networkData))

        output$outReferenceNetworkAbbreviation <-
          renderUI(CreateReferenceNetworkAbbreviationTextbox(
            ns,
            input$outReferenceNetworkBrowse_rows_selected,
            values$networkData))

        output$outReferenceNetworkChannelNumber <-
          renderUI(CreateReferenceNetworkChannelNumberTextbox(
            ns,
            input$outReferenceNetworkBrowse_rows_selected,
            values$networkData))

        output$outReferenceNetworkMessage <- renderText("")

        output$outReferenceNetworkActionButton <-
          renderUI(CreateReferenceNetworkActionButton(ns, "Update"))
      })

      ## Update button clicked
      observeEvent(input$referenceNetworkUpdate, {

        networkId <- values$networkData$NetworkId[input$outReferenceNetworkBrowse_rows_selected]

        message <- UpdateNetwork(networkId,
                                 input$referenceNetworkName,
                                 input$referenceNetworkAbbreviation,
                                 input$referenceNetworkChannelNumber)

        output$outReferenceNetworkMessage <- renderText(message)

        if (substring(message, 1, 16) == "Network Updated:")
        {
          output$outReferenceNetworkName <-
            renderUI(CreateReferenceNetworkNameTextbox(
              ns = ns))#,
              #passedValue = input$referenceNetworkName))

          output$outReferenceNetworkAbbreviation <-
            renderUI(CreateReferenceNetworkAbbreviationTextbox(
              ns = ns))#,
              #passedValue = input$referenceNetworkAbbreviation))

          output$outReferenceNetworkChannelNumber <-
            renderUI(CreateReferenceNetworkChannelNumberTextbox(
              ns = ns))#,
              #passedValue = input$referenceNetworkChannelNumber))

          output$outReferenceNetworkActionButton <-
            renderUI(CreateReferenceNetworkActionButton(ns, "Add"))

          ########
          updateData()

          output$outReferenceNetworkBrowse <-
            DT::renderDataTable(GetNetworks(values$networkData))
        }
      })

      ## Refresh button clicked
      observeEvent(input$referenceNetworkResetButton, {
        output$outReferenceNetworkName <-
          renderUI(CreateReferenceNetworkNameTextbox(ns))

        output$outReferenceNetworkAbbreviation <-
          renderUI(CreateReferenceNetworkAbbreviationTextbox(ns))

        output$outReferenceNetworkChannelNumber <-
          renderUI(CreateReferenceNetworkChannelNumberTextbox(ns))

        output$outReferenceNetworkActionButton <-
          renderUI(CreateReferenceNetworkActionButton(ns, "Add"))

        output$outReferenceNetworkMessage <- renderText("")

        ########
        updateData()

        output$outReferenceNetworkBrowse <-
          DT::renderDataTable(GetNetworks(values$networkData))
      })
    }
  )
}

CreateReferenceNetworkNameTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
      missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$NetworkName[rowIndex]

  return (
    textInput(ns("referenceNetworkName"), "Name", inputValue)
  )
}

CreateReferenceNetworkAbbreviationTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- ""
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
      missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- ""
  else
    inputValue <- dfData$NetworkAbbreviation[rowIndex]

  return (
    textInput(ns("referenceNetworkAbbreviation"), "Abbr", inputValue)
  )
}

CreateReferenceNetworkChannelNumberTextbox <- function(ns, rowIndex = NA, dfData = NA, passedValue = NA)
{
  inputValue <- 0
  if (!missing(passedValue) && length(passedValue) > 0 && !is.na(passedValue))
    inputValue <- passedValue
  else if (missing(rowIndex) || length(rowIndex) < 1 || is.na(rowIndex) ||
      missing(dfData) || length(dfData) < 1 || is.na(dfData))
    inputValue <- 0
  else
    inputValue <- dfData$ChannelNumber[rowIndex]

  return (
    numericInput(ns("referenceNetworkChannelNumber"),
                    "Channel",
                    min = 0, max = 99999.99, value = inputValue, step = .1)
  )
}

CreateReferenceNetworkActionButton <- function(ns, action)
{
  if (action == "Add")
    return(actionButton(ns("referenceNetworkAdd"), "Add"))
  else if (action == "Update")
    return(actionButton(ns("referenceNetworkUpdate"), "Update"))
  else if (action == "Delete")
    return(actionButton(ns("referenceNetworkDelete"), "Delete"))
}

GetNetworkData <- function()
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

  return(dfData)
}

GetNetworks <- function(networkData)
{
  dfData <- networkData[2:4]

  if (nrow(dfData) < 1)
    return(ReturnErrorDataTable("No data found"))

  return(
    DT::datatable(dfData,
              colnames = c("Abbr", "Name", "Channel"),
              rownames = FALSE,
              selection = "single",
              options = list(searching = FALSE))
  )
}

AddNetwork <- function(networkName, networkAbbreviation, channelNumber)
{
  if (trimws(networkName) == "")
    return("Network Name required")

  if (!is.na(channelNumber) && !is.numeric(channelNumber))
    return("Channel Number must be numeric")

  if (nchar(networkName) > 50)
    return("Network Name too long; limit to 50")

  if (nchar(networkAbbreviation) > 10)
    return("Network Abbreviation too long; limit to 10")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
                  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Reference.AddNetwork @networkName = '", networkName, "'", sep = "")

  if (trimws(networkAbbreviation) != "")
    query <- paste(query,
                   ", @networkAbbreviation = '",
                   networkAbbreviation, "'", sep = "")

  if (!is.na(channelNumber))
    query <- paste(query, ", @channelNumber = ", channelNumber, sep = "")

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

UpdateNetwork <- function(networkId, networkName, networkAbbreviation, channelNumber)
{
  if (networkId < 1)
    return("NetworkID required")

  if (trimws(networkName) == "")
    return("Network Name required")

  if (!is.na(channelNumber) && !is.numeric(channelNumber))
    return("Channel Number must be numeric")

  if (nchar(networkName) > 50)
    return("Network Name too long; limit to 50")

  if (nchar(networkAbbreviation) > 10)
    return("Network Abbreviation too long; limit to 10")

  ## try connecting to database; if the connection fails, return
  ## text with the error message
  con <- tryCatch(GetDatabaseConnection(),
                  error = function(err) { return(err) })
  ## above is what assigns the error to con, in message
  if (typeof(con) == "list")
    return(paste("Error connecting to database:", con$message))

  query <- paste("exec Reference.UpdateNetwork @networkId = '", networkId,
                 "', @networkName = '", networkName, "'", sep = "")

  if (trimws(networkAbbreviation) != "")
    query <- paste(query,
                   ", @networkAbbreviation = '",
                   networkAbbreviation, "'", sep = "")

  if (!is.na(channelNumber))
    query <- paste(query, ", @channelNumber = ", channelNumber, sep = "")

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

  return(paste("Network Updated:", networkName))
}

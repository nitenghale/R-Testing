GetDatabaseConnection <- function() {
  library(DBI)
  library(odbc)

  server <- "(local)"
  driver <- "ODBC Driver 17 for SQL Server"
  database <- "RTesting"
  uid <- "RTesting"
  pwd <- "SomePassword"

  return(
    dbConnect(
      odbc::odbc(),
      .connection_string = paste("Driver={", driver, "};", sep = ""),
      Server = server,
      Database = database,
      UID = uid,
      PWD = pwd
    )
  )
}

ReturnErrorDataTable <- function(error) {
  return(
    DT::datatable(
      data.frame(as.character(error)),
      colnames = c(""),
      rownames = FALSE,
      options = list(searching = FALSE,
                     paging = FALSE,
                     info = FALSE
      )
    )
  )
}

ReturnErrorDataFrame <- function(error) {
  return(as.data.frame(as.character(error)))
}

# Module UI function
networkModuleUI <- function(id, label = "Network Module") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    h1("Network Module")
  )
}

# Module server function
networkModuleServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {
    }
  )    
}

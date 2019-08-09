# To connect and interact wth database and define processes at database/server

library(shiny)

shinyServer(function(input, output,session) {
  
  searchQuery <- eventReactive(input$search, {
    load_data(input$query)
  })
  
  getuser <- eventReactive(input$signin, {
    if (input$username == "bf2_private" & input$password == "ilovetrex") {
      current_user <<- input$username
      return(paste("Welcome user", input$username, "!"))
    } else if (input$username == "bf2_public" & input$password == "3littlepigs") {
      current_user <<- input$username
      return(paste("Welcome user", input$username, "!"))
    } else {
      return("Sign in failed !")
    }
  })
  
  # Main interactions table
  output$table <- DT::renderDataTable(DT::datatable({
    data <- searchQuery()
    if (current_user == "none") return(data.frame(Error="You don't have permission to query the data"))
    if (input$hiconfi) data <- subset(data, MIST > 0.7 & Abundance > 0)
    if (is.null(data)) return (data.frame("NO RESULTS" = ""))
    if (current_user == "bf2_public") data <- subset(data, dataset %in% public_datasets)
    data = data[,fields]
    data
  },
  rownames = FALSE, 
  filter = "none", selection = "single", escape = FALSE, extensions = 'Buttons',
  options = list( dom = 'Bfrtip', pageLength=100, lengthMenu = c(10, 50, 100, 10000), autoWidth = TRUE, buttons = c('excel', 'pdf'))
  ))
  
  output$login <- renderText ({
    getuser()
  })
  
})

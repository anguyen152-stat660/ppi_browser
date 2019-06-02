library(shiny)

shinyServer(function(input, output,session) {
  
  searchQuery <- eventReactive(input$search, {
    load_data(input$query)
  })
  
  # Main interactions table
  output$table <- DT::renderDataTable(DT::datatable({
    data <- searchQuery()
    if (input$hiconfi) data <- subset(data, MIST > 0.7 & Abundance > 0)
    if (is.null(data)) return (data.frame("NO RESULTS" = ""))
    data = data[,fields]
    data
  },
  rownames = FALSE, 
  filter = "none", selection = "single", escape = FALSE, extensions = 'Buttons',
  options = list( dom = 'Bfrtip', pageLength=100, lengthMenu = c(10, 50, 100, 10000), autoWidth = TRUE, buttons = c('excel', 'pdf'))
  ))
  
})

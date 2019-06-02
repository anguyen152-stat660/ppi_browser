library(shiny)
library(shinythemes)

shinyUI (
  fluidPage(theme = shinytheme("cerulean"),  titlePanel(""),
            fluidRow(
              column(2,  img(src='logo.png', width = "130px", height = "50px")),
              column(10,  h3("Multiple Pathogen Interactome Browser"))
            ),
            br(),br(),br(),
            fluidRow(
              column(8, p(class = 'text-right', textInput('query', label = "Search for genes or pathogens (e.g enes: PIK3CA, ZFR or HIV, HCV):", value = "", width = '100%')))
            ),
            fluidRow(
              column(8, p(class = 'text-left', actionButton("search", "search", icon = icon("search"))))
            ),
            fluidRow(
              column(12,checkboxInput("hiconfi", label = "High confidence interactions (MiST > 0.7)", value = TRUE))
            ),
            fluidRow(
              column(12, offset = 0.2, 
                     DT::dataTableOutput('table')
              )
            ),
            hr(),
            p("Version 1.0 (May 2019): 210,646 interactions in 13 pathogens")
  )
)

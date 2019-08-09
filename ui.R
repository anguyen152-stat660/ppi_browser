# To create and design user-interface

# www to configure interace``

library(shiny)
library(shinythemes)

shinyUI (
  fluidPage(theme = shinytheme("cerulean"),  titlePanel(""),
            fluidRow(
              column(2,  img(src='logo.png', width = "130px", height = "50px")),
              column(6,  h3("Multiple Pathogen Interactome Browser")),
              column(1, textInput('username', label = "Username:", value = "", placeholder = '', width = '100%')),
              column(1, passwordInput('password', label = "Password:", value = "", width = '100%')),
              br(),
              column(1, actionButton("signin", "Sign in"))
            ),
            fluidRow(
              column(8, textOutput('login'))
            ),
            br(),br(),br(),
            fluidRow(
              column(8, p(class = 'text-right', textInput('query', label = "Search for genes or pathogens (e.g genes: PIK3CA, ZFR or pathogens: HIV, HCV):", value = "", width = '100%')))
            ),
            fluidRow(
              column(8, p(class = 'text-left', actionButton("search", "search", icon = icon("search"))))
            ),
            fluidRow(
              column(12,checkboxInput("hiconfi", label = "High confidence interactions (MiST > 0.7)", value = FALSE))
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

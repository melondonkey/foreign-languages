
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Foreign Language Speakers in the US"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput('language',
                  label = h3("Select a Language"),
                  choices = language_list,
                  selected = 'Russian'
                  )

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("mymap")
    )
  )
))

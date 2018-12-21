

shinyUI(fluidPage(

  # Application title
  titlePanel("Foreign Language Speakers in the US"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput('language',
                  label = "Select a Language",
                  choices = unique(df$Language),
                  selected = 'Russian'
                  ),
      textInput(
        'location',
        'Type your location',
        'atlanta ga'
      ),
    submitButton(text = "Apply Changes", icon = NULL, width = NULL)

    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
       tabPanel("Map", leafletOutput('map') ),
       tabPanel("Summary Chart", plotlyOutput('summaryPlot'))
      )
    )
  )
))

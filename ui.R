

shinyUI(fluidPage(

  # Application title
  titlePanel("Foreign Language Speakers in the US"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput('language',
                  label = h3("Select a Language"),
                  choices = unique(df$Language),
                  selected = 'Russian'
                  )

    ),

    # Show a plot of the generated distribution
    mainPanel(
       leafletOutput('map', width = "500px", height = "1000px")
    )
  )
))

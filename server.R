
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
library(ggmap)
library(here)
library(maptools)
library(readr)
library(dplyr)

df <- read_csv(here::here('census_data.csv'))

language_list <- unique(df$Language)

zipcodes.shp <- readShapeSpatial(here::here('shape-files',
                                            'cb_2016_us_zcta510_500k',
                                            'cb_2016_us_zcta510_500k.shp'))

mapped <- subset(zipcodes.shp, ZCTA5CE10 %in% df$Zip)


start_loc <- geocode('Atlanta, GA', source="dsk")



shinyServer(function(input, output) {
  
  mylang <- reactive({
    df %>% filter(Language==input$language) %>% #Choose language here!
      mutate(Zip = sprintf('%05d',Zip)) %>%
      filter(`Estimate Total` > 0) %>%
      arrange(Zip)
  })
  
  lang_poly <- reactive({
    subset(mapped, ZCTA5CE10 %in% mylang()$Zip)

    #mylang <- mylang[order(match(mylang$Zip, mapped@data$ZCTA5CE10)), ] #match the sort order in the polygon
  })
  
  mylang2 <- reactive({
    mylang()[order(match(mylang()$Zip, lang_poly()@data$ZCTA5CE10)), ]
  })
  
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles('OpenStreetMap.BlackAndWhite') %>%  # Esri.WorldGrayCanvas
      setView(lng = start_loc[1], lat = start_loc[2], zoom = 9) 
      
      
  })
  
  colorpal <- reactive({
    colorQuantile(palette = "viridis", 
                  domain = mylang()$`Estimate Total`, 
                  probs = c(0,.5, .75, .9, .95, .99, 1), 
                  reverse = TRUE)
  })
    
  
  observe({
    pal <- colorpal()
    
    leafletProxy("map") %>%
      addPolygons(data = lang_poly(),
        stroke = FALSE,
        fillOpacity = .5,
         fillColor = ~pal(mylang2()$`Estimate Total`),
        #   popup = mylang$Zip_string,
        popupOptions = NULL,
        #  label = mylabel,
        labelOptions = NULL,
        options = pathOptions(),
        highlightOptions = NULL
        
        
        
      )
      
    
  })
    
}) 
    
  

  
  
  
  

    
 




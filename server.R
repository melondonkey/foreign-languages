

shinyServer(function(input, output) {
  
  mylong <- reactive({
     geocode(input$location, source="dsk")[1]
 
  })  
  
  mylat <- reactive({
    geocode(input$location, source="dsk")[2]
    
  })

  mylang <- reactive({
    df %>% 
      filter(Language==input$language) %>% #Choose language here!
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
    pal <- colorpal()
    
    leaflet() %>%
         
      setView(
        #lng = start_loc[1], 
        #lat = start_loc[2], 
        lng =  mylong(),
        lat =  mylat(),
        zoom = 9
        )  %>%
      addProviderTiles('OpenStreetMap.BlackAndWhite') %>%
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
  
  colorpal <- reactive({
    colorQuantile(palette = "viridis", 
                  domain = mylang()$`Estimate Total`, 
                  probs = c(0,.5, .75, .9, .95, .99, 1), 
                  reverse = TRUE)
  })
  
  output$summaryPlot <- renderPlotly({
   p<- mylang() %>% group_by(`City State`) %>%
      summarize(ttl = sum(`Estimate Total`)) %>%
      filter(!is.na(`City State`)) %>%
      arrange(-ttl) %>%
      top_n(25) %>%
      ggplot(aes(x = reorder(`City State`, ttl), y = ttl)) + geom_bar(stat = 'identity') +
      coord_flip() +
      xlab("City") +
      ylab("# Speakers") +
      scale_y_continuous(labels = scales::comma) +
      ggtitle("Top 25 Metro Areas for this Language")
   p <- ggplotly(p, tooltip = c('y'))
   
  })
    
  
 
    
}) 
    
  

  
  
  
  

    
 




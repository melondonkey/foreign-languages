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

start_loc <- geocode('Atlanta, GA', source="dsk")


mylang <- df %>% filter(Language=='Russian') %>% #Choose language here!
  mutate(Zip = sprintf('%05d',Zip)) %>%
  filter(`Estimate Total` > 0) %>%
  arrange(Zip)


mapped <- subset(zipcodes.shp, ZCTA5CE10 %in% mylang$Zip)
mapped@data$ZCTA5CE10 <- as.character(mapped@data$ZCTA5CE10)


mylang <- mylang[order(match(mylang$Zip, mapped@data$ZCTA5CE10)), ] #match the sort order in the polygon






##Parameters
mypal <- colorQuantile(palette = "viridis", 
                       domain = mylang$`Estimate Total`, 
                       probs = c(0,.5, .75, .9, .95, .99, 1), 
                       reverse = TRUE)

mylabel <- paste0(mylang$Zip, " ", mylang$`Zip Description`, " - ", mylang$`Estimate Total`)

leaflet() %>%
  addProviderTiles('OpenStreetMap.BlackAndWhite') %>%  # Esri.WorldGrayCanvas
  setView(lng = start_loc[1], lat = start_loc[2], zoom = 10) %>%
  addPolygons(data = mapped,
              stroke = FALSE,
              fillOpacity = .5,
              fillColor = ~mypal(mylang$`Estimate Total`),
              popup = mylang$Zip_string,
              popupOptions = NULL,
              label = mylabel,
              labelOptions = NULL,
              options = pathOptions(),
              highlightOptions = NULL
              ) %>%
  addLegend(position = "bottomright",
            pal = mypal,
            values = mylang$`Estimate Total`,
            labFormat = function(type, cuts, p) {
              n = length(cuts)
              p = paste0(round(p * 100), '%')
              cuts = paste0(formatC(round(cuts[-n]) ), " - ", prettyNum( round(cuts[-1]) ))
              # mouse over the legend labels to see the percentile ranges
              paste0(
                '<span title="', p[-n], " - ", p[-1], '">', cuts,
                '</span>'
              )
            } 
            )



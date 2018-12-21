
#all that has to be done at beginning

library(shiny)
library(leaflet)
library(ggmap)
library(here)
#library(maptools)
library(readr)
library(dplyr)
library(rgdal)
library(plotly)

df <- read_csv(here::here('census_data.csv'))

language_list <- unique(df$Language)

#zipcodes.shp <- readShapeSpatial(here::here('shape-files',
#                                            'cb_2016_us_zcta510_500k',
#                                            'cb_2016_us_zcta510_500k.shp'))

zipcodes.shp <- rgdal::readOGR(here::here('shape-files',
                          'cb_2016_us_zcta510_500k',
                          'cb_2016_us_zcta510_500k.shp'))

mapped <- subset(zipcodes.shp, ZCTA5CE10 %in% df$Zip)


#start_loc <- geocode('Atlanta, GA', source="dsk")
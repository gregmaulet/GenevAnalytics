#install.packages("rgdal")
#install.packages("sp")
library(geojsonio)
#install.packages("leaflet")
library(leaflet)
library(sp)
library(htmltools)
library(htmlwidgets)
library(rgdal)
library(ggplot2)
library(jsonlite)
library(data.table)
library(dplyr)
library(ggpubr)
library(grid)
#install.packages("tigris")
library(tigris)



NInfractions_08_19=NInfractions_08_19 %>%rename(city=`...1`)
NInfractions_08_19=NInfractions_08_19[-1,]
NInfractions_19=NInfractions_08_19 %>%select(city,`2019`)
infractions <- merge(NInfractions_19, cities_coordinates)
infractions = as.data.frame(infractions)
infractions=infractions %>% rename(data=`2019`)
infractions=infractions %>% rename(Lat=lat)
infractions=infractions %>% rename(Lng=lng)
infractions$Lng= as.character(infractions$Lng)
class(infractions$Lng)
infractions$Lng= as.numeric(infractions$Lng)
class(infractions$Lng)
infractions$Lat= as.character(infractions$Lat)
class(infractions$Lat)
infractions$Lat= as.numeric(infractions$Lat)
class(infractions$Lat)

m <- leaflet() %>% addTiles()
m <- leaflet(infractions) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
colors <- colorQuantile("YlOrRd", infractions$data)
m %>% addCircleMarkers(lng = ~Lng, lat = ~Lat, radius = ~sqrt(data)/4, color = ~colors(data), label = ~paste(city, ":", data), fillOpacity = 0.8)






###  WAY 1 ###

cities_bound <- geojsonio::geojson_read("Desktop/GenevAnalytics/geneva_municipalities_boundaries.geojson", what="sp")
#"geneva_municipalities_boundaries.geojson" is made from the swiss municipalties boundaries open data json file and selected with QGIS, because the canton data from SITG open data was not working  
m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()

pal <- colorNumeric("YlOrRd", domain = infractions$`NInfractions_08_19$`2019`[2:46]`)
labels <- sprintf(NInfractions_08_19$city, NInfractions_08_19$`2019`) %>% lapply(htmltools::HTML)

m %>% addPolygons(
  fillColor = ~pal(NInfractions_08_19$`2019`),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))

# to avoid the problem of misplacement on the map, we try to integrate separated data to the json file. It will be 

infractions <- geo_join(cities_bound@data, NInfractions_19, "name", "NInfraction_19$city")




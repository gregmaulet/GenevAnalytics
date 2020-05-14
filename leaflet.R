#install.packages("rgdal")
#install.packages("sp")
library(geojsonio)
#install.packages("leaflet")
library(leaflet)
library(sp)
library(htmltools)
library(htmlwidgets)
library(rgdal)
library(jsonlite)
library(shiny)
library(plyr)
library(data.table)

#INFRACTIONS DATA MODELLING 
library(dplyr)
NInfractions_08_19=NInfractions_08_19 %>%dplyr::rename(city=`...1`)
NInfractions_08_19=NInfractions_08_19[-1,]
NInfractions_19=NInfractions_08_19 %>%dplyr::select(city,`2019`)
infractions <- merge(NInfractions_19, cities_coordinates)
infractions = as.data.frame(infractions)
infractions=infractions %>% dplyr::rename(data=`2019`)
infractions$lng= as.character(infractions$lng)
class(infractions$lng)
infractions$lng= as.numeric(infractions$lng)
class(infractions$lng)
infractions$lat= as.character(infractions$lat)
class(infractions$lat)
infractions$lat= as.numeric(infractions$lat)
class(infractions$lat)

#MEDECINS DATA MODELLING 
NMedecins=NMedecins %>% dplyr::rename(city=`...1`)
NMedecins=NMedecins[-1,-2]
medecins <- merge(NMedecins, cities_coordinates)
medecins = as.data.frame(medecins)
medecins=medecins %>% dplyr::rename(nb_medecins=NMedecins)
medecins$lng= as.character(medecins$lng)
class(medecins$lng)
medecins$lng= as.numeric(medecins$lng)
class(medecins$lng)
medecins$lat= as.character(medecins$lat)
class(medecins$lat)
medecins$lat= as.numeric(medecins$lat)
class(medecins$lat)


# SHINY STRUCTURE
ui <- fluidPage(
  
  leafletOutput("mymap"),
  
)

server <- function(input, output, session) {
  
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      etc. 
  })
}

shinyApp(ui, server)

#LEAFLET INFRACTIONS 
m <- leaflet() %>% addTiles()
m <- leaflet(infractions) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
colors_infractions <- colorQuantile("YlOrRd", infractions$data)
m %>% addCircleMarkers(lng = ~lng, lat = ~lat, radius = ~sqrt(data)/4, color = ~colors_infractions(data), label = ~paste(city, ":", data), fillOpacity = 0.8)


#LEAFLET MEDECINS 
m <- leaflet() %>% addTiles()
m <- leaflet(medecins) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
colors_medecins <- colorQuantile("YlOrRd", medecins$nb_medecins, n=2)
m %>% addCircleMarkers(lng = ~lng, lat = ~lat, color = ~colors_medecins(nb_medecins) ,radius = ~sqrt(nb_medecins), label = ~paste(city, ":", nb_medecins), fillOpacity = 0.8)






### LEAFLET WITH POLYGONS TRIAL ###

cities_bound <- geojsonio::geojson_read("https://github.com/gregmaulet/GenevAnalytics/blob/master/geneva_municipalities_boundaries.geojson", what="sp")

cities_bound <- geojsonio::geojson_read("Desktop/GenevAnalytics/geneva_municipalities_boundaries.geojson", what="sp")
# "geneva_municipalities_boundaries.geojson" is made from the swiss municipalties boundaries open data json file 
# and selected with QGIS, because the canton data from SITG open data was not working  

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = infractions$data)
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

# to avoid the problem of misplacement on the map, we tried to integrate separated data to the json file. 
infractions <- geo_join(cities_bound@data, NInfractions_19, "name", "NInfraction_19$city")
# This function has no error message, but no effect. After hours of research, we didn't find a solution 
# either replace the cities or to combine ou NInfractions dataframe with the json file. 



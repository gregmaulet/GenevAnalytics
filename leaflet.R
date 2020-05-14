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
library(dplyr)
library(data.table)
source("Data_Analysis.R")

cities_coordinates=Latitude_Longitude
cities_coordinates=cities_coordinates %>% dplyr::rename(city=`...1`)
cities_coordinates=cities_coordinates %>% dplyr::rename(lng=lon)

#INFRACTIONS DATA MODELLING 
NInfractions_08_19=NInfractions_08_19 %>%dplyr::rename(city=`...1`)
NInfractions_08_19=NInfractions_08_19[-1,-2]
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

#ECOLES PRIMAIRES DATA MODELLING 
NEcolePrimaire=NEcolePrimaire %>% dplyr::rename(city=`...1`)
NEcolePrimaire=NEcolePrimaire[-1,-2]
ecoles <- merge(NEcolePrimaire, cities_coordinates)
ecoles = as.data.frame(ecoles)
ecoles=ecoles %>% dplyr::rename(nb_ecole=Necole)
ecoles$lng= as.character(ecoles$lng)
class(ecoles$lng)
ecoles$lng= as.numeric(ecoles$lng)
class(ecoles$lng)
ecoles$lat= as.character(ecoles$lat)
class(ecoles$lat)
ecoles$lat= as.numeric(ecoles$lat)
class(ecoles$lat)

#ECOLES PRIMAIRES DATA MODELLING 
NEcolePrimaire=NEcolePrimaire %>% dplyr::rename(city=`...1`)
NEcolePrimaire=NEcolePrimaire[-1,-2]
ecoles <- merge(NEcolePrimaire, cities_coordinates)
ecoles = as.data.frame(ecoles)
ecoles=ecoles %>% dplyr::rename(nb_ecole=Necole)
ecoles$lng= as.character(ecoles$lng)
class(ecoles$lng)
ecoles$lng= as.numeric(ecoles$lng)
class(ecoles$lng)
ecoles$lat= as.character(ecoles$lat)
class(ecoles$lat)
ecoles$lat= as.numeric(ecoles$lat)
class(ecoles$lat)

#HABITANTS DATA MODELLING 
NHabitants_00_19=NHabitants_00_19 %>% dplyr::rename(city=`...1`)
NHabitants_00_19=NHabitants_00_19[-1,-2]
NHabitants_00_19=NHabitants_00_19 %>%dplyr::select(city,`2019`)
hab <- merge(NHabitants_00_19, cities_coordinates)
hab = as.data.frame(hab)
hab=hab %>% dplyr::rename(nb_hab=`2019`)
hab$lng= as.character(hab$lng)
hab$lng= as.numeric(hab$lng)
class(hab$lng)
hab$lat= as.character(hab$lat)
hab$lat= as.numeric(hab$lat)
class(hab$lat)

#SUPERMARKETS / KM^2 DATA MODELLING 
setDT(ratio_Supermarches, keep.rownames = TRUE)[]
ratio_Supermarches=ratio_Supermarches %>%dplyr::rename(city=rn)
ratio_Supermarches=ratio_Supermarches[-1,-2]
ratio_Supermarches=ratio_Supermarches %>%dplyr::select(city,"Total Super")
supermarkets <- merge(ratio_Supermarches, cities_coordinates)
supermarkets = as.data.frame(supermarkets)
supermarkets=supermarkets %>% dplyr::rename(nb_supermarkets="Total Super")
supermarkets$lng= as.character(supermarkets$lng)
supermarkets$lng= as.numeric(supermarkets$lng)
supermarkets$lat= as.character(supermarkets$lat)
supermarkets$lat= as.numeric(supermarkets$lat)

#SUPERFICIE DATA MODELLING
setDT(Superficie_OK, keep.rownames = TRUE)[]
Superficie_OK=Superficie_OK %>%dplyr::rename(city=rn)
Superficie_OK=Superficie_OK[-1,-2]
superficie <- merge(Superficie_OK, cities_coordinates)
superficie = as.data.frame(superficie)
superficie$lng= as.character(superficie$lng)
superficie$lng= as.numeric(superficie$lng)
superficie$lat= as.character(superficie$lat)
superficie$lat= as.numeric(superficie$lat)

#INVESTMENT SPENDING / HAB. DATA MODELLING
setDT(ratioDI, keep.rownames = TRUE)[]
ratioDI=ratioDI %>%dplyr::rename(city=rn)
ratioDI=ratioDI[-1,-2]
ratioDI=ratioDI %>%dplyr::select(city,`2017`)
ratioDI=ratioDI %>% dplyr::rename(DI=`2017`)
di <- merge(ratioDI, cities_coordinates)
di = as.data.frame(di)







### LEAFLET INFRACTIONS ###

cities_bound <- geojsonio::geojson_read("geneva_municipalities_boundaries.geojson", what="sp")

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = infractions$data)
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
  label = paste(infractions$city, ":", infractions$data),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))




###  LEAFLET MEDECINS  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = medecins$nb_medecins, n=2)
m %>% addPolygons(
  fillColor = ~pal(medecins$nb_medecins), 
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
  label = paste(medecins$city, ":", medecins$nb_medecins),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))



###  LEAFLET ECOLES  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorNumeric("YlOrRd", domain = ecoles$nb_ecole)
m %>% addPolygons(
  fillColor = ~pal(ecoles$nb_ecole), 
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
  label = paste(ecoles$city, ":", ecoles$nb_ecole),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))



###  LEAFLET HABITANTS  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = hab$nb_hab)
m %>% addPolygons(
  fillColor = ~pal(hab$nb_hab), 
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
  label = paste(hab$city, ":", hab$nb_hab),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))



###  LEAFLET SUPERMARKETS / KM^2  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorNumeric("YlOrRd", domain = supermarkets$nb_supermarkets)
m %>% addPolygons(
  fillColor = ~pal(supermarkets$nb_supermarkets), 
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
  label = paste(supermarkets$city, ":", supermarkets$nb_supermarkets, "supermarkets /Km^2"),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))



###  LEAFLET SUPERFICIE  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorNumeric("YlOrRd", domain = superficie$km2)
m %>% addPolygons(
  fillColor = ~pal(superficie$km2), 
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
  label = paste(superficie$city, ":", superficie$km2, "Km^2"),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))



###  LEAFLET INVESTMENT SPENDING / HAB.  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = di$DI)
m %>% addPolygons(
  fillColor = ~pal(di$DI), 
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
  label = paste(di$city, ":", di$DI, "CHF spent by the municipality / hab."),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))















#### NOTES ####



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


#LEAFLET ECOLES 
m <- leaflet() %>% addTiles()
m <- leaflet(ecoles) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
colors_ecoles <- colorNumeric("YlOrRd", ecoles$nb_ecole, n=2)
m %>% addCircleMarkers(lng = ~lng, lat = ~lat, color = ~colors_ecoles(nb_ecole) ,radius = ~nb_ecole, label = ~paste(city, ":", nb_ecole), fillOpacity = 0.8)


#LEAFLET HABITANTS 
m <- leaflet() %>% addTiles()
m <- leaflet(hab) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
colors_hab <- colorQuantile("YlOrRd", hab$nb_hab)
m %>% addCircleMarkers(lng = ~lng, lat = ~lat, color = ~colors_hab(nb_hab) ,radius = ~sqrt(nb_hab)/10, label = ~paste(city, ":", nb_hab), fillOpacity = 0.8)


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







#infractions <- geo_join(cities_bound@data, NInfractions_19, "name", "NInfraction_19$city")

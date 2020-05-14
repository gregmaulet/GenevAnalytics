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
cities_bound <- geojsonio::geojson_read("geneva_municipalities_boundaries.geojson", what="sp")


#INFRACTIONS DATA MODELLING 
NInfractions_08_19_2=NInfractions_08_19
NInfractions_08_19_2=NInfractions_08_19_2 %>%dplyr::rename(city=`...1`)
NInfractions_08_19_2=NInfractions_08_19_2[-1,-2]
NInfractions_19_2=NInfractions_08_19_2 %>%dplyr::select(city,`2019`)
infractions <- merge(NInfractions_19_2, cities_coordinates)
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

#INFRACTIONS / 1000 INHAB. DATA MODELLING 
ratioInfraction2=ratioInfraction
setDT(ratioInfraction2, keep.rownames = TRUE)[]
ratioInfraction2=ratioInfraction2 %>%dplyr::rename(city=rn)
ratioInfraction2=ratioInfraction2[-1,-2]
ratioInfraction2=ratioInfraction2 %>%dplyr::select(city,`2019`)
infractions_for_1000_inhab <- merge(ratioInfraction2, cities_coordinates)
infractions_for_1000_inhab = as.data.frame(infractions_for_1000_inhab)
infractions_for_1000_inhab=infractions_for_1000_inhab %>% dplyr::rename(inf=`2019`)
class(infractions_for_1000_inhab$lat)
class(infractions_for_1000_inhab$lng)

#MEDECINS DATA MODELLING 
NMedecins2=NMedecins
NMedecins2=NMedecins2 %>% dplyr::rename(city=`...1`)
NMedecins2=NMedecins2[-1,-2]
medecins <- merge(NMedecins2, cities_coordinates)
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

#MEDECINS / 1000 INHAB. DATA MODELLING 
ratioMedecins2=ratioMedecins
setDT(ratioMedecins2, keep.rownames = TRUE)[]
ratioMedecins2=ratioMedecins2 %>% dplyr::rename(city=rn)
ratioMedecins2=ratioMedecins2[-1,-2]
medecins_for_1000_inhab <- merge(ratioMedecins2, cities_coordinates)
medecins_for_1000_inhab = as.data.frame(medecins_for_1000_inhab)
medecins_for_1000_inhab=medecins_for_1000_inhab %>% dplyr::rename(nb_medecins_for_1000_inhab=NMedecins)
class(medecins_for_1000_inhab$lat)
class(medecins_for_1000_inhab$lng)

#ECOLES PRIMAIRES DATA MODELLING 
NEcolePrimaire2=NEcolePrimaire
NEcolePrimaire2=NEcolePrimaire2 %>% dplyr::rename(city=`...1`)
NEcolePrimaire2=NEcolePrimaire2[-1,-2]
ecoles <- merge(NEcolePrimaire2, cities_coordinates)
ecoles = as.data.frame(ecoles)
ecoles=ecoles %>% dplyr::rename(nb_ecole=Necole)
class(ecoles$lat)
class(ecoles$lng)


#INHABITANTS DATA MODELLING 
NHabitants_00_192=NHabitants_00_19
NHabitants_00_192=NHabitants_00_192 %>% dplyr::rename(city=`...1`)
NHabitants_00_192=NHabitants_00_192[-1,-2]
NHabitants_00_192=NHabitants_00_192 %>%dplyr::select(city,`2019`)
hab <- merge(NHabitants_00_192, cities_coordinates)
hab = as.data.frame(hab)
hab=hab %>% dplyr::rename(nb_hab=`2019`)
class(hab$lng)
class(hab$lat)


#SUPERMARKETS / KM^2 DATA MODELLING 
ratio_Supermarches2=ratio_Supermarches
setDT(ratio_Supermarches2, keep.rownames = TRUE)[]
ratio_Supermarches2=ratio_Supermarches2 %>%dplyr::rename(city=rn)
ratio_Supermarches2=ratio_Supermarches2[-1,-2]
ratio_Supermarches2=ratio_Supermarches2 %>%dplyr::select(city,"Total Super")
supermarkets <- merge(ratio_Supermarches2, cities_coordinates)
supermarkets = as.data.frame(supermarkets)
supermarkets=supermarkets %>% dplyr::rename(nb_supermarkets="Total Super")
class(supermarkets$lat)
class(supermarkets$lng)


#SUPERFICIE DATA MODELLING
Superficie_OK2=Superficie_OK
setDT(Superficie_OK2, keep.rownames = TRUE)[]
Superficie_OK2=Superficie_OK2 %>%dplyr::rename(city=rn)
Superficie_OK2=Superficie_OK2[-1,-2]
superficie <- merge(Superficie_OK2, cities_coordinates)
superficie = as.data.frame(superficie)
class(superficie$lat)
class(superficie$lng)


#INVESTMENT SPENDING / INHAB. DATA MODELLING
ratioDI2=ratioDI
setDT(ratioDI2, keep.rownames = TRUE)[]
ratioDI2=ratioDI2 %>%dplyr::rename(city=rn)
ratioDI2=ratioDI2[-1,-2]
ratioDI2=ratioDI2 %>%dplyr::select(city,`2017`)
ratioDI2=ratioDI2 %>% dplyr::rename(DI=`2017`)
di <- merge(ratioDI2, cities_coordinates)
di = as.data.frame(di)
class(di$lat)
class(di$lng)





### LEAFLET INFRACTIONS ###

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
  label = paste(infractions$city, ":", infractions$data, "violations"),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))


###  LEAFLET INFRACTIONS / 1000 INHAB. ###

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = infractions_for_1000_inhab$inf)
m %>% addPolygons(
  fillColor = ~pal(infractions_for_1000_inhab$inf), 
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
  label = paste(infractions_for_1000_inhab$city, ":", infractions_for_1000_inhab$inf, "violations / 1000 inhab."),
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



###  LEAFLET MEDECINS / 1000 INHAB.  ####

m <- leaflet()
m <- leaflet(cities_bound) %>% 
  setView(lng = 6.1667, lat=46.2, zoom = 1) %>%
  fitBounds(m, lng1=5.932896, lat1=46.311005, lng2=6.319477, lat2=46.128334) %>%
  addTiles() %>%
  addMeasure() 
m %>% addPolygons()
pal <- colorQuantile("YlOrRd", domain = medecins_for_1000_inhab$nb_medecins_for_1000_inhab, n=2)
m %>% addPolygons(
  fillColor = ~pal(medecins_for_1000_inhab$nb_medecins_for_1000_inhab), 
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
  label = paste(medecins_for_1000_inhab$city, ":", medecins_for_1000_inhab$nb_medecins_for_1000_inhab, "doctors / 1000 inhab."),
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



###  LEAFLET INHABITANTS  ####

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
  label = paste(di$city, ":", di$DI, "CHF spent by the municipality / inhab."),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))





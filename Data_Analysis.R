
options(scipen=999)

library(dplyr)

data("Latitude_Longitude")
ls()
Latitude_Longitude %>% head()

data("DepensesInvestiss_00_17")
ls()
DepensesInvestiss_00_17 %>% head()

data("Loyermoyen100m2_06_19")
ls()
Loyermoyen100m2_06_19 %>% head()

data("NEcolePrimaire")
ls()
NEcolePrimaire %>% head()

data("NHabitants_00_19")
ls()
NHabitants_00_19 %>% head()

data("NInfractions_08_19")
ls()
NInfractions_08_19 %>% head()

data("NMedecins")
ls()
NMedecins %>% head()

data("NParcs")
ls()
NParcs %>% head()

data("NSupermarches")
ls()
NSupermarches %>% head()

data("PMedianeAppart100m2_00_17")
ls()
PMedianeAppart100m2_00_17 %>% head()

data("PMedianeVilla_00_17")
ls()
PMedianeVilla_00_17 %>% head()

data("Superficie")
ls()
Superficie %>% head()

###2.0)DIVERS---------------------------------------
#Vector of Commune names
x <- c("NA","Aire-la-Ville","Anieres", "Avully", "Avusy",
       "Bardonnex","Bellevue","Bernex","Carouge", "Cartigny",
       "Celigny", "Chancy",  "Chene-Bougeries", "Chene-Bourg",
       "Choulex","Collex-Bossy","Collonge-Bellerive","Cologny",
       "Confignon","Corsier","Dardagny","Geneve","Genthod",
       "Grand-Saconnex","Gy","Hermance","Jussy","Laconnex",
       "Lancy","Meinier", "Meyrin", "Onex","Perly-Certoux",
       "Plan-les-Ouates", "Pregny-Chambesy", "Presinge", "Puplinge",
       "Russin","Satigny","Soral","Thonex","Troinex","Vandoeuvres",
       "Vernier","Versoix","Veyrier")
Commune <- matrix(x)
rm(x)

###3.0)CLEANDATA&RATIOS---------------------------------------

#3.1)Ratio Depenses d'Investissement de la Commune par habitant
matrixDepensesInvestiss_00_17 <- data.matrix(DepensesInvestiss_00_17)
matrixNHabitants_00_19 <- data.matrix(NHabitants_00_19)
matrixNHabitants_00_19prov <- matrixNHabitants_00_19[,-(21:22)]
matrixratioDIprov <- sweep(matrixDepensesInvestiss_00_17, 1, matrixNHabitants_00_19prov, "/")
matrixratioDI <- matrixratioDIprov * 1000
ratioDIprov <- as.data.frame(matrixratioDI)
ratioDIprov[1] <- NULL
ratioDIprov2 <- head(cbind(Commune, ratioDIprov), 46)
ratioDI <- ratioDIprov2[,-1]
rownames(ratioDI) <- ratioDIprov2[,1]
rm(matrixNHabitants_00_19prov,
   matrixDepensesInvestiss_00_17, matrixNHabitants_00_19,
   matrixratioDIprov, matrixratioDI, ratioDIprov, ratioDIprov2)
#3.2) Loyermoyen100m2 - Pas de ratio, seulement clean
Loyermoyen100m2_06_19[1] <- NULL
Loyermoyen100m2_06_19prov <- head(cbind(Commune, Loyermoyen100m2_06_19), 46)
Loyermoyen100m2_06_19_OK <- Loyermoyen100m2_06_19prov[,-1]
rownames(Loyermoyen100m2_06_19_OK) <- Loyermoyen100m2_06_19prov[,1]
rm(Loyermoyen100m2_06_19, Loyermoyen100m2_06_19prov)
#3.3) Ratio Ecole primaire (nombre d'ecoles primaires moyen par km2)
matrixNEcolePrimaire <- data.matrix(NEcolePrimaire)
matrixSuperficie <- data.matrix(Superficie)
matrixratio_ecoleprov <- sweep(matrixNEcolePrimaire, 1, matrixSuperficie, "/")
ratio_ecoleprov <- as.data.frame(matrixratio_ecoleprov)
ratio_ecoleprov[1] <- NULL
ratio_ecoleprov2 <- head(cbind(Commune, ratio_ecoleprov), 46)
ratio_ecole <- ratio_ecoleprov2[,-1]
rownames(ratio_ecole) <- ratio_ecoleprov2[,1]
rm(matrixNEcolePrimaire, matrixSuperficie, matrixratio_ecoleprov, ratio_ecoleprov,ratio_ecoleprov2)
#3.4) NHabitants - Pas de ratio seulement clean
NHabitants_00_19[1] <- NULL
NHabitantsprov <- head(cbind(Commune, NHabitants_00_19), 46)
NHabitants_OK <- NHabitantsprov[,-1]
rownames(NHabitants_OK) <- NHabitantsprov[,1]
rm(NHabitants_00_19, NHabitantsprov)
#3.5) Ratio Infraction pour 1000 habitants
data("NHabitants_00_19")
ls()
NHabitants_00_19 %>% head()

matrixNInfractions_08_19 <- data.matrix(NInfractions_08_19)
matrixNHabitants_00_19 <- data.matrix(NHabitants_00_19)
matrixNHabitants_00_19prov <- matrixNHabitants_00_19[,-(3:10)]
matrixratioInfractionprov <- sweep(matrixNInfractions_08_19, 1, matrixNHabitants_00_19prov, "/")
matrixratioInfraction <- matrixratioInfractionprov * 1000
ratioInfractionprov <- as.data.frame(matrixratioInfraction)
ratioInfractionprov[1] <- NULL
ratioInfractionprov2 <- head(cbind(Commune, ratioInfractionprov), 46)
ratioInfraction <- ratioInfractionprov2[,-1]
rownames(ratioInfraction) <- ratioInfractionprov2[,1]
rm(matrixNInfractions_08_19, matrixNHabitants_00_19, matrixNHabitants_00_19prov,
   matrixratioInfractionprov,matrixratioInfraction,ratioInfractionprov,ratioInfractionprov2)
#3.6) Ratio Medecin pour 1000 habitants
matrixNMedecins <- data.matrix(NMedecins)
matrixNHabitants_00_19 <- data.matrix(NHabitants_00_19)
matrixNHabitants_00_19prov <- matrixNHabitants_00_19[,-(21:22)]
matrixNMedecinsprov <- sweep(matrixNMedecins, 1, matrixNHabitants_00_19prov, "/")
matrixratioMedecins <- matrixNMedecinsprov * 1000
ratioMedecinsprov <- as.data.frame(matrixratioMedecins)
ratioMedecinsprov[1] <- NULL
ratioMedecinsprov2 <- head(cbind(Commune, ratioMedecinsprov), 46)
ratioMedecins <- ratioMedecinsprov2[,-1]
rownames(ratioMedecins) <- ratioMedecinsprov2[,1]
rm(  matrixNMedecins, matrixNHabitants_00_19 ,matrixNHabitants_00_19prov,matrixNMedecinsprov,matrixratioMedecins,ratioMedecinsprov ,ratioMedecinsprov2 )

#3.7) Ratio Parcs par km2
matrixNParcs <- data.matrix(NParcs)
matrixSuperficie <- data.matrix(Superficie)
matrixratio_NParcsprov <- sweep(matrixNParcs, 1, matrixSuperficie, "/")
ratio_NParcsprov <- as.data.frame(matrixratio_NParcsprov)
ratio_NParcsprov[1] <- NULL
ratio_NParcsprov2 <- head(cbind(Commune, ratio_NParcsprov), 46)
ratio_NParcs <- ratio_NParcsprov2[,-1]
rownames(ratio_NParcs) <- ratio_NParcsprov2[,1]
rm(matrixNParcs, matrixSuperficie, matrixratio_NParcsprov, ratio_NParcsprov,ratio_NParcsprov2)

#3.8) Ratio Supermarches par km2
matrixNSupermarches <- data.matrix(NSupermarches)
matrixNSupermarchesprov <- matrixNSupermarches[,-(4:9)]
matrixSuperficie <- data.matrix(Superficie)
matrixratio_NSupermarchesprov <- sweep(matrixNSupermarchesprov, 1, matrixSuperficie, "/")
ratio_NSupermarchesprov <- as.data.frame(matrixratio_NSupermarchesprov)
ratio_NSupermarchesprov[1] <- NULL
ratio_NSupermarchesprov2 <- head(cbind(Commune, ratio_NSupermarchesprov), 46)
ratio_Supermarches <- ratio_NSupermarchesprov2[,-1]
rownames(ratio_Supermarches) <- ratio_NSupermarchesprov2[,1]
rm(matrixNSupermarches, matrixNSupermarchesprov,matrixSuperficie, matrixratio_NSupermarchesprov, ratio_NSupermarchesprov,ratio_NSupermarchesprov2)

#3.9) Prix mediane appartement 100m2 - Pas de ratio, seulement clean
PMedianeAppart100m2_00_17[1] <- NULL
PMedianeAppart100m2_00_17prov <- head(cbind(Commune, PMedianeAppart100m2_00_17), 46)
PMedianeAppart100m2_00_17_OK <- PMedianeAppart100m2_00_17prov[,-1]
rownames(PMedianeAppart100m2_00_17_OK) <- PMedianeAppart100m2_00_17prov[,1]
rm(PMedianeAppart100m2_00_17, PMedianeAppart100m2_00_17prov)

#3.10) Prix mediane Villa - Pas de ratio, seulement clean - Aucun detail sur dimensions du bien
PMedianeVilla_00_17[1] <- NULL
PMedianeVilla_00_17prov <- head(cbind(Commune, PMedianeVilla_00_17), 46)
PMedianeVilla_00_17_OK <- PMedianeVilla_00_17prov[,-1]
rownames(PMedianeVilla_00_17_OK) <- PMedianeVilla_00_17prov[,1]
rm(PMedianeVilla_00_17, PMedianeVilla_00_17prov)

#3.11) Densite de population
matrixNHabitants_00_19 <- data.matrix(NHabitants_00_19)
matrixSuperficie <- data.matrix(Superficie)
matrixSuperficieprov <- matrixSuperficie[,-(1:2)]
matrixDensite_population <- sweep(matrixNHabitants_00_19, 1, matrixSuperficieprov, "/")
Densite_populationprov <- as.data.frame(matrixDensite_population)
Densite_populationprov[1] <- NULL
Densite_populationprov2 <- head(cbind(Commune, Densite_populationprov), 46)
Densite_population <- Densite_populationprov2[,-1]
rownames(Densite_population) <- Densite_populationprov2[,1]
rm(matrixSuperficieprov,
   matrixSuperficie, matrixNHabitants_00_19,
   matrixDensite_population, Densite_populationprov, Densite_populationprov2)


#3.12)Superficie a clean
Superficie[1] <- NULL
Superficieprov <- head(cbind(Commune, Superficie), 46)
Superficie_OK <- Superficieprov[,-1]
rownames(Superficie_OK) <- Superficieprov[,1]
rm(Superficie, Superficieprov)

###4.0) FONCTIONS PLOT------------------------------
#4.1) DI (funratioDIplot("nom de la commune")) & examples
fplotratioDI <- function(a){x <- ratioDI[c(a),c(2:19)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="CHF",main="Depense moy. d'Investissement de commune par habitant")
axis(1, at=1:18, labels=2000:2017)}

#4.2) Loyermoyen100m2 (funloyermoyen100m2plot("nom de la commune"))
fplotloyer <- function(a){x <- Loyermoyen100m2_06_19_OK[c(a),c(2:15)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="CHF", ylim = c(1000,2500), main="Loyer moyen appartement 100m2")
axis(1, at=1:14, labels=2006:2019)}

#4.3) Pas besoin pour ecole car ni la superficie ni le nombre d'ecole varie (malheureusement, pour cette derniere variable, j'ai pas les dates d'entrees)
#4.4) Population
fplotpopulation <- function(a){x <- NHabitants_OK[c(a),c(2:21)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="Nombre d'habitants", main="Population")
axis(1, at=1:20, labels=2000:2019)}
#4.5) Ratio Infraction pour 1000 habitants

fplotinfraction <- function(a){x <- ratioInfraction[c(a),c(2:13)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="Nombre d'infractions",main="Nombre d'infractions du Code Penal par 1000 habitants")
axis(1, at=1:12, labels=2008:2019)}


#4.9) Prix mediane appartement 100m2 
fplotprixappart <- function(a){x <- PMedianeAppart100m2_00_17_OK[c(a),c(2:19)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="CHF", main="Prix mediane d'un appartement 100m2")
axis(1, at=1:18, labels=2000:2017)}

#4.10) Prix mediane Villa
fplotprixvilla <- function(a){x <- PMedianeVilla_00_17_OK[c(a),c(2:19)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="CHF", main="Prix mediane d'une villa (taille inconnue)")
axis(1, at=1:18, labels=2000:2017)}

#4.11) Densite population (plot discutable vu que c'est la meme courbe que celle de la population)
fplotdensitepopulation <- function(a){x <- Densite_population[c(a),c(2:21)]
tx <- t(x)
plot( tx,type="l", col="blue", lwd=2, xlab="Year", xaxt = "n", ylab="Nombre de personnes/km2",main="Densite de la population")
axis(1, at=1:20, labels=2000:2019)}


##5) FONCTIONS POUR OBTENIR DONNEES VOULUES D'UNE COMMUNE EN DERNIERE ANNEE DISPONIBLE------------------------------------------------------
#5.1) DI : Depenses d'investissement de la commmune par habitant (2017)
freturnDI <- function(a){x <- ratioDI[c(a),19]
return(round(x, digits = 2))
}
#5.2) Loyermoyen100m2 : Loyer moyen d'un appartement de 100m2 (2019)
freturnloyer <- function(a){x <- Loyermoyen100m2_06_19_OK[c(a),15]
return(round(x, digits = 2))
}

#5.3) Ratio Ecole : Nombre d'ecoles par km2 : 
freturnecole <- function(a){x <- ratio_ecole[c(a), c(2)]
return(round(x, digits = 2))
}

#5.4) Population : Nombre d'habitants (2019) 
freturnpopulation <- function(a){x <- NHabitants_OK[c(a),21]
return(round(x, digits = 2))
}

#5.5) Ratio Infraction pour 1000 habitants
# Nombre d'infractions du Code Penal pour 1000 habitants (2019)
freturninfraction <- function(a){x <- ratioInfraction[c(a),13]
return(round(x, digits = 2))
}

#5.6) Ratio Medecin (pour 1000 habitants) : Nombre de medecins pour 1000 habitants
freturnmedecin <- function(a){x <- ratioMedecins[c(a), c(2)]
return(round(x, digits = 2))
}

#5.7) Ratio Parc : Nombre de parcs par km2
freturnparc <- function(a){x <- ratio_NParcs[c(a), c(2)]
return(round(x, digits = 2))
}

#5.8) Ratio Supermarche : Nombre de supermarchés par km2
freturnsupermarche <- function(a){x <- ratio_Supermarches[c(a), c(2)]
cat("Nombre de supermarchés par km2 : ") 
return(round(x, digits = 2))
}

#5.9) Prix mediane appartement 100m2 : Prix mediane d'un appartement de 100m2 (2017)
freturnprixappart <- function(a){x <- PMedianeAppart100m2_00_17_OK[c(a),19]
return(round(x, digits = 2))
}

#5.10) Prix mediane Villa : Prix mediane d'une villa (Taille inconnue, 2017)
freturnprixvilla <- function(a){x <- PMedianeVilla_00_17_OK[c(a),19]
return(round(x, digits = 2))
}

#5.11) Densite population : Nombre d'habitants par km2 (2019) 
freturndensitepopulation <- function(a){x <- Densite_population[c(a),21]
return(round(x, digits = 2))
}

#5.12) Superficie km2 : Superficie de la commune en km2
freturnsuperficie <- function(a){x <- Superficie_OK[c(a), c(2)]
return(round(x, digits = 2))
}

##6) CLEAN USELESS DATA------------------------------------------------------
#rm(Commune, DepensesInvestiss_00_17,NEcolePrimaire, NInfractions_08_19, NMedecins, NParcs, NSupermarches, NHabitants_00_19)


##7) LISTE FONCTIONS FINALES-------------------------------------------
#fpopulation <- function(a){
#  cat(freturnpopulation(a))
#  fplotpopulation(a)
#  cat(freturndensitepopulation(a))
#  fplotdensitepopulation(a)
#  cat(freturnsuperficie(a))
#}

fpopulation <- function(a){
  freturnpopulation(a)
  fplotpopulation(a)
  freturndensitepopulation(a)
  fplotdensitepopulation(a)
  freturnsuperficie(a)
}

fimmobilier <- function(a){
  cat(freturnloyer(a))
  fplotloyer(a)
  cat(freturnprixappart(a))
  fplotprixappart(a)
  cat(freturnprixvilla(a))
  fplotprixvilla(a)
}


fcommodite <- function(a){
  print(freturnsupermarche(a))
  
  print(freturnecole(a))
  
  cat(freturnparc(a))
}

fservice <- function(a){
  cat(freturninfraction(a))
  fplotinfraction(a)
  cat(freturnDI(a))
  fplotratioDI(a)
  cat(freturnmedecin(a))
}
##7.1) Examples
#fpopulation("Geneve")
#fimmobilier("Geneve")
#fcommodite("Geneve")
#fservice("Geneve")


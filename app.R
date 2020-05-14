#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(geojsonio)
library(leaflet)
library(sp)
library(htmltools)
library(htmlwidgets)
library(rgdal)
library(jsonlite)
library(plyr)
library(dplyr)
library(data.table)
library(shiny)
source("Data_Analysis.R")


### ABSTRACTS #######################################################################
abstractAirelaVille = "La commune genevoise d’Aire-la-Ville est située sur la rive gauche du Rhône, à la hauteur du barrage de Verbois. Proche des grands axes de communication, comme l’aéroport et le centre de Genève, elle offre à ses habitants un cadre naturel magnifique, entre fleuve, forêts et champs. La faune y est riche grâce à la réserve naturelle du Moulin-de-Vert, et les promeneurs y croisent fréquemment biches, renards ou sangliers."
abstractAnieres = "Bordée par le lac, Anières fait frontière commune avec Hermance, Corsier et la France.  Les constructions occupent principalement la rive et les pentes exposées à l’ouest le long du lac, où elles côtoient le vignoble. Les conditions y sont variées et malgré l’intensification agricole, il subsiste quelques lambeaux de milieux naturels intéressants, comme des prairies. "
abstractAvully = "Avully est située dans la campagne genevoise, sur la rive gauche du Rhône, qui borde la commune au nord et à l'ouest. Henri Dunant venait régulièrement à Avully pour rendre visite à son grand-père maternel Henri Colladon, maire de la commune d'Avully et directeur de l’hôpital. Aujourd'hui encore une plaque commémorative est affichée sur la Résidence de Henri Colladon dans la commune."
abstractAvusy = "Située près de la pointe ouest de la Suisse, Avusy est entourée de Chancy, Avully, Cartigny, Laconnex et Soral. Au sud, elle fait frontière avec le département français de la Haute-Savoie sur plusieurs kilomètres. Historiquement, la commune d’Avusy est vouée à l’agriculture. Aujourd’hui encore elle reste attachée à cette vocation."
abstractBardonnex = "Bardonnex est une commune rurale située au sud du canton de Genève, le long de la frontière entre la France et la Suisse.  Les grandes cultures sur le plateau laissent la place à la viticulture sur le coteau sud. La douane de Bardonnex est un important passage frontalier par l'autoroute A1 et l'autoroute française A41."
abstractBellevue = "Située entre le centre-ville, le lac et la frontière avec la France, Bellevue est traversée par deux axes routiers importants : la route de Lausanne et l’autoroute A1. Deux points clés distinguent la vie à Bellevue, à savoir son esprit villageois, ainsi que ses trois accès privilégiés au lac : Port Saladin, l’esplanade Gitana et la plage du Vengeron, partagée avec la commune de Pregny-Chambésy."
abstractBernex = "Le territoire de Bernex est entouré au sud-est de la commune de Perly-Certoux, à l'est de celle de Confignon, au nord-est de Vernier, au nord de Satigny, au nord-ouest d'Aire-la-Ville, à l'ouest de Cartigny, au sud-ouest de Laconnex, et au sud de Soral. Ses deux principaux cours d'eau sont le Rhône qui fait la frontière avec Vernier et Satigny, et l'Aire qui fait la frontière avec Perly-Certoux."
abstractCarouge = "Carouge jouxte la ville de Genève, dont elle est séparée par la rivière Arve, et fait partie de la République et Canton de Genève depuis 1816. Elle est réputée pour le quartier du « vieux Carouge », qui garde un certain charme et où les terrasses des bistros sont courues lorsque les beaux jours reviennent."
abstractCartigny = "Cartigny est situé dans la campagne genevoise, sur la rive gauche du Rhône. Un ancien méandre de celui-ci est devenu en 1940 un étang dans la Réserve Naturelle du Moulin-de-Vert. En 1968, sa mise en réserve cynégétique a été une première étape dans l'interdiction de la chasse dans le canton de Genève."
abstractCeligny = "La commune de Céligny est une partie exclavée du canton de Genève, se situant au nord de celui-ci, au bord du Léman, à l'intérieur du canton de Vaud. À un peu plus de dix-huit kilomètres de Genève, sur la rive droite du lac, la commune de Céligny est formée de deux parties exclavées."
abstractChancy = "Chancy est la commune la plus occidentale de Suisse. Elle se situe à l'endroit où le Rhône quitte le territoire helvétique et correspond également au point le plus bas en altitude de la Suisse romande."
abstractCheneBougeries = "La commune de Chêne-Bougeries est située à l'est de la ville de Genève, qu'elle jouxte. La majeure partie de son territoire est classée en zone villa avec par exemple le quartier de Conches, l'autre partie est classée zone immeuble avec par exemple le quartier de la Gradelle."
abstractCheneBourg = "Chêne-Bourg est la plus jeune et la plus petite commune genevoise. Située au cœur des Trois-Chêne, adossée au cours d’eau de la Seymaz, elle est traversée par l’important axe routier de la rue de Genève qui relie l’agglomération annemassienne au centre-ville."
abstractChoulex = "La commune de Choulex se situe dans la région du canton de Genève, entre l’Arve et et le lac. Choulex est longé du nord-est au sud par la Seymaz, petite rivière dont la source se situe entre le Carre d’Amont et Meinier, près de Rouelbeau. "
abstractCollexBossy = "Proche de l'aéroport de Genève-Cointrin, mais située hors de ses zones de nuisance, la commune de Collex-Bossy constitue, sur la rive droite du lac, un 'poumon de verdure' pour l'agglomération urbaine de Genève. L'agriculture, la viticulture et l’artisanat, pour l'essentiel, constituent le tissu économique de Collex-Bossy."
abstractCollongeBellerive = "La commune se trouve sur la rive gauche du Léman. Après un passé voué à l’agriculture, sa vocation est aujourd’hui essentiellement résidentielle. On y compte toutefois de nombreuses entreprises artisanales, des commerces et des professions libérales."
abstractCologny = "Cologny est une commune essentiellement résidentielle, située sur un coteau dominant le lac Léman. C'est une des communes les plus riches du canton de Genève. Le World Economic Forum (Forum économique mondial) ainsi que la Fondation Martin Bodmer y ont leur siège."
abstractConfignon = "Entre ses coteaux ensoleillés voués à la vigne, culminant à 435 mètres d'altitude, et le cours d'eau de l'Aire, dont les abords ont récemment fait l'objet d'une opération de renaturation, Confignon est une commune qui a su conserver son caractère villageois. Un caractère qu'elle fait voeu de protéger."
abstractCorsier = "Corsier se situe au bord du Léman. La Commune est traversée par le Nant d'Aisy qui prend sa source à la frontière franco-suisse. Jouissant d’une situation exceptionnelle, avec vue sur lac, Jura, Voirons et Alpes, Corsier possède des atouts majeurs qui font qu’il est agréable d’y vivre."
abstractDardagny = "Située presque à l'extrémité occidentale du pays, Dardagny est délimitée par la frontière avec la France à l'ouest et au nord, par le Rhône au sud et les communes de Russin et Satigny à l'est. Le ruisseau des Charmilles se jette pour sa part directement dans le Rhône en passant par le territoire français."
abstractGeneve  = "Genève s'étend à l'extrémité sud-ouest du Léman, sur les deux rives du Rhône. Après la Seconde Guerre mondiale, le siège européen de l'Organisation des Nations unies (ONU) et des dizaines d'organisations internationales s'installent à Genève, ce qui sera profitable au développement du tourisme de loisirs et d'affaires."
abstractGenthod = "Située au bord du lac, la commune de Genthod est bordée au nord par la commune de Versoix, à l'ouest par celle de Collex-Bossy et au sud par Bellevue. Aujourd'hui, elle possède encore trois exploitations agricoles en plus de ses commerces et restaurants, de ses quelques entreprises artisanales et de la prestigieuse manufacture horlogère de Franck Muller."
abstractGrandSaconnex = "La commune est située sur la rive droite du canton de Genève et au nord de celui-ci. Comprenant l’aéroport et Palexpo, elle est limitrophe de la commune de Ferney-Voltaire en France. Rurale vers 1900, elle a pris un caractère très résidentiel grâce à la présence de nombreuses et importantes organisations internationales. "
abstractGy = "Situé sur un plateau entre les Voirons et le lac, Gy dispose d’une vue exceptionnelle sur tous les monts et sommets qui bordent le canton. Une nature préservée faite de grands espaces avec une agriculture omniprésente qui modèle des paysages variés est la description de cette commune."
abstractHermance = "Hermance se situe sur la rive sud du Léman, à l'extrémité septentrionale de Genève. Son village est sans nul doute l'un des plus pittoresques du canton. La commune est limitrophe d'Anières et de la France, rappelant qu’elle a été longtemps savoyarde et ce jusqu’au Traité de Turin. "
abstractJussy = "Limitrophe de Gy, Presinge et Meinier, ainsi que de la France (Saint-Cergues, Juvigny),  le village a gardé un caractère agricole et viticole grâce aux 20 exploitations encore existantes."
abstractLaconnex = "Laconnex fait partie de cette région du canton de Genève appelée “Champagne genevoise”. La Champagne genevoise comprend les sept communes d’Aire-la-Ville, Avully, Avusy, Cartigny, Chancy, Laconnex et Soral."
abstractLancy = "La commune comprend les localités du Petit-Lancy, du Grand-Lancy et de La Praille. Dans ces deux dernières se trouvent respectivement, entre autre, le centre administratif/technique des transports genevois et le Stade de Genève."
abstractMeinier = "La commune de Meinier est composée de plusieurs villages ou hameaux. La zone agricole y domine, mais il y a aussi la zone industrielle et artisanale de la Pallanterie, qui a été réalisée en collaboration avec la commune de Collonge-Bellerive."
abstractMeyrin = "En 1922, Meyrin se dinstingue par la construction de la première piste d'aviation de Cointrin. En 1954, le Centre européen de recherche nucléaire (CERN) s'installe sur le territoire de la commune et s'étend plus tard à cheval sur la frontière franco-suisse. La présence de l'aéroport international, désormais connecté à l'autoroute A1, est ainsi un atout pour favoriser l'accueil des organisations internationales."
abstractOnex = "Onex s'étend entre le Rhône et l'Aire. Cette commune peut être vue en deux parties ; le village, appelé plus communément le « Vieil-Onex » et le quartier plus urbain « Cité-Nouvelle » ou « Onex-Cité », qui s'est construit entre le Rhône et la route de Chancy."
abstractPerlyCertoux = "La commune se trouve à la frontière avec la France. Son principal cours d'eau est la rivière de l'Aire. Située sur l'axe Genève-Saint-Julien-en-Genevois, en frontière du territoire français, à proximité de l'autoroute de contournement de Genève, une zone de commerce et d'artisanat s'est développée sur cet axe urbanisé, parallèlement à la zone d'habitation."
abstractPlanlesOuates = "D’origine agricole, la commune a vu de nombreuses industries s’implanter sur la partie maraîchère de son territoire pour donner naissance à une zone industrielle (ZIPLO). À la suite de l'arrivée importante de l'industrie horlogère ces dernières années, le nom a été détourné de façon humoristique en « Plan-les-Watch »."
abstractPregnyChambesy = "La commune de Pregny-Chambésy est située sur la rive droite du lac Léman, aux portes de la campagne genevoise, non loin de l'aéroport international de Genève-Cointrin et à proximité du quartier des Nations. Elle a conservé, depuis de nombreuses années, un aspect de ruralité, tout en étant résidentielle."
abstractPresinge = "Aujourd’hui encore, la commune est vouée à l’agriculture et à la viticulture. Toutefois, avec le développement des moyens de communication et l’envie toujours plus grande des citadins d’habiter la campagne, Presinge, petit à petit, s’est également découvert une vocation résidentielle. "
abstractPuplinge = "Situé sur la rive gauche dans la région Arve-Lac, Puplinge s'étend entre les rivières de la Seymaz et du Foron. Son territoire est principalement constitué de terrains agricoles.  Elle est limitrophe de Choulex, Presinge et Thônex, ainsi que de la France (Ville-la-Grand et Annemasse)."
abstractRussin = "Environ 97% du territoire communal est constitué de zones agricoles, de bois et de forêts. Six exploitants cultivent aujourd’hui, de la vigne, des arbres fruitiers, des grandes cultures et proposent des produits de qualité sur les marchés de la ville ou en vente directe dans les fermes. La Fête des Vendanges de Russin est la plus grande des « caves ouvertes » de Genève."
abstractSatigny = "Satigny est la plus grande commune viticole de Suisse. Il y a également trois zones industrielles représentant plus de 8000 postes de travail sur environ 725 entreprises, allant du domaine de l’automobile, à l’alimentation, en passant par les produits chimiques.  "
abstractSoral = "Soral est une commune à vocation essentiellement agricole et viticole ; 83% de la surface est consacrée à l’agriculture. Elle partage une frontière de plusieurs kilomètres avec le département français voisin de Haute-Savoie. Commune essentiellement paysanne, Soral ne cultive pas que ses terres agricoles et ses vignes. Elle privilégie aussi les artistes et les artisans d’art qui se sont établis sur son territoire."
abstractThonex = "Limitrophe avec la France, Thônex peut être divisée en 3 parties : le nord et le sud, principalement agricoles avec des villas, et le centre urbain. Avec la diversité des magasins, des lieux de détente et de loisirs font que cette commune peut être considérée comme une vraie ville où le commerce tourne. "
abstractTroinex = "Village essentiellement agricole jusqu’au siècle dernier, Troinex est devenu une commune plutôt résidentielle depuis une cinquantaine d’années. Elle possède cependant encore, dans la zone des marais située au pied du Salève, une des plus vastes zones maraîchères de Suisse, dans laquelle les techniques modernes de production sous serre et hors sol sont utilisées."
abstractVandoeuvres = "Vandœuvres est une petite commune suburbaine, de vocation résidentielle. La tradition veut qu’il y ait un chêne par habitant dans la commune. Chaque année, elle accueille une centaine de savants de divers pays du monde, qui viennent chacun pour des séjours de deux à huit semaines, y mener leurs recherches."
abstractVernier = "Vernier, grâce à sa position au croisement de plusieurs axes importants, attire un grand nombre d'activités tertiaires et secondaires. L’aéroport ne se trouve pas très loin et sur la commune se trouve le fameux centre commercial genevois Balexert, mais aussi le Bois-des-Frères, permettant de retrouver le calme de la nature."
abstractVersoix = "Limitrophe des communes vaudoises de Chavannes-des-Bois et Mies, la commune de Versoix jouit d’une importante forêt en liaison directe avec les massifs forestiers du Jura et du canton de Vaud. Le Bois du Faisan est une réserve naturelle depuis 1933, située sur la rive droite de la rivière la Versoix. "
abstractVeyrier = "Demeurée rurale jusqu'au milieu du XXe siècle, la commune de Veyrier est aujourd'hui essentiellement résidentielle. Elle préserve toutefois sa vocation agricole à raison de un tiers de sa superficie. Vernier est limitrophe des communes françaises d'Étrembières, de Collonges-sous-Salève et de Bossey en Haute-Savoie."
#####################################################################################


########### USER INTERFACE ##########################################################
# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("GenevAnalytics"),
    
    fluidRow(
        
        column(style='border-right: 3px double black',width=6,
               #titlePanel("Map de Genève avec classements"),
               
               # La map à Greg on mettra ici
               selectInput("ClasserPar", h4("Classer par"), 
                           choices = list("Population"="Population", 
                                          "Nombre d'infractions (2019)"="Infractions",
                                          "Infractions pour 1000 habitants"="Infractions1000",
                                          "Nombre de médecins"="Medecins",
                                          "Médecins pour 1000 habitant"="Medecins1000",
                                          "Ecoles"="Ecoles",
                                          "Supermarchés par km2"="SupermarchesKM2",
                                          "Superficie"="Superficie",
                                          "Dépenses investissement par habitant"="Investissement"
                                          ), 
                           selected = "Population",
                           selectize = FALSE),
               leafletOutput("mymap")
               #navbarPage(id="navMap", title="Trier par:", selected = "Population",
               #           tabPanel("Population", value = "Population", leafletOutput("mymap")),
               #           tabPanel("Infractions", value = "Infractions", leafletOutput("mymap")),
               #           tabPanel("Population1", value = "Population1", leafletOutput("mymap")),
               #           tabPanel("Population2", value = "Population2", leafletOutput("mymap"))
               #)
               
        ),
        
    
        
        column(width=6,
               navbarPage(id="navPage", title="Commune:", selected = "Aire-la-Ville",
                   #navbarMenu(title = span( "Versoix", style = "font-weight: bold" ),
                    navbarMenu( title=tags$div(textOutput("selectedCommune"),style = "font-weight: bold; display: inline-block; vertical-align: middle;"),
                        # Communes navbar ---------------
                        tabPanel("Aire-la-Ville", value = "Aire-la-Ville", htmlOutput("DescriptionAirelaVille"), img(src="AirelaVille.jpg",width = 400)),
                        tabPanel("Anieres", value = "Anieres", htmlOutput("DescriptionAnieres"), img(src="Anieres.jpg",width = 400)),
                        tabPanel("Avully", value = "Avully", htmlOutput("DescriptionAvully"), img(src="Avully.jpg",width = 400)),
                        tabPanel("Avusy", value = "Avusy", htmlOutput("DescriptionAvusy"), img(src="Avusy.jpg",width = 400)),
                        tabPanel("Bardonnex", value = "Bardonnex", htmlOutput("DescriptionBardonnex"), img(src="Bardonnex.jpg",width = 400)),
                        tabPanel("Bellevue", value = "Bellevue", htmlOutput("DescriptionBellevue"), img(src="Bellevue.jpg",width = 400)),
                        tabPanel("Bernex", value = "Bernex", htmlOutput("DescriptionBernex"), img(src="Bernex.jpg",width = 400)),
                        tabPanel("Carouge", value = "Carouge", htmlOutput("DescriptionCarouge"), img(src="Carouge.jpg",width = 400)),
                        tabPanel("Cartigny", value = "Cartigny", htmlOutput("DescriptionCartigny"), img(src="Cartigny.jpg",width = 400)),
                        tabPanel("Celigny", value = "Celigny", htmlOutput("DescriptionCeligny"), img(src="Celigny.jpg",width = 400)),
                        tabPanel("Chancy", value = "Chancy", htmlOutput("DescriptionChancy"), img(src="Chancy.jpg",width = 400)),
                        tabPanel("Chene-Bougeries", value = "Chene-Bougeries", htmlOutput("DescriptionCheneBougeries"), img(src="CheneBougeries.jpg",width = 400)),
                        tabPanel("Chene-Bourg", value = "Chene-Bourg", htmlOutput("DescriptionCheneBourg"), img(src="CheneBourg.jpg",width = 400)),
                        tabPanel("Choulex", value = "Choulex", htmlOutput("DescriptionChoulex"), img(src="Choulex.jpg",width = 400)),
                        tabPanel("Collex-Bossy", value = "Collex-Bossy", htmlOutput("DescriptionCollexBossy"), img(src="CollexBossy.jpg",width = 400)),
                        tabPanel("Collonge-Bellerive", value = "Collonge-Bellerive", htmlOutput("DescriptionCollongeBellerive"), img(src="CollongeBellerive.jpg",width = 400)),
                        tabPanel("Cologny", value = "Cologny", htmlOutput("DescriptionCologny"), img(src="Cologny.jpg",width = 400)),
                        tabPanel("Confignon", value = "Confignon", htmlOutput("DescriptionConfignon"), img(src="Confignon.jpg",width = 400)),
                        tabPanel("Corsier", value = "Corsier", htmlOutput("DescriptionCorsier"), img(src="Corsier.jpg",width = 400)),
                        tabPanel("Dardagny", value = "Dardagny", htmlOutput("DescriptionDardagny"), img(src="Dardagny.jpg",width = 400)),
                        tabPanel("Geneve", value = "Geneve", htmlOutput("DescriptionGeneve"), img(src="Geneve.jpg",width = 400)),
                        tabPanel("Genthod", value = "Genthod", htmlOutput("DescriptionGenthod"), img(src="Genthod.jpg",width = 400)),
                        tabPanel("Grand-Saconnex", value = "Grand-Saconnex", htmlOutput("DescriptionGrandSaconnex"), img(src="GrandSaconnex.jpg",width = 400)),
                        tabPanel("Gy", value = "Gy", htmlOutput("DescriptionGy"), img(src="Gy.jpg",width = 400)),
                        tabPanel("Hermance", value = "Hermance", htmlOutput("DescriptionHermance"), img(src="Hermance.jpg",width = 400)),
                        tabPanel("Jussy", value = "Jussy", htmlOutput("DescriptionJussy"), img(src="Jussy.jpg",width = 400)),
                        tabPanel("Laconnex", value = "Laconnex", htmlOutput("DescriptionLaconnex"), img(src="Laconnex.jpg",width = 400)),
                        tabPanel("Lancy", value = "Lancy", htmlOutput("DescriptionLancy"), img(src="Lancy.jpg",width = 400)),
                        tabPanel("Meinier", value = "Meinier", htmlOutput("DescriptionMeinier"), img(src="Meinier.jpg",width = 400)),
                        tabPanel("Meyrin", value = "Meyrin", htmlOutput("DescriptionMeyrin"), img(src="Meyrin.jpg",width = 400)),
                        tabPanel("Onex", value = "Onex", htmlOutput("DescriptionOnex"), img(src="Onex.jpg",width = 400)),
                        tabPanel("Perly-Certoux", value = "Perly-Certoux", htmlOutput("DescriptionPerlyCertoux"), img(src="PerlyCertoux.jpg",width = 400)),
                        tabPanel("Plan-les-Ouates", value = "Plan-les-Ouates", htmlOutput("DescriptionPlanlesOuates"), img(src="PlanlesOuates.jpg",width = 400)),
                        tabPanel("Pregny-Chambesy", value = "Pregny-Chambesy", htmlOutput("DescriptionPregnyChambesy"), img(src="PregnyChambesy.jpg",width = 400)),
                        tabPanel("Presinge", value = "Presinge", htmlOutput("DescriptionPresinge"), img(src="Presinge.jpg",width = 400)),
                        tabPanel("Puplinge", value = "Puplinge", htmlOutput("DescriptionPuplinge"), img(src="Puplinge.jpg",width = 400)),
                        tabPanel("Russin", value = "Russin", htmlOutput("DescriptionRussin"), img(src="Russin.jpg",width = 400)),
                        tabPanel("Satigny", value = "Satigny", htmlOutput("DescriptionSatigny"), img(src="Satigny.jpg",width = 400)),
                        tabPanel("Soral", value = "Soral", htmlOutput("DescriptionSoral"), img(src="Soral.jpg",width = 400)),
                        tabPanel("Thonex", value = "Thonex", htmlOutput("DescriptionThonex"), img(src="Thonex.jpg",width = 400)),
                        tabPanel("Troinex", value = "Troinex", htmlOutput("DescriptionTroinex"), img(src="Troinex.jpg",width = 400)),
                        tabPanel("Vandoeuvres", value = "Vandoeuvres", htmlOutput("DescriptionVandoeuvres"), img(src="Vandoeuvres.jpg",width = 400)),
                        tabPanel("Vernier", value = "Vernier", htmlOutput("DescriptionVernier"), img(src="Vernier.jpg",width = 400)),
                        tabPanel("Versoix", value = "Versoix", htmlOutput("DescriptionVersoix"), img(src="Versoix.jpg",width = 400)),
                        tabPanel("Veyrier", value = "Veyrier", htmlOutput("DescriptionVeyrier"), img(src="Veyrier.jpg",width = 400))
                        # _Communes navbar --------------
                              ),
                   tabPanel("Population", value = "Population",
                            htmlOutput("PopulationCommune"),
                            plotOutput("PopulationCommune_Plot1"),
                            plotOutput("PopulationCommune_Plot2")),
                   
                   tabPanel("Immobilier",
                            htmlOutput("ImmobilierCommune"),
                            plotOutput("ImmobilierCommune_Plot1"),
                            plotOutput("ImmobilierCommune_Plot2"),
                            plotOutput("ImmobilierCommune_Plot3")),
                   
                   tabPanel("Commodités", value = "Commodites",
                            htmlOutput("CommoditesCommune")),
                   
                   tabPanel("Autres", value = "Autres",
                            htmlOutput("AutresCommune"),
                            plotOutput("AutresCommune_Plot1"),
                            plotOutput("AutresCommune_Plot2"))
               )
               
               

        )
    )

    
    
)




########### SERVER ####################################################################
# Define server logic required to draw a histogram
server <- function(input, output) {

    #selectedCommune = "SERVER"
    MaCommune = "Geneve"
    
    #### MAP ####################################################
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
    
    #INFRACTIONS / 1000 INHAB. DATA MODELLING 
    setDT(ratioInfraction, keep.rownames = TRUE)[]
    ratioInfraction=ratioInfraction %>%dplyr::rename(city=rn)
    ratioInfraction=ratioInfraction[-1,-2]
    ratioInfraction=ratioInfraction %>%dplyr::select(city,`2019`)
    infractions_for_1000_inhab <- merge(ratioInfraction, cities_coordinates)
    infractions_for_1000_inhab = as.data.frame(infractions_for_1000_inhab)
    infractions_for_1000_inhab=infractions_for_1000_inhab %>% dplyr::rename(inf=`2019`)
    class(infractions_for_1000_inhab$lat)
    class(infractions_for_1000_inhab$lng)
    
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
    
    #MEDECINS / 1000 INHAB. DATA MODELLING 
    setDT(ratioMedecins, keep.rownames = TRUE)[]
    ratioMedecins=ratioMedecins %>% dplyr::rename(city=rn)
    ratioMedecins=ratioMedecins[-1,-2]
    medecins_for_1000_inhab <- merge(ratioMedecins, cities_coordinates)
    medecins_for_1000_inhab = as.data.frame(medecins_for_1000_inhab)
    medecins_for_1000_inhab=medecins_for_1000_inhab %>% dplyr::rename(nb_medecins_for_1000_inhab=NMedecins)
    class(medecins_for_1000_inhab$lat)
    class(medecins_for_1000_inhab$lng)
    
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
    
    #INHABITANTS DATA MODELLING 
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
    
    #INVESTMENT SPENDING / INHAB. DATA MODELLING
    setDT(ratioDI, keep.rownames = TRUE)[]
    ratioDI=ratioDI %>%dplyr::rename(city=rn)
    ratioDI=ratioDI[-1,-2]
    ratioDI=ratioDI %>%dplyr::select(city,`2017`)
    ratioDI=ratioDI %>% dplyr::rename(DI=`2017`)
    di <- merge(ratioDI, cities_coordinates)
    di = as.data.frame(di)

    source("Data_Analysis.R")
    
    
    cities_bound <- geojsonio::geojson_read("geneva_municipalities_boundaries.geojson", what="sp")
    
    output$mymap <- renderLeaflet({
        if(input$ClasserPar == "Infractions")
        {
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
        } else if(input$ClasserPar == "Infractions1000"){
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
            
        } else if(input$ClasserPar == "Medecins"){
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
            
        } else if(input$ClasserPar == "Medecins1000"){
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
            
        } else if(input$ClasserPar == "Ecoles"){
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
            
        } else if(input$ClasserPar == "Population"){
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
            
        } else if(input$ClasserPar == "SupermarchesKM2"){
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
            
        } else if(input$ClasserPar == "Superficie"){
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
            
        } else if(input$ClasserPar == "Investissement"){
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
        } 
        
    })
    
    #############################################################
    
    
    output$selectedCommune <- renderText({
        if(input$navPage == "Population" || 
           input$navPage == "Immobilier" ||
           input$navPage == "Commodites" ||
           input$navPage == "Autres"){
            MaCommune
        } else {
            MaCommune <<- input$navPage
        }
    })
    
    ### output description communes #############################
    output$DescriptionAirelaVille <- renderText({paste("<img src='armoiries/AirelaVille.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractAirelaVille,"</p></br></br></br></br>")})
    output$DescriptionAnieres <- renderText({paste("<img src='armoiries/Anieres.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractAnieres,"</p></br></br></br></br>")})
    output$DescriptionAvully <- renderText({paste("<img src='armoiries/Avully.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractAvully,"</p></br></br></br></br>")})
    output$DescriptionAvusy <- renderText({paste("<img src='armoiries/Avusy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractAvusy,"</p></br></br></br></br>")})
    output$DescriptionBardonnex <- renderText({paste("<img src='armoiries/Bardonnex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractBardonnex,"</p></br></br></br></br>")})
    output$DescriptionBellevue <- renderText({paste("<img src='armoiries/Bellevue.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractBellevue,"</p></br></br></br></br>")})
    output$DescriptionBernex <- renderText({paste("<img src='armoiries/Bernex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractBernex,"</p></br></br></br></br>")})
    output$DescriptionCarouge <- renderText({paste("<img src='armoiries/Carouge.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCarouge,"</p></br></br></br></br>")})
    output$DescriptionCartigny <- renderText({paste("<img src='armoiries/Cartigny.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCartigny,"</p></br></br></br></br>")})
    output$DescriptionCeligny <- renderText({paste("<img src='armoiries/Celigny.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCeligny,"</p></br></br></br></br>")})
    output$DescriptionChancy <- renderText({paste("<img src='armoiries/Chancy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractChancy,"</p></br></br></br></br>")})
    output$DescriptionCheneBougeries <- renderText({paste("<img src='armoiries/CheneBougeries.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCheneBougeries,"</p></br></br></br></br>")})
    output$DescriptionCheneBourg <- renderText({paste("<img src='armoiries/CheneBourg.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCheneBourg,"</p></br></br></br></br>")})
    output$DescriptionChoulex <- renderText({paste("<img src='armoiries/Choulex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractChoulex,"</p></br></br></br></br>")})
    output$DescriptionCollexBossy <- renderText({paste("<img src='armoiries/CollexBossy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCollexBossy,"</p></br></br></br></br>")})
    output$DescriptionCollongeBellerive <- renderText({paste("<img src='armoiries/CollongeBellerive.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCollongeBellerive,"</p></br></br></br></br>")})
    output$DescriptionCologny <- renderText({paste("<img src='armoiries/Cologny.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCologny,"</p></br></br></br></br>")})
    output$DescriptionConfignon <- renderText({paste("<img src='armoiries/Confignon.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractConfignon,"</p></br></br></br></br>")})
    output$DescriptionCorsier <- renderText({paste("<img src='armoiries/Corsier.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractCorsier,"</p></br></br></br></br>")})
    output$DescriptionDardagny <- renderText({paste("<img src='armoiries/Dardagny.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractDardagny,"</p></br></br></br></br>")})
    output$DescriptionGeneve <- renderText({paste("<img src='armoiries/Geneve.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractGeneve,"</p></br></br></br></br>")})
    output$DescriptionGenthod <- renderText({paste("<img src='armoiries/Genthod.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractGenthod,"</p></br></br></br></br>")})
    output$DescriptionGrandSaconnex <- renderText({paste("<img src='armoiries/GrandSaconnex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractGrandSaconnex,"</p></br></br></br></br>")})
    output$DescriptionGy <- renderText({paste("<img src='armoiries/Gy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractGy,"</p></br></br></br></br>")})
    output$DescriptionHermance <- renderText({paste("<img src='armoiries/Hermance.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractHermance,"</p></br></br></br></br>")})
    output$DescriptionJussy <- renderText({paste("<img src='armoiries/Jussy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractJussy,"</p></br></br></br></br>")})
    output$DescriptionLaconnex <- renderText({paste("<img src='armoiries/Laconnex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractLaconnex,"</p></br></br></br></br>")})
    output$DescriptionLancy <- renderText({paste("<img src='armoiries/Lancy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractLancy,"</p></br></br></br></br>")})
    output$DescriptionMeinier <- renderText({paste("<img src='armoiries/Meinier.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractMeinier,"</p></br></br></br></br>")})
    output$DescriptionMeyrin <- renderText({paste("<img src='armoiries/Meyrin.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractMeyrin,"</p></br></br></br></br>")})
    output$DescriptionOnex <- renderText({paste("<img src='armoiries/Onex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractOnex,"</p></br></br></br></br>")})
    output$DescriptionPerlyCertoux <- renderText({paste("<img src='armoiries/PerlyCertoux.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractPerlyCertoux,"</p></br></br></br></br>")})
    output$DescriptionPlanlesOuates <- renderText({paste("<img src='armoiries/PlanlesOuates.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractPlanlesOuates,"</p></br></br></br></br>")})
    output$DescriptionPregnyChambesy <- renderText({paste("<img src='armoiries/PregnyChambesy.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractPregnyChambesy,"</p></br></br></br></br>")})
    output$DescriptionPresinge <- renderText({paste("<img src='armoiries/Presinge.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractPresinge,"</p></br></br></br></br>")})
    output$DescriptionPuplinge <- renderText({paste("<img src='armoiries/Puplinge.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractPuplinge,"</p></br></br></br></br>")})
    output$DescriptionRussin <- renderText({paste("<img src='armoiries/Russin.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractRussin,"</p></br></br></br></br>")})
    output$DescriptionSatigny <- renderText({paste("<img src='armoiries/Satigny.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractSatigny,"</p></br></br></br></br>")})
    output$DescriptionSoral <- renderText({paste("<img src='armoiries/Soral.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractSoral,"</p></br></br></br></br>")})
    output$DescriptionThonex <- renderText({paste("<img src='armoiries/Thonex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractThonex,"</p></br></br></br></br>")})
    output$DescriptionTroinex <- renderText({paste("<img src='armoiries/Troinex.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractTroinex,"</p></br></br></br></br>")})
    output$DescriptionVandoeuvres <- renderText({paste("<img src='armoiries/Vandoeuvres.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractVandoeuvres,"</p></br></br></br></br>")})
    output$DescriptionVernier <- renderText({paste("<img src='armoiries/Vernier.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractVernier,"</p></br></br></br></br>")})
    output$DescriptionVersoix <- renderText({paste("<img src='armoiries/Versoix.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractVersoix,"</p></br></br></br></br>")})
    output$DescriptionVeyrier <- renderText({paste("<img src='armoiries/Veyrier.png' style='float:left; margin-right:10px; margin-top:5px'><p align='justify'>",abstractVeyrier,"</p></br></br></br></br>")})
    #############################################################
    
    
    
    #### Population ###############################################
    # Texte
    output$PopulationCommune <- renderText({
        updateContentPopulation()
    })
    updateContentPopulation <- eventReactive(input$navPage,{
        if(input$navPage == "Population")
        {
            paste(
                "<p><b>Nombre d'habitants (2019): </b> ",freturnpopulation(MaCommune),
                "</p><p><b>Nombre d'habitants par km2 (2019): </b>",freturndensitepopulation(MaCommune),
                "</p><p><b>Superficie de la commune en km2: </b>",freturnsuperficie(MaCommune), 
                "</br>"
            )
        }
    })
    
    # PLOT 1
    output$PopulationCommune_Plot1 <- renderPlot({
        updateContentPopulation_Plot1()
    })
    updateContentPopulation_Plot1 <- eventReactive(input$navPage,{
        if(input$navPage == "Population")
        {
            fplotpopulation(MaCommune)
        }
    })
    
    ## PLOT 2 
    #output$PopulationCommune_Plot2 <- renderPlot({
    #    updateContentPopulation_Plot2()
    #})
    #updateContentPopulation_Plot2 <- eventReactive(input$navPage,{
    #    if(input$navPage == "Population")
    #    {
    #        fplotdensitepopulation(MaCommune)
    #    }
    #})
    #############################################################
    
    
    #### Immobilier ###############################################
    # Texte
    output$ImmobilierCommune <- renderText({
        updateContentImmobilier()
    })
    updateContentImmobilier <- eventReactive(input$navPage,{
        if(input$navPage == "Immobilier"){
            paste(
                "<p><b>Loyer moyen d'un appartement de 100m2 (2019): </b> ",freturnloyer(MaCommune),
                "</p><p><b>Prix mediane d'un appartement de 100m2 (2017): </b>",freturnprixappart(MaCommune),
                "</p><p><b>Prix mediane d'une villa (Taille inconnue, 2017): </b>",freturnprixvilla(MaCommune), 
                "</br>"
            )
        }
    })
    
    # PLOT 1
    output$ImmobilierCommune_Plot1 <- renderPlot({
        updateContentImmobilier_Plot1()
    })
    updateContentImmobilier_Plot1 <- eventReactive(input$navPage,{
        if(input$navPage == "Immobilier")
        {
            fplotloyer(MaCommune)
        }
    })
    
    # PLOT 2
    output$ImmobilierCommune_Plot2 <- renderPlot({
        updateContentImmobilier_Plot2()
    })
    updateContentImmobilier_Plot2 <- eventReactive(input$navPage,{
        if(input$navPage == "Immobilier")
        {
            fplotprixappart(MaCommune)
        }
    })
    
    # PLOT 3
    output$ImmobilierCommune_Plot3 <- renderPlot({
        updateContentImmobilier_Plot3()
    })
    updateContentImmobilier_Plot3 <- eventReactive(input$navPage,{
        if(input$navPage == "Immobilier")
        {
            fplotprixvilla(MaCommune)
        }
    })
    #############################################################
    
    
    #### Commodités ###############################################
    output$CommoditesCommune <- renderText({
        updateContentCommodites()
    })
    updateContentCommodites <- eventReactive(input$navPage,{
        if(input$navPage == "Commodites"){
            paste(
                "<p><b>Nombre de supermarchés par km2: </b> ",freturnsupermarche(MaCommune),
                "</p><p><b>Nombre d'ecoles par km2: </b>",freturnecole(MaCommune),
                "</p><p><b>Nombre de parcs par km2: </b>",freturnparc(MaCommune), 
                "</br>"
            )
        }
    })
    #############################################################
    
    
    #### Autres ###############################################
    output$AutresCommune <- renderText({
        updateContentAutres()
    })
    
    updateContentAutres <- eventReactive(input$navPage,{
        if(input$navPage == "Autres"){
            paste(
                "<p><b>Nombre d'infractions du Code Penal pour 1000 habitants (2019): </b> ",freturninfraction(MaCommune),
                "</p><p><b>Depenses d'investissement de la commmune par habitant (2017): </b>",freturnDI(MaCommune),
                "</p><p><b>Nombre de medecins pour 1000 habitants: </b>",freturnmedecin(MaCommune), 
                "</br>"
            )
        }
    })
    
    # PLOT 1
    output$AutresCommune_Plot1 <- renderPlot({
        updateContentAutres_Plot1()
    })
    updateContentAutres_Plot1 <- eventReactive(input$navPage,{
        if(input$navPage == "Autres")
        {
            fplotinfraction(MaCommune)
        }
    })
    
    # PLOT 2
    output$AutresCommune_Plot2 <- renderPlot({
        updateContentAutres_Plot2()
    })
    updateContentAutres_Plot2 <- eventReactive(input$navPage,{
        if(input$navPage == "Autres")
        {
            fplotratioDI(MaCommune)
        }
    })
    #############################################################
    
    


}

# Run the application 
shinyApp(ui = ui, server = server)

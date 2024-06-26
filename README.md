# GenevAnalytics

Il s'agit d'un projet de groupe réalisé en collaboration avec Matthias Fahmey et Jimmy Dang, dans le cadre du cours de bachelor "Introduction to Data Science" à l'UNIGE. 

Nous avons réalisé cet outil intéractif d'aide à la décision en matière de logement sur le canton de Genève. Il permet de visualiser, par commune, des données relatives aux prix des logements, mais aussi des critères important lors du choix d'un lieu de vie, comme le nombre de supermarchés ou de médecins sur la communes. D'un côté de l'écran, les données sont visualisées sur une carte intéractive, de l'autre, des informations propres à chaque commune peuvent être obtenus par un menu déroulant. En voici une démonstration :

![demo](https://github.com/gregmaulet/GenevAnalytics/assets/60261098/02ce0396-222e-4563-ace2-27db4e56a6a6)
![Demo](https://private-user-images.githubusercontent.com/60261098/296217434-02ce0396-222e-4563-ace2-27db4e56a6a6.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDU0MjA0ODgsIm5iZiI6MTcwNTQyMDE4OCwicGF0aCI6Ii82MDI2MTA5OC8yOTYyMTc0MzQtMDJjZTAzOTYtMjIyZS00NTYzLWFjZTItMjdkYjRlNTZhNmE2LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAxMTYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTE2VDE1NDk0OFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWU3NjRlNWM0MmQwYzI5ZWEzOGYxYzZkNmFiNjI2OTcyMmQwNTBhNWJlZmY2ZmQ5MDFiM2YzMGYyYTA2MWYxNDcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.mrE6-bBIxW4bEraKHy7eRjqQK7pF5067VMihj_KJk74)

Cet outil a été réalisé à l'aide de R Shiny app, et de GitHub pour la collaboration. La carte intéractive est réalisée à l'aide de leaflet avec les découpages des communes obtenus auprès d'opendata.swiss, et les autres données étaient disponibles publiquement auprès du canton de Genève et/ou de la Confédération.

**Disclaimer:** Il s'agit d'un devoir réalisé dans le cadre d'un cours et n'est donc pas un outil élaborée destiné à être utilisé, mais simplement la concrétisation d'une idée, réalisé dans un temps très limité, pour seul but la validation de compétences programmatiques. 

install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

library(DBI)
con <- dbConnect(odbc::odbc(), "DemoData")

#Creacion de diferentes objetos

#Data frames

dfsql = dbGetQuery(con,"SELECT e.*, c.NombreFacultad FROM Fact.Examen E INNER JOIN
                                  Dimension.Carrera C on (E.SK_Carrera
                                  = C.SK_Carrera)")

#  Un conteo de la cantidad de exámenes que se realizaron agrupado por facultad

Df_ConteoPorFacultad = dfsql %>% count(NombreFacultad)

#  Un conteo de la cantidad de candidatos agrupados por genero


dfsql1 = dbGetQuery(con, "select DC.ID_Candidato, DC.Genero
                          from Dimension.Candidato DC
                   ")

Df_AgrupacionGenero = dfsql1 %>% group_by(Genero) %>% count(ID_Candidato) %>% count(Cantidadn = n)


#  Un total de la cantidad de ingresos por evaluaciones (columna precio) que se ha recibido 
#agrupado por carrera

dfsql2 = dbGetQuery(con, "SELECT E.Precio,DC.NombreCarrera 
FROM Fact.Examen E INNER JOIN Dimension.Carrera DC ON (E.SK_Carrera = DC.SK_Carrera)
")

Df_TotalPrecio = dfsql2 %>% summarise(Df_TotalPrecio = sum(Precio)) 

Df_TotalPrecio = dfsql2 %>% group_by(NombreCarrera) %>% summarise(Df_TotalPrecio = sum(Precio))

#Un data frame filtrado que contenga únicamente las tres facultades con el promedio de la 
#nota mas alto

dfsql3 = dbGetQuery(con, "
SELECT DC.NombreFacultad, E.NotaTotal
FROM Dimension.Carrera DC INNER JOIN
Fact.Examen E ON (DC.SK_Carrera = E.SK_Carrera)

"
)

PromedioAlto <- dfsql3 %>% group_by(NombreFacultad) %>% summarise(PromedioNota = mean(NotaTotal))

Df_PromedioAltoFacultad <- data.frame(PromedioAlto)



#GRAFICAS

#Un grafico de pie con la cantidad de exámenes agrupados por facultad


ggplot(Df_ConteoPorFacultad,aes(x="",y=n,fill=NombreFacultad)) +
  geom_bar(stat = "identity", width=1) +
  coord_polar("y",start = 0)

#Un grafico de barras con el promedio de la nota agrupado por carrera

dfsql5 <- dbGetQuery(con,"SELECT E.NotaTotal, C.NombreCarrera
FROM Fact.Examen E INNER JOIN 
Dimension.Carrera C ON (E.SK_Carrera = C.SK_Carrera)
")


NotasCarreraPromedio <- dfsql5 %>% group_by(NombreCarrera)  %>% summarise(NotaPromedio = mean(NotaTotal))

Df_NotasCarreraPromedio <- data.frame(NotasCarreraPromedio)

class(Df_NotasCarreraPromedio)


ggplot(Df_NotasCarreraPromedio, aes(x=NombreCarrera, y=NotaPromedio, fill=NombreCarrera))+
  geom_bar(stat = "identity", width = 1)+
  theme_dark()



#Un grafico de línea con la cantidad de exámenes por año

dfsql4 = dbGetQuery(con, "

SELECT E.ID_Examen, F.Year
FROM Fact.Examen E INNER JOIN 
Dimension.Fecha F ON (E.DateKey = F.DateKey)

                    
")

CantidadExamenAnio <- dfsql4 %>% group_by(Year) %>% summarise(CantidadExamen = n())

Df_CantidadExamenAnio = data.frame(CantidadExamenAnio)


ggplot(data = Df_CantidadExamenAnio, aes(x=Year,y=CantidadExamen)) +
         geom_line() + geom_text(
           label = Df_CantidadExamenAnio$CantidadExamen, nudge_x = 0.25, nudge_y = 0.25,check_overlap = TRUE)



        






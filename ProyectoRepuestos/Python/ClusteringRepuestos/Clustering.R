install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)
library(DBI)
library(odbc)

install.packages("DBI")

# ALEXANDER VILLATORO 1182118
# LUIS CHUTÁ 1320016
# SERGIO LARA 1044418
# ANDRES GALVEZ 1024718


# Conectar a DB

con <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "DESKTOP-0PP45D4", 
                 Database = "RepuestosWeb", timeout = 50)

#Data frames

dfsql = dbGetQuery(con,"

select cat.Nombre,
sum(p.Precio*cd.Cantidad) as TotalPorParte,
sum(cd.Cantidad) as TotalPartesCotizadas,
avg(cd.cantidad) as PromedioPartesCotizadas
from Cotizacion C left join
CotizacionDetalle CD on C.IDCotizacion = CD.IDCotizacion inner join
Partes P on P.ID_Parte = cd.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
                   
")



dfsql
class(dfsql)

rownames(dfsql) <- dfsql$Nombre
RepuestoNombre <- subset(dfsql, select = -c(Nombre))
Repuestos <- scale(RepuestoNombre)
Repuestos <- na.omit(Repuestos) #quitar los registros que estan en null

head(dfsql)
head(Repuestos)

install.packages("factoextra") #paquete para graficar
library(factoextra) #libreria de paquete instalado


distancia <- get_dist(Repuestos)
fviz_dist(distancia, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))


set.seed(123) #seed permitira fijar un id para generar valores random
clusterk2 <- kmeans(Repuestos, 2, nstart = 25)
print(clusterk2)

#visualizacion de asignacion a cluster
clusterk2$cluster
#Tama?o de cada cluster
clusterk2$size
#Centros de los 4 clusters
clusterk2$centers
clusterk2$totss
clusterk2$withinss
clusterk2$tot.withinss
clusterk2$betweenss
clusterk2$iter
clusterk2$ifault

fviz_cluster(clusterk2, data = Repuestos)


clusterk3 <- kmeans(Repuestos, 3, nstart = 25)
clusterk4 <- kmeans(Repuestos, 4, nstart = 25)
clusterk5 <- kmeans(Repuestos, 5, nstart = 25)
clusterk6 <- kmeans(Repuestos, 6, nstart = 25)
clusterk7 <- kmeans(Repuestos, 7, nstart = 25)

grafica1 <- fviz_cluster(clusterk2, geom = "point", data = Repuestos) + ggtitle("k = 2")
grafica2 <- fviz_cluster(clusterk3, geom = "point",  data = Repuestos) + ggtitle("k = 3")
grafica3 <- fviz_cluster(clusterk4, geom = "point",  data = Repuestos) + ggtitle("k = 4")
grafica4 <- fviz_cluster(clusterk5, geom = "point",  data = Repuestos) + ggtitle("k = 5")
grafica5 <- fviz_cluster(clusterk6, geom = "point",  data = Repuestos) + ggtitle("k = 6")
grafica6 <- fviz_cluster(clusterk7, geom = "point",  data = Repuestos) + ggtitle("k = 7")

library(gridExtra)
grid.arrange(grafica1, grafica2, grafica3, grafica4, grafica5,grafica6,nrow = 2)




#dibujamos la grafica de wss vs K para ver el K "optimo"
fviz_nbclust(Repuestos, kmeans, method = "wss") +
  geom_vline(xintercept = 6, linetype = 2)

EstadosCluster4<-as.data.frame(clusterk4$cluster)
RepuestosRaw<-Repuestos
RepuestosRaw

tst<-merge(EstadosCluster4,RepuestosRaw,by=0, all=TRUE)

names(tst)[2]<-"clustno"
tst<-subset(tst, select=-c(Row.names))

aggregate(tst,by=list(tst$clustno),FUN=mean)


# ¿Cuál es el mejor número de clusters? ¿Por qué?
# Un cluster de 6 o 7 ya que divide perfectamente los datos y no existen un traslape entre ellos.

#  ¿Cuáles serían las etiquetas para cada cluster?
# Los Centroidos por cada cluster que se tenga, los titulos, tambien nos identifica las relaciones entre cada dato o columna.


# ----------------------------------------------------------------------------

# EJEERCICIO # 2

setwd("C:\\Users\\alexg\\Downloads")

install.packages('arules')
library('arules')


txn <- read.transactions ("Compras.csv",rm.duplicates = FALSE,format="single",sep=",",cols=c(1,2))


#libreria para plotear arules
install.packages("arulesViz")
library("arulesViz")

txn@itemInfo
image(txn)


RulesCompras <- apriori(txn,parameter=list(sup=0.5,conf=0.9,target="rules"))


inspect(RulesCompras)


plot(txn)
plot(RulesCompras, engine = "plotly") #plot interactivo

#tabla para visualizar reglas
inspectDT(txn)

#plot grafico
plot(RulesCompras, method = "graph", engine = "htmlwidget")


#  ¿Existe alguna regla entre productos que tenga este nivel de confianza? ¿Cuáles?
# Solamente existe una regla en la cual coinciden con el soporte del 50% y una confianza del 90%


# ¿Cuál es el nivel de lift de cada regla encontrada?

rules_high_lift <- head(sort(RulesCompras, by="lift"), 3)
inspect(rules_high_lift)
inspectDT(rules_high_lift)



setwd("E:\\Archivos Varios\\Downloads")
# Instalamos los paquetes
install.packages('arules')
library('arules')
install.packages("dplyr")
library(dplyr)

a1 <- read.csv(file = '201031COVID19MEXICO.csv')

DatosAgrupados <- a1 %>%                         # Count rows by group
  group_by(EDAD) %>% 
  summarise(UCICount = sum(ifelse((UCI ==1)|(UCI==2),1,0)),INTUBADOCount=sum(ifelse(INTUBADO==2,1,0)),FallecidosCount=sum(ifelse( FECHA_DEF !="9999-99-99",1,0)), TotalCasos = n())


Totales <- scale(DatosAgrupados) # con la funcion scale ajustamos todo a la media y sd
Totales <- na.omit(DatosAgrupados) # con la funcion scale ajustamos todo a la media y sd

clusterk3 <- kmeans(Totales, 3, nstart = 25)
clusterk4 <- kmeans(Totales, 4, nstart = 25)
clusterk5 <- kmeans(Totales, 5, nstart = 25)
clusterk6 <- kmeans(Totales, 20, nstart = 25)
# Se eligieron estos K por que se vieron visualmente que al aumentar el nivel de K
# aumenta la mejora de los agrupamientos.



install.packages("factoextra") #paquete para graficar
library(factoextra) #libreria de paquete instalado
grafica2 <- fviz_cluster(clusterk3, geom = "point",  data = Totales) + ggtitle("k = 3")
grafica3 <- fviz_cluster(clusterk4, geom = "point",  data = Totales) + ggtitle("k = 4")
grafica4 <- fviz_cluster(clusterk5, geom = "point",  data = Totales) + ggtitle("k = 5")
grafica5 <- fviz_cluster(clusterk6, geom = "point",  data = Totales) + ggtitle("k = 20")
library(gridExtra)
grid.arrange(grafica2, grafica3, grafica4,grafica5, nrow = 2)

# Se elige el K=20 ya que este es que presenta una mejor agrupacion a los datos vistos y
# se cree que mejorara poco a poco viendo que la muestra esta en una distribucion normal.





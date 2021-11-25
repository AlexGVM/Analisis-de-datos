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

select * from V_CantidadPorVehiculoyDescuento;
                   
")



dfsql

dfsql <- na.omit(dfsql)

dfsqlindex <- sample(1:nrow(dfsql), 0.8*nrow(dfsql))

dfsql1 <- dfsql[dfsqlindex,] #80%
dfsql2 <- dfsql[-dfsqlindex,] #20%


for (i in c("NombreParte","NombreDescuento","Marca","Modelo")) {
  dfsql1[,i]=as.factor(dfsql1[,i])  
}


for (i in c("NombreParte","NombreDescuento","Marca","Modelo")) {
  dfsql1[,i]=as.numeric(dfsql1[,i])  
}

dfsql1

lmHeight = lm(Cantidad~Anio+Marca+Modelo, data = dfsql1) #Create the linear regression

summary(lmHeight) #Review the results

lmHeight2 = lm(Cantidad~NombreParte, data = dfsql1) #Create the linear regression

summary(lmHeight2) 

lmHeight3 = lm(Cantidad~NombreDescuento, data = dfsql1) #Create the linear regression

summary(lmHeight3) 

plot(Cantidad~NombreParte, data = dfsql1)

# Add fit lines
abline(lm(Cantidad~NombreParte, data = dfsql1), col="red")


dfsql1

boxplot(dfsql1$NombreParte, main="Nombre Parte", sub=paste("Outlier rows: ", boxplot.stats(dfsql1$NombreParte)$out))


boxplot(dfsql1$NombreDescuento, main="Nombre Descuento ", sub=paste("Outlier rows: ", boxplot.stats(dfsql1$NombreDescuento)$out))

boxplot(dfsql1$Marca, main="Marca", sub=paste("Outlier rows: ", boxplot.stats(dfsql1$Marca)$out))


scatter.smooth(y=dfsql1$Cantidad, x=dfsql1$Anio, main = "Cantidad - Año")
#----------------------------------------------------------

#Regresión logistica

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

dfsqlL = dbGetQuery(con,"

select R.Nombre as NombreRegion, CA.Nombre as NombreCategoria, V.Marca, O.Total_Orden, DO.Cantidad,P.Precio
from Region R inner join Ciudad C on (R.ID_Region = C.ID_Region)
inner join Orden O on (C.ID_Ciudad = O.ID_Ciudad) inner join 
Detalle_orden DO on (O.ID_Orden = DO.ID_Orden) inner join
Partes P on (P.ID_Parte = DO.ID_Parte) inner join 
Categoria CA on (CA.ID_Categoria = P.ID_Categoria) inner join
Vehiculo V on (V.VehiculoID = DO.VehiculoID)


"
)

dfsqlL <- na.omit(dfsqlL)

dfsqlindexL <- sample(1:nrow(dfsqlL), 0.8*nrow(dfsqlL))

dfsqlL1 <- dfsqlL[dfsqlindexL,] #80%
dfsqlL2 <- dfsqlL[-dfsqlindexL,] #20%


for (i in c("NombreRegion","NombreCategoria","Marca")) {
  dfsqlL1[,i]=as.factor(dfsqlL1[,i])  
}


for (i in c("NombreRegion","NombreCategoria","Marca")) {
  dfsqlL1[,i]=as.numeric(dfsqlL1[,i])  
}

dfsqlL1

lmHeightL = lm(Total_Orden~NombreRegion+NombreCategoria+Marca+Cantidad+Precio, data = dfsqlL1) #Create the linear regression


lmHeightL2 = lm(Total_Orden~Precio, data = dfsqlL1) #Create the linear regression

lmHeightL3 = lm(Total_Orden~Cantidad, data = dfsqlL1) #Create the linear regression

lmHeightL3 = lm(Total_Orden~NombreRegion, data = dfsqlL1) #Create the linear regression


summary(lmHeightL2) #Review the results





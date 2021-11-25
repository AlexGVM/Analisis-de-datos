install.packages("ggplot2")
install.packages("dplyr")
install.packages("TSeries")

library(ggplot2)
library(dplyr)
library(DBI)
library(odbc)

library(tseries)

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

SELECT CAST(DATEPART(YEAR,c.FechaCreacion) AS VARCHAR(4)) + '-' +
 CAST(DATEPART(QUARTER,c.FechaCreacion) AS VARCHAR(1)) AS
AnioTrimestreCotizacion,
 SUM(cd.Cantidad * p.Precio) AS TotalCotizacion,
 SUM(cd.Cantidad) AS TotalPartesVendidas,
 AVG(cd.Cantidad * p.Precio) AS PromedioCotizacion
FROM dbo.Cotizacion c
 INNER JOIN dbo.CotizacionDetalle cd
 ON cd.IDCotizacion = c.IDCotizacion
 INNER JOIN dbo.Partes p
 ON p.ID_Parte = cd.ID_Parte
 JOIN dbo.Vehiculo v
 ON v.VehiculoID = cd.VehiculoID
GROUP BY CAST(DATEPART(YEAR,c.FechaCreacion) AS VARCHAR(4)) + '-' +
 CAST(DATEPART(QUARTER,c.FechaCreacion) AS VARCHAR(1))
ORDER BY 1 ASC;

                   
")


install.packages('ggplot')
library(ggplot2)


install.packages("forecast", dependencies=TRUE)
library(forecast)

df1 <- dfsql %>% select(TotalCotizacion)


df2 <- dfsql %>% select(TotalPartesVendidas)


df3 <- dfsql %>% select(PromedioCotizacion)


ts1 <- ts(df1, start = c(2000,1), frequency = 4)
plot(ts1)


ts2 <- ts(df2, start = c(2000,1), frequency = 4)
plot(ts2)


ts3 <- ts(df3, start = c(2000,1), frequency = 4)
plot(ts3)

# la funcion window nos permite dividir un objeto "ts" de un inicio a un fin
ts180p <- window(ts1, start = 2000, end = 2015)
plot(ts180p)

ts280p <- window(ts2, start = 2000, end = 2015)
plot(ts280p)

ts380p <- window(ts3, start = 2000, end = 2015)
plot(ts380p)


meanmodel <- meanf(ts180p,h=80)
naivemodel <- naive(ts180p, h=80)
driftmodel <- rwf(ts180p, h=80)

adf.test(ts180p)

acf(meanmodel$residuals)

meanmodel2 <- meanf(ts280p,h=80)
naivemodel2 <- naive(ts280p, h=80)
driftmodel2 <- rwf(ts280p, h=80)

adf.test(ts280p)
acf(meanmodel2$residuals)

meanmodel3 <- meanf(ts380p,h=80)
naivemodel3 <- naive(ts380p, h=80)
driftmodel3 <- rwf(ts380p, h=80)

adf.test(ts380p)
acf(meanmodel3$residuals)

plot(meanmodel, plot.conf = F, main = "")
lines(naivemodel$mean, col=123, lwd = 2)
lines(driftmodel$mean, col='red', lwd = 2)

legend("topleft",lty=1,col=c(4,123,22),
       legend=c("Mean","Naive","Drift"))

plot(meanmodel2, plot.conf = F, main = "")
lines(naivemodel2$mean, col=123, lwd = 2)
lines(driftmodel2$mean, col='red', lwd = 2)

legend("topleft",lty=1,col=c(4,123,22),
       legend=c("Mean","Naive","Drift"))

plot(meanmodel3, plot.conf = F, main = "") 
lines(naivemodel3$mean, col=123, lwd = 2) 
lines(driftmodel3$mean, col='red', lwd = 2)


legend("topleft",lty=1,col=c(4,123,22),
       legend=c("Mean","Naive","Drift"))



acf(ts180p, lag.max = 20) 
pacf(ts180p, lag.max = 20)


auto.arima(ts180p)
arima(ts180p)

myar = auto.arima(ts180p, stepwise = F, approximation = F)

myar

# Ploteamos vs original
plot(ts180p, lwd = 3)
lines(myar$fitted, col = "red")












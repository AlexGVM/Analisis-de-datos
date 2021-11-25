go
CREATE VIEW  V_CantidadPorVehiculoyDescuento
AS 

sELECT v.Anio,
 v.Marca,
 v.Modelo,
 p.Nombre AS NombreParte,
 d.NombreDescuento,
 do.Cantidad
FROM dbo.Detalle_orden do
 JOIN dbo.Partes p
 ON p.ID_Parte = do.ID_Parte
 JOIN dbo.Descuento d
 ON d.ID_Descuento = do.ID_Descuento
 JOIN dbo.Vehiculo v
 ON v.VehiculoID = do.VehiculoID; go SELECT CAST(DATEPART(YEAR,c.FechaCreacion) AS VARCHAR(4)) + '-' +
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
ORDER BY 1 ASC;SELECT Nombre, COUNT(*) FROM Partes 
     GROUP BY Nombre
     HAVING COUNT(*)>1;
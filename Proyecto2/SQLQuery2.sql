CREATE VIEW VW_TotalOrdenNombres
AS
select R.Nombre as NombreRegion, CA.Nombre as NombreCategoria, V.Marca, O.Total_Orden, DO.Cantidad,P.Precio
from Region R inner join Ciudad C on (R.ID_Region = C.ID_Region)
inner join Orden O on (C.ID_Ciudad = O.ID_Ciudad) inner join 
Detalle_orden DO on (O.ID_Orden = DO.ID_Orden) inner join
Partes P on (P.ID_Parte = DO.ID_Parte) inner join 
Categoria CA on (CA.ID_Categoria = P.ID_Categoria) inner join
Vehiculo V on (V.VehiculoID = DO.VehiculoID)
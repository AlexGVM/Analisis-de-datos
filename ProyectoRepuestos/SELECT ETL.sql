
/* RECORDATORIO

	'4-ETL' as ID_Batch,
	'Repuestos' as ID_SourceSystem


*/


-- DIMENSION PARTES
SELECT  
	P.ID_Parte,
	C.ID_Categoria,
	L.ID_Linea,
	P.Nombre as NombrePartes,
	P.Descripcion as DescripcionPartes,
	P.Precio,
	C.Nombre as NombreCategoria,
	C.Descripcion as DescripcionCategoria,
	L.Nombre as NombreLinea,
	L.Descripcion as DescripcionLinea,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion



FROM dbo.Linea L INNER JOIN
dbo.Categoria C on (L.ID_Linea = C.ID_Linea) INNER JOIN 
dbo.Partes P on (C.ID_Categoria = P.ID_Categoria)

-- DIMENSION CLIENTES

SELECT  
	ID_Cliente,
	PrimerNombre,
	SegundoNombre,
	PrimerApellido,
	SegundoApellido,
	Genero,
	Correo_Electronico,
	FechaNacimiento,
	Direccion,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion


FROM dbo.Clientes


--DIMENSION VEHICULO

SELECT  
	H.VIN_Patron,
	H.VehiculoID,
	H.Anio,
	H.Marca,
	H.Modelo,
	H.SubModelo,
	H.Estilo,
	H.FechaCreacion AS FechaCreacionVehiculo,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacionAuditoria,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion

FROM dbo.Vehiculo H


--DIMENSION GEOGRAFIA

SELECT  
	C.ID_Ciudad as ID_Geografia,
	C.ID_Ciudad,
	R.ID_Region,
	P.ID_Pais,
	C.Nombre as NombreCiudad,
	C.CodigoPostal,
	R.Nombre as NombreRegion,
	P.Nombre as NombrePais,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion


FROM dbo.Ciudad C INNER JOIN 
dbo.Region R ON (C.ID_Region = R.ID_Region) INNER JOIN 
dbo.Pais P ON (P.ID_Pais = R.ID_Pais)

-- DIMENSION ASEGURADORAS

SELECT
	A.IDAseguradora,
	A.NombreAseguradora,
	A.RowCreatedDate,
	A.Activa,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion


FROM dbo.Aseguradoras A



-- DIMENSION Descuento

SELECT
	D.ID_Descuento,
	D.NombreDescuento,
	D.PorcentajeDescuento,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion

FROM dbo.Descuento D

-- DIMENSION PlantaReparacion

SELECT   
   IDPlantaReparacion, 
	CompanyNombre ,
	Direccion, 
	Direccion2 ,
	Ciudad ,
	Estado ,
	CodigoPostal, 
	Pais,
	AlmacenKeystone, 
	LocalizadorCotizacion, 
	FechaAgregado ,
	IDEmpresa ,
	ValidacionSeguro, 
	Activo ,
	CreadoPor, 
	ActualizadoPor, 
	UltimaFechaActualizacion,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion

FROM dbo.PlantaReparacion


SELECT
	ID_StatusOrden,
	NombreStatus,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion


FROM dbo.StatusOrden


-- DIMENSION COTIZACION 

SELECT  
	C.IDCotizacion,
	A.IDAseguradora,
	P.IDPlantaReparacion,
	CD.NumLinea,
	CD.ID_Parte,
	C.IDOrden,
	C.status,
	C.TipoDocumento,
	C.ProcesadoPor,
	C.AseguradoraSubsidiaria,
	C.NumeroReclamo,
	C.OrdenRealizada,
	C.CotizacionRealizada,
	C.CotizacionDuplicada,
	C.procurementFolderID,
	C.DireccionEntrega1,
	C.DireccionEntrega2,
	C.MarcadoEntrega,
	C.IDPartner,
	C.CodigoPostal,
	C.LeidoPorPlantaReparacion,
	C.LeidoPorPlantaReparacionFecha,
	C.CotizacionReabierta,
	C.EsAseguradora,
	C.CodigoVerificacion,
	C.IDClientePlantaReparacion,
	C.FechaCreacionRegistro,
	C.IDRecotizacion,
	C.PartnerConfirmado,
	C.WrittenBy,
	C.SeguroValidado,
	C.FechaCaptura,
	C.Ruta,
	C.FechaLimiteRuta,
	C.TelefonoEntrega,
	P.CompanyNombre,
	P.Direccion,
	P.Direccion2,
	P.Ciudad as CiudadPlanta,
	P.Estado as EstadoPlanta,
	P.CodigoPostal as CodigoPostalPlanta,
	P.Pais as PaisPlanta,
	P.TelefonoAlmacen,
	P.FaxAlmacen,
	P.CorreoContacto,
	P.NombreContacto,
	P.TelefonoContacto,
	P.TituloTrabajo,
	P.AlmacenKeystone,
	P.IDPredio,
	P.LocalizadorCotizacion,
	P.FechaAgregado,
	P.IDEmpresa,
	P.ValidacionSeguro,
	P.Activo,
	P.CreadoPor,
	P.ActualizadoPor,
	P.UltimaFechaActualizacion,
	CD.OETipoParte,
	CD.AltPartNum,
	CD.AltTipoParte,
	CD.ciecaTipoParte,
	CD.partDescripcion,
	CD.Cantidad as CantidadCD,
	CD.PrecioListaOnRO,
	CD.PrecioNetoOnRO,
	CD.NecesitadoParaFecha,
	CD.VehiculoID,
	A.NombreAseguradora,
	A.RowCreatedDate,
	A.Activa,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion


FROM dbo.Cotizacion C INNER JOIN
dbo.Aseguradoras A ON (C.IDAseguradora = A.IDAseguradora) INNER JOIN 
dbo.CotizacionDetalle CD ON (CD.IDCotizacion = C.IDCotizacion) INNER JOIN 
dbo.PlantaReparacion P ON (P.IDPlantaReparacion = C.IDPlantaReparacion)

--FACT ORDEN

SELECT  
	O.ID_Orden,
	C.ID_Cliente,
	CU.ID_Ciudad,
	SO.ID_StatusOrden,
	DO.ID_DetalleOrden,
	P.ID_Parte,
	D.ID_Descuento,
	DO.Cantidad,
	DO.VehiculoID,
	SO.NombreStatus,
	O.Total_Orden,
	O.Fecha_Orden,
	O.NumeroOrden,
	D.NombreDescuento,
	D.PorcentajeDescuento,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion

FROM dbo.Orden O INNER JOIN
dbo.Detalle_orden DO on (DO.ID_Orden = O.ID_Orden) INNER JOIN 
dbo.StatusOrden SO on (SO.ID_StatusOrden = O.ID_StatusOrden) INNER JOIN 
dbo.Descuento D on (D.ID_Descuento = DO.ID_Descuento) INNER JOIN 
dbo.Clientes C on (C.ID_Cliente = O.ID_Cliente) INNER JOIN 
dbo.Ciudad CU on (CU.ID_Ciudad = O.ID_Ciudad) INNER JOIN 
dbo.Partes P on (P.ID_Parte = DO.ID_Parte)


select *
from dbo.PlantaReparacion

select *
from dbo.Vehiculo

select *
from dbo.Partes
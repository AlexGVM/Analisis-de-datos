USE [RepuestosWeb_DWH]
GO

--Creamos tabla para log de fact batches
CREATE TABLE FactLog
(
	ID_Batch UNIQUEIDENTIFIER DEFAULT(NEWID()),
	FechaEjecucion DATETIME DEFAULT(GETDATE()),
	NuevosRegistros INT,
	CONSTRAINT [PK_FactLog] PRIMARY KEY
	(
		ID_Batch
	)
)
GO

ALTER TABLE Fact.Orden ADD CONSTRAINT [FK_IDBatch] FOREIGN KEY (ID_Batch) 
REFERENCES Factlog(ID_Batch)
go


/****** Object:  Table [staging].[Examen]    Script Date: 8/31/2020 6:34:39 PM ******/
create schema [staging]
go

DROP TABLE IF EXISTS [staging].[Orden]
GO

CREATE TABLE [staging].[Orden](
	[ID_Orden] [int] NOT NULL,
	[ID_Cliente] [int] NULL,
	[ID_Ciudad] [int] NOT NULL,
	[ID_Geografia] [int] NOT NULL,
	[ID_StatusOrden] [int] NOT NULL,
	[Total_Orden] [decimal](12, 2) NULL,
	[Fecha_Orden] [datetime] NOT NULL,
	[NumeroOrden] [varchar](20) NULL,
	[ID_DetalleOrden] [int] NOT NULL,
	[ID_Parte] [varchar](50) NULL,
	[ID_Descuento] [int] NULL,
	[Cantidad] [int] NOT NULL,
	[VehiculoID] [int] NULL,
	[IDCotizacion] [int] NOT NULL,
	[status] [varchar](50) NULL,
	[TipoDocumento] [varchar](50) NULL,
	[FechaCreacionCotizacion] [datetime] NULL,
	[FechaModificacionCotizacion] [datetime] NULL,
	[ProcesadoPor] [varchar](50) NULL,
	[IDAseguradora] [int] NULL,
	[AseguradoraSubsidiaria] [varchar](80) NULL,
	[NumeroReclamo] [varchar](50) NULL,
	[IDPlantaReparacion] [varchar](50) NULL,
	[OrdenRealizada] [bit] NULL,
    [CotizacionRealizada] [bit] NULL, 
	[CotizacionDuplicada] [bit] NULL, 
	[procurementFolderID] [varchar](50) NULL, 
	[DireccionEntrega1] [varchar](50) NULL, 
	[DireccionEntrega2] [varchar](50) NULL, 
	[MarcadoEntrega] [bit] NULL, 
	[IDPartner] [varchar](50) NULL, 
	[CodigoPostal] [varchar](10) NULL, 
	[LeidoPorPlantaReparacion] [bit] NOT NULL, 
	[LeidoPorPlantaReparacionFecha] [datetime] NULL, 
	[CotizacionReabierta] [bit] NOT NULL, 
	[EsAseguradora] [bit] NULL, 
	[CodigoVerificacion] [varchar](50) NULL, 
	[IDClientePlantaRepacion] [varchar](50) NULL, 
	[FechaCreacionRegistro] [datetime] NOT NULL, 
	[IDRecotizacion] [varchar](100) NULL, 
	[PartnerConfirmado] [bit] NOT NULL, 
	[WrittenBy] [varchar](80) NULL, 
	[SeguroValidado] [bit] NOT NULL, 
	[FechaCaptura] [datetime] NULL, 
	[Ruta] [varchar](500) NULL, 
	[FechaLimiteRuta] [varchar](50) NULL, 
	[TelefonoEntrega] [varchar](15) NULL,
	[NumLinea] [varchar](50) NOT NULL,
	[OETipoParte] [varchar](10) NULL, 
	[AltPartNum] [varchar](45) NULL, 
	[AltTipoParte] [varchar](45) NULL, 
	[ciecaTipoParte] [varchar](45) NULL, 
	[partDescripcion] [varchar](255) NULL, 
	[CantidadCD] [varchar](100) NULL, 
	[PrecioListaOnRO] [varchar](10) NULL, 
	[PrecioNetoOnRO] [varchar](10) NULL, 
	[NecesitadoParaFecha] [datetime] NULL, 



) ON [PRIMARY]
GO

--Query para llenar datos en Staging
SELECT 
	O.[ID_Orden],
	O.[ID_Cliente],
	O.[ID_Ciudad],
	O.[ID_Ciudad] as [ID_Geografia],
	O.[ID_StatusOrden],
	O.[Total_Orden] ,
	O.[Fecha_Orden] ,
	O.[NumeroOrden] ,
	DO.[ID_DetalleOrden],
	DO.[ID_Parte] ,
	DO.[ID_Descuento],
	DO.[Cantidad],
	DO.[VehiculoID],
	C.[IDCotizacion],
	C.[status] ,
	C.[TipoDocumento] ,
	C.[FechaCreacion] ,
	C.[FechaModificacion] ,
	C.[ProcesadoPor] ,
	C.[IDAseguradora],
	C.[AseguradoraSubsidiaria] ,
	C.[NumeroReclamo] ,
	C.[IDPlantaReparacion] ,
	C.[OrdenRealizada] ,
    C.[CotizacionRealizada] , 
	C.[CotizacionDuplicada] , 
	C.[procurementFolderID] , 
	C.[DireccionEntrega1] , 
	C.[DireccionEntrega2] , 
	C.[MarcadoEntrega] , 
	C.[IDPartner] , 
	C.[CodigoPostal], 
	C.[LeidoPorPlantaReparacion] , 
	C.[LeidoPorPlantaReparacionFecha] , 
	C.[CotizacionReabierta] , 
	C.[EsAseguradora] , 
	C.[CodigoVerificacion] , 
	C.[IDClientePlantaReparacion] , 
	C.[FechaCreacionRegistro] , 
	C.[IDRecotizacion] , 
	C.[PartnerConfirmado] , 
	C.[WrittenBy] , 
	C.[SeguroValidado] , 
	C.[FechaCaptura] , 
	C.[Ruta] , 
	C.[FechaLimiteRuta] , 
	C.[TelefonoEntrega] ,
	CD.[NumLinea] ,
	CD.[OETipoParte], 
	CD.[AltPartNum] , 
	CD.[AltTipoParte] , 
	CD.[ciecaTipoParte] , 
	CD.[partDescripcion] , 
	CD.[Cantidad] AS CantidadCD , 
	CD.[PrecioListaOnRO], 
	CD.[PrecioNetoOnRO], 
	CD.[NecesitadoParaFecha],



FROM dbo.Orden O
     INNER JOIN dbo.Detalle_orden DO ON(O.ID_Orden = DO.ID_Orden)
	 INNER JOIN dbo.Cotizacion C ON (O.ID_Orden = C.IDOrden)
	 INNER JOIN dbo.CotizacionDetalle CD ON (CD.IDCotizacion = C.IDCotizacion)

	 WHERE ((Fecha_Orden>?))
go 


CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT

		INSERT INTO FactLog (ID_Batch, FechaEjecucion, NuevosRegistros)
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE Fact.Orden AS T
		USING (
			SELECT SK_Partes, SK_Geografia,  SK_Vehiculo, SK_Descuento, SK_StatusOrden, SK_Aseguradoras, SK_PlantaReparacion, DateKey, getdate() FechaCreacion, CAST(SUSER_NAME() AS nvarchar(100)) UsuarioCreacion, NULL as FechaModificacion, NULL as UsuarioModificacion,  ID_Orden, DG.ID_Ciudad, DSO.ID_StatusOrden, ID_DetalleOrden, NumLinea, IDCotizacion, IDAseguradora, DPR.IDPlantaReparacion, DD.ID_Descuento, ID_Partes, Cantidad, DV.VehiculoID, Total_Orden, Fecha_Orden, NumeroOrden,status, TipoDocumento, FechaCreacionCotizacion, FechaModificacionCotizacion, ProcesadoPor, AseguradoraSubsidiaria, NumeroReclamo, OrdenRealizada, CotizacionRealizada, CotizacionDuplicada, procurementFolderID, DireccionEntrega1, DireccionEntrega2, MarcadoEntrega, IDPartner, R.CodigoPostal, LeidoPorPlantaReparacion, LeidoPorPlantaReparacionFecha, CotizacionReabierta, EsAseguradora, CodigoVerificacion, IDClientePlantaRepacion, FechaCreacionRegistro, IDRecotizacion, PartnerConfirmado, WrittenBy, SeguroValidado, FechaCaptura, Ruta, FechaLimiteRuta, TelefonoEntrega, OETipoParte, AltPartNum, AltTipoParte, ciecaTipoParte, partDescripcion, CantidadCD, PrecioListaOnRO, PrecioNetoOnRO, NecesitadoParaFecha
			FROM STAGING.Orden R
						INNER JOIN Dimension.Partes DP ON(DP.ID_Partes = R.ID_Parte and R.Fecha_Orden BETWEEN DP.FechaInicioValidez AND ISNULL(DP.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.Geografia DG ON(DG.ID_Geografia = R.ID_Geografia and R.Fecha_Orden BETWEEN DG.FechaInicioValidez AND ISNULL(DG.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.Descuento DD ON (DD.ID_Descuento = R.ID_Descuento and R.Fecha_Orden BETWEEN DD.FechaInicioValidez AND ISNULL(DD.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.Vehiculo DV ON (DV.VehiculoID = R.VehiculoID and R.Fecha_Orden BETWEEN DV.FechaInicioValidez AND ISNULL(DV.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.StatusOrden DSO ON (DSO.ID_StatusOrden = R.ID_StatusOrden and R.Fecha_Orden BETWEEN DSO.FechaInicioValidez AND ISNULL(DSO.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.Aseguradoras DA ON (DA.ID_Aseguradora = R.IDAseguradora and R.Fecha_Orden BETWEEN DA.FechaInicioValidez AND ISNULL(DA.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.PlantaReparacion DPR ON (DPR.IDPlantaReparacion = R.IDPlantaReparacion and R.Fecha_Orden BETWEEN DPR.FechaInicioValidez AND ISNULL(DPR.FechaFinValidez, '9999-12-31'))
						INNER JOIN Dimension.Fecha F ON(CAST((CAST(YEAR(R.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
				) AS S ON (S.ID_Orden = T.ID_Orden)

		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT (SK_Partes, SK_Geografia, SK_Vehiculo, SK_Descuento, SK_StatusOrden, SK_Aseguradoras, SK_PlantaReparacion, DateKey, FechaCreacion, UsuarioCreacion, FechaModificacion, UsuarioModificacion, ID_Orden, ID_Ciudad, ID_StatusOrden, ID_DetalleOrden, NumLinea, IDCotizacion, IDAseguradora, IDPlantaReparacion, ID_Descuento, ID_Partes, Cantidad, VehiculoID, Total_Orden, Fecha_Orden, NumeroOrden, status, TipoDocumento, FechaCreacionCotizacion, FechaModificacionCotizacion, ProcesadoPor, AseguradoraSubsidiaria, NumeroReclamo, OrdenRealizada, CotizacionRealizada, CotizacionDuplicada, procurementFolderID, DireccionEntrega1, DireccionEntrega2, MarcadoEntrega, IDPartner, CodigoPostal, LeidoPorPlantaReparacion, LeidoPorPlantaReparacionFecha, CotizacionReabierta, EsAseguradora, CodigoVerificacion, IDClientePlantaRepacion, FechaCreacionRegistro, IDRecotizacion, PartnerConfirmado, WrittenBy, SeguroValidado, FechaCaptura, Ruta, FechaLimiteRuta, TelefonoEntrega, OETipoParte, AltPartNum, AltTipoParte, ciecaTipoParte, partDescripcion, CantidadCD, PrecioListaOnRO, PrecioNetoOnRO, NecesitadoParaFecha)
		VALUES (S.SK_Partes, S.SK_Geografia,  S.SK_Vehiculo, S.SK_Descuento, S.SK_StatusOrden, S.SK_Aseguradoras, S.SK_PlantaReparacion, S.DateKey, S.FechaCreacion, S.UsuarioCreacion, S.FechaModificacion, S.UsuarioModificacion, S.ID_Orden, S.ID_Ciudad, S.ID_StatusOrden, S.ID_DetalleOrden, S.NumLinea, S.IDCotizacion, S.IDAseguradora, S.IDPlantaReparacion, S.ID_Descuento, S.ID_Partes, S.Cantidad, S.VehiculoID, S.Total_Orden, S.Fecha_Orden, S.NumeroOrden, S.status, S.TipoDocumento, S.FechaCreacionCotizacion, S.FechaModificacionCotizacion, S.ProcesadoPor, S.AseguradoraSubsidiaria, S.NumeroReclamo, S.OrdenRealizada, S.CotizacionRealizada, S.CotizacionDuplicada, S.procurementFolderID, S.DireccionEntrega1, S.DireccionEntrega2, S.MarcadoEntrega, S.IDPartner, S.CodigoPostal, S.LeidoPorPlantaReparacion, S.LeidoPorPlantaReparacionFecha, S.CotizacionReabierta, S.EsAseguradora, S.CodigoVerificacion, S.IDClientePlantaRepacion, S.FechaCreacionRegistro, S.IDRecotizacion, S.PartnerConfirmado, S.WrittenBy, S.SeguroValidado, S.FechaCaptura, S.Ruta, S.FechaLimiteRuta, S.TelefonoEntrega, S.OETipoParte, S.AltPartNum, S.AltTipoParte, S.ciecaTipoParte, S.partDescripcion, S.CantidadCD, S.PrecioListaOnRO, S.PrecioNetoOnRO, S.NecesitadoParaFecha);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM FACT.Orden
		)AS A

		UPDATE FactLog
		SET NuevosRegistros=@RowsAffected, FechaEjecucion = @MaxFechaEjecucion
		WHERE ID_Batch = @NuevoGUIDInsert

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT @@ERROR,'Ocurrio el siguiente error: '+ERROR_MESSAGE()
		IF (@@TRANCOUNT>0)
			ROLLBACK;
	END CATCH

END
go


	 
	 select *
	 from Fact.Orden




select *
from staging.Orden



select *
from Dimension.Geografia


select *
from RepuestosWeb.dbo.Pais P INNER JOIN
RepuestosWeb.dbo.Region R ON (P.ID_Pais = R.ID_Pais) INNER JOIN  
RepuestosWeb.dbo.Ciudad C ON (R.ID_Region = C.ID_Region)

select *
from Dimension.Partes

select *
from Dimension.PlantaReparacion
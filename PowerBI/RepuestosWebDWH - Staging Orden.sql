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
	[ID_Descuento] [int] NOT NULL,
	[ID_Partes] [varchar](100) NOT NULL,
	[ID_Clientes] [int] NOT NULL,
	[ID_Geografia][int] NOT NULL,
	[NombreDescuento] [varchar](300) NOT NULL,
	[PorcentajeDescuento] [decimal](6, 2) NULL,
	[Total_Orden] [decimal](12, 2) NULL,
	[Cantidad] [int] NULL,
	[NombreStatus] [varchar](300) NULL,
	[Fecha_Orden] [datetime] NULL

) ON [PRIMARY]
GO

--Query para llenar datos en Staging
SELECT O.ID_Orden,
	   DO.ID_Descuento,
	   P.ID_Parte,
	   C.ID_Cliente,
	   CU.ID_Ciudad as ID_Geografia,
	   D.NombreDescuento,
	   D.PorcentajeDescuento,
	   O.Total_Orden,
	   DO.Cantidad,
	   SO.NombreStatus,
	   O.Fecha_Orden

FROM dbo.Orden O
     INNER JOIN dbo.Detalle_orden DO ON(O.ID_Orden = DO.ID_Orden)
	 INNER JOIN dbo.Partes P ON (DO.ID_Parte = P.ID_Parte)
	 INNER JOIN dbo.StatusOrden SO ON (O.ID_StatusOrden = SO.ID_StatusOrden)
	 INNER JOIN dbo.Clientes C ON (O.ID_Cliente = C.ID_Cliente)
	 INNER JOIN dbo.Ciudad CU ON (O.ID_Ciudad = CU.ID_Ciudad)
     LEFT JOIN DBO.Descuento D ON(DO.ID_Descuento = D.ID_Descuento)
WHERE ((Fecha_Orden>?))
go

--Script de SP para MERGE
CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT

		INSERT INTO FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE Fact.Orden AS T
		USING (
			SELECT [SK_Partes], [SK_Geografia],[SK_Clientes], [DateKey], @NuevoGUIDINsert as ID_Batch, 'ssis' as ID_SourceSystem, [ID_Orden], [ID_Descuento], [NombreDescuento], [PorcentajeDescuento], [Total_Orden], [Cantidad], [NombreStatus]
			FROM STAGING.Orden R
						INNER JOIN Dimension.Partes DP ON(DP.ID_Partes = R.ID_Partes)
						INNER JOIN Dimension.Geografia DG ON(DG.ID_Geografia = R.ID_Geografia)
						INNER JOIN Dimension.Clientes DC ON(DC.ID_Cliente = R.ID_Clientes)
						INNER JOIN Dimension.Fecha F ON(CAST((CAST(YEAR(R.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
				) AS S ON (S.ID_Orden = T.ID_Orden)

		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT ([SK_Partes], [SK_Geografia],[SK_Clientes], [DateKey],  [ID_Batch], [ID_SourceSystem], [ID_Orden], [ID_Descuento], [NombreDescuento], [PorcentajeDescuento], [Total_Orden], [Cantidad], [NombreStatus])
		VALUES (S.[SK_Partes], S.[SK_Geografia], S.[SK_Clientes],S.[DateKey],  S.[ID_Batch], S.[ID_SourceSystem], S.[ID_Orden], S.[ID_Descuento], S.[NombreDescuento], S.[PorcentajeDescuento], S.[Total_Orden], S.[Cantidad], S.[NombreStatus]);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(FechaPrueba) as MaxFechaEjecucion
			FROM FACT.Orden
			UNION
			SELECT MAX(FechaModificacionSource)  as MaxFechaEjecucion
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


--Test de SCD
USE RepuestosWeb
go

INSERT INTO dbo.Orden ([ID_Cliente], [ID_Ciudad], [ID_StatusOrden], [Total_Orden], [Fecha_Orden])
values (1,1,1,getdate(),200.00,90)
go

insert into dbo.Examen_Detalle ( [ID_Examen], [ID_Materia], [NotaArea])
values (@@IDENTITY,1,90)

select *
from	RepuestosWeb_DWH.Fact.Orden e inner join
		RepuestosWeb_DWH.Dimension.Clientes c on e.SK_Clientes = c.SK_Clientes
where	c.ID_Cliente = 1


select *
from RepuestosWeb_DWH.dbo.FactLog



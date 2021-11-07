USE MASTER
GO

DECLARE @EliminarDB BIT = 1;
--Eliminar BDD si ya existe y si @EliminarDB = 1
if (((select COUNT(1) from sys.databases where name = 'RepuestosWeb_DWH')>0) AND (@EliminarDB = 1))
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'RepuestosWeb_DWH'
	
	
	use [master];
	ALTER DATABASE [RepuestosWeb_DWH] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
		
	DROP DATABASE [RepuestosWeb_DWH]
	print 'RepuestosWeb_DWH ha sido eliminada'
end

GO


CREATE DATABASE RepuestosWeb_DWH
GO

USE RepuestosWeb_DWH
GO

--Enteros
 --User Defined Type _ Surrogate Key
	--Tipo para SK entero: Surrogate Key
	CREATE TYPE [UDT_SK] FROM INT
	GO

	--Tipo para PK entero
	CREATE TYPE [UDT_PK] FROM INT
	GO

--Cadenas

	--Tipo para cadenas largas
	CREATE TYPE [UDT_VarcharLargo] FROM VARCHAR(600)
	GO

	--Tipo para cadenas medianas
	CREATE TYPE [UDT_VarcharMediano] FROM VARCHAR(300)
	GO

	--Tipo para cadenas cortas
	CREATE TYPE [UDT_VarcharCorto] FROM VARCHAR(100)
	GO

	--Tipo para cadenas cortas
	CREATE TYPE [UDT_UnCaracter] FROM CHAR(1)
	GO

--Decimal

	--Tipo Decimal 6,2
	CREATE TYPE [UDT_Decimal6.2] FROM DECIMAL(6,2)
	GO

	--Tipo Decimal 5,2
	CREATE TYPE [UDT_Decimal5.2] FROM DECIMAL(5,2)
	GO

	--Tipo INT
	CREATE TYPE [UDT_INT] FROM INT
	GO

	--Tipo Decimal 12,2
	CREATE TYPE [UDT_Decimal12.2] FROM DECIMAL(12,2)
	GO

--Fechas
	CREATE TYPE [UDT_DateTime] FROM DATETIME
	GO

--Schemas para separar objetos
	CREATE SCHEMA Fact
	GO

	CREATE SCHEMA Dimension
	GO

--------------------------------------------------------------------------------------------
-------------------------------MODELADO CONCEPTUAL------------------------------------------
--------------------------------------------------------------------------------------------
--Tablas Dimensiones

	CREATE TABLE Dimension.Partes
	(
		SK_Partes [UDT_SK] PRIMARY KEY IDENTITY,


--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	
		
	)
	GO

	CREATE TABLE Dimension.Geografia
	(
		SK_Geografia [UDT_SK] PRIMARY KEY IDENTITY,

--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	

	)
	GO

	CREATE TABLE Dimension.Clientes
	(
		SK_Clientes [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	

	

	)
	GO

	CREATE TABLE Dimension.Vehiculo
	(
		SK_Vehiculo [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacionAuditoria DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	

	)
	GO
	
	CREATE TABLE Dimension.Descuento
	(
		SK_Descuento [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	)
	GO

	CREATE TABLE Dimension.StatusOrden
	(
		SK_StatusOrden [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	)
	GO

	CREATE TABLE Dimension.Aseguradoras
	(
		SK_Aseguradoras [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	)
	GO

	CREATE TABLE Dimension.PlantaReparacion
	(
		SK_PlantaReparacion [UDT_SK] PRIMARY KEY IDENTITY,
	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	)
	GO


	CREATE TABLE Dimension.Fecha
	(
		DateKey INT PRIMARY KEY
	)
	GO

--Tablas Fact

	CREATE TABLE Fact.Orden
	(
		SK_Orden [UDT_SK] PRIMARY KEY IDENTITY,
		SK_Partes [UDT_SK] REFERENCES Dimension.Partes(SK_Partes),
		SK_Geografia [UDT_SK] REFERENCES Dimension.Geografia(SK_Geografia),
		SK_Clientes [UDT_SK] REFERENCES Dimension.Clientes(SK_Clientes),
		SK_Vehiculo [UDT_SK] REFERENCES Dimension.Vehiculo(SK_Vehiculo),
		SK_Descuento [UDT_SK] REFERENCES Dimension.Descuento(SK_Descuento), --SK_Cotizacion
		SK_StatusOrden [UDT_SK] REFERENCES Dimension.StatusOrden(SK_StatusOrden),
		SK_Aseguradoras [UDT_SK] REFERENCES Dimension.Aseguradoras(SK_Aseguradoras),
		SK_PlantaReparacion [UDT_SK] REFERENCES Dimension.PlantaReparacion(SK_PlantaReparacion),
		DateKey INT REFERENCES Dimension.Fecha(DateKey),

	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(20)	
	

	)

--Metadata

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de partes provee una vista desnormalizada de las tablas de Partes, Linea y Categoria, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Partes';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de Geografia provee una vista desnormalizada de las tablas País, Región y Ciudad, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Geografia';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de Clientes provee una vista desnormalizada de las tablas que tendrá información de los clientes, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Clientes';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de Aseguradoras provee una vista desnormalizada de la tabla de aseguradoras, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Aseguradoras';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de PlantaReparacion provee una vista desnormalizada de la tabla de PlantaReparacion, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'PlantaReparacion';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de Vehiculo provee una vista desnormalizada de las tablas que tendrá información de los vehiculos, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Vehiculo';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de Descuento provee una vista desnormalizada de la tabla Descuento, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Descuento';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension de StatusOrden provee una vista desnormalizada de la tabla de StatusOrden, dejando todo en una única dimensión para un modelo estrella', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'StatusOrden';
	GO
	
	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La dimension fecha es generada de forma automatica y no tiene datos origen, se puede regenerar enviando un rango de fechas al stored procedure USP_FillDimDate', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Fecha';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La tabla de hechos es una union proveniente de las tablas de Orden, Detalle_Orden, Cotización y CotizaciónDetalle', 
     @level0type = N'SCHEMA', 
     @level0name = N'Fact', 
     @level1type = N'TABLE', 
     @level1name = N'Orden';
	GO

--------------------------------------------------------------------------------------------
---------------------------------MODELADO LOGICO--------------------------------------------
--------------------------------------------------------------------------------------------
--Transformación en modelo lógico (mas detalles)

	--Fact
	ALTER TABLE Fact.Orden ADD ID_Orden [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_Cliente [UDT_PK]	
	ALTER TABLE Fact.Orden ADD ID_Ciudad [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_StatusOrden [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_DetalleOrden [UDT_PK]
	ALTER TABLE Fact.Orden ADD NumLinea varchar(50) NOT NULL
	ALTER TABLE Fact.Orden ADD [IDCotizacion] [UDT_PK]
	ALTER TABLE Fact.Orden ADD IDAseguradora [UDT_PK] NULL
	ALTER TABLE Fact.Orden ADD IDPlantaReparacion varchar(50) NULL
	ALTER TABLE Fact.Orden ADD ID_Descuento [UDT_PK]
	ALTER TABLE Fact.Orden ADD ID_Partes varchar(50) NOT NULL
	ALTER TABLE Fact.Orden ADD Cantidad INT NOT NULL
	ALTER TABLE Fact.Orden ADD VehiculoID [UDT_PK]
	ALTER TABLE Fact.Orden ADD Total_Orden decimal(12,2) NOT NULL
	ALTER TABLE Fact.Orden ADD [Fecha_Orden] DATETIME NULL
	ALTER TABLE Fact.Orden ADD NumeroOrden varchar(20) NULL 
	ALTER TABLE Fact.Orden ADD status varchar(50) NULL
	ALTER TABLE Fact.Orden ADD TipoDocumento varchar(50) NULL
	ALTER TABLE Fact.Orden ADD FechaCreacionCotizacion datetime NULL
	ALTER TABLE Fact.Orden ADD FechaModificacionCotizacion datetime NULL
	ALTER TABLE Fact.Orden ADD ProcesadoPor varchar(50) NULL
	ALTER TABLE Fact.Orden ADD AseguradoraSubsidiaria varchar(80) NULL
	ALTER TABLE Fact.Orden ADD NumeroReclamo varchar(50) NULL
	ALTER TABLE Fact.Orden ADD OrdenRealizada bit NULL
	ALTER TABLE Fact.Orden ADD CotizacionRealizada bit NULL
	ALTER TABLE Fact.Orden ADD CotizacionDuplicada bit NULL
	ALTER TABLE Fact.Orden ADD [procurementFolderID] varchar(50) NULL
	ALTER TABLE Fact.Orden ADD DireccionEntrega1 varchar(50) NULL
	ALTER TABLE Fact.Orden ADD DireccionEntrega2 varchar(50) NULL
	ALTER TABLE Fact.Orden ADD MarcadoEntrega bit NULL
	ALTER TABLE Fact.Orden ADD IDPartner varchar(50) NULL
	ALTER TABLE Fact.Orden ADD CodigoPostal varchar(10) NULL
	ALTER TABLE Fact.Orden ADD [LeidoPorPlantaReparacion] bit NOT NULL
	ALTER TABLE Fact.Orden ADD [LeidoPorPlantaReparacionFecha] datetime NULL
	ALTER TABLE Fact.Orden ADD CotizacionReabierta bit NULL
	ALTER TABLE Fact.Orden ADD EsAseguradora bit NULL
	ALTER TABLE Fact.Orden ADD CodigoVerificacion varchar(50) NULL
	ALTER TABLE Fact.Orden ADD IDClientePlantaRepacion varchar(50) NULL
	ALTER TABLE Fact.Orden ADD FechaCreacionRegistro datetime NOT NULL
	ALTER TABLE Fact.Orden ADD IDRecotizacion varchar(100) NULL
	ALTER TABLE Fact.Orden ADD PartnerConfirmado bit NOT NULL
	ALTER TABLE Fact.Orden ADD WrittenBy varchar(80) NULL
	ALTER TABLE Fact.Orden ADD SeguroValidado bit NOT NULL
	ALTER TABLE Fact.Orden ADD FechaCaptura datetime NULL
	ALTER TABLE Fact.Orden ADD Ruta varchar(500) NULL
	ALTER TABLE Fact.Orden ADD FechaLimiteRuta varchar(50) NULL
	ALTER TABLE Fact.Orden ADD TelefonoEntrega varchar(15) NULL
	ALTER TABLE Fact.Orden ADD [OETipoParte] varchar(10) NULL
	ALTER TABLE Fact.Orden ADD [AltPartNum] varchar(45) NULL
	ALTER TABLE Fact.Orden ADD [AltTipoParte] varchar(45) NULL
	ALTER TABLE Fact.Orden ADD [ciecaTipoParte] varchar(45) NULL
	ALTER TABLE Fact.Orden ADD [partDescripcion] varchar(255) NULL
	ALTER TABLE Fact.Orden ADD CantidadCD int NULL
	ALTER TABLE Fact.Orden ADD [PrecioListaOnRO] varchar(10) NULL
	ALTER TABLE Fact.Orden ADD [PrecioNetoOnRO] varchar(45) NULL
	ALTER TABLE Fact.Orden ADD [NecesitadoParaFecha] datetime NULL



	--DimDescuento
	ALTER TABLE Dimension.Descuento ADD ID_Descuento [UDT_PK]
	ALTER TABLE Dimension.Descuento ADD NombreDescuento varchar(200) NOT NULL
	ALTER TABLE Dimension.Descuento ADD PorcentajeDescuento decimal(2,2) NOT NULL


	--DimStatusOrden
	ALTER TABLE Dimension.StatusOrden ADD ID_StatusOrden [UDT_PK]
	ALTER TABLE Dimension.StatusOrden ADD NombreStatus varchar(100) NOT NULL

	--DimAseguradoras
	ALTER TABLE Dimension.Aseguradoras ADD ID_Aseguradora [UDT_PK]
	ALTER TABLE Dimension.Aseguradoras ADD NombreAseguradora varchar(80) NULL
	ALTER TABLE Dimension.Aseguradoras ADD RowCreatedDate datetime NULL
	ALTER TABLE Dimension.Aseguradoras ADD Activa bit NULL


	--DimPlantaReparacion

	ALTER TABLE Dimension.PlantaReparacion ADD IDPlantaReparacion varchar(50) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD CompanyNombre varchar(50) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD DireccionPlanta varchar(50) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD DireccioPlanta2 varchar(50) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD CiudadPlanta varchar(50) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD EstadoPlanta varchar(50) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD CodigoPostalPlanta varchar(10) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD PaisPlanta varchar(4) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD AlmacenKeystone varchar(3) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD LocalizadorCotizacion varchar(4) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD FechaAgregado datetime NULL
	ALTER TABLE Dimension.PlantaReparacion ADD IDEmpresa varchar(3) NOT NULL
	ALTER TABLE Dimension.PlantaReparacion ADD ValidacionSeguro bit NULL
	ALTER TABLE Dimension.PlantaReparacion ADD Activo bit NULL
	ALTER TABLE Dimension.PlantaReparacion ADD CreadoPor varchar(50) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD ActualizadoPor varchar(50) NULL
	ALTER TABLE Dimension.PlantaReparacion ADD UltimaFechaActualizacion datetime NULL




	--DimFecha	
	ALTER TABLE Dimension.Fecha ADD [Date] DATE NOT NULL
    ALTER TABLE Dimension.Fecha ADD [Day] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DaySuffix] CHAR(2) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Weekday] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName] VARCHAR(10) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName_Short] CHAR(3) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekDayName_FirstLetter] CHAR(1) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DOWInMonth] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [DayOfYear] SMALLINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekOfMonth] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [WeekOfYear] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Month] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName] VARCHAR(10) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName_Short] CHAR(3) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthName_FirstLetter] CHAR(1) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Quarter] TINYINT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [QuarterName] VARCHAR(6) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [Year] INT NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MMYYYY] CHAR(6) NOT NULL
	ALTER TABLE Dimension.Fecha ADD [MonthYear] CHAR(7) NOT NULL
    ALTER TABLE Dimension.Fecha ADD IsWeekend BIT NOT NULL
  
	--DimGeografia
	ALTER TABLE Dimension.Geografia ADD ID_Geografia [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD ID_Ciudad [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD ID_Region [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD ID_Pais [UDT_PK]
	ALTER TABLE Dimension.Geografia ADD NombreCiudad varchar(100) NOT NULL
	ALTER TABLE Dimension.Geografia ADD CodigoPostal varchar(50) NULL
	ALTER TABLE Dimension.Geografia ADD NombreRegion varchar(100) NOT NULL
	ALTER TABLE Dimension.Geografia ADD NombrePais varchar(100) NOT NULL
	
	--DimPartes
	ALTER TABLE Dimension.Partes ADD ID_Partes varchar(50) NOT NULL
	ALTER TABLE Dimension.Partes ADD ID_Categoria [UDT_PK]
	ALTER TABLE Dimension.Partes ADD ID_Linea [UDT_PK]
	ALTER TABLE Dimension.Partes ADD NombrePartes varchar(100) NOT NULL
	ALTER TABLE Dimension.Partes ADD DescripcionPartes varchar(500) NULL
	ALTER TABLE Dimension.Partes ADD Precio decimal(12,2) NOT NULL
	ALTER TABLE Dimension.Partes ADD NombreCategoria varchar(100) NULL
	ALTER TABLE Dimension.Partes ADD DescripcionCategoria varchar(500) NULL
	ALTER TABLE Dimension.Partes ADD NombreLinea varchar(100) NULL
	ALTER TABLE Dimension.Partes ADD DescripcionLinea varchar(500) NULL

	--DimClientes
	ALTER TABLE Dimension.Clientes ADD ID_Cliente [UDT_PK]
	ALTER TABLE Dimension.Clientes ADD PrimerNombre varchar(100) NOT NULL
	ALTER TABLE Dimension.Clientes ADD SegundoNombre varchar(100) NOT NULL
	ALTER TABLE Dimension.Clientes ADD PrimerApellido varchar(100) NOT NULL
	ALTER TABLE Dimension.Clientes ADD SegundoApellido varchar(100) NOT NULL
	ALTER TABLE Dimension.Clientes ADD Genero char(1) NOT NULL
	ALTER TABLE Dimension.Clientes ADD Correo_Electronico varchar(100) NULL
	ALTER TABLE Dimension.Clientes ADD FechaNacimiento datetime NULL
	ALTER TABLE Dimension.Clientes ADD Direccion varchar(1000) NULL

	
	--DimVehiculo
	ALTER TABLE Dimension.Vehiculo ADD VIN_Patron varchar(10) NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD VehiculoID [UDT_PK]
	ALTER TABLE Dimension.Vehiculo ADD Anio smallint NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD Marca varchar(24) NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD Modelo varchar(32) NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD SubModelo varchar(48) NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD Estilo varchar(128) NOT NULL
	ALTER TABLE Dimension.Vehiculo ADD FechaCreacionVehiculo datetime NULL



--Indices Columnares
	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-TotalOrden] ON [Fact].[Orden]
	(
	   [Cantidad],
	   [Total_Orden]
	)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
	GO

	create index [IndicePlantaReparacion] on [PlantaReparacion] ( [IDPlantaReparacion] ) include ( 
	CompanyNombre,
	  Direccion,
	  Direccion2,
	  Ciudad ,
	  Estado ,
	  CodigoPostal ,
	  Pais ,
	  AlmacenKeystone,
	  LocalizadorCotizacion,
	  FechaAgregado,
	  IDEmpresa ,
	  ValidacionSeguro,
	  Activo,
	  CreadoPor, 
	  ActualizadoPor, 
	  UltimaFechaActualizacion )


--Queries para llenar datos

--Dimensiones


--------------------------------------------------------------------------------------------
-----------------------CORRER CREATE de USP_FillDimDate PRIMERO!!!--------------------------
--------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_FillDimDate @CurrentDate DATE = '2016-01-01', 
                                 @EndDate     DATE = '2022-12-31'
AS
    BEGIN
        SET NOCOUNT ON;
        DELETE FROM Dimension.Fecha;

        WHILE @CurrentDate < @EndDate
            BEGIN
                INSERT INTO Dimension.Fecha
                ([DateKey], 
                 [Date], 
                 [Day], 
                 [DaySuffix], 
                 [Weekday], 
                 [WeekDayName], 
                 [WeekDayName_Short], 
                 [WeekDayName_FirstLetter], 
                 [DOWInMonth], 
                 [DayOfYear], 
                 [WeekOfMonth], 
                 [WeekOfYear], 
                 [Month], 
                 [MonthName], 
                 [MonthName_Short], 
                 [MonthName_FirstLetter], 
                 [Quarter], 
                 [QuarterName], 
                 [Year], 
                 [MMYYYY], 
                 [MonthYear], 
                 [IsWeekend]
                )
                       SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate), 
                              DATE = @CurrentDate, 
                              Day = DAY(@CurrentDate), 
                              [DaySuffix] = CASE
                                                WHEN DAY(@CurrentDate) = 1
                                                     OR DAY(@CurrentDate) = 21
                                                     OR DAY(@CurrentDate) = 31
                                                THEN 'st'
                                                WHEN DAY(@CurrentDate) = 2
                                                     OR DAY(@CurrentDate) = 22
                                                THEN 'nd'
                                                WHEN DAY(@CurrentDate) = 3
                                                     OR DAY(@CurrentDate) = 23
                                                THEN 'rd'
                                                ELSE 'th'
                                            END, 
                              WEEKDAY = DATEPART(dw, @CurrentDate), 
                              WeekDayName = DATENAME(dw, @CurrentDate), 
                              WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)), 
                              WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1), 
                              [DOWInMonth] = DAY(@CurrentDate), 
                              [DayOfYear] = DATENAME(dy, @CurrentDate), 
                              [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1, 
                              [WeekOfYear] = DATEPART(wk, @CurrentDate), 
                              [Month] = MONTH(@CurrentDate), 
                              [MonthName] = DATENAME(mm, @CurrentDate), 
                              [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)), 
                              [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1), 
                              [Quarter] = DATEPART(q, @CurrentDate), 
                              [QuarterName] = CASE
                                                  WHEN DATENAME(qq, @CurrentDate) = 1
                                                  THEN 'First'
                                                  WHEN DATENAME(qq, @CurrentDate) = 2
                                                  THEN 'second'
                                                  WHEN DATENAME(qq, @CurrentDate) = 3
                                                  THEN 'third'
                                                  WHEN DATENAME(qq, @CurrentDate) = 4
                                                  THEN 'fourth'
                                              END, 
                              [Year] = YEAR(@CurrentDate), 
                              [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)), 
                              [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)), 
                              [IsWeekend] = CASE
                                                WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
                                                     OR DATENAME(dw, @CurrentDate) = 'Saturday'
                                                THEN 1
                                                ELSE 0
                                            END     ;
                SET @CurrentDate = DATEADD(DD, 1, @CurrentDate);
            END;
    END;
go



	DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
	--Fecha
	IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
	begin
		EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							 @EndDate     = @FechaMaxima
	end
	SELECT * FROM Dimension.Fecha
	
	

--------------------------------------------------------------------------------------------
------------------------------------Resultado Final-----------------------------------------
--------------------------------------------------------------------------------------------	

	SELECT *
	FROM	Fact.Orden AS O INNER JOIN
			Dimension.Partes AS C ON o.SK_Partes = C.SK_Partes INNER JOIN
			Dimension.Geografia AS CA ON O.SK_Geografia = CA.SK_Geografia INNER JOIN
			Dimension.Clientes AS DC ON O.SK_Clientes = DC.SK_Clientes INNER JOIN
			Dimension.Fecha AS F ON O.DateKey = F.DateKey

	select *
	from Dimension.Partes

	select *
	from Dimension.PlantaReparacion

	select *
	from Fact.Orden

-----------------------------------------------------------------------------------------------------------
	
SELECT   
  IDPlantaReparacion,
	  CompanyNombre,
	  Direccion,
	  Direccion2,
	  Ciudad ,
	  Estado ,
	  CodigoPostal ,
	  Pais ,
	  AlmacenKeystone,
	  LocalizadorCotizacion,
	  FechaAgregado,
	  IDEmpresa ,
	  ValidacionSeguro,
	  Activo,
	  CreadoPor, 
	  ActualizadoPor, 
	  UltimaFechaActualizacion,
	CAST('2020-01-01' AS DATETIME) as FechaInicioValidez,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion

FROM dbo.PlantaReparacion


update statistics PlantaReparacion with fullscan


select *
from cotizacion i


select *
from Descuento




select *
from Orden O inner join 
Detalle_orden do on (O.ID_Orden = do.ID_Orden)

--Promedio de orden

sum(Total_Orden)/count(ID_Orden)

--Promedio de cotizacion

select * 
from Cotizacion C inner join 
CotizacionDetalle CD on (C.IDCotizacion = CD.IDCotizacion)

sum(Cantidad) / count(IDCotizacion)


select *
from Partes

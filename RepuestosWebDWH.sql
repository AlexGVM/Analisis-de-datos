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
		ID_Batch UNIQUEIDENTIFIER NULL,
		ID_SourceSystem VARCHAR(20),
		[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
		[FechaFinValidez] DATETIME NULL,


	--Columnas Auditoria
	FechaCreacion DATETIME NOT NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NOT NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,

	
		
	)
	GO

	CREATE TABLE Dimension.Geografia
	(
		SK_Geografia [UDT_SK] PRIMARY KEY IDENTITY,
		ID_Batch UNIQUEIDENTIFIER NULL,
		ID_SourceSystem VARCHAR(20),
		[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
		[FechaFinValidez] DATETIME NULL,
		--Columnas SCD Tipo 2

	--Columnas Auditoria
	FechaCreacion DATETIME NOT NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NOT NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje

	

	)
	GO

	CREATE TABLE Dimension.Clientes
	(
		SK_Clientes [UDT_SK] PRIMARY KEY IDENTITY,
		ID_Batch UNIQUEIDENTIFIER NULL,
		ID_SourceSystem VARCHAR(20),
		[FechaInicioValidez] DATETIME NOT NULL DEFAULT(GETDATE()),
		[FechaFinValidez] DATETIME NULL,
		--Columnas SCD Tipo 2

	--Columnas Auditoria
	FechaCreacion DATETIME NOT NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NOT NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje

	

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
		DateKey INT REFERENCES Dimension.Fecha(DateKey),

	--Columnas SCD Tipo 2
	[FechaInicioValidez] DATETIME NULL DEFAULT(GETDATE()),
	[FechaFinValidez] DATETIME NULL,
	--Columnas Auditoria
	FechaCreacion DATETIME NOT NULL DEFAULT(GETDATE()),
	UsuarioCreacion NVARCHAR(100) NOT NULL DEFAULT(SUSER_NAME()),
	FechaModificacion DATETIME NULL,
	UsuarioModificacion NVARCHAR(100) NULL,
	--Columnas Linaje
	ID_Batch UNIQUEIDENTIFIER NULL,
	ID_SourceSystem VARCHAR(50)
	

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
     @value = N'La dimension fecha es generada de forma automatica y no tiene datos origen, se puede regenerar enviando un rango de fechas al stored procedure USP_FillDimDate', 
     @level0type = N'SCHEMA', 
     @level0name = N'Dimension', 
     @level1type = N'TABLE', 
     @level1name = N'Fecha';
	GO

	EXEC sys.sp_addextendedproperty 
     @name = N'Desnormalizacion', 
     @value = N'La tabla de hechos es una union proveniente de las tablas de Orden, Detalle_Orden, Descuento y StatusOrden', 
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
	ALTER TABLE Fact.Orden ADD ID_Descuento [UDT_PK]	
	ALTER TABLE Fact.Orden ADD NombreDescuento [UDT_VarcharMediano]
	ALTER TABLE Fact.Orden ADD PorcentajeDescuento [UDT_Decimal6.2]
	ALTER TABLE Fact.Orden ADD Total_Orden [UDT_Decimal12.2]
	ALTER TABLE Fact.Orden ADD Cantidad [UDT_INT]
	ALTER TABLE Fact.Orden ADD NombreStatus [UDT_VarcharMediano]
	ALTER TABLE Fact.Orden ADD [Fecha_Orden] DATETIME NULL

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
	ALTER TABLE Dimension.Geografia ADD NombreCiudad [UDT_VarcharMediano]
	ALTER TABLE Dimension.Geografia ADD CodigoPostal [UDT_INT]
	ALTER TABLE Dimension.Geografia ADD NombreRegion [UDT_VarcharMediano]
	ALTER TABLE Dimension.Geografia ADD NombrePais [UDT_VarcharMediano]
	
	--DimPartes
	ALTER TABLE Dimension.Partes ADD ID_Partes [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD ID_Categoria [UDT_PK]
	ALTER TABLE Dimension.Partes ADD ID_Linea [UDT_PK]
	ALTER TABLE Dimension.Partes ADD NombrePartes [UDT_VarcharCorto]
	ALTER TABLE Dimension.Partes ADD DescripcionPartes [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD PrecioPartes [UDT_Decimal6.2]
	ALTER TABLE Dimension.Partes ADD NombreCategoria [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD DescripcionCategoria [UDT_Varcharlargo]
	ALTER TABLE Dimension.Partes ADD NombreLinea [UDT_VarcharMediano]
	ALTER TABLE Dimension.Partes ADD DescripcionLinea [UDT_Varcharlargo]
		

	--DimClientes
	ALTER TABLE Dimension.Clientes ADD ID_Cliente [UDT_PK]
	ALTER TABLE Dimension.Clientes ADD PrimerNombre [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes ADD SegundoNombre [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes ADD PrimerApellido [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes ADD SegundoApellido [UDT_VarcharMediano]
	ALTER TABLE Dimension.Clientes ADD Genero [UDT_UnCaracter]
	ALTER TABLE Dimension.Clientes ADD Correo_Electronico [UDT_Varcharlargo]
	ALTER TABLE Dimension.Clientes ADD FechaNacimiento [UDT_DateTime]


--Indices Columnares
	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-TotalOrden] ON [Fact].[Orden]
	(
	   [Cantidad],
	   [Total_Orden]
	)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
	GO

--Queries para llenar datos

--Dimensiones

	--DimPartes
	INSERT INTO Dimension.Partes
	(ID_Partes, 
	 ID_Categoria, 
	 ID_Linea, 
	 NombrePartes,
	 DescripcionPartes,
	 PrecioPartes,
	 NombreCategoria,
	 DescripcionCategoria,
	 NombreLinea,
	 DescripcionLinea,
	 [FechaInicioValidez],
	 ID_Batch,
	 ID_SourceSystem
	)
	SELECT P.ID_Partes, 
			C.ID_Categoria, 
			L.ID_Linea, 
			P.NombrePartes,
			P.DescripcionPartes,
			P.Precio,
			C.NombreCategoria,
			C.DescripcionCategoria,
			L.NombreLinea,
			L.DescripcionLinea,
			CAST('2020-01-01' AS DATETIME) AS FechaInicioValidez,
			NULL as ID_Batch,
			'RepuestosWeb' as ID_SourceSystem
	FROM RepuestosWeb.dbo.Partes P
		INNER JOIN RepuestosWeb.dbo.Categoria C ON(P.ID_Categoria = C.ID_Categoria)
		INNER JOIN RepuestosWeb.dbo.Linea L ON (C.ID_Linea = L.ID_Linea);
	
	SELECT * FROM Dimension.Partes

	--DimGeografia
	INSERT INTO Dimension.Geografia
	([ID_Geografia],
	 [ID_Ciudad], 
	 [ID_Region], 
	 [ID_Pais], 
	 [NombreCiudad], 
	 [CodigoPostal], 
	 [NombreRegion], 
	 [NombrePais],
	 [FechaInicioValidez],
	 ID_Batch,
	 ID_SourceSystem
	)
	SELECT  C.ID_Ciudad as IDGeografia,
			C.ID_Ciudad,
			R.ID_Region,
			P.ID_Pais,
			C.Nombre as NombreCiudad,
			C.CodigoPostal,
			R.Nombre as NombreRegion,
			P.Nombre as NombrePais,
			CAST('2020-01-01' AS DATETIME) AS FechaInicioValidez,
			NULL as ID_Batch,
			'RepuestosWeb' as ID_SourceSystem
	FROM RepuestosWeb.dbo.Ciudad C
		INNER JOIN RepuestosWeb.dbo.Region R ON(C.ID_Region = R.ID_Region)
		INNER JOIN RepuestosWeb.dbo.Pais P ON(R.ID_Pais = P.ID_Pais);

		SELECT * FROM Dimension.Geografia


	--DimClientes
	INSERT INTO Dimension.Clientes
	(ID_Cliente, 
	 PrimerNombre, 
	 SegundoNombre, 
	 PrimerApellido,
	 SegundoApellido,
	 Genero,
	 Correo_Electronico,
	 FechaNacimiento,
	 [FechaInicioValidez],
	 ID_Batch,
	 ID_SourceSystem
	)
	SELECT C.ID_Cliente, 
			C.PrimerNombre, 
			C.SegundoNombre, 
			C.PrimerApellido,
			C.SegundoApellido,
			C.Genero,
			C.Correo_Electronico,
			C.FechaNacimiento,
			CAST('2020-01-01' AS DATETIME) AS FechaInicioValidez,
			NULL as ID_Batch,
			'RepuestosWeb' as ID_SourceSystem
	FROM RepuestosWeb.dbo.Clientes C
	
	SELECT * FROM Dimension.Clientes

--------------------------------------------------------------------------------------------
-----------------------CORRER CREATE de USP_FillDimDate PRIMERO!!!--------------------------
--------------------------------------------------------------------------------------------

	DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
	--Fecha
	IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
	begin
		EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							 @EndDate     = @FechaMaxima
	end
	SELECT * FROM Dimension.Fecha
	
	--FactOrden
	INSERT INTO [Fact].[Orden]
	([SK_Partes], 
	 [SK_Geografia],
	 [SK_Clientes],
	 [DateKey], 
	 [FechaCreacion],
	 [UsuarioCreacion],
	 [FechaModificacion],
	 [UsuarioModificacion],
	 [ID_Orden], 
	 [ID_Descuento], 	
	 [NombreDescuento], 
	 [PorcentajeDescuento], 
	 [Total_Orden], 
	 [Cantidad],  
	 [NombreStatus],
	 [ID_Batch],
	 [ID_SourceSystem]
	)

	SELECT  --Columnas de mis dimensiones en DWH
			DP.SK_Partes, 
			DG.SK_Geografia,
			DC.SK_Clientes,
			F.DateKey, 
			getdate() as FechaCreacion,
			SUSER_NAME() as UsuarioCreacion,
			NULL as FechaModificacion,
			NULL as UsuarioModificacion,
			O.ID_Orden, 
			D.ID_Descuento, 			
			D.NombreDescuento, 
			D.PorcentajeDescuento, 
			O.Total_Orden, 
			Do.Cantidad,
			SO.NombreStatus,
			 --Columnas Linaje
			NULL as ID_Batch,
			'RepuestosWeb' as ID_SourceSystem
				 
	FROM RepuestosWeb.dbo.Orden O
		INNER JOIN RepuestosWeb.dbo.StatusOrden SO ON(O.ID_StatusOrden = SO.ID_StatusOrden)
		INNER JOIN RepuestosWeb.dbo.Detalle_orden DO ON(O.ID_Orden = DO.ID_Orden)
		INNER JOIN RepuestosWeb.dbo.Descuento D ON(D.ID_Descuento = DO.ID_Descuento)
		INNER JOIN RepuestosWeb.dbo.Ciudad C ON(O.ID_Ciudad = C.ID_Ciudad)
		INNER JOIN RepuestosWeb.dbo.Region R ON(C.ID_Region = R.ID_Region)
		INNER JOIN RepuestosWeb.dbo.Pais P ON(R.ID_Pais = P.ID_Pais)
		INNER JOIN RepuestosWeb.dbo.Partes PA ON(DO.ID_Parte = PA.ID_Parte)

		--Referencias a DWH
		INNER JOIN Dimension.Partes DP ON(DP.ID_Partes = PA.ID_Parte )
											
		INNER JOIN Dimension.Geografia DG ON(DG.ID_Geografia = C.ID_Ciudad  )
		INNER JOIN Dimension.Clientes DC ON(DC.ID_Cliente = O.ID_Cliente)
		INNER JOIN Dimension.Fecha F ON(CAST((CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey);

		/*

			SELECT  --Columnas de mis dimensiones en DWH
			DP.SK_Partes, 
			DG.SK_Geografia,
			DC.SK_Clientes,
			F.DateKey, 
			getdate() as FechaCreacion,
			'ETL' as UsuarioCreacion,
			NULL as FechaModificacion,
			NULL as UsuarioModificacion,
			O.ID_Orden, 
			D.ID_Descuento, 			
			D.NombreDescuento, 
			D.PorcentajeDescuento, 
			O.Total_Orden, 
			Do.Cantidad,
			SO.NombreStatus,
			 --Columnas Linaje
			NULL as ID_Batch,
			'RepuestosWeb' as ID_SourceSystem
				 
	FROM RepuestosWeb.dbo.Orden O
		INNER JOIN RepuestosWeb.dbo.StatusOrden SO ON(O.ID_StatusOrden = SO.ID_StatusOrden)
		INNER JOIN RepuestosWeb.dbo.Detalle_orden DO ON(O.ID_Orden = DO.ID_Orden)
		INNER JOIN RepuestosWeb.dbo.Descuento D ON(D.ID_Descuento = DO.ID_Descuento)
		INNER JOIN RepuestosWeb.dbo.Ciudad C ON(O.ID_Ciudad = C.ID_Ciudad)
		INNER JOIN RepuestosWeb.dbo.Region R ON(C.ID_Region = R.ID_Region)
		INNER JOIN RepuestosWeb.dbo.Pais P ON(R.ID_Pais = P.ID_Pais)
		INNER JOIN RepuestosWeb.dbo.Partes PA ON(DO.ID_Parte = PA.ID_Parte)

		--Referencias a DWH
		INNER JOIN Dimension.Partes DP ON(DP.ID_Partes = PA.ID_Parte and
											O.Fecha_Orden BETWEEN DP.FechaInicioValidez AND ISNULL(DP.FechaFinValidez, '9999-12-31'))
		INNER JOIN Dimension.Geografia DG ON(DG.ID_Geografia = C.ID_Ciudad  and
											O.Fecha_Orden BETWEEN DG.FechaInicioValidez AND ISNULL(DG.FechaFinValidez, '9999-12-31'))
		INNER JOIN Dimension.Clientes DC ON(DC.ID_Cliente = O.ID_Cliente  and
											O.Fecha_Orden BETWEEN DC.FechaInicioValidez AND ISNULL(DC.FechaFinValidez, '9999-12-31'))
		INNER JOIN Dimension.Fecha F ON(CAST((CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey);

		*/
	
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
	from Fact.Orden
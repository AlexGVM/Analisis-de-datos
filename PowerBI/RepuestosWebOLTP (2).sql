USE MASTER
GO

DECLARE @EliminarDB BIT = 1;
--Eliminar BDD si ya existe y si @EliminarDB = 1
if (((select COUNT(1) from sys.databases where name = 'RepuestosWeb1')>0) AND (@EliminarDB = 1))
begin
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'RepuestosWeb1'
	
	
	use [master];
	ALTER DATABASE [RepuestosWeb1] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
		
	DROP DATABASE [RepuestosWeb1]
	print 'RepuestosWeb1 ha sido eliminada'
end

	
GO


CREATE DATABASE RepuestosWeb1
go

USE RepuestosWeb1
go

exec sp_changedbowner 'sa'
go

CREATE TABLE Linea 
(
	ID_Linea  INT IDENTITY PRIMARY KEY,
	NombreLinea VARCHAR(100),
	DescripcionLinea VARCHAR(500)
)

INSERT INTO Linea
	(
	NombreLinea,
	DescripcionLinea
	)
	SELECT L.Nombre,L.Descripcion
	FROM RepuestosWeb.dbo.Linea L
			
	


CREATE TABLE Categoria
(
	ID_Categoria  INT IDENTITY PRIMARY KEY,
	ID_Linea INT REFERENCES Linea (ID_Linea),
	NombreCategoria VARCHAR(100),
	DescripcionCategoria VARCHAR(500)
)

INSERT INTO Categoria
	(
	ID_Linea,
	NombreCategoria,
	DescripcionCategoria
	)
	SELECT C.ID_Linea,C.Nombre,C.Descripcion
	FROM RepuestosWeb.dbo.Categoria C


CREATE TABLE Partes
(
	ID_Partes INT IDENTITY PRIMARY KEY,
	ID_Categoria INT NOT NULL REFERENCES Categoria(ID_Categoria),
	NombrePartes VARCHAR(100) NOT NULL,
	DescripcionPartes VARCHAR(500) NULL,
	Precio Decimal(12,2) NOT NULL
)

INSERT INTO Partes
	(ID_Categoria,
	NombrePartes,
	DescripcionPartes,
	Precio
	)
	SELECT P.ID_Categoria,P.Nombre,P.Descripcion,P.Precio
	FROM RepuestosWeb.dbo.Partes P

CREATE TABLE Clientes
(
	ID_Cliente  INT IDENTITY PRIMARY KEY,
	PrimerNombre VARCHAR(100) NOT NULL,
	SegundoNombre VARCHAR(100) NOT NULL,
	PrimerApellido VARCHAR(100) NOT NULL,
	SegundoApellido VARCHAR(100) NOT NULL,
	Genero CHAR(1) NOT NULL,
	Correo_Electronico VARCHAR(100) NULL,
	FechaNacimiento DATETIME
)

INSERT INTO Clientes
	(
	PrimerNombre,
	SegundoNombre,
	PrimerApellido,
	SegundoApellido,
	Genero,
	Correo_Electronico,
	FechaNacimiento
	)
	SELECT C.PrimerNombre,C.SegundoNombre,C.PrimerApellido,C.SegundoApellido,C.Genero,C.Correo_Electronico,C.FechaNacimiento
	FROM RepuestosWeb.dbo.Clientes C

CREATE TABLE Pais
(
	ID_Pais  INT IDENTITY PRIMARY KEY,
	Nombre	VARCHAR(100) NOT NULL
)

INSERT INTO Pais
	(
	Nombre
	)
	SELECT P.Nombre 
	FROM RepuestosWeb.dbo.Pais P

CREATE TABLE Region
(
	ID_Region  INT IDENTITY PRIMARY KEY,
	ID_Pais INT NOT NULL REFERENCES Pais(ID_Pais),
	Nombre VARCHAR(100) NOT NULL
)

INSERT INTO Region
	(
	ID_Pais,
	Nombre
	)
	SELECT R.ID_Pais, R.Nombre 
	FROM RepuestosWeb.dbo.Region R

CREATE TABLE Ciudad
(
	ID_Ciudad  INT IDENTITY PRIMARY KEY,
	ID_Region INT NOT NULL REFERENCES Region(ID_Region),
	Nombre VARCHAR(100) NOT NULL,
	CodigoPostal INT
)

INSERT INTO Ciudad
	(
	ID_Region,
	Nombre,
	CodigoPostal
	)
	SELECT C.ID_Region,C.Nombre,C.CodigoPostal
	FROM RepuestosWeb.dbo.Ciudad C

CREATE TABLE StatusOrden
(
	ID_StatusOrden INT IDENTITY PRIMARY KEY,
	NombreStatus VARCHAR(100) NOT NULL
)

INSERT INTO StatusOrden
	(
	NombreStatus
	)
	SELECT so.NombreStatus 
	FROM RepuestosWeb.dbo.StatusOrden SO


CREATE TABLE Orden
(
	ID_Orden INT IDENTITY PRIMARY KEY,
	ID_Cliente INT NULL REFERENCES Clientes(ID_Cliente),
	ID_Ciudad INT NOT NULL REFERENCES Ciudad(ID_Ciudad),
	ID_StatusOrden INT NOT NULL REFERENCES StatusOrden(ID_StatusOrden),
	Total_Orden DECIMAL(12,2) NOT NULL,
	Fecha_Orden DATETIME NOT NULL,

)

INSERT INTO Orden
	(
	ID_Cliente,
	ID_Ciudad,
	ID_StatusOrden,
	Total_Orden,
	Fecha_Orden
	)
	SELECT O.ID_Cliente,O.ID_Ciudad,O.ID_StatusOrden, O.Total_Orden,O.Fecha_Orden
	FROM RepuestosWeb.dbo.Orden O


CREATE TABLE Descuento
(
	ID_Descuento INT IDENTITY PRIMARY KEY,
	NombreDescuento VARCHAR(200) NOT NULL,
	PorcentajeDescuento DECIMAL(2,2) NOT NULL
)

INSERT INTO Descuento
	(
	NombreDescuento,
	PorcentajeDescuento
	)
	SELECT d.NombreDescuento,d.PorcentajeDescuento
	FROM RepuestosWeb.dbo.Descuento D

CREATE TABLE Detalle_orden
(
	ID_DetalleOrden INT  PRIMARY KEY,
	ID_Orden INT REFERENCES Orden(ID_orden),
	ID_Partes INT REFERENCES Partes(ID_Partes),
	ID_Descuento INT REFERENCES Descuento(ID_Descuento),
	Cantidad INT NOT NULL
)

INSERT INTO Detalle_orden
	(
	ID_Orden,
	ID_Partes,
	ID_Descuento,
	Cantidad
	)
	SELECT DO.ID_Orden,DO.ID_Parte,DO.ID_Descuento, DO.Cantidad
	FROM RepuestosWeb.dbo.Detalle_orden DO


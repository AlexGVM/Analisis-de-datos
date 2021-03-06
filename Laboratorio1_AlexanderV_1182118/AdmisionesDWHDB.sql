USE [master]
GO
/****** Object:  Database [Admisiones_DWH]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE DATABASE [Admisiones_DWH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Admisiones_DWH', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.AD2C2021\MSSQL\DATA\Admisiones_DWH.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Admisiones_DWH_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.AD2C2021\MSSQL\DATA\Admisiones_DWH_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Admisiones_DWH] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Admisiones_DWH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Admisiones_DWH] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET ARITHABORT OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Admisiones_DWH] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Admisiones_DWH] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Admisiones_DWH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Admisiones_DWH] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET RECOVERY FULL 
GO
ALTER DATABASE [Admisiones_DWH] SET  MULTI_USER 
GO
ALTER DATABASE [Admisiones_DWH] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Admisiones_DWH] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Admisiones_DWH] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Admisiones_DWH] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Admisiones_DWH] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Admisiones_DWH] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Admisiones_DWH', N'ON'
GO
ALTER DATABASE [Admisiones_DWH] SET QUERY_STORE = OFF
GO
USE [Admisiones_DWH]
GO
/****** Object:  Schema [Dimension]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE SCHEMA [Dimension]
GO
/****** Object:  Schema [Fact]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE SCHEMA [Fact]
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_DateTime]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_DateTime] FROM [datetime] NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_Decimal5.2]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_Decimal5.2] FROM [decimal](5, 2) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_Decimal6.2]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_Decimal6.2] FROM [decimal](6, 2) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_PK]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_PK] FROM [int] NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_SK]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_SK] FROM [int] NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_UnCaracter]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_UnCaracter] FROM [char](1) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_VarcharCorto]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_VarcharCorto] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_VarcharLargo]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_VarcharLargo] FROM [varchar](600) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[UDT_VarcharMediano]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE TYPE [dbo].[UDT_VarcharMediano] FROM [varchar](300) NULL
GO
/****** Object:  Table [Dimension].[Candidato]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Candidato](
	[SK_Candidato] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[ID_Candidato] [dbo].[UDT_PK] NULL,
	[ID_Colegio] [dbo].[UDT_PK] NULL,
	[ID_Diversificado] [dbo].[UDT_PK] NULL,
	[NombreCandidato] [dbo].[UDT_VarcharCorto] NULL,
	[ApellidoCandidato] [dbo].[UDT_VarcharCorto] NULL,
	[Genero] [dbo].[UDT_UnCaracter] NULL,
	[FechaNacimiento] [dbo].[UDT_DateTime] NULL,
	[NombreColegio] [dbo].[UDT_VarcharLargo] NULL,
	[NombreDiversificado] [dbo].[UDT_VarcharLargo] NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Candidato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Carrera]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Carrera](
	[SK_Carrera] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[ID_Carrera] [dbo].[UDT_PK] NULL,
	[ID_Facultad] [dbo].[UDT_PK] NULL,
	[NombreCarrera] [dbo].[UDT_VarcharMediano] NULL,
	[NombreFacultad] [dbo].[UDT_VarcharMediano] NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Carrera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Descuento]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Descuento](
	[SK_Descuento] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[ID_Descuento] [dbo].[UDT_PK] NULL,
	[DescripcionDescuento] [dbo].[UDT_VarcharMediano] NULL,
	[PorcentajeDescuento] [dbo].[UDT_Decimal6.2] NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Descuento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Fecha]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Fecha](
	[DateKey] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [char](2) NOT NULL,
	[Weekday] [tinyint] NOT NULL,
	[WeekDayName] [varchar](10) NOT NULL,
	[WeekDayName_Short] [char](3) NOT NULL,
	[WeekDayName_FirstLetter] [char](1) NOT NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [smallint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[MonthName_Short] [char](3) NOT NULL,
	[MonthName_FirstLetter] [char](1) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [int] NOT NULL,
	[MMYYYY] [char](6) NOT NULL,
	[MonthYear] [char](7) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Dimension].[Materia]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Materia](
	[SK_Materia] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[ID_Materia] [dbo].[UDT_PK] NULL,
	[NombreMateria] [dbo].[UDT_VarcharMediano] NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Materia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Fact].[Examen]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Examen](
	[SK_Examen] [dbo].[UDT_SK] IDENTITY(1,1) NOT NULL,
	[SK_Candidato] [dbo].[UDT_SK] NULL,
	[SK_Carrera] [dbo].[UDT_SK] NULL,
	[SK_Materia] [dbo].[UDT_SK] NULL,
	[SK_Descuento] [dbo].[UDT_SK] NULL,
	[DateKey] [int] NULL,
	[ID_Examen] [dbo].[UDT_PK] NULL,
	[Precio] [dbo].[UDT_Decimal6.2] NULL,
	[NotaTotal] [dbo].[UDT_Decimal5.2] NULL,
	[NotaArea] [dbo].[UDT_Decimal5.2] NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [NCCS-Precio]    Script Date: 8/31/2021 4:46:18 PM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-Precio] ON [Fact].[Examen]
(
	[Precio],
	[NotaTotal]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO
ALTER TABLE [Fact].[Examen]  WITH CHECK ADD FOREIGN KEY([DateKey])
REFERENCES [Dimension].[Fecha] ([DateKey])
GO
ALTER TABLE [Fact].[Examen]  WITH CHECK ADD FOREIGN KEY([SK_Candidato])
REFERENCES [Dimension].[Candidato] ([SK_Candidato])
GO
ALTER TABLE [Fact].[Examen]  WITH CHECK ADD FOREIGN KEY([SK_Carrera])
REFERENCES [Dimension].[Carrera] ([SK_Carrera])
GO
ALTER TABLE [Fact].[Examen]  WITH CHECK ADD FOREIGN KEY([SK_Descuento])
REFERENCES [Dimension].[Descuento] ([SK_Descuento])
GO
ALTER TABLE [Fact].[Examen]  WITH CHECK ADD FOREIGN KEY([SK_Materia])
REFERENCES [Dimension].[Materia] ([SK_Materia])
GO
/****** Object:  StoredProcedure [dbo].[USP_FillDimDate]    Script Date: 8/31/2021 4:46:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_FillDimDate] @CurrentDate DATE = '2016-01-01', 
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

GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La dimension candidato provee una vista desnormalizada de las tablas origen Candidato, Diversificado y Colegio, dejando todo en una única dimensión para un modelo estrella' , @level0type=N'SCHEMA',@level0name=N'Dimension', @level1type=N'TABLE',@level1name=N'Candidato'
GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La dimension carrera provee una vista desnormalizada de las tablas origen Facultad y Carrera en una sola dimensión para un modelo estrella' , @level0type=N'SCHEMA',@level0name=N'Dimension', @level1type=N'TABLE',@level1name=N'Carrera'
GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La tabla de descuento del examen' , @level0type=N'SCHEMA',@level0name=N'Dimension', @level1type=N'TABLE',@level1name=N'Descuento'
GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La dimension fecha es generada de forma automatica y no tiene datos origen, se puede regenerar enviando un rango de fechas al stored procedure USP_FillDimDate' , @level0type=N'SCHEMA',@level0name=N'Dimension', @level1type=N'TABLE',@level1name=N'Fecha'
GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La tabla de materia en la cual consistia el examen' , @level0type=N'SCHEMA',@level0name=N'Dimension', @level1type=N'TABLE',@level1name=N'Materia'
GO
EXEC sys.sp_addextendedproperty @name=N'Desnormalizacion', @value=N'La tabla de hechos es una union proveniente de las tablas de Examen, Examen Detalle' , @level0type=N'SCHEMA',@level0name=N'Fact', @level1type=N'TABLE',@level1name=N'Examen'
GO
USE [master]
GO
ALTER DATABASE [Admisiones_DWH] SET  READ_WRITE 
GO

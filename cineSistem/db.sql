USE [master]
GO
/****** Object:  Database [cineSistem]    Script Date: 6/09/2023 12:02:46 p. m. ******/
CREATE DATABASE [cineSistem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'cineSistem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\cineSistem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'cineSistem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\cineSistem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [cineSistem] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cineSistem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [cineSistem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cineSistem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cineSistem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cineSistem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cineSistem] SET ARITHABORT OFF 
GO
ALTER DATABASE [cineSistem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [cineSistem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cineSistem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cineSistem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cineSistem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [cineSistem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cineSistem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cineSistem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cineSistem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cineSistem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [cineSistem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cineSistem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cineSistem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [cineSistem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [cineSistem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cineSistem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [cineSistem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [cineSistem] SET RECOVERY FULL 
GO
ALTER DATABASE [cineSistem] SET  MULTI_USER 
GO
ALTER DATABASE [cineSistem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [cineSistem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [cineSistem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [cineSistem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [cineSistem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [cineSistem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'cineSistem', N'ON'
GO
ALTER DATABASE [cineSistem] SET QUERY_STORE = ON
GO
ALTER DATABASE [cineSistem] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [cineSistem]
GO
/****** Object:  Table [dbo].[pelicula]    Script Date: 6/09/2023 12:02:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pelicula](
	[idPel] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NULL,
	[descripcion] [varchar](250) NULL,
	[director] [varchar](50) NULL,
	[genero] [varchar](100) NULL,
	[imagen] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[idPel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rankingPelicula]    Script Date: 6/09/2023 12:02:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rankingPelicula](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[idPel] [int] NOT NULL,
	[ranking] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[rankingPelicula]  WITH CHECK ADD  CONSTRAINT [FK_peliculaRank] FOREIGN KEY([idPel])
REFERENCES [dbo].[pelicula] ([idPel])
GO
ALTER TABLE [dbo].[rankingPelicula] CHECK CONSTRAINT [FK_peliculaRank]
GO
/****** Object:  StoredProcedure [dbo].[sp_crearRank]    Script Date: 6/09/2023 12:02:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_crearRank](
@idPel int,
@ranking int

)
AS
BEGIN
	INSERT INTO rankingPelicula (idPel,ranking) VALUES (@idPel,@ranking)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_crearUsuario]    Script Date: 6/09/2023 12:02:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_crearUsuario](
@email varchar(100),
@password varchar(200),
@nombre varchar(100),
@registrado bit output,
@mensaje varchar(100) output
)
AS
BEGIN
	if(not exists(SELECT * FROM usuario WHERE email = @email))
	BEGIN
		INSERT INTO usuario(email,password,nombre) values (@email,@password,@nombre)
		SET @registrado =1 
		SET @mensaje = 'Usuario registrado'
	END
	else
	BEGIN
		SET @registrado = 0
		SET @mensaje = 'Email ya existe'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_validarUsuario]    Script Date: 6/09/2023 12:02:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_validarUsuario](
@email varchar(100),
@password varchar(200)
)
AS
BEGIN
	if(exists(SELECT * FROM usuario WHERE email = @email AND password = @password))
		SELECT idUser FROM usuario WHERE email = @email AND password = @password
	else
		select '0'
END
GO
USE [master]
GO
ALTER DATABASE [cineSistem] SET  READ_WRITE 
GO

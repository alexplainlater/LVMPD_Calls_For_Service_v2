USE master
--=============================================================================
-- Set up the staging and ETL databases for the LVMPD Crime project
-- Using default settings for database creation.  Can customize more if necessary
-- *** WILL DROP DATABASES IF THEY ALREADY EXIST ***
-- The way it is currently set up, will create the databases:
--		LVMPD_Crime_ETL
--		LVMPD_Crime_Staging
--		LVMPD_Crime_FF
--		LVMPD_Crime_Geographies
--		LVMPD_Crime_DW
--=============================================================================
DECLARE @log_message VARCHAR(MAX)
DECLARE @ProjectName VARCHAR(255)
DECLARE @DatabaseName VARCHAR(255)
DECLARE @SQL VARCHAR(MAX)
DECLARE @SQL2 VARCHAR(MAX)

SET @ProjectName = 'LVMPD_Crime' --++ Adjust name of project here

--=============================================================================
-- Start message for setting up the databases for this project
--=============================================================================
SET @log_message = '*** Starting the database setup process at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

--=============================================================================
-- Create the ETL database
-- This database will hold all of the ETL metadata that will keep track of which
-- files have been loaded and which files still need to be loaded, how to load
-- them, and the stored procedures that will load the raw files into the database.
--=============================================================================
SET @DatabaseName = @ProjectName + '_ETL'

SET @log_message = 'Creating the ETL database: ' + @DatabaseName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
BEGIN
	PRINT 'Database [' + @DatabaseName + '] exists. Dropping it to ensure a fresh start...'
	SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
	EXEC( @SQL )
	
	SET @SQL = 'DROP DATABASE [' + @DatabaseName + ']'
	EXEC( @SQL )
	
	PRINT 'Database [' + @DatabaseName + '] dropped.'
END

PRINT 'Creating database [' + @DatabaseName + ']...'
SET @SQL = 'CREATE DATABASE [' + @DatabaseName + ']'

EXEC( @SQL )
PRINT 'Database [' + @DatabaseName + '] created successfully.'

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
	PRINT 'Verification: Database [' + @DatabaseName + '] now exists.'
ELSE
	PRINT 'Verification: Creation of [' + @DatabaseName + '] failed.'

--=============================================================================
-- Create the staging database
-- This is where the raw files will be initially loaded into SQL.
--=============================================================================
SET @DatabaseName = @ProjectName + '_Staging'

SET @log_message = 'Creating the staging database: ' + @DatabaseName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
BEGIN
	PRINT 'Database [' + @DatabaseName + '] exists. Dropping it to ensure a fresh start...'
	SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
	EXEC( @SQL )
	
	SET @SQL = 'DROP DATABASE [' + @DatabaseName + ']'
	EXEC( @SQL )
	
	PRINT 'Database [' + @DatabaseName + '] dropped.'
END

PRINT 'Creating database [' + @DatabaseName + ']...'
SET @SQL = 'CREATE DATABASE [' + @DatabaseName + ']'

EXEC( @SQL )
PRINT 'Database [' + @DatabaseName + '] created successfully.'

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
	PRINT 'Verification: Database [' + @DatabaseName + '] now exists.'
ELSE
	PRINT 'Verification: Creation of [' + @DatabaseName + '] failed.'

--=============================================================================
-- Create the FF database
-- This is where the raw files are combined into one table for each feed.
--=============================================================================
SET @DatabaseName = @ProjectName + '_FF'

SET @log_message = 'Creating the FF database: ' + @DatabaseName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
BEGIN
	PRINT 'Database [' + @DatabaseName + '] exists. Dropping it to ensure a fresh start...'
	SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
	EXEC( @SQL )
	
	SET @SQL = 'DROP DATABASE [' + @DatabaseName + ']'
	EXEC( @SQL )
	
	PRINT 'Database [' + @DatabaseName + '] dropped.'
END

PRINT 'Creating database [' + @DatabaseName + ']...'
SET @SQL = 'CREATE DATABASE [' + @DatabaseName + ']'

EXEC( @SQL )
PRINT 'Database [' + @DatabaseName + '] created successfully.'

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
	PRINT 'Verification: Database [' + @DatabaseName + '] now exists.'
ELSE
	PRINT 'Verification: Creation of [' + @DatabaseName + '] failed.'

--=============================================================================
-- Create the Geographies database
-- This is where the geography data will be loaded.  These geographies will be
-- boundaries for areas like sectors and command areas along with census 
-- geographies that will be used in this project.
--=============================================================================
SET @DatabaseName = @ProjectName + '_Geographies'

SET @log_message = 'Creating the Geographies database: ' + @DatabaseName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
BEGIN
	PRINT 'Database [' + @DatabaseName + '] exists. Dropping it to ensure a fresh start...'
	SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
	EXEC( @SQL )
	
	SET @SQL = 'DROP DATABASE [' + @DatabaseName + ']'
	EXEC( @SQL )
	
	PRINT 'Database [' + @DatabaseName + '] dropped.'
END

PRINT 'Creating database [' + @DatabaseName + ']...'
SET @SQL = 'CREATE DATABASE [' + @DatabaseName + ']'

EXEC( @SQL )
PRINT 'Database [' + @DatabaseName + '] created successfully.'

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
	PRINT 'Verification: Database [' + @DatabaseName + '] now exists.'
ELSE
	PRINT 'Verification: Creation of [' + @DatabaseName + '] failed.'

--=============================================================================
-- Create the DW database
-- This is where the data will be cleaned and combined to be used in reporting
-- and analysis (data marts).  Will include any lookup meta data to be used in 
-- the project.
--=============================================================================
SET @DatabaseName = @ProjectName + '_DW'

SET @log_message = 'Creating the DW database: ' + @DatabaseName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
BEGIN
	PRINT 'Database [' + @DatabaseName + '] exists. Dropping it to ensure a fresh start...'
	SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
	EXEC( @SQL )
	
	SET @SQL = 'DROP DATABASE [' + @DatabaseName + ']'
	EXEC( @SQL )
	
	PRINT 'Database [' + @DatabaseName + '] dropped.'
END

PRINT 'Creating database [' + @DatabaseName + ']...'
SET @SQL = 'CREATE DATABASE [' + @DatabaseName + ']'

EXEC( @SQL )
PRINT 'Database [' + @DatabaseName + '] created successfully.'

IF EXISTS( SELECT name FROM sys.databases WHERE name = @DatabaseName )
	PRINT 'Verification: Database [' + @DatabaseName + '] now exists.'
ELSE
	PRINT 'Verification: Creation of [' + @DatabaseName + '] failed.'

--=============================================================================
-- Finished setting up databases
--=============================================================================
SET @log_message = '*** Finished the database setup process at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

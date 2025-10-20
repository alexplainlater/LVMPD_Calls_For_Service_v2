--=============================================================================
-- Create ETL metadata tables:
--		LVMPD_Crime_ETL.dbo.Feeds
--		LVMPD_Crime_ETL.dbo.Files
--		LVMPD_Crime_ETL.dbo.Fields
--=============================================================================

-- Setup local variables
DECLARE @log_message VARCHAR(MAX)
DECLARE @ProjectName VARCHAR(100)
DECLARE @TableName VARCHAR(255)
DECLARE @SQL VARCHAR(MAX)
DECLARE @DEBUG BIT

SET @ProjectName = 'LVMPD_Crime' --++
SET @DEBUG = 0	--++

--=============================================================================
-- Start message for setting up the ETL metadata tables for this project
--=============================================================================
SET @log_message = '*** Starting the ETL metadata table setup process at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

--=============================================================================
-- An ETL metadata table to hold all the different feeds that will need to be loaded
--=============================================================================
SET @TableName = @ProjectName + '_ETL.dbo.Feeds'

SET @log_message = 'Creating the ETL metadata table: ' + @TableName+ '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
SET @SQL = '
	IF OBJECT_ID( ''' + @TableName + ''' ) IS NOT NULL
		DROP TABLE ' + @TableName + '
	CREATE TABLE ' + @TableName + '
	(
		feedID INT IDENTITY( 1, 1 )
		, feedName VARCHAR(100)
		, feedNameSQL VARCHAR(100)
		, feedDescription VARCHAR(1000)
		, feedDataFolder VARCHAR(1000)
		, feedDataFileConvention VARCHAR(1000)
		, externalID VARCHAR(100)
		, externalIDDescription VARCHAR(1000)
		, activateDT DATETIME
		, deActivateDT DATETIME
		, activeFlag BIT
		, ffTableCreated BIT
		, geometryTypes VARCHAR(100)
	)
'
IF @DEBUG = 1
	PRINT @SQL
ELSE
	EXEC( @SQL )

--=============================================================================
-- An ETL metadata table that will hold all the files that will and have been loaded
--=============================================================================
SET @TableName = @ProjectName + '_ETL.dbo.Files'

SET @log_message = 'Creating the ETL metadata table: ' + @TableName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
SET @SQL = '
	IF OBJECT_ID( ''' + @TableName + ''' ) IS NOT NULL
		DROP TABLE ' + @TableName + '
	CREATE TABLE ' + @TableName + '
	(
		fileID INT IDENTITY( 1, 1 )
		, fileName VARCHAR(255)
		, fileLocation VARCHAR(1000)
		, fileDescription VARCHAR(1000)
		, fileDate DATETIME
		, fileSize INT
		, feedID INT
		, insertDT DATETIME
		, loadDT DATETIME
		, loadLocation VARCHAR(1000)
		, loadedRecords INT
		, activeFlag BIT
		, ffInserted BIT
		, stagingDropped BIT
		, geoJSONFlag BIT
	)
'
IF @DEBUG = 1
	PRINT @SQL
ELSE
	EXEC( @SQL )
	
--=============================================================================
-- An ETL metadata table to hold all the fields/columns that have been loaded.
--=============================================================================
SET @TableName = @ProjectName + '_ETL.dbo.Fields'

SET @log_message = 'Creating the ETL metadata table: ' + @TableName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
SET @SQL = '
	IF OBJECT_ID( ''' + @TableName + ''' ) IS NOT NULL
		DROP TABLE ' + @TableName + '
	CREATE TABLE ' + @TableName + '
	(
		fieldID INT IDENTITY( 1, 1 )
		, fieldName VARCHAR(255)
		, fieldNameSrc VARCHAR(255)
		, fieldAlias VARCHAR(255)
		, fieldDataType VARCHAR(255)
		, fieldNullable BIT
		, fieldDescription VARCHAR(1000)
		, fieldTransform VARCHAR(1000)
		, feedID INT
		, fieldOrdinalPosition SMALLINT
		, fieldSrc VARCHAR(25)
		, insertDT DATETIME
		, activeFlag BIT
		, pkFlag BIT
		, coordField BIT
	)
'
IF @DEBUG = 1
	PRINT @SQL
ELSE
	EXEC( @SQL )

--=============================================================================
-- Finish message for setting up the ETL metadata tables for this project
--=============================================================================
SET @log_message = '*** Finished the ETL metadata table setup process at: ' + CONVERT( VARCHAR, GETDATE(), 113 )
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
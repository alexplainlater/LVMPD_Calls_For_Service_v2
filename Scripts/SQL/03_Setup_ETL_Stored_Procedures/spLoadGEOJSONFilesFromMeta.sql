USE LVMPD_Crime_ETL

GO

CREATE PROCEDURE [dbo].[spLoadGEOJSONFilesFromMeta]
	@Project VARCHAR(255)
	, @FeedName VARCHAR(100)
	, @DEBUG BIT
AS
BEGIN
	SET NOCOUNT ON

	/******************************************************************************
		Script to dynamically create and execute the loading statements for all 
			LVMPD Calls For Service Daily - GeoJSON 
		files that have yet to be loaded and are active using metadata from 
		the ETL Feeds and ETL Files metadata tables.

	******************************************************************************/

	DECLARE @FileName VARCHAR(1000) = ''
	DECLARE @FileFolder VARCHAR(1000) = ''
	DECLARE @FileID INT = 0
	DECLARE @TableName VARCHAR(255) = ''
	DECLARE @AffectedRecords INT = 0

	DECLARE @FieldName VARCHAR(255) = ''
	DECLARE @FieldNameSrc VARCHAR(255) = ''
	DECLARE @FieldOrdinalPosition SMALLINT = 0
	DECLARE @FieldSrc VARCHAR(25) = ''
	DECLARE @FieldCoord BIT = 0

	DECLARE @SQL_Update VARCHAR(MAX) = ''
	DECLARE @SQL_Begin VARCHAR(MAX) = ''
	DECLARE @SQL_Select VARCHAR(MAX) = ''
	DECLARE @SQL_With VARCHAR(MAX) = ''
	DECLARE @SQL_Middle VARCHAR(MAX) = ''
	DECLARE @SQL_End VARCHAR(MAX) = ''
	DECLARE @SQL_Total VARCHAR(MAX) = ''
	
	DECLARE @log_message VARCHAR(MAX) = ''

	DECLARE file_cursor CURSOR FOR
		--Cycle through all files that are active, for this feed, and not yet loaded
		SELECT
			f.fileName
			, f.fileLocation
			, f.fileID
		FROM LVMPD_Crime_ETL.dbo.Files f
		INNER JOIN LVMPD_Crime_ETL.dbo.Feeds fd
			ON f.feedID = fd.feedID
		WHERE fd.feedName = @feedName
			AND f.activeFlag = 1
			AND fd.activeFlag = 1
			AND f.loadDT IS NULL
			AND f.geoJSONFlag = 1
		ORDER BY fileID
	
	OPEN file_cursor

	FETCH NEXT FROM file_cursor
	INTO @FileName, @FileFolder, @FileID

	WHILE @@FETCH_STATUS = 0
	BEGIN -- file cursor
		SET @TableName = REPLACE( REPLACE( @FileName, ' ', '' ), '.', '_' )
	
		SET @log_message = 'Running with fileID: ' + CONVERT( VARCHAR, @FileID ) + ', fileLocation: ' + @FileFolder + ', fileName: ' + @FileName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + ''
			RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
		--============================================================================
		-- Create the beginning of the SQL statement we are generating
		--============================================================================
		SET @SQL_Begin = '
		DECLARE @jsonData NVARCHAR(MAX)	
		SELECT @jsonData = BulkColumn
		FROM OPENROWSET(BULK ''' + @FileFolder + @FileName + ''', SINGLE_CLOB) AS jsonFile

		DECLARE @CRS VARCHAR(50)
		SELECT @CRS = crs
		FROM OPENJSON( @jsonData, ''$.crs'' )
		WITH
		(
			CRS VARCHAR(50) ''$.properties.name''
		)

		IF OBJECT_ID( ''' + @Project + '_Staging.dbo.[' + @TableName + ']'' ) IS NOT NULL
			DROP TABLE ' + @Project + '_Staging.dbo.[' + @TableName + ']
	'
		--============================================================================
		-- Create the middle of the SQL statement we are generating with the INTO and 
		-- FROM statements
		--============================================================================
		SET @SQL_Middle = '
		INTO ' + @Project + '_Staging.dbo.[' + @TableName + ']
		FROM OPENJSON( @jsonData, ''$.features'' )
		WITH 
		('
	
		DECLARE fieldCursor CURSOR FOR
			--============================================================================
			-- Cycle through the fields in the file/table
			--============================================================================
			SELECT
				fl.fieldName
				, fl.fieldNameSrc
				, fl.fieldOrdinalPosition
				, fl.fieldSrc
				, fl.coordField
			FROM LVMPD_Crime_ETL.dbo.Fields fl
			INNER JOIN LVMPD_Crime_ETL.dbo.Feeds fd
				ON fl.feedID = fd.feedID
			WHERE fd.feedName = @feedName
				AND fl.activeFlag = 1
				AND fd.activeFlag = 1
				AND fl.fieldName <> 'Geom' -- will handle this in the FF step
				AND fl.fieldOrdinalPosition <> 1
			ORDER BY fl.fieldOrdinalPosition
		
		OPEN fieldCursor

		FETCH NEXT FROM fieldCursor
		INTO @FieldName, @FieldNameSrc, @FieldOrdinalPosition, @FieldSrc, @FieldCoord

		--============================================================================
		-- Add the first field to the select statement
		--============================================================================
		SET @SQL_Select = '
		SELECT
			etl_file_key = CONVERT( INT, ' + CONVERT( VARCHAR, @FileID ) + ' )
			'
	
		--============================================================================
		-- No with needed on the ETL file key and etl xid as it is generated internally 
		-- and not found in the file
		--============================================================================
		SET @SQL_With = ''

		WHILE @@FETCH_STATUS = 0
		BEGIN -- field cursor
			-- add the field to the select piece of the statement
			SET @SQL_Select = @SQL_Select + '
			, ' + @FieldName + ' = ' + CASE WHEN @FieldSrc = 'Calculated' THEN @FieldNameSrc ELSE @FieldName END
		
			-- determine whether the field should be added in the with section
			SET @SQL_With = CASE 
				WHEN @FieldSrc = 'Source' THEN 	
					@SQL_With + 
					CASE WHEN @fieldOrdinalPosition = 3 THEN '
			' 
					ELSE
					'
			, ' 
					END + @FieldName + CASE WHEN @FieldCoord = 1 THEN ' NVARCHAR(MAX) ''$.' + COALESCE( NULLIF( @FieldNameSrc, '' ), @FieldName ) + ''' AS JSON' ELSE ' VARCHAR(MAX) ''$.' + COALESCE( NULLIF( @FieldNameSrc, '' ), @FieldName ) + '''' END
				ELSE 
					@SQL_With + ''
				END

			FETCH NEXT FROM fieldCursor
			INTO @FieldName, @FieldNameSrc, @FieldOrdinalPosition, @FieldSrc, @FieldCoord
		END -- field cursor

		CLOSE fieldCursor

		DEALLOCATE fieldCursor

		SET @SQL_End = '
	)'
		
		--============================================================================
		-- Concatenate all the SQL pieces together into one statement
		--============================================================================
		SET @SQL_Total = @SQL_Begin + @SQL_Select + @SQL_Middle + @SQL_With + @SQL_End

		IF @DEBUG = 1
		BEGIN
			PRINT '******* Show Begin Statement *******'
			PRINT @SQL_Begin 
			PRINT '******* Show Select Statement *******'
			PRINT @SQL_Select
			PRINT '******* Show Middle Statement *******'
			PRINT @SQL_Middle
			PRINT '******* Show With Statement *******'
			PRINT @SQL_With
			PRINT '******* Show End Statement *******'
			PRINT @SQL_End
			PRINT '******* Show Total Statement *******'
			PRINT @SQL_Total
		END
		ELSE
		BEGIN
			EXEC( @SQL_Total )
			SET @AffectedRecords = @@ROWCOUNT
		END

		SET @log_message = 'Finished creating ' + @Project + '_Staging.dbo.[' + @TableName + '] at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + '. Updating ETL metadata with affected recods: ' + CONVERT( VARCHAR, @AffectedRecords ) + ''
			RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

		--============================================================================
		-- Updates the Files metadata to include the loaded location and the number
		-- of records loaded
		-- **** Need to update so this only runs if this doesn't fail ***
		--============================================================================
		SET @SQL_Update = '
			UPDATE a
			SET loadDT = GETDATE()
				, loadLocation = ''' + @Project + '_Staging.dbo.[' + @TableName + ']''
				, loadedRecords = ' +  CONVERT( VARCHAR, @AffectedRecords ) + '
			FROM ' + @Project + '_ETL.dbo.Files a
			WHERE a.fileID = ' + CONVERT( VARCHAR, @FileID ) + '
		'
		IF @DEBUG = 1
		BEGIN
			PRINT '******* Show Update Statement *******'
			PRINT @SQL_Update
		END
		ELSE
			EXEC( @SQL_Update )

		FETCH NEXT FROM file_cursor
		INTO @FileName, @FileFolder, @FileID 
	END -- file_cursor

	CLOSE file_cursor

	DEALLOCATE file_cursor

END
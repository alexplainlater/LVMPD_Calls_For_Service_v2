DECLARE @FeedID INT
DECLARE @FeedName VARCHAR(255)
DECLARE @FeedFFTable VARCHAR(255)

DECLARE @FileID INT
DECLARE @FileStagingTable VARCHAR(255)
DECLARE @FileRecords INT

DECLARE @SQL VARCHAR(MAX)
DECLARE @SQLCounts NVARCHAR(MAX)
DECLARE @log_message VARCHAR(MAX)
DECLARE @DEBUG BIT = 0


SET @log_message = '*** Started the process to insert all records into their respective FF tables.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + ''
	RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
--=============================================================================
-- Cycle through each active feed
--=============================================================================
DECLARE feedCursor CURSOR FOR
	SELECT
		feedID
		, feedName
		, FeedFFTable = 'LVMPD_Crime_FF.dbo.' + feedNameSQL
	FROM LVMPD_Crime_ETL.dbo.Feeds
	WHERE activeFlag = 1
	ORDER BY feedID
	
OPEN feedCursor

FETCH NEXT FROM feedCursor
INTO @FeedID, @FeedName, @FeedFFTable

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @log_message = 'Beginning to process the ' + @FeedName + '(' + CONVERT( VARCHAR, @feedID ) + ') feed.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + ''
		RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
	
	--=============================================================================
	-- Cycle through each active file in the feed, looking for files that have been
	-- loaded into staging and have not already been flagged as being inserted into 
	-- their FF tables.
	--=============================================================================
	DECLARE fileCursor CURSOR FOR
		SELECT
			fileID
			, loadLocation
			, loadedRecords
		FROM LVMPD_Crime_ETL.dbo.Files
		WHERE loadDT IS NOT NULL
			AND ffInserted = 0
			AND activeFlag = 1
			AND feedID = @FeedID

	OPEN fileCursor

	FETCH NEXT FROM fileCursor
	INTO @FileID, @FileStagingTable, @FileRecords

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @log_message = 'Processing file ID: ' + CONVERT( VARCHAR, @FileID ) + ' from staging table: ' + @FileStagingTable + '.  Looking to insert: ' + CONVERT( VARCHAR, @FileRecords ) + ' records.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + ''
			RAISERROR( @log_message, 0, 1 ) WITH NOWAIT

		DECLARE @BeginCount INT
		DECLARE @EndCount INT
		
		--Beginning Count
		SET @SQLCounts = 'SELECT @BeginCountOUT = COUNT(*) FROM ' + @FeedFFTable
		EXECUTE sp_executesql
			@SQLCounts
			, N'@BeginCountOUT INT OUTPUT'
			, @BeginCountOUT = @BeginCount OUTPUT
		
		--=============================================================================
		-- Build the SQL statement to insert the staging table records into the FF table
		--=============================================================================
		-- Grab all the column names.  Add the etl keys and the geom field we're going to generate
		DECLARE @Columns VARCHAR(MAX) = ''

		SELECT
			@Columns = @Columns + STRING_AGG( b.fieldName, ', ' ) WITHIN GROUP( ORDER BY fieldOrdinalPosition ASC )
		FROM LVMPD_Crime_ETL.dbo.Files a
		INNER JOIN LVMPD_Crime_ETL.dbo.Fields b
			ON a.feedID = b.feedID
		WHERE a.fileID = @FileID
			AND b.activeFlag = 1

		-- Grab all the field transform statements
		DECLARE @SelectFields VARCHAR(MAX) = ''
	
		SELECT
			@SelectFields = @SelectFields + STRING_AGG( fieldName + ' = CONVERT( ' + fieldDataType + ', ' + fieldTransform + ' )', ',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9) + CHAR(9) ) WITHIN GROUP( ORDER BY fieldOrdinalPosition ASC )
		FROM LVMPD_Crime_ETL.dbo.Files a
		INNER JOIN LVMPD_Crime_ETL.dbo.Fields b
			ON a.feedID = b.feedID
		WHERE a.fileID = @FileID
			AND b.activeFlag = 1

		--=============================================================================
		-- Build the entire SQL statement.  Adding criteria needed to process the JSON 
		-- coordinates into a well known text string to create the geometry value
		--=============================================================================
		SET @SQL = '
			INSERT INTO ' + @FeedFFTable + ' WITH( TABLOCK )
			(
				' + @Columns + '
			)
			SELECT
				' + @SelectFields + '
			FROM ' + @FileStagingTable + ' a
			OUTER APPLY 
			(
				SELECT 
					WktString = CASE
									-- Process as a POINT
									WHEN a.GeometryType = ''Point'' THEN 
										''POINT ('' + REPLACE( TRIM( ''[]'' FROM a.GeometryCoordinates ), '','', '' '' ) + '')''
									-- Process as MULTIPOLYGON if the type is ''MultiPolygon'' or if it''s a ''Polygon'' with a MultiPolygon structure.
									WHEN a.GeometryType = ''MultiPolygon'' OR ( a.GeometryType = ''Polygon'' AND LEFT( TRIM( a.GeometryCoordinates ), 4 ) = ''[[[['' ) THEN
									(
										SELECT 
											CONCAT( ''MULTIPOLYGON ('', STRING_AGG( CONVERT( NVARCHAR(MAX), CONCAT( ''('', PolygonRings, '')'' ) ), '', '' ) WITHIN GROUP( ORDER BY CONVERT( INT, PolygonKey ) ASC ), '')'' )
										FROM 
										(
											-- Aggregate points into rings for each polygon
											SELECT
												PolygonKey
												, PolygonRings = STRING_AGG( CONVERT( NVARCHAR(MAX), CONCAT( ''('', RingPoints, '')'' ) ), '', '' ) WITHIN GROUP( ORDER BY CONVERT( INT, RingKey ) ASC )
											FROM 
											(
												-- Shred JSON to individual points and format them
												SELECT
													PolygonKey = Polygons.[key]
													, RingKey = Rings.[key]
													, RingPoints = STRING_AGG( CONVERT( NVARCHAR(MAX), CONCAT( JSON_VALUE( Points.value, ''$[0]'' ), '' '', JSON_VALUE( Points.value, ''$[1]'' ) ) ), '', '' ) WITHIN GROUP( ORDER BY CONVERT( INT, Points.[key] ) ASC )
												FROM OPENJSON( a.GeometryCoordinates, ''$'') Polygons
												CROSS APPLY OPENJSON(Polygons.value) Rings
												CROSS APPLY OPENJSON(Rings.value) Points
												GROUP BY 
													Polygons.[key]
													, Rings.[key]
											) RingsData
											GROUP BY 
												PolygonKey
										) PolygonsData
									)
									-- Process as a standard POLYGON
									ELSE
									(
										SELECT 
											CONCAT( ''POLYGON ('', STRING_AGG( CONVERT( NVARCHAR(MAX), CONCAT( ''('', RingPoints, '')'' ) ), '', '' ) WITHIN GROUP( ORDER BY CONVERT( INT, RingKey ) ASC ), '')'' )
										FROM 
										(
											-- Aggregate points into rings
											SELECT
												RingKey = Rings.[key]
												, RingPoints = STRING_AGG(CONVERT(NVARCHAR(MAX), CONCAT(JSON_VALUE(Points.value, ''$[0]''), '' '', JSON_VALUE(Points.value, ''$[1]''))), '', '') WITHIN GROUP (ORDER BY CONVERT(INT, Points.[key]) ASC)
											FROM OPENJSON( a.GeometryCoordinates, ''$'' ) Rings
											CROSS APPLY OPENJSON( Rings.value ) Points
											GROUP BY 
												Rings.[key]
										) RingsData
									)
								END
			) b'

		--PRINT @SQL
		EXEC( @SQL )

		--Ending Count
		SET @SQLCounts = 'SELECT @EndCountOUT = COUNT(*) FROM ' + @FeedFFTable
		EXECUTE sp_executesql
			@SQLCounts
			, N'@EndCountOUT INT OUTPUT'
			, @EndCountOUT = @EndCount OUTPUT

		--=============================================================================
		-- Ensure the number of records inserted is what we expected
		--=============================================================================
		SET @log_message = 'Confirming Insertion: BEGIN Count: ' + CONVERT( VARCHAR, @BeginCount ) + ' END Count: ' + CONVERT( VARCHAR, @EndCount ) + ' Difference: ' + CONVERT( VARCHAR, @EndCount - @BeginCount ) + ' ETL Record Count: ' + CONVERT( VARCHAR, @FileRecords ) + '.'
			RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
		IF ( @EndCount - @BeginCount ) = @FileRecords
		BEGIN
			SET @log_message = 'File count matches inserted count. Updating ffInserted flag in LVMPD_Crime_ETL.dbo.Files.'
				RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
			--=============================================================================
			-- if the number of records is what we expected, update the FF inserted flag to 1
			-- *** should have some sort of rollback and fail if it's not what we expected ***
			--=============================================================================
			UPDATE a
			SET ffInserted = 1
			FROM LVMPD_Crime_ETL.dbo.Files a
			WHERE fileID = @FileID
		END

		FETCH NEXT FROM fileCursor
		INTO @FileID, @FileStagingTable, @FileRecords
	END

	CLOSE fileCursor

	DEALLOCATE fileCursor

	FETCH NEXT FROM feedCursor
	INTO @FeedID, @FeedName, @FeedFFTable
END

CLOSE feedCursor

DEALLOCATE feedCursor
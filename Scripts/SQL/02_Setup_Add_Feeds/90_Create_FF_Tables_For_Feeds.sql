--=============================================================================
-- Script that generates the FF tables for all the feeds in the feed metadata
-- table using all the fields in the field metadat table.  
--=============================================================================
DECLARE @SQL VARCHAR(MAX)
DECLARE @log_message VARCHAR(MAX)
DECLARE @TableToCreate VARCHAR(255)
DECLARE @ColumnDefinitions VARCHAR(MAX)
DECLARE @Feed VARCHAR(255)
DECLARE @FeedSQL VARCHAR(255)
DECLARE @FeedID INT
DECLARE @DEBUG BIT

SET @DEBUG = 0

DECLARE feed_cursor CURSOR FOR
	SELECT
		feedName, feedNameSQL, feedID
	FROM LVMPD_Crime_ETL.dbo.Feeds
	WHERE activeFlag = 1
		AND ISNULL( ffTableCreated, 0 ) <> 1

OPEN feed_cursor

FETCH NEXT FROM feed_cursor
INTO @Feed, @FeedSQL, @FeedID

WHILE @@FETCH_STATUS = 0
BEGIN -- feed cursor
	SELECT		
		@ColumnDefinitions = STRING_AGG( fieldName + ' ' + fieldDataType + CASE WHEN fieldNullable = 0 THEN ' NOT NULL' ELSE ' NULL' END, ',' + CHAR(13) + CHAR(10) + CHAR(9) ) WITHIN GROUP( ORDER BY fieldOrdinalPosition ASC )
	FROM LVMPD_Crime_ETL.dbo.Fields a
	WHERE a.feedID = @FeedID

	SET @TableToCreate = 'LVMPD_Crime_FF.dbo.' + @FeedSQL
	
	SET @log_message = 'Creating the table: ' + @TableToCreate + ' for the feed: ' + @Feed + '.'
		RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
	SET @SQL = '
IF OBJECT_ID( ''' + @TableToCreate + ''' ) IS NOT NULL
	DROP TABLE ' + @TableToCreate + '
CREATE TABLE ' + @TableToCreate + '
(
	' + @ColumnDefinitions + '
)'
	IF @DEBUG = 1
		PRINT @SQL
	ELSE
	BEGIN
		EXEC( @SQL )

		SET @log_message = 'Updating the Feeds metadata table to flag that the FF table has been created for ' + @Feed + '(' + CONVERT( VARCHAR, @FeedID ) + ').'
			RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
		UPDATE a
		SET ffTableCreated = 1
		FROM LVMPD_Crime_ETL.dbo.Feeds a
		WHERE feedID = @FeedID
	END
	
	FETCH NEXT FROM feed_cursor
	INTO @Feed, @FeedSQL, @FeedID
END

CLOSE feed_cursor

DEALLOCATE feed_cursor

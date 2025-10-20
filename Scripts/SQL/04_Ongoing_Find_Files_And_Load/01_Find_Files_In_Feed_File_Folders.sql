DECLARE @FeedID INT
DECLARE @FeedName VARCHAR(255)
DECLARE @log_message VARCHAR(MAX)

DECLARE feedCursor CURSOR FOR
	SELECT
		feedID
		, feedName
	FROM LVMPD_Crime_ETL.dbo.Feeds
	WHERE activeFlag = 1
	ORDER BY feedID
	
OPEN feedCursor

FETCH NEXT FROM feedCursor
INTO @FeedID, @FeedName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @log_message = 'Updating Files feed for Feed ID: ' + CONVERT( VARCHAR, @FeedID ) + ' and Feed Name: ' + @FeedName + '.  Started at: ' + CONVERT( VARCHAR, GETDATE(), 113 ) + ''
		RAISERROR( @log_message, 0, 1 ) WITH NOWAIT
	EXEC LVMPD_Crime_ETL.dbo.spFindNewFilesForFeed
		@FeedNum = @FeedID

	FETCH NEXT FROM feedCursor
	INTO @FeedID, @FeedName
END

CLOSE feedCursor

DEALLOCATE feedCursor
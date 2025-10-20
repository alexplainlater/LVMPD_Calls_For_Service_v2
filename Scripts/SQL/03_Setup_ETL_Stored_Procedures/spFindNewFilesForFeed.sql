USE LVMPD_Crime_ETL

GO

CREATE PROCEDURE spFindNewFilesForFeed 
	@FeedNum INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @FeedDataFolder VARCHAR(MAX)
	DECLARE @FeedDataFileConvention VARCHAR(MAX)
	DECLARE @DirectoryStatement VARCHAR(MAX)

	SELECT 
		@FeedDataFolder = feedDataFolder
		, @FeedDataFileConvention = feedDataFileConvention
	FROM LVMPD_Crime_ETL.dbo.Feeds
	WHERE feedID = @FeedNum
		AND activeFlag = 1

	IF OBJECT_ID( 'tempdb..#CmdOutput' ) IS NOT NULL
		DROP TABLE #CmdOutput
	CREATE TABLE #CmdOutput 
	(
		lineNum INT IDENTITY( 1, 1 )
		, OutputLine NVARCHAR(4000)
	)

	--=============================================================================
	-- Runs dir command in the command shell
	-- /a:-d	=>  remove directories from the list of files and folders displayed
	-- /o:dn	=>	sort order (by date/time, oldest first, then alphabetically by name)
	-- /t:w		=>	time field (w = last written)
	-- /-c		=>	remove the thousands separator in file sizes
	-- /x		=>	adds additional space before file name so we can search for multiple spaces when parsing
	-- https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/dir
	--=============================================================================
	SET @DirectoryStatement = N'EXEC xp_cmdshell ''dir /a:-d/o:dn/t:w/-c/x "' + @FeedDataFolder + @FeedDataFileConvention + '"'''

	INSERT INTO #CmdOutput (OutputLine)
	EXEC( @DirectoryStatement )

	--SELECT * FROM #CmdOutput

	INSERT INTO LVMPD_Crime_ETL.dbo.Files
	(
		fileName
		, fileLocation
		, fileDescription
		, fileDate
		, fileSize
		, feedID
		, insertDT
		, activeFlag
		, ffInserted
		, stagingDropped
		, geoJSONFlag
	)
	SELECT
		fileName = RIGHT( a.OutputLine, CHARINDEX( '   ', REVERSE( a.OutputLine ) ) - 1 )
		, fileLocation = @FeedDataFolder
		, fileDescription = ''
		, fileDate = CONVERT( DATETIME, LEFT( a.OutputLine, 20 ) )
		, fileSize = CONVERT( INT,	
			REPLACE(
				SUBSTRING( 
						a.OutputLine
						, 20 + PATINDEX( '%[^ ]%', SUBSTRING( a.OutputLine, 21, LEN( a.OutputLine ) ) ) -- look for not a space after date/time
						, PATINDEX( '%[ ]%', SUBSTRING( a.OutputLine, 21 + PATINDEX( '%[^ ]%', SUBSTRING( a.OutputLine, 21, LEN( a.OutputLine ) ) ), LEN( a.OutputLine ) ) ) -- look for space after not a space
					)
				, ','
				, ''
			)
		)
		, feedID = @FeedNum
		, insertDT = GETDATE()
		, activeFlag = 1
		, ffInserted = 0
		, stagingDropped = 0
		, geoJSONFlag = CASE WHEN RIGHT( RIGHT( a.OutputLine, CHARINDEX( '   ', REVERSE( a.OutputLine ) ) - 1 ), 8 ) = '.geojson' THEN 1 ELSE 0 END -- are the last 8 characters of the file name = '.geojson'
	FROM #CmdOutput a
	LEFT JOIN LVMPD_Crime_ETL.dbo.Files f
		ON RIGHT( a.OutputLine, CHARINDEX( '   ', REVERSE( a.OutputLine ) ) - 1 ) = f.fileName
		AND @FeedDataFolder = f.fileLocation
	WHERE a.lineNum > 5
		AND a.lineNum <= ( SELECT COUNT(*) FROM #CmdOutput ) - 3
		AND f.fileID IS NULL


	SELECT * FROM LVMPD_Crime_ETL.dbo.Files
END


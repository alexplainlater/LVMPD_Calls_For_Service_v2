DECLARE @FeedName VARCHAR(100)
DECLARE @FeedNameSQL VARCHAR(100)

SET @FeedName = 'LVMPD Calls For Service Last 30 Days - GeoJSON'
SET @FeedNameSQL = 'LVMPD_Calls_For_Service_Last_30_Days'

--=============================================================================
-- Add an entry in the feed table for the Last 30 Days Calls For Service historical file
--=============================================================================
INSERT INTO LVMPD_Crime_ETL.dbo.Feeds( feedName, feedNameSQL, feedDescription, feedDataFolder, feedDataFileConvention, externalID, externalIDDescription, activateDT, deActivateDT, activeFlag, ffTableCreated, geometryTypes )
SELECT
	feedName = @FeedName
	, feedNameSQL = @FeedNameSQL
	, feedDescription = 'GeoJSON files for LVMPD Calls for Service for 30 Day windows'
	, feedDataFolder = 'Z:\Las_Vegas_Crime\Data\LVMPD\LVMPD_Calls_For_Service\FileTypes\GeoJSON\Historical\Last_30_Days\'
	, feedDataFileConvention = 'LVMPD_Calls_For_Service_30_Days_*.geojson'
	, externalID = '6a371d1a491a4a0794578b031859c768'
	, externalIDDescription = 'ArcGIS Online Item ID of the Feature Service'
	, activateDT = GETDATE()
	, deActivateDT = NULL
	, activeFlag = 1
	, ffTableCreated = 0
	, geometryTypes = 'Point'

--=============================================================================
-- Add the fields of the feed into the Fields metadata table

-- Here is the documentation from the source:
-- Last 30 Days: https://services.arcgis.com/jjSk6t82vIntwDbs/arcgis/rest/services/LVMPD_Calls_For_Service_30_Days/FeatureServer/0
--OBJECTID (type: esriFieldTypeOID, alias: OBJECTID, SQL Type: sqlTypeOther, length: 0, nullable: false, editable: false)
--IncidentNumber (type: esriFieldTypeString, alias: Incident Number, SQL Type: sqlTypeOther, length: 20, nullable: true, editable: true)
--IncidentDate (type: esriFieldTypeDate, alias: Incident Date, SQL Type: sqlTypeOther, length: 8, nullable: true, editable: true)
--Classification (type: esriFieldTypeString, alias: Classification, SQL Type: sqlTypeOther, length: 40, nullable: true, editable: true)
--IncidentTypeCode (type: esriFieldTypeString, alias: Incident Type Code, SQL Type: sqlTypeOther, length: 20, nullable: true, editable: true)
--IncidentTypeDescription (type: esriFieldTypeString, alias: Incident Type Description, SQL Type: sqlTypeOther, length: 60, nullable: true, editable: true)
--Address (type: esriFieldTypeString, alias: Address, SQL Type: sqlTypeOther, length: 100, nullable: true, editable: true)
--Disposition (type: esriFieldTypeString, alias: Disposition, SQL Type: sqlTypeOther, length: 10, nullable: true, editable: true)
--Latitude (type: esriFieldTypeDouble, alias: Latitude, SQL Type: sqlTypeOther, nullable: true, editable: true)
--Longitude (type: esriFieldTypeDouble, alias: Longitude, SQL Type: sqlTypeOther, nullable: true, editable: true)
--Weekday (type: esriFieldTypeString, alias: Weekday, SQL Type: sqlTypeOther, length: 12, nullable: true, editable: true)
--Hour (type: esriFieldTypeInteger, alias: Hour, SQL Type: sqlTypeOther, nullable: true, editable: true)
--Month (type: esriFieldTypeInteger, alias: Month, SQL Type: sqlTypeOther, nullable: true, editable: true)
--Day (type: esriFieldTypeInteger, alias: Day, SQL Type: sqlTypeOther, nullable: true, editable: true)
--Year (type: esriFieldTypeInteger, alias: Year, SQL Type: sqlTypeOther, nullable: true, editable: true)
--ZipCode (type: esriFieldTypeString, alias: Zip Code, SQL Type: sqlTypeOther, length: 5, nullable: true, editable: true)
--UpdatedDate (type: esriFieldTypeDate, alias: Updated Date, SQL Type: sqlTypeOther, length: 8, nullable: true, editable: true)

INSERT INTO LVMPD_Crime_ETL.dbo.Fields( fieldName, fieldNameSrc, fieldAlias, fieldDatatype, fieldNullable, fieldDescription, fieldTransform, feedID, fieldOrdinalPosition, fieldSrc, insertDT, activeFlag, pkFlag, coordField )
SELECT
	fieldName = 'etl_file_key'
	, fieldNameSrc = 'CONVERT( INT, '' + CONVERT( VARCHAR, @FileID ) + '' )'
	, fieldAlias = 'ETL File Key'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'ETL metadata for the key that ties to the file'
	, fieldTransform = 'etl_file_key'
	, feedID = f.feedID
	, fieldOrdinalPosition = 1
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'etl_file_xid'
	, fieldNameSrc = 'IDENTITY( INT, 1, 1 )'
	, fieldAlias = 'ETL File XID'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'ETL metadata for the key that ties to the individual record'
	, fieldTransform = 'etl_file_xid'
	, feedID = f.feedID
	, fieldOrdinalPosition = 2
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'OBJECTID'
	, fieldNameSrc = 'properties.OBJECTID'
	, fieldAlias = 'OBJECTID'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'Source identity ID of record'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( OBJECTID ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 3
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'IncidentNumber'
	, fieldNameSrc = 'properties.IncidentNumber'
	, fieldAlias = 'Incident Number'
	, fieldDataType = 'VARCHAR(20)' -- Documentation says 200 length, but I can see it's smaller
	, fieldNullable = 1
	, fieldDescription = 'Source identity ID of record'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( IncidentNumber ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 4
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'IncidentDate'
	, fieldNameSrc = 'properties.IncidentDate'
	, fieldAlias = 'Incident Date'
	, fieldDataType = 'DATETIMEOFFSET(0)'
	, fieldNullable = 1
	, fieldDescription = 'Date the incident occurred in UTC time'
	, fieldTransform = 'CONVERT( DATETIME, SUBSTRING( IncidentDate, 6, LEN( IncidentDate ) - 9 ), 113 ) AT TIME ZONE ''UTC'''
	, feedID = f.feedID
	, fieldOrdinalPosition = 5
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Classification'
	, fieldNameSrc = 'properties.Classification'
	, fieldAlias = 'Classification'
	, fieldDataType = 'VARCHAR(40)'
	, fieldNullable = 1
	, fieldDescription = 'Overall classification of incident type'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Classification ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 6
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'IncidentTypeCode'
	, fieldNameSrc = 'properties.IncidentTypeCode'
	, fieldAlias = 'Incident Type Code'
	, fieldDataType = 'VARCHAR(10)' -- Documentation says length of 20, but I can see it's smaller
	, fieldNullable = 1
	, fieldDescription = 'Code for the type of incident that occurred'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( IncidentTypeCode ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 7
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'IncidentTypeDescription'
	, fieldNameSrc = 'properties.IncidentTypeDescription'
	, fieldAlias = 'Incident Type Description'
	, fieldDataType = 'VARCHAR(50)' -- Documentation says length of 60, but I can see it's smaller
	, fieldNullable = 1
	, fieldDescription = 'Description for incident type code'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( IncidentTypeDescription ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 8
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Address'
	, fieldNameSrc = 'properties.Address'
	, fieldAlias = 'Address'
	, fieldDataType = 'VARCHAR(60)' --Documentation says length is 100 but i can see it's smaller
	, fieldNullable = 1
	, fieldDescription = 'Location of incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Address ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 9
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Disposition'
	, fieldNameSrc = 'properties.Disposition'
	, fieldAlias = 'Disposition'
	, fieldDataType = 'VARCHAR(5)' 
	, fieldNullable = 1
	, fieldDescription = 'Resolution of incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Disposition ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 10
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Latitude'
	, fieldNameSrc = 'properties.Latitude'
	, fieldAlias = 'Latitude'
	, fieldDataType = 'DECIMAL(10,8)'
	, fieldNullable = 1
	, fieldDescription = 'Latitude coordinate of incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Latitude ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 11
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Longitude'
	, fieldNameSrc = 'properties.Longitude'
	, fieldAlias = 'Longitude'
	, fieldDataType = 'DECIMAL(11,8)'
	, fieldNullable = 1
	, fieldDescription = 'Longitude coordinate of incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Longitude ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 12
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Weekday'
	, fieldNameSrc = 'properties.Weekday'
	, fieldAlias = 'Weekday'
	, fieldDataType = 'VARCHAR(10)' -- Documentation says length of 30, but I can see it's smaller
	, fieldNullable = 1
	, fieldDescription = 'Word day of the week incident occurred'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Weekday ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 13
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Hour'
	, fieldNameSrc = 'properties.Hour'
	, fieldAlias = 'Hour'
	, fieldDataType = 'TINYINT'
	, fieldNullable = 1
	, fieldDescription = 'Hour incident occurred'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Hour ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 14
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Month'
	, fieldNameSrc = 'properties.Month'
	, fieldAlias = 'Month'
	, fieldDataType = 'TINYINT'
	, fieldNullable = 1
	, fieldDescription = 'Month of the incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Month ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 15
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Day'
	, fieldNameSrc = 'properties.Day'
	, fieldAlias = 'Day'
	, fieldDataType = 'SMALLINT'
	, fieldNullable = 1
	, fieldDescription = 'Day of the year the incident occurred (1 - 366)'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Day ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 16
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Year'
	, fieldNameSrc = 'properties.Year'
	, fieldAlias = 'Year'
	, fieldDataType = 'SMALLINT'
	, fieldNullable = 1
	, fieldDescription = 'Year the incident occurred'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Year ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 17
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'ZipCode'
	, fieldNameSrc = 'properties.ZipCode'
	, fieldAlias = 'ZIP Code'
	, fieldDataType = 'CHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'ZIP code of location of incident'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( ZipCode ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 18
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'UpdatedDate'
	, fieldNameSrc = 'properties.UpdatedDate'
	, fieldAlias = 'Updated Date'
	, fieldDataType = 'DATETIMEOFFSET(0)'
	, fieldNullable = 1
	, fieldDescription = 'Last time this record was updated in the source system'
	, fieldTransform = 'CONVERT( DATETIME, SUBSTRING( UpdatedDate, 6, LEN( UpdatedDate ) - 9 ), 113 ) AT TIME ZONE ''UTC'''
	, feedID = f.feedID
	, fieldOrdinalPosition = 19
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryCRS'
	, fieldNameSrc = '@CRS'
	, fieldAlias = 'CRS'
	, fieldDataType = 'VARCHAR(10)'
	, fieldNullable = 1
	, fieldDescription = 'Coordinate Reference System for geometry coordinates'
	, fieldTransform = 'REPLACE( NULLIF( LTRIM( RTRIM( GeometryCRS ) ), '''' ), ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 20
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryType'
	, fieldNameSrc = 'geometry.type'
	, fieldAlias = 'Geometry Type'
	, fieldDataType = 'VARCHAR(20)'
	, fieldNullable = 1
	, fieldDescription = 'Type of geometry the coordinates represent'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryType ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 21
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryCoordinates'
	, fieldNameSrc = 'geometry.coordinates'
	, fieldAlias = 'Coordinates'
	, fieldDataType = 'NVARCHAR(MAX)'
	, fieldNullable = 1
	, fieldDescription = 'The coordinates for the geometry that is provided'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryCoordinates ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 22
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 1
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Geom'
	, fieldNameSrc = ''
	, fieldAlias = 'Geom'
	, fieldDataType = 'GEOMETRY'
	, fieldNullable = 1
	, fieldDescription = 'Geometry data type representation of the coordinates'
	, fieldTransform = 'GEOMETRY::STGeomFromText( b.WktString, RIGHT( REPLACE( a.GeometryCRS, ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' ), 4 ) ).MakeValid()'
	, feedID = f.feedID
	, fieldOrdinalPosition = 23
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

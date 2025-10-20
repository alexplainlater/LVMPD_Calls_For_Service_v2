DECLARE @FeedName VARCHAR(100)
DECLARE @FeedNameSQL VARCHAR(100)

SET @FeedName = 'LVMPD Area Commands - GeoJSON'
SET @FeedNameSQL = 'LVMPD_Area_Commands'

--=============================================================================
-- Add an entry in the feed table for the LVMPD Area Commands file
--=============================================================================
INSERT INTO LVMPD_Crime_ETL.dbo.Feeds( feedName, feedNameSQL, feedDescription, feedDataFolder, feedDataFileConvention, externalID, externalIDDescription, activateDT, deActivateDT, activeFlag, ffTableCreated, geometryTypes )
SELECT
	feedName = @FeedName
	, feedNameSQL = @FeedNameSQL
	, feedDescription = 'LVMPD Area Command Boundaries Effective as of 1/25/2020'
	, feedDataFolder = 'Z:\Las_Vegas_Crime\Data\LVMPD\LVMPD Area Commands\'
	, feedDataFileConvention = 'AREA_COMMANDS.geojson'
	, externalID = '0803e2a7a8e44517b6eb9aa8071df996'
	, externalIDDescription = 'ArcGIS Online Item ID of the Feature Service'
	, activateDT = GETDATE()
	, deActivateDT = NULL
	, activeFlag = 1
	, ffTableCreated = 0
	, geometryTypes = 'Polygon, Multipolygon'

--=============================================================================
-- Add the fields of the feed into the Fields metadata table

-- Here is the documentation from the source:
-- Area Commands: https://services.arcgis.com/jjSk6t82vIntwDbs/ArcGIS/rest/services/AREA_COMMANDS/FeatureServer/0
-- OBJECTID (type: esriFieldTypeOID, alias: OBJECTID, SQL Type: sqlTypeOther, length: 0, nullable: false, editable: false)
-- NAME (type: esriFieldTypeString, alias: NAME, SQL Type: sqlTypeOther, length: 4, nullable: true, editable: true)
-- AGENCY (type: esriFieldTypeString, alias: AGENCY, SQL Type: sqlTypeOther, length: 5, nullable: true, editable: true)
-- AC (type: esriFieldTypeString, alias: AC, SQL Type: sqlTypeOther, length: 4, nullable: true, editable: true)
-- Shape__Area (type: esriFieldTypeDouble, alias: Shape__Area, SQL Type: sqlTypeDouble, nullable: true, editable: false)
-- Shape__Length (type: esriFieldTypeDouble, alias: Shape__Length, SQL Type: sqlTypeDouble, nullable: true, editable: false)
-- FULLNAME (type: esriFieldTypeString, alias: FULL NAME, SQL Type: sqlTypeOther, length: 50, nullable: true, editable: true)
--=============================================================================

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
	, fieldDescription = 'Unique identifier for the record.'
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
	fieldName = 'Name'
	, fieldNameSrc = 'properties.NAME'
	, fieldAlias = 'Area Command'
	, fieldDataType = 'VARCHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'Name of the Area Command.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Name ) ), '''' )'
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
	fieldName = 'Agency'
	, fieldNameSrc = 'properties.AGENCY'
	, fieldAlias = 'Agency'
	, fieldDataType = 'VARCHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'Agency name.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Agency ) ), '''' )'
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
	fieldName = 'AreaCommandCode'
	, fieldNameSrc = 'properties.AC'
	, fieldAlias = 'Area Command Code'
	, fieldDataType = 'VARCHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'Area Command Code.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( AreaCommandCode ) ), '''' )'
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
	fieldName = 'FullName'
	, fieldNameSrc = 'properties.FULLNAME'
	, fieldAlias = 'Area Command - Full Name'
	, fieldDataType = 'VARCHAR(50)'
	, fieldNullable = 1
	, fieldDescription = 'Full name of the Area Command.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( FullName ) ), '''' )'
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
	fieldName = 'GeometryCRS'
	, fieldNameSrc = '@CRS'
	, fieldAlias = 'CRS'
	, fieldDataType = 'VARCHAR(10)'
	, fieldNullable = 1
	, fieldDescription = 'Coordinate Reference System for geometry coordinates'
	, fieldTransform = 'REPLACE( NULLIF( LTRIM( RTRIM( GeometryCRS ) ), '''' ), ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 8
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
	fieldName = 'GeometryCoordinates'
	, fieldNameSrc = 'geometry.coordinates'
	, fieldAlias = 'Coordinates'
	, fieldDataType = 'NVARCHAR(MAX)'
	, fieldNullable = 1
	, fieldDescription = 'The coordinates for the geometry that is provided'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryCoordinates ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 10
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
	, fieldOrdinalPosition = 11
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

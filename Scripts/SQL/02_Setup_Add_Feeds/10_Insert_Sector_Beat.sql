DECLARE @FeedName VARCHAR(100)
DECLARE @FeedNameSQL VARCHAR(100)

SET @FeedName = 'LVMPD Sector Beat - GeoJSON'
SET @FeedNameSQL = 'LVMPD_Sector_Beat'

--=============================================================================
-- Add an entry in the feed table for the LVMPD Sector Beat file
--=============================================================================
INSERT INTO LVMPD_Crime_ETL.dbo.Feeds( feedName, feedNameSQL, feedDescription, feedDataFolder, feedDataFileConvention, externalID, externalIDDescription, activateDT, deActivateDT, activeFlag, ffTableCreated, geometryTypes )
SELECT
	feedName = @FeedName
	, feedNameSQL = @FeedNameSQL
	, feedDescription = 'Polygon Areas of the LVMPD Beat Boundaries'
	, feedDataFolder = 'Z:\Las_Vegas_Crime\Data\LVMPD\LVMPD Sector Beat\'
	, feedDataFileConvention = 'LVMPD_Sector_Beat.geojson'
	, externalID = '48516778560747e28d69be39813157a9'
	, externalIDDescription = 'ArcGIS Online Item ID of the Feature Service'
	, activateDT = GETDATE()
	, deActivateDT = NULL
	, activeFlag = 1
	, ffTableCreated = 0
	, geometryTypes = 'Polygon, Multipolygon'

--=============================================================================
-- Add the fields of the feed into the Fields metadata table

-- Here is the documentation from the source:
-- Sector Beat: https://services.arcgis.com/jjSk6t82vIntwDbs/ArcGIS/rest/services/LVMPD_Sector_Beat/FeatureServer/0
-- OBJECTID (type: esriFieldTypeOID, alias: OBJECTID, SQL Type: sqlTypeOther, length: 0, nullable: false, editable: false)
-- BEAT (type: esriFieldTypeString, alias: BEAT, SQL Type: sqlTypeOther, length: 4, nullable: true, editable: true)
-- SECTOR (type: esriFieldTypeString, alias: SECTOR, SQL Type: sqlTypeOther, length: 4, nullable: true, editable: true)
-- ACOM (type: esriFieldTypeString, alias: ACOM, SQL Type: sqlTypeOther, length: 4, nullable: true, editable: true)
-- Shape__Area (type: esriFieldTypeDouble, alias: Shape__Area, SQL Type: sqlTypeDouble, nullable: true, editable: false)
-- Shape__Length (type: esriFieldTypeDouble, alias: Shape__Length, SQL Type: sqlTypeDouble, nullable: true, editable: false)
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
	fieldName = 'ObjectID'
	, fieldNameSrc = 'properties.OBJECTID'
	, fieldAlias = 'Object ID'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'Unique identifier for the record.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( ObjectID ) ), '''' )'
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
	fieldName = 'Beat'
	, fieldNameSrc = 'properties.BEAT'
	, fieldAlias = 'Beat'
	, fieldDataType = 'CHAR(2)'
	, fieldNullable = 1
	, fieldDescription = 'Police beat identifier.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Beat ) ), '''' )'
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
	fieldName = 'Sector'
	, fieldNameSrc = 'properties.SECTOR'
	, fieldAlias = 'Sector'
	, fieldDataType = 'CHAR(1)'
	, fieldNullable = 1
	, fieldDescription = 'Police sector identifier.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( Sector ) ), '''' )'
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
	fieldName = 'AreaCommand'
	, fieldNameSrc = 'properties.ACOM'
	, fieldAlias = 'Area Command Code'
	, fieldDataType = 'VARCHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'Area Command identifier.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( AreaCommand ) ), '''' )'
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
	fieldName = 'GeometryCRS'
	, fieldNameSrc = '@CRS'
	, fieldAlias = 'CRS'
	, fieldDataType = 'VARCHAR(10)'
	, fieldNullable = 1
	, fieldDescription = 'Coordinate Reference System for geometry coordinates'
	, fieldTransform = 'REPLACE( NULLIF( LTRIM( RTRIM( GeometryCRS ) ), '''' ), ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 7
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
	fieldName = 'GeometryCoordinates'
	, fieldNameSrc = 'geometry.coordinates'
	, fieldAlias = 'Coordinates'
	, fieldDataType = 'NVARCHAR(MAX)'
	, fieldNullable = 1
	, fieldDescription = 'The coordinates for the geometry that is provided'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryCoordinates ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 9
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
	, fieldOrdinalPosition = 10
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1
